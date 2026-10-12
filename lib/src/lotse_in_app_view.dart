import 'package:flutter/material.dart';

import 'lotse_feedback_texts.dart';
import 'lotse_in_app.dart';
import 'lotse_survey.dart';
import 'lotse_survey_view.dart';
import 'lotse_taps.dart';

/// Shows the in-app messages the team wrote in the Lotse console for a
/// segment of devices: a card in the middle of the screen or a banner at the
/// top, one at a time, above [child].
///
/// Put it into the `builder` of your `MaterialApp`, so it sits above every
/// route and uses the app's theme:
///
/// ```dart
/// MaterialApp.router(
///   routerConfig: router,
///   builder: (context, child) => LotseInAppMessages(
///     onTap: (message) => router.go(message.targetPath ?? '/'),
///     child: child!,
///   ),
/// );
/// ```
///
/// The SDK asks the server for messages when the app starts and whenever it
/// comes back to the front, at most once a minute; `Lotse.checkInAppMessages`
/// asks at once. A message the user taps or closes does not come again. The
/// SDK tracks `in_app_view`, `in_app_tap` and `in_app_dismiss` with the id of
/// the message, so the console reports on it and a segment can use it.
///
/// The same place shows the surveys of the console: one question to a
/// segment, as a card with the scores 0 to 10 or two to five answers. A
/// survey comes only when no message is on screen; the SDK sends the answer
/// and tracks `survey_view` and `survey_dismiss`. Nothing to do for the app.
///
/// Before `Lotse.init` and when there is nothing to show it just shows
/// [child]. The buttons read "Open" and "Close", in German on a German
/// device; the team sets the card's button label per message. The texts of
/// the survey card come from [texts].
class LotseInAppMessages extends StatelessWidget {
  /// Shows the messages above [child]. [onTap] gets the tapped message, whose
  /// [LotseInAppMessage.targetPath] is the app route to open.
  const LotseInAppMessages({
    required this.child,
    this.onTap,
    this.texts,
    super.key,
  });

  /// The app.
  final Widget child;

  /// Called when the user taps a card's button or a banner. Without it a tap
  /// only closes the message.
  final void Function(LotseInAppMessage message)? onTap;

  /// Texts of the survey card (the `survey…` fields). Without them the SDK
  /// picks English or German by the locale.
  final LotseFeedbackTexts? texts;

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<LotseInAppInbox?>(
        valueListenable: lotseInAppInbox,
        builder: (context, inbox, _) => inbox == null
            ? child
            : ValueListenableBuilder<LotseSurveyDesk?>(
                valueListenable: lotseSurveyDesk,
                builder: (context, surveys, _) => LotseInAppHost(
                  inbox: inbox,
                  surveys: surveys,
                  onTap: onTap,
                  texts: texts,
                  child: child,
                ),
              ),
      );
}

/// [LotseInAppMessages] over a given inbox. Internal; tests use it directly.
class LotseInAppHost extends StatefulWidget {
  /// Shows what [inbox] holds above [child].
  const LotseInAppHost({
    required this.inbox,
    required this.child,
    this.surveys,
    this.onTap,
    this.texts,
    super.key,
  });

  final LotseInAppInbox inbox;

  /// Shows its survey while no message is on screen; null for none.
  final LotseSurveyDesk? surveys;
  final Widget child;
  final void Function(LotseInAppMessage message)? onTap;
  final LotseFeedbackTexts? texts;

  @override
  State<LotseInAppHost> createState() => _LotseInAppHostState();
}

