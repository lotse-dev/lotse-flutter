import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/lotse_in_app.dart';
import 'package:lotse/src/lotse_in_app_view.dart';
import 'package:lotse/src/lotse_retake.dart';
import 'package:lotse/src/lotse_scope.dart';
import 'package:lotse/src/lotse_screens.dart';
import 'package:lotse/src/lotse_taps.dart';

final _navigatorKey = GlobalKey<NavigatorState>();

/// The test view is 800 × 600. On top a 100 px bar with a button and a
/// confidential box, below it a list of 100 px rows.
Widget _app() => LotseScope(
  child: MaterialApp(
    navigatorKey: _navigatorKey,
    navigatorObservers: [LotseScreenObserver.withTracker((_) {})],
    initialRoute: 'home',
    onGenerateRoute: (settings) => MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => Column(
        children: [
          SizedBox(
            height: 100,
            child: Row(
              children: [
                SizedBox(
                  width: 200,
                  child: TextButton(onPressed: () {}, child: const Text('buy')),
                ),
                const SizedBox(
                  width: 200,
                  child: LotseConfidential(child: Text('iban')),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 50,
              itemExtent: 100,
              itemBuilder: (_, i) => Text('row $i'),
            ),
          ),
        ],
      ),
    ),
  ),
);

/// A page that scrolls as a whole, like the demo's home: 200 px on top, then
/// a shrink-wrapped grid of two 300 px columns with a 100 px gap between them,
/// then more content.
Widget _pageApp() => LotseScope(
  child: MaterialApp(
    navigatorObservers: [LotseScreenObserver.withTracker((_) {})],
    initialRoute: 'catalog',
    onGenerateRoute: (settings) => MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 200),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 100,
              childAspectRatio: 350 / 200,
              padding: EdgeInsets.zero,
              children: [for (var i = 0; i < 6; i++) Text('item $i')],
            ),
            const SizedBox(height: 1000),
          ],
        ),
      ),
    ),
  ),
);

/// A home screen with an in-app message of [style] above it.
Future<void> _pumpWithMessage(
  WidgetTester tester,
  LotseInAppStyle style,
) async {
  final inbox = LotseInAppInbox(
    fetch: () async => [
      LotseInAppMessage(id: 1, title: 'Spring sale', body: '', style: style),
    ],
    track: (_, _) async {},
  );
  await inbox.check();
  await tester.pumpWidget(
    LotseScope(
      child: MaterialApp(
        navigatorObservers: [LotseScreenObserver.withTracker((_) {})],
        initialRoute: 'home',
        onGenerateRoute: (settings) => MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const SizedBox.expand(),
        ),
        builder: (context, child) =>
            LotseInAppHost(inbox: inbox, child: child!),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  late List<LotseTap> taps;

  setUp(() {
    taps = [];
    lotseTapSink = taps.add;
  });

  tearDown(() {
    lotseTapSink = null;
    lotseCurrentScreen.value = null;
  });

  testWidgets('when the user taps then the tap carries screen, position and '
      'viewport, outside a scroll view without scrollY', (tester) async {
    await tester.pumpWidget(_app());

    await tester.tapAt(const Offset(50, 40));

    final tap = taps.single;
    expect(tap.screen, 'home');
    expect((tap.x, tap.y), (50, 40));
    expect(tap.scrollY, isNull);
    expect((tap.viewportWidth, tap.viewportHeight), (800, 600));
    expect(tap.rage, isFalse);
  });

  testWidgets('when the list is scrolled then a tap in it carries the offset', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(taps, isEmpty, reason: 'a drag is no tap');

    await tester.tapAt(const Offset(400, 350));

    final tap = taps.single;
    expect(tap.scrollY, 300);
    expect(tap.y, 350);
  });

  testWidgets('when a page scrolls as a whole then a tap carries its offset, '
      'on a grid item and between the columns', (tester) async {
    await tester.pumpWidget(_pageApp());
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -250),
    );
    await tester.pumpAndSettle();

    // Item 2 lies at content y 400 to 600, on screen at 150 to 350.
    await tester.tapAt(const Offset(100, 200));
    // Between the columns, x 350 to 450.
    await tester.tapAt(const Offset(400, 200));

    expect(taps.map((t) => t.scrollY), [250, 250]);
  });

  testWidgets('when the page is not scrolled yet then a tap carries 0', (
    tester,
  ) async {
    await tester.pumpWidget(_pageApp());

    await tester.tapAt(const Offset(100, 300));

    expect(taps.single.scrollY, 0);
  });

  testWidgets('when an in-app card is tapped then the tap belongs to no '
      'screen', (tester) async {
    await _pumpWithMessage(tester, LotseInAppStyle.card);

    // On the card, and on the dimmed rest of the screen around it.
    await tester.tap(find.text('Spring sale'));
    await tester.tapAt(const Offset(10, 590));

    expect(taps, isEmpty);
  });

  testWidgets('when a banner is up then a tap beside it still belongs to the '
      'screen', (tester) async {
    await _pumpWithMessage(tester, LotseInAppStyle.banner);

    await tester.tap(find.text('Spring sale'));
    await tester.tapAt(const Offset(400, 500));

    expect(taps.map((t) => (t.screen, t.y)), [('home', 500)]);
  });

  testWidgets('when a confidential region is tapped then nothing is recorded', (
    tester,
  ) async {
    await tester.pumpWidget(_app());

    await tester.tapAt(const Offset(300, 50));

    expect(taps, isEmpty);
  });

  testWidgets('when a dialog is open then taps are not recorded', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    showDialog<void>(
      context: _navigatorKey.currentContext!,
      builder: (_) => const Text('dialog'),
    );
    await tester.pumpAndSettle();

    await tester.tapAt(const Offset(50, 40));

    expect(taps, isEmpty);
  });

  testWidgets('when the retake bar is up then a tap on it is no tap of the '
      'page below (F9)', (tester) async {
    await tester.pumpWidget(_app());
    final context = _navigatorKey.currentContext!;
    final retake = lotseCaptureControllerOf(context)!.retake;
    final choice = retake.request(
      LotseRetakeRequest(
        hint: 'hint',
        captureLabel: 'capture',
        cancelLabel: 'cancel',
        themes: InheritedTheme.capture(from: context, to: null),
        textDirection: TextDirection.ltr,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('capture'));
    await tester.pumpAndSettle();
    expect(await choice, LotseRetakeChoice.capture);

    expect(taps, isEmpty);
  });

  testWidgets('when a press is held then it is no tap', (tester) async {
    await tester.pumpWidget(_app());

    final gesture = await tester.startGesture(const Offset(50, 40));
    await tester.pump(const Duration(milliseconds: 600));
    // Test pointers carry the time stamps they are given, zero by default.
    await gesture.up(timeStamp: const Duration(milliseconds: 600));

    expect(taps, isEmpty);
  });

  testWidgets('when heatmaps are off then nothing is recorded', (tester) async {
    lotseTapSink = null;
    await tester.pumpWidget(_app());

    await tester.tapAt(const Offset(50, 40));

    expect(taps, isEmpty);
  });

  testWidgets('when the scope is gone then its pointer route is removed', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pumpWidget(const SizedBox());

    await tester.tapAt(const Offset(50, 40));

    expect(taps, isEmpty);
  });
}
