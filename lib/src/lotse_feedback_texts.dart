import 'dart:ui';

/// Every text of the feedback sheet, of "My feedback", of its conversations,
/// of the support chat, of the feature board and of the survey card.
///
/// The SDK ships [english] and [german] and picks one by the device locale.
/// An app overrides single texts with [copyWith] or passes its own instance to
/// `Lotse.instance.showFeedback` and `Lotse.instance.showMyFeedback`:
///
/// ```dart
/// Lotse.instance.showFeedback(
///   context,
///   texts: LotseFeedbackTexts.english.copyWith(title: 'Tell us'),
/// );
/// ```
class LotseFeedbackTexts {
  /// Creates a complete set of texts.
  const LotseFeedbackTexts({
    required this.title,
    required this.categoryBug,
    required this.categoryIdea,
    required this.categoryPraise,
    required this.categoryOther,
    required this.messageHint,
    required this.messageTooLong,
    required this.emailLabel,
    required this.emailInvalid,
    required this.screenshotLabel,
    required this.retake,
    required this.retakeHint,
    required this.retakeCapture,
    required this.retakeCancel,
    required this.remove,
    required this.annotate,
    required this.annotateTitle,
    required this.annotateUndo,
    required this.annotateClear,
    required this.annotateDone,
    required this.annotateCancel,
    required this.annotateFailed,
    required this.captureRenderFailed,
    required this.captureTooLarge,
    required this.captureFailed,
    required this.replayAttach,
    required this.replayHint,
    required this.send,
    required this.retry,
    required this.sendFailed,
    required this.limitReached,
    required this.sentTitle,
    required this.sentBody,
    required this.close,
    required this.myFeedbackTitle,
    required this.myFeedbackEmpty,
    required this.loadFailed,
    required this.statusOpen,
    required this.statusInProgress,
    required this.statusDone,
    required this.statusDismissed,
    required this.unreadLabel,
    required this.conversationTitle,
    required this.authorYou,
    required this.authorTeam,
    required this.replyHint,
    required this.replySend,
    required this.replyFailed,
    required this.replyLimitReached,
    required this.categoryQuestion,
    required this.supportChatTitle,
    required this.supportChatIntro,
    required this.supportChatHint,
    required this.supportChatSend,
    required this.supportChatDisabled,
    required this.supportChatFailed,
    required this.supportChatLimitReached,
    required this.featureBoardTitle,
    required this.featureTabIdeas,
    required this.featureTabPlanned,
    required this.featureTabInProgress,
    required this.featureTabShipped,
    required this.featureEmptyIdeas,
    required this.featureEmptyPlanned,
    required this.featureEmptyInProgress,
    required this.featureEmptyShipped,
    required this.featureVote,
    required this.featureUnvote,
    required this.featureVoteFailed,
    required this.featureVoteLimitReached,
    required this.featureGone,
    required this.surveyNotLikely,
    required this.surveyVeryLikely,
    required this.surveyCommentPrompt,
    required this.surveyCommentHint,
    required this.surveySend,
    required this.surveySkip,
    required this.surveyThanks,
    required this.surveyFailed,
    this.languageCode = 'en',
  });

  /// Picks the texts for [locale]: [german] for German, [english] for
  /// everything else.
  factory LotseFeedbackTexts.forLocale(Locale locale) =>
      locale.languageCode == 'de' ? german : english;

  /// Language of these texts as an ISO 639 code. Dates in the conversations
  /// follow it when the app itself is not localized for this language.
  final String languageCode;

  /// Heading of the sheet.
  final String title;

  /// Chip of the category bug.
  final String categoryBug;

  /// Chip of the category idea.
  final String categoryIdea;

  /// Chip of the category praise.
  final String categoryPraise;

  /// Chip of the category other.
  final String categoryOther;

  /// Hint inside the empty message field.
  final String messageHint;

  /// Error below a message that is longer than the limit.
  final String messageTooLong;

  /// Label of the optional e-mail field.
  final String emailLabel;

  /// Error below an e-mail field that does not hold an address.
  final String emailInvalid;

  /// Label of the screenshot preview, also its description for screen readers.
  final String screenshotLabel;

  /// Button that takes the screenshot again.
  final String retake;

  /// Line on the floating bar after "Retake": the user goes to the screen
  /// the feedback is about.
  final String retakeHint;

  /// Button on the floating bar that captures the screen now.
  final String retakeCapture;

