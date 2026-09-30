import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/app_modal.dart';
import '../../../l10n/app_localizations.dart';
// CROSS-FEATURE IMPORT, and deliberate: `avatarsProvider` is
// `GET /reference/avatars`, a single reference list that registration and Edit
// Profile both pick from. It lives under registration/ only because Day 2 built
// the wizard first. A second copy here would be two caches of one endpoint and
// a guaranteed drift — the brief's "reuse before building" rule names this
// picker explicitly.
import '../../registration/models/reference_models.dart';
import '../../registration/notifier/reference_providers.dart';
import 'avatar_disc.dart';

/// The two avatar sheets from the Edit Profile frame family: an action sheet
/// that asks HOW (`216:3341`), then the picker itself (`180:4153`).
///
/// Both are a `#FCFBF9` / `#232428` card with a 22pt top radius. The picker
/// has a centred title and a ✕ at the start edge; the action sheet has neither,
/// only a drag handle over two plain rows (API→UI Wave 20).

/// What [AvatarActionSheet] resolved to. Only one arm is reachable today.
enum AvatarAction {
  /// Pick from `GET /reference/avatars`.
  useDefault,
}

/// The sheets' card: OPAQUE, like the dialog (`Frame 1000003004` /
/// `Frame 427319513` are `#FCFBF9` / `#232428`; `cardFill` is 20% in dark and
/// made the panel see-through), 22 at the top corners.
BoxDecoration _cardDecoration(AppColors ext) => BoxDecoration(
  color: ext.background,
  borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
);

/// The picker's chrome · Figma `180:4153`: a 35 dp title bar 30 under the
/// card's top, its content 24 under the bar, starting 21 in.
///
/// The ✕ is the frame's own `akar-icons:cross` (`180:4247`, 23 x 23, 27 from
/// the card's start) in [AppColors.profileDialogClose], with a 48 x 48 target
/// centred on it, as on the Profile dialogs (W19-3). The 48 dp row that target
/// needs is centred on the frame's bar: 23.5 = 30 − (48 − 35) / 2 above it and
/// 17.5 = 24 − 6.5 under it. It was `Icons.close` in [AppColors.textPrimary]
/// with a 35 x 35 target; API→UI Wave 20.
class _SheetCard extends StatelessWidget {
  const _SheetCard({required this.title, required this.child});

  final String title;

  /// Full width: [ChooseAvatarSheet]'s strip insets itself, so it can run to
  /// the card's edge the way the frame's does.
  final Widget child;

  /// The ✕ box's start (27) minus half of what the 48 target adds to it.
  static const _closeStart = 27 - (48 - 23) / 2;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    return SafeArea(
      top: false,
      child: Container(
        decoration: _cardDecoration(ext),
        padding: const EdgeInsetsDirectional.only(top: 23.5, bottom: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 48,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Padding(
                    // Clear of the ✕'s whole target on both sides, so a long
                    // title never runs under it (register SF-08).
                    padding: const EdgeInsets.symmetric(
                      horizontal: _closeStart + 48,
                    ),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      // One line, like `TitledChrome` (register SF-08).
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppType.h2.copyWith(color: ext.textPrimary),
                    ),
                  ),
                  PositionedDirectional(
                    start: _closeStart,
                    child: IconButton(
                      key: const Key('avatar_sheet_dismiss'),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints.tightFor(
                        width: 48,
                        height: 48,
                      ),
                      tooltip: l10n.dialogClose,
                      // Pops NOTHING — the sheet resolves to null, which every
                      // caller reads as "the student changed their mind".
                      onPressed: () => Navigator.of(context).pop(),
                      icon: SvgPicture.asset(
                        'assets/icons/close_cross.svg',
                        width: 23,
                        height: 23,
                        // The tooltip names the button; the glyph's own image
                        // semantics would make it an ImageView (W11-7).
                        excludeFromSemantics: true,
                        colorFilter: ColorFilter.mode(
                          ext.profileDialogClose,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 17.5),
            child,
          ],
        ),
      ),
    );
  }
}

/// "How would you like to change your picture?" — the frame's avatar action
/// sheet (`216:3341`), with one of its two options permanently unavailable.
///
/// The frame draws a drag handle and two plain, full-width rows with one
/// hairline between them: no title, no ✕, no icons, no row borders (API→UI
/// Wave 20; it used to wear the picker's title-and-✕ chrome and bordered icon
/// rows). The one addition is the caption under the rows saying why Upload
/// photo does nothing (owner ruling, `DESIGN_ISSUES.md` #106). Dismissed by the
/// scrim, a drag or Back, like any modal sheet.
///
/// Resolves to an [AvatarAction], or null if dismissed.
class AvatarActionSheet extends StatelessWidget {
  const AvatarActionSheet({super.key});

