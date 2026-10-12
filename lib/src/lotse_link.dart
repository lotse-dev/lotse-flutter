import 'package:flutter/foundation.dart';
import 'package:lotse/src/client/lotse_client.dart' as generated;
import 'package:shared_preferences/shared_preferences.dart';
import 'lotse_log.dart';

const _deferredResolvedKey = 'lotse.deferredResolved';

/// A Lotse link resolved for this project: where the app should navigate and
/// which campaign brought the user there.
class LotseLink {
  /// Creates a resolved link.
  const LotseLink({
    required this.slug,
    required this.targetPath,
    this.campaign,
    this.source,
    this.medium,
  });

  /// The slug the link was resolved from.
  final String slug;

  /// The app route to open, for example `/offer/42`.
  final String targetPath;

  /// The campaign the link belongs to, if any.
  final String? campaign;

  /// The traffic source, if any.
  final String? source;

  /// The marketing medium, if any.
  final String? medium;
}

/// Resolves [slug] through [resolve] and maps the server answer to a
/// [LotseLink].
///
/// Returns `null` if the slug is unknown or the call fails. Failures are
/// logged, never thrown into the app. Takes the endpoint call as a function
/// so it can be tested without a server. [onOpened] hears of every link
/// that resolved.
Future<LotseLink?> resolveLotseLink(
  Future<generated.ResolvedLink> Function(String slug) resolve,
  String slug, {
  void Function(LotseLink link)? onOpened,
}) async {
  try {
    final link = lotseLinkFromResolved(await resolve(slug));
    if (link != null) onOpened?.call(link);
    return link;
  } on generated.LotseNotFoundException {
    debugPrint('Lotse: link "$slug" not found.');
    return null;
  } catch (error) {
    lotseLog('could not resolve link "$slug"', error);
    return null;
  }
}

/// Maps the server answer [link] to a [LotseLink], keeping `null` as `null`.
LotseLink? lotseLinkFromResolved(generated.ResolvedLink? link) => link == null
    ? null
    : LotseLink(
        slug: link.slug,
        targetPath: link.targetPath,
        campaign: link.campaign,
        source: link.source,
        medium: link.medium,
      );

/// Resolves the deferred link through [resolve], once per install.
///
/// Returns `null` on every call after a successful one, without a match and on
/// any failure. A failed call leaves the flag unset so the next start retries;
/// the server answers repeated calls with the stored link. Failures are logged,
/// never thrown into the app.
Future<LotseLink?> resolveDeferredLotseLinkOnce(
  SharedPreferences preferences,
  Future<generated.ResolvedLink?> Function() resolve,
) async {
  if (preferences.getBool(_deferredResolvedKey) ?? false) return null;
  final generated.ResolvedLink? link;
  try {
    link = await resolve();
  } catch (error) {
    lotseLog('could not resolve the deferred link', error);
    return null;
  }
  try {
    await preferences.setBool(_deferredResolvedKey, true);
  } catch (error) {
    lotseLog('could not persist the deferred link flag', error);
  }
  return lotseLinkFromResolved(link);
}

/// Event the SDK tracks when a link opened the app and resolved, with the
/// prop `slug`. The setup diagnosis compares it with the clicks that landed
/// in the browser: App Links that work never reach the server as a click.
const linkOpenEvent = 'link_open';
