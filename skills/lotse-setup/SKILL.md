---
name: lotse-setup
description: Add the Lotse SDK (package `lotse`) to a Flutter app — dependency, Lotse.init with the public key, LotseScope, Android manifest and App Links, signing fingerprints in the Lotse console, Firebase, and the console's setup diagnosis. Use when integrating Lotse into an app for the first time, when Lotse.instance throws "Call Lotse.init() before use", or when the console's Diagnosis page shows failures. For events, links, push and feedback in detail see lotse-events, lotse-deep-links, lotse-push and lotse-feedback.
---

# Lotse setup

Lotse gives a Flutter app deep links with attribution, analytics, feedback and push on
one event stream. Android is the primary platform; iOS works (see lotse-push) but gets
less testing. The app only ever touches `package:lotse/lotse.dart`: the class
`Lotse` and the `Lotse*` types and widgets. Never import anything from `lotse_client`
or a Serverpod package.

Do the steps in order. Each step names what the user must do in the console
(`https://console.lotse.dev`); ask them for the values instead of inventing any.

## 1. Collect from the user

| Value | Where in the console | Example |
|---|---|---|
| Public key | Setup → API keys | `lt_pk_…` |
| Server URL | — | `https://api.lotse.dev/` |
| Project handle | Growth → Links: short URLs are `https://HANDLE.lotse.dev/l/…` | `acme` → `acme.lotse.dev` |

The public key is not a secret (it ships in the app), but never put a secret key
(`lt_sk_…`) or an agent token (`lt_at_…`) into an app.

## 2. Dependency

The SDK is the package `lotse` on pub.dev:

```bash
flutter pub add lotse
```

Requirements: Dart `^3.12.2`, Flutter `>=3.44.4`. Run `flutter pub get`.

## 3. Android build settings

The SDK uses `flutter_local_notifications`, which needs core library desugaring. In
`android/app/build.gradle.kts`:

```kotlin
android {
    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
```

(Groovy `build.gradle`: `coreLibraryDesugaringEnabled true` and
`coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.1.4'`.) Without it the
Android build fails.

In `android/app/src/main/AndroidManifest.xml`, outside `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

## 4. Initialise

`Lotse.init` must complete before anything uses `Lotse.instance` (it throws a
`StateError` otherwise) and before `runApp` (replay and heatmaps read their options at
start). Await it: then `deferredLink` and `initialPush` are settled too.

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lotse/lotse.dart';

import 'firebase_options.dart'; // from `flutterfire configure`, see lotse-push

const _publicKey = String.fromEnvironment('LOTSE_PUBLIC_KEY');
const _serverUrl = String.fromEnvironment(
  'LOTSE_SERVER_URL',
  defaultValue: 'https://api.lotse.dev/',
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Lotse.captureLaunchLinks(); // before the first await, see lotse-deep-links
  if (!kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  await Lotse.init(publicKey: _publicKey, serverUrl: _serverUrl);

  final deferred = await Lotse.instance.deferredLink; // first start only
  final push = await Lotse.instance.initialPush;
  final router = buildRouter(
    initialLocation: safeLocation(push?.targetPath ?? deferred?.targetPath),
  );
  // Pushes tapped while the app runs, see lotse-push.
  Lotse.instance.pushOpened.listen(
    (push) => router.go(safeLocation(push.targetPath)),
  );
  runApp(MyApp(router: router));
}
```

`Lotse.init` signature (all other parameters are optional):

```dart
static Future<void> init({
  required String publicKey,
  required String serverUrl,
  bool allowInsecureLocalhost = false,
  bool heatmaps = false,
  LotseBackgrounds heatmapBackgrounds = LotseBackgrounds.developmentBuilds,
  LotseReplayOptions? replay,
})
```

- Calling it twice does nothing. It never throws into the app, with one exception: a
  malformed `serverUrl` throws `LotseServerUrlError` before any request.
- `serverUrl` is `https://api.lotse.dev/`. Leave `allowInsecureLocalhost` off; it is
  only for development of Lotse itself.
- Without Firebase the SDK still works, just without push. If the app does not call
  `Firebase.initializeApp` itself, `init` tries `Firebase.initializeApp()` without
  options, which only works on Android with `google-services.json`.
- `init` asks for the notification permission on its first run (Android 13+, iOS).
  If the app wants to ask later, tell the user; the SDK has no switch for it.

## 5. Wrap the app

