import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/lotse.dart';
import 'package:lotse/src/lotse_annotation.dart';
import 'package:lotse/src/lotse_annotation_editor.dart';
import 'package:lotse/src/lotse_capture.dart';
import 'package:lotse/src/lotse_feedback.dart';
import 'package:lotse/src/lotse_feedback_sheet.dart';
import 'package:lotse/src/lotse_replay_recorder.dart';
import 'package:lotse/src/lotse_scope.dart';

const _red = Color(0xFFFF0000);
const _blue = Color(0xFF0000FF);
const _seed = Color(0xFF00695C);

/// Records the drafts it gets and answers with [results] in order, then with
/// `sent`. With [gate] set, every answer waits for it.
class _FakeSender {
  _FakeSender({List<LotseFeedbackSendResult> results = const [], this.gate})
    : _results = [...results];

  final List<LotseFeedbackSendResult> _results;
  final Completer<void>? gate;
  final drafts = <LotseFeedbackDraft>[];

  Future<LotseFeedbackSendResult> call(LotseFeedbackDraft draft) async {
    drafts.add(draft);
    await gate?.future;
    return _results.isEmpty
        ? LotseFeedbackSendResult.sent
        : _results.removeAt(0);
  }
}

/// A red screen on the route `/cart` with a button that opens the sheet, and
/// a blue one on `/other` to go to for a retake.
Widget _app(
  _FakeSender sender, {
  bool askForEmail = false,
  LotseFeedbackTexts? texts,
  Map<String, String>? metadata,
}) => MaterialApp(
  theme: ThemeData(colorSchemeSeed: _seed),
  initialRoute: '/cart',
  routes: {
    '/cart': (context) => Scaffold(
      backgroundColor: _red,
      body: Align(
        alignment: Alignment.topLeft,
        child: TextButton(
          onPressed: () => showLotseFeedbackSheet(
            context,
            send: sender.call,
            askForEmail: askForEmail,
            texts: texts,
            metadata: metadata,
          ),
          child: const Text('open'),
        ),
      ),
    ),
    '/other': (context) => const Scaffold(backgroundColor: _blue),
  },
);

/// Taps "Retake" and pumps until the sheet is gone and the bar is there.
/// The flow of the sheet runs in real async since `_tapAndAwaitSheet`, so
/// this waits in real async too.
Future<void> _retake(WidgetTester tester) async {
  await tester.runAsync(() async {
    await tester.tap(find.text('Retake'));
    for (var i = 0; i < 100; i++) {
      await tester.pump(const Duration(milliseconds: 50));
      await Future<void>.delayed(const Duration(milliseconds: 5));
      if (find.byType(LotseFeedbackSheet).evaluate().isEmpty &&
          find.text('Take screenshot').evaluate().length == 1 &&
          !tester.binding.hasScheduledFrame) {
        return;
      }
    }
    fail('The retake bar did not show.');
  });
}

/// Taps [finder] and pumps until the sheet is on screen and at rest. A capture
/// waits for a frame and rasterizes in real async, which a plain
/// `pumpAndSettle` never gives it.
Future<void> _tapAndAwaitSheet(WidgetTester tester, Finder finder) async {
  await tester.runAsync(() async {
    await tester.tap(finder);
    for (var i = 0; i < 100; i++) {
      await tester.pump(const Duration(milliseconds: 50));
      await Future<void>.delayed(const Duration(milliseconds: 5));
      final sheet = find.byType(LotseFeedbackSheet);
      if (sheet.evaluate().length == 1 &&
          find.text('open').hitTestable().evaluate().isEmpty &&
          !tester.binding.hasScheduledFrame) {
        return;
      }
    }
    fail('The feedback sheet did not open.');
  });
}

/// The colour of [png] at the relative position ([dx], [dy]).
Future<Color> _colorAt(
  WidgetTester tester,
  Uint8List png,
  double dx,
  double dy,
) async {
  final color = await tester.runAsync(() async {
    final codec = await ui.instantiateImageCodec(png);
    final image = (await codec.getNextFrame()).image;
    final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    final x = (image.width * dx).floor();
    final y = (image.height * dy).floor();
    final offset = (y * image.width + x) * 4;
    image.dispose();
    return Color.fromARGB(
      data!.getUint8(offset + 3),
      data.getUint8(offset),
      data.getUint8(offset + 1),
      data.getUint8(offset + 2),
    );
  });
  return color!;
}

