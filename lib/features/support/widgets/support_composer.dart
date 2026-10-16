import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/elevated_surface.dart';
import '../../../l10n/app_localizations.dart';
import 'support_status_pill.dart';

/// The bar both the composer and the closed bar sit in · Figma `178:3467`: the
/// card fill, a thin shadow cast UP (0, -1), start padding 20, end 16 and 10
/// above and below. Dark has no frame: Glass G5 and no shadow.
class _ThreadBar extends StatelessWidget {
  const _ThreadBar({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;

    return ElevatedSurface(
      shape: const RoundedRectangleBorder(),
      color: ext.supportCardFill,
      shadows: elevation.supportComposerBarShadows,
      glass: elevation.supportComposerBarGlass,
      padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 16, 10),
      child: child,
    );
  }
}

/// The reply composer · Figma `178:3467` / `178:3468`.
///
/// A white field (radius 30, at least 56 high) grows from one to four lines,
/// holds at most 4000 characters (the contract's cap, enforced as a formatter
/// so the field cannot hold what the server would refuse), and has the send
/// glyph at its end.
///
/// **The send glyph is a labelled button** for screen readers: one node named
/// `supportSend` (Send / إرسال, owner-approved O-14), from a 48 dp target
/// around its 24 dp drawing. The keyboard's Send action ([TextInputAction.send])
/// sends too.
///
/// **The field keeps its name once there is text.** The hint is the field's
/// only name, and Material drops a hint from semantics as soon as the field
/// holds text, which would leave a screen reader announcing an unnamed field.
/// So the same approved words are restated as the field's label then, and only
/// then: while the field is empty the visible hint already names it, and both
/// would read it twice. The label is `''` rather than `null` while empty, which
/// keeps the field on the same semantics node as the first character arrives
/// (`null` re-creates the node, and a screen reader's focus is lost with it).
///
/// **The glyph is disabled** while the trimmed text is empty or a send is in
/// flight, and shows a spinner in flight. The send is the caller's: this widget
/// only reports it, once, through [onSend], and never sends an empty text.
class SupportComposer extends StatelessWidget {
  const SupportComposer({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.canSend,
    required this.sending,
    required this.onSend,
    this.onChanged,
    this.errorText,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  /// Whether there is something to send right now (non-empty after trimming,
  /// and nothing already in flight).
  final bool canSend;

  /// A send is in flight: the glyph becomes a spinner.
  final bool sending;

  final VoidCallback onSend;
  final ValueChanged<String>? onChanged;

  /// The localized reason the last send failed, shown above the field. The text
  /// stays in the field.
  final String? errorText;

  /// The contract's cap on a reply `body` (`openapi.yaml`, 1 to 4000).
  static const maxLength = 4000;

  static const _radius = 30.0;
  static const _minHeight = 56.0;

  /// `178:3468`: the hint starts 22 from the start edge.
  static const _textStart = 22.0;

  /// One 24 line in the 56: 16 above and below.
  static const _textVertical = 16.0;

  /// The glyph is drawn 24 and sits 16 from the end edge; the 48 tap target
  /// around it therefore overhangs that edge's padding by 12, so 4 is left
  /// after it.
  static const _glyph = 24.0;
  static const _target = 48.0;
  static const _afterTarget = 4.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;

    return _ThreadBar(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (errorText != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 8),
              // A live region: the failure appears while the student's focus is
              // in the field, so a screen reader has to be told it happened.
              child: Semantics(
                liveRegion: true,
                child: Row(
                  key: const Key('support_send_error'),
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 18,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        errorText!,
                        style: AppType.bodyMedium.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ElevatedSurface(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_radius),
            ),
            color: ext.supportSurfaceFill,
            shadows: elevation.supportComposerFieldShadows,
            // The frame gives the field no Glass, but it is an input on a
            // Glass bar in dark and would otherwise have no edge at all: the
            // existing field Glass, which is null in light.
            glass: elevation.fieldGlass,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: _minHeight),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    // The field's name once the hint is gone (see the class
                    // doc). Only the Semantics rebuilds per keystroke; the
                    // field is the builder's child.
                    child: ListenableBuilder(
                      listenable: controller,
                      builder: (context, field) => Semantics(
                        label: controller.text.isEmpty
                            ? ''
                            : l10n.supportComposerHint,
                        child: field,
                      ),
                      // The padding is inside the field, so the whole pill (not
                      // just its one text line) takes the tap.
                      child: TextField(
                        key: const Key('support_composer_field'),
                        controller: controller,
                        focusNode: focusNode,
                        onChanged: onChanged,
                        // The keyboard's own Send action sends too. It is a
                        // multiline field, so without this the Enter key would
                        // add a line.
                        textInputAction: TextInputAction.send,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 4,
                        onSubmitted: (_) => onSend(),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(maxLength),
                        ],
                        style: AppType.bodyLarge.copyWith(
                          color: ext.textPrimary,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          // Dense, or Material floors the field at 48.
                          isDense: true,
                          contentPadding: const EdgeInsetsDirectional.only(
                            start: _textStart,
                            top: _textVertical,
                            bottom: _textVertical,
                          ),
                          hintText: l10n.supportComposerHint,
                          hintStyle: AppType.h4.copyWith(
                            color: ext.supportComposerHint,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // One node: a button named Send, enabled only when there is
                  // something to send. The tap action is the InkResponse's.
                  Semantics(
                    container: true,
                    button: true,
                    enabled: canSend,
                    label: l10n.supportSend,
                    // Its own transparent Material: the ink must paint ABOVE
                    // the field's fill, and the Scaffold's Material is below
                    // it.
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkResponse(
                        key: const Key('support_send'),
                        onTap: canSend ? onSend : null,
                        customBorder: const CircleBorder(),
                        radius: _target / 2,
                        child: SizedBox.square(
                          dimension: _target,
                          child: Center(
                            child: sending
                                // Excluded: a progress indicator inside the
                                // button would give the node a progress-bar
                                // role on Android (BUG-021's lesson).
                                ? ExcludeSemantics(
                                    child: SizedBox.square(
                                      dimension: _glyph - 4,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: ext.supportInk,
                                      ),
                                    ),
                                  )
                                : SvgPicture.asset(
                                    'assets/icons/support_send.svg',
                                    height: _glyph,
                                    // The glyph points to the right (the
                                    // frame's paper plane), so it mirrors in
                                    // RTL like the chevrons do.
                                    matchTextDirection: true,
                                    // Tinted from a token, so it follows the
                                    // canvas. A disabled glyph is dimmed with
                                    // the project's existing 0.45 convention.
                                    colorFilter: ColorFilter.mode(
                                      canSend
                                          ? ext.supportInk
                                          : ext.supportInk.withValues(
                                              alpha: 0.45,
                                            ),
                                      BlendMode.srcIn,
                                    ),
                                    excludeFromSemantics: true,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: _afterTarget),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// What replaces the composer once a ticket is closed: the Closed pill and a
/// text button that opens the create screen.
///
/// **A stand-in layout, not a drawn one.** The frame has no closed thread; the
/// contract only says a closed ticket refuses a reply and cannot be reopened.
/// So the bar reuses the composer's own bar and the list's approved copy (the
/// pill's `supportStatusClosed`, the card's `supportCreateNewTicket`) and
/// invents no new text. Logged for the designer.
///
/// The button shares the card's key on purpose, so the two always read alike.
/// In Arabic that is the owner-approved shorter form, the same words as the
/// create screen's own heading (`createTicket`).
class SupportClosedBar extends StatelessWidget {
  const SupportClosedBar({super.key, required this.onNewTicket});

  final VoidCallback onNewTicket;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    return _ThreadBar(
      child: Row(
        children: [
          SupportStatusPill(
            key: const Key('support_closed_pill'),
            label: l10n.supportStatusClosed,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                key: const Key('support_closed_new_ticket'),
                onPressed: onNewTicket,
                style: TextButton.styleFrom(
                  foregroundColor: ext.supportInk,
                  minimumSize: const Size(48, 48),
                ),
                // The style goes on the Text, not the button's `textStyle`:
                // that one REPLACES the theme's, and `AppType` names no family
                // (by design), so the label lost Inter and its Tajawal/Cairo
                // fallback and drew in the platform's default face. On the
                // Text it merges onto the theme's and keeps both.
                child: Text(
                  l10n.supportCreateNewTicket,
                  textAlign: TextAlign.end,
                  style: AppType.buttonMedium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