  /// Button on the floating bar that goes back to the sheet without a new
  /// screenshot.
  final String retakeCancel;

  /// Button that drops the screenshot.
  final String remove;

  /// Button that opens the screenshot for drawing.
  final String annotate;

  /// Heading of the editor the user draws in.
  final String annotateTitle;

  /// Editor button that removes the last stroke.
  final String annotateUndo;

  /// Editor button that removes every stroke.
  final String annotateClear;

  /// Editor button that keeps the strokes and returns to the sheet.
  final String annotateDone;

  /// Editor button that returns to the sheet without keeping anything.
  final String annotateCancel;

  /// Shown in the editor when the strokes could not be put into the image.
  final String annotateFailed;

  /// Explains a screen that cannot be captured, which maps and web views cause.
  final String captureRenderFailed;

  /// Explains a screenshot that stayed too large.
  final String captureTooLarge;

  /// Explains any other failed capture.
  final String captureFailed;

  /// The switch that attaches the replay of the last seconds. `{seconds}`
  /// becomes the length of the recording.
  final String replayAttach;

  /// Below that switch: what the recording shows and who sees it.
  final String replayHint;

  /// The send button.
  final String send;

  /// The send button after a failed attempt.
  final String retry;

  /// Shown after a failed attempt.
  final String sendFailed;

  /// Shown when the server turned the message away because of a quota.
  final String limitReached;

  /// Heading of the confirmation.
  final String sentTitle;

  /// Body of the confirmation.
  final String sentBody;

  /// Button that closes the confirmation.
  final String close;

  /// Heading of the list of the user's own feedback.
  final String myFeedbackTitle;

  /// Shown in the list while the user has sent nothing yet.
  final String myFeedbackEmpty;

  /// Shown when the list or a conversation could not be loaded.
  final String loadFailed;

  /// Status of a message nobody has picked up yet.
  final String statusOpen;

  /// Status of a message the team is working on.
  final String statusInProgress;

  /// Status of a message the team is done with.
  final String statusDone;

  /// Status of a message the team will not act on.
  final String statusDismissed;

  /// Describes the unread marker of a list entry for screen readers.
  final String unreadLabel;

  /// Heading of a conversation.
  final String conversationTitle;

  /// Name above what the user wrote.
  final String authorYou;

  /// Name above what the team wrote.
  final String authorTeam;

  /// Hint inside the empty reply field.
  final String replyHint;

  /// Describes the button that sends a reply.
  final String replySend;

  /// Shown after a reply could not be sent.
  final String replyFailed;

  /// Shown when the server turned a reply away because of a quota.
  final String replyLimitReached;

  /// Category of a support chat in "My feedback". Not a chip of the sheet.
  final String categoryQuestion;

  /// Heading of the support chat.
  final String supportChatTitle;

  /// Shown in the support chat before the first question.
  final String supportChatIntro;

  /// Hint inside the empty question field.
  final String supportChatHint;

  /// Describes the button that sends the question.
  final String supportChatSend;

  /// Shown instead of the question field while the project has the chat
  /// switched off.
  final String supportChatDisabled;

  /// Shown after a question could not be sent.
  final String supportChatFailed;

  /// Shown when the server turned a question away because of a quota.
  final String supportChatLimitReached;

  /// Heading of the feature board.
  final String featureBoardTitle;

  /// Tab of the ideas nothing is decided about yet.
  final String featureTabIdeas;

  /// Tab of the ideas the team intends to build.
  final String featureTabPlanned;

  /// Tab of the ideas the team is building.
  final String featureTabInProgress;

  /// Tab of the ideas that are in the app.
  final String featureTabShipped;

  /// Shown in the tab of the ideas while it is empty.
  final String featureEmptyIdeas;

  /// Shown in the tab of the planned ideas while it is empty.
  final String featureEmptyPlanned;

  /// Shown in the tab of the ideas in progress while it is empty.
  final String featureEmptyInProgress;

  /// Shown in the tab of the shipped ideas while it is empty.
  final String featureEmptyShipped;

  /// Describes the button that votes for an idea.
  final String featureVote;

  /// Describes the button that takes the vote back.
  final String featureUnvote;

  /// Shown after a vote could not be stored.
  final String featureVoteFailed;

  /// Shown when the server turned a vote away because of a quota.
  final String featureVoteLimitReached;

  /// Shown when the idea voted on is not on the board any more.
  final String featureGone;

  /// Label below the lowest score of an NPS survey.
  final String surveyNotLikely;

