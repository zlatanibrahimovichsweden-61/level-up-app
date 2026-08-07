import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../core/widgets/titled_chrome.dart';
import '../../../l10n/app_localizations.dart';
import '../../profile/models/profile_update.dart';
import '../../profile/models/student_profile.dart';
import '../../profile/notifier/edit_profile_notifier.dart';
import '../../profile/notifier/me_notifier.dart';
import '../../profile/profile_error_copy.dart';
import '../widgets/settings_rows.dart';
import '../widgets/settings_section.dart';

/// Settings · Figma `176:1840`, routed at `/settings`. Replaces the
/// `_Placeholder` the Profile hub has been pointing at since Step 1.
///
/// Four blocks, and they do not all have the same relationship to the server:
///
/// - **Languages** and **Mode** are pure client preferences. They are wired to
///   `localeProvider` and `themeModeProvider` and need no endpoint, which is
///   why they keep working when `/me` is down.
/// - **Rank** is two `PATCH /me` fields (adr-023). It renders from `GET /me`
///   and writes through Step 2's `ProfileRepository.updateMe` — the same single
///   path, not a second one.
/// - **Notification Preferences** has no storage anywhere in the contract, so
///   all four toggles render disabled (`seif_fight.md` **S28**).
///
/// **The whole screen does not sit behind a `StateWidget`, and that is the
/// point.** A student whose `/me` is failing can still switch to Arabic and
/// still switch to the dark canvas; putting the page behind one state machine
/// would take away two working controls because a third one's request failed.
/// Only the Rank block carries `/me`'s state, and only that block degrades.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final offline = ref.watch(isOnlineProvider).value == false;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (offline) const OfflineBanner(),
            Expanded(
              child: TitledChrome(
                title: l10n.profileSettings,
                backKey: const Key('settings_back'),
                child: ListView(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 32),
                  children: const [
                    _LanguagesSection(),
                    SizedBox(height: 24),
                    _ModeSection(),
                    SizedBox(height: 24),
                    _RankSection(),
                    SizedBox(height: 24),
                    _NotificationsSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Languages — the existing [localeProvider], not a second mechanism.
///
/// The six language PILLS across the pre-auth screens call `toggle()`, which is
/// the right verb when there is one control and two states. Here both options
/// are on screen, so the rows call `select()` — tapping the language you are
/// already using must do nothing, and a toggle would flip you off it.
///
/// Both names are written in their OWN language in both ARB files, on purpose:
/// a student who has landed in a script they cannot read needs to recognise the
/// row that gets them out, and "الإنجليزية" is no help to someone looking for
/// English.
class _LanguagesSection extends ConsumerWidget {
  const _LanguagesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(localeProvider);

    void select(Locale value) =>
        ref.read(localeProvider.notifier).select(value);

    return SettingsSection(
      title: l10n.settingsLanguages,
      children: [
        SettingsChoiceRow(
          key: const Key('settings_language_ar'),
          label: l10n.languageArabicName,
          selected: locale.languageCode == 'ar',
          onTap: () => select(const Locale('ar')),
        ),
        SettingsChoiceRow(
          key: const Key('settings_language_en'),
          label: l10n.languageEnglishName,
          selected: locale.languageCode == 'en',
          onTap: () => select(const Locale('en')),
        ),
      ],
    );
  }
}

/// Mode — **two** canvases, where the frame draws three colour circles.
///
/// TODO(contract): seif_fight.md **S26** — the third circle has no palette
/// behind it. `AppColors` has exactly two, light and dark, and every fidelity
/// pass since Day 7b was measured against those two. Inventing a third would
/// mean inventing ~50 token values and calling them a design.
///
/// The swatch on each row is that palette's own `background`, so the circle a
/// student taps cannot drift from the canvas they get.
class _ModeSection extends ConsumerWidget {
  const _ModeSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final mode = ref.watch(themeModeProvider);

    void select(ThemeMode value) =>
        ref.read(themeModeProvider.notifier).select(value);

    return SettingsSection(
      title: l10n.settingsMode,
      children: [
        SettingsChoiceRow(
          key: const Key('settings_mode_light'),
          label: l10n.themeLight,
          swatch: AppColors.light.background,
          selected: mode == ThemeMode.light,
          onTap: () => select(ThemeMode.light),
        ),
        SettingsChoiceRow(
          key: const Key('settings_mode_dark'),
          label: l10n.themeDark,
          swatch: AppColors.dark.background,
          selected: mode == ThemeMode.dark,
          onTap: () => select(ThemeMode.dark),
        ),
      ],
    );
  }
}

/// Rank — **two** independent booleans, where the frame draws one "Show Rank"
/// switch.
///
/// TODO(contract): seif_fight.md **S27** — `leaderboardVisible` ("am I listed
/// at all") and `scoreHidden` ("listed, but without my score") are different
/// questions, and adr-023 defaults them differently (`true` / `false`). One
/// switch cannot express two booleans, and collapsing them would mean silently
/// choosing a privacy policy for a minor. Both are drawn.
///
/// Writes go through Step 2's [EditProfileNotifier] — the same command over the
/// same `ProfileRepository.updateMe`, so there is exactly one `PATCH /me` path
/// in the app. Each toggle sends **only its own field**: [ProfileUpdate] omits
/// everything left null, so flipping one cannot quietly rewrite the other.
///
/// Nothing is optimistic. The switch shows what `/me` says; a successful save
/// invalidates `/me` and the new value arrives from the server, which is the
/// same rule the rest of the app follows for anything the server owns.
class _RankSection extends ConsumerWidget {
  const _RankSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final me = ref.watch(meProvider);
    final save = ref.watch(editProfileProvider);

    // The nullable `.value`, not a `when`: after a successful toggle `/me` is
    // invalidated and briefly loading again, and dropping the rows to a
    // skeleton on every flip would make a working control look broken.
    final StudentProfile? profile = me.value;

    if (profile == null) {
      return SettingsSection(
        title: l10n.settingsRank,
        children: [
          if (me.hasError)
            _SectionMessage(
              key: const Key('settings_rank_unavailable'),
              text: profileSaveErrorMessage(l10n, me.error),
              onRetry: () => ref.read(meProvider.notifier).refresh(),
            )
          else
            const _SectionLoading(key: Key('settings_rank_loading')),
        ],
      );
    }

    final busy = save.isLoading;
    void write(ProfileUpdate update) =>
        ref.read(editProfileProvider.notifier).save(update);

    return SettingsSection(
      title: l10n.settingsRank,
      note: save.hasError
          ? Text(
              key: const Key('settings_rank_error'),
              profileSaveErrorMessage(l10n, save.error),
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).extension<AppColors>()!.destructive,
              ),
            )
          : null,
      children: [
        SettingsSwitchRow(
          key: const Key('settings_leaderboard_visible'),
          label: l10n.settingsLeaderboardVisible,
          help: l10n.settingsLeaderboardVisibleHelp,
          value: profile.privacy.leaderboardVisible,
          onChanged: busy
              ? null
              : (value) => write(ProfileUpdate(leaderboardVisible: value)),
        ),
        SettingsSwitchRow(
          key: const Key('settings_score_hidden'),
          label: l10n.settingsScoreHidden,
          help: l10n.settingsScoreHiddenHelp,
          value: profile.privacy.scoreHidden,
          onChanged:
              busy ? null : (value) => write(ProfileUpdate(scoreHidden: value)),
        ),
      ],
    );
  }
}

