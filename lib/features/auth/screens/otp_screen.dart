import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/router/return_target.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/circle_back_button.dart';
import '../../../core/widgets/elevation/elevated_surface.dart';
import '../../../core/widgets/elevation/primary_cta.dart';
import '../../../core/widgets/language_pill.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../l10n/app_localizations.dart';
import '../../registration/models/registration_args.dart';
import '../../registration/notifier/registration_controller.dart';
import '../auth_error_copy.dart';
import '../models/auth_outcome.dart';
import '../models/otp_args.dart';
import '../notifier/otp_notifier.dart';

/// OTP verify. SIX boxes (contract mandates 6; the Figma's 4 is superseded).
/// Forks on verify: authenticated → success screen → /home; registrationRequired
/// → carry the registrationToken to /register. Renders loading / error / offline
/// / success / banned (`403 account_banned`: locked entry + "Back to login"),
/// in AR (RTL) + EN (LTR).
class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key, required this.args});

  final OtpArgs args;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();
  String _pin = '';

  /// Set by the first exit from the success view; see [_continueToApp].
  bool _leavingSuccessView = false;

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _verify() {
    // Guard the auto-submit path too (button is disabled when offline).
    if (ref.read(isOnlineProvider).value == false) return;
    // …and when banned: the code was consumed and the contract says do not
    // retry. The cells are disabled then, but that does not stop `onCompleted`
    // (pinput 6.0.2 fires it on any controller text change, enabled or not), so
    // this guard is what keeps every path to `verify` shut; the notifier refuses
    // too.
    if (ref.read(otpProvider(widget.args)).isBanned) return;
    FocusScope.of(context).unfocus();
    ref.read(otpProvider(widget.args).notifier).verify(_pin);
  }

  /// Leaves the sign-in success view for the app: the remembered location a
  /// signed-out bounce left (once) — only if the student who just signed in is
  /// the one whose session ended (matched by the server's student id) — else
  /// Home. An outcome without an id fails closed to Home too.
  ///
  /// The success view has two ways out and they are this one: its Continue and
  /// the OS Back. Back must not be a third — it would pop to a Login form with
  /// a live session behind it.
  ///
  /// It runs ONCE. Two exits in the same frame (Continue and Back, or the same
  /// one twice - a janky handset delivers both before the first navigation has
  /// been built) would each consume the return target, and the second consume
  /// finds it spent and answers Home, overriding the remembered place the
  /// first one went to.
  void _continueToApp() {
    if (_leavingSuccessView) return;
    _leavingSuccessView = true;
    context.go(
      ref
          .read(returnTargetProvider)
          .consume(
            studentId: switch (ref.read(otpProvider(widget.args)).outcome) {
              AuthenticatedOutcome(:final studentId) => studentId,
              _ => null,
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(otpProvider(widget.args));
    // Distinct offline STATE: only when connectivity is definitively down
    // (null = unknown/first frame → treated as online, don't block).
    final offline = ref.watch(isOnlineProvider).value == false;

    // registrationRequired navigates away immediately (no success screen);
    // navigation can't happen during build, so it goes through this listener.
    ref.listen(otpProvider(widget.args), (prev, next) {
      final outcome = next.outcome;
      if (outcome is RegistrationRequiredOutcome) {
        // The registration wizard's seed: the token, its TTL, and the proven
        // phone (shown read-only on Sign Up_1; never re-submitted).
        final args = RegistrationArgs(
          registrationToken: outcome.registrationToken,
          expiresInSeconds: outcome.expiresInSeconds,
          phone: widget.args.phone,
        );
        // Seed HERE, not in SignupIdentityScreen.initState. A ref.listen
        // callback runs outside the build phase, so mutating a provider is
        // legal; initState is part of element mount, and Riverpod asserts on
        // it — which red-screened the whole wizard (BUG-001).
        ref.read(registrationControllerProvider.notifier).start(args);
        context.go('/register', extra: args);
      }
    });

    final succeeded = state.outcome is AuthenticatedOutcome;

    return Scaffold(
      // No AppBar at all now. It used to be `succeeded ? null : AppBar()`,
      // which made OTP the only screen in the app wearing Material's stock
      // back arrow while every other pushed screen wears the design's chevron
      // chip (`CircleBackButton`, Figma `90:208`). Same control, third
      // appearance. The affordance itself stays — a student who mistyped their
      // number needs a way back to Login — it is only the widget that changes.
      body: SafeArea(
        child: Column(
          children: [
            if (offline) const OfflineBanner(),
            // One header row, 24dp gutters to match `_InputView` below it.
            // The language pill sits top-end on BOTH views — the input frame
            // (`82:1254`) draws it exactly where the success frame (`155:809`)
            // does; the build used to show it only after success. The back
            // chip is the build's own addition (Figma draws none) and is
            // dropped after success: once tokens are stored, "back" to the OTP
            // input is meaningless.
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24, 8, 24, 0),
              child: Row(
                children: [
                  if (!succeeded)
                    CircleBackButton(onPressed: () => context.pop()),
                  const Spacer(),
                  LanguagePill(
                    label: l10n.switchLanguage,
                    onTap: () => ref.read(localeProvider.notifier).toggle(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: succeeded
                  ? _SuccessView(onContinue: _continueToApp)
                  : _InputView(
                      l10n: l10n,
                      state: state,
                      pinController: _pinController,
                      focusNode: _focusNode,
                      onChanged: (v) => setState(() => _pin = v),
                      onCompleted: (v) {
                        _pin = v;
                        _verify();
                      },
                      onVerify:
                          _pin.length == 6 && !state.isVerifying && !offline
                          ? _verify
                          : null,
                      // Resend is disabled while offline (null → button disabled).
                      onResend: offline
                          ? null
                          : () => ref
                                .read(otpProvider(widget.args).notifier)
                                .resend(),
                      // `account_banned`: the CTA becomes this. `go`, not
                      // `pop`, as registration's expired view does — it
                      // lands on Login whatever the stack was.
                      onBackToLogin: () => context.go('/login'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// The offline indicator is the shared `OfflineBanner` (core/widgets). This
// screen used to carry a private line-for-line copy of it (register SF-01).

class _InputView extends StatelessWidget {
  const _InputView({
    required this.l10n,
    required this.state,
    required this.pinController,
    required this.focusNode,
    required this.onChanged,
    required this.onCompleted,
    required this.onVerify,
    required this.onResend,
    required this.onBackToLogin,
  });

  final AppLocalizations l10n;
  final OtpUiState state;
  final TextEditingController pinController;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onCompleted;
  final VoidCallback? onVerify;
  final VoidCallback? onResend;

  /// The primary CTA while [OtpUiState.isBanned] — the existing "Back to login".
  final VoidCallback onBackToLogin;

  /// The card's own radius and auto-layout · `308:5114` / `337:19501`, read
  /// on the Properties panel 2026-09-20. Both canvases give the same four
  /// numbers, so there is one set here rather than a token per theme.
  static const _cardRadius = 19.0;
  static const _cardPadding = EdgeInsetsDirectional.fromSTEB(10, 15, 10, 15);

  /// The card's auto-layout gap — between the digit row and "Verify", which
  /// are its only two children. The build had 28 here, measured off a
  /// screenshot.
  static const _cardGap = 20.0;

  // The frame's text is TRIMMED to cap-height/baseline, so its gaps run from
  // glyph to glyph; Flutter's line boxes add leading above the caps and below
  // the baseline. The three gaps below are the frame's glyph-to-glyph values
  // translated into box-to-box ones, and each was set from the Wave 02 device
  // walk (Pixel 8, pixel rows of the screencap, measured from the language
  // pill's top so the status-bar difference cancels), not from font metrics:
  //
  //   pill top → title caps        frame 81.3 · device 58.3 at 8  → 31
  //   title baseline → subtitle    frame 15   · device 24.0 at 12 → 3
  //   subtitle baseline → card     frame 35   · device 41.2 at 35 → 28.8

  /// Header row to the title's box (on top of the scroll view's own 8).
  static const _gapHeaderToTitle = 31.0;

  /// Title box to subtitle box — the frame's 15 between trimmed glyphs.
  static const _gapTitleToSubtitle = 3.0;

  /// `Frame 1000002976`'s gap (`308:5109`) — subtitle block to card: 35
  /// between the trimmed subtitle and the card, 28.8 from the line box.
  static const _gapTitleToCard = 28.8;

  /// `Frame 1000002977`'s gap (`308:5108`) — card to the resend block. The
  /// build had 16.
  static const _gapCardToResend = 26.0;

  /// The `Type= wrong` variant (`82:1439` / `337:19284`): the digit row ends
  /// at 15 + 61.01 and the error line starts at 89. Its other side is the
  /// card's own 20 to "Verify" (the line ends ~101, Verify starts at 121).
  static const _gapDigitsToError = 13.0;

  /// The contract mandates six digits.
  static const _digitCount = 6;

  /// The gap between two cells before `spaceBetween` spreads the rest — the one
  /// pinput draws by default, stated here so [_digitRowWidth] does not lean on
  /// a package private.
  static const _digitGap = 8.0;

  /// The row's least width: six cells and the five gaps between them (328).
  static const _digitRowWidth =
      _digitCount * _DigitBox._width + (_digitCount - 1) * _digitGap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;

    // The mapped inline message: otp_invalid uses the "incorrect code" copy and
    // red boxes; other failures (expired/throttled/offline/generic) use the
    // same line without the red boxes.
    final hasError = state.error != null;

    // `403 account_banned` is terminal here: the code was correct but consumed,
    // and no session exists. Code entry and resend lock, the one error line
    // carries the contract's suggested copy, and "Back to login" takes the
    // Verify button's place — same widget, same style, nothing new on screen.
    // The designer's banned frame is item DG-03
    // (`.ai/audits/current/completion/03_DESIGNER_HANDOFF.md`); the Support
    // route a banned student would be sent to is Seif question SQ-12
    // (`02_SEIF_HANDOFF.md`). Until both land, this inline state is the screen.
    final banned = state.isBanned;

    // The frame's error line: Inter Medium 10 (`labelSmall`), start-aligned
    // under the digits, no icon (`82:1447`).
    Widget? errorLine;
    if (hasError) {
      final text = Text(
        authErrorMessage(l10n, state.error),
        textAlign: TextAlign.start,
        style: AppType.labelSmall.copyWith(color: ext.otpErrorText),
      );
      // Banned is a terminal answer that arrives with no other cue (the cells
      // just lock), so a screen reader is told when it appears. A plain
      // `Semantics` over the same Text: no visual change, and the other error
      // states are not wrapped at all.
      errorLine = banned ? Semantics(liveRegion: true, child: text) : text;
    }

    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 8, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: _gapHeaderToTitle),
          Text(
            l10n.checkOtpTitle,
            textAlign: TextAlign.center,
            style: AppType.h1.copyWith(color: ext.textPrimary),
          ),
          const SizedBox(height: _gapTitleToSubtitle),
          Text(
            l10n.otpSubtitle,
            textAlign: TextAlign.center,
            style: AppType.bodyLarge.copyWith(color: ext.textSecondary),
          ),
          const SizedBox(height: _gapTitleToCard),
          // ---------------------------------------------------------------
          // The code card · edit5 #31. It is 354 wide, which is exactly this
          // scroll view's content width, so it needs no width of its own.
          //
          // **"Verify" is INSIDE it**, and that is a reading, not a choice:
          // the variant `Type= correct` has exactly two children — the digit
          // row (`Frame 427319511`, 320 x 61.01) and the button
          // (`Component 8`, 334 x 60) — with gap 20 between them and the
          // card's own 15/10/15/10 padding around both. 15 + 61.01 + 20 + 60
          // + 15 is the card's hug height of 171.01 to the hundredth, which
          // is the arithmetic that proves the child list is complete.
          //
          // The error line DOES have a slot: both component sets carry a
          // `Type= wrong` variant (`82:1439` light, `337:19284` dark) that
          // puts it between the digits and the button. An earlier reading
          // said otherwise; corrected in docs/DESIGN_ISSUES.md #49.
          ElevatedSurface(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_cardRadius),
            ),
            padding: _cardPadding,
            color: ext.otpCardFill,
            // Light: black 0.2/0.2/4. Dark: the same offsets at blur 7.9 in
            // `rgba(174,135,231,0.25)` — the one drop shadow in the whole
            // file whose dark colour is not black, and the reason this card
            // elevates in dark with a glow instead of Glass.
            shadows: elevation.otpCardShadows,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // OTP boxes fill left-to-right regardless of UI locale.
                Directionality(
                  textDirection: TextDirection.ltr,
                  // The row is `_digitRowWidth` wide at its least, and the
                  // card has that much room only from a 396 dp screen up
                  // (docs/RESPONSIVE.md #8). With room to spare the row is
                  // exactly as wide as the card, as it always was (the cells
                  // spread with `spaceBetween`) and the scale is 1. Without
                  // it, the row keeps its least width and the whole row is
                  // scaled down to the card — never wider, so nothing spills.
                  // The tree is the same at every width, so the field keeps
                  // its state across a rotation.
                  child: LayoutBuilder(
                    builder: (context, constraints) => FittedBox(
                      fit: BoxFit.scaleDown,
                      child: SizedBox(
                        width: math.max(_digitRowWidth, constraints.maxWidth),
                        child: Pinput.builder(
                          length: _digitCount,
                          controller: pinController,
                          focusNode: focusNode,
                          autofocus: true,
                          // Banned: the cells stop taking input and the node
                          // gives up focus (pinput drops `canRequestFocus`
                          // with `enabled`).
                          enabled: !banned,
                          keyboardType: TextInputType.number,
                          forceErrorState: state.isInvalidCode,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          separatorBuilder: (_) =>
                              const SizedBox(width: _digitGap),
                          onChanged: onChanged,
                          onCompleted: onCompleted,
                          builder: (context, pin) => _DigitBox(state: pin),
                        ),
                      ),
                    ),
                  ),
                ),
                // The frame's error line (built above). Every failure uses
                // this one slot; only `otp_invalid` also turns the cells red.
                if (errorLine != null) ...[
                  const SizedBox(height: _gapDigitsToError),
                  errorLine,
                ],
                const SizedBox(height: _cardGap),
                PrimaryCta(
                  enabled: banned || onVerify != null,
                  child: FilledButton(
                    onPressed: banned ? onBackToLogin : onVerify,
                    child: banned
                        ? Text(l10n.backToLogin, style: AppType.buttonLarge)
                        : state.isVerifying
                        ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: cs.onPrimary,
                            ),
                          )
                        : Text(l10n.verify, style: AppType.buttonLarge),
                  ),
                ),
              ],
            ),
          ),
          // No resend once banned: a new code could not change the answer, and
          // the contract says do not retry.
          if (!banned) ...[
            const SizedBox(height: _gapCardToResend),
            _ResendRow(
              l10n: l10n,
              secondsRemaining: state.secondsRemaining,
              isResending: state.isResending,
              onResend: onResend,
            ),
          ],
        ],
      ),
    );
  }
}

/// One OTP cell · edit5 #52, Figma `Rectangle 104`-`107` light and
/// `I337:19501;337:19276`-`...19279` dark.
///
/// **Why a builder and not a `PinTheme`.** `PinTheme` carries a
/// `BoxDecoration`, and a `BoxDecoration` cannot express the dark canvas's
/// G19 — frost, refraction, dispersion and splay are painted by
/// `ElevatedSurface`, not by a border and a fill. `Pinput.builder` hands the
/// cell over whole, which is the only way this surface gets built once instead
/// of twice.
///
/// **The geometry stays the build's**: 6 boxes at 48 x 56 / r16, where Figma
/// draws 4 at 66 x 61.01 / r11.73. The contract mandates six digits
/// (docs/DESIGN_ISSUES.md #5), and six boxes at the frame's width do not fit a
/// 334-wide card. Only the SURFACE follows Figma.
class _DigitBox extends StatelessWidget {
  const _DigitBox({required this.state});

  final PinItemState state;

  static const _width = 48.0;
  static const _height = 56.0;
  static const _radius = 16.0;

  /// The focused stroke — the app's own; Figma draws no focused cell.
  static const _focusedBorderWidth = 1.5;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;

    final (Color fill, Color border, double borderWidth) = switch (state.type) {
      // `Type= wrong` (`82:1439` / `337:19284`): the resting fill and width,
      // only the stroke turns red.
      PinItemStateType.error => (
        ext.otpDigitFill,
        ext.otpDigitErrorBorder,
        elevation.otpDigitBorderWidth,
      ),
      PinItemStateType.focused => (
        ext.otpDigitFill,
        cs.primary,
        _focusedBorderWidth,
      ),
      // `disabled` is the banned lock (`account_banned`: the field is
      // disabled, see `_InputView`) and keeps the resting look, as do
      // `submitted` / `following` / `initial`.
      _ => (
        ext.otpDigitFill,
        ext.otpDigitBorder,
        elevation.otpDigitBorderWidth,
      ),
    };

    final textStyle = AppType.h2.copyWith(color: ext.textPrimary);

    return ElevatedSurface(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radius),
      ),
      width: _width,
      height: _height,
      // Dark is `#232428` at 20%, so the cell composites over the card rather
      // than over its own fill - which is what makes the Glass rim read.
      color: fill,
      side: BorderSide(color: border, width: borderWidth),
      glass: elevation.otpDigitGlass,
      child: Center(child: Text(state.value, style: textStyle)),
    );
  }
}

