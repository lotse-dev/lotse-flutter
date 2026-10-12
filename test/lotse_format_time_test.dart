import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/lotse.dart';
import 'package:lotse/src/lotse_my_feedback_page.dart';

final _time = DateTime(2026, 9, 24, 19, 50);

/// Material texts of an app localized for German; only the date is marked,
/// so a test sees whether the app's localizations were used.
class _GermanAppLocalizations extends DefaultMaterialLocalizations {
  const _GermanAppLocalizations();

  @override
  String formatShortDate(DateTime date) => 'app date';
}

class _GermanAppDelegate extends LocalizationsDelegate<MaterialLocalizations> {
  const _GermanAppDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'de';

  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      SynchronousFuture(const _GermanAppLocalizations());

  @override
  bool shouldReload(_GermanAppDelegate old) => false;
}

/// MaterialApp also asks for Cupertino texts in German.
class _GermanCupertinoDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _GermanCupertinoDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'de';

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture(const DefaultCupertinoLocalizations());

  @override
  bool shouldReload(_GermanCupertinoDelegate old) => false;
}

/// Formats [_time] with [texts] inside an app and returns the text.
Future<String> _format(
  WidgetTester tester,
  LotseFeedbackTexts texts, {
  bool germanApp = false,
}) async {
  late String result;
  await tester.pumpWidget(
    MaterialApp(
      locale: germanApp ? const Locale('de') : null,
      supportedLocales: germanApp
          ? const [Locale('de')]
          : const [Locale('en', 'US')],
      localizationsDelegates: germanApp
          ? const [
              _GermanAppDelegate(),
              _GermanCupertinoDelegate(),
              DefaultWidgetsLocalizations.delegate,
            ]
          : null,
      home: Builder(
        builder: (context) {
          result = lotseFormatTime(context, texts, _time);
          return const SizedBox();
        },
      ),
    ),
  );
  return result;
}

void main() {
  group('Given a time in the conversations', () {
    testWidgets('when the texts are German and the app is not localized '
        'then the date is German anyway', (tester) async {
      expect(
        await _format(tester, LotseFeedbackTexts.german),
        '24. Sept. 2026, 19:50',
      );
    });

    testWidgets('when the texts are English and the app is not localized '
        'then the date is English', (tester) async {
      expect(
        await _format(tester, LotseFeedbackTexts.english),
        'Sep 24, 2026, 7:50 PM',
      );
    });

    testWidgets('when the app is localized for the language of the texts '
        "then the app's format is used", (tester) async {
      expect(
        await _format(tester, LotseFeedbackTexts.german, germanApp: true),
        'app date, 7:50 PM',
      );
    });

    testWidgets('when the texts are English and the app is German '
        'then the date stays English like the texts', (tester) async {
      expect(
        await _format(tester, LotseFeedbackTexts.english, germanApp: true),
        'Sep 24, 2026, 7:50 PM',
      );
    });

    test('when a German time has one digit then it is padded like a clock', () {
      expect(
        lotseGermanTime(DateTime(2026, 1, 5, 7, 3)),
        '5. Jan. 2026, 07:03',
      );
    });

    test('when an app overrides a text then the language stays', () {
      expect(LotseFeedbackTexts.german.copyWith(title: 'x').languageCode, 'de');
      expect(LotseFeedbackTexts.english.languageCode, 'en');
    });
  });
}