  /// Label below the highest score of an NPS survey.
  final String surveyVeryLikely;

  /// Asked after the score when the team did not write its own prompt.
  final String surveyCommentPrompt;

  /// Hint inside the comment field of a survey.
  final String surveyCommentHint;

  /// Sends the answer to a survey.
  final String surveySend;

  /// Sends the score without a comment.
  final String surveySkip;

  /// Shown for a moment after the answer arrived.
  final String surveyThanks;

  /// Shown after an answer could not be sent.
  final String surveyFailed;

  /// The English texts.
  static const english = LotseFeedbackTexts(
    title: 'Send feedback',
    categoryBug: 'Bug',
    categoryIdea: 'Idea',
    categoryPraise: 'Praise',
    categoryOther: 'Other',
    messageHint: 'What would you like to tell us?',
    messageTooLong: 'At most 4000 characters.',
    emailLabel: 'E-mail for a reply (optional)',
    emailInvalid: 'This is not an e-mail address.',
    screenshotLabel: 'Screenshot',
    retake: 'Retake',
    retakeHint: 'Go to the screen you mean',
    retakeCapture: 'Take screenshot',
    retakeCancel: 'Cancel',
    remove: 'Remove',
    annotate: 'Mark',
    annotateTitle: 'Mark the screenshot',
    annotateUndo: 'Undo',
    annotateClear: 'Clear',
    annotateDone: 'Done',
    annotateCancel: 'Cancel',
    annotateFailed: 'The marks could not be saved. Please try again.',
    captureRenderFailed:
        'This screen cannot be captured. Your message is sent without a '
        'screenshot.',
    captureTooLarge:
        'The screenshot is too large. Your message is sent without it.',
    captureFailed:
        'The screenshot could not be taken. Your message is sent without it.',
    replayAttach: 'Attach the last {seconds} seconds',
    replayHint:
        'A recording of the screen before you opened this. Inputs are '
        'blacked out, and only the team sees it.',
    send: 'Send',
    retry: 'Try again',
    sendFailed:
        'Your feedback could not be sent. Nothing is lost, please try again.',
    limitReached:
        'The limit for feedback is reached for now. Please try again later.',
    sentTitle: 'Thank you',
    sentBody: 'Your feedback has arrived.',
    close: 'Close',
    myFeedbackTitle: 'My feedback',
    myFeedbackEmpty: 'You have not sent any feedback yet.',
    loadFailed: 'This could not be loaded. Please try again.',
    statusOpen: 'Received',
    statusInProgress: 'In progress',
    statusDone: 'Done',
    statusDismissed: 'Closed',
    unreadLabel: 'New reply',
    conversationTitle: 'Conversation',
    authorYou: 'You',
    authorTeam: 'Team',
    replyHint: 'Write a reply',
    replySend: 'Send reply',
    replyFailed: 'Your reply could not be sent. Please try again.',
    replyLimitReached:
        'The limit for replies is reached for now. Please try again later.',
    categoryQuestion: 'Question',
    supportChatTitle: 'Support',
    supportChatIntro:
        'Ask us anything about the app. We answer here as soon as we can.',
    supportChatHint: 'Write your question',
    supportChatSend: 'Send question',
    supportChatDisabled: 'The support chat is not available at the moment.',
    supportChatFailed: 'Your question could not be sent. Please try again.',
    supportChatLimitReached:
        'The limit for questions is reached for now. Please try again later.',
    featureBoardTitle: 'Feature board',
    featureTabIdeas: 'Ideas',
    featureTabPlanned: 'Planned',
    featureTabInProgress: 'In progress',
    featureTabShipped: 'Shipped',
    featureEmptyIdeas: 'There are no ideas to vote on at the moment.',
    featureEmptyPlanned: 'Nothing is planned at the moment.',
    featureEmptyInProgress: 'Nothing is in progress at the moment.',
    featureEmptyShipped: 'Nothing has been shipped yet.',
    featureVote: 'Vote for this idea',
    featureUnvote: 'Take your vote back',
    featureVoteFailed: 'Your vote could not be saved. Please try again.',
    featureVoteLimitReached:
        'The limit for votes is reached for now. Please try again later.',
    featureGone: 'This idea is no longer on the board.',
    surveyNotLikely: 'Not likely',
    surveyVeryLikely: 'Very likely',
    surveyCommentPrompt: 'What is the main reason for your score?',
    surveyCommentHint: 'Optional',
    surveySend: 'Send',
    surveySkip: 'Skip',
    surveyThanks: 'Thank you!',
    surveyFailed: 'Your answer could not be sent.',
  );

