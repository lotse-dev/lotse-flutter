import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/client/lotse_client.dart' as generated;
import 'package:lotse/src/lotse_link.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late List<String?> logs;

  setUp(() {
    logs = [];
    final original = debugPrint;
    debugPrint = (message, {wrapWidth}) => logs.add(message);
    addTearDown(() => debugPrint = original);
  });

  test('maps the server answer to a LotseLink', () async {
    final link = await resolveLotseLink(
      (slug) async => generated.ResolvedLink(
        slug: slug,
        targetPath: '/offer/42',
        campaign: 'summer',
        source: 'newsletter',
        medium: 'email',
      ),
      'abc',
    );

    expect(link, isNotNull);
    expect(link!.slug, 'abc');
    expect(link.targetPath, '/offer/42');
    expect(link.campaign, 'summer');
    expect(link.source, 'newsletter');
    expect(link.medium, 'email');
    expect(logs, isEmpty);
  });

  test('keeps missing campaign fields null', () async {
    final link = await resolveLotseLink(
      (slug) async => generated.ResolvedLink(slug: slug, targetPath: '/'),
      'abc',
    );

    expect(link!.campaign, isNull);
    expect(link.source, isNull);
    expect(link.medium, isNull);
  });

  test('returns null and logs when the link is not found', () async {
    final link = await resolveLotseLink(
      (_) async => throw generated.LotseNotFoundException(message: 'nope'),
      'abc',
    );

    expect(link, isNull);
    expect(logs, ['Lotse: link "abc" not found.']);
  });

  test('returns null and logs when the call fails', () async {
    final link = await resolveLotseLink(
      (_) async => throw StateError('offline'),
      'abc',
    );

    expect(link, isNull);
    expect(logs, hasLength(1));
    expect(logs.single, startsWith('Lotse: could not resolve link "abc": '));
    expect(logs.single, contains('offline'));
  });

  test('maps a missing server answer to null', () {
    expect(lotseLinkFromResolved(null), isNull);
  });

  group('resolveDeferredLotseLinkOnce', () {
    late SharedPreferences preferences;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      preferences = await SharedPreferences.getInstance();
    });

    test('maps the match and sets the flag', () async {
      final link = await resolveDeferredLotseLinkOnce(
        preferences,
        () async =>
            generated.ResolvedLink(slug: 'abc', targetPath: '/offer/42'),
      );

      expect(link!.slug, 'abc');
      expect(link.targetPath, '/offer/42');
      expect(preferences.getBool('lotse.deferredResolved'), isTrue);
    });

    test('sets the flag when nothing matched', () async {
      final link = await resolveDeferredLotseLinkOnce(
        preferences,
        () async => null,
      );

      expect(link, isNull);
      expect(preferences.getBool('lotse.deferredResolved'), isTrue);
    });

    test('leaves the flag unset and logs when the call fails', () async {
      final link = await resolveDeferredLotseLinkOnce(
        preferences,
        () async => throw StateError('offline'),
      );

      expect(link, isNull);
      expect(preferences.getBool('lotse.deferredResolved'), isNull);
      expect(logs.single, contains('offline'));
    });

    test('does not call the server once the flag is set', () async {
      await preferences.setBool('lotse.deferredResolved', true);
      var called = false;

      final link = await resolveDeferredLotseLinkOnce(preferences, () async {
        called = true;
        return null;
      });

      expect(link, isNull);
      expect(called, isFalse);
    });
  });

  test('tells onOpened of a resolved link, not of a missing one', () async {
    final opened = <String>[];
    await resolveLotseLink(
      (slug) async => generated.ResolvedLink(slug: slug, targetPath: '/'),
      'launch',
      onOpened: (link) => opened.add(link.slug),
    );
    await resolveLotseLink(
      (_) async => throw generated.LotseNotFoundException(message: 'nope'),
      'gone',
      onOpened: (link) => opened.add(link.slug),
    );
    expect(opened, ['launch']);
    expect(linkOpenEvent, 'link_open');
  });
}
