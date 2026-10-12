import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart'
    show CupertinoLocalizations, DefaultCupertinoLocalizations;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/client/lotse_client.dart' as generated;
import 'package:lotse/lotse.dart';
import 'package:lotse/src/lotse_in_app.dart';
import 'package:lotse/src/lotse_in_app_view.dart';

const _card = LotseInAppMessage(
  id: 1,
  title: 'Spring sale',
  body: '20 % off everything.',
  style: LotseInAppStyle.card,
  targetPath: '/offer/42',
  slug: 'sale',
);
const _banner = LotseInAppMessage(
  id: 2,
  title: 'New in the shop',
  body: 'Have a look.',
  style: LotseInAppStyle.banner,
);

/// A server in memory: answers with [messages], records the events.
class _Server {
  List<LotseInAppMessage> messages = [];
  int fetches = 0;
  bool failing = false;
  Completer<void>? hold;

  /// `name messageId` per tracked event.
  final events = <String>[];

  Future<List<LotseInAppMessage>> fetch() async {
    fetches++;
    await hold?.future;
    if (failing) throw Exception('offline');
    return [...messages];
  }

  Future<void> track(String name, Map<String, String> props) async =>
      events.add('$name ${props['messageId']}');
}

void main() {
  group('LotseInAppInbox', () {
    late _Server server;
    late DateTime now;
    late LotseInAppInbox inbox;

    setUp(() {
      server = _Server();
      now = DateTime.utc(2026, 9, 25, 12);
      inbox = LotseInAppInbox(
        fetch: server.fetch,
        track: server.track,
        clock: () => now,
      );
    });

    test('shows the newest message and tracks the view once', () async {
      server.messages = [_card, _banner];
      await inbox.check();
      expect(inbox.current.value, _card);
      inbox.shown(_card);
      inbox.shown(_card);
      expect(server.events, ['in_app_view 1']);
    });

    test('checks at most once a minute unless forced', () async {
      await inbox.check();
      await inbox.check();
      expect(server.fetches, 1);
      now = now.add(const Duration(seconds: 59));
      await inbox.check();
      expect(server.fetches, 1);
      await inbox.check(force: true);
      expect(server.fetches, 2);
      now = now.add(lotseInAppFetchInterval);
      await inbox.check();
      expect(server.fetches, 3);
    });

    test('a tap tracks in_app_tap, closes the message, and the next one '
        'waits for the next check', () async {
      server.messages = [_card, _banner];
      await inbox.check();
      inbox.tapped(_card);
      expect(inbox.current.value, isNull);
      expect(server.events.last, 'in_app_tap 1');
      // The server has not seen the tap yet and still answers with it.
      await inbox.check(force: true);
      expect(inbox.current.value, _banner);
    });

    test('closing tracks in_app_dismiss and the message does not come '
        'again', () async {
      server.messages = [_banner];
      await inbox.check();
      inbox.dismissed(_banner);
      expect(server.events.last, 'in_app_dismiss 2');
      await inbox.check(force: true);
      expect(inbox.current.value, isNull);
    });

    test('a message that is shown stays until the user acts', () async {
      server.messages = [_banner];
      await inbox.check();
      server.messages = [_card, _banner];
      await inbox.check(force: true);
      expect(inbox.current.value, _banner);
    });

    test('a failing fetch shows nothing and throws nothing', () async {
      server.failing = true;
      await inbox.check();
      expect(inbox.current.value, isNull);
    });

    test('clear forgets the messages and drops an answer on its way', () async {
      server.messages = [_card];
      await inbox.check();
      inbox.dismissed(_card);
      inbox.clear();
      server.hold = Completer();
      final running = inbox.check();
      inbox.clear();
      server.hold!.complete();
      await running;
      expect(inbox.current.value, isNull);
      // The next identity sees the message it never closed.
      server.hold = null;
      await inbox.check();
      expect(inbox.current.value, _card);
    });

    test('the message of the server becomes the SDK\'s own type', () {
      final message = lotseInAppMessageFrom(
        generated.SdkInAppMessage(
          id: 7,
          title: 'T',
          body: 'B',
          style: generated.InAppMessageStyle.banner,
          buttonLabel: 'Go',
          targetPath: '/x',
          slug: 's',
        ),
      );
      expect(message.id, 7);
      expect(message.style, LotseInAppStyle.banner);
      expect(message.buttonLabel, 'Go');
      expect(message.targetPath, '/x');
      expect(message.slug, 's');
    });
  });

  group('LotseInAppHost', () {
    late _Server server;
    late LotseInAppInbox inbox;
    late List<LotseInAppMessage> tapped;

    setUp(() {
      server = _Server();
      inbox = LotseInAppInbox(fetch: server.fetch, track: server.track);
      tapped = [];
    });

    Future<void> pump(WidgetTester tester, {Locale? locale}) =>
        tester.pumpWidget(
          MaterialApp(
            locale: locale,
            supportedLocales: const [Locale('en'), Locale('de')],
            localizationsDelegates: const [
              _AnyMaterialLocalizations(),
              _AnyCupertinoLocalizations(),
              DefaultWidgetsLocalizations.delegate,
            ],
            builder: (context, child) =>
                LotseInAppHost(inbox: inbox, onTap: tapped.add, child: child!),
            home: const Scaffold(body: Text('App')),
          ),
        );

    testWidgets('a card shows title, text and "Open", and a tap hands the '
        'message to the app', (tester) async {
      server.messages = [_card];
      await inbox.check();
      await pump(tester);
      await tester.pump();
      expect(find.text('App'), findsOneWidget);
      expect(find.text('Spring sale'), findsOneWidget);
      expect(find.text('20 % off everything.'), findsOneWidget);
      expect(server.events, ['in_app_view 1']);

      await tester.tap(find.text('Open'));
      await tester.pump();
      expect(tapped, [_card]);
      expect(find.text('Spring sale'), findsNothing);
      expect(server.events.last, 'in_app_tap 1');
    });

    testWidgets('a card uses the button label of the team', (tester) async {
      server.messages = [
        const LotseInAppMessage(
          id: 3,
          title: 'T',
          body: 'B',
          style: LotseInAppStyle.card,
          buttonLabel: 'Shop now',
        ),
      ];
      await inbox.check();
      await pump(tester);
      expect(find.text('Shop now'), findsOneWidget);
      expect(find.text('Open'), findsNothing);
    });

    testWidgets('a banner closes on its icon without a tap', (tester) async {
      server.messages = [_banner];
      await inbox.check();
      await pump(tester);
      expect(find.text('New in the shop'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();
      expect(tapped, isEmpty);
      expect(find.text('New in the shop'), findsNothing);
      expect(server.events, ['in_app_view 2', 'in_app_dismiss 2']);
    });

    testWidgets('a German app reads "Öffnen"', (tester) async {
      server.messages = [_card];
      await inbox.check();
      await pump(tester, locale: const Locale('de'));
      expect(find.text('Öffnen'), findsOneWidget);
      expect(find.text('Open'), findsNothing);
    });

    testWidgets('tapping the banner itself hands it to the app', (
      tester,
    ) async {
      server.messages = [_banner];
      await inbox.check();
      await pump(tester);
      await tester.tap(find.text('New in the shop'));
      await tester.pump();
      expect(tapped, [_banner]);
    });

    testWidgets('without a message only the app shows', (tester) async {
      await pump(tester);
      expect(find.text('App'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('coming back to the front checks again', (tester) async {
      await pump(tester);
      expect(server.fetches, 0);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      expect(server.fetches, 1);
    });
  });

  testWidgets('LotseInAppMessages shows only the app before init', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => LotseInAppMessages(child: child!),
        home: const Text('App'),
      ),
    );
    expect(find.text('App'), findsOneWidget);
  });

  test('the public library exports only the SDK\'s own symbols', () {
    // dart test runs in the package root.
    final library = File('lib/lotse.dart').readAsStringSync();
    final exports = RegExp(
      r'^export [^;]+;',
      multiLine: true,
    ).allMatches(library).map((m) => m[0]!).toList();
    expect(exports, isNotEmpty);
    for (final export in exports) {
      expect(export, startsWith("export 'src/"));
      expect(export, contains(' show '));
    }
    expect(library, isNot(contains('lotse_client')));
    // Surveys are the SDK's business; LotseInAppMessages shows them.
    expect(library, isNot(contains('lotse_survey')));
    expect(
      exports.where((e) => e.contains('lotse_in_app')).join(),
      allOf(
        contains('LotseInAppMessage'),
        contains('LotseInAppStyle'),
        contains('LotseInAppMessages'),
        isNot(contains('LotseInAppInbox')),
        isNot(contains('LotseInAppHost')),
      ),
    );
  });
}

/// The English material and cupertino texts for every locale, so a German app can be
/// pumped without flutter_localizations.
class _AnyMaterialLocalizations
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _AnyMaterialLocalizations();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      SynchronousFuture(const DefaultMaterialLocalizations());

  @override
  bool shouldReload(_AnyMaterialLocalizations old) => false;
}

class _AnyCupertinoLocalizations
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _AnyCupertinoLocalizations();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture(const DefaultCupertinoLocalizations());

  @override
  bool shouldReload(_AnyCupertinoLocalizations old) => false;
}
