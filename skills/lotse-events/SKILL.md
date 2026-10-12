---
name: lotse-events
description: Track analytics events with the Lotse SDK — Lotse.instance.track, event naming, props without personal data, screen views with LotseScreenObserver and go_router, identify and reset for logged-in users, heatmaps and the events Lotse records by itself. Use when adding or reviewing analytics in a Flutter app that uses the lotse package, when designing events for funnels, retention, segments or campaign goals, or when wiring login and logout to Lotse. Requires lotse-setup to be done.
---

# Lotse events

Events feed every part of Lotse: the overview, funnels, retention, segments, campaign
goals and the timeline shown next to each feedback message. Good names and clean props
matter more than many events.

Precondition: `await Lotse.init(...)` has completed (lotse-setup). Before that,
`Lotse.instance` throws a `StateError`.

## Track

```dart
// Future<void> track(String name, {Map<String, String>? props})
unawaited(Lotse.instance.track('checkout_started', props: {'items': '3'}));
```

- Fire and forget: `track` never throws. It writes the event to an on-device queue and
  sends it right away; without network the event waits (also across app restarts) and
  is dropped after 30 days. Don't `await` it in UI code (`unawaited` from `dart:async`,
  or no `await`).
- Props are `Map<String, String>`. Pass numbers and booleans as strings: `'3'`, `'true'`.
- Limits — an event over them is not tracked, only logged as `Lotse: "…" is not tracked`:
  name 1–100 characters, at most 20 props, keys 1–200 and values up to 200 characters.

## Naming

- `snake_case`, object first, action in the past: `checkout_started`, `item_added`,
  `purchase_completed`, `signup_completed`, `search_performed`. Pick one style per app
  and keep it; renaming later splits the history.
- One event per user intent, not per widget: `item_added` with `{'source': 'list'}`
  rather than `add_button_list_tapped` and `add_button_detail_tapped`.
- Name the steps a funnel or a campaign goal will need (e.g. `catalog` screen →
  `item_added` → `checkout_started` → `purchase_completed`).
- Don't track what Lotse records already, and never use these names yourself:
  `session_start`, `screen_view`, `app_update`, `link_open`, `push_open`, `push_sent`,
  `rage_tap`, `identify`, `attribution_match`, `feedback_submitted`, `feature_voted`,
  `feature_unvoted`, `in_app_view`, `in_app_tap`, `in_app_dismiss`, `survey_view`,
  `survey_dismiss`, `survey_answered`, `link_click`.

## Props: labels and IDs, no personal data

Props are stored as they are and show up in the console, in segments and with the AI
agents the team connects (lotse-mcp). Put in labels and identifiers of *things*, never
data about a person.

| Good | Never |
|---|---|
| `{'product_id': 'sku-1042'}` | e-mail, name, phone, address |
| `{'plan': 'pro'}` | free text the user typed (search terms, messages) |
| `{'source': 'push'}` | precise location, IP, device identifiers |
| `{'step': '2', 'method': 'card'}` | tokens, passwords, payment data |
| `{'screen': 'offer'}` | amounts tied to a named person, health data |

If a value could identify a person or was typed by one, drop it or reduce it to a
category (`'query_length': '12'` instead of the query).

## Screen views

`LotseScreenObserver` writes `screen_view` with prop `screen` for every page that
becomes visible. The screen is the route's `name`, or its path pattern (`offer/:id`)
without one — never the concrete location, so IDs do not leak into analytics.

```dart
final router = GoRouter(
  observers: [LotseScreenObserver()],
  routes: [
    GoRoute(path: '/', name: 'home', builder: (_, _) => const HomeScreen()),
    GoRoute(
      path: '/offer/:id',
      name: 'offer',
      builder: (_, state) => OfferScreen(id: state.pathParameters['id']!),
    ),
  ],
);
```

- Give every route a `name`; these names are also the screens of heatmaps and the
  "last screen" of feedback messages.