  /// The German texts.
  static const german = LotseFeedbackTexts(
    title: 'Feedback senden',
    categoryBug: 'Fehler',
    categoryIdea: 'Idee',
    categoryPraise: 'Lob',
    categoryOther: 'Sonstiges',
    messageHint: 'Was möchtest du uns sagen?',
    messageTooLong: 'Höchstens 4000 Zeichen.',
    emailLabel: 'E-Mail für eine Antwort (optional)',
    emailInvalid: 'Das ist keine E-Mail-Adresse.',
    screenshotLabel: 'Screenshot',
    retake: 'Neu aufnehmen',
    retakeHint: 'Geh zu der Seite, um die es geht',
    retakeCapture: 'Screenshot aufnehmen',
    retakeCancel: 'Abbrechen',
    remove: 'Entfernen',
    annotate: 'Markieren',
    annotateTitle: 'Screenshot markieren',
    annotateUndo: 'Rückgängig',
    annotateClear: 'Alles löschen',
    annotateDone: 'Fertig',
    annotateCancel: 'Abbrechen',
    annotateFailed:
        'Die Markierungen konnten nicht gespeichert werden. Bitte versuche '
        'es erneut.',
    captureRenderFailed:
        'Dieser Bildschirm lässt sich nicht aufnehmen. Deine Nachricht wird '
        'ohne Screenshot gesendet.',
    captureTooLarge:
        'Der Screenshot ist zu groß. Deine Nachricht wird ohne ihn gesendet.',
    captureFailed:
        'Der Screenshot konnte nicht aufgenommen werden. Deine Nachricht wird '
        'ohne ihn gesendet.',
    replayAttach: 'Die letzten {seconds} Sekunden anhängen',
    replayHint:
        'Eine Aufzeichnung des Bildschirms, bevor du das hier geöffnet hast. '
        'Eingaben sind geschwärzt, und nur das Team sieht sie.',
    send: 'Senden',
    retry: 'Erneut senden',
    sendFailed:
        'Dein Feedback konnte nicht gesendet werden. Nichts ist verloren, '
        'bitte versuche es erneut.',
    limitReached:
        'Das Limit für Feedback ist vorerst erreicht. Bitte versuche es '
        'später noch einmal.',
    sentTitle: 'Danke',
    sentBody: 'Dein Feedback ist angekommen.',
    close: 'Schließen',
    myFeedbackTitle: 'Mein Feedback',
    myFeedbackEmpty: 'Du hast noch kein Feedback gesendet.',
    loadFailed: 'Das konnte nicht geladen werden. Bitte versuche es erneut.',
    statusOpen: 'Eingegangen',
    statusInProgress: 'In Arbeit',
    statusDone: 'Erledigt',
    statusDismissed: 'Geschlossen',
    unreadLabel: 'Neue Antwort',
    conversationTitle: 'Gespräch',
    authorYou: 'Du',
    authorTeam: 'Team',
    replyHint: 'Antwort schreiben',
    replySend: 'Antwort senden',
    replyFailed:
        'Deine Antwort konnte nicht gesendet werden. Bitte versuche es erneut.',
    replyLimitReached:
        'Das Limit für Antworten ist vorerst erreicht. Bitte versuche es '
        'später noch einmal.',
    categoryQuestion: 'Frage',
    supportChatTitle: 'Support',
    supportChatIntro:
        'Frag uns alles zur App. Wir antworten hier, so schnell wir können.',
    supportChatHint: 'Frage schreiben',
    supportChatSend: 'Frage senden',
    supportChatDisabled: 'Der Support-Chat ist zurzeit nicht verfügbar.',
    supportChatFailed:
        'Deine Frage konnte nicht gesendet werden. Bitte versuche es erneut.',
    supportChatLimitReached:
        'Das Limit für Fragen ist vorerst erreicht. Bitte versuche es später '
        'noch einmal.',
    featureBoardTitle: 'Ideen-Board',
    featureTabIdeas: 'Ideen',
    featureTabPlanned: 'Geplant',
    featureTabInProgress: 'In Arbeit',
    featureTabShipped: 'Fertig',
    featureEmptyIdeas: 'Zurzeit gibt es keine Ideen zum Abstimmen.',
    featureEmptyPlanned: 'Zurzeit ist nichts geplant.',
    featureEmptyInProgress: 'Zurzeit ist nichts in Arbeit.',
    featureEmptyShipped: 'Noch ist nichts fertig.',
    featureVote: 'Für diese Idee stimmen',
    featureUnvote: 'Stimme zurücknehmen',
    featureVoteFailed:
        'Deine Stimme konnte nicht gespeichert werden. Bitte versuche es '
        'erneut.',
    featureVoteLimitReached:
        'Das Limit für Stimmen ist vorerst erreicht. Bitte versuche es '
        'später noch einmal.',
    featureGone: 'Diese Idee ist nicht mehr auf dem Board.',
    languageCode: 'de',
    surveyNotLikely: 'Unwahrscheinlich',
    surveyVeryLikely: 'Sehr wahrscheinlich',
    surveyCommentPrompt: 'Was ist der wichtigste Grund für deine Bewertung?',
    surveyCommentHint: 'Optional',
    surveySend: 'Senden',
    surveySkip: 'Überspringen',
    surveyThanks: 'Danke!',
    surveyFailed: 'Deine Antwort konnte nicht gesendet werden.',
  );

