import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/lotse_launch_links.dart';

/// Stands in for a router: hears route pushes once it is registered.
class _Router with WidgetsBindingObserver {
  final heard = <String>[];

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) {
    heard.add(routeInformation.uri.toString());
    return Future.value(true);
  }
}

/// Sends a route push the way the engine does when a link reopens the app.
Future<void> _platformPush(WidgetTester tester, String location) =>
    tester.binding.defaultBinaryMessenger.handlePlatformMessage(
      SystemChannels.navigation.name,
      SystemChannels.navigation.codec.encodeMethodCall(
        MethodCall('pushRouteInformation', <String, Object?>{
          'location': location,
          'state': null,
        }),
      ),
      (_) {},
    );

/// Builds the first frame and lets the handed-on push reach the observers.
Future<void> _firstFrame(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.runAsync(() => Future<void>.delayed(Duration.zero));
  await tester.pump();
}

void main() {
  testWidgets('a link pushed before the router exists reaches it after the '
      'first frame', (tester) async {
    LotseLaunchLinks.start(tester.binding);
    await _platformPush(tester, 'https://demo.lotse.dev/l/launch');

    final router = _Router();
    tester.binding.addObserver(router);
    addTearDown(() => tester.binding.removeObserver(router));
    await _firstFrame(tester);

    expect(router.heard, ['https://demo.lotse.dev/l/launch']);
  });

  testWidgets('of several early links only the newest is handed on', (
    tester,
  ) async {
    LotseLaunchLinks.start(tester.binding);
    await _platformPush(tester, '/l/first');
    await _platformPush(tester, '/l/second');

    final router = _Router();
    tester.binding.addObserver(router);
    addTearDown(() => tester.binding.removeObserver(router));
    await _firstFrame(tester);

    expect(router.heard, ['/l/second']);
  });

  testWidgets('without an early link nothing is pushed', (tester) async {
    LotseLaunchLinks.start(tester.binding);
    final router = _Router();
    tester.binding.addObserver(router);
    addTearDown(() => tester.binding.removeObserver(router));
    await _firstFrame(tester);

    expect(router.heard, isEmpty);
  });

  testWidgets('a link after the first frame goes straight to the router', (
    tester,
  ) async {
    LotseLaunchLinks.start(tester.binding);
    final router = _Router();
    tester.binding.addObserver(router);
    addTearDown(() => tester.binding.removeObserver(router));
    await _firstFrame(tester);

    await _platformPush(tester, '/l/later');

    expect(router.heard, ['/l/later']);
  });

  testWidgets('a second start before the first frame keeps one capture', (
    tester,
  ) async {
    LotseLaunchLinks.start(tester.binding);
    LotseLaunchLinks.start(tester.binding);
    await _platformPush(tester, '/l/once');

    final router = _Router();
    tester.binding.addObserver(router);
    addTearDown(() => tester.binding.removeObserver(router));
    await _firstFrame(tester);

    expect(router.heard, ['/l/once']);
  });
}
