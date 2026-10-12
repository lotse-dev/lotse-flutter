# The setup diagnosis

Console → **Setup → Diagnosis** checks whether short links open the app. It runs when
the page opens and on "Run again" (at most 30 runs per project and hour). From a link's
detail page ("Opens in browser?") it runs for that one link. Each check has a status —
ok, warning, failed or unknown — a finding and "What to do". At the bottom the page
shows the exact intent filter for the project's host, ready to copy.

The same diagnosis is available to agents through the MCP tool `diagnose_setup`
(see lotse-mcp).

| Check (key) | Fails or warns when | Fix |
|---|---|---|
| Project active (`project`) | the project is suspended: the link domain answers 404, also to `assetlinks.json` | contact the Lotse team |
| Android app (`android.app`) | the project has no Android app | Setup → Apps → Add app → Android |
| Package name (`android.package`) | not a valid Android package name | delete and add the app again with `applicationId` from `android/app/build.gradle(.kts)` |
| Signing certificate (`android.fingerprints`) | none, SHA-1 or malformed: failed. Exactly one: warning (a Play build is signed by Google's key) | Apps → Edit fingerprints: Play App Signing key, upload key, debug key (`./gradlew signingReport`) |
| assetlinks.json (`android.assetlinks`) | redirect, not 200, not `application/json`, no JSON list, or a fingerprint missing | after a change the file may be cached up to five minutes; run again |
| Google verifies … (`android.google`) | Google's Digital Asset Links API does not link package and fingerprint to the host | compare with the certificate that signs the installed build; Google caches for a few minutes |
| Manifest of the app (`android.manifest`) | always unknown: the server cannot see the manifest | see below |
| Traffic of the last 7 days (`traffic`) | Android clicks reached the browser but no `link_open` was recorded: warning. Mostly in-app browsers: warning, not a setup error | tap a link on a device with the app installed; make sure the `/l/:slug` route calls `resolveLink` |
| iOS app (`ios.app`) | no or malformed Team ID | add the 10-character Team ID of the Apple Developer account |
| apple-app-site-association (`ios.aasa`) | file not served correctly or app missing | run again later; check Team ID and bundle ID |
| APNs (`push.apns`) | no key (warning: push goes through FCM), team mismatch (failed), sandbox key (warning) | Apps → upload the `.p8` key with environment `production` for TestFlight/App Store |

`push.*` checks are listed but never become the summary: they do not decide where a
link opens.

## How the traffic proves App Links

A working App Link never reaches the server: Android opens the app directly. So every
Android `link_click` the server records landed in a browser — from a phone without the
app (fine, it goes to the store) or from one where verification failed. The SDK records
`link_open` with the slug whenever `Lotse.instance.resolveLink` resolves. "Clicks but
no opens" therefore means: either nobody with the app tapped a link, or App Links are
not verified, or the app never calls `resolveLink`.

## Device commands

```bash
# Is the domain verified for the app?
adb shell pm get-app-links <package>          # expect: HANDLE.lotse.dev: verified

# Re-run verification after changing fingerprints or the manifest
adb shell pm verify-app-links --re-verify <package>

# Open a short link like a tap would
adb shell am start -a android.intent.action.VIEW \
  -c android.intent.category.BROWSABLE \
  -d "https://HANDLE.lotse.dev/l/test"

# Watch what the SDK says
adb logcat -s flutter | grep "Lotse:"
```

## Why a correct setup can still open the browser

- The URL was typed or pasted into the browser's address bar: Android never intercepts
  that. Test from a messenger, notes or mail app.
- In-app browsers (Instagram, Facebook, TikTok, LinkedIn, …) never hand links to apps.
- The app was installed before the fingerprints were fixed. Reinstall or run
  `pm verify-app-links --re-verify`.
- The installed build is signed with a key whose fingerprint is not in the console
  (common: Play App Signing key missing).
