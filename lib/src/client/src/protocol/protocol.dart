/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:lotse/src/client/src/protocol/agent_token.dart' as _izywjc6s;
import 'package:lotse/src/client/src/protocol/api_key.dart' as _imzvo1nf;
import 'package:lotse/src/client/src/protocol/app_user_list_item.dart' as _itcuuu2x;
import 'package:lotse/src/client/src/protocol/campaign.dart' as _isnrua4r;
import 'package:lotse/src/client/src/protocol/device.dart' as _illpjbsr;
import 'package:lotse/src/client/src/protocol/event.dart' as _i7mn5lps;
import 'package:lotse/src/client/src/protocol/feature_board_item.dart' as _iktk6feb;
import 'package:lotse/src/client/src/protocol/feature_request.dart' as _i9ewlb1w;
import 'package:lotse/src/client/src/protocol/funnel_step.dart' as _i1oe7xkk;
import 'package:lotse/src/client/src/protocol/heatmap_background_slot.dart'
    as _iv0jmya8;
import 'package:lotse/src/client/src/protocol/heatmap_screen.dart' as _ixzdz37m;
import 'package:lotse/src/client/src/protocol/in_app_message_list_item.dart'
    as _it4jt2kp;
import 'package:lotse/src/client/src/protocol/journey_detail.dart' as _ipj5sx6m;
import 'package:lotse/src/client/src/protocol/link.dart' as _imhn7g80;
import 'package:lotse/src/client/src/protocol/link_click.dart' as _i95j1fet;
import 'package:lotse/src/client/src/protocol/lotse_app.dart' as _iwe5i9u8;
import 'package:lotse/src/client/src/protocol/my_feedback.dart' as _i7qvzrlb;
import 'package:lotse/src/client/src/protocol/project.dart' as _ixeiu5z6;
import 'package:lotse/src/client/src/protocol/project_invitation_info.dart'
    as _i729nurv;
import 'package:lotse/src/client/src/protocol/project_member_info.dart'
    as _iiynwmmr;