/// The resend block · Figma `82:1328` → Frame `427319517` (161 × hug, vertical,
/// gap 20). While the countdown runs it stacks the timer pill over the
/// "Resend OTP" label exactly as the frame does; at zero only the label is
/// left, now tappable. Resending itself shows a spinner in place of both.
class _ResendRow extends StatelessWidget {
  const _ResendRow({
    required this.l10n,
    required this.secondsRemaining,
    required this.isResending,
    required this.onResend,
  });

  final AppLocalizations l10n;
  final int secondsRemaining;
  final bool isResending;
  final VoidCallback? onResend;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (isResending) {
      return Center(
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 2.5, color: cs.primary),
        ),
      );
    }
    final counting = secondsRemaining > 0;

    // The label is drawn in full colour even while counting — the frame shows
    // it that way under the pill — but `onPressed` is null until zero, which is
    // what keeps the notifier's `canResend` rule honest. The explicit colour on
    // the Text is what stops Material greying a disabled button.
    final label = TextButton(
      onPressed: counting ? null : onResend,
      child: Text(
        l10n.resendOtp,
        style: AppType.buttonMedium.copyWith(color: cs.primary),
      ),
    );
    if (!counting) return Center(child: label);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ResendTimerPill(l10n: l10n, secondsRemaining: secondsRemaining),
        const SizedBox(height: _ResendTimerPill.gapBelow),
        label,
      ],
    );
  }
}

