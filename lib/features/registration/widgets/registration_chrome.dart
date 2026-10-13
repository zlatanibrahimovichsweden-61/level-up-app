import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/circle_back_button.dart';
import '../../../core/widgets/language_pill.dart';
import '../../../l10n/app_localizations.dart';

/// The chrome both track-detail frames share (`337:5269`, `337:10373`).

/// Back chip + language pill, matching the frames' top row.
///
/// The chip is the shared [CircleBackButton] (Figma `90:208`) that the rest of
/// the wizard uses, not Material's platform arrow — the two were mixed across
/// the four registration screens, so the same control had two appearances one
/// step apart. It mirrors under RTL on its own.
///
/// **The back target is 48 (O-15), the chip stays 35.** The chip sits in a
/// [CircleBackButton.tapTarget] box flush to the START of the row, so the extra
/// reaches into the free space before the pill and not past the page gutter.
/// The row is therefore 48 tall rather than the pill's 36.10, and the pill is
/// centred in it. A screen that places the header takes [slop] off the inset
/// above it and off the gap below it, which puts the chip, the pill and
/// everything under them on the pixels the frame draws.
class RegistrationHeader extends ConsumerWidget {
  const RegistrationHeader({super.key});

  /// Half of how much taller the row is than the pill it was drawn around:
  /// (48 - 36.10) / 2. Each screen gives this back above and below the row.
  static const double slop =
      (CircleBackButton.tapTarget - LanguagePill.height) / 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        CircleBackButton(
          onPressed: () => context.pop(),
          variant: BackChipVariant.registration,
          tapTargetSize: MaterialTapTargetSize.padded,
          chipAlignment: AlignmentDirectional.centerStart,
        ),
        const Spacer(),
        LanguagePill(
          label: l10n.switchLanguage,
          onTap: () => ref.read(localeProvider.notifier).toggle(),
        ),
      ],
    );
  }
}

/// A submit failure that is NOT per-field and does NOT restart registration —
/// offline, a 5xx, or an unmapped code. Per-field failures render under their
/// own field instead; token/phone failures navigate away.
class SubmitFailureBanner extends StatelessWidget {
  const SubmitFailureBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 16),
      child: Row(
        children: [
          Icon(Icons.error_outline, size: 20, color: cs.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: AppType.bodyMedium.copyWith(color: cs.error),
            ),
          ),
        ],
      ),
    );
  }
}
