import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

/// The two avatar sheets from the Edit Profile frame family (`180:3989` and its
/// sibling variants): an action sheet that asks HOW, then the picker itself.
///
/// Both wear the frame's sheet chrome (`180:4153`) — a `#FCFBF9` card with a
/// 22pt radius, a centred title and a ✕ at the start edge.

/// What [AvatarActionSheet] resolved to. Only one arm is reachable today.
enum AvatarAction {
  /// Pick from `GET /reference/avatars`.
  useDefault,
}

/// Shared chrome for both sheets · Figma `180:4153`.
class _SheetCard extends StatelessWidget {
  const _SheetCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          // OPAQUE, like the dialog: `Frame 1000003004` / `Frame 427319513`
          // are `#FCFBF9` / `#232428`. `cardFill` is 20% in dark and made the
          // panel see-through.
          color: ext.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        ),
        padding: const EdgeInsetsDirectional.fromSTEB(21, 30, 21, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 35,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    // One line, like `TitledChrome` (register SF-08).
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppType.h2.copyWith(color: ext.textPrimary),
                  ),
                  PositionedDirectional(
                    start: 0,
                    child: IconButton(
                      key: const Key('avatar_sheet_dismiss'),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints.tightFor(
                        width: 35,
                        height: 35,
                      ),
                      tooltip: l10n.dialogClose,
                      // Pops NOTHING — the sheet resolves to null, which every
                      // caller reads as "the student changed their mind".
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close, size: 23, color: ext.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            child,
          ],
        ),
      ),
    );
  }
}

/// "How would you like to change your picture?" — the frame's avatar action
/// sheet, with one of its two options permanently unavailable.
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

    return _SheetCard(
      title: l10n.changeAvatarTitle,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // TODO(contract): seif_fight.md S29 — `PUT /me/avatar` is
          // `x-stability: draft` AND moderated (adr-021: SafeSearch, so an
          // upload is not even synchronously "set"). There is no endpoint to
          // call and no defined UX for a rejected image, so the option renders
          // and does not work.
          _SheetRow(
            key: const Key('avatar_upload_photo'),
            icon: Icons.photo_camera_outlined,
            label: l10n.uploadPhoto,
            disabledHint: l10n.uploadPhotoUnavailable,
          ),
          const SizedBox(height: 12),
          _SheetRow(
            key: const Key('avatar_use_default'),
            icon: Icons.face_outlined,
            label: l10n.useAvatar,
            onTap: () => Navigator.of(context).pop(AvatarAction.useDefault),
          ),
          const SizedBox(height: 12),
          // Said out loud, not just implied by the dimming — the student is
          // owed a reason a drawn option does nothing.
          Text(
            l10n.uploadPhotoUnavailable,
            textAlign: TextAlign.center,
            style: AppType.captionRegular.copyWith(
              color: Theme.of(context).extension<AppColors>()!.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// One action row. Same enabled/disabled contract as `ProfileMenuRow`: a null
/// [onTap] produces a row with no [InkWell] in its subtree at all, wrapped in
/// an [IgnorePointer] — not a live tap target with a dead callback.
class _SheetRow extends StatelessWidget {
  const _SheetRow({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.disabledHint,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final String? disabledHint;

  /// Shared with the Profile menu rows so "disabled" looks identical wherever
  /// it appears.
  static const disabledOpacity = 0.45;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;

    final row = Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: ext.profileRowBorder, width: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 26, color: ext.textPrimary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: AppType.h3.copyWith(color: ext.textPrimary),
            ),
          ),
        ],
      ),
    );

    if (onTap == null) {
      return Semantics(
        button: true,
        enabled: false,
        hint: disabledHint,
        child: IgnorePointer(
          child: Opacity(opacity: disabledOpacity, child: row),
        ),
      );
    }

    return Semantics(
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: row,
        ),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;
    final avatars = ref.watch(avatarsProvider);

    return _SheetCard(
      title: l10n.chooseAvatarTitle,
      child: SizedBox(
        height: _size,
        child: avatars.when(
          loading: () => const Center(child: CircularProgressIndicator()),
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
          error: (error, _) => _SheetFailure(
            message: isOffline(error) ? l10n.offline : l10n.genericError,
            onRetry: () => ref.invalidate(avatarsProvider),
          ),
          data: (items) => items.isEmpty
              // An empty list is not a failure the student can retry away —
              // the server answered, with nothing. Left as it was.
              ? Center(
                  child: Text(
                    l10n.genericError,
                    style: AppType.bodyMedium.copyWith(
                      color: ext.textSecondary,
                    ),
                  ),
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
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
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: selected ? Border.all(color: cs.primary, width: 2.5) : null,
          ),
          child: ClipOval(
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
