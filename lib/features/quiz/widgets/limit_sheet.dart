import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/app_modal.dart';
import '../../../l10n/app_localizations.dart';

/// The free-plan limit card · Figma `199:2335` (school) ·
/// `225:6634` / `225:7001` (university).
///
/// Opened by the two 403s on `POST /quizzes` that are not inline errors:
/// `weekly_question_limit_reached` and `subscription_required`. Same card,
/// different heading and body.
///
/// Also the contract's popup for `GET /questions/{id}/explanation`'s
/// `subscription_required` ([showExplanation]): same card and title, the
/// contract's approved copy as the body, verbatim (API→UI Wave 12, owner
/// ruling 2026-09-26).
///
/// **A centred card, not a bottom sheet** (API→UI Wave 11, owner ruling
/// 2026-09-26). The frame's `limitation` instance (`207:5904`) is a 345-wide
/// card at radius 22 over the scrim, with a ✕ before the title. It used to be
/// a bottom sheet with a drag handle. The class keeps its name: its callers
/// and tests name the thing, not its shape.
///
/// **Purchase-silent (adr-049 §3).** The frames draw an "Upgrade To Premium"
/// button over a benefits list; the contract forbids both — the app never
/// shows a paywall, a price, an upgrade link or where to buy. The card
/// explains the 403 and offers the ✕ and "Not now", nothing else (D-007,
/// docs/DESIGN_ISSUES.md #51).
///
/// **Weekly, not daily.** The frame family says "Daily Limit Reached"; the
/// contract says *"Free plan: 50 questions/WEEK"* and names the code
/// `weekly_question_limit_reached`. The server owns the rule and the code name
/// agrees with it, so the copy says weekly (docs/seif_fight.md S16).
///
/// **The "QUESTIONS 50/50" bar is not built.** Nothing in the contract exposes
/// how many questions a student has used or what their cap is — the 403 is the
/// only signal, and it arrives without numbers. Drawing a bar would mean
/// fabricating both ends of it, exactly as with the setup screen's pool card
/// (docs/seif_fight.md S15).
class LimitSheet extends StatelessWidget {
  const LimitSheet({super.key, required this.code, this.explanation = false});

  /// `weekly_question_limit_reached` or `subscription_required`.
  final String code;

  /// The explanation popup rather than a quiz-creation one: the body is the
  /// contract's approved copy for `getExplanation`'s `subscription_required`.
  final bool explanation;

  /// Shows the card for [error]. Dismissible — by the ✕, "Not now", a tap on
  /// the scrim or Back: the student must be able to get back to what they were
  /// doing, and there is nothing else to do here.
  static Future<void> show(BuildContext context, ApiException error) =>
      _open(context, LimitSheet(code: error.code));

  /// The contract's popup for an AI explanation a student is not subscribed
  /// to: "Show this popup, using this approved copy verbatim".
  static Future<void> showExplanation(BuildContext context) => _open(
    context,
    const LimitSheet(code: 'subscription_required', explanation: true),
  );

  static Future<void> _open(BuildContext context, LimitSheet card) {
    // `Rectangle 6427` in the light Limitation frame: 50% #313131 over a page
    // blurred at sigma 5.75.
    //
    // **The dark scrim is BLOCKED, not absent.** No dark Limitation frame
    // exists in the file, so `limitSheetScrim` is null on that canvas and the
    // card keeps the framework's default barrier there — a gap recorded in
    // docs/DESIGN_ISSUES.md, not a design decision.
    return showAppDialog<void>(
      context: context,
      scrim: Theme.of(context).extension<AppElevation>()!.limitSheetScrim,
      builder: (_) => card,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final l10n = AppLocalizations.of(context);

    final isSubscription = code == 'subscription_required';
    final title = isSubscription
        ? l10n.subscriptionRequiredTitle
        : l10n.freeUsageReachedTitle;
    final body = explanation
        ? l10n.explanationSubscriptionRequired
        : isSubscription
        ? l10n.subscriptionRequiredBody
        : l10n.weeklyLimitBody;

    return Dialog(
      // Opaque page fill, like every dialog in the app: `#FCFBF9` is the
      // frame's own card. Dark has no frame (#74) and takes the dark page
      // fill, as the Profile dialog does.
      backgroundColor: ext.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      // 345 wide on the 402 frame.
      insetPadding: const EdgeInsets.symmetric(horizontal: 28.5, vertical: 24),
      // Top and bottom are the app's dialog rhythm (`ProfileConfirmDialog`,
      // `180:4445`: 20 over a 35 dp title row), not the frame's 59 and 16,
      // which were drawn around the benefits card and the CTA that adr-049
      // removed (#51). The top reads 13.5 because the row below is 48, not 35:
      // same centre line, 6.5 more on each side.
      child: Padding(
        padding: const EdgeInsetsDirectional.only(top: 13.5, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // The frame's title row: a 23 dp ✕ box 6 inside a row inset 18,
            // i.e. 24 from the card's start edge, and the title centred.
            //
            // The ✕ keeps a full 48 x 48 target, centred on that box. Inset
            // 11.5 = 24 - (48 - 23) / 2. The row is 48 tall so the whole
            // target is inside it: a Stack neither paints nor hit-tests
            // outside its own size. W11-5 (API→UI Wave 11 walk): the 48 dp
            // padding used to centre a 35 dp button's icon 6.5 dp inboard.
            // Stretched, so `start: 0` is the row's edge and not the title's
            // (the Profile dialog's 2026-08-21 device bug).
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11.5),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 48),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Padding(
                      // Clear of the ✕ target on BOTH sides, so the title
                      // stays centred and a long one wraps instead of running
                      // under it.
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        // The frame sets Inter 600/22; the type scale has no
                        // 22, so this is the app's dialog title (h2), as on
                        // the Profile dialog.
                        style: AppType.h2.copyWith(color: ext.limitSheetTitle),
                      ),
                    ),
                    PositionedDirectional(
                      start: 0,
                      child: IconButton(
                        key: const Key('limit_sheet_close'),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints.tightFor(
                          width: 48,
                          height: 48,
                        ),
                        tooltip: l10n.dialogClose,
                        onPressed: () => Navigator.of(context).pop(),
                        // The frame's own `akar-icons:cross` (`207:5904`):
                        // 15.3 dp of stroke in its 23 dp box, round caps.
                        // `Icons.close` drew 13.3 (W11-5).
                        icon: SvgPicture.asset(
                          'assets/icons/close_cross.svg',
                          width: 23,
                          height: 23,
                          // The tooltip names the button. Without this the
                          // glyph's own `Semantics(image: true)` merges in and
                          // TalkBack reads an ImageView (W11-7).
                          excludeFromSemantics: true,
                          colorFilter: ColorFilter.mode(
                            ext.limitSheetClose,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 12 below a 35 dp row = 5.5 below this 48 dp one.
            const SizedBox(height: 5.5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    body,
                    textAlign: TextAlign.center,
                    style: AppType.bodyLarge.copyWith(color: ext.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  // No CTA. The frames draw "Upgrade To Premium" over a
                  // benefits list; adr-049 §3 forbids both. Dismissal is the
                  // only action.
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.notNow),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
