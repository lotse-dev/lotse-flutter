/// Lotse SDK: deep links, attribution and push for Flutter apps.
///
/// [LotseScreenObserver] reports screen views when handed to a navigator.
///
/// The generated Serverpod client stays internal. Apps only see [Lotse] and
/// its own types such as [LotseLink] and [LotseFeedbackTexts], and the widgets
/// [LotseScope] and [LotseConfidential] for feedback screenshots. [LotseScope]
/// also brings the navigator a tapped reply push opens its conversation on.
/// [LotseInAppMessages] shows the in-app messages of the console as
/// [LotseInAppMessage], and the surveys of the console in the same place.
library;

export 'src/lotse.dart' show Lotse;
export 'src/lotse_backgrounds.dart' show LotseBackgrounds;
export 'src/lotse_feedback.dart' show LotseFeedbackCategory;
export 'src/lotse_feedback_texts.dart' show LotseFeedbackTexts;
export 'src/lotse_in_app.dart' show LotseInAppMessage, LotseInAppStyle;
export 'src/lotse_in_app_view.dart' show LotseInAppMessages;
export 'src/lotse_link.dart' show LotseLink;
export 'src/lotse_replay_recorder.dart' show LotseReplayOptions;
export 'src/lotse_push.dart' show LotsePush;
export 'src/lotse_screens.dart' show LotseScreenObserver;
export 'src/lotse_server_url.dart' show LotseServerUrlError;
export 'src/lotse_scope.dart' show LotseConfidential, LotseScope, LotseUnmasked;
