import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lotse/lotse.dart';
import 'package:lotse/src/lotse_feedback_opener.dart';

/// Pushes a page that names the conversation, like the SDK pushes the thread.
void _pushMarker(NavigatorState navigator, int feedbackId) => navigator.push(
  MaterialPageRoute<void>(
    builder: (context) => Scaffold(body: Text('Conversation $feedbackId')),
  ),
);

void main() {
  group('Given the opener of reply pushes', () {
    testWidgets('when the push is tapped while the app runs '
        'then the conversation opens on the app navigator', (tester) async {
      final key = GlobalKey<NavigatorState>();
      final opener = LotseFeedbackOpener()
        ..handler = _pushMarker
        ..attach(key);
      await tester.pumpWidget(
        MaterialApp(navigatorKey: key, home: const Text('Home')),
      );

      opener.open(12);
      await tester.pumpAndSettle();

      expect(find.text('Conversation 12'), findsOneWidget);
      expect(opener.pending, isNull);
    });

    testWidgets('when the push started the app '
        'then the conversation waits for handler and navigator', (
      tester,
    ) async {
      final key = GlobalKey<NavigatorState>();
      final opener = LotseFeedbackOpener()..open(12);
      expect(opener.pending, 12);

      opener.handler = _pushMarker;
      expect(opener.pending, 12);

      // The scope attaches its key while the navigator is not built yet.
      opener.attach(key);
      expect(opener.pending, 12);
      await tester.pumpWidget(
        MaterialApp(navigatorKey: key, home: const Text('Home')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Conversation 12'), findsOneWidget);
    });

    testWidgets('when two pushes are waiting then the later one opens', (
      tester,
    ) async {
      final key = GlobalKey<NavigatorState>();
      final opened = <int>[];
      final opener = LotseFeedbackOpener()
        ..open(12)
        ..open(13)
        ..handler = ((_, feedbackId) => opened.add(feedbackId))
        ..attach(key);
      await tester.pumpWidget(
        MaterialApp(navigatorKey: key, home: const Text('Home')),
      );
      await tester.pumpAndSettle();

      expect(opened, [13]);
      expect(opener.pending, isNull);
    });

    testWidgets('when the key never gets a navigator '
        'then the opener gives up instead of rendering forever', (
      tester,
    ) async {
      final opener = LotseFeedbackOpener()
        ..handler = _pushMarker
        ..attach(GlobalKey<NavigatorState>())
        ..open(12);
      await tester.pumpWidget(const SizedBox());

      // Would time out if frames kept being scheduled.
      await tester.pumpAndSettle();

      expect(opener.pending, isNull);
    });

    testWidgets('when the scope is gone then nothing is opened', (
      tester,
    ) async {
      final key = GlobalKey<NavigatorState>();
      final opened = <int>[];
      final opener = LotseFeedbackOpener()
        ..handler = ((_, feedbackId) => opened.add(feedbackId))
        ..attach(key)
        ..detach(key);
      await tester.pumpWidget(
        MaterialApp(navigatorKey: key, home: const Text('Home')),
      );

      opener.open(12);
      await tester.pumpAndSettle();

      expect(opened, isEmpty);
      expect(opener.pending, 12);
    });

    testWidgets('when the handler throws then the app is not disturbed', (
      tester,
    ) async {
      final key = GlobalKey<NavigatorState>();
      final opener = LotseFeedbackOpener()
        ..handler = ((_, _) => throw StateError('broken'))
        ..attach(key);
      await tester.pumpWidget(
        MaterialApp(navigatorKey: key, home: const Text('Home')),
      );

      opener.open(12);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Home'), findsOneWidget);
    });
  });

  group('Given a LotseScope with the navigator key of a go_router app', () {
    tearDown(lotseFeedbackOpener.reset);

    GoRouter router(GlobalKey<NavigatorState> key) => GoRouter(
      navigatorKey: key,
      initialLocation: '/offer',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const Text('Home')),
        GoRoute(
          path: '/offer',
          builder: (context, state) => const Text('Offer'),
        ),
      ],
    );

    testWidgets('when a reply push started the app '
        'then the conversation opens above the first route', (tester) async {
      final key = GlobalKey<NavigatorState>();
      lotseFeedbackOpener
        ..handler = _pushMarker
        ..open(12);

      await tester.pumpWidget(
        LotseScope(
          navigatorKey: key,
          child: MaterialApp.router(routerConfig: router(key)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Conversation 12'), findsOneWidget);

      // Leaving the conversation lands on the route the app started with.
      key.currentState!.pop();
      await tester.pumpAndSettle();
      expect(find.text('Offer'), findsOneWidget);
    });

    testWidgets('when a reply push is tapped while the app runs '
        'then the conversation opens above the current route', (tester) async {
      final key = GlobalKey<NavigatorState>();
      lotseFeedbackOpener.handler = _pushMarker;
      await tester.pumpWidget(
        LotseScope(
          navigatorKey: key,
          child: MaterialApp.router(routerConfig: router(key)),
        ),
      );
      await tester.pumpAndSettle();

      lotseFeedbackOpener.open(12);
      await tester.pumpAndSettle();

      expect(find.text('Conversation 12'), findsOneWidget);
    });

    testWidgets('when the scope has no key then a push opens nothing', (
      tester,
    ) async {
      final key = GlobalKey<NavigatorState>();
      final opened = <int>[];
      lotseFeedbackOpener.handler = (_, feedbackId) => opened.add(feedbackId);
      await tester.pumpWidget(
        LotseScope(child: MaterialApp.router(routerConfig: router(key))),
      );

      lotseFeedbackOpener.open(12);
      await tester.pumpAndSettle();

      expect(opened, isEmpty);
    });

    testWidgets('when the scope goes away then its key is forgotten', (
      tester,
    ) async {
      final key = GlobalKey<NavigatorState>();
      final opened = <int>[];
      lotseFeedbackOpener.handler = (_, feedbackId) => opened.add(feedbackId);
      await tester.pumpWidget(
        LotseScope(
          navigatorKey: key,
          child: MaterialApp.router(routerConfig: router(key)),
        ),
      );
      await tester.pumpWidget(MaterialApp.router(routerConfig: router(key)));

      lotseFeedbackOpener.open(12);
      await tester.pumpAndSettle();

      expect(opened, isEmpty);
    });
  });
}