  /// A copy with the given texts replaced.
  LotseFeedbackTexts copyWith({
    String? title,
    String? categoryBug,
    String? categoryIdea,
    String? categoryPraise,
    String? categoryOther,
    String? messageHint,
    String? messageTooLong,
    String? emailLabel,
    String? emailInvalid,
    String? screenshotLabel,
    String? retake,
    String? retakeHint,
    String? retakeCapture,
    String? retakeCancel,
    String? remove,
    String? annotate,
    String? annotateTitle,
    String? annotateUndo,
    String? annotateClear,
    String? annotateDone,
    String? annotateCancel,
    String? annotateFailed,
    String? captureRenderFailed,
    String? captureTooLarge,
    String? captureFailed,
    String? replayAttach,
    String? replayHint,
    String? send,
    String? retry,
    String? sendFailed,
    String? limitReached,
    String? sentTitle,
    String? sentBody,
    String? close,
    String? myFeedbackTitle,
    String? myFeedbackEmpty,
    String? loadFailed,
    String? statusOpen,
    String? statusInProgress,
    String? statusDone,
    String? statusDismissed,
    String? unreadLabel,
    String? conversationTitle,
    String? authorYou,
    String? authorTeam,
    String? replyHint,
    String? replySend,
    String? replyFailed,
    String? replyLimitReached,
    String? categoryQuestion,
    String? supportChatTitle,
    String? supportChatIntro,
    String? supportChatHint,
    String? supportChatSend,
    String? supportChatDisabled,
    String? supportChatFailed,
    String? supportChatLimitReached,
    String? featureBoardTitle,
    String? featureTabIdeas,
    String? featureTabPlanned,
    String? featureTabInProgress,
    String? featureTabShipped,
    String? featureEmptyIdeas,
    String? featureEmptyPlanned,
    String? featureEmptyInProgress,
    String? featureEmptyShipped,
    String? featureVote,
    String? featureUnvote,
    String? featureVoteFailed,
    String? featureVoteLimitReached,
    String? featureGone,
    String? surveyNotLikely,
    String? surveyVeryLikely,
    String? surveyCommentPrompt,
    String? surveyCommentHint,
    String? surveySend,
    String? surveySkip,
    String? surveyThanks,
    String? surveyFailed,
    String? languageCode,
  }) => LotseFeedbackTexts(
    title: title ?? this.title,
    categoryBug: categoryBug ?? this.categoryBug,
    categoryIdea: categoryIdea ?? this.categoryIdea,
    categoryPraise: categoryPraise ?? this.categoryPraise,
    categoryOther: categoryOther ?? this.categoryOther,
    messageHint: messageHint ?? this.messageHint,
    messageTooLong: messageTooLong ?? this.messageTooLong,
    emailLabel: emailLabel ?? this.emailLabel,
    emailInvalid: emailInvalid ?? this.emailInvalid,
    screenshotLabel: screenshotLabel ?? this.screenshotLabel,
    retake: retake ?? this.retake,
    retakeHint: retakeHint ?? this.retakeHint,
    retakeCapture: retakeCapture ?? this.retakeCapture,
    retakeCancel: retakeCancel ?? this.retakeCancel,
    remove: remove ?? this.remove,
    annotate: annotate ?? this.annotate,
    annotateTitle: annotateTitle ?? this.annotateTitle,
    annotateUndo: annotateUndo ?? this.annotateUndo,
    annotateClear: annotateClear ?? this.annotateClear,
    annotateDone: annotateDone ?? this.annotateDone,
    annotateCancel: annotateCancel ?? this.annotateCancel,
    annotateFailed: annotateFailed ?? this.annotateFailed,
    captureRenderFailed: captureRenderFailed ?? this.captureRenderFailed,
    captureTooLarge: captureTooLarge ?? this.captureTooLarge,
    captureFailed: captureFailed ?? this.captureFailed,
    replayAttach: replayAttach ?? this.replayAttach,
    replayHint: replayHint ?? this.replayHint,
    send: send ?? this.send,
    retry: retry ?? this.retry,
    sendFailed: sendFailed ?? this.sendFailed,
    limitReached: limitReached ?? this.limitReached,
    sentTitle: sentTitle ?? this.sentTitle,
    sentBody: sentBody ?? this.sentBody,
    close: close ?? this.close,
    myFeedbackTitle: myFeedbackTitle ?? this.myFeedbackTitle,
    myFeedbackEmpty: myFeedbackEmpty ?? this.myFeedbackEmpty,
    loadFailed: loadFailed ?? this.loadFailed,
    statusOpen: statusOpen ?? this.statusOpen,
    statusInProgress: statusInProgress ?? this.statusInProgress,
    statusDone: statusDone ?? this.statusDone,
    statusDismissed: statusDismissed ?? this.statusDismissed,
    unreadLabel: unreadLabel ?? this.unreadLabel,
    conversationTitle: conversationTitle ?? this.conversationTitle,
    authorYou: authorYou ?? this.authorYou,
    authorTeam: authorTeam ?? this.authorTeam,
    replyHint: replyHint ?? this.replyHint,
    replySend: replySend ?? this.replySend,
    replyFailed: replyFailed ?? this.replyFailed,
    replyLimitReached: replyLimitReached ?? this.replyLimitReached,
    categoryQuestion: categoryQuestion ?? this.categoryQuestion,
    supportChatTitle: supportChatTitle ?? this.supportChatTitle,
    supportChatIntro: supportChatIntro ?? this.supportChatIntro,
    supportChatHint: supportChatHint ?? this.supportChatHint,
    supportChatSend: supportChatSend ?? this.supportChatSend,
    supportChatDisabled: supportChatDisabled ?? this.supportChatDisabled,
    supportChatFailed: supportChatFailed ?? this.supportChatFailed,
    supportChatLimitReached:
        supportChatLimitReached ?? this.supportChatLimitReached,
    featureBoardTitle: featureBoardTitle ?? this.featureBoardTitle,
    featureTabIdeas: featureTabIdeas ?? this.featureTabIdeas,
    featureTabPlanned: featureTabPlanned ?? this.featureTabPlanned,
    featureTabInProgress: featureTabInProgress ?? this.featureTabInProgress,
    featureTabShipped: featureTabShipped ?? this.featureTabShipped,
    featureEmptyIdeas: featureEmptyIdeas ?? this.featureEmptyIdeas,
    featureEmptyPlanned: featureEmptyPlanned ?? this.featureEmptyPlanned,
    featureEmptyInProgress:
        featureEmptyInProgress ?? this.featureEmptyInProgress,
    featureEmptyShipped: featureEmptyShipped ?? this.featureEmptyShipped,
    featureVote: featureVote ?? this.featureVote,
    featureUnvote: featureUnvote ?? this.featureUnvote,
    featureVoteFailed: featureVoteFailed ?? this.featureVoteFailed,
    featureVoteLimitReached:
        featureVoteLimitReached ?? this.featureVoteLimitReached,
    featureGone: featureGone ?? this.featureGone,
    surveyNotLikely: surveyNotLikely ?? this.surveyNotLikely,
    surveyVeryLikely: surveyVeryLikely ?? this.surveyVeryLikely,
    surveyCommentPrompt: surveyCommentPrompt ?? this.surveyCommentPrompt,
    surveyCommentHint: surveyCommentHint ?? this.surveyCommentHint,
    surveySend: surveySend ?? this.surveySend,
    surveySkip: surveySkip ?? this.surveySkip,
    surveyThanks: surveyThanks ?? this.surveyThanks,
    surveyFailed: surveyFailed ?? this.surveyFailed,
    languageCode: languageCode ?? this.languageCode,
  );
}