import 'package:lotse/src/client/src/protocol/sdk_in_app_message.dart' as _izpbyx5h;
import 'package:lotse/src/client/src/protocol/segment.dart' as _i0v8239j;
import 'package:lotse/src/client/src/protocol/survey.dart' as _i9wfizaq;
import 'package:lotse/src/client/src/protocol/tracked_event.dart' as _inlxo86g;
import 'package:lotse/src/client/src/protocol/tracked_tap.dart' as _izr1kezp;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'acquisition_report.dart' as _i4gvoeo1;
import 'acquisition_row.dart' as _i03ibdtb;
import 'agent_token.dart' as _icvv29rr;
import 'agent_token_created.dart' as _iv2da2o5;
import 'agent_token_level.dart' as _iv7slllc;
import 'analytics_count.dart' as _i1ktyzpb;
import 'analytics_overview.dart' as _i7rjvjqt;
import 'api_key.dart' as _i72lo5ui;
import 'api_key_created.dart' as _ib1akd69;
import 'apns_environment.dart' as _iy23tayo;
import 'app_user.dart' as _i2j2xfrn;
import 'app_user_list_item.dart' as _i8lj71qd;
import 'attribution_source.dart' as _i879b165;
import 'campaign.dart' as _iv6aasei;
import 'campaign_report.dart' as _ic3i7r9m;
import 'campaign_status.dart' as _iys7xjaz;
import 'csv_export.dart' as _isbyl930;
import 'csv_export_kind.dart' as _ihuvp8cb;
import 'csv_export_request.dart' as _ihzhdhyt;
import 'csv_feedback_filter.dart' as _iog5sq87;
import 'delivery.dart' as _ia87vg9p;
import 'delivery_status.dart' as _ib7m4h6q;
import 'delivery_summary.dart' as _izenipf5;
import 'device.dart' as _ilo09f9g;
import 'device_platform.dart' as _ij3iar7l;
import 'device_registration.dart' as _ihub5uuq;
import 'event.dart' as _iu57571s;
import 'explorer_query.dart' as _is6a98og;
import 'explorer_report.dart' as _i8rjtzwa;
import 'explorer_series.dart' as _ia8ec5jy;
import 'explorer_series_kind.dart' as _i39vvocg;
import 'explorer_split.dart' as _i6em6g0k;
import 'feature_board_item.dart' as _iwsbvz85;
import 'feature_request.dart' as _i0n3whlw;
import 'feature_request_status.dart' as _ios6zwvp;
import 'feedback.dart' as _iut2va9k;
import 'feedback_category.dart' as _iju423hp;
import 'feedback_conversation_change.dart' as _i8aok9sf;
import 'feedback_detail.dart' as _isd3h8f0;
import 'feedback_list_item.dart' as _i7gab86f;
import 'feedback_message.dart' as _i6m0uyvp;
import 'feedback_message_author.dart' as _imklq58l;
import 'feedback_page.dart' as _i37glqj7;
import 'feedback_push_status.dart' as _ipimo89r;
import 'feedback_replay_info.dart' as _iz3c8pxx;
import 'feedback_screenshot_info.dart' as _igoqmjz7;
import 'feedback_status.dart' as _ipjm5lus;
import 'feedback_submission.dart' as _i1txpxy2;
import 'funnel_report.dart' as _ivok65vy;
import 'funnel_row.dart' as _i4ciuq8e;
import 'funnel_split.dart' as _i3dwtlfw;
import 'funnel_step.dart' as _ilifyhbs;
import 'heatmap_background_info.dart' as _immlrb5m;
import 'heatmap_background_slot.dart' as _i2frcp28;
import 'heatmap_cell.dart' as _i2wopt0u;
import 'heatmap_report.dart' as _irpymhu8;
import 'heatmap_screen.dart' as _ix0h1r59;
import 'heatmap_width_class.dart' as _ibbfwb4e;
import 'identity_secret_created.dart' as _icu4k8w6;
import 'identity_verification_status.dart' as _il6qcl22;
import 'in_app_message.dart' as _icz8bdg4;
import 'in_app_message_list_item.dart' as _ikekgdeo;
import 'in_app_message_report.dart' as _io2eohxg;
import 'in_app_message_status.dart' as _ihkv7mfu;
import 'in_app_message_style.dart' as _iv76hups;
import 'journey.dart' as _iuh01ynj;
import 'journey_arm.dart' as _i34jp9wz;
import 'journey_detail.dart' as _iu4edyms;
import 'journey_exit.dart' as _ilvr900l;
import 'journey_group.dart' as _ihadhz3u;
import 'journey_input.dart' as _idsjwygn;
import 'journey_report.dart' as _i5ktdfyb;
import 'journey_status.dart' as _i6knwx07;
import 'journey_trigger.dart' as _ia9frtih;
import 'journey_variant_input.dart' as _it0j7yj1;
import 'link.dart' as _iz3quwrh;
import 'link_click.dart' as _im1bvi19;
import 'lotse_app.dart' as _ihsimdup;
import 'lotse_conflict_exception.dart' as _ivzfk8pq;
import 'lotse_install_credential_exception.dart' as _ie33z5i4;
import 'lotse_invalid_input_exception.dart' as _itzrvmn4;
import 'lotse_mail_not_sent_exception.dart' as _iuvvcdjp;
import 'lotse_not_found_exception.dart' as _izw809ga;
import 'lotse_owner_only_exception.dart' as _ictkkbnn;
import 'lotse_project_suspended_exception.dart' as _ilq5ecfk;
import 'lotse_quota_exceeded_exception.dart' as _imf72r4y;
import 'lotse_support_chat_disabled_exception.dart' as _ilnpyi2m;
import 'my_feedback.dart' as _ivxqciuj;
import 'my_feedback_message.dart' as _ikrc0jjp;
import 'my_feedback_thread.dart' as _i4254r4x;
import 'platform_count.dart' as _iclib0po;
import 'project.dart' as _ifiazq2p;
import 'project_invitation_info.dart' as _ieaem7s0;
import 'project_member_info.dart' as _igjd66vg;
import 'push_credential.dart' as _iqnrtiz4;
import 'push_provider.dart' as _i0unzms6;
import 'push_token.dart' as _i6cqc8ei;
import 'replay_chunk.dart' as _iqfu18id;
import 'replay_frame.dart' as _i5dutshk;
import 'replay_mark.dart' as _i4x1uj01;
import 'replay_mark_kind.dart' as _igbo9v0t;
import 'resolved_link.dart' as _iteij1k5;
import 'retention_cohort.dart' as _i20mhv3w;
import 'retention_report.dart' as _iplqqvn8;
import 'retention_row.dart' as _iva6i66v;
import 'retention_split.dart' as _iuyop9cb;
import 'sdk_in_app_message.dart' as _ivl2z976;
import 'sdk_survey.dart' as _im4znf6v;
import 'segment.dart' as _iavhy62p;
import 'setup_check.dart' as _ie45uxmr;
import 'setup_check_status.dart' as _i10jnq79;
import 'setup_diagnosis.dart' as _ij7ppc9u;
import 'setup_traffic.dart' as _i3mfntce;
import 'support_chat.dart' as _ia25305t;
import 'survey.dart' as _if7lizhn;
import 'survey_group.dart' as _illgmjmc;
import 'survey_kind.dart' as _i7m36ch5;
import 'survey_report.dart' as _io9fb8qj;
import 'survey_response_item.dart' as _ibd3jznw;
import 'survey_response_page.dart' as _inhml88y;
import 'survey_status.dart' as _iw9o61c2;
import 'timeline.dart' as _i1ky4p4f;
import 'timeline_item.dart' as _ignyleo4;
import 'timeline_item_kind.dart' as _i9cf7i61;
import 'tracked_event.dart' as _ipwekx4s;
import 'tracked_tap.dart' as _ig0dwpc6;
export 'acquisition_report.dart';
export 'acquisition_row.dart';
export 'agent_token.dart';
export 'agent_token_created.dart';
export 'agent_token_level.dart';
export 'analytics_count.dart';
export 'analytics_overview.dart';
export 'api_key.dart';
export 'api_key_created.dart';
export 'apns_environment.dart';
export 'app_user.dart';
export 'app_user_list_item.dart';
export 'attribution_source.dart';
export 'campaign.dart';
export 'campaign_report.dart';
export 'campaign_status.dart';
export 'csv_export.dart';
export 'csv_export_kind.dart';
export 'csv_export_request.dart';
export 'csv_feedback_filter.dart';
export 'delivery.dart';
export 'delivery_status.dart';
export 'delivery_summary.dart';
export 'device.dart';
export 'device_platform.dart';
export 'device_registration.dart';
export 'event.dart';
export 'explorer_query.dart';
export 'explorer_report.dart';
export 'explorer_series.dart';
export 'explorer_series_kind.dart';
export 'explorer_split.dart';
export 'feature_board_item.dart';
export 'feature_request.dart';
export 'feature_request_status.dart';
export 'feedback.dart';
export 'feedback_category.dart';
export 'feedback_conversation_change.dart';
export 'feedback_detail.dart';
export 'feedback_list_item.dart';
export 'feedback_message.dart';
export 'feedback_message_author.dart';
export 'feedback_page.dart';
export 'feedback_push_status.dart';
export 'feedback_replay_info.dart';
export 'feedback_screenshot_info.dart';
export 'feedback_status.dart';
export 'feedback_submission.dart';
export 'funnel_report.dart';
export 'funnel_row.dart';
export 'funnel_split.dart';
export 'funnel_step.dart';
export 'heatmap_background_info.dart';
export 'heatmap_background_slot.dart';
export 'heatmap_cell.dart';
export 'heatmap_report.dart';
export 'heatmap_screen.dart';
export 'heatmap_width_class.dart';
export 'identity_secret_created.dart';
export 'identity_verification_status.dart';
export 'in_app_message.dart';
export 'in_app_message_list_item.dart';
export 'in_app_message_report.dart';
export 'in_app_message_status.dart';
export 'in_app_message_style.dart';
export 'journey.dart';
export 'journey_arm.dart';
export 'journey_detail.dart';
export 'journey_exit.dart';
export 'journey_group.dart';
export 'journey_input.dart';
export 'journey_report.dart';
export 'journey_status.dart';
export 'journey_trigger.dart';
export 'journey_variant_input.dart';
export 'link.dart';
export 'link_click.dart';
export 'lotse_app.dart';
export 'lotse_conflict_exception.dart';
export 'lotse_install_credential_exception.dart';
export 'lotse_invalid_input_exception.dart';
export 'lotse_mail_not_sent_exception.dart';
export 'lotse_not_found_exception.dart';
export 'lotse_owner_only_exception.dart';
export 'lotse_project_suspended_exception.dart';
export 'lotse_quota_exceeded_exception.dart';
export 'lotse_support_chat_disabled_exception.dart';
export 'my_feedback.dart';
export 'my_feedback_message.dart';
export 'my_feedback_thread.dart';
export 'platform_count.dart';
export 'project.dart';
export 'project_invitation_info.dart';
export 'project_member_info.dart';
export 'push_credential.dart';
export 'push_provider.dart';
export 'push_token.dart';
export 'replay_chunk.dart';
export 'replay_frame.dart';
export 'replay_mark.dart';
export 'replay_mark_kind.dart';
export 'resolved_link.dart';
export 'retention_cohort.dart';
export 'retention_report.dart';
export 'retention_row.dart';
export 'retention_split.dart';
export 'sdk_in_app_message.dart';
export 'sdk_survey.dart';
export 'segment.dart';
export 'setup_check.dart';
export 'setup_check_status.dart';
export 'setup_diagnosis.dart';
export 'setup_traffic.dart';
export 'support_chat.dart';
export 'survey.dart';
export 'survey_group.dart';
export 'survey_kind.dart';
export 'survey_report.dart';
export 'survey_response_item.dart';
export 'survey_response_page.dart';
export 'survey_status.dart';
export 'timeline.dart';
export 'timeline_item.dart';
export 'timeline_item_kind.dart';
export 'tracked_event.dart';
export 'tracked_tap.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i4gvoeo1.AcquisitionReport) {
      return _i4gvoeo1.AcquisitionReport.fromJson(data) as T;
    }
    if (t == _i03ibdtb.AcquisitionRow) {
      return _i03ibdtb.AcquisitionRow.fromJson(data) as T;
    }
    if (t == _icvv29rr.AgentToken) {
      return _icvv29rr.AgentToken.fromJson(data) as T;
    }
    if (t == _iv2da2o5.AgentTokenCreated) {
      return _iv2da2o5.AgentTokenCreated.fromJson(data) as T;
    }
    if (t == _iv7slllc.AgentTokenLevel) {
      return _iv7slllc.AgentTokenLevel.fromJson(data) as T;
    }
    if (t == _i1ktyzpb.AnalyticsCount) {
      return _i1ktyzpb.AnalyticsCount.fromJson(data) as T;
    }
    if (t == _i7rjvjqt.AnalyticsOverview) {
      return _i7rjvjqt.AnalyticsOverview.fromJson(data) as T;
    }
    if (t == _i72lo5ui.ApiKey) {
      return _i72lo5ui.ApiKey.fromJson(data) as T;
    }
    if (t == _ib1akd69.ApiKeyCreated) {
      return _ib1akd69.ApiKeyCreated.fromJson(data) as T;
    }
    if (t == _iy23tayo.ApnsEnvironment) {
      return _iy23tayo.ApnsEnvironment.fromJson(data) as T;
    }
    if (t == _i2j2xfrn.AppUser) {
      return _i2j2xfrn.AppUser.fromJson(data) as T;
    }
    if (t == _i8lj71qd.AppUserListItem) {
      return _i8lj71qd.AppUserListItem.fromJson(data) as T;
    }
    if (t == _i879b165.AttributionSource) {
      return _i879b165.AttributionSource.fromJson(data) as T;
    }
    if (t == _iv6aasei.Campaign) {
      return _iv6aasei.Campaign.fromJson(data) as T;
    }
    if (t == _ic3i7r9m.CampaignReport) {
      return _ic3i7r9m.CampaignReport.fromJson(data) as T;
    }
    if (t == _iys7xjaz.CampaignStatus) {
      return _iys7xjaz.CampaignStatus.fromJson(data) as T;
    }
    if (t == _isbyl930.CsvExport) {
      return _isbyl930.CsvExport.fromJson(data) as T;
    }
    if (t == _ihuvp8cb.CsvExportKind) {
      return _ihuvp8cb.CsvExportKind.fromJson(data) as T;
    }
    if (t == _ihzhdhyt.CsvExportRequest) {
      return _ihzhdhyt.CsvExportRequest.fromJson(data) as T;
    }
    if (t == _iog5sq87.CsvFeedbackFilter) {
      return _iog5sq87.CsvFeedbackFilter.fromJson(data) as T;
    }
    if (t == _ia87vg9p.Delivery) {
      return _ia87vg9p.Delivery.fromJson(data) as T;
    }
    if (t == _ib7m4h6q.DeliveryStatus) {
      return _ib7m4h6q.DeliveryStatus.fromJson(data) as T;
    }
    if (t == _izenipf5.DeliverySummary) {
      return _izenipf5.DeliverySummary.fromJson(data) as T;
    }
    if (t == _ilo09f9g.Device) {
      return _ilo09f9g.Device.fromJson(data) as T;
    }
    if (t == _ij3iar7l.DevicePlatform) {
      return _ij3iar7l.DevicePlatform.fromJson(data) as T;
    }
    if (t == _ihub5uuq.DeviceRegistration) {
      return _ihub5uuq.DeviceRegistration.fromJson(data) as T;
    }
    if (t == _iu57571s.Event) {
      return _iu57571s.Event.fromJson(data) as T;
    }
    if (t == _is6a98og.ExplorerQuery) {
      return _is6a98og.ExplorerQuery.fromJson(data) as T;
    }
    if (t == _i8rjtzwa.ExplorerReport) {
      return _i8rjtzwa.ExplorerReport.fromJson(data) as T;
    }
    if (t == _ia8ec5jy.ExplorerSeries) {
      return _ia8ec5jy.ExplorerSeries.fromJson(data) as T;
    }
    if (t == _i39vvocg.ExplorerSeriesKind) {
      return _i39vvocg.ExplorerSeriesKind.fromJson(data) as T;
    }
    if (t == _i6em6g0k.ExplorerSplit) {
      return _i6em6g0k.ExplorerSplit.fromJson(data) as T;
    }
    if (t == _iwsbvz85.FeatureBoardItem) {
      return _iwsbvz85.FeatureBoardItem.fromJson(data) as T;
    }
    if (t == _i0n3whlw.FeatureRequest) {
      return _i0n3whlw.FeatureRequest.fromJson(data) as T;
    }
    if (t == _ios6zwvp.FeatureRequestStatus) {
      return _ios6zwvp.FeatureRequestStatus.fromJson(data) as T;
    }
    if (t == _iut2va9k.Feedback) {
      return _iut2va9k.Feedback.fromJson(data) as T;
    }
    if (t == _iju423hp.FeedbackCategory) {
      return _iju423hp.FeedbackCategory.fromJson(data) as T;
    }
    if (t == _i8aok9sf.FeedbackConversationChange) {
      return _i8aok9sf.FeedbackConversationChange.fromJson(data) as T;
    }
    if (t == _isd3h8f0.FeedbackDetail) {
      return _isd3h8f0.FeedbackDetail.fromJson(data) as T;
    }
    if (t == _i7gab86f.FeedbackListItem) {
      return _i7gab86f.FeedbackListItem.fromJson(data) as T;
    }
    if (t == _i6m0uyvp.FeedbackMessage) {
      return _i6m0uyvp.FeedbackMessage.fromJson(data) as T;
    }
    if (t == _imklq58l.FeedbackMessageAuthor) {
      return _imklq58l.FeedbackMessageAuthor.fromJson(data) as T;
    }
    if (t == _i37glqj7.FeedbackPage) {
      return _i37glqj7.FeedbackPage.fromJson(data) as T;
    }
    if (t == _ipimo89r.FeedbackPushStatus) {
      return _ipimo89r.FeedbackPushStatus.fromJson(data) as T;
    }
    if (t == _iz3c8pxx.FeedbackReplayInfo) {
      return _iz3c8pxx.FeedbackReplayInfo.fromJson(data) as T;
    }
    if (t == _igoqmjz7.FeedbackScreenshotInfo) {
      return _igoqmjz7.FeedbackScreenshotInfo.fromJson(data) as T;
    }
    if (t == _ipjm5lus.FeedbackStatus) {
      return _ipjm5lus.FeedbackStatus.fromJson(data) as T;
    }
    if (t == _i1txpxy2.FeedbackSubmission) {
      return _i1txpxy2.FeedbackSubmission.fromJson(data) as T;
    }
    if (t == _ivok65vy.FunnelReport) {
      return _ivok65vy.FunnelReport.fromJson(data) as T;
    }
    if (t == _i4ciuq8e.FunnelRow) {
      return _i4ciuq8e.FunnelRow.fromJson(data) as T;
    }
    if (t == _i3dwtlfw.FunnelSplit) {
      return _i3dwtlfw.FunnelSplit.fromJson(data) as T;
    }
    if (t == _ilifyhbs.FunnelStep) {
      return _ilifyhbs.FunnelStep.fromJson(data) as T;
    }
    if (t == _immlrb5m.HeatmapBackgroundInfo) {
      return _immlrb5m.HeatmapBackgroundInfo.fromJson(data) as T;
    }
    if (t == _i2frcp28.HeatmapBackgroundSlot) {
      return _i2frcp28.HeatmapBackgroundSlot.fromJson(data) as T;
    }
    if (t == _i2wopt0u.HeatmapCell) {
      return _i2wopt0u.HeatmapCell.fromJson(data) as T;
    }
    if (t == _irpymhu8.HeatmapReport) {
      return _irpymhu8.HeatmapReport.fromJson(data) as T;
    }
    if (t == _ix0h1r59.HeatmapScreen) {
      return _ix0h1r59.HeatmapScreen.fromJson(data) as T;
    }
    if (t == _ibbfwb4e.HeatmapWidthClass) {
      return _ibbfwb4e.HeatmapWidthClass.fromJson(data) as T;
    }
    if (t == _icu4k8w6.IdentitySecretCreated) {
      return _icu4k8w6.IdentitySecretCreated.fromJson(data) as T;
    }
    if (t == _il6qcl22.IdentityVerificationStatus) {
      return _il6qcl22.IdentityVerificationStatus.fromJson(data) as T;
    }
    if (t == _icz8bdg4.InAppMessage) {
      return _icz8bdg4.InAppMessage.fromJson(data) as T;
    }
    if (t == _ikekgdeo.InAppMessageListItem) {
      return _ikekgdeo.InAppMessageListItem.fromJson(data) as T;
    }
    if (t == _io2eohxg.InAppMessageReport) {
      return _io2eohxg.InAppMessageReport.fromJson(data) as T;
    }
    if (t == _ihkv7mfu.InAppMessageStatus) {
      return _ihkv7mfu.InAppMessageStatus.fromJson(data) as T;
    }
    if (t == _iv76hups.InAppMessageStyle) {
      return _iv76hups.InAppMessageStyle.fromJson(data) as T;
    }
    if (t == _iuh01ynj.Journey) {
      return _iuh01ynj.Journey.fromJson(data) as T;
    }
    if (t == _i34jp9wz.JourneyArm) {
      return _i34jp9wz.JourneyArm.fromJson(data) as T;
    }
    if (t == _iu4edyms.JourneyDetail) {
      return _iu4edyms.JourneyDetail.fromJson(data) as T;
    }
    if (t == _ilvr900l.JourneyExit) {
      return _ilvr900l.JourneyExit.fromJson(data) as T;
    }
    if (t == _ihadhz3u.JourneyGroup) {
      return _ihadhz3u.JourneyGroup.fromJson(data) as T;
    }
    if (t == _idsjwygn.JourneyInput) {
      return _idsjwygn.JourneyInput.fromJson(data) as T;
    }
    if (t == _i5ktdfyb.JourneyReport) {
      return _i5ktdfyb.JourneyReport.fromJson(data) as T;
    }
    if (t == _i6knwx07.JourneyStatus) {
      return _i6knwx07.JourneyStatus.fromJson(data) as T;
    }
    if (t == _ia9frtih.JourneyTrigger) {
      return _ia9frtih.JourneyTrigger.fromJson(data) as T;
    }
    if (t == _it0j7yj1.JourneyVariantInput) {
      return _it0j7yj1.JourneyVariantInput.fromJson(data) as T;
    }
    if (t == _iz3quwrh.Link) {
      return _iz3quwrh.Link.fromJson(data) as T;
    }
    if (t == _im1bvi19.LinkClick) {
      return _im1bvi19.LinkClick.fromJson(data) as T;
    }
    if (t == _ihsimdup.LotseApp) {
      return _ihsimdup.LotseApp.fromJson(data) as T;
    }
    if (t == _ivzfk8pq.LotseConflictException) {
      return _ivzfk8pq.LotseConflictException.fromJson(data) as T;
    }
    if (t == _ie33z5i4.LotseInstallCredentialException) {
      return _ie33z5i4.LotseInstallCredentialException.fromJson(data) as T;
    }
    if (t == _itzrvmn4.LotseInvalidInputException) {
      return _itzrvmn4.LotseInvalidInputException.fromJson(data) as T;
    }
    if (t == _iuvvcdjp.LotseMailNotSentException) {
      return _iuvvcdjp.LotseMailNotSentException.fromJson(data) as T;
    }
    if (t == _izw809ga.LotseNotFoundException) {
      return _izw809ga.LotseNotFoundException.fromJson(data) as T;
    }
    if (t == _ictkkbnn.LotseOwnerOnlyException) {
      return _ictkkbnn.LotseOwnerOnlyException.fromJson(data) as T;
    }
    if (t == _ilq5ecfk.LotseProjectSuspendedException) {
      return _ilq5ecfk.LotseProjectSuspendedException.fromJson(data) as T;
    }
    if (t == _imf72r4y.LotseQuotaExceededException) {
      return _imf72r4y.LotseQuotaExceededException.fromJson(data) as T;
    }
    if (t == _ilnpyi2m.LotseSupportChatDisabledException) {
      return _ilnpyi2m.LotseSupportChatDisabledException.fromJson(data) as T;
    }
    if (t == _ivxqciuj.MyFeedback) {
      return _ivxqciuj.MyFeedback.fromJson(data) as T;
    }
    if (t == _ikrc0jjp.MyFeedbackMessage) {
      return _ikrc0jjp.MyFeedbackMessage.fromJson(data) as T;
    }
    if (t == _i4254r4x.MyFeedbackThread) {
      return _i4254r4x.MyFeedbackThread.fromJson(data) as T;
    }
    if (t == _iclib0po.PlatformCount) {
      return _iclib0po.PlatformCount.fromJson(data) as T;
    }
    if (t == _ifiazq2p.Project) {
      return _ifiazq2p.Project.fromJson(data) as T;
    }
    if (t == _ieaem7s0.ProjectInvitationInfo) {
      return _ieaem7s0.ProjectInvitationInfo.fromJson(data) as T;
    }
    if (t == _igjd66vg.ProjectMemberInfo) {
      return _igjd66vg.ProjectMemberInfo.fromJson(data) as T;
    }
    if (t == _iqnrtiz4.PushCredential) {
      return _iqnrtiz4.PushCredential.fromJson(data) as T;
    }
    if (t == _i0unzms6.PushProvider) {
      return _i0unzms6.PushProvider.fromJson(data) as T;
    }
    if (t == _i6cqc8ei.PushToken) {
      return _i6cqc8ei.PushToken.fromJson(data) as T;
    }
    if (t == _iqfu18id.ReplayChunk) {
      return _iqfu18id.ReplayChunk.fromJson(data) as T;
    }
    if (t == _i5dutshk.ReplayFrame) {
      return _i5dutshk.ReplayFrame.fromJson(data) as T;
    }
    if (t == _i4x1uj01.ReplayMark) {
      return _i4x1uj01.ReplayMark.fromJson(data) as T;
    }
    if (t == _igbo9v0t.ReplayMarkKind) {
      return _igbo9v0t.ReplayMarkKind.fromJson(data) as T;
    }
    if (t == _iteij1k5.ResolvedLink) {
      return _iteij1k5.ResolvedLink.fromJson(data) as T;
    }
    if (t == _i20mhv3w.RetentionCohort) {
      return _i20mhv3w.RetentionCohort.fromJson(data) as T;
    }
    if (t == _iplqqvn8.RetentionReport) {
      return _iplqqvn8.RetentionReport.fromJson(data) as T;
    }
    if (t == _iva6i66v.RetentionRow) {
      return _iva6i66v.RetentionRow.fromJson(data) as T;
    }
    if (t == _iuyop9cb.RetentionSplit) {
      return _iuyop9cb.RetentionSplit.fromJson(data) as T;
    }
    if (t == _ivl2z976.SdkInAppMessage) {
      return _ivl2z976.SdkInAppMessage.fromJson(data) as T;
    }
    if (t == _im4znf6v.SdkSurvey) {
      return _im4znf6v.SdkSurvey.fromJson(data) as T;
    }
    if (t == _iavhy62p.Segment) {
      return _iavhy62p.Segment.fromJson(data) as T;
    }
    if (t == _ie45uxmr.SetupCheck) {
      return _ie45uxmr.SetupCheck.fromJson(data) as T;
    }
    if (t == _i10jnq79.SetupCheckStatus) {
      return _i10jnq79.SetupCheckStatus.fromJson(data) as T;
    }
    if (t == _ij7ppc9u.SetupDiagnosis) {
      return _ij7ppc9u.SetupDiagnosis.fromJson(data) as T;
    }
    if (t == _i3mfntce.SetupTraffic) {
      return _i3mfntce.SetupTraffic.fromJson(data) as T;
    }
    if (t == _ia25305t.SupportChat) {
      return _ia25305t.SupportChat.fromJson(data) as T;
    }
    if (t == _if7lizhn.Survey) {
      return _if7lizhn.Survey.fromJson(data) as T;
    }
    if (t == _illgmjmc.SurveyGroup) {
      return _illgmjmc.SurveyGroup.fromJson(data) as T;
    }
    if (t == _i7m36ch5.SurveyKind) {
      return _i7m36ch5.SurveyKind.fromJson(data) as T;
    }
    if (t == _io9fb8qj.SurveyReport) {
      return _io9fb8qj.SurveyReport.fromJson(data) as T;
    }
    if (t == _ibd3jznw.SurveyResponseItem) {
      return _ibd3jznw.SurveyResponseItem.fromJson(data) as T;
    }
    if (t == _inhml88y.SurveyResponsePage) {
      return _inhml88y.SurveyResponsePage.fromJson(data) as T;
    }
    if (t == _iw9o61c2.SurveyStatus) {
      return _iw9o61c2.SurveyStatus.fromJson(data) as T;
    }
    if (t == _i1ky4p4f.Timeline) {
      return _i1ky4p4f.Timeline.fromJson(data) as T;
    }
    if (t == _ignyleo4.TimelineItem) {
      return _ignyleo4.TimelineItem.fromJson(data) as T;
    }
    if (t == _i9cf7i61.TimelineItemKind) {
      return _i9cf7i61.TimelineItemKind.fromJson(data) as T;
    }
    if (t == _ipwekx4s.TrackedEvent) {
      return _ipwekx4s.TrackedEvent.fromJson(data) as T;
    }
    if (t == _ig0dwpc6.TrackedTap) {
      return _ig0dwpc6.TrackedTap.fromJson(data) as T;
    }
    if (t == _isc.getType<_i4gvoeo1.AcquisitionReport?>()) {
      return (data != null ? _i4gvoeo1.AcquisitionReport.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i03ibdtb.AcquisitionRow?>()) {
      return (data != null ? _i03ibdtb.AcquisitionRow.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_icvv29rr.AgentToken?>()) {
      return (data != null ? _icvv29rr.AgentToken.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iv2da2o5.AgentTokenCreated?>()) {
      return (data != null ? _iv2da2o5.AgentTokenCreated.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iv7slllc.AgentTokenLevel?>()) {
      return (data != null ? _iv7slllc.AgentTokenLevel.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i1ktyzpb.AnalyticsCount?>()) {
      return (data != null ? _i1ktyzpb.AnalyticsCount.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i7rjvjqt.AnalyticsOverview?>()) {
      return (data != null ? _i7rjvjqt.AnalyticsOverview.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i72lo5ui.ApiKey?>()) {
      return (data != null ? _i72lo5ui.ApiKey.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ib1akd69.ApiKeyCreated?>()) {
      return (data != null ? _ib1akd69.ApiKeyCreated.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iy23tayo.ApnsEnvironment?>()) {
      return (data != null ? _iy23tayo.ApnsEnvironment.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i2j2xfrn.AppUser?>()) {
      return (data != null ? _i2j2xfrn.AppUser.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i8lj71qd.AppUserListItem?>()) {
      return (data != null ? _i8lj71qd.AppUserListItem.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i879b165.AttributionSource?>()) {
      return (data != null ? _i879b165.AttributionSource.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iv6aasei.Campaign?>()) {
      return (data != null ? _iv6aasei.Campaign.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ic3i7r9m.CampaignReport?>()) {
      return (data != null ? _ic3i7r9m.CampaignReport.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iys7xjaz.CampaignStatus?>()) {
      return (data != null ? _iys7xjaz.CampaignStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_isbyl930.CsvExport?>()) {
      return (data != null ? _isbyl930.CsvExport.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ihuvp8cb.CsvExportKind?>()) {
      return (data != null ? _ihuvp8cb.CsvExportKind.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ihzhdhyt.CsvExportRequest?>()) {
      return (data != null ? _ihzhdhyt.CsvExportRequest.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iog5sq87.CsvFeedbackFilter?>()) {
      return (data != null ? _iog5sq87.CsvFeedbackFilter.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ia87vg9p.Delivery?>()) {
      return (data != null ? _ia87vg9p.Delivery.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ib7m4h6q.DeliveryStatus?>()) {
      return (data != null ? _ib7m4h6q.DeliveryStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_izenipf5.DeliverySummary?>()) {
      return (data != null ? _izenipf5.DeliverySummary.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ilo09f9g.Device?>()) {
      return (data != null ? _ilo09f9g.Device.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ij3iar7l.DevicePlatform?>()) {
      return (data != null ? _ij3iar7l.DevicePlatform.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ihub5uuq.DeviceRegistration?>()) {
      return (data != null ? _ihub5uuq.DeviceRegistration.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iu57571s.Event?>()) {
      return (data != null ? _iu57571s.Event.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_is6a98og.ExplorerQuery?>()) {
      return (data != null ? _is6a98og.ExplorerQuery.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i8rjtzwa.ExplorerReport?>()) {
      return (data != null ? _i8rjtzwa.ExplorerReport.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ia8ec5jy.ExplorerSeries?>()) {
      return (data != null ? _ia8ec5jy.ExplorerSeries.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i39vvocg.ExplorerSeriesKind?>()) {
      return (data != null ? _i39vvocg.ExplorerSeriesKind.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i6em6g0k.ExplorerSplit?>()) {
      return (data != null ? _i6em6g0k.ExplorerSplit.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iwsbvz85.FeatureBoardItem?>()) {
      return (data != null ? _iwsbvz85.FeatureBoardItem.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i0n3whlw.FeatureRequest?>()) {
      return (data != null ? _i0n3whlw.FeatureRequest.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ios6zwvp.FeatureRequestStatus?>()) {
      return (data != null
              ? _ios6zwvp.FeatureRequestStatus.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iut2va9k.Feedback?>()) {
      return (data != null ? _iut2va9k.Feedback.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iju423hp.FeedbackCategory?>()) {
      return (data != null ? _iju423hp.FeedbackCategory.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i8aok9sf.FeedbackConversationChange?>()) {
      return (data != null
              ? _i8aok9sf.FeedbackConversationChange.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_isd3h8f0.FeedbackDetail?>()) {
      return (data != null ? _isd3h8f0.FeedbackDetail.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i7gab86f.FeedbackListItem?>()) {
      return (data != null ? _i7gab86f.FeedbackListItem.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i6m0uyvp.FeedbackMessage?>()) {
      return (data != null ? _i6m0uyvp.FeedbackMessage.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_imklq58l.FeedbackMessageAuthor?>()) {
      return (data != null
              ? _imklq58l.FeedbackMessageAuthor.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i37glqj7.FeedbackPage?>()) {
      return (data != null ? _i37glqj7.FeedbackPage.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ipimo89r.FeedbackPushStatus?>()) {
      return (data != null ? _ipimo89r.FeedbackPushStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iz3c8pxx.FeedbackReplayInfo?>()) {
      return (data != null ? _iz3c8pxx.FeedbackReplayInfo.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_igoqmjz7.FeedbackScreenshotInfo?>()) {
      return (data != null
              ? _igoqmjz7.FeedbackScreenshotInfo.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ipjm5lus.FeedbackStatus?>()) {
      return (data != null ? _ipjm5lus.FeedbackStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i1txpxy2.FeedbackSubmission?>()) {
      return (data != null ? _i1txpxy2.FeedbackSubmission.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ivok65vy.FunnelReport?>()) {
      return (data != null ? _ivok65vy.FunnelReport.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i4ciuq8e.FunnelRow?>()) {
      return (data != null ? _i4ciuq8e.FunnelRow.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i3dwtlfw.FunnelSplit?>()) {
      return (data != null ? _i3dwtlfw.FunnelSplit.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ilifyhbs.FunnelStep?>()) {
      return (data != null ? _ilifyhbs.FunnelStep.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_immlrb5m.HeatmapBackgroundInfo?>()) {
      return (data != null
              ? _immlrb5m.HeatmapBackgroundInfo.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i2frcp28.HeatmapBackgroundSlot?>()) {
      return (data != null
              ? _i2frcp28.HeatmapBackgroundSlot.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i2wopt0u.HeatmapCell?>()) {
      return (data != null ? _i2wopt0u.HeatmapCell.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_irpymhu8.HeatmapReport?>()) {
      return (data != null ? _irpymhu8.HeatmapReport.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ix0h1r59.HeatmapScreen?>()) {
      return (data != null ? _ix0h1r59.HeatmapScreen.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ibbfwb4e.HeatmapWidthClass?>()) {
      return (data != null ? _ibbfwb4e.HeatmapWidthClass.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_icu4k8w6.IdentitySecretCreated?>()) {
      return (data != null
              ? _icu4k8w6.IdentitySecretCreated.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_il6qcl22.IdentityVerificationStatus?>()) {
      return (data != null
              ? _il6qcl22.IdentityVerificationStatus.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_icz8bdg4.InAppMessage?>()) {
      return (data != null ? _icz8bdg4.InAppMessage.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ikekgdeo.InAppMessageListItem?>()) {
      return (data != null
              ? _ikekgdeo.InAppMessageListItem.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_io2eohxg.InAppMessageReport?>()) {
      return (data != null ? _io2eohxg.InAppMessageReport.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ihkv7mfu.InAppMessageStatus?>()) {
      return (data != null ? _ihkv7mfu.InAppMessageStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iv76hups.InAppMessageStyle?>()) {
      return (data != null ? _iv76hups.InAppMessageStyle.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iuh01ynj.Journey?>()) {
      return (data != null ? _iuh01ynj.Journey.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i34jp9wz.JourneyArm?>()) {
      return (data != null ? _i34jp9wz.JourneyArm.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iu4edyms.JourneyDetail?>()) {
      return (data != null ? _iu4edyms.JourneyDetail.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ilvr900l.JourneyExit?>()) {
      return (data != null ? _ilvr900l.JourneyExit.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ihadhz3u.JourneyGroup?>()) {
      return (data != null ? _ihadhz3u.JourneyGroup.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_idsjwygn.JourneyInput?>()) {
      return (data != null ? _idsjwygn.JourneyInput.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i5ktdfyb.JourneyReport?>()) {
      return (data != null ? _i5ktdfyb.JourneyReport.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i6knwx07.JourneyStatus?>()) {
      return (data != null ? _i6knwx07.JourneyStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ia9frtih.JourneyTrigger?>()) {
      return (data != null ? _ia9frtih.JourneyTrigger.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_it0j7yj1.JourneyVariantInput?>()) {
      return (data != null
              ? _it0j7yj1.JourneyVariantInput.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iz3quwrh.Link?>()) {
      return (data != null ? _iz3quwrh.Link.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_im1bvi19.LinkClick?>()) {
      return (data != null ? _im1bvi19.LinkClick.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ihsimdup.LotseApp?>()) {
      return (data != null ? _ihsimdup.LotseApp.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ivzfk8pq.LotseConflictException?>()) {
      return (data != null
              ? _ivzfk8pq.LotseConflictException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ie33z5i4.LotseInstallCredentialException?>()) {
      return (data != null
              ? _ie33z5i4.LotseInstallCredentialException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_itzrvmn4.LotseInvalidInputException?>()) {
      return (data != null
              ? _itzrvmn4.LotseInvalidInputException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iuvvcdjp.LotseMailNotSentException?>()) {
      return (data != null
              ? _iuvvcdjp.LotseMailNotSentException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_izw809ga.LotseNotFoundException?>()) {
      return (data != null
              ? _izw809ga.LotseNotFoundException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ictkkbnn.LotseOwnerOnlyException?>()) {
      return (data != null
              ? _ictkkbnn.LotseOwnerOnlyException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ilq5ecfk.LotseProjectSuspendedException?>()) {
      return (data != null
              ? _ilq5ecfk.LotseProjectSuspendedException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_imf72r4y.LotseQuotaExceededException?>()) {
      return (data != null
              ? _imf72r4y.LotseQuotaExceededException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ilnpyi2m.LotseSupportChatDisabledException?>()) {
      return (data != null
              ? _ilnpyi2m.LotseSupportChatDisabledException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ivxqciuj.MyFeedback?>()) {
      return (data != null ? _ivxqciuj.MyFeedback.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ikrc0jjp.MyFeedbackMessage?>()) {
      return (data != null ? _ikrc0jjp.MyFeedbackMessage.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i4254r4x.MyFeedbackThread?>()) {
      return (data != null ? _i4254r4x.MyFeedbackThread.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iclib0po.PlatformCount?>()) {
      return (data != null ? _iclib0po.PlatformCount.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ifiazq2p.Project?>()) {
      return (data != null ? _ifiazq2p.Project.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ieaem7s0.ProjectInvitationInfo?>()) {
      return (data != null
              ? _ieaem7s0.ProjectInvitationInfo.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_igjd66vg.ProjectMemberInfo?>()) {
      return (data != null ? _igjd66vg.ProjectMemberInfo.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iqnrtiz4.PushCredential?>()) {
      return (data != null ? _iqnrtiz4.PushCredential.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i0unzms6.PushProvider?>()) {
      return (data != null ? _i0unzms6.PushProvider.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i6cqc8ei.PushToken?>()) {
      return (data != null ? _i6cqc8ei.PushToken.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iqfu18id.ReplayChunk?>()) {
      return (data != null ? _iqfu18id.ReplayChunk.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i5dutshk.ReplayFrame?>()) {
      return (data != null ? _i5dutshk.ReplayFrame.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i4x1uj01.ReplayMark?>()) {
      return (data != null ? _i4x1uj01.ReplayMark.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_igbo9v0t.ReplayMarkKind?>()) {
      return (data != null ? _igbo9v0t.ReplayMarkKind.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iteij1k5.ResolvedLink?>()) {
      return (data != null ? _iteij1k5.ResolvedLink.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i20mhv3w.RetentionCohort?>()) {
      return (data != null ? _i20mhv3w.RetentionCohort.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iplqqvn8.RetentionReport?>()) {
      return (data != null ? _iplqqvn8.RetentionReport.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iva6i66v.RetentionRow?>()) {
      return (data != null ? _iva6i66v.RetentionRow.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iuyop9cb.RetentionSplit?>()) {
      return (data != null ? _iuyop9cb.RetentionSplit.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ivl2z976.SdkInAppMessage?>()) {
      return (data != null ? _ivl2z976.SdkInAppMessage.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_im4znf6v.SdkSurvey?>()) {
      return (data != null ? _im4znf6v.SdkSurvey.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iavhy62p.Segment?>()) {
      return (data != null ? _iavhy62p.Segment.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ie45uxmr.SetupCheck?>()) {
      return (data != null ? _ie45uxmr.SetupCheck.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i10jnq79.SetupCheckStatus?>()) {
      return (data != null ? _i10jnq79.SetupCheckStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ij7ppc9u.SetupDiagnosis?>()) {
      return (data != null ? _ij7ppc9u.SetupDiagnosis.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i3mfntce.SetupTraffic?>()) {
      return (data != null ? _i3mfntce.SetupTraffic.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ia25305t.SupportChat?>()) {
      return (data != null ? _ia25305t.SupportChat.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_if7lizhn.Survey?>()) {
      return (data != null ? _if7lizhn.Survey.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_illgmjmc.SurveyGroup?>()) {
      return (data != null ? _illgmjmc.SurveyGroup.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i7m36ch5.SurveyKind?>()) {
      return (data != null ? _i7m36ch5.SurveyKind.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_io9fb8qj.SurveyReport?>()) {
      return (data != null ? _io9fb8qj.SurveyReport.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ibd3jznw.SurveyResponseItem?>()) {
      return (data != null ? _ibd3jznw.SurveyResponseItem.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_inhml88y.SurveyResponsePage?>()) {
      return (data != null ? _inhml88y.SurveyResponsePage.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iw9o61c2.SurveyStatus?>()) {
      return (data != null ? _iw9o61c2.SurveyStatus.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i1ky4p4f.Timeline?>()) {
      return (data != null ? _i1ky4p4f.Timeline.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ignyleo4.TimelineItem?>()) {
      return (data != null ? _ignyleo4.TimelineItem.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i9cf7i61.TimelineItemKind?>()) {
      return (data != null ? _i9cf7i61.TimelineItemKind.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ipwekx4s.TrackedEvent?>()) {
      return (data != null ? _ipwekx4s.TrackedEvent.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ig0dwpc6.TrackedTap?>()) {
      return (data != null ? _ig0dwpc6.TrackedTap.fromJson(data) : null) as T;
    }
    if (t == List<_i03ibdtb.AcquisitionRow>) {
      return (data as List)
              .map((e) => deserialize<_i03ibdtb.AcquisitionRow>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i1ktyzpb.AnalyticsCount>) {
      return (data as List)
              .map((e) => deserialize<_i1ktyzpb.AnalyticsCount>(e))
              .toList()
          as T;
    }
    if (t == List<_iclib0po.PlatformCount>) {
      return (data as List)
              .map((e) => deserialize<_iclib0po.PlatformCount>(e))
              .toList()
          as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String>(v)),
          )
          as T;
    }
    if (t == _isc.getType<Map<String, String>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<String>(v)),
                )
              : null)
          as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<dynamic>(v)),
          )
          as T;
    }
    if (t == dynamic) {
      return deserializeDynamicFieldValue(data) as T;
    }
    if (t == _isc.getType<Map<String, dynamic>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<dynamic>(v)),
                )
              : null)
          as T;
    }
    if (t == List<_ilifyhbs.FunnelStep>) {
      return (data as List)
              .map((e) => deserialize<_ilifyhbs.FunnelStep>(e))
              .toList()
          as T;
    }
    if (t == _isc.getType<List<_ilifyhbs.FunnelStep>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_ilifyhbs.FunnelStep>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<DateTime>) {
      return (data as List).map((e) => deserialize<DateTime>(e)).toList() as T;
    }
    if (t == List<_ia8ec5jy.ExplorerSeries>) {
      return (data as List)
              .map((e) => deserialize<_ia8ec5jy.ExplorerSeries>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_iu57571s.Event>) {
      return (data as List).map((e) => deserialize<_iu57571s.Event>(e)).toList()
          as T;
    }
    if (t == List<_igoqmjz7.FeedbackScreenshotInfo>) {
      return (data as List)
              .map((e) => deserialize<_igoqmjz7.FeedbackScreenshotInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i6m0uyvp.FeedbackMessage>) {
      return (data as List)
              .map((e) => deserialize<_i6m0uyvp.FeedbackMessage>(e))
              .toList()
          as T;
    }
    if (t == List<_i7gab86f.FeedbackListItem>) {
      return (data as List)
              .map((e) => deserialize<_i7gab86f.FeedbackListItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i4ciuq8e.FunnelRow>) {
      return (data as List)
              .map((e) => deserialize<_i4ciuq8e.FunnelRow>(e))
              .toList()
          as T;
    }
    if (t == List<_i2wopt0u.HeatmapCell>) {
      return (data as List)
              .map((e) => deserialize<_i2wopt0u.HeatmapCell>(e))
              .toList()
          as T;
    }
    if (t == List<_iv6aasei.Campaign>) {
      return (data as List)
              .map((e) => deserialize<_iv6aasei.Campaign>(e))
              .toList()
          as T;
    }
    if (t == List<_it0j7yj1.JourneyVariantInput>) {
      return (data as List)
              .map((e) => deserialize<_it0j7yj1.JourneyVariantInput>(e))
              .toList()
          as T;
    }
    if (t == List<_ihadhz3u.JourneyGroup>) {
      return (data as List)
              .map((e) => deserialize<_ihadhz3u.JourneyGroup>(e))
              .toList()
          as T;
    }
    if (t == List<_ikrc0jjp.MyFeedbackMessage>) {
      return (data as List)
              .map((e) => deserialize<_ikrc0jjp.MyFeedbackMessage>(e))
              .toList()
          as T;
    }
    if (t == List<_i5dutshk.ReplayFrame>) {
      return (data as List)
              .map((e) => deserialize<_i5dutshk.ReplayFrame>(e))
              .toList()
          as T;
    }
    if (t == List<_i4x1uj01.ReplayMark>) {
      return (data as List)
              .map((e) => deserialize<_i4x1uj01.ReplayMark>(e))
              .toList()
          as T;
    }
    if (t == List<_iva6i66v.RetentionRow>) {
      return (data as List)
              .map((e) => deserialize<_iva6i66v.RetentionRow>(e))
              .toList()
          as T;
    }
    if (t == List<_i20mhv3w.RetentionCohort>) {
      return (data as List)
              .map((e) => deserialize<_i20mhv3w.RetentionCohort>(e))
              .toList()
          as T;
    }
    if (t == _isc.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_ie45uxmr.SetupCheck>) {
      return (data as List)
              .map((e) => deserialize<_ie45uxmr.SetupCheck>(e))
              .toList()
          as T;
    }
    if (t == _isc.getType<List<int>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_ibd3jznw.SurveyResponseItem>) {
      return (data as List)
              .map((e) => deserialize<_ibd3jznw.SurveyResponseItem>(e))
              .toList()
          as T;
    }
    if (t == List<_ilo09f9g.Device>) {
      return (data as List)
              .map((e) => deserialize<_ilo09f9g.Device>(e))
              .toList()
          as T;
    }
    if (t == List<_ignyleo4.TimelineItem>) {
      return (data as List)
              .map((e) => deserialize<_ignyleo4.TimelineItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i1oe7xkk.FunnelStep>) {
      return (data as List)
              .map((e) => deserialize<_i1oe7xkk.FunnelStep>(e))
              .toList()
          as T;
    }
    if (t == List<_ixzdz37m.HeatmapScreen>) {
      return (data as List)
              .map((e) => deserialize<_ixzdz37m.HeatmapScreen>(e))
              .toList()
          as T;
    }
    if (t == List<_itcuuu2x.AppUserListItem>) {
      return (data as List)
              .map((e) => deserialize<_itcuuu2x.AppUserListItem>(e))
              .toList()
          as T;
    }
    if (t == List<_ixeiu5z6.Project>) {
      return (data as List)
              .map((e) => deserialize<_ixeiu5z6.Project>(e))
              .toList()
          as T;
    }
    if (t == List<_iwe5i9u8.LotseApp>) {
      return (data as List)
              .map((e) => deserialize<_iwe5i9u8.LotseApp>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _isc.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_imzvo1nf.ApiKey>) {
      return (data as List)
              .map((e) => deserialize<_imzvo1nf.ApiKey>(e))
              .toList()
          as T;
    }
    if (t == List<_izywjc6s.AgentToken>) {
      return (data as List)
              .map((e) => deserialize<_izywjc6s.AgentToken>(e))
              .toList()
          as T;
    }
    if (t == List<_illpjbsr.Device>) {
      return (data as List)
              .map((e) => deserialize<_illpjbsr.Device>(e))
              .toList()
          as T;
    }
    if (t == List<_i7mn5lps.Event>) {
      return (data as List).map((e) => deserialize<_i7mn5lps.Event>(e)).toList()
          as T;
    }
    if (t == List<_imhn7g80.Link>) {
      return (data as List).map((e) => deserialize<_imhn7g80.Link>(e)).toList()
          as T;
    }
    if (t == List<_i95j1fet.LinkClick>) {
      return (data as List)
              .map((e) => deserialize<_i95j1fet.LinkClick>(e))
              .toList()
          as T;
    }
    if (t == List<_isnrua4r.Campaign>) {
      return (data as List)
              .map((e) => deserialize<_isnrua4r.Campaign>(e))
              .toList()
          as T;
    }
    if (t == List<_i0v8239j.Segment>) {
      return (data as List)
              .map((e) => deserialize<_i0v8239j.Segment>(e))
              .toList()
          as T;
    }
    if (t == List<_ipj5sx6m.JourneyDetail>) {
      return (data as List)
              .map((e) => deserialize<_ipj5sx6m.JourneyDetail>(e))
              .toList()
          as T;
    }
    if (t == List<_it4jt2kp.InAppMessageListItem>) {
      return (data as List)
              .map((e) => deserialize<_it4jt2kp.InAppMessageListItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i9wfizaq.Survey>) {
      return (data as List)
              .map((e) => deserialize<_i9wfizaq.Survey>(e))
              .toList()
          as T;
    }
    if (t == List<_i9ewlb1w.FeatureRequest>) {
      return (data as List)
              .map((e) => deserialize<_i9ewlb1w.FeatureRequest>(e))
              .toList()
          as T;
    }
    if (t == List<_iiynwmmr.ProjectMemberInfo>) {
      return (data as List)
              .map((e) => deserialize<_iiynwmmr.ProjectMemberInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i729nurv.ProjectInvitationInfo>) {
      return (data as List)
              .map((e) => deserialize<_i729nurv.ProjectInvitationInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_inlxo86g.TrackedEvent>) {
      return (data as List)
              .map((e) => deserialize<_inlxo86g.TrackedEvent>(e))
              .toList()
          as T;
    }
    if (t == List<_iv0jmya8.HeatmapBackgroundSlot>) {
      return (data as List)
              .map((e) => deserialize<_iv0jmya8.HeatmapBackgroundSlot>(e))
              .toList()
          as T;
    }
    if (t == List<_izr1kezp.TrackedTap>) {
      return (data as List)
              .map((e) => deserialize<_izr1kezp.TrackedTap>(e))
              .toList()
          as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String>(v)),
          )
          as T;
    }
    if (t == _isc.getType<Map<String, String>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<String>(v)),
                )
              : null)
          as T;
    }
    if (t == List<_i7qvzrlb.MyFeedback>) {
      return (data as List)
              .map((e) => deserialize<_i7qvzrlb.MyFeedback>(e))
              .toList()
          as T;
    }
    if (t == List<_iktk6feb.FeatureBoardItem>) {
      return (data as List)
              .map((e) => deserialize<_iktk6feb.FeatureBoardItem>(e))
              .toList()
          as T;
    }
    if (t == List<_izpbyx5h.SdkInAppMessage>) {
      return (data as List)
              .map((e) => deserialize<_izpbyx5h.SdkInAppMessage>(e))
              .toList()
          as T;
    }
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i4gvoeo1.AcquisitionReport => 'AcquisitionReport',
      _i03ibdtb.AcquisitionRow => 'AcquisitionRow',
      _icvv29rr.AgentToken => 'AgentToken',
      _iv2da2o5.AgentTokenCreated => 'AgentTokenCreated',
      _iv7slllc.AgentTokenLevel => 'AgentTokenLevel',
      _i1ktyzpb.AnalyticsCount => 'AnalyticsCount',
      _i7rjvjqt.AnalyticsOverview => 'AnalyticsOverview',
      _i72lo5ui.ApiKey => 'ApiKey',
      _ib1akd69.ApiKeyCreated => 'ApiKeyCreated',
      _iy23tayo.ApnsEnvironment => 'ApnsEnvironment',
      _i2j2xfrn.AppUser => 'AppUser',
      _i8lj71qd.AppUserListItem => 'AppUserListItem',
      _i879b165.AttributionSource => 'AttributionSource',
      _iv6aasei.Campaign => 'Campaign',
      _ic3i7r9m.CampaignReport => 'CampaignReport',
      _iys7xjaz.CampaignStatus => 'CampaignStatus',
      _isbyl930.CsvExport => 'CsvExport',
      _ihuvp8cb.CsvExportKind => 'CsvExportKind',
      _ihzhdhyt.CsvExportRequest => 'CsvExportRequest',
      _iog5sq87.CsvFeedbackFilter => 'CsvFeedbackFilter',
      _ia87vg9p.Delivery => 'Delivery',
      _ib7m4h6q.DeliveryStatus => 'DeliveryStatus',
      _izenipf5.DeliverySummary => 'DeliverySummary',
      _ilo09f9g.Device => 'Device',
      _ij3iar7l.DevicePlatform => 'DevicePlatform',
      _ihub5uuq.DeviceRegistration => 'DeviceRegistration',
      _iu57571s.Event => 'Event',
      _is6a98og.ExplorerQuery => 'ExplorerQuery',
      _i8rjtzwa.ExplorerReport => 'ExplorerReport',
      _ia8ec5jy.ExplorerSeries => 'ExplorerSeries',
      _i39vvocg.ExplorerSeriesKind => 'ExplorerSeriesKind',
      _i6em6g0k.ExplorerSplit => 'ExplorerSplit',
      _iwsbvz85.FeatureBoardItem => 'FeatureBoardItem',
      _i0n3whlw.FeatureRequest => 'FeatureRequest',
      _ios6zwvp.FeatureRequestStatus => 'FeatureRequestStatus',
      _iut2va9k.Feedback => 'Feedback',
      _iju423hp.FeedbackCategory => 'FeedbackCategory',
      _i8aok9sf.FeedbackConversationChange => 'FeedbackConversationChange',
      _isd3h8f0.FeedbackDetail => 'FeedbackDetail',
      _i7gab86f.FeedbackListItem => 'FeedbackListItem',
      _i6m0uyvp.FeedbackMessage => 'FeedbackMessage',
      _imklq58l.FeedbackMessageAuthor => 'FeedbackMessageAuthor',
      _i37glqj7.FeedbackPage => 'FeedbackPage',
      _ipimo89r.FeedbackPushStatus => 'FeedbackPushStatus',
      _iz3c8pxx.FeedbackReplayInfo => 'FeedbackReplayInfo',
      _igoqmjz7.FeedbackScreenshotInfo => 'FeedbackScreenshotInfo',
      _ipjm5lus.FeedbackStatus => 'FeedbackStatus',
      _i1txpxy2.FeedbackSubmission => 'FeedbackSubmission',
      _ivok65vy.FunnelReport => 'FunnelReport',
      _i4ciuq8e.FunnelRow => 'FunnelRow',
      _i3dwtlfw.FunnelSplit => 'FunnelSplit',
      _ilifyhbs.FunnelStep => 'FunnelStep',
      _immlrb5m.HeatmapBackgroundInfo => 'HeatmapBackgroundInfo',
      _i2frcp28.HeatmapBackgroundSlot => 'HeatmapBackgroundSlot',
      _i2wopt0u.HeatmapCell => 'HeatmapCell',
      _irpymhu8.HeatmapReport => 'HeatmapReport',
      _ix0h1r59.HeatmapScreen => 'HeatmapScreen',
      _ibbfwb4e.HeatmapWidthClass => 'HeatmapWidthClass',
      _icu4k8w6.IdentitySecretCreated => 'IdentitySecretCreated',
      _il6qcl22.IdentityVerificationStatus => 'IdentityVerificationStatus',
      _icz8bdg4.InAppMessage => 'InAppMessage',
      _ikekgdeo.InAppMessageListItem => 'InAppMessageListItem',
      _io2eohxg.InAppMessageReport => 'InAppMessageReport',
      _ihkv7mfu.InAppMessageStatus => 'InAppMessageStatus',
      _iv76hups.InAppMessageStyle => 'InAppMessageStyle',
      _iuh01ynj.Journey => 'Journey',
      _i34jp9wz.JourneyArm => 'JourneyArm',
      _iu4edyms.JourneyDetail => 'JourneyDetail',
      _ilvr900l.JourneyExit => 'JourneyExit',
      _ihadhz3u.JourneyGroup => 'JourneyGroup',
      _idsjwygn.JourneyInput => 'JourneyInput',
      _i5ktdfyb.JourneyReport => 'JourneyReport',
      _i6knwx07.JourneyStatus => 'JourneyStatus',
      _ia9frtih.JourneyTrigger => 'JourneyTrigger',
      _it0j7yj1.JourneyVariantInput => 'JourneyVariantInput',
      _iz3quwrh.Link => 'Link',
      _im1bvi19.LinkClick => 'LinkClick',
      _ihsimdup.LotseApp => 'LotseApp',
      _ivzfk8pq.LotseConflictException => 'LotseConflictException',
      _ie33z5i4.LotseInstallCredentialException =>
        'LotseInstallCredentialException',
      _itzrvmn4.LotseInvalidInputException => 'LotseInvalidInputException',
      _iuvvcdjp.LotseMailNotSentException => 'LotseMailNotSentException',
      _izw809ga.LotseNotFoundException => 'LotseNotFoundException',
      _ictkkbnn.LotseOwnerOnlyException => 'LotseOwnerOnlyException',
      _ilq5ecfk.LotseProjectSuspendedException =>
        'LotseProjectSuspendedException',
      _imf72r4y.LotseQuotaExceededException => 'LotseQuotaExceededException',
      _ilnpyi2m.LotseSupportChatDisabledException =>
        'LotseSupportChatDisabledException',
      _ivxqciuj.MyFeedback => 'MyFeedback',
      _ikrc0jjp.MyFeedbackMessage => 'MyFeedbackMessage',
      _i4254r4x.MyFeedbackThread => 'MyFeedbackThread',
      _iclib0po.PlatformCount => 'PlatformCount',
      _ifiazq2p.Project => 'Project',
      _ieaem7s0.ProjectInvitationInfo => 'ProjectInvitationInfo',
      _igjd66vg.ProjectMemberInfo => 'ProjectMemberInfo',
      _iqnrtiz4.PushCredential => 'PushCredential',
      _i0unzms6.PushProvider => 'PushProvider',
      _i6cqc8ei.PushToken => 'PushToken',
      _iqfu18id.ReplayChunk => 'ReplayChunk',
      _i5dutshk.ReplayFrame => 'ReplayFrame',
      _i4x1uj01.ReplayMark => 'ReplayMark',
      _igbo9v0t.ReplayMarkKind => 'ReplayMarkKind',
      _iteij1k5.ResolvedLink => 'ResolvedLink',
      _i20mhv3w.RetentionCohort => 'RetentionCohort',
      _iplqqvn8.RetentionReport => 'RetentionReport',
      _iva6i66v.RetentionRow => 'RetentionRow',
      _iuyop9cb.RetentionSplit => 'RetentionSplit',
      _ivl2z976.SdkInAppMessage => 'SdkInAppMessage',
      _im4znf6v.SdkSurvey => 'SdkSurvey',
      _iavhy62p.Segment => 'Segment',
      _ie45uxmr.SetupCheck => 'SetupCheck',
      _i10jnq79.SetupCheckStatus => 'SetupCheckStatus',
      _ij7ppc9u.SetupDiagnosis => 'SetupDiagnosis',
      _i3mfntce.SetupTraffic => 'SetupTraffic',
      _ia25305t.SupportChat => 'SupportChat',
      _if7lizhn.Survey => 'Survey',
      _illgmjmc.SurveyGroup => 'SurveyGroup',
      _i7m36ch5.SurveyKind => 'SurveyKind',
      _io9fb8qj.SurveyReport => 'SurveyReport',
      _ibd3jznw.SurveyResponseItem => 'SurveyResponseItem',
      _inhml88y.SurveyResponsePage => 'SurveyResponsePage',
      _iw9o61c2.SurveyStatus => 'SurveyStatus',
      _i1ky4p4f.Timeline => 'Timeline',
      _ignyleo4.TimelineItem => 'TimelineItem',
      _i9cf7i61.TimelineItemKind => 'TimelineItemKind',
      _ipwekx4s.TrackedEvent => 'TrackedEvent',
      _ig0dwpc6.TrackedTap => 'TrackedTap',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('lotse.', '');
    }

    switch (data) {
      case _i4gvoeo1.AcquisitionReport():
        return 'AcquisitionReport';
      case _i03ibdtb.AcquisitionRow():
        return 'AcquisitionRow';
      case _icvv29rr.AgentToken():
        return 'AgentToken';
      case _iv2da2o5.AgentTokenCreated():
        return 'AgentTokenCreated';
      case _iv7slllc.AgentTokenLevel():
        return 'AgentTokenLevel';
      case _i1ktyzpb.AnalyticsCount():
        return 'AnalyticsCount';
      case _i7rjvjqt.AnalyticsOverview():
        return 'AnalyticsOverview';
      case _i72lo5ui.ApiKey():
        return 'ApiKey';
      case _ib1akd69.ApiKeyCreated():
        return 'ApiKeyCreated';
      case _iy23tayo.ApnsEnvironment():
        return 'ApnsEnvironment';
      case _i2j2xfrn.AppUser():
        return 'AppUser';
      case _i8lj71qd.AppUserListItem():
        return 'AppUserListItem';
      case _i879b165.AttributionSource():
        return 'AttributionSource';
      case _iv6aasei.Campaign():
        return 'Campaign';
      case _ic3i7r9m.CampaignReport():
        return 'CampaignReport';
      case _iys7xjaz.CampaignStatus():
        return 'CampaignStatus';
      case _isbyl930.CsvExport():
        return 'CsvExport';
      case _ihuvp8cb.CsvExportKind():
        return 'CsvExportKind';
      case _ihzhdhyt.CsvExportRequest():
        return 'CsvExportRequest';
      case _iog5sq87.CsvFeedbackFilter():
        return 'CsvFeedbackFilter';
      case _ia87vg9p.Delivery():
        return 'Delivery';
      case _ib7m4h6q.DeliveryStatus():
        return 'DeliveryStatus';
      case _izenipf5.DeliverySummary():
        return 'DeliverySummary';
      case _ilo09f9g.Device():
        return 'Device';
      case _ij3iar7l.DevicePlatform():
        return 'DevicePlatform';
      case _ihub5uuq.DeviceRegistration():
        return 'DeviceRegistration';
      case _iu57571s.Event():
        return 'Event';
      case _is6a98og.ExplorerQuery():
        return 'ExplorerQuery';
      case _i8rjtzwa.ExplorerReport():
        return 'ExplorerReport';
      case _ia8ec5jy.ExplorerSeries():
        return 'ExplorerSeries';
      case _i39vvocg.ExplorerSeriesKind():
        return 'ExplorerSeriesKind';
      case _i6em6g0k.ExplorerSplit():
        return 'ExplorerSplit';
      case _iwsbvz85.FeatureBoardItem():
        return 'FeatureBoardItem';
      case _i0n3whlw.FeatureRequest():
        return 'FeatureRequest';
      case _ios6zwvp.FeatureRequestStatus():
        return 'FeatureRequestStatus';
      case _iut2va9k.Feedback():
        return 'Feedback';
      case _iju423hp.FeedbackCategory():
        return 'FeedbackCategory';
      case _i8aok9sf.FeedbackConversationChange():
        return 'FeedbackConversationChange';
      case _isd3h8f0.FeedbackDetail():
        return 'FeedbackDetail';
      case _i7gab86f.FeedbackListItem():
        return 'FeedbackListItem';
      case _i6m0uyvp.FeedbackMessage():
        return 'FeedbackMessage';
      case _imklq58l.FeedbackMessageAuthor():
        return 'FeedbackMessageAuthor';
      case _i37glqj7.FeedbackPage():
        return 'FeedbackPage';
      case _ipimo89r.FeedbackPushStatus():
        return 'FeedbackPushStatus';
      case _iz3c8pxx.FeedbackReplayInfo():
        return 'FeedbackReplayInfo';
      case _igoqmjz7.FeedbackScreenshotInfo():
        return 'FeedbackScreenshotInfo';
      case _ipjm5lus.FeedbackStatus():
        return 'FeedbackStatus';
      case _i1txpxy2.FeedbackSubmission():
        return 'FeedbackSubmission';
      case _ivok65vy.FunnelReport():
        return 'FunnelReport';
      case _i4ciuq8e.FunnelRow():
        return 'FunnelRow';
      case _i3dwtlfw.FunnelSplit():
        return 'FunnelSplit';
      case _ilifyhbs.FunnelStep():
        return 'FunnelStep';
      case _immlrb5m.HeatmapBackgroundInfo():
        return 'HeatmapBackgroundInfo';
      case _i2frcp28.HeatmapBackgroundSlot():
        return 'HeatmapBackgroundSlot';
      case _i2wopt0u.HeatmapCell():
        return 'HeatmapCell';
      case _irpymhu8.HeatmapReport():
        return 'HeatmapReport';
      case _ix0h1r59.HeatmapScreen():
        return 'HeatmapScreen';
      case _ibbfwb4e.HeatmapWidthClass():
        return 'HeatmapWidthClass';
      case _icu4k8w6.IdentitySecretCreated():
        return 'IdentitySecretCreated';
      case _il6qcl22.IdentityVerificationStatus():
        return 'IdentityVerificationStatus';
      case _icz8bdg4.InAppMessage():
        return 'InAppMessage';
      case _ikekgdeo.InAppMessageListItem():
        return 'InAppMessageListItem';
      case _io2eohxg.InAppMessageReport():
        return 'InAppMessageReport';
      case _ihkv7mfu.InAppMessageStatus():
        return 'InAppMessageStatus';
      case _iv76hups.InAppMessageStyle():
        return 'InAppMessageStyle';
      case _iuh01ynj.Journey():
        return 'Journey';
      case _i34jp9wz.JourneyArm():
        return 'JourneyArm';
      case _iu4edyms.JourneyDetail():
        return 'JourneyDetail';
      case _ilvr900l.JourneyExit():
        return 'JourneyExit';
      case _ihadhz3u.JourneyGroup():
        return 'JourneyGroup';
      case _idsjwygn.JourneyInput():
        return 'JourneyInput';
      case _i5ktdfyb.JourneyReport():
        return 'JourneyReport';
      case _i6knwx07.JourneyStatus():
        return 'JourneyStatus';
      case _ia9frtih.JourneyTrigger():
        return 'JourneyTrigger';
      case _it0j7yj1.JourneyVariantInput():
        return 'JourneyVariantInput';
      case _iz3quwrh.Link():
        return 'Link';
      case _im1bvi19.LinkClick():
        return 'LinkClick';
      case _ihsimdup.LotseApp():
        return 'LotseApp';
      case _ivzfk8pq.LotseConflictException():
        return 'LotseConflictException';
      case _ie33z5i4.LotseInstallCredentialException():
        return 'LotseInstallCredentialException';
      case _itzrvmn4.LotseInvalidInputException():
        return 'LotseInvalidInputException';
      case _iuvvcdjp.LotseMailNotSentException():
        return 'LotseMailNotSentException';
      case _izw809ga.LotseNotFoundException():
        return 'LotseNotFoundException';
      case _ictkkbnn.LotseOwnerOnlyException():
        return 'LotseOwnerOnlyException';
      case _ilq5ecfk.LotseProjectSuspendedException():
        return 'LotseProjectSuspendedException';
      case _imf72r4y.LotseQuotaExceededException():
        return 'LotseQuotaExceededException';
      case _ilnpyi2m.LotseSupportChatDisabledException():
        return 'LotseSupportChatDisabledException';
      case _ivxqciuj.MyFeedback():
        return 'MyFeedback';
      case _ikrc0jjp.MyFeedbackMessage():
        return 'MyFeedbackMessage';
      case _i4254r4x.MyFeedbackThread():
        return 'MyFeedbackThread';
      case _iclib0po.PlatformCount():
        return 'PlatformCount';
      case _ifiazq2p.Project():
        return 'Project';
      case _ieaem7s0.ProjectInvitationInfo():
        return 'ProjectInvitationInfo';
      case _igjd66vg.ProjectMemberInfo():
        return 'ProjectMemberInfo';
      case _iqnrtiz4.PushCredential():
        return 'PushCredential';
      case _i0unzms6.PushProvider():
        return 'PushProvider';
      case _i6cqc8ei.PushToken():
        return 'PushToken';
      case _iqfu18id.ReplayChunk():
        return 'ReplayChunk';
      case _i5dutshk.ReplayFrame():
        return 'ReplayFrame';
      case _i4x1uj01.ReplayMark():
        return 'ReplayMark';
      case _igbo9v0t.ReplayMarkKind():
        return 'ReplayMarkKind';
      case _iteij1k5.ResolvedLink():
        return 'ResolvedLink';
      case _i20mhv3w.RetentionCohort():
        return 'RetentionCohort';
      case _iplqqvn8.RetentionReport():
        return 'RetentionReport';
      case _iva6i66v.RetentionRow():
        return 'RetentionRow';
      case _iuyop9cb.RetentionSplit():
        return 'RetentionSplit';
      case _ivl2z976.SdkInAppMessage():
        return 'SdkInAppMessage';
      case _im4znf6v.SdkSurvey():
        return 'SdkSurvey';
      case _iavhy62p.Segment():
        return 'Segment';
      case _ie45uxmr.SetupCheck():
        return 'SetupCheck';
      case _i10jnq79.SetupCheckStatus():
        return 'SetupCheckStatus';
      case _ij7ppc9u.SetupDiagnosis():
        return 'SetupDiagnosis';
      case _i3mfntce.SetupTraffic():
        return 'SetupTraffic';
      case _ia25305t.SupportChat():
        return 'SupportChat';
      case _if7lizhn.Survey():
        return 'Survey';
      case _illgmjmc.SurveyGroup():
        return 'SurveyGroup';
      case _i7m36ch5.SurveyKind():
        return 'SurveyKind';
      case _io9fb8qj.SurveyReport():
        return 'SurveyReport';
      case _ibd3jznw.SurveyResponseItem():
        return 'SurveyResponseItem';
      case _inhml88y.SurveyResponsePage():
        return 'SurveyResponsePage';
      case _iw9o61c2.SurveyStatus():
        return 'SurveyStatus';
      case _i1ky4p4f.Timeline():
        return 'Timeline';
      case _ignyleo4.TimelineItem():
        return 'TimelineItem';
      case _i9cf7i61.TimelineItemKind():
        return 'TimelineItemKind';
      case _ipwekx4s.TrackedEvent():
        return 'TrackedEvent';
      case _ig0dwpc6.TrackedTap():
        return 'TrackedTap';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AcquisitionReport') {
      return deserialize<_i4gvoeo1.AcquisitionReport>(data['data']);
    }
    if (dataClassName == 'AcquisitionRow') {
      return deserialize<_i03ibdtb.AcquisitionRow>(data['data']);
    }
    if (dataClassName == 'AgentToken') {
      return deserialize<_icvv29rr.AgentToken>(data['data']);
    }
    if (dataClassName == 'AgentTokenCreated') {
      return deserialize<_iv2da2o5.AgentTokenCreated>(data['data']);
    }
    if (dataClassName == 'AgentTokenLevel') {
      return deserialize<_iv7slllc.AgentTokenLevel>(data['data']);
    }
    if (dataClassName == 'AnalyticsCount') {
      return deserialize<_i1ktyzpb.AnalyticsCount>(data['data']);
    }
    if (dataClassName == 'AnalyticsOverview') {
      return deserialize<_i7rjvjqt.AnalyticsOverview>(data['data']);
    }
    if (dataClassName == 'ApiKey') {
      return deserialize<_i72lo5ui.ApiKey>(data['data']);
    }
    if (dataClassName == 'ApiKeyCreated') {
      return deserialize<_ib1akd69.ApiKeyCreated>(data['data']);
    }
    if (dataClassName == 'ApnsEnvironment') {
      return deserialize<_iy23tayo.ApnsEnvironment>(data['data']);
    }
    if (dataClassName == 'AppUser') {
      return deserialize<_i2j2xfrn.AppUser>(data['data']);
    }
    if (dataClassName == 'AppUserListItem') {
      return deserialize<_i8lj71qd.AppUserListItem>(data['data']);
    }
    if (dataClassName == 'AttributionSource') {
      return deserialize<_i879b165.AttributionSource>(data['data']);
    }
    if (dataClassName == 'Campaign') {
      return deserialize<_iv6aasei.Campaign>(data['data']);
    }
    if (dataClassName == 'CampaignReport') {
      return deserialize<_ic3i7r9m.CampaignReport>(data['data']);
    }
    if (dataClassName == 'CampaignStatus') {
      return deserialize<_iys7xjaz.CampaignStatus>(data['data']);
    }
    if (dataClassName == 'CsvExport') {
      return deserialize<_isbyl930.CsvExport>(data['data']);
    }
    if (dataClassName == 'CsvExportKind') {
      return deserialize<_ihuvp8cb.CsvExportKind>(data['data']);
    }
    if (dataClassName == 'CsvExportRequest') {
      return deserialize<_ihzhdhyt.CsvExportRequest>(data['data']);
    }
    if (dataClassName == 'CsvFeedbackFilter') {
      return deserialize<_iog5sq87.CsvFeedbackFilter>(data['data']);
    }
    if (dataClassName == 'Delivery') {
      return deserialize<_ia87vg9p.Delivery>(data['data']);
    }
    if (dataClassName == 'DeliveryStatus') {
      return deserialize<_ib7m4h6q.DeliveryStatus>(data['data']);
    }
    if (dataClassName == 'DeliverySummary') {
      return deserialize<_izenipf5.DeliverySummary>(data['data']);
    }
    if (dataClassName == 'Device') {
      return deserialize<_ilo09f9g.Device>(data['data']);
    }
    if (dataClassName == 'DevicePlatform') {
      return deserialize<_ij3iar7l.DevicePlatform>(data['data']);
    }
    if (dataClassName == 'DeviceRegistration') {
      return deserialize<_ihub5uuq.DeviceRegistration>(data['data']);
    }
    if (dataClassName == 'Event') {
      return deserialize<_iu57571s.Event>(data['data']);
    }
    if (dataClassName == 'ExplorerQuery') {
      return deserialize<_is6a98og.ExplorerQuery>(data['data']);
    }
    if (dataClassName == 'ExplorerReport') {
      return deserialize<_i8rjtzwa.ExplorerReport>(data['data']);
    }
    if (dataClassName == 'ExplorerSeries') {
      return deserialize<_ia8ec5jy.ExplorerSeries>(data['data']);
    }
    if (dataClassName == 'ExplorerSeriesKind') {
      return deserialize<_i39vvocg.ExplorerSeriesKind>(data['data']);
    }
    if (dataClassName == 'ExplorerSplit') {
      return deserialize<_i6em6g0k.ExplorerSplit>(data['data']);
    }
    if (dataClassName == 'FeatureBoardItem') {
      return deserialize<_iwsbvz85.FeatureBoardItem>(data['data']);
    }
    if (dataClassName == 'FeatureRequest') {
      return deserialize<_i0n3whlw.FeatureRequest>(data['data']);
    }
    if (dataClassName == 'FeatureRequestStatus') {
      return deserialize<_ios6zwvp.FeatureRequestStatus>(data['data']);
    }
    if (dataClassName == 'Feedback') {
      return deserialize<_iut2va9k.Feedback>(data['data']);
    }
    if (dataClassName == 'FeedbackCategory') {
      return deserialize<_iju423hp.FeedbackCategory>(data['data']);
    }
    if (dataClassName == 'FeedbackConversationChange') {
      return deserialize<_i8aok9sf.FeedbackConversationChange>(data['data']);
    }
    if (dataClassName == 'FeedbackDetail') {
      return deserialize<_isd3h8f0.FeedbackDetail>(data['data']);
    }
    if (dataClassName == 'FeedbackListItem') {
      return deserialize<_i7gab86f.FeedbackListItem>(data['data']);
    }
    if (dataClassName == 'FeedbackMessage') {
      return deserialize<_i6m0uyvp.FeedbackMessage>(data['data']);
    }
    if (dataClassName == 'FeedbackMessageAuthor') {
      return deserialize<_imklq58l.FeedbackMessageAuthor>(data['data']);
    }
    if (dataClassName == 'FeedbackPage') {
      return deserialize<_i37glqj7.FeedbackPage>(data['data']);
    }
    if (dataClassName == 'FeedbackPushStatus') {
      return deserialize<_ipimo89r.FeedbackPushStatus>(data['data']);
    }
    if (dataClassName == 'FeedbackReplayInfo') {
      return deserialize<_iz3c8pxx.FeedbackReplayInfo>(data['data']);
    }
    if (dataClassName == 'FeedbackScreenshotInfo') {
      return deserialize<_igoqmjz7.FeedbackScreenshotInfo>(data['data']);
    }
    if (dataClassName == 'FeedbackStatus') {
      return deserialize<_ipjm5lus.FeedbackStatus>(data['data']);
    }
    if (dataClassName == 'FeedbackSubmission') {
      return deserialize<_i1txpxy2.FeedbackSubmission>(data['data']);
    }
    if (dataClassName == 'FunnelReport') {
      return deserialize<_ivok65vy.FunnelReport>(data['data']);
    }
    if (dataClassName == 'FunnelRow') {
      return deserialize<_i4ciuq8e.FunnelRow>(data['data']);
    }
    if (dataClassName == 'FunnelSplit') {
      return deserialize<_i3dwtlfw.FunnelSplit>(data['data']);
    }
    if (dataClassName == 'FunnelStep') {
      return deserialize<_ilifyhbs.FunnelStep>(data['data']);
    }
    if (dataClassName == 'HeatmapBackgroundInfo') {
      return deserialize<_immlrb5m.HeatmapBackgroundInfo>(data['data']);
    }
    if (dataClassName == 'HeatmapBackgroundSlot') {
      return deserialize<_i2frcp28.HeatmapBackgroundSlot>(data['data']);
    }
    if (dataClassName == 'HeatmapCell') {
      return deserialize<_i2wopt0u.HeatmapCell>(data['data']);
    }
    if (dataClassName == 'HeatmapReport') {
      return deserialize<_irpymhu8.HeatmapReport>(data['data']);
    }
    if (dataClassName == 'HeatmapScreen') {
      return deserialize<_ix0h1r59.HeatmapScreen>(data['data']);
    }
    if (dataClassName == 'HeatmapWidthClass') {
      return deserialize<_ibbfwb4e.HeatmapWidthClass>(data['data']);
    }
    if (dataClassName == 'IdentitySecretCreated') {
      return deserialize<_icu4k8w6.IdentitySecretCreated>(data['data']);
    }
    if (dataClassName == 'IdentityVerificationStatus') {
      return deserialize<_il6qcl22.IdentityVerificationStatus>(data['data']);
    }
    if (dataClassName == 'InAppMessage') {
      return deserialize<_icz8bdg4.InAppMessage>(data['data']);
    }
    if (dataClassName == 'InAppMessageListItem') {
      return deserialize<_ikekgdeo.InAppMessageListItem>(data['data']);
    }
    if (dataClassName == 'InAppMessageReport') {
      return deserialize<_io2eohxg.InAppMessageReport>(data['data']);
    }
    if (dataClassName == 'InAppMessageStatus') {
      return deserialize<_ihkv7mfu.InAppMessageStatus>(data['data']);
    }
    if (dataClassName == 'InAppMessageStyle') {
      return deserialize<_iv76hups.InAppMessageStyle>(data['data']);
    }
    if (dataClassName == 'Journey') {
      return deserialize<_iuh01ynj.Journey>(data['data']);
    }
    if (dataClassName == 'JourneyArm') {
      return deserialize<_i34jp9wz.JourneyArm>(data['data']);
    }
    if (dataClassName == 'JourneyDetail') {
      return deserialize<_iu4edyms.JourneyDetail>(data['data']);
    }
    if (dataClassName == 'JourneyExit') {
      return deserialize<_ilvr900l.JourneyExit>(data['data']);
    }
    if (dataClassName == 'JourneyGroup') {
      return deserialize<_ihadhz3u.JourneyGroup>(data['data']);
    }
    if (dataClassName == 'JourneyInput') {
      return deserialize<_idsjwygn.JourneyInput>(data['data']);
    }
    if (dataClassName == 'JourneyReport') {
      return deserialize<_i5ktdfyb.JourneyReport>(data['data']);
    }
    if (dataClassName == 'JourneyStatus') {
      return deserialize<_i6knwx07.JourneyStatus>(data['data']);
    }
    if (dataClassName == 'JourneyTrigger') {
      return deserialize<_ia9frtih.JourneyTrigger>(data['data']);
    }
    if (dataClassName == 'JourneyVariantInput') {
      return deserialize<_it0j7yj1.JourneyVariantInput>(data['data']);
    }
    if (dataClassName == 'Link') {
      return deserialize<_iz3quwrh.Link>(data['data']);
    }
    if (dataClassName == 'LinkClick') {
      return deserialize<_im1bvi19.LinkClick>(data['data']);
    }
    if (dataClassName == 'LotseApp') {
      return deserialize<_ihsimdup.LotseApp>(data['data']);
    }
    if (dataClassName == 'LotseConflictException') {
      return deserialize<_ivzfk8pq.LotseConflictException>(data['data']);
    }
    if (dataClassName == 'LotseInstallCredentialException') {
      return deserialize<_ie33z5i4.LotseInstallCredentialException>(
        data['data'],
      );
    }
    if (dataClassName == 'LotseInvalidInputException') {
      return deserialize<_itzrvmn4.LotseInvalidInputException>(data['data']);
    }
    if (dataClassName == 'LotseMailNotSentException') {
      return deserialize<_iuvvcdjp.LotseMailNotSentException>(data['data']);
    }
    if (dataClassName == 'LotseNotFoundException') {
      return deserialize<_izw809ga.LotseNotFoundException>(data['data']);
    }
    if (dataClassName == 'LotseOwnerOnlyException') {
      return deserialize<_ictkkbnn.LotseOwnerOnlyException>(data['data']);
    }
    if (dataClassName == 'LotseProjectSuspendedException') {
      return deserialize<_ilq5ecfk.LotseProjectSuspendedException>(
        data['data'],
      );
    }
    if (dataClassName == 'LotseQuotaExceededException') {
      return deserialize<_imf72r4y.LotseQuotaExceededException>(data['data']);
    }
    if (dataClassName == 'LotseSupportChatDisabledException') {
      return deserialize<_ilnpyi2m.LotseSupportChatDisabledException>(
        data['data'],
      );
    }
    if (dataClassName == 'MyFeedback') {
      return deserialize<_ivxqciuj.MyFeedback>(data['data']);
    }
    if (dataClassName == 'MyFeedbackMessage') {
      return deserialize<_ikrc0jjp.MyFeedbackMessage>(data['data']);
    }
    if (dataClassName == 'MyFeedbackThread') {
      return deserialize<_i4254r4x.MyFeedbackThread>(data['data']);
    }
    if (dataClassName == 'PlatformCount') {
      return deserialize<_iclib0po.PlatformCount>(data['data']);
    }
    if (dataClassName == 'Project') {
      return deserialize<_ifiazq2p.Project>(data['data']);
    }
    if (dataClassName == 'ProjectInvitationInfo') {
      return deserialize<_ieaem7s0.ProjectInvitationInfo>(data['data']);
    }
    if (dataClassName == 'ProjectMemberInfo') {
      return deserialize<_igjd66vg.ProjectMemberInfo>(data['data']);
    }
    if (dataClassName == 'PushCredential') {
      return deserialize<_iqnrtiz4.PushCredential>(data['data']);
    }
    if (dataClassName == 'PushProvider') {
      return deserialize<_i0unzms6.PushProvider>(data['data']);
    }
    if (dataClassName == 'PushToken') {
      return deserialize<_i6cqc8ei.PushToken>(data['data']);
    }
    if (dataClassName == 'ReplayChunk') {
      return deserialize<_iqfu18id.ReplayChunk>(data['data']);
    }
    if (dataClassName == 'ReplayFrame') {
      return deserialize<_i5dutshk.ReplayFrame>(data['data']);
    }
    if (dataClassName == 'ReplayMark') {
      return deserialize<_i4x1uj01.ReplayMark>(data['data']);
    }
    if (dataClassName == 'ReplayMarkKind') {
      return deserialize<_igbo9v0t.ReplayMarkKind>(data['data']);
    }
    if (dataClassName == 'ResolvedLink') {
      return deserialize<_iteij1k5.ResolvedLink>(data['data']);
    }
    if (dataClassName == 'RetentionCohort') {
      return deserialize<_i20mhv3w.RetentionCohort>(data['data']);
    }
    if (dataClassName == 'RetentionReport') {
      return deserialize<_iplqqvn8.RetentionReport>(data['data']);
    }
    if (dataClassName == 'RetentionRow') {
      return deserialize<_iva6i66v.RetentionRow>(data['data']);
    }
    if (dataClassName == 'RetentionSplit') {
      return deserialize<_iuyop9cb.RetentionSplit>(data['data']);
    }
    if (dataClassName == 'SdkInAppMessage') {
      return deserialize<_ivl2z976.SdkInAppMessage>(data['data']);
    }
    if (dataClassName == 'SdkSurvey') {
      return deserialize<_im4znf6v.SdkSurvey>(data['data']);
    }
    if (dataClassName == 'Segment') {
      return deserialize<_iavhy62p.Segment>(data['data']);
    }
    if (dataClassName == 'SetupCheck') {
      return deserialize<_ie45uxmr.SetupCheck>(data['data']);
    }
    if (dataClassName == 'SetupCheckStatus') {
      return deserialize<_i10jnq79.SetupCheckStatus>(data['data']);
    }
    if (dataClassName == 'SetupDiagnosis') {
      return deserialize<_ij7ppc9u.SetupDiagnosis>(data['data']);
    }
    if (dataClassName == 'SetupTraffic') {
      return deserialize<_i3mfntce.SetupTraffic>(data['data']);
    }
    if (dataClassName == 'SupportChat') {
      return deserialize<_ia25305t.SupportChat>(data['data']);
    }
    if (dataClassName == 'Survey') {
      return deserialize<_if7lizhn.Survey>(data['data']);
    }
    if (dataClassName == 'SurveyGroup') {
      return deserialize<_illgmjmc.SurveyGroup>(data['data']);
    }
    if (dataClassName == 'SurveyKind') {
      return deserialize<_i7m36ch5.SurveyKind>(data['data']);
    }
    if (dataClassName == 'SurveyReport') {
      return deserialize<_io9fb8qj.SurveyReport>(data['data']);
    }
    if (dataClassName == 'SurveyResponseItem') {
      return deserialize<_ibd3jznw.SurveyResponseItem>(data['data']);
    }
    if (dataClassName == 'SurveyResponsePage') {
      return deserialize<_inhml88y.SurveyResponsePage>(data['data']);
    }
    if (dataClassName == 'SurveyStatus') {
      return deserialize<_iw9o61c2.SurveyStatus>(data['data']);
    }
    if (dataClassName == 'Timeline') {
      return deserialize<_i1ky4p4f.Timeline>(data['data']);
    }
    if (dataClassName == 'TimelineItem') {
      return deserialize<_ignyleo4.TimelineItem>(data['data']);
    }
    if (dataClassName == 'TimelineItemKind') {
      return deserialize<_i9cf7i61.TimelineItemKind>(data['data']);
    }
    if (dataClassName == 'TrackedEvent') {
      return deserialize<_ipwekx4s.TrackedEvent>(data['data']);
    }
    if (dataClassName == 'TrackedTap') {
      return deserialize<_ig0dwpc6.TrackedTap>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('lotse', this);
    _iacc.Protocol().registerHostProtocol('lotse', this);
  }

  @override
  String getModuleName() => 'lotse';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