/// Draws a horizontal line across the editor at the relative height [dy],
/// taps "Done" and pumps until the editor is gone. Merging decodes and
/// encodes in real async, like a capture.
Future<void> _markAndAwaitSheet(WidgetTester tester, double dy) async {
  final canvas = tester.getRect(
    find.descendant(
      of: find.byType(LotseAnnotationEditor),
      matching: find.byType(AspectRatio),
    ),
  );
  final y = canvas.top + canvas.height * dy;
  final gesture = await tester.startGesture(Offset(canvas.left + 20, y));
  await gesture.moveTo(Offset(canvas.right - 20, y));
  await gesture.up();
  await tester.pump();
  await _tapAndAwaitEditorGone(tester, find.text('Done'));
}

Future<void> _tapAndAwaitEditorGone(WidgetTester tester, Finder finder) async {
  await tester.runAsync(() async {
    await tester.tap(finder);
    for (var i = 0; i < 100; i++) {
      await tester.pump(const Duration(milliseconds: 50));
      await Future<void>.delayed(const Duration(milliseconds: 5));
      if (find.byType(LotseAnnotationEditor).evaluate().isEmpty &&
          !tester.binding.hasScheduledFrame) {
        return;
      }
    }
    fail('The annotation editor did not close.');
  });
}

/// The size of [png] in pixels.
Future<(int, int)> _sizeOf(WidgetTester tester, Uint8List png) async {
  final size = await tester.runAsync(() async {
    final codec = await ui.instantiateImageCodec(png);
    final image = (await codec.getNextFrame()).image;
    final size = (image.width, image.height);
    image.dispose();
    return size;
  });
  return size!;
}

