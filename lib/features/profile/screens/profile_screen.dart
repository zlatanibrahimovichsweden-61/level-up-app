import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/screen_state.dart';
import '../../../core/network/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../core/widgets/state_widget.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/notifier/auth_controller.dart';
import '../models/student_profile.dart';
import '../notifier/me_notifier.dart';
import '../widgets/profile_confirm_dialog.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_menu_row.dart';
import '../widgets/profile_stat_card.dart';

/// Profile · Figma `166:4416`. The Account tab's root, and ONE screen for both
/// tracks — the University Student Flow draws the identical hub, exactly as it
/// did for Home and the quiz.
///
/// **This screen consumes no endpoint of its own.** It reads the existing
/// [meProvider] (`GET /me`), which Home already populated; switching to the
/// Account tab must not cost a second request, which is why the notifier is
/// non-autoDispose and why nothing here calls the repository directly.
///
/// ## What the frame draws and this screen does not
///
/// The Account cluster was designed as a finished product. Most of it has no
/// contract, and the honest response is to render the shape and disable it
/// rather than hide it behind a placeholder:
///
/// - **Solved Questions** is omitted outright. `StudentProfile` has no
///   answered/solved counter and `SubjectTree`'s per-node counts are per
///   subject, not a lifetime figure. Summing them client-side would invent a
///   number — `seif_fight.md` **S24**.
/// - **Rank "HERO"** is omitted for the same reason: the contract has `level`
///   (int) and `badges` (int), no tier string, and `GET /leaderboard/me` is
///   draft — **S25**. A card showing "—" was the alternative and is worse; it
///   invites someone to fill it in with a guess.
/// - **Points** is real, and is `points.total` printed verbatim.
///
/// States: loading (a skeleton shaped like the real content) · error (retry
/// re-calls `/me` on tap, never silently) · offline (its own view, plus a
/// pinned banner when connectivity drops with data already on screen). There is
/// no EMPTY state — `/me` either returns a profile or fails.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final me = ref.watch(meProvider);
    // Distinct offline STATE: only when connectivity is definitively down
    // (null = unknown/first frame → treated as online, don't block).
    final offline = ref.watch(isOnlineProvider).value == false;

    void retry() => ref.read(meProvider.notifier).refresh();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileTitle),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        bottom: false, // the nav shell owns the bottom inset
        child: Column(
          children: [
            if (offline) const OfflineBanner(),
            Expanded(
              child: StateWidget<StudentProfile>(
                state: profileScreenState(me),
                onRetry: retry,
                loading: const _Skeleton(),
                error: _Message(
                  icon: Icons.error_outline,
                  text: l10n.genericError,
                  onRetry: retry,
                ),
                offline: _Message(
                  icon: Icons.wifi_off,
                  text: l10n.offline,
                  onRetry: retry,
                ),
                onLoaded: (profile) => _Loaded(profile: profile),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bridges `GET /me`'s [AsyncValue] onto the shared sealed [ScreenState].
///
/// Offline is chosen by EXCEPTION TYPE, not by a connectivity read, so a
/// request that died on a dead network says so even if the stream has not
/// caught up yet. Exposed (not private) so the mapping is unit-testable without
/// pumping a widget.
ScreenState<StudentProfile> profileScreenState(AsyncValue<StudentProfile> me) =>
    me.when<ScreenState<StudentProfile>>(
      data: ScreenLoaded<StudentProfile>.new,
      loading: ScreenLoading<StudentProfile>.new,
      error: (error, _) => isOffline(error)
          ? const ScreenOffline<StudentProfile>()
          // A localization KEY, not user-facing copy: the server's
          // `title`/`detail` are developer-facing English and never shown.
          : ScreenError<StudentProfile>('genericError', cause: error),
    );

class _Loaded extends ConsumerWidget {
  const _Loaded({required this.profile});

  final StudentProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProfileHeaderCard(
            name: profile.name,
            avatarUrl: profile.avatar.url,
            // Server-authoritative integer, formatted for display only.
            levelLabel: l10n.levelProgress(profile.level),
            editLabel: l10n.editProfile,
            onEdit: () => context.push('/profile/edit'),
          ),
          const SizedBox(height: 20),
          // The ONE stat card the contract can fill. `points.total` is the
          // SERVER's sum of the dual pools (adr-003) — the app never adds
          // `school + university` itself and never infers a level from it.
          ProfileStatCard(
            key: const Key('profile_points_card'),
            label: l10n.profilePointsLabel,
            value: l10n.pointsValue(profile.points.total),
          ),
          const SizedBox(height: 20),
          _Menu(profile: profile),
        ],
      ),
    );
  }
}