- One observer on the `GoRouter`. Since go_router 17 a `ShellRoute` reports to it; do
  not add a second observer to the shell (views would count twice). With go_router 16
  or older, or `notifyRootObserver: false`, the shell needs its own instance.
- Dialogs and bottom sheets are skipped. To rename or skip routes:
  `LotseScreenObserver(screenName: (route) => route.settings.name)`; return `null` to skip.
- `MaterialApp`: `navigatorObservers: [LotseScreenObserver()]`.

## Users: identify and reset

Installs are anonymous. When the app knows its user, after login and whenever traits
change:

```dart
await Lotse.instance.identify('u_8f3a2c', traits: {'plan': 'pro', 'lang': 'de'});
```

- Use a pseudonymous ID from your backend, not an e-mail address: it is stored as is.
- Traits are merged over earlier ones, never removed. Limits: id 1–256 characters, at
  most 50 traits per user, keys 1–64, values up to 1024 characters. Same rule as props:
  no personal data in traits.
- Without identity verification any app user can claim any ID. If the project has an
  identity secret (console, project settings), the backend computes the hash and the
  app passes it:

  ```dart
  await Lotse.instance.identify(userId, userHash: hashFromYourBackend);
  ```

  The hash is the lowercase hex HMAC-SHA256 of the trimmed ID with the whole `lt_is_…`
  secret as key, computed on the server (snippets in the SDK README, "Identity
  verification"). Never put the secret into the app, a config file of the app or the
  repository. A wrong hash is refused, a missing one once the project requires it.

On logout or account switch, before the next person sees the app:

```dart
await Lotse.instance.reset();
```

`reset` starts a new anonymous install (new `Lotse.instance.installId`), closes open
Lotse pages, drops queued events and taps of the old identity and revokes its push
token. Call `identify` again after the next login.

## What Lotse records by itself

| Event | When |
|---|---|
| `session_start` | `init`, and after `reset` |
| `screen_view` (`screen`) | `LotseScreenObserver` |
| `app_update` (`from`, `to`) | first start of a new `version+build` |
| `link_open` (`slug`) | `resolveLink` resolved a link |
| `push_open` (`campaignId`, `deliveryId`) | a Lotse push was tapped |
| `rage_tap` (`screen`, `x`, `y`) | heatmaps on, 3+ quick taps on one spot |
| `in_app_*`, `survey_*`, `feature_voted`, `feedback_submitted` | the respective feature |

## Heatmaps (optional)

```dart
await Lotse.init(publicKey: '…', serverUrl: '…', heatmaps: true);
```

Records taps per named screen inside `LotseScope`, batched. Taps are behavioural data:
ask for consent as for analytics. Off by default. `LotseConfidential` regions and
dialogs are not recorded. Screenshots for the heatmap background are taken from debug
and profile builds by default; `heatmapBackgrounds: LotseBackgrounds.allBuilds` also
uses release builds.

## Testability

`Lotse.instance` does not exist in widget tests. Inject the tracking function instead
of calling the singleton deep in widgets:

```dart
typedef Track = Future<void> Function(String name, {Map<String, String>? props});

class CartScreen extends StatelessWidget {
  const CartScreen({required this.track, super.key});
  final Track track;
  // ...
}

// In main(), after init:
CartScreen(track: Lotse.instance.track);
// In tests:
CartScreen(track: (name, {props}) async => tracked.add(name));
```

In bloc/cubit apps, pass the same function into the cubit.

## Consent

The SDK has no opt-out switch. If the app needs analytics consent first, call
`Lotse.init` only after consent (feedback and links then also wait), and keep
`heatmaps` off without consent.

## Review checklist

- [ ] Event names are `snake_case`, consistent, and none is in the reserved list
- [ ] Props hold labels and IDs only; no personal data, no user-typed text
- [ ] Every route has a `name`; exactly one `LotseScreenObserver` per navigator
- [ ] `identify` after login with a pseudonymous ID, with `userHash` from the backend
  if the project verifies identities; `reset` on logout
- [ ] No `track` call can run before `Lotse.init` finished
