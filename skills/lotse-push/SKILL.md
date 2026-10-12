---
name: lotse-push
description: Set up push notifications from Lotse in a Flutter app — Firebase configuration, the FCM credential in the Lotse console, the Android channel lotse_push, opening a push's target route with Lotse.instance.initialPush and pushOpened, feedback reply pushes, and the iOS/APNs status. Use when enabling Lotse campaigns or feedback replies in an app, or when pushes do not arrive or do not open the right screen. Requires lotse-setup. Campaigns themselves are sent from the console, never from app code.
---

# Lotse push

Lotse sends campaigns (console → Campaigns) and replies to feedback as push messages.
The app does not send anything and does not parse payloads: it hands Firebase to the
SDK and routes the `LotsePush` it gets back. On the device Firebase is only the
transport; Lotse's server delivers through FCM (Android, iOS) or APNs (iOS).

No push on the web: the SDK never asks a browser for permission.

## 1. Firebase in the app

```bash
dart pub global activate flutterfire_cli
flutterfire configure            # creates lib/firebase_options.dart
flutter pub add firebase_core
```

`flutterfire configure` also adds `google-services.json` and the
`com.google.gms.google-services` Gradle plugin on Android.

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }
  await Lotse.init(publicKey: _publicKey, serverUrl: _serverUrl);
  // ...
}
```

Initialise Firebase before `Lotse.init`; the SDK uses the app that is already there.
`firebase_messaging` comes with the SDK; the app only needs it as a direct dependency
if it uses Firebase messaging for its own pushes too. Lotse ignores messages that are
not its own.

`Lotse.init` then, on its own:
- creates the Android notification channel `lotse_push` (high importance, so pushes pop
  up) — do not create or rename it;
- asks for the notification permission (Android 13+ needs
  `<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>` in the
  manifest);
- reports the FCM token (and on iOS the APNs token) and keeps it current.

## 2. Credential in the console

The project **owner** uploads the Firebase service account JSON under
**Setup → Apps → the Android app → FCM credential** (Firebase console → Project
settings → Service accounts → Generate new private key). Lotse stores it encrypted and
never shows it again. Never commit this file to the app repository or paste it into a
chat.

## 3. Open the target of a tapped push

```dart
class LotsePush {
  final String campaignId;
  final String deliveryId;
  final String? targetPath; // e.g. '/offer/42', null without a link
}
```

```dart
await Lotse.init(publicKey: _publicKey, serverUrl: _serverUrl);
final push = await Lotse.instance.initialPush;      // tapped while the app was closed
final router = buildRouter(initialLocation: safeLocation(push?.targetPath));

// Tapped while the app runs (foreground or background):
Lotse.instance.pushOpened.listen(
  (push) => router.go(safeLocation(push.targetPath)),
);
```

`safeLocation` is the route guard from lotse-deep-links: a target the app has no route
for goes to `/`. `initialPush` completes with `null` when the app started otherwise or
push is unavailable; it never errors. Both record `push_open` automatically, which the
campaign report counts as opened.

While the app is in the foreground Android shows no notification for a push, and the
SDK does not show one either.

## 4. Feedback reply pushes

A reply of the team to a feedback message also arrives as a push, but never as a
`LotsePush`: the SDK opens the conversation itself. For that `LotseScope` needs the
app's navigator key (see lotse-feedback):

```dart
LotseScope(
  navigatorKey: navigatorKey, // the same key as GoRouter(navigatorKey: ...)
  child: MaterialApp.router(routerConfig: router),
)
```

Without the key the push only brings the app to the front.

## 5. iOS

Works without app changes beyond the usual Firebase setup:

- capabilities: Push Notifications (`aps-environment`) and Background Modes → Remote
  notifications;
- the SDK reports the APNs token next to the FCM token. Once the owner uploads an APNs
  key (`.p8`, Key ID, Team ID) for the iOS app under Setup → Apps, Lotse sends directly
  through APNs; otherwise through FCM;
- builds from Xcode need a key for `sandbox`, TestFlight and App Store builds
  `production`. The diagnosis warns about a sandbox key.

Android is the primary platform; test there first.

## 6. Test

1. Real Android device, app started once, notification permission granted.
2. The device appears under Workspace → Devices in the console.
3. Console → Campaigns: a campaign to a small segment (e.g. just this device) with a link.
4. Tap the push with the app closed → app opens on the target. Repeat with the app in
   the background → `pushOpened` routes.
5. The campaign report shows sent and opened.

Logs: `Lotse: push messaging is unavailable` means Firebase is not configured or not
initialised; `could not report the push token` means the device has no token yet.

## Don'ts

- Don't send pushes from the app or call FCM with the service account from the app.
- Don't create your own channel for Lotse pushes or change `lotse_push`.
- Don't call `FirebaseMessaging.instance.deleteToken()` on logout; call
  `Lotse.instance.reset()` (lotse-events), which handles the token.
- Agents connected through lotse-mcp cannot send campaigns, by design.
