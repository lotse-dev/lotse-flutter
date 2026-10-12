---
name: lotse-feedback
description: Add in-app feedback with the Lotse SDK — the feedback sheet with screenshot (showFeedback), masking with LotseConfidential and LotseUnmasked, replay of the last seconds, conversations and unread badge (showMyFeedback, unreadFeedbackCount), support chat, feature board with votes, surveys and in-app messages, and custom texts. Use when adding a feedback button, bug reporting, a support chat or a roadmap/voting board to a Flutter app that uses the lotse package, or when reviewing what a screenshot or replay may show. Requires lotse-setup.
---

# Lotse feedback

Everything here is built in: sheets and pages in the app's theme, English and German
texts picked by the device locale. The app decides only *where* the entries are and
*what must never be visible* in an image.

Precondition: `Lotse.init` completed and `LotseScope` wraps the app (lotse-setup).
Without `LotseScope` the sheet works but has no screenshot, and reply pushes cannot open
their conversation.

## 1. Feedback sheet

```dart
// Future<void> showFeedback(BuildContext context,
//     {Map<String, String>? metadata, bool askForEmail = false, LotseFeedbackTexts? texts})
IconButton(
  icon: const Icon(Icons.feedback_outlined),
  tooltip: 'Send feedback',
  onPressed: () => Lotse.instance.showFeedback(
    context,
    metadata: {'plan': 'pro', 'cart_items': '3'},
  ),
);
```

- Call from any context below a `Navigator`. The screenshot is taken *before* the sheet
  opens, so open it from the screen the feedback is about.
- The user picks a category (bug, idea, praise, other), writes a message, can retake
  the screenshot on another screen, draw on it or remove it.
- `metadata`: at most 20 entries, stored with the message. Same rule as event props:
  labels and IDs, no personal data.
- `askForEmail: true` adds an optional e-mail field. Off by default; replies reach the
  user in the app anyway (section 4).
- The route name (`ModalRoute.of(context)?.settings.name`) is sent as the last screen:
  name your routes.
- Failures show in the sheet with a retry; nothing throws into the app. There is no
  offline queue for feedback.

The console's inbox shows each message with screenshot, replay, device, app version
and the events before it.

## 2. What images may show

Screenshots, replays and heatmap backgrounds are masked *in the image*, never on screen.

Masked automatically: every text input (`EditableText`, so `TextField`,
`TextFormField`), every platform view (web view, map) shown as a grey box.

```dart
// Always black in images: account data, balances, health data, personal details.
LotseConfidential(child: Text(iban));

// Show a harmless input or web view; LotseConfidential inside still hides its part.
LotseUnmasked(child: SearchBar(controller: searchController));
```

- `LotseScope(maskAllText: true, child: ...)` blacks out all text — for apps where
  almost every screen is personal (banking, health, messaging).
- Custom input widgets that don't use `EditableText` are not detected: wrap them in
  `LotseConfidential`.
- Platform views: only texture-based Android views (default `AndroidView`,
  `webview_flutter`) can appear inside `LotseUnmasked`; Hybrid Composition, iOS and web
  views stay grey ("Not recordable").
- Taps on `LotseConfidential` regions are not recorded for heatmaps.

When adding feedback to an existing app, walk through its screens and wrap everything
personal in `LotseConfidential`. That is the one review step that matters.

## 3. Replay of the last seconds (optional)

```dart
await Lotse.init(
  publicKey: _publicKey,
  serverUrl: _serverUrl,
  replay: const LotseReplayOptions(seconds: 60), // 15 to 120, default 60
);
```

`LotseScope` then keeps the last seconds in memory, masked like screenshots, plus taps
and screen changes. Nothing leaves the device unless the user keeps "Attach the last 60
seconds" on in the sheet. `attachByDefault: false` starts that switch off. Call `init`
before `runApp`. On the web at most one frame per second.

## 4. Conversations and the unread badge

The team answers in the console; the user reads and replies under "My feedback".

```dart
ListTile(
  leading: ValueListenableBuilder<int>(
    valueListenable: Lotse.instance.unreadFeedbackCount,
    builder: (context, unread, child) => Badge(
      isLabelVisible: unread > 0,
      label: Text('$unread'),
      child: child,
    ),
    child: const Icon(Icons.forum_outlined),
  ),
  title: const Text('My feedback'),
  onTap: () => Lotse.instance.showMyFeedback(context),
);
```

A team reply arrives as a push (lotse-push). Tapping it opens the conversation on the
navigator given to `LotseScope(navigatorKey: ...)` — use the same key as
`GoRouter(navigatorKey: ...)` or `MaterialApp(navigatorKey: ...)`.

## 5. Support chat

```dart
onTap: () => Lotse.instance.showSupportChat(context),
```

An asynchronous chat in which the user asks first. The project switches it on in the
console (Setup → Settings); while it is off the page shows a notice, so the entry may
stay in the app. Replies count into `unreadFeedbackCount`.

## 6. Feature board

```dart
onTap: () => Lotse.instance.showFeatureBoard(context),
```

Tabs Ideas, Planned, In progress, Shipped; users vote with one tap. Users cannot submit
ideas there — offer `showFeedback` for that; the team turns an idea message into a board
entry in the console. Each vote is the event `feature_voted`, so "voted for X" can be a
segment for the push that announces X.

## 7. Surveys and in-app messages

Both come from the console and need only `LotseInAppMessages` in `MaterialApp.builder`
(lotse-setup step 5):

```dart
MaterialApp.router(
  routerConfig: router,
  builder: (context, child) => LotseInAppMessages(
    onTap: (message) => router.go(safeLocation(message.targetPath)),
    child: child!,
  ),
);
```

`Lotse.instance.checkInAppMessages()` asks right away, e.g. after a purchase; otherwise
the SDK asks on start and when the app returns to the foreground.

## 8. Texts

```dart
Lotse.instance.showFeedback(
  context,
  texts: LotseFeedbackTexts.english.copyWith(title: 'Tell us'),
);
```

`LotseFeedbackTexts.english`, `LotseFeedbackTexts.german`,
`LotseFeedbackTexts.forLocale(locale)` and `copyWith(...)`. The same `texts` parameter
exists on `showMyFeedback`, `showSupportChat`, `showFeatureBoard` and
`LotseInAppMessages`. A conversation opened from a push uses the device locale.

## Logout

`Lotse.instance.reset()` closes open Lotse pages and starts a new anonymous install; the
old conversations stay with the team but can no longer be reached from this install.
See lotse-events.

## Checklist

- [ ] One visible "Send feedback" entry; "My feedback" with the unread badge
- [ ] Personal widgets wrapped in `LotseConfidential`; custom inputs too
- [ ] `LotseScope(navigatorKey: ...)` shares the router's key
- [ ] `metadata` without personal data
- [ ] Replay only if the team wants it, with `init` before `runApp`
