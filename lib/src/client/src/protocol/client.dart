/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'dart:typed_data' as _idt;
import 'package:http/http.dart' as _i85jenna;
import 'package:lotse/src/client/src/protocol/acquisition_report.dart' as _i20y0aod;
import 'package:lotse/src/client/src/protocol/agent_token.dart' as _izywjc6s;
import 'package:lotse/src/client/src/protocol/agent_token_created.dart'
    as _ire6rsvy;
import 'package:lotse/src/client/src/protocol/agent_token_level.dart' as _iftmj5k7;
import 'package:lotse/src/client/src/protocol/analytics_overview.dart' as _ir5ronot;
import 'package:lotse/src/client/src/protocol/api_key.dart' as _imzvo1nf;
import 'package:lotse/src/client/src/protocol/api_key_created.dart' as _i0qvu201;
import 'package:lotse/src/client/src/protocol/apns_environment.dart' as _iiz2r0fa;
import 'package:lotse/src/client/src/protocol/app_user.dart' as _i9cgg3r7;
import 'package:lotse/src/client/src/protocol/app_user_list_item.dart' as _itcuuu2x;
import 'package:lotse/src/client/src/protocol/campaign.dart' as _isnrua4r;
import 'package:lotse/src/client/src/protocol/campaign_report.dart' as _ie9wnyd5;
import 'package:lotse/src/client/src/protocol/csv_export.dart' as _ihn6x8sm;
import 'package:lotse/src/client/src/protocol/csv_export_request.dart' as _ib1qclyo;
import 'package:lotse/src/client/src/protocol/delivery_summary.dart' as _ih34aj5x;
import 'package:lotse/src/client/src/protocol/device.dart' as _illpjbsr;
import 'package:lotse/src/client/src/protocol/device_platform.dart' as _ipw7cd6p;
import 'package:lotse/src/client/src/protocol/device_registration.dart'
    as _ii8htaq5;
import 'package:lotse/src/client/src/protocol/event.dart' as _i7mn5lps;
import 'package:lotse/src/client/src/protocol/explorer_query.dart' as _i12dwnjx;
import 'package:lotse/src/client/src/protocol/explorer_report.dart' as _isgqgait;
import 'package:lotse/src/client/src/protocol/feature_board_item.dart' as _iktk6feb;
import 'package:lotse/src/client/src/protocol/feature_request.dart' as _i9ewlb1w;
import 'package:lotse/src/client/src/protocol/feature_request_status.dart'
    as _iy0ugmyc;
import 'package:lotse/src/client/src/protocol/feedback.dart' as _intnc2la;
import 'package:lotse/src/client/src/protocol/feedback_category.dart' as _i9lhucay;
import 'package:lotse/src/client/src/protocol/feedback_conversation_change.dart'
    as _iwaox72k;
import 'package:lotse/src/client/src/protocol/feedback_detail.dart' as _ijy2s14x;
import 'package:lotse/src/client/src/protocol/feedback_message.dart' as _i7te3iey;
import 'package:lotse/src/client/src/protocol/feedback_page.dart' as _i0fj1xz3;
import 'package:lotse/src/client/src/protocol/feedback_replay_info.dart'
    as _iq3jz10h;
import 'package:lotse/src/client/src/protocol/feedback_status.dart' as _i7mfdxkk;
import 'package:lotse/src/client/src/protocol/feedback_submission.dart'
    as _ift03pyz;
import 'package:lotse/src/client/src/protocol/funnel_report.dart' as _iu7f39kv;
import 'package:lotse/src/client/src/protocol/funnel_split.dart' as _i7u407uy;
import 'package:lotse/src/client/src/protocol/funnel_step.dart' as _i1oe7xkk;
import 'package:lotse/src/client/src/protocol/heatmap_background_slot.dart'
    as _iv0jmya8;
import 'package:lotse/src/client/src/protocol/heatmap_report.dart' as _ij0uml61;
import 'package:lotse/src/client/src/protocol/heatmap_screen.dart' as _ixzdz37m;
import 'package:lotse/src/client/src/protocol/heatmap_width_class.dart'
    as _i0sl3x5f;
import 'package:lotse/src/client/src/protocol/identity_secret_created.dart'
    as _it6kuuwq;
import 'package:lotse/src/client/src/protocol/identity_verification_status.dart'
    as _iz05sm2g;
import 'package:lotse/src/client/src/protocol/in_app_message.dart' as _iuaghtaj;
import 'package:lotse/src/client/src/protocol/in_app_message_list_item.dart'
    as _it4jt2kp;
import 'package:lotse/src/client/src/protocol/in_app_message_report.dart'
    as _iqeef7am;
import 'package:lotse/src/client/src/protocol/in_app_message_style.dart'
    as _i6wilhlt;
import 'package:lotse/src/client/src/protocol/journey_detail.dart' as _ipj5sx6m;
import 'package:lotse/src/client/src/protocol/journey_input.dart' as _iz615xmq;
import 'package:lotse/src/client/src/protocol/journey_report.dart' as _i3543zgv;
import 'package:lotse/src/client/src/protocol/link.dart' as _imhn7g80;
import 'package:lotse/src/client/src/protocol/link_click.dart' as _i95j1fet;
import 'package:lotse/src/client/src/protocol/lotse_app.dart' as _iwe5i9u8;
import 'package:lotse/src/client/src/protocol/my_feedback.dart' as _i7qvzrlb;
import 'package:lotse/src/client/src/protocol/my_feedback_thread.dart' as _ixkb7t32;
import 'package:lotse/src/client/src/protocol/project.dart' as _ixeiu5z6;
import 'package:lotse/src/client/src/protocol/project_invitation_info.dart'
    as _i729nurv;
import 'package:lotse/src/client/src/protocol/project_member_info.dart'
    as _iiynwmmr;
import 'package:lotse/src/client/src/protocol/push_credential.dart' as _iykvszre;
import 'package:lotse/src/client/src/protocol/push_provider.dart' as _ih2izyow;
import 'package:lotse/src/client/src/protocol/replay_chunk.dart' as _iee74lve;
import 'package:lotse/src/client/src/protocol/resolved_link.dart' as _i5zi1oud;
import 'package:lotse/src/client/src/protocol/retention_report.dart' as _i50257ml;
import 'package:lotse/src/client/src/protocol/retention_split.dart' as _i1z7vpha;
import 'package:lotse/src/client/src/protocol/sdk_in_app_message.dart' as _izpbyx5h;
import 'package:lotse/src/client/src/protocol/sdk_survey.dart' as _i5ze76md;
import 'package:lotse/src/client/src/protocol/segment.dart' as _i0v8239j;
import 'package:lotse/src/client/src/protocol/setup_diagnosis.dart' as _irbew980;
import 'package:lotse/src/client/src/protocol/support_chat.dart' as _igjgpeew;
import 'package:lotse/src/client/src/protocol/survey.dart' as _i9wfizaq;
import 'package:lotse/src/client/src/protocol/survey_group.dart' as _i3k6u36k;
import 'package:lotse/src/client/src/protocol/survey_kind.dart' as _igtgltl2;
import 'package:lotse/src/client/src/protocol/survey_report.dart' as _ivviso22;
import 'package:lotse/src/client/src/protocol/survey_response_page.dart'
    as _iopuxx20;