/// The frame's ten rows: eight navigation rows, then the two action rows that
/// open dialogs.
///
/// Exactly one of the eight had a destination in Step 1. Step 3 gave four more
/// a **shell** — a real screen, at the frame's shape, with every control
/// disabled — because a row that opens something honest teaches a student more
/// than a row that cannot be opened. The remaining three stay disabled: they
/// have nowhere to lead even in shell form.
///
/// | Row | Step 3 |
/// |---|---|
/// | Settings | live → the real screen |
/// | Refer a Friend · Customer Support | live → a disabled shell |
/// | Privacy & policy · Terms & Conditions | live → a `TODO(content)` screen |
/// | Favorite questions · your progress | still disabled |
/// | Subscription | removed — absent, not disabled (adr-049 §3, D-007) |
///
/// Every disabled row keeps its stable `Key` and its one `TODO(contract)`
/// naming the `seif_fight.md` entry — and so does every row that now
/// navigates, because arriving at a shell does not close the gap that made it
/// a shell.
class _Menu extends ConsumerWidget {
  const _Menu({required this.profile});

  final StudentProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unavailable = l10n.profileRowUnavailable;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // The only live row in Step 1. `/settings` is still a placeholder;
        // Step 3 replaces it with the real screen.
        ProfileMenuRow(
          key: const Key('profile_row_settings'),
          icon: Icons.settings,
          label: l10n.profileSettings,
          onTap: () => context.push('/settings'),
        ),
        const SizedBox(height: 16),
        // TODO(contract): seif_fight.md S11 — `/me/favorites` is
        // `x-stability: draft`, so there is nothing to list. Enable when it
        // stabilises.
        ProfileMenuRow(
          key: const Key('profile_row_favorites'),
          icon: Icons.bookmark,
          label: l10n.profileFavoriteQuestions,
          disabledHint: unavailable,
        ),
        const SizedBox(height: 16),
        // TODO(contract): seif_fight.md S32 — "your progress" has no endpoint
        // of any kind. `GET /me` carries points/level/badges but no history,
        // and per-subject counters are not a progress timeline. No shell for
        // this one: an empty chart reads as "you have done nothing", which is
        // a lie about the student rather than about the app.
        ProfileMenuRow(
          key: const Key('profile_row_progress'),
          icon: Icons.bar_chart,
          label: l10n.profileYourProgress,
          disabledHint: unavailable,
        ),
        const SizedBox(height: 16),
        // TODO(contract): seif_fight.md S5 — the referral code is collected at
        // registration and thrown away; there is no referral endpoint, so the
        // screen behind this row is a SHELL with its share control disabled.
        // The row navigates (Step 3) because a student who taps it learns the
        // feature exists and is not open yet; a dead row teaches nothing.
        ProfileMenuRow(
          key: const Key('profile_row_refer'),
          icon: Icons.share,
          label: l10n.profileReferAFriend,
          onTap: () => context.push('/refer'),
        ),
        const SizedBox(height: 16),
        // TODO(contract): seif_fight.md S33 — customer support is fully
        // designed (tickets, chat, message threads) and has no endpoint at all.
        // Same treatment as Refer a Friend: the row leads to a shell, not
        // nowhere.
        ProfileMenuRow(
          key: const Key('profile_row_support'),
          icon: Icons.headset_mic,
          label: l10n.profileCustomerSupport,
          onTap: () => context.push('/support'),
        ),
        // No Subscription row. The frame draws one; adr-049 §3 makes the app
        // purchase-silent, so it is absent rather than disabled (D-007).
        const SizedBox(height: 16),
        // TODO(contract): seif_fight.md S30 — no endpoint is needed, but the
        // legal TEXT does not exist. Writing it is not this app's call. The
        // row leads to a `TODO(content)` screen that says so, which is more
        // honest than a row that cannot be opened at all.
        ProfileMenuRow(
          key: const Key('profile_row_privacy'),
          icon: Icons.privacy_tip,
          label: l10n.profilePrivacyPolicy,
          onTap: () => context.push('/legal/privacy'),
        ),
        const SizedBox(height: 16),
        // TODO(contract): seif_fight.md S30 — same as Privacy & policy above:
        // no copy has been supplied.
        ProfileMenuRow(
          key: const Key('profile_row_terms'),
          icon: Icons.privacy_tip,
          label: l10n.profileTermsConditions,
          onTap: () => context.push('/legal/terms'),
        ),
        const SizedBox(height: 16),
        // Go to Uni: the ROW opens the dialog; the dialog's confirm is what is
        // disabled. Track switching has no endpoint and adr-003's dual point
        // pools make it a data-model question — see the dialog below.
        ProfileMenuRow(
          key: const Key('profile_row_go_to_uni'),
          icon: Icons.trending_up,
          label: l10n.profileGoToUniversity,
          tone: ProfileRowTone.emphasis,
          onTap: () => _showGoToUni(context, l10n),
        ),
        const SizedBox(height: 16),
        ProfileMenuRow(
          key: const Key('profile_row_logout'),
          icon: Icons.logout,
          label: l10n.profileLogout,
          tone: ProfileRowTone.destructive,
          onTap: () => _confirmLogout(context, ref, l10n),
        ),
      ],
    );
  }

  /// Conflict 9 — built, confirm disabled.
  ///
  /// TODO(contract): seif_fight.md S31 — there is no track-switch endpoint.
  /// `POST /auth/register` sets the track through a discriminated body
  /// (`SchoolRegistration` | `UniversityRegistration`) whose two arms have
  /// different SHAPES (adr-010: university has no country field), and
  /// `PATCH /me` cannot express it. The blocker is not the missing route: it is
  /// that `points` are dual-pool per track (adr-003) and nobody has answered
  /// what happens to the school pool on a switch. That is a data-model
  /// question, not a UI one.
  Future<void> _showGoToUni(BuildContext context, AppLocalizations l10n) {
    return ProfileConfirmDialog.show(
      context,
      ProfileConfirmDialog(
        title: l10n.goToUniTitle,
        body: l10n.goToUniBody,
        note: l10n.goToUniWarning,
        confirmLabel: l10n.goToUniConfirm,
        confirmKey: const Key('go_to_uni_confirm'),
        // The default, spelled out: there is nothing for Confirm to call.
        confirmEnabled: false,
        disabledReason: l10n.goToUniUnavailable,
      ),
    );
  }

  /// Conflict 11 — the one thing on this screen that fully works.
  ///
  /// `POST /auth/logout` is stable and has been consumed since Day 1b;
  /// [AuthController.logout] already does the best-effort revoke and clears
  /// ONLY the tokens so `device_id` survives. Nothing is reimplemented here —
  /// the dialog is new, the behaviour behind it is not, and the router's
  /// redirect guard takes it from `AuthUnauthenticated` to `/login`.
  Future<void> _confirmLogout(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    // Resolved BEFORE the await: `ref` must not be reached across an async gap
    // once the dialog has had a chance to unmount this widget.
    final auth = ref.read(authControllerProvider.notifier);

    final confirmed = await ProfileConfirmDialog.show(
      context,
      ProfileConfirmDialog(
        title: l10n.logoutTitle,
        body: l10n.logoutBody,
        confirmLabel: l10n.logoutConfirm,
        confirmKey: const Key('logout_confirm'),
        tone: ProfileConfirmTone.destructive,
        confirmEnabled: true,
      ),
    );
    // Dismiss (the ✕, Back, or a barrier tap) resolves false and does NOTHING.
    if (!confirmed) return;
    await auth.logout();
  }
}

