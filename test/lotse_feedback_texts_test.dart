import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/lotse.dart';

void main() {
  group('Given the built-in feedback texts', () {
    test('when the locale is German then the German texts are picked', () {
      expect(
        LotseFeedbackTexts.forLocale(const Locale('de', 'AT')),
        same(LotseFeedbackTexts.german),
      );
    });

    test('when the locale is anything else then English is picked', () {
      for (final locale in const [
        Locale('en', 'US'),
        Locale('fr'),
        Locale('ja'),
      ]) {
        expect(
          LotseFeedbackTexts.forLocale(locale),
          same(LotseFeedbackTexts.english),
        );
      }
    });

    test('when the retake bar is shown then both languages have its texts', () {
      for (final texts in [
        LotseFeedbackTexts.english,
        LotseFeedbackTexts.german,
      ]) {
        expect(texts.retakeHint, isNotEmpty);
        expect(texts.retakeCapture, isNotEmpty);
        expect(texts.retakeCancel, isNotEmpty);
      }
      expect(LotseFeedbackTexts.german.retakeCapture, 'Screenshot aufnehmen');
      final texts = LotseFeedbackTexts.german.copyWith(retakeCancel: 'Zurück');
      expect(texts.retakeCancel, 'Zurück');
      expect(texts.retakeCapture, LotseFeedbackTexts.german.retakeCapture);
    });

    test('when an app overrides one text then the others stay', () {
      final texts = LotseFeedbackTexts.german.copyWith(title: 'Sag uns was');

      expect(texts.title, 'Sag uns was');
      expect(texts.send, LotseFeedbackTexts.german.send);
      expect(texts.annotate, LotseFeedbackTexts.german.annotate);
      expect(
        texts.captureRenderFailed,
        LotseFeedbackTexts.german.captureRenderFailed,
      );
    });

    test('when an app overrides the texts of the editor '
        'then each one lands in its own field', () {
      final texts = LotseFeedbackTexts.english.copyWith(
        annotate: 'a',
        annotateTitle: 'b',
        annotateUndo: 'c',
        annotateClear: 'd',
        annotateDone: 'e',
        annotateCancel: 'f',
        annotateFailed: 'g',
      );

      expect(
        [
          texts.annotate,
          texts.annotateTitle,
          texts.annotateUndo,
          texts.annotateClear,
          texts.annotateDone,
          texts.annotateCancel,
          texts.annotateFailed,
        ],
        ['a', 'b', 'c', 'd', 'e', 'f', 'g'],
      );
      expect(texts.remove, LotseFeedbackTexts.english.remove);
    });

    test('when an app overrides the texts of the conversations '
        'then each one lands in its own field', () {
      final texts = LotseFeedbackTexts.english.copyWith(
        myFeedbackTitle: 'a',
        myFeedbackEmpty: 'b',
        loadFailed: 'c',
        statusOpen: 'd',
        statusInProgress: 'e',
        statusDone: 'f',
        statusDismissed: 'g',
        unreadLabel: 'h',
        conversationTitle: 'i',
        authorYou: 'j',
        authorTeam: 'k',
        replyHint: 'l',
        replySend: 'm',
        replyFailed: 'n',
        replyLimitReached: 'o',
      );

      expect(
        [
          texts.myFeedbackTitle,
          texts.myFeedbackEmpty,
          texts.loadFailed,
          texts.statusOpen,
          texts.statusInProgress,
          texts.statusDone,
          texts.statusDismissed,
          texts.unreadLabel,
          texts.conversationTitle,
          texts.authorYou,
          texts.authorTeam,
          texts.replyHint,
          texts.replySend,
          texts.replyFailed,
          texts.replyLimitReached,
        ],
        [
          'a',
          'b',
          'c',
          'd',
          'e',
          'f',
          'g',
          'h',
          'i',
          'j',
          'k',
          'l',
          'm',
          'n',
          'o',
        ],
      );
      expect(texts.send, LotseFeedbackTexts.english.send);
    });

    test('when the conversations are shown in German '
        'then no text is left in English', () {
      const english = LotseFeedbackTexts.english;
      const german = LotseFeedbackTexts.german;

      expect(german.myFeedbackTitle, isNot(english.myFeedbackTitle));
      expect(german.myFeedbackEmpty, isNot(english.myFeedbackEmpty));
      expect(german.loadFailed, isNot(english.loadFailed));
      expect(german.statusOpen, isNot(english.statusOpen));
      expect(german.statusInProgress, isNot(english.statusInProgress));
      expect(german.statusDone, isNot(english.statusDone));
      expect(german.statusDismissed, isNot(english.statusDismissed));
      expect(german.unreadLabel, isNot(english.unreadLabel));
      expect(german.conversationTitle, isNot(english.conversationTitle));
      expect(german.authorYou, isNot(english.authorYou));
      expect(german.replyHint, isNot(english.replyHint));
      expect(german.replySend, isNot(english.replySend));
      expect(german.replyFailed, isNot(english.replyFailed));
      expect(german.replyLimitReached, isNot(english.replyLimitReached));
    });
  });
}