class _LotseInAppHostState extends State<LotseInAppHost> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      // The survey after the messages: it waits while one is on screen.
      onResume: () async {
        await widget.inbox.check();
        await widget.surveys?.check();
      },
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  void _tap(LotseInAppMessage message) {
    widget.inbox.tapped(message);
    widget.onTap?.call(message);
  }

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<LotseInAppMessage?>(
        valueListenable: widget.inbox.current,
        builder: (context, message, child) {
          if (message == null) return _survey(context, child!);
          // After the frame: tracking must not run inside a build.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) widget.inbox.shown(message);
          });
          final texts = _InAppTexts.of(context);
          return Stack(
            children: [
              child!,
              // Taps on the message belong to no screen of the app.
              Positioned.fill(
                child: LotseOffScreen(
                  child: Stack(
                    children: [
                      switch (message.style) {
                        LotseInAppStyle.card => _Card(
                          key: ValueKey(message.id),
                          message: message,
                          texts: texts,
                          onTap: () => _tap(message),
                          onClose: () => widget.inbox.dismissed(message),
                        ),
                        LotseInAppStyle.banner => _Banner(
                          key: ValueKey(message.id),
                          message: message,
                          texts: texts,
                          onTap: () => _tap(message),
                          onClose: () => widget.inbox.dismissed(message),
                        ),
                      },
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        child: widget.child,
      );
}

/// [child] with the card of the current survey above it, if any.
extension on _LotseInAppHostState {
  Widget _survey(BuildContext context, Widget child) {
    final surveys = widget.surveys;
    if (surveys == null) return child;
    return ValueListenableBuilder<LotseSurveyState?>(
      valueListenable: surveys.current,
      builder: (context, state, child) {
        if (state == null) return child!;
        // After the frame: tracking must not run inside a build.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) surveys.shown(state.survey);
        });
        final texts =
            widget.texts ??
            LotseFeedbackTexts.forLocale(
              Localizations.maybeLocaleOf(context) ??
                  WidgetsBinding.instance.platformDispatcher.locale,
            );
        return Stack(
          children: [
            child!,
            Positioned.fill(
              child: LotseOffScreen(
                child: LotseSurveyCard(
                  key: ValueKey(state.survey.id),
                  desk: surveys,
                  state: state,
                  texts: texts,
                ),
              ),
            ),
          ],
        );
      },
      child: child,
    );
  }
}

/// The two fixed words of the messages, English or German by the locale of
/// the app, else of the device.
class _InAppTexts {
  const _InAppTexts(this.open, this.close);

  final String open;
  final String close;

  static _InAppTexts of(BuildContext context) {
    final locale =
        Localizations.maybeLocaleOf(context) ??
        WidgetsBinding.instance.platformDispatcher.locale;
    return locale.languageCode == 'de'
        ? const _InAppTexts('Öffnen', 'Schließen')
        : const _InAppTexts('Open', 'Close');
  }
}

/// A close icon without a tooltip: the host may sit above the navigator,
/// where there is no overlay for one.
class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    excludeSemantics: true,
    child: IconButton(icon: const Icon(Icons.close), onPressed: onPressed),
  );
}

class _Card extends StatelessWidget {
  const _Card({
    required this.message,
    required this.texts,
    required this.onTap,
    required this.onClose,
    super.key,
  });

  final LotseInAppMessage message;
  final _InAppTexts texts;
  final VoidCallback onTap;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black54,
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Material(
                  color: theme.colorScheme.surfaceContainerHigh,
                  elevation: 6,
                  borderRadius: BorderRadius.circular(28),
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 8, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Text(
                                  message.title,
                                  style: theme.textTheme.titleLarge,
                                ),
                              ),
                            ),
                            _CloseButton(
                              label: texts.close,
                              onPressed: onClose,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 16, 16),
                          child: Text(
                            message.body,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(end: 8),
                            child: FilledButton(
                              onPressed: onTap,
                              child: Text(message.buttonLabel ?? texts.open),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    required this.message,
    required this.texts,
    required this.onTap,
    required this.onClose,
    super.key,
  });

  final LotseInAppMessage message;
  final _InAppTexts texts;
  final VoidCallback onTap;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Material(
            color: theme.colorScheme.primaryContainer,
            elevation: 4,
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            message.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                          Text(
                            message.body,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _CloseButton(label: texts.close, onPressed: onClose),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