/// Loading — grey blocks in the shape of the header, the stat card and the
/// first rows, so the page does not jump when the real content lands.
class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Scrolls for the same reason the loaded body does: the hub is taller
      // than a phone, and a skeleton that overflows instead of scrolling would
      // make the placeholder shape lie about the content it stands in for.
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _Block(height: 104, radius: 15),
          const SizedBox(height: 20),
          // 90, not 82: the stat row's real height is 12 padding + 24 label
          // line (h3, 18 x 24/18) + 8 gap + 34 value line (displayLarge,
          // 28 x 34/28) + 12 padding. 82 was tuned to the tight bespoke line
          // heights the cards carried before the type scale landed, so it had
          // to follow them up or the row would jump 8px the moment data
          // arrived. The 104 and 64 blocks above and below are glyph- and
          // container-driven, so the scale did not move them.
          const _Block(height: 90, radius: 16),
          const SizedBox(height: 20),
          for (var i = 0; i < 5; i++) ...[
            const _Block(height: 64, radius: 16),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({required this.height, this.radius = 6});

  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: ext.progressTrack,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// Centred icon + localized line + a USER-TAPPED retry. Shared by the error and
/// offline slots so the two never drift apart visually.
class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text, this.onRetry});

  final IconData icon;
  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: ext.mutedText),
            const SizedBox(height: 16),
            Text(
              text,
              textAlign: TextAlign.center,
              style: AppType.bodyLarge.copyWith(color: ext.textSecondary),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              // Re-triggers the same request on tap — never a silent loop.
              FilledButton(onPressed: onRetry, child: Text(l10n.retry)),
            ],
          ],
        ),
      ),
    );
  }
}
