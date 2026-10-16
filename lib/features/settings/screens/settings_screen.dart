import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/segmented_track.dart';
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

/// Settings · Figma `1409:8642` (School, light, English), routed at
/// `/settings`. Replaces the `_Placeholder` the Profile hub has been pointing at
/// since Step 1.
///
/// Three blocks, and they do not all have the same relationship to the server:
///
/// - **Languages** and **Mode** are pure client preferences. They are wired to
///   `localeProvider` and `themeModeProvider` and need no endpoint, which is
///   why they keep working when `/me` is down.
/// - **Rank** is two `PATCH /me` fields (adr-023). It renders from `GET /me`
///   and writes through Step 2's `ProfileRepository.updateMe` — the same single
///   path, not a second one.
///
/// **There is no Notification Preferences block.** None of the six Settings
/// frames draws one, and the contract has nowhere to store a notification
/// preference (`updateMyProfile` takes only name, email, avatarId,
/// `leaderboardVisible` and `scoreHidden`; `seif_fight.md` **S28**). The four
/// disabled toggles this screen used to carry were a stand-in for a frame that
/// is no longer drawn, and were removed rather than left as dead controls.
///
/// **The whole screen does not sit behind a `StateWidget`, and that is the
/// point.** A student whose `/me` is failing can still switch to Arabic and
/// still switch to the dark canvas; putting the page behind one state machine
/// would take away two working controls because a third one's request failed.
/// Only the Rank block carries `/me`'s state, and only that block degrades.
///
/// The spacing is the frame's single 25, measured to the headings' ink — see
/// [kSettingsRhythm].
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
                  padding: const EdgeInsetsDirectional.fromSTEB(
                    20,
                    _contentTop,
                    20,
                    32,
                  ),
                  children: const [
                    _LanguagesSection(),
                    SizedBox(height: _blockGap),
                    _ModeSection(),
                    SizedBox(height: _blockGap),
                    _RankSection(),
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

/// The title bar's bottom to the first heading's cap top: the frame's 25
/// (`176:1863` ends at y 95, `176:2298` starts at y 120). `TitledChrome` ends
/// its bar with 8 of its own padding.
const double _contentTop = kSettingsRhythm - 8 - kSettingsHeadingCapTop;

/// A block's bottom to the next heading's cap top: the frame's 25.
const double _blockGap = kSettingsRhythm - kSettingsHeadingCapTop;

/// Languages — the existing [localeProvider], not a second mechanism.
///
/// The six language PILLS across the pre-auth screens call `toggle()`, which is
/// the right verb when there is one control and two states. Here both options
/// are on screen, so the control calls `select()` — tapping the language you
/// are already using must do nothing, and a toggle would flip you off it.
///
/// Both names are written in their OWN language in both ARB files, on purpose:
/// a student who has landed in a script they cannot read needs to recognise the
/// option that gets them out, and "الإنجليزية" is no help to someone looking
/// for English.
///
/// ---
///
/// **It is a segmented TRACK, not two rows in a card** — owner decision
/// 2026-09-17, edit5 #50. `176:1840` and `337:8177` both draw `Frame
/// 1000003007`: one 362 x 44 groove at radius 32 with two equal segments, the
/// selected one filled `#AE87E7` at radius 51 — no card, no radio rings, no
/// dividers. It is the SAME Figma component as the Lectures quiz-type tabs, so
/// it takes the same [SegmentedTrack] primitive and the same `pillTrack*`
/// tokens; building it a second way is exactly the drift the primitive exists
/// to stop.
///
/// **English is on the LEFT in both languages** — owner ruling 2026-09-29
/// (docs/DESIGN_ISSUES.md #108). The Arabic frame does not mirror this
/// control: `549:21798` "الانجليزية" sits at x 20 and `549:21796` "العربية" at
/// x 201, the same places as in English (`176:2372`, `176:2374`); only the
/// filled segment moves. `SegmentedTrack` is a `Row` and mirrors under RTL on
/// its own — right for the Lectures tabs and the leaderboard toggle, which
/// share it — so this one instance is pinned to LTR rather than the primitive
/// being changed. The build mirrored it until API→UI Wave 21.
///
/// The two `Key`s are preserved through `keyOf`, so the screen's existing tests
/// still find the same targets they always did.
class _LanguagesSection extends ConsumerWidget {
  const _LanguagesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;
    final locale = ref.watch(localeProvider);

    // `languageCode`, not the whole `Locale`: the app's locale can arrive with
    // a country subtag from the platform, and `Locale('ar') == Locale('ar',
    // 'EG')` is false — which would leave the track with nothing selected.
    final selected = locale.languageCode == 'ar' ? _arabic : _english;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // The same title treatment `SettingsSection` gives its own blocks, so
        // losing the card does not make this heading a different size from the
        // three above and below it.
        SettingsHeading(l10n.settingsLanguages),
        Directionality(
          // The frame's fixed order — see the class doc.
          textDirection: TextDirection.ltr,
          child: SegmentedTrack<Locale>(
            segments: const [_english, _arabic],
            selected: selected,
            onChanged: (value) =>
                ref.read(localeProvider.notifier).select(value),
            labelOf: (value) => value.languageCode == 'ar'
                ? l10n.languageArabicName
                : l10n.languageEnglishName,
            keyOf: (value) => Key('settings_language_${value.languageCode}'),
            style: SegmentedTrackStyle(
              trackColor: ext.pillTrackFill,
              trackRadius: 32,
              trackInsetShadows: elevation.pillTrackInsetShadows,
              selectedColor: ext.pillTrackSelectedFill,
              // The frame's 51 on a 44-high segment; anything at or above half
              // the height is the same stadium and 22 is that half exactly —
              // the quiz-type tabs' reasoning, on the same component.
              selectedRadius: 22,
              selectedInsetShadows: elevation.pillTrackSelectedInsetShadows,
              // ⚠️ The frame's own label here is Inter Medium 500 at **18**
              // (`176:2373` / `176:2375`, and `337:8179` / `337:8181` in dark).
              // The scale has no 18/w500 — `h3` is 18/w600 — and the SAME Figma
              // component reads **14** on the Lectures screen (`180:5339`). One
              // component, two sizes, neither of them the build's 12. Recorded
              // for the designer in docs/DESIGN_ISSUES.md #72; the shared
              // style is kept rather than inventing a scale entry, which
              // docs/AGENT_WORKFLOW.md forbids outright.
              labelStyle: AppType.labelMedium,
              // Read on the Properties panel 2026-09-20 and both already
              // tokenised by edit3: idle `#384F47` light / `#FCFBF9` dark,
              // selected `#FCFBF9` on both. The selected pair is the 2.74:1 the
              // owner accepted in docs/DESIGN_ISSUES.md #77.
              idleLabelColor: ext.pillTrackLabel,
              selectedLabelColor: ext.pillTrackSelectedLabel,
            ),
          ),
        ),
      ],
    );
  }
}