/// Notification Preferences — four toggles, no storage.
///
/// TODO(contract): seif_fight.md **S28** — nothing in the contract persists a
/// notification preference. `PUT /me/fcm-token` is a device token and is draft
/// besides, so there is not even a draft endpoint to build against. All four
/// render disabled: a switch that slides and forgets is worse than one that
/// visibly cannot.
///
/// They render **ON**, which is the frame's answer (`176:1840` draws all four
/// purple) rather than ours. This step first shipped them off, reasoning that
/// any value here is invented — true, but the frame was not available at the
/// time and it settles the question. Both states are equally fictional for a
/// control nothing can persist, so the design wins for free. See
/// docs/DESIGN_ISSUES.md #48.
class _NotificationsSection extends StatelessWidget {
  const _NotificationsSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;
    final hint = l10n.settingsNotificationsUnavailable;

    return SettingsSection(
      title: l10n.settingsNotifications,
      note: Text(
        hint,
        style: TextStyle(fontSize: 13, color: ext.hint),
      ),
      children: [
        SettingsSwitchRow(
          key: const Key('settings_notif_announcements'),
          label: l10n.notifAnnouncements,
          value: true, // the frame draws all four ON — see the class doc
          disabledHint: hint,
        ),
        SettingsSwitchRow(
          key: const Key('settings_notif_promotions'),
          label: l10n.notifPromotions,
          value: true, // the frame draws all four ON — see the class doc
          disabledHint: hint,
        ),
        SettingsSwitchRow(
          key: const Key('settings_notif_support'),
          label: l10n.notifSupport,
          value: true, // the frame draws all four ON — see the class doc
          disabledHint: hint,
        ),
        SettingsSwitchRow(
          key: const Key('settings_notif_system'),
          label: l10n.notifSystem,
          value: true, // the frame draws all four ON — see the class doc
          disabledHint: hint,
        ),
      ],
    );
  }
}

/// Rank while `/me` has never resolved. Deliberately the height of the two
/// rows it stands in for, so arriving data does not shove the sections below it
/// down the page.
class _SectionLoading extends StatelessWidget {
  const _SectionLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 128,
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

/// A one-line stand-in inside a section's card, for when that section's data
/// failed. Only Rank can reach it.
class _SectionMessage extends StatelessWidget {
  const _SectionMessage({super.key, required this.text, this.onRetry});

  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.5, 18, 16.5, 18),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 15, color: ext.textSecondary),
            ),
          ),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: Text(l10n.retry)),
        ],
      ),
    );
  }
}