/// The countdown pill · Figma `Item / Timer` in `Frame 1000002977`
/// (`332:3390`): light `332:3391`, dark `337:19503`.
///
/// A stadium holding a stroke-drawn stopwatch and the remaining time as
/// `mm.ss`. The frame really does separate with a DOT ("00.21"); that is built
/// verbatim and flagged (docs/DESIGN_ISSUES.md #49) rather than silently
/// "corrected" to a colon.
///
/// **The geometry and the bevel are now READ, and both moved.** The height was
/// 36 and the horizontal padding 14, measured off a 100%-zoom screenshot
/// because the connector was on a view-only seat; the panel gives **42** and
/// **15**. The shadow was an OUTER black borrowed from the five card frames;
/// both canvases draw an **inset** bevel instead, and they agree on nothing
/// about it — light is black 25% from directly above at blur 4, dark is a pale
/// `rgba(198,198,198,0.25)` from the start-bottom at blur 1.2. Those live in
/// `AppElevation.otpTimerInsetShadows`; an inner shadow is a real inset here
/// (edit1.md R7), not a second surface drawn on top.
///
/// **Content colour, read 2026-09-24:** glyph and digits share
/// [AppColors.otpTimerContent] — `#384F47` in `82:1316`, `#FCFBF9` in
/// `337:19503` (the dark glyph export is stroked cream too). They used to take
/// `colorScheme.primary` (lavender in dark) and `textSecondary`. The digits are
/// Medium 12 = `AppType.labelMedium`. The 15×19 glyph box is read, not
/// measured.
class _ResendTimerPill extends StatelessWidget {
  const _ResendTimerPill({required this.l10n, required this.secondsRemaining});

