/// Data keys Lotse puts into the payload of a campaign push.
const _campaignIdKey = 'lotse_campaign_id';
const _deliveryIdKey = 'lotse_delivery_id';
const _targetPathKey = 'lotse_target_path';

/// Data keys of a push that announces a team reply to a feedback message.
/// Must match `FcmClient` on the server.
const _typeKey = 'lotse_type';
const _feedbackType = 'lotse_feedback';
const _feedbackIdKey = 'lotse_feedback_id';

/// A push sent by Lotse that the user tapped.
class LotsePush {
  /// Creates a tapped push.
  const LotsePush({
    required this.campaignId,
    required this.deliveryId,
    this.targetPath,
  });

  /// The campaign the push belongs to.
  final String campaignId;

  /// The delivery this device received.
  final String deliveryId;

  /// The app route to open, for example `/offer/42`. Null when the campaign
  /// has no link.
  final String? targetPath;
}

/// Reads the Lotse payload out of a push message's data.
///
/// Returns null for messages that are not Lotse pushes, so an app that uses
/// Firebase for other messages too is not disturbed.
LotsePush? lotsePushFromData(Map<String, dynamic>? data) {
  // A reply push stays inside the SDK, whatever else it carries.
  if (data == null || data[_typeKey] == _feedbackType) return null;
  final campaignId = data[_campaignIdKey];
  final deliveryId = data[_deliveryIdKey];
  if (campaignId is! String ||
      campaignId.isEmpty ||
      deliveryId is! String ||
      deliveryId.isEmpty) {
    return null;
  }
  final targetPath = data[_targetPathKey];
  return LotsePush(
    campaignId: campaignId,
    deliveryId: deliveryId,
    targetPath: targetPath is String && targetPath.isNotEmpty
        ? targetPath
        : null,
  );
}

/// Reads the feedback id out of a push that announces a team reply.
///
/// Returns null for every other message, campaign pushes included. Such a push
/// carries no app route: the SDK opens the conversation itself, so it never
/// reaches the app as a [LotsePush].
int? lotseFeedbackIdFromData(Map<String, dynamic>? data) {
  if (data == null || data[_typeKey] != _feedbackType) return null;
  final id = data[_feedbackIdKey];
  final parsed = id is String ? int.tryParse(id) : null;
  return parsed != null && parsed > 0 ? parsed : null;
}