  static Future<AvatarAction?> show(BuildContext context) {
    return showAppModalSheet<AvatarAction>(
      context: context,
      scrim: Theme.of(
        context,
      ).extension<AppElevation>()!.avatarActionSheetScrim,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AvatarActionSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    return SafeArea(
      top: false,
      child: Container(
        decoration: _cardDecoration(ext),
        // `216:3341`: the handle 15 under the card's top; the last row ends
        // 25 above the frame's bottom edge.
        padding: const EdgeInsetsDirectional.only(top: 15, bottom: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // `Rectangle 6428`: 94 x 4, fully rounded, centred. Decoration
            // only — the sheet drags without it.
            Center(
              child: ExcludeSemantics(
                child: Container(
                  key: const Key('avatar_sheet_handle'),
                  width: 94,
                  height: 4,
                  decoration: BoxDecoration(
                    color: ext.avatarSheetHandle,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            // The first row starts at 39: 20 under the handle.
            const SizedBox(height: 20),
            // TODO(contract): seif_fight.md S29 — `PUT /me/avatar` is
            // `x-stability: draft` AND moderated (adr-021: SafeSearch, so an
            // upload is not even synchronously "set"). There is no endpoint to
            // call and no defined UX for a rejected image, so the option renders
            // and does not work.
            _SheetRow(
              key: const Key('avatar_upload_photo'),
              label: l10n.uploadPhoto,
              disabledHint: l10n.uploadPhotoUnavailable,
              // The frame's only line: under the first row (`216:3343`).
              divider: true,
            ),
            // 83 → 96 in the frame.
            const SizedBox(height: 13),
            _SheetRow(
              key: const Key('avatar_use_default'),
              label: l10n.useAvatar,
              onTap: () => Navigator.of(context).pop(AvatarAction.useDefault),
            ),
            const SizedBox(height: 12),
            // Said out loud, not just implied by the dimming — the student is
            // owed a reason a drawn option does nothing (owner ruling, #106).
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                l10n.uploadPhotoUnavailable,
                key: const Key('avatar_upload_unavailable_note'),
                textAlign: TextAlign.center,
                style: AppType.captionRegular.copyWith(
                  color: ext.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One action row · Figma `216:3343` / `216:3345`: full width, the label 20 in
/// and 10 over and under (44 tall), no icon, no border. Same enabled/disabled
/// contract as `ProfileMenuRow`: a null [onTap] produces a row with no
/// [InkWell] in its subtree at all, wrapped in an [IgnorePointer] — not a live
/// tap target with a dead callback.
///
/// The frame sets the labels in Inter Medium 20; the build keeps the type
/// scale's `h3` (18 / 600, the same 24 line), as the Profile menu rows do
/// (#104).
class _SheetRow extends StatelessWidget {
  const _SheetRow({
    super.key,
    required this.label,
    this.onTap,
    this.disabledHint,
    this.divider = false,
  });

  final String label;
  final VoidCallback? onTap;
  final String? disabledHint;

  /// The 0.5 dp hairline along the row's bottom edge, inside its 44.
  final bool divider;

  /// Shared with the Profile menu rows so "disabled" looks identical wherever
  /// it appears.
  static const disabledOpacity = 0.45;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;

    final label = Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: Text(
        this.label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppType.h3.copyWith(color: ext.textPrimary),
      ),
    );

    // The hairline stays at full strength under a dimmed row: it separates
    // the two rows, it is not part of the unavailable one.
    Widget withDivider(Widget child) => DecoratedBox(
      key: divider ? const Key('avatar_sheet_divider') : null,
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        border: divider
            ? Border(
                bottom: BorderSide(color: ext.avatarSheetDivider, width: 0.5),
              )
            : null,
      ),
      child: child,
    );

    if (onTap == null) {
      return Semantics(
        button: true,
        enabled: false,
        hint: disabledHint,
        child: IgnorePointer(
          child: withDivider(Opacity(opacity: disabledOpacity, child: label)),
        ),
      );
    }

    return Semantics(
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(onTap: onTap, child: withDivider(label)),
      ),
    );
  }
}

/// "Choose Avatar" · Figma `180:4153` — the default-avatar picker, fed by the
/// EXISTING [avatarsProvider] (`GET /reference/avatars`).
///
/// Resolves to the picked [Avatar], or null if dismissed.
class ChooseAvatarSheet extends ConsumerWidget {
  const ChooseAvatarSheet({super.key, this.selectedId});

  /// The id currently on the account (or already picked this session), so the
  /// student can see which one is theirs.
  final String? selectedId;

  static Future<Avatar?> show(BuildContext context, {String? selectedId}) {
    // Its own sigma (13.4) rather than the action sheet's (14.7): two frames,
    // two readings, not one value reused.
    return showAppModalSheet<Avatar>(
      context: context,
      scrim: Theme.of(
        context,
      ).extension<AppElevation>()!.chooseAvatarSheetScrim,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChooseAvatarSheet(selectedId: selectedId),
    );
  }

  static const _size = 69.0;

  /// The strip's start inset (`180:4284` at 21).
  static const _inset = 21.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;
    final avatars = ref.watch(avatarsProvider);

    // The strip starts 21 in and runs to the card's edge, cut there the way
    // the frame's 409-wide row is (`180:4284`); the non-data states keep the
    // 21 on both sides.
    Widget inset(Widget child) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: _inset),
      child: child,
    );

    return _SheetCard(
      title: l10n.chooseAvatarTitle,
      child: SizedBox(
        height: _size,
        child: avatars.when(
          loading: () =>
              inset(const Center(child: CircularProgressIndicator())),
          // `avatarsProvider` is a plain, non-autoDispose `FutureProvider`,
          // deliberately OUTSIDE the session scope (global reference data,
          // identical for every student — see
          // `session_scope_discipline_test.dart`). Nothing invalidates it, and
          // this sheet was its only consumer with no way to ask again.
          //
          // What was actually happening before is worth stating exactly,
          // because it was not what it looked like: the provider inherited
          // Riverpod 3's automatic exponential-backoff retry, so a failing
          // `getAvatars` was called 7 times in ~15 s off one sheet open and
          // kept going — a silent network loop behind a modal, with no
          // deterministic way for the student to recover. `avatarsProvider`
          // now sets `retry: _noRetry` like every notifier in the app, which
          // makes the failure stick, and this button is what clears it. Not
          // every provider does: the six sibling `/reference/*` providers still
          // carry the automatic retry — see `reference_providers.dart`.
          //
          // A user-tapped `ref.invalidate` — the same recovery every reference
          // picker in the registration wizard already uses. The project rule is
          // that retry is a button, never silent.
          error: (error, _) => inset(
            _SheetFailure(
              message: isOffline(error) ? l10n.offline : l10n.genericError,
              onRetry: () => ref.invalidate(avatarsProvider),
            ),
          ),
          data: (items) => items.isEmpty
              // An empty list is not a failure the student can retry away —
              // the server answered, with nothing. Left as it was.
              ? inset(
                  Center(
                    child: Text(
                      l10n.genericError,
                      style: AppType.bodyMedium.copyWith(
                        color: ext.textSecondary,
                      ),
                    ),
                  ),
                )
              : ListView.separated(
                  key: const Key('avatar_choice_strip'),
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: _inset),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 16),
                  itemBuilder: (_, i) => _AvatarChoice(
                    avatar: items[i],
                    selected: items[i].id == selectedId,
                    onTap: () => Navigator.of(context).pop(items[i]),
                  ),
                ),
        ),
      ),
    );
  }
}

/// A failed avatar load, inside the sheet's own row height.
///
/// Laid out horizontally because the slot is a fixed 69 dp strip — a stacked
/// message-over-button would not fit, and growing the sheet to make room would
/// change a measured frame.
class _SheetFailure extends StatelessWidget {
  const _SheetFailure({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: AppType.bodyMedium.copyWith(color: ext.textSecondary),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            key: const Key('avatar_sheet_retry'),
            onPressed: onRetry,
            child: Text(l10n.retry),
          ),
        ],
      ),
    );
  }
}