/// The two locales, as constants so `segments` can be `const` and the identity
/// comparison inside [SegmentedTrack] is stable across rebuilds.
const _english = Locale('en');
const _arabic = Locale('ar');

/// Mode — **two** canvases, where the frame draws three colour circles.
///
/// TODO(contract): seif_fight.md **S26** — the third circle has no palette
/// behind it. `AppColors` has exactly two, light and dark, and every fidelity
/// pass since Day 7b was measured against those two. Inventing a third would
/// mean inventing ~50 token values and calling them a design.
///
/// The swatch on each row is that palette's own `background`, so the circle a
/// student taps cannot drift from the canvas they get.
///
/// **Figma draws no card here**, exactly as it draws none around Languages:
/// `176:1840` and `337:8141` put three `Ellipse 124` swatches straight under
/// the heading. The card is kept anyway, because the control it belongs to is
/// BLOCKED (#45) — restyling the container of a stand-in whose contents cannot
/// be built would be polishing the wrong half. Recorded in
/// docs/DESIGN_ISSUES.md #45 together with the swatches' own read values, so
/// whoever unblocks it has both.
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
/// TODO(contract): seif_fight.md **S27** — `leaderboardVisible` and
/// `scoreHidden` are two booleans, and adr-023 defaults them differently
/// (`true` / `false`). One switch cannot express two booleans, and collapsing
/// them would mean silently choosing a privacy policy for a minor. Both are
/// drawn. ⚠️ Since adr-111 BOTH take a student off the board; `scoreHidden`
/// also costs them their own rank (`403 score_hidden_leaderboard_unavailable`).
/// Neither switch has a help line: no frame draws one, and the owner dropped
/// both on 2026-10-15, which also retired BUG-017's stale "listed, but without
/// my score" line (docs/KNOWN_BUGS.md). The second label keeps "points", not
/// the English frame's "score" (owner decision, same day).
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
              style: AppType.bodyMedium.copyWith(
                color: Theme.of(context).extension<AppColors>()!.destructive,
              ),
            )
          : null,
      children: [
        SettingsSwitchRow(
          key: const Key('settings_leaderboard_visible'),
          label: l10n.settingsLeaderboardVisible,
          value: profile.privacy.leaderboardVisible,
          onChanged: busy
              ? null
              : (value) => write(ProfileUpdate(leaderboardVisible: value)),
        ),
        SettingsSwitchRow(
          key: const Key('settings_score_hidden'),
          label: l10n.settingsScoreHidden,
          value: profile.privacy.scoreHidden,
          onChanged: busy
              ? null
              : (value) => write(ProfileUpdate(scoreHidden: value)),
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
      // The rows' 16 in from the card's inner edge (see `_rowPadding`).
      padding: const EdgeInsetsDirectional.fromSTEB(16, 18, 16, 18),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: AppType.bodyMedium.copyWith(color: ext.textSecondary),
            ),
          ),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: Text(l10n.retry)),
        ],
      ),
    );
  }
}
