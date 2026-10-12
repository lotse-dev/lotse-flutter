import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lotse/src/lotse_screens.dart';

void main() {
  late List<String> screens;
  late LotseScreenObserver observer;

  setUp(() {
    screens = [];
    observer = LotseScreenObserver.withTracker(screens.add);
  });

  group('Given a plain navigator', () {
    Future<NavigatorState> pumpApp(WidgetTester tester) async {
      final key = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: key,
          navigatorObservers: [observer],
          initialRoute: 'home',
          onGenerateRoute: (settings) => MaterialPageRoute(
            settings: settings,
            builder: (_) => Text('${settings.name}'),
          ),
        ),
      );
      return key.currentState!;
    }

    testWidgets('when pages are pushed, replaced and popped then every '
        'visible page is reported', (tester) async {
      final navigator = await pumpApp(tester);
      navigator.pushNamed('products');
      await tester.pumpAndSettle();
      navigator.pushReplacementNamed('cart');
      await tester.pumpAndSettle();
      navigator.pop();
      await tester.pumpAndSettle();

      expect(screens, ['home', 'products', 'cart', 'home']);
    });

    testWidgets('when a dialog opens and closes then no screen is reported', (
      tester,
    ) async {
      final navigator = await pumpApp(tester);
      showDialog<void>(
        context: navigator.context,
        builder: (_) => const Text('dialog'),
      );
      await tester.pumpAndSettle();
      navigator.pop();
      await tester.pumpAndSettle();

      expect(screens, ['home']);
    });

    testWidgets('when a route has no name then it is skipped', (tester) async {
      final navigator = await pumpApp(tester);
      navigator.push(MaterialPageRoute<void>(builder: (_) => const Text('x')));
      await tester.pumpAndSettle();

      expect(screens, ['home']);
    });

    testWidgets('when a custom name is given then it decides, null skips', (
      tester,
    ) async {
      observer = LotseScreenObserver.withTracker(
        screens.add,
        screenName: (route) => route.settings.name == 'secret'
            ? null
            : 'app/${route.settings.name}',
      );
      final navigator = await pumpApp(tester);
      navigator.pushNamed('secret');
      await tester.pumpAndSettle();

      expect(screens, ['app/home']);
    });

    testWidgets('when a name is longer than the server takes then it is cut', (
      tester,
    ) async {
      final navigator = await pumpApp(tester);
      navigator.pushNamed('x' * 300);
      await tester.pumpAndSettle();

      expect(screens.last, hasLength(maxScreenNameLength));
    });
  });

  group('Given an observer that reports the screen on top', () {
    late ValueNotifier<String?> current;

    Future<NavigatorState> pumpApp(WidgetTester tester) async {
      current = ValueNotifier<String?>(null);
      addTearDown(current.dispose);
      final key = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: key,
          navigatorObservers: [
            LotseScreenObserver.withTracker((_) {}, current: current),
          ],
          initialRoute: 'home',
          onGenerateRoute: (settings) => MaterialPageRoute(
            settings: settings,
            builder: (_) => Text('${settings.name}'),
          ),
        ),
      );
      return key.currentState!;
    }

    testWidgets('when pages change then the top page is current', (
      tester,
    ) async {
      final navigator = await pumpApp(tester);
      expect(current.value, 'home');

      navigator.pushNamed('products');
      await tester.pumpAndSettle();
      expect(current.value, 'products');

      navigator.pushReplacementNamed('cart');
      await tester.pumpAndSettle();
      expect(current.value, 'cart');

      navigator.pop();
      await tester.pumpAndSettle();
      expect(current.value, 'home');
    });

    testWidgets('when a dialog is on top then there is no screen, after it '
        'the page is back', (tester) async {
      final navigator = await pumpApp(tester);
      showDialog<void>(
        context: navigator.context,
        builder: (_) => const Text('dialog'),
      );
      await tester.pumpAndSettle();
      expect(current.value, isNull);

      navigator.pop();
      await tester.pumpAndSettle();
      expect(current.value, 'home');
    });

    testWidgets('when a page without a name is on top then there is no '
        'screen', (tester) async {
      final navigator = await pumpApp(tester);
      navigator.push(MaterialPageRoute<void>(builder: (_) => const Text('x')));
      await tester.pumpAndSettle();
      expect(current.value, isNull);
    });

    testWidgets('when a page below the top is removed then the top stays', (
      tester,
    ) async {
      final navigator = await pumpApp(tester);
      navigator.pushNamed('products');
      await tester.pumpAndSettle();
      navigator.pushNamedAndRemoveUntil('cart', (route) => false);
      await tester.pumpAndSettle();
      expect(current.value, 'cart');
    });
  });

  testWidgets('Given go_router when navigating then routes are reported by '
      'name, or by path pattern without one', (tester) async {
    final router = GoRouter(
      observers: [observer],
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (_, _) => const Text('home'),
          routes: [
            GoRoute(
              path: 'products/:id',
              builder: (_, state) => Text('${state.pathParameters['id']}'),
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    router.go('/products/42');
    await tester.pumpAndSettle();

    expect(screens.first, 'home');
    expect(screens.last, 'products/:id');
    expect(screens, isNot(contains(contains('42'))));
  });
}