```dart
final navigatorKey = GlobalKey<NavigatorState>();

GoRouter buildRouter({required String initialLocation}) => GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: initialLocation,
  observers: [LotseScreenObserver()],
  routes: [
    GoRoute(path: '/', name: 'home', builder: (_, _) => const HomeScreen()),
    // App routes with a `name` each, see lotse-events.
    // The short-link route, see lotse-deep-links:
    GoRoute(
      path: '/l/:slug',
      redirect: (context, state) async {
        final link = await Lotse.instance.resolveLink(
          state.pathParameters['slug']!,
        );
        return safeLocation(link?.targetPath);
      },
    ),
  ],
);

/// A link's or push's target if the app has a route for it, else home.
/// Keep the pattern in sync with the routes (see lotse-deep-links).
final _appRoute = RegExp(r'^/(|offer/[\w-]+)$');
String safeLocation(String? target) =>
    target != null && !target.startsWith('/l/') && _appRoute.hasMatch(target)
    ? target
    : '/';

class MyApp extends StatelessWidget {
  const MyApp({required this.router, super.key});

  final GoRouter router;

  @override
  Widget build(BuildContext context) => LotseScope(
    navigatorKey: navigatorKey,
    child: MaterialApp.router(
      routerConfig: router,
      builder: (context, child) => LotseInAppMessages(
        onTap: (message) => router.go(safeLocation(message.targetPath)),
        child: child!,
      ),
    ),
  );
}
```

- `LotseScope` around the whole app: feedback screenshots, replay, heatmap taps, and
  the navigator a tapped feedback-reply push opens its conversation on.
- `LotseScreenObserver` reports `screen_view` per named route.
- `LotseInAppMessages` in `builder` shows in-app messages and surveys above every route.
- Without go_router: `MaterialApp(navigatorKey: navigatorKey, navigatorObservers: [LotseScreenObserver()])`.

## 6. App Links (Android)

Inside the main `<activity>` of the manifest, with the user's handle:

```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="https" android:host="HANDLE.lotse.dev" android:pathPrefix="/l/" />
</intent-filter>
```

Flutter's built-in deep linking hands `/l/<slug>` to go_router. If the app already uses
a deep-link plugin (`app_links`, `uni_links`), keep one mechanism only.

## 7. Console: the Android app and its fingerprints

Tell the user to open **Setup → Apps → Add app → Android** and enter:

- the package name: `applicationId` from `android/app/build.gradle(.kts)`;
- SHA-256 fingerprints, one per line. Get them with `cd android && ./gradlew signingReport`
  (or `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android`).
  Add the debug key for development, the upload key, and — for Play builds — the
  **Play App Signing** key (Play Console → Test and release → App integrity).
  SHA-1 is refused.

Lotse then serves `https://HANDLE.lotse.dev/.well-known/assetlinks.json` for this app.
Fingerprints can be changed later under Apps → Edit fingerprints; Android re-verifies
only on install or update.

## 8. Verify with the diagnosis

1. Install the app on a real Android device (`flutter run`).
2. In the console create a link (Links → Create link, e.g. slug `test`, target `/`).
3. Tap `https://HANDLE.lotse.dev/l/test` on the device (from a messenger or notes app,
   not by typing it in Chrome's address bar). The app should open.
4. Open **Setup → Diagnosis** and press "Run again".

What the checks mean and how to fix them: `references/diagnosis.md`.

A healthy setup shows no failed check. Expected non-green rows:
- "Manifest of the app" is always *unknown* — the server cannot see the manifest.
  Verify on the device: `adb shell pm get-app-links <package>` must show
  `HANDLE.lotse.dev: verified`.
- "Signing certificate" warns with a single fingerprint; add the Play signing key.
- "Traffic of the last 7 days" stays *unknown* until a link was tapped on Android.

## Checklist

- [ ] `lotse` dependency resolves, desugaring enabled, app builds for Android
- [ ] `Lotse.init` awaited before `runApp`, key from `--dart-define`, `https` URL
- [ ] `LotseScope` around the app, `navigatorKey` shared with the router
- [ ] `LotseScreenObserver` on the router, every route has a `name`
- [ ] `/l/:slug` route calls `Lotse.instance.resolveLink`
- [ ] intent filter with the project's host and `autoVerify="true"`
- [ ] Android app with package name and ≥2 SHA-256 fingerprints in the console
- [ ] Diagnosis: no failed check, `pm get-app-links` says verified
- [ ] `flutter analyze` clean

Debug output: every SDK problem is a `debugPrint` starting with `Lotse:`. Filter the
log for it (`flutter logs | grep Lotse:`).