  final AppLocalizations l10n;
  final int secondsRemaining;

  /// Frame 427319517's vertical gap to "Resend OTP".
  static const gapBelow = 20.0;

  static const _height = 42.0;
  static const _inset = 15.0;
  static const _gap = 8.0;

  /// The export's own viewBox (`assets/icons/stopwatch.svg` is 15×19). Drawn
  /// at native size rather than squeezed into a square, the way
  /// `CircleBackButton` treats its 15×30 chevron.
  static const _iconWidth = 15.0;
  static const _iconHeight = 19.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;
    final minutes = (secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsRemaining % 60).toString().padLeft(2, '0');

    return Semantics(
      // A screen reader gets the sentence, not "zero zero dot two one".
      label: l10n.resendIn(secondsRemaining),
      excludeSemantics: true,
      child: ElevatedSurface(
        // r100 in the frame on a 42-high pill: a stadium at any width, which
        // is what the shape says without carrying a number that stops being
        // true if the copy grows.
        shape: const StadiumBorder(),
        height: _height,
        padding: const EdgeInsetsDirectional.symmetric(horizontal: _inset),
        color: ext.otpTimerFill,
        shadows: elevation.otpTimerInsetShadows,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // The designer's export of the icon layer in Frame 427319517 — a
            // STROKE-drawn stopwatch at 1.6 with round caps. The file carries
            // the stroke as a literal `#384F47`; it is tinted here anyway so the
            // dark canvas gets the frame's cream (`app_colors_test.dart` pins
            // the literal to the token's light value).
            SvgPicture.asset(
              'assets/icons/stopwatch.svg',
              width: _iconWidth,
              height: _iconHeight,
              colorFilter: ColorFilter.mode(
                ext.otpTimerContent,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: _gap),
            Text(
              l10n.resendTimer(minutes, seconds),
              style: AppType.labelMedium.copyWith(color: ext.otpTimerContent),
            ),
          ],
        ),
      ),
    );
  }
}