class _AvatarChoice extends StatelessWidget {
  const _AvatarChoice({
    required this.avatar,
    required this.selected,
    required this.onTap,
  });

  final Avatar avatar;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        key: Key('avatar_choice_${avatar.id}'),
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: ChooseAvatarSheet._size,
          height: ChooseAvatarSheet._size,
          // The ring is the build's, not the frame's (its five cells are
          // identical): the student has to see which avatar is theirs.
          foregroundDecoration: BoxDecoration(
            shape: BoxShape.circle,
            border: selected ? Border.all(color: cs.primary, width: 2.5) : null,
          ),
          // Every cell is the frame's gradient disc (`180:4277`…).
          child: AvatarDisc(
            size: ChooseAvatarSheet._size,
            child: CachedNetworkImage(
              imageUrl: avatar.url,
              fit: BoxFit.cover,
              // See home_header.dart. This is the worst of the five sites: a
              // GRID of avatars, so every full-resolution decode is multiplied
              // by however many the sheet shows at once.
              memCacheWidth:
                  (ChooseAvatarSheet._size *
                          MediaQuery.devicePixelRatioOf(context))
                      .round(),
              placeholder: (_, _) => Container(color: ext.progressTrack),
              errorWidget: (_, _, _) => Container(
                color: ext.progressTrack,
                child: Icon(Icons.person, color: ext.mutedText),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
