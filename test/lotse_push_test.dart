import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/lotse_push.dart';

void main() {
  group('Given lotsePushFromData', () {
    test('when the Lotse keys are present then a push', () {
      final push = lotsePushFromData({
        'lotse_campaign_id': '7',
        'lotse_delivery_id': '42',
        'lotse_target_path': '/offer/42',
      });
      expect(push?.campaignId, '7');
      expect(push?.deliveryId, '42');
      expect(push?.targetPath, '/offer/42');
    });

    test('when the campaign has no link then no target path', () {
      final push = lotsePushFromData({
        'lotse_campaign_id': '7',
        'lotse_delivery_id': '42',
      });
      expect(push?.targetPath, isNull);
    });

    test('when the message is not a Lotse push then null', () {
      expect(lotsePushFromData(null), isNull);
      expect(lotsePushFromData({}), isNull);
      expect(lotsePushFromData({'lotse_campaign_id': '7'}), isNull);
      expect(
        lotsePushFromData({'lotse_campaign_id': '', 'lotse_delivery_id': '42'}),
        isNull,
      );
    });
  });

  group('Given lotseFeedbackIdFromData', () {
    const replyPush = {
      'lotse_type': 'lotse_feedback',
      'lotse_feedback_id': '12',
    };

    test('when the push announces a team reply then the feedback id', () {
      expect(lotseFeedbackIdFromData(replyPush), 12);
    });

    test('when the push announces a team reply '
        'then it is not a campaign push, so it never reaches the app', () {
      expect(lotsePushFromData(replyPush), isNull);
    });

    test('when a reply push carries campaign keys as well '
        'then it still never reaches the app', () {
      expect(
        lotsePushFromData({
          ...replyPush,
          'lotse_campaign_id': '7',
          'lotse_delivery_id': '42',
        }),
        isNull,
      );
    });

    test('when the push belongs to a campaign then null', () {
      expect(
        lotseFeedbackIdFromData({
          'lotse_campaign_id': '7',
          'lotse_delivery_id': '42',
          'lotse_target_path': '/offer/42',
        }),
        isNull,
      );
    });

    test('when the type or the id is missing or malformed then null', () {
      expect(lotseFeedbackIdFromData(null), isNull);
      expect(lotseFeedbackIdFromData({}), isNull);
      expect(lotseFeedbackIdFromData({'lotse_feedback_id': '12'}), isNull);
      expect(lotseFeedbackIdFromData({'lotse_type': 'lotse_feedback'}), isNull);
      for (final id in ['', 'abc', '0', '-3', '1.5']) {
        expect(
          lotseFeedbackIdFromData({
            'lotse_type': 'lotse_feedback',
            'lotse_feedback_id': id,
          }),
          isNull,
          reason: 'id "$id"',
        );
      }
      expect(
        lotseFeedbackIdFromData({
          'lotse_type': 'other',
          'lotse_feedback_id': '12',
        }),
        isNull,
      );
    });
  });
}
