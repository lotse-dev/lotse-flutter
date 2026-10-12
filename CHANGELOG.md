## 0.1.0

First release on pub.dev.

* Setup: `Lotse.init` with the public key from the console registers the device and reports `session_start`. `Lotse.captureLaunchLinks` keeps a link that opens the app before `init` is done.
* Links: deferred deep links after an install from a link (`deferredLink`), `resolveLink`, and the Play install referrer for attribution on Android.
* Analytics: `track` with a queue that survives being offline, screen views with `LotseScreenObserver`, heatmaps from taps, app updates.
* Users: `identify` and `reset`, with identity verification by a hash your backend computes.
* Feedback: the feedback sheet with screenshot and masking (`LotseConfidential`, `LotseUnmasked`), replay of the last seconds, conversations with unread count, support chat, feature board with votes, surveys and in-app messages, custom texts.
* Push: FCM on Android and iOS, `initialPush` and `pushOpened` for tapped pushes.
* Agent skills for setup, events, deep links, push, feedback and the Lotse MCP server in `skills/`.