void main() {
  group('Given an app without a LotseScope', () {
    testWidgets('when the sheet opens '
        'then it has chips, a message field and a disabled send button, but '
        'no screenshot and no e-mail field', (tester) async {
      await tester.pumpWidget(_app(_FakeSender()));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Send feedback'), findsOneWidget);
      for (final chip in ['Bug', 'Idea', 'Praise', 'Other']) {
        expect(find.widgetWithText(ChoiceChip, chip), findsOneWidget);
      }
      // A question opens a support chat, not a feedback message.
      expect(find.widgetWithText(ChoiceChip, 'Question'), findsNothing);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(Image), findsNothing);
      expect(find.text('Retake'), findsNothing);
      expect(find.text('Remove'), findsNothing);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
    });

    testWidgets('when feedback is sent '
        'then the draft carries category, text, route name and metadata, and '
        'the sheet confirms and closes', (tester) async {
      final sender = _FakeSender();
      await tester.pumpWidget(_app(sender, metadata: {'cart': '3 items'}));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Idea'));
      await tester.enterText(find.byType(TextField), ' Dark mode please ');
      await tester.pump();
      await tester.tap(find.text('Send'));
      await tester.pumpAndSettle();

      final draft = sender.drafts.single;
      expect(draft.category, LotseFeedbackCategory.idea);
      expect(draft.message, 'Dark mode please');
      expect(draft.lastScreen, '/cart');
      expect(draft.metadata, {'cart': '3 items'});
      expect(draft.contactEmail, isNull);
      expect(draft.screenshot, isNull);
      expect(find.text('Thank you'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.byType(LotseFeedbackSheet), findsNothing);
    });

    testWidgets('when sending is under way '
        'then the button shows progress and the fields are locked', (
      tester,
    ) async {
      final sender = _FakeSender(gate: Completer<void>());
      await tester.pumpWidget(_app(sender));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Hello');
      await tester.pump();

      await tester.tap(find.text('Send'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );

      sender.gate!.complete();
      await tester.pumpAndSettle();
      expect(find.text('Thank you'), findsOneWidget);
    });

    testWidgets('when sending fails '
        'then the error shows, everything typed is still there and retry '
        'sends it', (tester) async {
      final sender = _FakeSender(results: [LotseFeedbackSendResult.failed]);
      await tester.pumpWidget(_app(sender, askForEmail: true));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Praise'));
      await tester.enterText(find.byType(TextField).first, 'Nice app');
      await tester.enterText(find.byType(TextField).last, 'ada@example.com');
      await tester.pump();
      await tester.tap(find.text('Send'));
      await tester.pumpAndSettle();

      expect(find.text(LotseFeedbackTexts.english.sendFailed), findsOneWidget);
      expect(find.text('Nice app'), findsOneWidget);
      expect(find.text('ada@example.com'), findsOneWidget);
      expect(
        tester
            .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Praise'))
            .selected,
        isTrue,
      );
      expect(find.text('Send'), findsNothing);

      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();

      expect(find.text('Thank you'), findsOneWidget);
      expect(sender.drafts, hasLength(2));
      expect(sender.drafts.last.category, LotseFeedbackCategory.praise);
      expect(sender.drafts.last.message, 'Nice app');
      expect(sender.drafts.last.contactEmail, 'ada@example.com');
    });

    testWidgets('when the quota is used up then the sheet says so', (
      tester,
    ) async {
      final sender = _FakeSender(
        results: [LotseFeedbackSendResult.limitReached],
      );
      await tester.pumpWidget(_app(sender));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Hello');
      await tester.pump();
      await tester.tap(find.text('Send'));
      await tester.pumpAndSettle();

      expect(
        find.text(LotseFeedbackTexts.english.limitReached),
        findsOneWidget,
      );
    });

    testWidgets('when askForEmail is on '
        'then a malformed address shows an error and blocks sending', (
      tester,
    ) async {
      await tester.pumpWidget(_app(_FakeSender(), askForEmail: true));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsNWidgets(2));
      await tester.enterText(find.byType(TextField).first, 'Hello');
      await tester.enterText(find.byType(TextField).last, 'ada@');
      await tester.pump();

      expect(find.text('This is not an e-mail address.'), findsOneWidget);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
    });

    testWidgets('when the device locale is German '
        'then the sheet is German', (tester) async {
      tester.platformDispatcher.localeTestValue = const Locale('de', 'DE');
      addTearDown(tester.platformDispatcher.clearLocaleTestValue);
      await tester.pumpWidget(_app(_FakeSender()));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Feedback senden'), findsOneWidget);
      expect(find.text('Fehler'), findsOneWidget);
      expect(find.text('Senden'), findsOneWidget);
    });

    testWidgets('when the app passes its own texts '
        'then they win over the locale', (tester) async {
      tester.platformDispatcher.localeTestValue = const Locale('de', 'DE');
      addTearDown(tester.platformDispatcher.clearLocaleTestValue);
      await tester.pumpWidget(
        _app(
          _FakeSender(),
          texts: LotseFeedbackTexts.english.copyWith(title: 'Tell us'),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Tell us'), findsOneWidget);
      expect(find.text('Send'), findsOneWidget);
    });

    testWidgets('when the sheet opens then it uses the theme of the app', (
      tester,
    ) async {
      await tester.pumpWidget(_app(_FakeSender()));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      final theme = Theme.of(tester.element(find.byType(LotseFeedbackSheet)));
      expect(
        theme.colorScheme.primary,
        ThemeData(colorSchemeSeed: _seed).colorScheme.primary,
      );
    });

    testWidgets('when there is no navigator '
        'then nothing is thrown and nothing is sent', (tester) async {
      final sender = _FakeSender();
      late BuildContext outside;
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            outside = context;
            return const SizedBox();
          },
        ),
      );

      await showLotseFeedbackSheet(outside, send: sender.call);

      expect(sender.drafts, isEmpty);
    });
  });

  group('Given replays on and an app inside a LotseScope', () {
    setUp(() => lotseReplayOptions = const LotseReplayOptions(seconds: 30));
    tearDown(() => lotseReplayOptions = null);

    testWidgets('when the sheet is open then the recorder rests, the sheet '
        'offers the recording, and it goes with the message', (tester) async {
      final sender = _FakeSender();
      await tester.pumpWidget(LotseScope(child: _app(sender)));
      final recorder = lotseReplayRecorderOf(
        tester.element(find.text('open')),
      )!;
      // The first frame becomes a keyframe in real async.
      await tester.runAsync(() async {
        for (var i = 0; i < 20 && recorder.buffer.isEmpty; i++) {
          await Future<void>.delayed(const Duration(milliseconds: 20));
          await tester.pump();
        }
      });
      expect(recorder.buffer.isEmpty, isFalse);

      await _tapAndAwaitSheet(tester, find.text('open'));

      expect(recorder.recording, isFalse);
      expect(find.text('Attach the last 30 seconds'), findsOneWidget);
      expect(
        tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value,
        isTrue,
      );

      await tester.enterText(find.byType(TextField), 'Broken');
      await tester.pump();
      // The switch makes the sheet taller than the test view.
      await tester.ensureVisible(find.text('Send'));
      await tester.tap(find.text('Send'));
      await tester.pumpAndSettle();
      expect(sender.drafts.single.replay, isNotEmpty);

      await tester.ensureVisible(find.text('Close'));
      await tester.tap(find.text('Close'));
      // The flow of the sheet runs in real async since it opened.
      await tester.runAsync(() async {
        for (var i = 0; i < 50 && !recorder.recording; i++) {
          await tester.pump(const Duration(milliseconds: 50));
          await Future<void>.delayed(const Duration(milliseconds: 5));
        }
      });
      expect(recorder.recording, isTrue);

      // Disposes the recorder and its timers before the test checks them.
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('when the switch is turned off then the message goes alone', (
      tester,
    ) async {
      final sender = _FakeSender();
      await tester.pumpWidget(LotseScope(child: _app(sender)));
      final recorder = lotseReplayRecorderOf(
        tester.element(find.text('open')),
      )!;
      await tester.runAsync(() async {
        for (var i = 0; i < 20 && recorder.buffer.isEmpty; i++) {
          await Future<void>.delayed(const Duration(milliseconds: 20));
          await tester.pump();
        }
      });

      await _tapAndAwaitSheet(tester, find.text('open'));
      await tester.ensureVisible(find.byType(SwitchListTile));
      await tester.tap(find.byType(SwitchListTile));
      await tester.enterText(find.byType(TextField), 'Broken');
      await tester.pump();
      // The switch makes the sheet taller than the test view.
      await tester.ensureVisible(find.text('Send'));
      await tester.tap(find.text('Send'));
      await tester.pumpAndSettle();

      expect(sender.drafts.single.replay, isNull);
      await tester.pumpWidget(const SizedBox());
    });
  });

  group('Given an app inside a LotseScope', () {
    testWidgets('when the sheet opens '
        'then the screenshot was taken before it: the preview is there and '
        'the sent image shows the app, not the sheet', (tester) async {
      final sender = _FakeSender();
      await tester.pumpWidget(LotseScope(child: _app(sender)));

      await _tapAndAwaitSheet(tester, find.text('open'));

      expect(find.byType(Image), findsOneWidget);
      expect(find.text('Retake'), findsOneWidget);
      expect(find.text('Mark'), findsOneWidget);
      expect(find.text('Remove'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Broken');
      await tester.pump();
      await tester.tap(find.text('Send'));
      await tester.pumpAndSettle();

      final png = sender.drafts.single.screenshot!;
      // The sheet covers the lower part of the screen; the app is red there.
      expect(await _colorAt(tester, png, 0.5, 0.9), _red);
    });

    testWidgets('when the screenshot is removed '
        'then the preview is gone and the message goes without it', (
      tester,
    ) async {
      final sender = _FakeSender();
      await tester.pumpWidget(LotseScope(child: _app(sender)));
      await _tapAndAwaitSheet(tester, find.text('open'));

      await tester.tap(find.text('Remove'));
      await tester.pump();

      expect(find.byType(Image), findsNothing);
      expect(find.text('Mark'), findsNothing);
      expect(find.text('Remove'), findsNothing);
      expect(find.text('Retake'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Broken');
      await tester.pump();
      await tester.tap(find.text('Send'));
      await tester.pumpAndSettle();
      expect(sender.drafts.single.screenshot, isNull);
    });

    testWidgets('when the screenshot is retaken '
        'then the sheet comes back with everything typed and an image of the '
        'app without the sheet', (tester) async {
      final sender = _FakeSender();
      await tester.pumpWidget(
        LotseScope(child: _app(sender, askForEmail: true)),
      );
      await _tapAndAwaitSheet(tester, find.text('open'));

      await tester.tap(find.text('Idea'));
      await tester.enterText(find.byType(TextField).first, 'Dark mode please');
      await tester.enterText(find.byType(TextField).last, 'ada@example.com');
      await tester.pump();
      await tester.tap(find.text('Remove'));
      await tester.pump();

      await _retake(tester);
      await _tapAndAwaitSheet(tester, find.text('Take screenshot'));

      expect(find.text('Take screenshot'), findsNothing);
      expect(find.byType(Image), findsOneWidget);
      expect(find.text('Dark mode please'), findsOneWidget);
      expect(find.text('ada@example.com'), findsOneWidget);
      expect(
        tester
            .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Idea'))
            .selected,
        isTrue,
      );

      // With preview and e-mail field the form is taller than the test view.
      await tester.ensureVisible(find.text('Send'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Send'));
      await tester.pumpAndSettle();

      final draft = sender.drafts.single;
      expect(draft.message, 'Dark mode please');
      for (final dy in [0.3, 0.6, 0.9]) {
        expect(await _colorAt(tester, draft.screenshot!, 0.5, dy), _red);
      }
    });

    testWidgets('when the user goes to another screen for the retake '
        'then the screenshot shows that screen without the bar and the '
        'feedback names it', (tester) async {
      final sender = _FakeSender();
      await tester.pumpWidget(LotseScope(child: _app(sender)));
      await _tapAndAwaitSheet(tester, find.text('open'));
      await tester.enterText(find.byType(TextField), 'Wrong colour');
      await tester.pump();

      await _retake(tester);
      tester.state<NavigatorState>(find.byType(Navigator)).pushNamed('/other');
      await tester.pumpAndSettle();
      // The bar is still there on the new screen.
      expect(find.text('Take screenshot'), findsOneWidget);
      final bar = tester.getRect(find.text('Take screenshot'));
      await _tapAndAwaitSheet(tester, find.text('Take screenshot'));

      expect(find.text('Wrong colour'), findsOneWidget);
      await tester.tap(find.text('Send'));
      await tester.pumpAndSettle();

      final draft = sender.drafts.single;
      expect(draft.lastScreen, '/other');
      final view = tester.view.physicalSize / tester.view.devicePixelRatio;
      expect(
        await _colorAt(
          tester,
          draft.screenshot!,
          bar.center.dx / view.width,
          bar.center.dy / view.height,
        ),
        _blue,
      );
      expect(await _colorAt(tester, draft.screenshot!, 0.5, 0.3), _blue);
    });

    testWidgets('when the retake is cancelled then the sheet comes back with '
        'the screenshot it had', (tester) async {
      final sender = _FakeSender();
      await tester.pumpWidget(LotseScope(child: _app(sender)));
      await _tapAndAwaitSheet(tester, find.text('open'));
      final before = tester
          .widget<LotseFeedbackSheet>(find.byType(LotseFeedbackSheet))
          .controller
          .screenshot!;

      await _retake(tester);
      tester.state<NavigatorState>(find.byType(Navigator)).pushNamed('/other');
      await tester.pumpAndSettle();
      await _tapAndAwaitSheet(tester, find.text('Cancel'));

      expect(find.text('Take screenshot'), findsNothing);
      final sheet = tester.widget<LotseFeedbackSheet>(
        find.byType(LotseFeedbackSheet),
      );
      expect(sheet.controller.screenshot!.png, same(before.png));
      expect(sheet.controller.lastScreen, '/cart');
    });

    testWidgets('when the bar is dragged then it moves with the finger and '
        'stays on the screen', (tester) async {
      await tester.pumpWidget(LotseScope(child: _app(_FakeSender())));
      await _tapAndAwaitSheet(tester, find.text('open'));
      await _retake(tester);

      final hint = find.text('Go to the screen you mean');
      final start = tester.getRect(hint);
      await tester.drag(hint, const Offset(-40, -200));
      await tester.pump();
      final moved = tester.getRect(hint);
      expect(moved.top, closeTo(start.top - 200, 1));
      expect(moved.left, closeTo(start.left - 40, 1));

      await tester.drag(hint, const Offset(-5000, -5000));
      await tester.pump();
      final bar = tester.getRect(
        find.ancestor(of: hint, matching: find.byType(Material)).first,
      );
      expect(bar.left, 0);
      expect(bar.top, 0);

      // The buttons still work where the bar was dragged to.
      await _tapAndAwaitSheet(tester, find.text('Take screenshot'));
      expect(find.byType(LotseFeedbackSheet), findsOneWidget);

      // The next retake starts where the bar was left.
      await _retake(tester);
      final again = tester.getRect(
        find.ancestor(of: hint, matching: find.byType(Material)).first,
      );
      expect(again.topLeft, bar.topLeft);
    });

    testWidgets('when the screenshot is marked '
        'then the sent image has the same size, shows the pen where the user '
        'drew and the app everywhere else', (tester) async {
      final sender = _FakeSender();
      await tester.pumpWidget(LotseScope(child: _app(sender)));
      await _tapAndAwaitSheet(tester, find.text('open'));
      final sheet = tester.widget<LotseFeedbackSheet>(
        find.byType(LotseFeedbackSheet),
      );
      final captured = sheet.controller.screenshot!;

      await tester.tap(find.text('Mark'));
      await tester.pumpAndSettle();
      expect(find.byType(LotseAnnotationEditor), findsOneWidget);
      await _markAndAwaitSheet(tester, 0.75);

      expect(find.byType(LotseFeedbackSheet), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Look here');
      await tester.pump();
      await tester.tap(find.text('Send'));
      await tester.pumpAndSettle();

      final png = sender.drafts.single.screenshot!;
      expect(png, isNot(equals(captured.png)));
      expect(png.lengthInBytes, lessThanOrEqualTo(maxScreenshotBytes));
      expect(await _sizeOf(tester, png), (captured.width, captured.height));
      expect(await _colorAt(tester, png, 0.5, 0.75), lotseAnnotationColor);
      expect(await _colorAt(tester, png, 0.5, 0.9), _red);
    });

    testWidgets('when the editor is opened again and the mark is undone '
        'then the screenshot goes out as it was captured', (tester) async {
      final sender = _FakeSender();
      await tester.pumpWidget(LotseScope(child: _app(sender)));
      await _tapAndAwaitSheet(tester, find.text('open'));
      final sheet = tester.widget<LotseFeedbackSheet>(
        find.byType(LotseFeedbackSheet),
      );
      final captured = sheet.controller.screenshot!;
      await tester.tap(find.text('Mark'));
      await tester.pumpAndSettle();
      await _markAndAwaitSheet(tester, 0.75);
      expect(sheet.controller.screenshot, isNot(same(captured)));

      await tester.tap(find.text('Mark'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Undo'));
      await tester.pump();
      await _tapAndAwaitEditorGone(tester, find.text('Done'));

      await tester.enterText(find.byType(TextField), 'Never mind');
      await tester.pump();
      await tester.tap(find.text('Send'));
      await tester.pumpAndSettle();
      expect(sender.drafts.single.screenshot, same(captured.png));
    });

    testWidgets('when the editor is cancelled then the screenshot stays', (
      tester,
    ) async {
      final sender = _FakeSender();
      await tester.pumpWidget(LotseScope(child: _app(sender)));
      await _tapAndAwaitSheet(tester, find.text('open'));
      final sheet = tester.widget<LotseFeedbackSheet>(
        find.byType(LotseFeedbackSheet),
      );
      final captured = sheet.controller.screenshot!;

      await tester.tap(find.text('Mark'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(LotseFeedbackSheet), findsOneWidget);
      expect(sheet.controller.screenshot, same(captured));
      expect(sheet.controller.strokes, isEmpty);
    });
  });

  group('Given a sheet whose capture failed', () {
    Future<LotseFeedbackController> pumpSheet(
      WidgetTester tester,
      LotseCaptureFailure failure,
    ) async {
      final controller = LotseFeedbackController(_FakeSender().call)
        ..applyCapture(LotseCaptureFailed(failure));
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LotseFeedbackSheet(
              controller: controller,
              texts: LotseFeedbackTexts.english,
              canRetake: true,
            ),
          ),
        ),
      );
      return controller;
    }

    testWidgets('when rendering failed '
        'then the sheet explains it instead of skipping the screenshot '
        'silently, and sending still works', (tester) async {
      final controller = await pumpSheet(
        tester,
        LotseCaptureFailure.renderFailed,
      );

      expect(
        find.text(LotseFeedbackTexts.english.captureRenderFailed),
        findsOneWidget,
      );
      expect(find.byType(Image), findsNothing);
      expect(find.text('Retake'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'The map is broken');
      await tester.pump();
      expect(controller.canSend, isTrue);
    });

    testWidgets('when the image stayed too large then the sheet says so', (
      tester,
    ) async {
      await pumpSheet(tester, LotseCaptureFailure.tooLarge);

      expect(
        find.text(LotseFeedbackTexts.english.captureTooLarge),
        findsOneWidget,
      );
    });

    testWidgets('when there was no boundary then nothing is explained', (
      tester,
    ) async {
      await pumpSheet(tester, LotseCaptureFailure.noBoundary);

      expect(find.textContaining('screenshot'), findsNothing);
    });
  });
}
