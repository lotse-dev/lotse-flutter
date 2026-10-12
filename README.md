# lotse

![Lotse: know your users, reach the right ones](https://raw.githubusercontent.com/lotse-dev/lotse-flutter/main/doc/banner.jpg)

Deep links, attribution, analytics, feedback and push for Flutter apps on a
[Lotse](https://lotse.dev) backend. The SDK talks to the server through a
generated Serverpod client but never shows it: apps only see `Lotse` and the
SDK's own types.

## Install

```bash
flutter pub add lotse
```

Requires Dart `^3.12.2` and Flutter `>=3.44.4`. You need a project in the Lotse
console for the public key.

## Getting started

```dart
import 'package:lotse/lotse.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Lotse.captureLaunchLinks(); // before the first await
  await Lotse.init(
    publicKey: 'lt_pk_...', // from the Lotse console
    serverUrl: 'https://api.lotse.dev/',
  );
  runApp(LotseScope(child: MyApp()));
}
```

`captureLaunchLinks` keeps a link that reopens the app while `main` is still waiting
(Android restores an app whose process it ended and delivers the link a moment later)
and hands it to the router after the first frame. Call it before anything is awaited.

`init` registers the device, reports `session_start` and starts push messaging
if the app has a Firebase configuration. Nothing in the SDK throws into the
app: failures are logged with `debugPrint` and the call returns `null` or does
nothing. The one exception is a `serverUrl` that breaks the rules below — a
configuration mistake, thrown as `LotseServerUrlError` before any request is
made.

## On the web

The SDK runs in Flutter web apps too: events, links, users, feedback,
heatmaps and replay. The device reports the platform `web` and, as its OS
version, the browser and its major version (`Chrome 140`). Differences:

- No push. The SDK never asks the browser for notification permission, even if
  the app has set up Firebase itself.
- The install credential lives in `localStorage` through
  `flutter_secure_storage`. Any script on the page can read it, like any other
  token a web app keeps. It only lets its holder act as this one device.
- Replay records a frame at most once a second. With the CanvasKit renderer,
  taking a frame costs the main thread about 10 to 20 ms; a `--wasm` build
  (skwasm) takes well under 2 ms.

## The server URL

`serverUrl` is `https://api.lotse.dev/`. It carries the install credential and
private conversations, so the SDK checks it before the first request leaves the
device: it must be `https`, without credentials, query or fragment. Certificates
are checked the normal way of the platform; the SDK has no way to turn that off.

## Events, links and push

```dart
await Lotse.instance.track('checkout_started', props: {'cart': '3 items'});

final link = await Lotse.instance.resolveLink('summer');   // LotseLink?
final first = await Lotse.instance.deferredLink;           // once per install
final opened = await Lotse.instance.initialPush;           // LotsePush?
Lotse.instance.pushOpened.listen((push) => router.go(push.targetPath ?? '/'));
```

A link that resolves is tracked as `link_open` with its slug. Call
`resolveLink` when a short link opens the app; the setup diagnosis in the console
compares these opens with the clicks that ended up in the browser.

`targetPath` of a link, a push and an in-app message is a route of your app,
written by your team in the console: hand it to your router (`router.go`), not to
`launchUrl` or a web view. The server refuses a path that starts with `//` or `/\`,
which a browser would read as another host, but a router is still the only place
the path belongs.

### Push on iOS

The SDK reports the FCM token on every platform and, on iOS, the APNs device
token as well. Lotse then sends to an iPhone directly through APNs once the
project owner has uploaded an APNs key (.p8) for the iOS app under Apps in the
console, and over FCM otherwise. `initialPush`, `pushOpened`, `push_open` and
the feedback replies work the same either way; your app changes nothing.

What the iOS app needs, besides the Firebase configuration:

- the Push Notifications capability (`aps-environment` in the entitlements) and
  the background mode "Remote notifications";
- for Universal Links, the Associated Domains capability with
  `applinks:<handle>.lotse.dev`, and the Team ID on the iOS app in the console;
- an APNs key of the same team. Builds run from Xcode register sandbox tokens
  and need a key uploaded for `sandbox`; TestFlight and App Store builds need
  `production`.

`reset()` cannot delete the APNs token, it belongs to the app installation. The
server moves it to the new identity when the SDK reports it again.

### Screen views

Hand a `LotseScreenObserver` to your navigator and every page that becomes visible is
reported as a `screen_view` event with the prop `screen`:

```dart
final router = GoRouter(
  observers: [LotseScreenObserver()],
  routes: [
    GoRoute(path: '/', name: 'home', builder: (_, _) => const HomeScreen()),
    GoRoute(path: '/offer/:id', name: 'offer', builder: ...),
  ],
);
```

The screen is the route's name, or its path pattern (`offer/:id`) if it has none, never
the concrete location, so ids do not end up in your analytics. Give your routes a
`name`. Dialogs, bottom sheets and routes without a name are skipped; pass
`screenName:` to decide yourself, returning null to skip a route. Since go_router 17
a `ShellRoute` reports its pages to the `GoRouter` observers, so one instance covers
them; a second one in the shell's `observers` would count every view twice. With
go_router 16 or older, or `notifyRootObserver: false`, the shell needs its own. Views
are reported once `Lotse.init` has finished; views before `init` is called are
dropped. With `MaterialApp`, use `navigatorObservers: [LotseScreenObserver()]`.

### Heatmaps

With `Lotse.init(heatmaps: true)` a `LotseScope` around the app records where users tap,
per screen from `LotseScreenObserver`, and the console draws a heatmap from it:

```dart
await Lotse.init(publicKey: '…', serverUrl: '…', heatmaps: true);
```

A tap is a press released within 500 ms without moving; drags and scrolls are not taps.
Each tap carries its position in logical pixels and, inside a vertical scroll view, the
scroll offset, so taps on long lists land in the right place. Taps are sent in batches,
at most every 30 seconds, from 100 taps and when the app goes to the background.
Three or more taps within a second on one spot are rage taps; each burst also becomes
the event `rage_tap` with `screen`, `x` and `y`, so "rage tappers" can be a segment.

Nothing is recorded while a dialog or bottom sheet is on top, on screens without a
name, or on a `LotseConfidential` region. Taps are behavioural data like events: ask
your users for consent as you do for analytics. Off by default.

The console draws a heatmap over a screenshot of its screen, one per screen, app
version and width class (narrow below 360, regular up to 599, wide from 600 logical
pixels). When one is missing, the server asks for it and the SDK takes it once that
screen has been still for a second. By default only debug and profile builds do this:
open each screen once on your own device after a new version. `LotseConfidential`
regions are blacked out. To let release builds provide them too:

```dart
await Lotse.init(
  publicKey: '…',
  serverUrl: '…',
  heatmaps: true,
  heatmapBackgrounds: LotseBackgrounds.allBuilds,
);
```

### App updates

When the app starts with another version than last time, `init` reports `app_update`
with the props `from` and `to`. The version is `version+buildNumber` from your
pubspec, e.g. `1.4.0+12`; segments on the app version compare against exactly this
text.

## In-app messages

Your team writes in-app messages in the console: a card in the middle of the screen or
a banner at the top, for a segment, opening the same deep link a push would. Put
`LotseInAppMessages` into the `builder` of your `MaterialApp`, so it sits above every
route:

```dart
MaterialApp.router(
  routerConfig: router,
  builder: (context, child) => LotseInAppMessages(
    onTap: (message) => router.go(message.targetPath ?? '/'),
    child: child!,
  ),
);
```

The SDK asks the server when the app starts and whenever it comes back to the front,
at most once a minute, and shows one message at a time. The server checks the segment
for this device at that moment, so a device that falls into it later gets the message
then. `Lotse.instance.checkInAppMessages()` asks right away, for a moment your app
knows better, e.g. after a purchase.

It tracks `in_app_view`, `in_app_tap` and `in_app_dismiss` with the prop `messageId`.
A message the user tapped or closed does not come again; one that was only seen does,
on a later start. The buttons read "Open" and "Close", in German on a German device;
your team sets the card's button label per message. `reset()` forgets the messages of
the old identity.

## Users

Lotse works with anonymous installs. If your app knows who its user is, tell Lotse after
login, and again whenever the traits change:

```dart
await Lotse.instance.identify('user-4711', traits: {'plan': 'pro', 'lang': 'de'});
```

The id is stored as is and shown in the console, so prefer a pseudonymous id from your
own backend over an e-mail address. Several installs may name the same user; a later
call merges its traits over the earlier ones and never removes one. Limits: an id of 1
to 256 characters, at most 50 traits per user, keys of 1 to 64 and values of at most
1024 characters. `identify` never throws; a refused call is logged without the id or a
trait.

The user is a trait for analytics and segments. It opens nothing private: no install
gains access to the feedback or conversations of another install of the same user.
After `reset()` the new install is anonymous until you call `identify` again.

### Identity verification

Without it, Lotse takes the id as the app says it. Anybody with your app can then call
`identify` with the id of somebody else, overwrite that user's traits and with them
the segments that decide which pushes, in-app messages and surveys the user gets.
Identity verification closes that: your backend signs the id, and Lotse refuses an id
without a valid signature.

1. In the console, open the project settings, "Identity verification", and generate
   the identity secret (`lt_is_…`). It is shown once. Put it where your backend keeps
   its secrets, e.g. an environment variable. **Never ship it in the app** and keep it
   out of version control: whoever has it can sign any id.
2. Your backend computes the user hash of the signed-in user and hands it to the app
   with the login or session response:

   **Node.js**

   ```js
   import { createHmac } from 'node:crypto';

   const userHash = createHmac('sha256', process.env.LOTSE_IDENTITY_SECRET)
     .update(userId, 'utf8')
     .digest('hex');
   ```

   **Python**

   ```python
   import hashlib, hmac, os

   user_hash = hmac.new(
       os.environ["LOTSE_IDENTITY_SECRET"].encode("utf-8"),
       user_id.encode("utf-8"),
       hashlib.sha256,
   ).hexdigest()
   ```

   **Dart** (`package:crypto`)

   ```dart
   import 'dart:convert';
   import 'package:crypto/crypto.dart';

   final userHash = Hmac(sha256, utf8.encode(identitySecret))
       .convert(utf8.encode(userId))
       .toString();
   ```

3. The app passes it along:

   ```dart
   await Lotse.instance.identify(session.userId, userHash: session.lotseUserHash);
   ```

The rule: lowercase hex (64 characters) of HMAC-SHA256, the key being the UTF-8 bytes
of the whole secret including `lt_is_`, the message the UTF-8 bytes of the user id as
Lotse stores it, that is without leading and trailing whitespace. Ids from a database
rarely have any; if yours might, trim the id before you hash it and pass the same id to
`identify`. To check your code: the secret `lt_is_example` and the id `user-42` give
`2b6dbefac48e5741a14664b9210ebc33b3cf848a3f2be67e432f9144f517b117`.

What the server does:

| Project | No hash | Wrong hash | Valid hash |
|---|---|---|---|
| no identity secret | accepted | ignored, accepted | ignored, accepted |
| secret, verification not required | accepted | refused | accepted |
| secret, verification required | refused | refused | accepted |

A refused call writes nothing: no user, no traits, no link to the install, no event.
Like every failure of `identify` it is not thrown into the app; a debug build logs
`Lotse: could not identify the user: LotseInvalidInputException`, without the id or the
hash.

Roll it out in this order: generate the secret, ship the backend and an app version
that send the hash, and switch on "Require verification" in the console once the
versions without the hash are no longer in use. Until then calls without a hash still
pass, wrong ones are refused.

Generating the secret again replaces it at once; hashes of the old one are refused from
the next call on. Update the secret in your backend right away, or switch the
requirement off while you do; an app should get a fresh hash with every login or
session instead of keeping one forever. Deleting the secret switches verification off.
Only the owner of the project can generate, delete or require it.

## What stays on the device

- The install credential is in the secure storage of the platform (Android
  Keystore, iOS Keychain).
- Events and heatmap taps that could not be sent yet wait in `SharedPreferences`
  (keys `lotse.eventQueue` and `lotse.tapQueue`), at most 1,000 events for at most
  30 days, with the props your app tracked. So do the install id and a few flags
  (`lotse.*`). On Android, `SharedPreferences` is part of Auto Backup unless your
  app excludes it; if your props can hold personal data, exclude the file
  `FlutterSharedPreferences.xml` in your backup rules
  (`android:fullBackupContent` / `android:dataExtractionRules`).
- The SDK logs to the console of the app with the prefix `Lotse:`. Release builds
  get the type of an error, not its text.

## Logout and account switch

Lotse has no user accounts. Feedback, the support chat, votes and pushes belong to an
anonymous install. If your app has a login, tell Lotse when the user changes, before
the next one sees the app:

```dart
await Lotse.instance.reset();
```

At once, before the future completes, open Lotse pages close, their live updates stop,
`unreadFeedbackCount` drops to zero and answers of the server still on their way are
discarded. Then the credential of the old identity is revoked, the push token of the
device is deleted (on iOS the APNs token moves to the new install instead, see "Push
on iOS"), and the SDK goes on as a new install with a new `installId`.
Without a network the revocation is made up for on the next start. `reset` never
throws.

The conversations of the old identity stay with your team in the console. From this
app install they cannot be reached again, also not when the same person logs back in:
Lotse cannot know it is the same person. A reinstall of the app is a new identity as
well.

`Lotse.instance.installId` names the install and is not a secret. What opens its
conversations is a credential the SDK keeps in the Android Keystore / iOS Keychain and
never hands to the app.

## Feedback

```dart
// Once around the app. Provides the boundary the screenshot is taken of.
runApp(LotseScope(child: MyApp()));

// Anywhere below a Navigator.
await Lotse.instance.showFeedback(
  context,
  metadata: {'cart': '3 items'}, // stored with the message, at most 20 entries
  askForEmail: true,             // optional e-mail field, off by default
);

// Black in every screenshot, unchanged on screen.
LotseConfidential(child: Text(iban));
```

What Lotse blacks out is painted into the image, never on the screen:
`LotseConfidential` regions, every text input and every platform view (web view,
map). Wrap a search field or a harmless web view in `LotseUnmasked` to show it;
a `LotseConfidential` inside still hides its part. Platform views are grey with a
window symbol. Only texture-based Android views (the default of `AndroidView` and
`webview_flutter`) can appear in the image. A platform view that cannot, with
Hybrid Composition, on iOS or on the web, stays grey inside `LotseUnmasked` too,
labelled "Not recordable". `LotseScope(maskAllText: true)`
blacks out every text as well. Custom input widgets that do not use Flutter's
`EditableText` are not recognised; wrap them in `LotseConfidential`.
Masks are found in everything Flutter paints, also below widgets that hide
their subtree from screen readers (`ExcludeSemantics`,
`Semantics(excludeSemantics: true)`). Only what is not painted is skipped:
offstage routes and widgets, fully transparent subtrees, the hidden children of
an `IndexedStack`. A `Visibility` that hides its child but keeps its size is
masked as if it were shown.

The sheet is a modal bottom sheet in the theme of the app: category (bug, idea,
praise, other), message, the optional e-mail field, a preview of the screenshot
with "retake", "mark" and "remove", and a send button.

- The screenshot is taken before the sheet opens. "Retake" closes the sheet
  and shows a floating bar with "Take screenshot" and "Cancel". The user can go
  anywhere in the app to the screen the feedback is about and capture it there.
  The bar can be dragged out of the way; it is never in the image. The sheet
  comes back with everything the user entered, and the last screen sent is the
  one captured. "Cancel" keeps the screenshot the sheet had.
- "Mark" opens the screenshot full screen. The user draws on it with one pen in
  one colour, with undo and clear. "Done" burns the strokes into the image that
  is sent; opened again, earlier strokes can still be undone.
- Without a `LotseScope` the sheet works the same, without a screenshot.
- Screens with platform views (maps, web views) are captured like any other;
  the views are masked as described above.
- If sending fails, the sheet shows the error, keeps every input and offers a
  retry. There is no offline queue yet.
- Screenshots are scaled to at most 1280 px on the longest edge and 1 MB, with
  or without marks.
- The name of the current route (`ModalRoute.of(context)?.settings.name`) is
  sent as the last screen, so named routes make the inbox easier to read. After
  a retake it is the route on top of the navigator.

### Replay of the last seconds

```dart
await Lotse.init(
  publicKey: '…',
  serverUrl: '…',
  replay: const LotseReplayOptions(seconds: 60), // 15 to 120
);
```

With this option `LotseScope` keeps the last seconds of the screen in memory: a few
pictures a second, only after Flutter drew something, masked like screenshots (text
inputs, platform views and `LotseConfidential` regions), plus taps and screen changes.
Nothing leaves the device on its own. The feedback sheet shows "Attach the last 60
seconds" when there is a recording; if the user keeps it on, the recording goes up
after the message, and your team plays it in the console next to the screenshot. The
recorder pauses while the sheet is open, so the message being typed is never in it.
`attachByDefault: false` starts the switch off. Call `init` before `runApp`.

### Conversations

The team can answer a message from the console. The user finds the answer under
"My feedback" and can reply there:

```dart
// The list of this device's messages with status and unread marker. A tap
// opens the conversation with a reply field.
await Lotse.instance.showMyFeedback(context);

// For a badge on the entry that leads there.
ValueListenableBuilder<int>(
  valueListenable: Lotse.instance.unreadFeedbackCount,
  builder: (context, unread, child) =>
      Badge(isLabelVisible: unread > 0, label: Text('$unread'), child: child),
  child: const Icon(Icons.forum_outlined),
);
```

- An open conversation gets new replies live: it keeps a Serverpod streaming
  method (a WebSocket to your `serverUrl`) open and reloads as soon as the
  server says something changed. If that connection cannot be opened or drops,
  it asks every five seconds instead and tries the live connection again a
  little later. It marks what it shows as read. Nothing is open or polled while
  no conversation is on screen or the app is in the background. In a browser
  the API host refuses the WebSocket handshake of foreign origins, so the SDK
  on the web polls.
- `unreadFeedbackCount` is refreshed at start, when a push announces a reply
  and after a conversation was read.
- A team reply arrives as a push. That push is not an app route: it never shows
  up in `initialPush` or `pushOpened`. Tapping it opens the conversation, for
  which Lotse needs the navigator of the app. Give `LotseScope` the same key as
  the router:

```dart
final navigatorKey = GlobalKey<NavigatorState>();
final router = GoRouter(navigatorKey: navigatorKey, routes: routes);

runApp(
  LotseScope(
    navigatorKey: navigatorKey,
    child: MaterialApp.router(routerConfig: router),
  ),
);
```

  Without a router the key goes to `MaterialApp(navigatorKey: ...)`. An existing
  router has its key at `router.routerDelegate.navigatorKey`. Without a key the
  push just brings the app to the front. A conversation opened from a push uses
  the built-in texts for the device locale.
- While the app is in the foreground, Firebase shows no notification. The badge
  still updates, and an open conversation shows the reply right away.

### Support chat

The same conversations carry a support chat, in which the user asks first:

```dart
await Lotse.instance.showSupportChat(context);
```

- The chat is switched on per project in the console (project settings) and is
  off by default. While it is off the page shows a notice instead of the
  question field; the app does not have to ask before it offers the entry.
- The page opens the running conversation of this device or, without one, a
  field for the first question. A conversation is over once the team set it to
  done or dismissed; the next question starts a new one. Earlier ones stay
  under "My feedback" with the category "Question".
- A conversation that runs when the chat is switched off stays open for
  replies from both sides.
- Replies count into `unreadFeedbackCount` and arrive as the same push as
  replies to feedback. Questions count into the feedback quotas.
- It is an asynchronous chat: no typing indicator, attachments, opening hours
  or bot.

### Feature board

The team puts ideas on the board in the console, users vote on them:

```dart
await Lotse.instance.showFeatureBoard(context);
```

- Four tabs: Ideas, Planned, In progress and Shipped, each with the ideas in
  that status, most votes first. Archived and merged ideas do not show up.
- One tap votes, a second one takes the vote back. The count moves at once; if
  the server does not take the vote, it is taken back with a message. A device
  gets 50 new votes in 24 hours, taking a vote back is never turned away.
- Pulling a tab down loads the whole board again. An empty tab says so.
- Users cannot hand in ideas on the board. Offer `showFeedback` for that; the
  team turns a message of the category idea into an idea on the board with one
  click in the console.
- Votes belong to the install. Each one is also the event `feature_voted` with
  the prop `featureRequestId`, so "voted for X" works as a segment for the
  push that announces X.

### Texts

English and German are built in and picked by the device locale. Override
single texts or pass a complete set:

```dart
Lotse.instance.showFeedback(
  context,
  texts: LotseFeedbackTexts.english.copyWith(title: 'Tell us'),
);
```

`showMyFeedback`, `showSupportChat` and `showFeatureBoard` take the same
`texts`; the set covers the sheet, the list, the conversations, the support chat
and the feature board.

## AI agents

The package ships agent skills in the [agentskills.io](https://agentskills.io)
format, for Claude Code, Cursor, Codex and other agents: `lotse-setup`,
`lotse-events`, `lotse-deep-links`, `lotse-push`, `lotse-feedback` and `lotse-mcp`
(working with a project through the Lotse MCP server; create the token in the
console under project settings → AI agents, and never write it into files in your
repository).

Install them into your app with the [skills](https://pub.dev/packages/skills) CLI,
which finds the skills of every package your app depends on:

```bash
dart pub global activate skills
skills get --package lotse --all
```

Run `skills get` again after updating `lotse` to update the skills.