// The blinking caret that used to sit in the active cell is GONE, and it is
// not an oversight. `Pinput.builder` hard-codes `showCursor = false` and
// `cursor = null` (pinput 6.0.2, `pinput.dart:176`), so the move off
// `PinTheme` - which the dark canvas's G19 forces, because a `BoxDecoration`
// cannot express frost, refraction or splay - takes the caret with it.
// Drawing it back means a `Text('|')`, and the hardcoded-copy guard counts
// that literal: baseline 4 -> 5 on a ratchet RISKS.md R-7 freezes at "may
// fall further, never rise". Owner's call, 2026-09-20: keep the guard.
//
// What is left in its place is not nothing - the active cell still carries
// the 1.5 `colorScheme.primary` border, so "where am I typing" is still
// answered. Recorded in docs/DESIGN_ISSUES.md #49.

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.onContinue});
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    return PopScope(
      // Once the tokens are stored there is no "back": the chip is gone from
      // this view for that reason, and the OS Back must agree with it rather
      // than pop to the Login form (the signed-in redirect off `/login` only
      // runs on a navigation, not on a pop). It does what Continue does.
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) onContinue();
      },
      // Scrolls like `_InputView` when it is taller than the viewport (a phone
      // on its side; the largest text on a short screen). Continue sits at the
      // bottom of the column, and a Column that overflows is not hit-testable
      // past its own bounds, so without this the one way forward could be
      // drawn and still not answer a tap. When it fits, nothing scrolls and
      // the block is centred exactly as before.
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              // Figma puts this block at x17.5/w363 of 402; built at 20, the
              // app-wide horizontal padding.
              padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 24),
              child: Column(
                // The frame top-anchors the block at y245 of 878 (28%), which
                // reads as optically centred now that the AppBar is gone.
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _SuccessBadge(),
                  const SizedBox(height: 18),
                  Text(
                    l10n.otpSuccessTitle,
                    textAlign: TextAlign.center,
                    style: AppType.h1.copyWith(color: ext.textPrimary),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l10n.otpSuccessSubtitle,
                    textAlign: TextAlign.center,
                    style: AppType.bodyLarge.copyWith(color: ext.bodyMuted),
                  ),
                  // `332:3400`: gap 60 after a fixed 267-high group whose text
                  // block ends at 252, so the subtitle sits 75 above Continue,
                  // not 60.
                  const SizedBox(height: 75),
                  // edit5 §7.11a. Always enabled: the only way onto this view
                  // is a stored session, so there is no state in which
                  // "Continue" is dead.
                  PrimaryCta(
                    child: FilledButton(
                      onPressed: onContinue,
                      child: Text(
                        l10n.continueLabel,
                        style: AppType.buttonLarge,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The scalloped emerald check · Figma `82:1598`.
///
/// Carries its own emerald — `#22C55E`, the value `AppColors.successBadge`
/// records — and is deliberately NOT tinted at the call site.
///
/// The brief asks for the badge to be tinted with the token instead of
/// `colorScheme.primary`, and the *intent* (a success signal must not follow the
/// green→purple accent flip, which is why it used to render purple in dark) is
/// exactly right. But a `ColorFilter` is single-channel: the badge is two
/// colours — an emerald scallop and a WHITE checkmark — so any `srcIn` tint
/// flattens the check into the fill and leaves a green blob. The asset already
/// holds the correct colours, so it renders unfiltered, and
/// `otp_success_badge_test.dart` asserts the SVG's fill still equals the token
/// in both palettes — which catches a re-export drifting away from it.
///
/// **Sized 152×148, not the design's 144×140, and that is correct.** Figma's
/// export pads the canvas by the drop shadow's bleed (the frame's own
/// `inset[-1.79% -4.17% -3.93% -1.39%]` = 8dp on each axis), so the scalloped
/// shape lands at exactly 144×140 inside a 152×148 box. Sizing the box to
/// 144×140 would shrink the badge itself to ~136×132.
class _SuccessBadge extends StatelessWidget {
  const _SuccessBadge();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        'assets/images/success_badge.svg',
        width: 152,
        height: 148,
        semanticsLabel: AppLocalizations.of(context).otpSuccessTitle,
      ),
    );
  }
}