import 'package:lotse/src/client/src/protocol/timeline.dart' as _iol68c7o;
import 'package:lotse/src/client/src/protocol/tracked_event.dart' as _inlxo86g;
import 'package:lotse/src/client/src/protocol/tracked_tap.dart' as _izr1kezp;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
///
/// Starting a registration or a password reset mails an address nobody has
/// proven to own yet, so both are rate limited before anything is sent.
/// {@category Endpoint}
class EndpointEmailIdp extends _iaic.EndpointEmailIdpBase {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Starts the registration for a new user account with an email-based login
  /// associated to it, and mails a verification code to [email].
  ///
  /// Always returns an account request ID, which can be used to complete the
  /// registration. If the email is already registered, no mail goes out and
  /// the returned ID will not be valid.
  ///
  /// Throws an [EmailAccountRequestException] with reason
  /// [EmailAccountRequestExceptionReason.tooManyAttempts] when too many
  /// registrations were started for this address, from this client or in
  /// total, whether the address is registered or not.
  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be sent out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] with reason
  /// [EmailAccountPasswordResetExceptionReason.tooManyAttempts] when too many
  /// resets were requested for this address or from this client.
  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _iacc.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// If [refreshToken] is omitted, cookie-mode web clients fall back to the
  /// configured HttpOnly refresh cookie. When neither source is present this
  /// throws [RefreshTokenNotFoundException], the same public "no usable refresh
  /// credential" exception used for unknown refresh tokens.
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'jwtRefresh',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// Console endpoint for the reports of the pillar "Verstehen". Every method
/// checks that the project belongs to the caller, like the reading methods
/// of `ProjectEndpoint`, and every query filters by that project. Reading
/// needs no quota and works on a suspended project too.
/// {@category Endpoint}
class EndpointAnalytics extends _isc.EndpointRef {
  EndpointAnalytics(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'analytics';

  /// Key figures of [projectId] in the range [from, to), at most
  /// [maxOverviewRange] long. See [AnalyticsOverview].
  _ida.Future<_ir5ronot.AnalyticsOverview> overview(
    int projectId,
    DateTime from,
    DateTime to,
  ) => caller.callServerEndpoint<_ir5ronot.AnalyticsOverview>(
    'analytics',
    'overview',
    {
      'projectId': projectId,
      'from': from,
      'to': to,
    },
  );

  /// Clicks, installs, active after 7 days and [goalEvent] per campaign,
  /// source and medium for installs in [from, to), at most
  /// [maxOverviewRange] long. See [AcquisitionReport].
  _ida.Future<_i20y0aod.AcquisitionReport> acquisition(
    int projectId,
    DateTime from,
    DateTime to, {
    String? goalEvent,
  }) => caller.callServerEndpoint<_i20y0aod.AcquisitionReport>(
    'analytics',
    'acquisition',
    {
      'projectId': projectId,
      'from': from,
      'to': to,
      'goalEvent': goalEvent,
    },
  );

  /// Recipients, sent, opened and [goalEvent] within 24 hours of the send
  /// for one campaign of [projectId]. See [CampaignReport].
  _ida.Future<_ie9wnyd5.CampaignReport> campaignReport(
    int projectId,
    int campaignId, {
    String? goalEvent,
  }) => caller.callServerEndpoint<_ie9wnyd5.CampaignReport>(
    'analytics',
    'campaignReport',
    {
      'projectId': projectId,
      'campaignId': campaignId,
      'goalEvent': goalEvent,
    },
  );

  /// The ordered funnel through [steps] for devices that did step 1 in the
  /// last [withinDays] days, each later step within [conversionDays] of
  /// step 1, split by [split]. See [FunnelReport]. The drop-offs of a step
  /// are the segment condition funnelDropout with the same parts.
  _ida.Future<_iu7f39kv.FunnelReport> funnel(
    int projectId,
    List<_i1oe7xkk.FunnelStep> steps, {
    required int withinDays,
    required int conversionDays,
    _i7u407uy.FunnelSplit? split,
  }) => caller.callServerEndpoint<_iu7f39kv.FunnelReport>(
    'analytics',
    'funnel',
    {
      'projectId': projectId,
      'steps': steps,
      'withinDays': withinDays,
      'conversionDays': conversionDays,
      'split': split,
    },
  );

  /// Installs in [from, to), at most [maxOverviewRange] long, by week from
  /// [from], and per week the share that sent a session_start on day 1, 7
  /// and 30, split by [split]. See [RetentionReport].
  _ida.Future<_i50257ml.RetentionReport> retention(
    int projectId,
    DateTime from,
    DateTime to, {
    _i1z7vpha.RetentionSplit? split,
  }) => caller.callServerEndpoint<_i50257ml.RetentionReport>(
    'analytics',
    'retention',
    {
      'projectId': projectId,
      'from': from,
      'to': to,
      'split': split,
    },
  );

  /// The screens with heatmap taps in the last [days] days, on [platform] or
  /// all platforms, the most tapped first.
  _ida.Future<List<_ixzdz37m.HeatmapScreen>> heatmapScreens(
    int projectId,
    int days, {
    _ipw7cd6p.DevicePlatform? platform,
  }) => caller.callServerEndpoint<List<_ixzdz37m.HeatmapScreen>>(
    'analytics',
    'heatmapScreens',
    {
      'projectId': projectId,
      'days': days,
      'platform': platform,
    },
  );

  /// The taps of [screen] on [platform] in [widthClass] over the last
  /// [days] days, of [appVersion] or all versions, counted in cells over
  /// the background of the screen. See [HeatmapReport].
  _ida.Future<_ij0uml61.HeatmapReport> heatmap(
    int projectId,
    String screen,
    _ipw7cd6p.DevicePlatform platform,
    _i0sl3x5f.HeatmapWidthClass widthClass,
    int days, {
    String? appVersion,
  }) => caller.callServerEndpoint<_ij0uml61.HeatmapReport>(
    'analytics',
    'heatmap',
    {
      'projectId': projectId,
      'screen': screen,
      'platform': platform,
      'widthClass': widthClass,
      'days': days,
      'appVersion': appVersion,
    },
  );

  /// The event of [query] per day in [from, to), at most [maxOverviewRange]
  /// long, as events and distinct devices, split as [query] says. See
  /// [ExplorerReport].
  _ida.Future<_isgqgait.ExplorerReport> explore(
    int projectId,
    DateTime from,
    DateTime to,
    _i12dwnjx.ExplorerQuery query,
  ) => caller.callServerEndpoint<_isgqgait.ExplorerReport>(
    'analytics',
    'explore',
    {
      'projectId': projectId,
      'from': from,
      'to': to,
      'query': query,
    },
  );

  /// Install, click, attribution, events, feedback and pushes of the device
  /// [deviceId] in [from, to), at most [maxOverviewRange] long, newest
  /// first. See [Timeline].
  _ida.Future<_iol68c7o.Timeline> deviceTimeline(
    int projectId,
    int deviceId,
    DateTime from,
    DateTime to,
  ) => caller.callServerEndpoint<_iol68c7o.Timeline>(
    'analytics',
    'deviceTimeline',
    {
      'projectId': projectId,
      'deviceId': deviceId,
      'from': from,
      'to': to,
    },
  );

  /// The timeline of every device the app last identified as the user
  /// [userId], in [from, to). See [Timeline].
  _ida.Future<_iol68c7o.Timeline> userTimeline(
    int projectId,
    int userId,
    DateTime from,
    DateTime to,
  ) => caller.callServerEndpoint<_iol68c7o.Timeline>(
    'analytics',
    'userTimeline',
    {
      'projectId': projectId,
      'userId': userId,
      'from': from,
      'to': to,
    },
  );

  /// Users of the project, last seen first, optionally those whose external
  /// id starts with [search]. [limit] defaults to 50, at most 100.
  _ida.Future<List<_itcuuu2x.AppUserListItem>> listUsers(
    int projectId, {
    String? search,
    int? limit,
  }) => caller.callServerEndpoint<List<_itcuuu2x.AppUserListItem>>(
    'analytics',
    'listUsers',
    {
      'projectId': projectId,
      'search': search,
      'limit': limit,
    },
  );

  /// Devices in the segment right now, and the devices that saw, tapped and
  /// dismissed the in-app message [messageId] since it became active. See
  /// [InAppMessageReport].
  _ida.Future<_iqeef7am.InAppMessageReport> inAppMessageReport(
    int projectId,
    int messageId,
  ) => caller.callServerEndpoint<_iqeef7am.InAppMessageReport>(
    'analytics',
    'inAppMessageReport',
    {
      'projectId': projectId,
      'messageId': messageId,
    },
  );

  /// Waiting devices, exits, and per group assigned, sent, opened, matured
  /// and goal, with the chance of B against A and of each variant against
  /// the holdout. See [JourneyReport].
  _ida.Future<_i3543zgv.JourneyReport> journeyReport(
    int projectId,
    int journeyId,
  ) => caller.callServerEndpoint<_i3543zgv.JourneyReport>(
    'analytics',
    'journeyReport',
    {
      'projectId': projectId,
      'journeyId': journeyId,
    },
  );

  /// Devices in the segment right now, the devices that saw and dismissed
  /// the survey [surveyId] since it became active, its answers by score or
  /// choice and, for an NPS survey, the NPS. See [SurveyReport].
  _ida.Future<_ivviso22.SurveyReport> surveyReport(
    int projectId,
    int surveyId,
  ) => caller.callServerEndpoint<_ivviso22.SurveyReport>(
    'analytics',
    'surveyReport',
    {
      'projectId': projectId,
      'surveyId': surveyId,
    },
  );

  /// One page of the answers to the survey [surveyId], newest first, each
  /// with platform, version and campaign of its device. [beforeId] is
  /// [SurveyResponsePage.nextBeforeId] of the page before. [group] keeps the
  /// NPS answers of one group, [choice] those of one choice, [withComment]
  /// those with a comment.
  _ida.Future<_iopuxx20.SurveyResponsePage> surveyResponses(
    int projectId,
    int surveyId, {
    _i3k6u36k.SurveyGroup? group,
    int? choice,
    bool? withComment,
    int? beforeId,
  }) => caller.callServerEndpoint<_iopuxx20.SurveyResponsePage>(
    'analytics',
    'surveyResponses',
    {
      'projectId': projectId,
      'surveyId': surveyId,
      'group': group,
      'choice': choice,
      'withComment': withComment,
      'beforeId': beforeId,
    },
  );

  /// One table or report of the console as a CSV file, see [CsvExport] and
  /// [CsvExportRequest]. Access, suspension, then the export budget
  /// [csvExportsPerProject], in this order: unlike reading, an export is
  /// refused for a suspended project. At most [csvExportMaxRows] rows and
  /// [csvExportMaxBytes] bytes.
  _ida.Future<_ihn6x8sm.CsvExport> exportCsv(
    int projectId,
    _ib1qclyo.CsvExportRequest request,
  ) => caller.callServerEndpoint<_ihn6x8sm.CsvExport>(
    'analytics',
    'exportCsv',
    {
      'projectId': projectId,
      'request': request,
    },
  );
}

/// Console endpoint. Authenticated console users manage the projects they own
/// or are members of. Every method first checks that the caller has access to
/// the project and every query filters by that project. Methods that create
/// something or make the project act outside check access, suspension and
/// quota, in this order: [_activeProject] (or [_activeOwnerProject]) first,
/// then the quota. What only the owner may do goes through [_ownerProject]
/// or [_activeOwnerProject], see `projects/ownership.dart`.
/// {@category Endpoint}
class EndpointProject extends _isc.EndpointRef {
  EndpointProject(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'project';

  /// Projects the caller owns and projects it is a member of. Bounded by
  /// [maxProjectsPerUser] and by the members quota of every project it joined
  /// by invitation, so it needs no limit of its own.
  _ida.Future<List<_ixeiu5z6.Project>> listProjects() =>
      caller.callServerEndpoint<List<_ixeiu5z6.Project>>(
        'project',
        'listProjects',
        {},
      );

  /// Creates a project whose links live under `<handle>.<link base domain>`.
  /// The handle cannot be changed later.
  _ida.Future<_ixeiu5z6.Project> createProject(
    String name,
    String handle,
  ) => caller.callServerEndpoint<_ixeiu5z6.Project>(
    'project',
    'createProject',
    {
      'name': name,
      'handle': handle,
    },
  );

  /// Deletes the project with everything in it: apps, push credentials, keys,
  /// the identity secret, links, clicks, devices, push tokens, users, events,
  /// feedback with its screenshots, campaigns, segments. The database
  /// cascades from the project row. The handle is retired in the same
  /// transaction and never given out again, see [RetiredHandle].
  ///
  /// [confirmHandle] repeats the handle, so a console tab showing another
  /// project cannot delete this one. A suspended project is refused: the
  /// suspension is the operator's decision, and so is deleting such a
  /// project (deploy/README.md, "Suspending a project"). Only the owner may
  /// delete; members and invitations go with the project.
  _ida.Future<void> deleteProject(
    int projectId,
    String confirmHandle,
  ) => caller.callServerEndpoint<void>(
    'project',
    'deleteProject',
    {
      'projectId': projectId,
      'confirmHandle': confirmHandle,
    },
  );

  _ida.Future<_ixeiu5z6.Project> getProject(int projectId) =>
      caller.callServerEndpoint<_ixeiu5z6.Project>(
        'project',
        'getProject',
        {'projectId': projectId},
      );

  /// Switches the support chat of the project on or off. Switching it on
  /// makes the project act outside, so it needs an active project; there is
  /// no quota because nothing is created, and the conversations it allows
  /// count into the feedback quotas. Switching it off is cleanup and works on
  /// a suspended project too. Existing conversations stay as they are.
  _ida.Future<_ixeiu5z6.Project> setSupportChatEnabled(
    int projectId,
    bool enabled,
  ) => caller.callServerEndpoint<_ixeiu5z6.Project>(
    'project',
    'setSupportChatEnabled',
    {
      'projectId': projectId,
      'enabled': enabled,
    },
  );

  /// Bounded by [maxAppsPerProject], so it needs no limit of its own.
  _ida.Future<List<_iwe5i9u8.LotseApp>> listApps(int projectId) =>
      caller.callServerEndpoint<List<_iwe5i9u8.LotseApp>>(
        'project',
        'listApps',
        {'projectId': projectId},
      );

  _ida.Future<_iwe5i9u8.LotseApp> createApp(
    int projectId, {
    required _ipw7cd6p.DevicePlatform platform,
    required String bundleId,
    String? teamId,
    String? appStoreId,
    List<String>? sha256Fingerprints,
  }) => caller.callServerEndpoint<_iwe5i9u8.LotseApp>(
    'project',
    'createApp',
    {
      'projectId': projectId,
      'platform': platform,
      'bundleId': bundleId,
      'teamId': teamId,
      'appStoreId': appStoreId,
      'sha256Fingerprints': sha256Fingerprints,
    },
  );

  /// Replaces the certificate fingerprints of the app [appId], normalized
  /// like in [createApp]. They go out through `assetlinks.json`, so this is
  /// refused for a suspended project. Android verifies App Links when the
  /// app is installed or updated; a device that verified against the old
  /// fingerprints keeps its result until then.
  _ida.Future<_iwe5i9u8.LotseApp> updateAppFingerprints(
    int projectId,
    int appId,
    List<String> sha256Fingerprints,
  ) => caller.callServerEndpoint<_iwe5i9u8.LotseApp>(
    'project',
    'updateAppFingerprints',
    {
      'projectId': projectId,
      'appId': appId,
      'sha256Fingerprints': sha256Fingerprints,
    },
  );

  /// Why a link of the project opens in the browser instead of the app:
  /// checks of the apps, of the well-known files as a phone fetches them,
  /// Google's verdict per fingerprint and the link traffic of the last days,
  /// narrowed to the link [slug] when given. See [SetupDiagnosis].
  ///
  /// Access, then the budget [setupDiagnosesPerProject]: every run makes
  /// requests to the link domain and to Google. A suspended project is
  /// diagnosed too; the suspension is its first finding.
  _ida.Future<_irbew980.SetupDiagnosis> diagnoseSetup(
    int projectId, {
    String? slug,
  }) => caller.callServerEndpoint<_irbew980.SetupDiagnosis>(
    'project',
    'diagnoseSetup',
    {
      'projectId': projectId,
      'slug': slug,
    },
  );

  /// Newest keys first, at most [maxApiKeysListed]. Only keys that are not
  /// revoked count against [maxActiveApiKeysPerProject], so revoked ones pile
  /// up over time and this list needs a bound of its own.
  _ida.Future<List<_imzvo1nf.ApiKey>> listApiKeys(int projectId) =>
      caller.callServerEndpoint<List<_imzvo1nf.ApiKey>>(
        'project',
        'listApiKeys',
        {'projectId': projectId},
      );

  /// Creates a key pair. The secret is returned exactly once.
  _ida.Future<_i0qvu201.ApiKeyCreated> createApiKey(
    int projectId,
    String label,
  ) => caller.callServerEndpoint<_i0qvu201.ApiKeyCreated>(
    'project',
    'createApiKey',
    {
      'projectId': projectId,
      'label': label,
    },
  );

  _ida.Future<void> revokeApiKey(
    int projectId,
    int keyId,
  ) => caller.callServerEndpoint<void>(
    'project',
    'revokeApiKey',
    {
      'projectId': projectId,
      'keyId': keyId,
    },
  );

  /// Agent tokens of the project, newest first, at most
  /// [maxAgentTokensListed], revoked and expired ones included. The token
  /// itself is never in here and its hash is server-only.
  _ida.Future<List<_izywjc6s.AgentToken>> listAgentTokens(int projectId) =>
      caller.callServerEndpoint<List<_izywjc6s.AgentToken>>(
        'project',
        'listAgentTokens',
        {'projectId': projectId},
      );

  /// Creates a token for an AI agent that acts on [projectId] through the
  /// MCP server. Any member may, not only the owner: the token can do nothing
  /// its creator could not do in the console, and it stops working when the
  /// creator leaves. [lifetimeDays] is one of [agentTokenLifetimeDays]. The
  /// token is returned exactly once.
  _ida.Future<_ire6rsvy.AgentTokenCreated> createAgentToken(
    int projectId,
    String name,
    _iftmj5k7.AgentTokenLevel level,
    int lifetimeDays,
  ) => caller.callServerEndpoint<_ire6rsvy.AgentTokenCreated>(
    'project',
    'createAgentToken',
    {
      'projectId': projectId,
      'name': name,
      'level': level,
      'lifetimeDays': lifetimeDays,
    },
  );

  /// Like [revokeApiKey], only the access is checked: a suspended project
  /// can still be cleaned up. Any member may revoke any token of the project.
  _ida.Future<void> revokeAgentToken(
    int projectId,
    int tokenId,
  ) => caller.callServerEndpoint<void>(
    'project',
    'revokeAgentToken',
    {
      'projectId': projectId,
      'tokenId': tokenId,
    },
  );

  /// Whether the project has an identity secret, since when, and whether
  /// identify requires a valid user hash. Never the secret. Reading works on
  /// a suspended project too.
  _ida.Future<_iz05sm2g.IdentityVerificationStatus> getIdentityVerification(
    int projectId,
  ) => caller.callServerEndpoint<_iz05sm2g.IdentityVerificationStatus>(
    'project',
    'getIdentityVerification',
    {'projectId': projectId},
  );

  /// Generates the identity secret of the project, or a new one that
  /// replaces the current secret at once: hashes of the old one fail from the
  /// next identify on, so the customer's backend has to switch as well. The
  /// requirement stays as it is. The secret is returned exactly once.
  ///
  /// No quota of its own: one secret per project, generating again replaces
  /// it.
  _ida.Future<_it6kuuwq.IdentitySecretCreated> generateIdentitySecret(
    int projectId,
  ) => caller.callServerEndpoint<_it6kuuwq.IdentitySecretCreated>(
    'project',
    'generateIdentitySecret',
    {'projectId': projectId},
  );

  /// Deletes the identity secret of the project and with it the requirement:
  /// identify takes every user id again, as without verification. Creates
  /// nothing and lets the project act on no one, so it works on a suspended
  /// project too: an owner must be able to drop a leaked secret.
  _ida.Future<_iz05sm2g.IdentityVerificationStatus> deleteIdentitySecret(
    int projectId,
  ) => caller.callServerEndpoint<_iz05sm2g.IdentityVerificationStatus>(
    'project',
    'deleteIdentitySecret',
    {'projectId': projectId},
  );

  /// Switches on or off whether identify requires a valid user hash. On
  /// needs an identity secret; without one the call is refused. Either way
  /// only identify gets stricter or looser, nothing is created and nothing
  /// reaches outside, so it works on a suspended project too.
  _ida.Future<_iz05sm2g.IdentityVerificationStatus>
  setIdentityVerificationRequired(
    int projectId,
    bool enabled,
  ) => caller.callServerEndpoint<_iz05sm2g.IdentityVerificationStatus>(
    'project',
    'setIdentityVerificationRequired',
    {
      'projectId': projectId,
      'enabled': enabled,
    },
  );

  /// Newest lastSeenAt first, ties by descending id so the order is total.
  /// Pass [attributedLinkId] to get only the devices attributed to that link,
  /// which is what the link detail counts. [limit] defaults to
  /// [defaultReadLimit] and is capped at [maxDeviceListLimit].
  _ida.Future<List<_illpjbsr.Device>> listDevices(
    int projectId, {
    int? limit,
    int? attributedLinkId,
  }) => caller.callServerEndpoint<List<_illpjbsr.Device>>(
    'project',
    'listDevices',
    {
      'projectId': projectId,
      'limit': limit,
      'attributedLinkId': attributedLinkId,
    },
  );

  /// One device, for the device detail the feedback inbox links to. A device
  /// of another project is not found, like an unknown one.
  _ida.Future<_illpjbsr.Device> getDevice(
    int projectId,
    int deviceId,
  ) => caller.callServerEndpoint<_illpjbsr.Device>(
    'project',
    'getDevice',
    {
      'projectId': projectId,
      'deviceId': deviceId,
    },
  );

  /// Events of the project, newest first. [limit] defaults to
  /// [defaultReadLimit] and is capped at [maxEventListLimit].
  ///
  /// Without [sinceId] this is the newest page. With [sinceId] it is the
  /// oldest page above that id, still returned newest first: a caller that
  /// takes the highest id of every page as the next [sinceId] walks the
  /// stream from that cursor upwards without duplicates and without gaps,
  /// however far it fell behind. Ids are unique, so the order is total.
  _ida.Future<List<_i7mn5lps.Event>> listEvents(
    int projectId, {
    int? sinceId,
    int? limit,
  }) => caller.callServerEndpoint<List<_i7mn5lps.Event>>(
    'project',
    'listEvents',
    {
      'projectId': projectId,
      'sinceId': sinceId,
      'limit': limit,
    },
  );

  /// Newest links first. Bounded by [maxLinksPerProject], so the whole list
  /// fits into one call and needs no limit of its own.
  _ida.Future<List<_imhn7g80.Link>> listLinks(int projectId) =>
      caller.callServerEndpoint<List<_imhn7g80.Link>>(
        'project',
        'listLinks',
        {'projectId': projectId},
      );

  _ida.Future<_imhn7g80.Link> getLink(
    int projectId,
    int linkId,
  ) => caller.callServerEndpoint<_imhn7g80.Link>(
    'project',
    'getLink',
    {
      'projectId': projectId,
      'linkId': linkId,
    },
  );

  /// Creates a link under /l/[slug] on the project's link domain. Slugs are
  /// unique per project.
  _ida.Future<_imhn7g80.Link> createLink(
    int projectId, {
    required String slug,
    required String targetPath,
    String? campaign,
    String? source,
    String? medium,
    String? fallbackIos,
    String? fallbackAndroid,
    String? fallbackWeb,
  }) => caller.callServerEndpoint<_imhn7g80.Link>(
    'project',
    'createLink',
    {
      'projectId': projectId,
      'slug': slug,
      'targetPath': targetPath,
      'campaign': campaign,
      'source': source,
      'medium': medium,
      'fallbackIos': fallbackIos,
      'fallbackAndroid': fallbackAndroid,
      'fallbackWeb': fallbackWeb,
    },
  );

  /// Newest clicks of one link first, ties by descending id so the order is
  /// total. [limit] defaults to [defaultReadLimit] and is capped at
  /// [maxLinkClickListLimit].
  _ida.Future<List<_i95j1fet.LinkClick>> listLinkClicks(
    int projectId,
    int linkId, {
    int? limit,
  }) => caller.callServerEndpoint<List<_i95j1fet.LinkClick>>(
    'project',
    'listLinkClicks',
    {
      'projectId': projectId,
      'linkId': linkId,
      'limit': limit,
    },
  );

  /// Stores the FCM service account of [appId], encrypted. Replaces an
  /// earlier upload. The returned row carries only the metadata; the payload
  /// is server-only and the JSON is never logged. Only the owner may upload:
  /// the account can send to every device of the app.
  _ida.Future<_iykvszre.PushCredential> uploadPushCredential(
    int projectId,
    int appId,
    String serviceAccountJson,
  ) => caller.callServerEndpoint<_iykvszre.PushCredential>(
    'project',
    'uploadPushCredential',
    {
      'projectId': projectId,
      'appId': appId,
      'serviceAccountJson': serviceAccountJson,
    },
  );

  /// Stores the APNs key of the iOS app [appId], encrypted: the content of
  /// the .p8 file with its Key ID and the Team ID of the developer account.
  /// Pushes go to [environment] with the app's bundle id as topic. Replaces
  /// an earlier upload. The returned row carries only the metadata; the key
  /// is server-only and never logged. Only the owner may upload: the key can
  /// send to every device of the app.
  ///
  /// No quota of its own: one credential per app and provider, and the apps
  /// are bounded by their quota.
  _ida.Future<_iykvszre.PushCredential> uploadApnsCredential(
    int projectId,
    int appId, {
    required String p8Key,
    required String keyId,
    required String teamId,
    required _iiz2r0fa.ApnsEnvironment environment,
  }) => caller.callServerEndpoint<_iykvszre.PushCredential>(
    'project',
    'uploadApnsCredential',
    {
      'projectId': projectId,
      'appId': appId,
      'p8Key': p8Key,
      'keyId': keyId,
      'teamId': teamId,
      'environment': environment,
    },
  );

  /// Metadata of the app's credential for [provider], or null when none was
  /// uploaded. The key or service account itself never leaves the server.
  _ida.Future<_iykvszre.PushCredential?> getPushCredential(
    int projectId,
    int appId, {
    required _ih2izyow.PushProvider provider,
  }) => caller.callServerEndpoint<_iykvszre.PushCredential?>(
    'project',
    'getPushCredential',
    {
      'projectId': projectId,
      'appId': appId,
      'provider': provider,
    },
  );

  /// Newest campaigns first, at most [maxCampaignsListed]. Sent campaigns
  /// stay, so unlike links or apps this list is not bounded by a quota.
  _ida.Future<List<_isnrua4r.Campaign>> listCampaigns(int projectId) =>
      caller.callServerEndpoint<List<_isnrua4r.Campaign>>(
        'project',
        'listCampaigns',
        {'projectId': projectId},
      );

  _ida.Future<_isnrua4r.Campaign> getCampaign(
    int projectId,
    int campaignId,
  ) => caller.callServerEndpoint<_isnrua4r.Campaign>(
    'project',
    'getCampaign',
    {
      'projectId': projectId,
      'campaignId': campaignId,
    },
  );

  /// Number of devices of the project that [segment] matches right now. The
  /// console shows it live while the segment is edited. [segment] is the
  /// predicate as JSON text; an invalid one is rejected, never counted as 0.
  _ida.Future<int> segmentCount(
    int projectId,
    String? segment,
  ) => caller.callServerEndpoint<int>(
    'project',
    'segmentCount',
    {
      'projectId': projectId,
      'segment': segment,
    },
  );

  /// The saved segments of the project, by name. Bounded by
  /// [maxSegmentsPerProject], so the list needs no limit of its own.
  _ida.Future<List<_i0v8239j.Segment>> listSegments(int projectId) =>
      caller.callServerEndpoint<List<_i0v8239j.Segment>>(
        'project',
        'listSegments',
        {'projectId': projectId},
      );

  /// Saves [segment] (the predicate as JSON text, see [segmentCount]) under
  /// [name], unique per project. A segment without conditions is refused:
  /// "every device" needs no name.
  _ida.Future<_i0v8239j.Segment> createSegment(
    int projectId, {
    required String name,
    required String segment,
  }) => caller.callServerEndpoint<_i0v8239j.Segment>(
    'project',
    'createSegment',
    {
      'projectId': projectId,
      'name': name,
      'segment': segment,
    },
  );

  /// Deletes a saved segment. Campaigns keep their copy of the predicate.
  /// Works on a suspended project too.
  _ida.Future<void> deleteSegment(
    int projectId,
    int segmentId,
  ) => caller.callServerEndpoint<void>(
    'project',
    'deleteSegment',
    {
      'projectId': projectId,
      'segmentId': segmentId,
    },
  );

  /// Creates a campaign in status draft. [linkId] must belong to the project
  /// and decides which app route the push opens. [segment] is the audience
  /// predicate as JSON text, see ARCHITECTURE.md; without it the campaign goes
  /// to every device of the project. Title and body are checked by
  /// [checkCampaignInput], so the push fits the providers' payload limit.
  _ida.Future<_isnrua4r.Campaign> createCampaign(
    int projectId, {
    required String title,
    required String body,
    int? linkId,
    String? segment,
  }) => caller.callServerEndpoint<_isnrua4r.Campaign>(
    'project',
    'createCampaign',
    {
      'projectId': projectId,
      'title': title,
      'body': body,
      'linkId': linkId,
      'segment': segment,
    },
  );

  /// Creates one pending delivery per device of the project that matches the
  /// campaign's segment and has a valid token for a push credential of the
  /// project, puts the campaign into sending and hands it to the worker.
  ///
  /// A scheduled campaign is sent right away as well; its planned send then
  /// finds it gone and does nothing.
  ///
  /// Only a draft is sent, and only once: the status change, the send quota
  /// and the deliveries are one transaction, see `push/campaign_send.dart`.
  /// Calling this again while the campaign is in sending creates nothing and
  /// returns the campaign, and restarts the worker if it never got going. A
  /// finished campaign is refused.
  _ida.Future<_isnrua4r.Campaign> sendCampaign(
    int projectId,
    int campaignId,
  ) => caller.callServerEndpoint<_isnrua4r.Campaign>(
    'project',
    'sendCampaign',
    {
      'projectId': projectId,
      'campaignId': campaignId,
    },
  );

  /// Plans the send of a draft for [sendAt], at least [minScheduleLead] and
  /// at most [maxScheduleAhead] from now. A scheduled campaign can be moved
  /// to another time the same way. At [sendAt] it is sent like
  /// [sendCampaign] would, with suspension and send quota checked then; if
  /// it cannot go out it becomes failed with the reason in `sendError`.
  ///
  /// Access and suspension first; the budget [campaignSchedulesPerProject]
  /// is consumed right before the campaign changes, so a refused time costs
  /// nothing. A campaign has one pending future call at most: moving it
  /// replaces the call, see [syncScheduledSend].
  _ida.Future<_isnrua4r.Campaign> scheduleCampaign(
    int projectId,
    int campaignId,
    DateTime sendAt,
  ) => caller.callServerEndpoint<_isnrua4r.Campaign>(
    'project',
    'scheduleCampaign',
    {
      'projectId': projectId,
      'campaignId': campaignId,
      'sendAt': sendAt,
    },
  );

  /// Takes a scheduled campaign back to draft and cancels its planned send.
  /// Only checks access, so a member of a suspended project can still stop
  /// a send. No budget: there is one call to cancel per scheduling, and
  /// scheduling has one.
  _ida.Future<_isnrua4r.Campaign> unscheduleCampaign(
    int projectId,
    int campaignId,
  ) => caller.callServerEndpoint<_isnrua4r.Campaign>(
    'project',
    'unscheduleCampaign',
    {
      'projectId': projectId,
      'campaignId': campaignId,
    },
  );

  /// Delivery counts of one campaign, which is what the console polls.
  _ida.Future<_ih34aj5x.DeliverySummary> deliverySummary(
    int projectId,
    int campaignId,
  ) => caller.callServerEndpoint<_ih34aj5x.DeliverySummary>(
    'project',
    'deliverySummary',
    {
      'projectId': projectId,
      'campaignId': campaignId,
    },
  );

  /// The newest journeys with their variants and assigned devices, at most
  /// [maxJourneysListed].
  _ida.Future<List<_ipj5sx6m.JourneyDetail>> listJourneys(int projectId) =>
      caller.callServerEndpoint<List<_ipj5sx6m.JourneyDetail>>(
        'project',
        'listJourneys',
        {'projectId': projectId},
      );

  _ida.Future<_ipj5sx6m.JourneyDetail> getJourney(
    int projectId,
    int journeyId,
  ) => caller.callServerEndpoint<_ipj5sx6m.JourneyDetail>(
    'project',
    'getJourney',
    {
      'projectId': projectId,
      'journeyId': journeyId,
    },
  );

  /// Creates a journey in status draft with one campaign per variant. The
  /// links of the variants must belong to the project; the segment is JSON
  /// text, like for campaigns.
  _ida.Future<_ipj5sx6m.JourneyDetail> createJourney(
    int projectId,
    _iz615xmq.JourneyInput input,
  ) => caller.callServerEndpoint<_ipj5sx6m.JourneyDetail>(
    'project',
    'createJourney',
    {
      'projectId': projectId,
      'input': input,
    },
  );

  /// Replaces the content of a draft, variants included. An active or ended
  /// journey is refused.
  _ida.Future<_ipj5sx6m.JourneyDetail> updateJourney(
    int projectId,
    int journeyId,
    _iz615xmq.JourneyInput input,
  ) => caller.callServerEndpoint<_ipj5sx6m.JourneyDetail>(
    'project',
    'updateJourney',
    {
      'projectId': projectId,
      'journeyId': journeyId,
      'input': input,
    },
  );

  /// Decides the devices of a draft from now on. Refused beyond
  /// [maxActiveJourneysPerProject] and without a push credential; an active
  /// journey stays as it is.
  _ida.Future<_ipj5sx6m.JourneyDetail> activateJourney(
    int projectId,
    int journeyId,
  ) => caller.callServerEndpoint<_ipj5sx6m.JourneyDetail>(
    'project',
    'activateJourney',
    {
      'projectId': projectId,
      'journeyId': journeyId,
    },
  );

  /// Makes [variant] (0 for A, 1 for B) the winner of an active journey,
  /// also before the rule picks one. Final.
  _ida.Future<_ipj5sx6m.JourneyDetail> pickJourneyWinner(
    int projectId,
    int journeyId,
    int variant,
  ) => caller.callServerEndpoint<_ipj5sx6m.JourneyDetail>(
    'project',
    'pickJourneyWinner',
    {
      'projectId': projectId,
      'journeyId': journeyId,
      'variant': variant,
    },
  );

  /// Stops deciding devices, a draft included. Final. Cleanup, so it works
  /// on a suspended project too.
  _ida.Future<_ipj5sx6m.JourneyDetail> endJourney(
    int projectId,
    int journeyId,
  ) => caller.callServerEndpoint<_ipj5sx6m.JourneyDetail>(
    'project',
    'endJourney',
    {
      'projectId': projectId,
      'journeyId': journeyId,
    },
  );

  /// Deletes a draft or ended journey with its variants, their deliveries
  /// and its entries; the events stay. Cleanup, so it works on a suspended
  /// project too.
  _ida.Future<void> deleteJourney(
    int projectId,
    int journeyId,
  ) => caller.callServerEndpoint<void>(
    'project',
    'deleteJourney',
    {
      'projectId': projectId,
      'journeyId': journeyId,
    },
  );

  /// The newest in-app messages with the devices that saw and tapped each,
  /// at most [maxInAppMessagesListed].
  _ida.Future<List<_it4jt2kp.InAppMessageListItem>> listInAppMessages(
    int projectId,
  ) => caller.callServerEndpoint<List<_it4jt2kp.InAppMessageListItem>>(
    'project',
    'listInAppMessages',
    {'projectId': projectId},
  );

  _ida.Future<_iuaghtaj.InAppMessage> getInAppMessage(
    int projectId,
    int messageId,
  ) => caller.callServerEndpoint<_iuaghtaj.InAppMessage>(
    'project',
    'getInAppMessage',
    {
      'projectId': projectId,
      'messageId': messageId,
    },
  );

  /// Creates an in-app message in status draft. [linkId] must belong to the
  /// project; a tap opens its target path. [segment] is the audience
  /// predicate as JSON text, like for campaigns; without it every device of
  /// the project gets the message.
  _ida.Future<_iuaghtaj.InAppMessage> createInAppMessage(
    int projectId, {
    required String title,
    required String body,
    required _i6wilhlt.InAppMessageStyle style,
    int? linkId,
    String? buttonLabel,
    String? segment,
  }) => caller.callServerEndpoint<_iuaghtaj.InAppMessage>(
    'project',
    'createInAppMessage',
    {
      'projectId': projectId,
      'title': title,
      'body': body,
      'style': style,
      'linkId': linkId,
      'buttonLabel': buttonLabel,
      'segment': segment,
    },
  );

  /// Replaces the content of a draft. An active or ended message is refused.
  _ida.Future<_iuaghtaj.InAppMessage> updateInAppMessage(
    int projectId,
    int messageId, {
    required String title,
    required String body,
    required _i6wilhlt.InAppMessageStyle style,
    int? linkId,
    String? buttonLabel,
    String? segment,
  }) => caller.callServerEndpoint<_iuaghtaj.InAppMessage>(
    'project',
    'updateInAppMessage',
    {
      'projectId': projectId,
      'messageId': messageId,
      'title': title,
      'body': body,
      'style': style,
      'linkId': linkId,
      'buttonLabel': buttonLabel,
      'segment': segment,
    },
  );

  /// Delivers a draft from now on. Refused beyond
  /// [maxActiveInAppMessagesPerProject]; an active message stays as it is.
  _ida.Future<_iuaghtaj.InAppMessage> activateInAppMessage(
    int projectId,
    int messageId,
  ) => caller.callServerEndpoint<_iuaghtaj.InAppMessage>(
    'project',
    'activateInAppMessage',
    {
      'projectId': projectId,
      'messageId': messageId,
    },
  );

  /// Stops delivering the message, a draft included. Final. Cleanup, so it
  /// works on a suspended project too.
  _ida.Future<_iuaghtaj.InAppMessage> endInAppMessage(
    int projectId,
    int messageId,
  ) => caller.callServerEndpoint<_iuaghtaj.InAppMessage>(
    'project',
    'endInAppMessage',
    {
      'projectId': projectId,
      'messageId': messageId,
    },
  );

  /// The newest surveys, at most [maxSurveysListed].
  _ida.Future<List<_i9wfizaq.Survey>> listSurveys(int projectId) =>
      caller.callServerEndpoint<List<_i9wfizaq.Survey>>(
        'project',
        'listSurveys',
        {'projectId': projectId},
      );

  _ida.Future<_i9wfizaq.Survey> getSurvey(
    int projectId,
    int surveyId,
  ) => caller.callServerEndpoint<_i9wfizaq.Survey>(
    'project',
    'getSurvey',
    {
      'projectId': projectId,
      'surveyId': surveyId,
    },
  );

  /// Creates a survey in status draft. [choices] only for
  /// [SurveyKind.choice], [askComment] and [commentPrompt] only for
  /// [SurveyKind.nps]. [segment] is the audience predicate as JSON text, like
  /// for campaigns; without it every device of the project gets the survey.
  _ida.Future<_i9wfizaq.Survey> createSurvey(
    int projectId, {
    required _igtgltl2.SurveyKind kind,
    required String question,
    List<String>? choices,
    required bool askComment,
    String? commentPrompt,
    String? segment,
  }) => caller.callServerEndpoint<_i9wfizaq.Survey>(
    'project',
    'createSurvey',
    {
      'projectId': projectId,
      'kind': kind,
      'question': question,
      'choices': choices,
      'askComment': askComment,
      'commentPrompt': commentPrompt,
      'segment': segment,
    },
  );

  /// Replaces the content of a draft, its kind included. An active or ended
  /// survey is refused.
  _ida.Future<_i9wfizaq.Survey> updateSurvey(
    int projectId,
    int surveyId, {
    required _igtgltl2.SurveyKind kind,
    required String question,
    List<String>? choices,
    required bool askComment,
    String? commentPrompt,
    String? segment,
  }) => caller.callServerEndpoint<_i9wfizaq.Survey>(
    'project',
    'updateSurvey',
    {
      'projectId': projectId,
      'surveyId': surveyId,
      'kind': kind,
      'question': question,
      'choices': choices,
      'askComment': askComment,
      'commentPrompt': commentPrompt,
      'segment': segment,
    },
  );

  /// Delivers a draft from now on. Refused beyond
  /// [maxActiveSurveysPerProject]; an active survey stays as it is.
  _ida.Future<_i9wfizaq.Survey> activateSurvey(
    int projectId,
    int surveyId,
  ) => caller.callServerEndpoint<_i9wfizaq.Survey>(
    'project',
    'activateSurvey',
    {
      'projectId': projectId,
      'surveyId': surveyId,
    },
  );

  /// Stops delivering the survey, a draft included. Final. Cleanup, so it
  /// works on a suspended project too.
  _ida.Future<_i9wfizaq.Survey> endSurvey(
    int projectId,
    int surveyId,
  ) => caller.callServerEndpoint<_i9wfizaq.Survey>(
    'project',
    'endSurvey',
    {
      'projectId': projectId,
      'surveyId': surveyId,
    },
  );

  /// Deletes the survey in any status, its answers with it. The events
  /// survey_view, survey_dismiss and survey_answered stay; they hold no
  /// comment. Cleanup, so it works on a suspended project too.
  _ida.Future<void> deleteSurvey(
    int projectId,
    int surveyId,
  ) => caller.callServerEndpoint<void>(
    'project',
    'deleteSurvey',
    {
      'projectId': projectId,
      'surveyId': surveyId,
    },
  );

  /// One page of the feedback inbox, newest first. Every filter is optional;
  /// [platform] and [campaign] look at the device that sent the message and
  /// at the link it is attributed to. [waitingForReply] keeps the
  /// conversations in which the user wrote last, which includes every message
  /// nobody answered yet. Never touches the screenshot table.
  _ida.Future<_i0fj1xz3.FeedbackPage> listFeedback(
    int projectId, {
    _i7mfdxkk.FeedbackStatus? status,
    _i9lhucay.FeedbackCategory? category,
    _ipw7cd6p.DevicePlatform? platform,
    String? appVersion,
    String? campaign,
    bool? waitingForReply,
    int? page,
  }) => caller.callServerEndpoint<_i0fj1xz3.FeedbackPage>(
    'project',
    'listFeedback',
    {
      'projectId': projectId,
      'status': status,
      'category': category,
      'platform': platform,
      'appVersion': appVersion,
      'campaign': campaign,
      'waitingForReply': waitingForReply,
      'page': page,
    },
  );

  /// One message with what Lotse knows around it: the device, the link it is
  /// attributed to, the [feedbackEventsBefore] events the device sent before
  /// the message (newest first), its screenshots without their bytes and the
  /// conversation below it (oldest first).
  _ida.Future<_ijy2s14x.FeedbackDetail> getFeedback(
    int projectId,
    int feedbackId,
  ) => caller.callServerEndpoint<_ijy2s14x.FeedbackDetail>(
    'project',
    'getFeedback',
    {
      'projectId': projectId,
      'feedbackId': feedbackId,
    },
  );

  /// Appends a reply of the team to the conversation and announces it on the
  /// device with a push. The push is a future call: it neither delays nor
  /// fails the reply, and its outcome lands in [FeedbackMessage.pushStatus].
  _ida.Future<_i7te3iey.FeedbackMessage> replyToFeedback(
    int projectId,
    int feedbackId,
    String body,
  ) => caller.callServerEndpoint<_i7te3iey.FeedbackMessage>(
    'project',
    'replyToFeedback',
    {
      'projectId': projectId,
      'feedbackId': feedbackId,
      'body': body,
    },
  );

  /// Live updates of one conversation while the console shows it, over a
  /// Serverpod streaming method (WebSocket). Each element says that the
  /// conversation changed; the console loads it with [getFeedback]. The first
  /// one arrives as soon as the stream listens.
  ///
  /// Reading, so owner and members get it, also for a suspended project.
  /// Before each signal access to the project and the message are checked
  /// again: a member who was removed, or a message that was deleted, ends the
  /// stream with "not found". The server ends the stream after
  /// [conversationStreamLifetime]; the console opens a new one with its
  /// current token. At most [maxConversationStreamsPerConsoleUser] per user
  /// are open at a time.
  _ida.Stream<_iwaox72k.FeedbackConversationChange> watchFeedback(
    int projectId,
    int feedbackId,
  ) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_iwaox72k.FeedbackConversationChange>,
        _iwaox72k.FeedbackConversationChange
      >(
        'project',
        'watchFeedback',
        {
          'projectId': projectId,
          'feedbackId': feedbackId,
        },
        {},
      );

  /// Marks the user's replies in one conversation as read by the team. Works
  /// on a suspended project too: reading is always possible.
  _ida.Future<void> markFeedbackReadByTeam(
    int projectId,
    int feedbackId,
  ) => caller.callServerEndpoint<void>(
    'project',
    'markFeedbackReadByTeam',
    {
      'projectId': projectId,
      'feedbackId': feedbackId,
    },
  );

  /// Bytes of one screenshot. This is the only way an image leaves the
  /// server; there is no web route for it.
  _ida.Future<_idt.ByteData> getFeedbackScreenshot(
    int projectId,
    int screenshotId,
  ) => caller.callServerEndpoint<_idt.ByteData>(
    'project',
    'getFeedbackScreenshot',
    {
      'projectId': projectId,
      'screenshotId': screenshotId,
    },
  );

  /// Deletes one heatmap background, for example one a device uploaded that
  /// does not show the app. The slot is free again, and the next device
  /// with taps on the screen fills it. Cleanup, so it works on a suspended
  /// project too.
  _ida.Future<void> deleteHeatmapBackground(
    int projectId,
    int backgroundId,
  ) => caller.callServerEndpoint<void>(
    'project',
    'deleteHeatmapBackground',
    {
      'projectId': projectId,
      'backgroundId': backgroundId,
    },
  );

  /// Bytes of one heatmap background, found through
  /// `AnalyticsEndpoint.heatmap`. Like screenshots, the only way it leaves
  /// the server.
  _ida.Future<_idt.ByteData> getHeatmapBackground(
    int projectId,
    int backgroundId,
  ) => caller.callServerEndpoint<_idt.ByteData>(
    'project',
    'getHeatmapBackground',
    {
      'projectId': projectId,
      'backgroundId': backgroundId,
    },
  );

  /// Works on a suspended project too: triaging the inbox is cleanup.
  _ida.Future<_intnc2la.Feedback> updateFeedbackStatus(
    int projectId,
    int feedbackId,
    _i7mfdxkk.FeedbackStatus status,
  ) => caller.callServerEndpoint<_intnc2la.Feedback>(
    'project',
    'updateFeedbackStatus',
    {
      'projectId': projectId,
      'feedbackId': feedbackId,
      'status': status,
    },
  );

  /// The replay of the last seconds before feedback [feedbackId], or null.
  _ida.Future<_iq3jz10h.FeedbackReplayInfo?> getFeedbackReplay(
    int projectId,
    int feedbackId,
  ) => caller.callServerEndpoint<_iq3jz10h.FeedbackReplayInfo?>(
    'project',
    'getFeedbackReplay',
    {
      'projectId': projectId,
      'feedbackId': feedbackId,
    },
  );

  /// Chunk [index] of that replay. Like screenshots, the only way it leaves
  /// the server.
  _ida.Future<_iee74lve.ReplayChunk> getFeedbackReplayChunk(
    int projectId,
    int feedbackId,
    int index,
  ) => caller.callServerEndpoint<_iee74lve.ReplayChunk>(
    'project',
    'getFeedbackReplayChunk',
    {
      'projectId': projectId,
      'feedbackId': feedbackId,
      'index': index,
    },
  );

  /// Deletes the trait [key] of the app user [userId] and returns the user
  /// as stored afterwards. Traits come from the app (`identify`), and without
  /// identity verification from anyone with the public key, so a team must
  /// be able to remove a single wrong or junk one without deleting the user.
  /// Cleanup, so it works on a suspended project too. A key the user does
  /// not have changes nothing; a later `identify` may send it again.
  _ida.Future<_i9cgg3r7.AppUser> deleteUserTrait(
    int projectId,
    int userId,
    String key,
  ) => caller.callServerEndpoint<_i9cgg3r7.AppUser>(
    'project',
    'deleteUserTrait',
    {
      'projectId': projectId,
      'userId': userId,
      'key': key,
    },
  );

  /// Deletes the replay of feedback [feedbackId], keeping the message.
  /// Cleanup, so it works on a suspended project too.
  _ida.Future<void> deleteFeedbackReplay(
    int projectId,
    int feedbackId,
  ) => caller.callServerEndpoint<void>(
    'project',
    'deleteFeedbackReplay',
    {
      'projectId': projectId,
      'feedbackId': feedbackId,
    },
  );

  /// Deletes the message and, by cascade, its screenshots and replay. The
  /// feedback_submitted event stays; it carries no text. Works on a suspended
  /// project too.
  _ida.Future<void> deleteFeedback(
    int projectId,
    int feedbackId,
  ) => caller.callServerEndpoint<void>(
    'project',
    'deleteFeedback',
    {
      'projectId': projectId,
      'feedbackId': feedbackId,
    },
  );

  /// The ideas of the project with their vote counts, most votes first. By
  /// default everything that is on the board; with [archived] the archive
  /// instead, newest change first and at most
  /// [maxArchivedFeatureRequestsListed], merged duplicates included.
  _ida.Future<List<_i9ewlb1w.FeatureRequest>> listFeatureRequests(
    int projectId, {
    bool? archived,
  }) => caller.callServerEndpoint<List<_i9ewlb1w.FeatureRequest>>(
    'project',
    'listFeatureRequests',
    {
      'projectId': projectId,
      'archived': archived,
    },
  );

  /// Puts a new idea on the board, where the devices of the project see it
  /// and vote on it.
  _ida.Future<_i9ewlb1w.FeatureRequest> createFeatureRequest(
    int projectId,
    String title,
    String description,
  ) => caller.callServerEndpoint<_i9ewlb1w.FeatureRequest>(
    'project',
    'createFeatureRequest',
    {
      'projectId': projectId,
      'title': title,
      'description': description,
    },
  );

  /// Like [createFeatureRequest], and remembers the feedback message of this
  /// project the idea came from. The message itself stays as it is.
  _ida.Future<_i9ewlb1w.FeatureRequest> createFeatureRequestFromFeedback(
    int projectId,
    int feedbackId,
    String title,
    String description,
  ) => caller.callServerEndpoint<_i9ewlb1w.FeatureRequest>(
    'project',
    'createFeatureRequestFromFeedback',
    {
      'projectId': projectId,
      'feedbackId': feedbackId,
      'title': title,
      'description': description,
    },
  );

  /// Changes the text the devices see, so it needs an active project. A
  /// merged duplicate is off the board for good and cannot be edited.
  _ida.Future<_i9ewlb1w.FeatureRequest> updateFeatureRequest(
    int projectId,
    int featureRequestId,
    String title,
    String description,
  ) => caller.callServerEndpoint<_i9ewlb1w.FeatureRequest>(
    'project',
    'updateFeatureRequest',
    {
      'projectId': projectId,
      'featureRequestId': featureRequestId,
      'title': title,
      'description': description,
    },
  );

  /// Moves an idea to another column of the board, which the devices see, so
  /// it needs an active project. Bringing one back from the archive puts one
  /// more idea on the board and is checked against the quota. The status
  /// archived goes the way of [archiveFeatureRequest].
  _ida.Future<_i9ewlb1w.FeatureRequest> setFeatureRequestStatus(
    int projectId,
    int featureRequestId,
    _iy0ugmyc.FeatureRequestStatus status,
  ) => caller.callServerEndpoint<_i9ewlb1w.FeatureRequest>(
    'project',
    'setFeatureRequestStatus',
    {
      'projectId': projectId,
      'featureRequestId': featureRequestId,
      'status': status,
    },
  );

  /// Takes an idea off the board. Its votes stay, and so does its place when
  /// it comes back. Works on a suspended project too: archiving is cleanup.
  _ida.Future<_i9ewlb1w.FeatureRequest> archiveFeatureRequest(
    int projectId,
    int featureRequestId,
  ) => caller.callServerEndpoint<_i9ewlb1w.FeatureRequest>(
    'project',
    'archiveFeatureRequest',
    {
      'projectId': projectId,
      'featureRequestId': featureRequestId,
    },
  );

  /// Merges the duplicate [duplicateId] into [intoId] and returns the latter
  /// with its new vote count. Both have to be ideas of this project. Works on
  /// a suspended project too: nothing new appears, the board gets tidier.
  _ida.Future<_i9ewlb1w.FeatureRequest> mergeFeatureRequests(
    int projectId,
    int duplicateId,
    int intoId,
  ) => caller.callServerEndpoint<_i9ewlb1w.FeatureRequest>(
    'project',
    'mergeFeatureRequests',
    {
      'projectId': projectId,
      'duplicateId': duplicateId,
      'intoId': intoId,
    },
  );

  /// The owner first, then the members. Bounded by [maxMembersPerProject].
  _ida.Future<List<_iiynwmmr.ProjectMemberInfo>> listMembers(int projectId) =>
      caller.callServerEndpoint<List<_iiynwmmr.ProjectMemberInfo>>(
        'project',
        'listMembers',
        {'projectId': projectId},
      );

  /// Open invitations, oldest first. Bounded by [maxMembersPerProject].
  _ida.Future<List<_i729nurv.ProjectInvitationInfo>> listInvitations(
    int projectId,
  ) => caller.callServerEndpoint<List<_i729nurv.ProjectInvitationInfo>>(
    'project',
    'listInvitations',
    {'projectId': projectId},
  );

  /// Invites [email] and sends the mail with the link. The invitee needs no
  /// account yet. Owner, suspension, quota, then the mail budget.
  _ida.Future<_i729nurv.ProjectInvitationInfo> inviteMember(
    int projectId,
    String email,
  ) => caller.callServerEndpoint<_i729nurv.ProjectInvitationInfo>(
    'project',
    'inviteMember',
    {
      'projectId': projectId,
      'email': email,
    },
  );

  /// Cleanup, so it works on a suspended project too.
  _ida.Future<void> revokeInvitation(
    int projectId,
    int invitationId,
  ) => caller.callServerEndpoint<void>(
    'project',
    'revokeInvitation',
    {
      'projectId': projectId,
      'invitationId': invitationId,
    },
  );

  /// Cleanup, so it works on a suspended project too. Revokes the agent
  /// tokens the member created for the project, see [removeMemberOf].
  _ida.Future<void> removeMember(
    int projectId,
    _isc.UuidValue userId,
  ) => caller.callServerEndpoint<void>(
    'project',
    'removeMember',
    {
      'projectId': projectId,
      'userId': userId,
    },
  );

  /// A member leaves the project, and their agent tokens of the project are
  /// revoked with it. The owner cannot leave; the project would be without
  /// one.
  _ida.Future<void> leaveProject(int projectId) =>
      caller.callServerEndpoint<void>(
        'project',
        'leaveProject',
        {'projectId': projectId},
      );

  /// Accepts the invitation behind [token], the fragment of the link in the
  /// mail, for the signed-in account. It takes no project id: the token
  /// names the project, and the account must have the invited address.
  _ida.Future<_ixeiu5z6.Project> acceptInvitation(String token) =>
      caller.callServerEndpoint<_ixeiu5z6.Project>(
        'project',
        'acceptInvitation',
        {'token': token},
      );
}

/// Endpoint for the Flutter SDK. Authenticated with a public key, which
/// resolves to exactly one project. Every query below filters by it.
///
/// The install id names an install and is public. What belongs to one install
/// alone (its conversations, its push target) opens only with the secret
/// install credential, see `install_credential.dart`.
/// {@category Endpoint}
class EndpointSdk extends _isc.EndpointRef {
  EndpointSdk(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'sdk';

  /// Creates the device on first start or refreshes it on later starts.
  /// Every field is bounded, see `device_input.dart`; one over a limit
  /// refuses the call before anything is read or written.
  ///
  /// A refresh needs the install [credential] once the install has one:
  /// whoever knows only the public install id must not change platform,
  /// versions or locale and with them the segments of the device. Without a
  /// matching credential the call writes nothing and still answers, so an
  /// SDK from before this parameter keeps starting; it just no longer
  /// refreshes the row. An install that never claimed a credential is
  /// refreshed as before.
  ///
  /// The answer carries only what the caller sent and the timestamps of
  /// this call ([registeredDeviceOf]), never the stored row: no attribution,
  /// no install referrer, no user.
  _ida.Future<_illpjbsr.Device> registerDevice(
    _ii8htaq5.DeviceRegistration registration, {
    String? credential,
  }) => caller.callServerEndpoint<_illpjbsr.Device>(
    'sdk',
    'registerDevice',
    {
      'registration': registration,
      'credential': credential,
    },
  );

  /// Hands out the secret credential of the install [installId], once. The SDK
  /// calls it right after the first [registerDevice] and keeps the answer in
  /// the secure storage of the platform; the server keeps a hash.
  ///
  /// An install from before the credential existed claims it on its first
  /// contact the same way. An install that already has or had a credential is
  /// refused with [LotseInstallCredentialException], so the install id alone
  /// never yields one.
  _ida.Future<String> claimInstallCredential(String installId) =>
      caller.callServerEndpoint<String>(
        'sdk',
        'claimInstallCredential',
        {'installId': installId},
      );

  /// Ends the identity of the install [installId], for a logout or an account
  /// switch in the host app: [credential] stops working for good, no new one
  /// is handed out, and the push tokens of the device are deleted. The SDK
  /// goes on under a new install id. The conversations stay for the team.
  _ida.Future<void> revokeInstallCredential(
    String installId,
    String credential,
  ) => caller.callServerEndpoint<void>(
    'sdk',
    'revokeInstallCredential',
    {
      'installId': installId,
      'credential': credential,
    },
  );

  /// Resolves a slug of this project to its app route and campaign.
  _ida.Future<_i5zi1oud.ResolvedLink> resolveLink(String slug) =>
      caller.callServerEndpoint<_i5zi1oud.ResolvedLink>(
        'sdk',
        'resolveLink',
        {'slug': slug},
      );

  /// The link this install came from, matched on the first call by install
  /// referrer or fingerprint. Later calls return the stored match and write
  /// nothing; for a referrer no click backed, the link its referrer names.
  /// Null when the install is not attributed.
  _ida.Future<_i5zi1oud.ResolvedLink?> resolveDeferredLink(
    String installId, {
    String? credential,
  }) => caller.callServerEndpoint<_i5zi1oud.ResolvedLink?>(
    'sdk',
    'resolveDeferredLink',
    {
      'installId': installId,
      'credential': credential,
    },
  );

  /// Stores the provider push token of the device identified by [installId].
  /// Needs the install [credential]: whoever sets the token decides where the
  /// pushes of this install go. The token must look like one of [provider],
  /// see `push_token_input.dart`.
  ///
  /// Reporting a token again clears an earlier [PushToken.invalidAt], because
  /// the device is obviously reachable through it now.
  _ida.Future<void> registerPushToken(
    String installId,
    String credential,
    String token,
    _ih2izyow.PushProvider provider,
  ) => caller.callServerEndpoint<void>(
    'sdk',
    'registerPushToken',
    {
      'installId': installId,
      'credential': credential,
      'token': token,
      'provider': provider,
    },
  );

  /// Appends events for the device identified by [installId]. Number and size
  /// of the events are bounded, see `track_input.dart`; one event over a limit
  /// refuses the whole call. Events outside the time window are dropped, and
  /// so is an event whose `clientId` the device has stored already: the SDK
  /// sends a batch again when the answer did not reach it. Only what is
  /// stored counts against the budgets.
  _ida.Future<void> track(
    String installId,
    List<_inlxo86g.TrackedEvent> events, {
    String? credential,
  }) => caller.callServerEndpoint<void>(
    'sdk',
    'track',
    {
      'installId': installId,
      'events': events,
      'credential': credential,
    },
  );

  /// Stores heatmap taps of the device identified by [installId]. Malformed
  /// taps refuse the call, taps older than a day or from the future are
  /// dropped, see `tap_input.dart`. Every rage burst also writes one
  /// `rage_tap` event, which costs the event budgets.
  ///
  /// Returns the heatmap backgrounds the device should capture: screens and
  /// width classes of these taps the project has no background for on the
  /// device's platform and app version, see [submitHeatmapBackground].
  _ida.Future<List<_iv0jmya8.HeatmapBackgroundSlot>> submitTaps(
    String installId,
    List<_izr1kezp.TrackedTap> taps, {
    String? credential,
  }) => caller.callServerEndpoint<List<_iv0jmya8.HeatmapBackgroundSlot>>(
    'sdk',
    'submitTaps',
    {
      'installId': installId,
      'taps': taps,
      'credential': credential,
    },
  );

  /// Stores [image] as the heatmap background of [screen] for the platform,
  /// app version and width class of the device [installId]. [width] and
  /// [height] are the logical size of the `LotseScope` boundary, [scrollY]
  /// the offset of the scroll view in the middle of it (0 outside of one).
  ///
  /// The first image of a slot wins; later ones are dropped without an
  /// error, and so is an image for a slot the device was never asked for: it
  /// must have sent taps on [screen] in this width class with its current
  /// platform and app version recently (`heatmapBackgroundWasAsked`).
  /// Checked like a feedback screenshot: PNG or JPEG, at most 1 MB and 1280
  /// pixels per edge. Costs the background budgets of project, device and
  /// client address and counts into the background quota of the project.
  _ida.Future<void> submitHeatmapBackground(
    String installId,
    String screen,
    int scrollY,
    int width,
    int height,
    _idt.ByteData image, {
    String? credential,
  }) => caller.callServerEndpoint<void>(
    'sdk',
    'submitHeatmapBackground',
    {
      'installId': installId,
      'screen': screen,
      'scrollY': scrollY,
      'width': width,
      'height': height,
      'image': image,
      'credential': credential,
    },
  );

  /// Ties the device [installId] to the app user [externalId] of this project
  /// and merges [traits] over the ones stored for that user. Creates the user
  /// on first sight, refreshes it afterwards, and writes [identifyEventName]
  /// to the event stream.
  ///
  /// Without an identity secret of the project the id is what the app says,
  /// not something Lotse verified. With one, [userHash] is the HMAC-SHA256
  /// of the trimmed id under the secret, computed by the customer's backend,
  /// and the rules of `identity_verification.dart` apply before anything is
  /// written: a wrong hash is always refused, a missing one while the
  /// project requires verification. Both with the same
  /// [LotseInvalidInputException]. Older SDKs send no hash.
  ///
  /// Either way the user row is a trait for analytics and segments. It opens
  /// nothing that belongs to another install. The install credential is
  /// required so that a client with only the public install id cannot
  /// relabel a device.
  ///
  /// Only a new user costs the user budgets; every accepted call costs one
  /// event and the bytes of its traits, a call the verification refuses
  /// costs nothing. Limits of the id
  /// and the traits are in `identify_input.dart`. Neither the id, a trait nor
  /// the hash ends up in a log or an error message.
  _ida.Future<void> identify(
    String installId,
    String credential,
    String externalId, {
    Map<String, String>? traits,
    String? userHash,
  }) => caller.callServerEndpoint<void>(
    'sdk',
    'identify',
    {
      'installId': installId,
      'credential': credential,
      'externalId': externalId,
      'traits': traits,
      'userHash': userHash,
    },
  );

  /// Stores a feedback message of the device identified by [installId],
  /// together with its [screenshot] when there is one, and writes
  /// [feedbackEventName] to the event stream. Returns the id of the message.
  ///
  /// The screenshot travels in the same call so that message and image are
  /// stored in one transaction and no orphaned upload can stay behind.
  ///
  /// A message of the category question opens a support chat. It is refused
  /// with [LotseSupportChatDisabledException] while the project has the chat
  /// switched off.
  ///
  /// Keys of a suspended project never get this far, see `authenticateApiKey`.
  _ida.Future<int> submitFeedback(
    String installId,
    _ift03pyz.FeedbackSubmission submission, {
    _idt.ByteData? screenshot,
    String? credential,
  }) => caller.callServerEndpoint<int>(
    'sdk',
    'submitFeedback',
    {
      'installId': installId,
      'submission': submission,
      'screenshot': screenshot,
      'credential': credential,
    },
  );

  /// Stores one chunk of the replay of the last seconds before the feedback
  /// message [feedbackId], which the device [installId] sent at most
  /// [replayUploadWindow] ago. The first chunk starts the replay and costs
  /// the replay budget and quota; sending a chunk again replaces it. Every
  /// PNG is checked against the frame, see `replay_input.dart`.
  _ida.Future<void> submitFeedbackReplayChunk(
    String installId,
    int feedbackId,
    _iee74lve.ReplayChunk chunk, {
    String? credential,
  }) => caller.callServerEndpoint<void>(
    'sdk',
    'submitFeedbackReplayChunk',
    {
      'installId': installId,
      'feedbackId': feedbackId,
      'chunk': chunk,
      'credential': credential,
    },
  );

  /// The feedback messages the device identified by [installId] sent, the
  /// conversation that moved last first. At most [maxMyFeedbackListed].
  _ida.Future<List<_i7qvzrlb.MyFeedback>> listMyFeedback(
    String installId,
    String credential,
  ) => caller.callServerEndpoint<List<_i7qvzrlb.MyFeedback>>(
    'sdk',
    'listMyFeedback',
    {
      'installId': installId,
      'credential': credential,
    },
  );

  /// One feedback message of the device with its conversation, oldest first.
  /// Feedback of another device is not found, also inside the same project.
  _ida.Future<_ixkb7t32.MyFeedbackThread> getMyFeedback(
    String installId,
    String credential,
    int feedbackId,
  ) => caller.callServerEndpoint<_ixkb7t32.MyFeedbackThread>(
    'sdk',
    'getMyFeedback',
    {
      'installId': installId,
      'credential': credential,
      'feedbackId': feedbackId,
    },
  );

  /// Appends a reply of the user to one of the device's own conversations and
  /// returns its id. The team sees it as unread.
  _ida.Future<int> replyToFeedback(
    String installId,
    String credential,
    int feedbackId,
    String body,
  ) => caller.callServerEndpoint<int>(
    'sdk',
    'replyToFeedback',
    {
      'installId': installId,
      'credential': credential,
      'feedbackId': feedbackId,
      'body': body,
    },
  );

  /// Marks the team's replies in one of the device's own conversations as
  /// read.
  _ida.Future<void> markFeedbackRead(
    String installId,
    String credential,
    int feedbackId,
  ) => caller.callServerEndpoint<void>(
    'sdk',
    'markFeedbackRead',
    {
      'installId': installId,
      'credential': credential,
      'feedbackId': feedbackId,
    },
  );

  /// Live updates of one of the device's own conversations, over a
  /// Serverpod streaming method (WebSocket). Each element says that the
  /// conversation changed; the SDK loads it with [getMyFeedback]. The first
  /// one arrives as soon as the stream listens.
  ///
  /// Authenticated like every call here: the public key in the open command
  /// of the stream resolves the project, the install [credential] the
  /// device. Feedback of another device or project is not found, here and on
  /// every later signal: before each one the device, its credential and the
  /// message are checked again, and a failed check ends the stream with its
  /// exception. The server ends the stream after
  /// [conversationStreamLifetime]; the SDK opens a new one. At most
  /// [maxConversationStreamsPerDevice] per device and
  /// [maxConversationStreamsPerProject] per project are open at a time.
  _ida.Stream<_iwaox72k.FeedbackConversationChange> watchMyFeedback(
    String installId,
    String credential,
    int feedbackId,
  ) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_iwaox72k.FeedbackConversationChange>,
        _iwaox72k.FeedbackConversationChange
      >(
        'sdk',
        'watchMyFeedback',
        {
          'installId': installId,
          'credential': credential,
          'feedbackId': feedbackId,
        },
        {},
      );

  /// Whether the project accepts new support chats, and the running one of
  /// the device identified by [installId]. A conversation that was started
  /// while the chat was on stays reachable after it is switched off.
  _ida.Future<_igjgpeew.SupportChat> getSupportChat(
    String installId,
    String credential,
  ) => caller.callServerEndpoint<_igjgpeew.SupportChat>(
    'sdk',
    'getSupportChat',
    {
      'installId': installId,
      'credential': credential,
    },
  );

  /// The feature board as the device identified by [installId] sees it: the
  /// ideas of this project that are neither archived nor merged, most votes
  /// first, optionally only those in [status], each with whether this device
  /// voted for it.
  _ida.Future<List<_iktk6feb.FeatureBoardItem>> listFeatureRequests(
    String installId, {
    _iy0ugmyc.FeatureRequestStatus? status,
    String? credential,
  }) => caller.callServerEndpoint<List<_iktk6feb.FeatureBoardItem>>(
    'sdk',
    'listFeatureRequests',
    {
      'installId': installId,
      'status': status,
      'credential': credential,
    },
  );

  /// Votes for an idea and writes [featureVotedEventName] with the id of the
  /// idea to the event stream, which makes "voted for X" a segment. Voting
  /// twice changes nothing. An idea of another project, an archived and a
  /// merged one are not found, and nothing is written.
  _ida.Future<_iktk6feb.FeatureBoardItem> voteFeature(
    String installId,
    int featureRequestId, {
    String? credential,
  }) => caller.callServerEndpoint<_iktk6feb.FeatureBoardItem>(
    'sdk',
    'voteFeature',
    {
      'installId': installId,
      'featureRequestId': featureRequestId,
      'credential': credential,
    },
  );

  /// Takes the vote of the device back and writes [featureUnvotedEventName].
  /// Without a vote it changes nothing.
  _ida.Future<_iktk6feb.FeatureBoardItem> unvoteFeature(
    String installId,
    int featureRequestId, {
    String? credential,
  }) => caller.callServerEndpoint<_iktk6feb.FeatureBoardItem>(
    'sdk',
    'unvoteFeature',
    {
      'installId': installId,
      'featureRequestId': featureRequestId,
      'credential': credential,
    },
  );

  /// The in-app messages the device identified by [installId] is to show:
  /// the active messages of this project whose segment matches the device
  /// right now and that it has neither tapped nor dismissed, newest first,
  /// at most [maxInAppMessagesPerFetch].
  ///
  /// Needs the install [credential]: the answer tells which segments the
  /// device is in, for example "reported a bug". Costs the fetch budgets of
  /// device and project only while the project has an active message.
  _ida.Future<List<_izpbyx5h.SdkInAppMessage>> inAppMessages(
    String installId,
    String credential,
  ) => caller.callServerEndpoint<List<_izpbyx5h.SdkInAppMessage>>(
    'sdk',
    'inAppMessages',
    {
      'installId': installId,
      'credential': credential,
    },
  );

  /// The survey the device identified by [installId] is to show, or null:
  /// the oldest active survey of this project whose segment matches the
  /// device right now and that it has neither answered nor dismissed. After
  /// an answer or a dismissal the device gets none for [surveyRest].
  ///
  /// Needs the install [credential] for the same reason as [inAppMessages].
  /// Costs the fetch budgets of device and project only while the project has
  /// an active survey.
  _ida.Future<_i5ze76md.SdkSurvey?> pendingSurvey(
    String installId,
    String credential,
  ) => caller.callServerEndpoint<_i5ze76md.SdkSurvey?>(
    'sdk',
    'pendingSurvey',
    {
      'installId': installId,
      'credential': credential,
    },
  );

  /// Answers the survey [surveyId] once: [score] (0 to 10) for an NPS
  /// survey, optionally with [comment] where it asks for one, [choice] (the
  /// index of the answer) for a choice survey. Writes [surveyAnsweredEvent]
  /// without the comment. A survey of another project, one that is not
  /// active and one whose segment no longer matches the device are not found;
  /// a second answer is a [LotseConflictException].
  ///
  /// Needs the install [credential]: whether a survey is found tells whether
  /// the device is in its segment.
  _ida.Future<void> answerSurvey(
    String installId,
    String credential,
    int surveyId, {
    int? score,
    int? choice,
    String? comment,
  }) => caller.callServerEndpoint<void>(
    'sdk',
    'answerSurvey',
    {
      'installId': installId,
      'credential': credential,
      'surveyId': surveyId,
      'score': score,
      'choice': choice,
      'comment': comment,
    },
  );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _iaic.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
  }

  late final _iaic.Caller serverpod_auth_idp;

  late final _iacc.Caller serverpod_auth_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    analytics = EndpointAnalytics(this);
    project = EndpointProject(this);
    sdk = EndpointSdk(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointAnalytics analytics;

  late final EndpointProject project;

  late final EndpointSdk sdk;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'analytics': analytics,
    'project': project,
    'sdk': sdk,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
