---
name: lotse-deep-links
description: Handle Lotse short links in a Flutter app — the /l/:slug route with Lotse.instance.resolveLink, mapping a link's targetPath to go_router routes, deferred deep linking after install with Lotse.instance.deferredLink, campaign attribution, and testing App Links with adb. Use when wiring links that open the app, when a Lotse link opens the browser instead of the app, or when testing install attribution. Requires lotse-setup (intent filter and fingerprints) to be done.
---

# Lotse deep links

A Lotse link is `https://HANDLE.lotse.dev/l/<slug>`. The team creates it in the console
(Links → Create link) or an agent with `create_link` (lotse-mcp). It carries:

- `targetPath` — the app route to open, e.g. `/offer/42`;
- optional `campaign`, `source`, `medium` for attribution;
- optional web/store fallbacks.

What happens on a tap:

| Device | Result |
|---|---|
| Android, app installed, App Links verified | Android opens the app with `/l/<slug>`; the server never sees it |
| Android, no app | Play Store, with a referrer that attributes the install exactly |
| iOS with app / without | Universal Link / App Store |
| Desktop, bots | web fallback |

`LotseLink` (what the SDK hands the app):

```dart
class LotseLink {
  final String slug;
  final String targetPath;   // e.g. '/offer/42'
  final String? campaign;
  final String? source;
  final String? medium;
}
```

## 1. The `/l/:slug` route

Flutter's built-in deep linking passes the URL's path to go_router. Add a redirect-only
route that resolves the slug and sends the user to the target:

```dart
GoRoute(
  path: '/l/:slug',
  redirect: (context, state) async {
    final link = await Lotse.instance.resolveLink(state.pathParameters['slug']!);
    return safeLocation(link?.targetPath);
  },
),
```

`resolveLink(String slug)` returns `Future<LotseLink?>`: `null` for an unknown slug or
any failure, never an exception. A resolved link is tracked as `link_open` with its
slug — the setup diagnosis relies on that, so always go through `resolveLink`, even if
the app could parse the path itself.

### Links that reopen a stopped app

Call `Lotse.captureLaunchLinks()` in `main`, right after
`WidgetsFlutterBinding.ensureInitialized()` and before anything is awaited:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Lotse.captureLaunchLinks();
  // await Firebase.initializeApp(...), await Lotse.init(...), build the router
  runApp(MyApp(router: router));
}
```

When Android has ended the app's process in the background, it restores the app
first and delivers the link a moment later, while `main` is still waiting. No router
listens yet and Flutter drops the link: the app opens on its first screen. The call
keeps the link and hands it to the router after the first frame. A cold start and a
running app don't need it, but it costs nothing there. It needs no `Lotse.init` and
works only if the router exists when `runApp` draws its first frame.

## 2. Guard the target

`targetPath` is whatever the team typed. Never navigate to a path the app has no route
for, and never to another short link:

```dart
/// Paths the app can open from a link or push. Keep in sync with the routes.
final _appRoute = RegExp(r'^/(|catalog|cart|offer/[\w-]+|product/[\w-]+)$');

String safeLocation(String? target) =>
    target != null && !target.startsWith('/l/') && _appRoute.hasMatch(target)
    ? target
    : '/';
```

Use the same guard for `deferredLink`, pushes (lotse-push) and in-app messages.

## 3. Deferred deep linking

When the app was installed through a link, the first start can open the link's target.
`Lotse.init` asks the server once per install:

```dart
await Lotse.init(publicKey: _publicKey, serverUrl: _serverUrl);
final deferred = await Lotse.instance.deferredLink; // Future<LotseLink?>
final router = buildRouter(initialLocation: safeLocation(deferred?.targetPath));
```

- Completes with the link only on the first start that matched; `null` on later starts,
  without a match, or on any failure. Never an error.
- Matching: an install from Google Play carries the slug in the install referrer and is
  matched exactly. Otherwise the server matches probabilistically (platform, language,
  IP prefix) against clicks of the last 60 minutes. VPNs, iCloud Private Relay or a
  switch between Wi-Fi and mobile data between click and first start break that match.
  Don't promise exact attribution outside Play.
- A link the OS opened the app with still wins: go_router prefers the platform's
  initial route over `initialLocation`.

Attribution (campaign, source, medium of the install) shows up in the console under
Acquisition without any app code.

## 4. Test

Find the handle and a slug (console → Links). Install a build on a real device whose
signing fingerprint is in the console (lotse-setup step 7).

```bash
# Verified?
adb shell pm get-app-links com.example.app       # HANDLE.lotse.dev: verified

# Open a link like a tap does
adb shell am start -a android.intent.action.VIEW \
  -c android.intent.category.BROWSABLE \
  -d "https://HANDLE.lotse.dev/l/summer"

# After changing fingerprints or the manifest
adb shell pm verify-app-links --re-verify com.example.app
```

The app must open on `targetPath`, and the log shows no `Lotse: link "…" not found.`

The same after Android ended the process (tests `captureLaunchLinks`):

```bash
adb shell input keyevent KEYCODE_HOME             # app in recents
adb shell am kill com.example.app                 # like memory pressure
adb shell am start -a android.intent.action.VIEW \
  -c android.intent.category.BROWSABLE \
  -d "https://HANDLE.lotse.dev/l/summer"
```

Deferred link, by hand:

1. Uninstall the app.
2. On the device, open `https://HANDLE.lotse.dev/l/summer` in Chrome (same network as
   the next step; no VPN). Without the app this leads to the store or fallback.
3. Within 60 minutes install the app (`flutter run` or `adb install`) and start it.
4. The first start opens `targetPath`; a second start does not.

Typed URLs in the browser's address bar and in-app browsers (Instagram, TikTok, …)
never open apps; that is Android, not Lotse. Test from a messenger or notes app.

If the link opens the browser: run the console's diagnosis
(`../lotse-setup/references/diagnosis.md`).

## Don'ts

- Don't add a second deep-link package (`app_links`, `uni_links`) next to Flutter's
  built-in handling for the same URLs.
- Don't compute attribution in the app; the server does it.
- Don't put personal data into a link's `targetPath`; it ends up in analytics and in
  links people share.
