import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/router/return_target.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/primary_cta.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../l10n/app_localizations.dart';
import '../models/reference_models.dart';
import '../models/registration_validation.dart';
import '../models/stage.dart';
import '../notifier/reference_providers.dart';
import '../notifier/registration_controller.dart';
import '../notifier/registration_submit_notifier.dart';
import '../registration_error_copy.dart';
import '../widgets/city_field.dart';
import '../widgets/date_of_birth_field.dart';
import '../widgets/reference_dropdown.dart';
import '../widgets/registration_chrome.dart';
import '../widgets/school_picker_field.dart';
import 'registration_expired_view.dart';

/// School Registration · Figma frame `337:5269`.
///
/// Field order follows the frame — Country → Governorate → City → Education
/// System → Grade → School Name → **Start learning** — with one addition the
/// frame is missing (date of birth, placed under the subtitle).
///
/// The geography branch is adr-010: the selected country's own
/// `requiresGovernorate` flag decides whether the student picks coded
/// governorate/city/school ids (Egypt) or just a city plus optional free-text
/// school name (everywhere else). The code never tests `countryCode == 'EG'`
/// itself — that list is server-owned and extensible.
///
/// `name` and `parentPhone` were collected on Sign Up_1 and are NOT re-asked.
class SchoolDetailScreen extends ConsumerStatefulWidget {
  const SchoolDetailScreen({super.key});

  @override
  ConsumerState<SchoolDetailScreen> createState() => _SchoolDetailScreenState();
}

class _SchoolDetailScreenState extends ConsumerState<SchoolDetailScreen> {
  /// The frame's one vertical rhythm (`125:511` / `337:5269`), box to box —
  /// its text is NOT trimmed here (title 29 = 22 x 1.3, subtitle 26):
  /// header row bottom 100.98 → title 126; subtitle bottom 189 → fields 214;
  /// `Component 4`'s own auto-layout gap between field blocks; fields bottom
  /// 891 → Start learning 916. All 25. The build used 8 / 28 / 16 / 28
  /// (Wave 03, W03-1).
  static const _gap = 25.0;

  /// The wire `status` of a stage / education system that is open for School
  /// registration. Anything else — `soon`, or a value this build has never seen —
  /// is shown but not selectable: an unknown status fails closed.
  static const _active = 'active';

  /// The wire `status` that carries the "Soon" mark. Any other not-open status
  /// is disabled with no mark.
  static const _soon = 'soon';

  /// The Education System and Grade blocks, so a `422` that refuses one of them
  /// can scroll that field back into view (the banner is far below it).
  final _systemBlockKey = GlobalKey();
  final _stageBlockKey = GlobalKey();

  /// The stage and education system the draft held when Start learning was
  /// last tapped - the values that request carried. The pickers stay enabled
  /// while it is in flight, so the draft can have moved on by the time its
  /// `422` lands; [_refuseChoice] forgets a refused field only if the draft
  /// still holds what was refused.
  ({String? stage, String? educationSystem})? _sent;

  /// Any edit clears a stale submit failure so its inline errors stop showing.
  void _edit(void Function() change) {
    change();
    ref.read(registrationSubmitProvider.notifier).clearError();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;
    final draft = ref.watch(registrationControllerProvider);
    final submitState = ref.watch(registrationSubmitProvider);
    final offline = ref.watch(isOnlineProvider).value == false;

    _handleSubmitOutcome(l10n);
    _seedDefaultCountry(draft?.countryCode);

    // Guard: reachable only inside a live registration window.
    if (draft == null || draft.isExpired) {
      return const RegistrationExpiredView();
    }

    final controller = ref.read(registrationControllerProvider.notifier);
    final requiresGovernorate = draft.requiresGovernorate ?? false;

    // Which stages and education systems are open is the server's setting, read
    // fresh on every visit to this screen (D-026): never cached, never
    // defaulted, never hard-coded. Registration waits for both lists.
    final stages = ref.watch(schoolStagesProvider);
    final systems = ref.watch(educationSystemsProvider);
    final statusesReady = _isSettled(stages) && _isSettled(systems);
    _clearStaleChoices(
      stage: draft.stage,
      educationSystem: draft.educationSystem,
      stages: stages,
      systems: systems,
    );
    final canSubmit = statusesReady && !submitState.isLoading;

    // Inline errors come from whichever side rejected the form: the client
    // pre-flight (before any request) or the server's `validation_failed`
    // field map. One channel, keyed by the contract's field names.
    final issues = fieldIssuesFrom(submitState.error);
    String? errorFor(String field) {
      final issue = issues[field];
      return issue == null ? null : fieldIssueMessage(l10n, issue);
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (offline) const OfflineBanner(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 8, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const RegistrationHeader(),
                    const SizedBox(height: _gap),
                    Text(
                      l10n.schoolRegistrationTitle,
                      style: AppType.h1.copyWith(color: ext.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    // `125:536` is `#7C7C7C` — the muted grey DESIGN_ISSUES
                    // #24 folds into `bodyMuted`, not the near-black
                    // `textSecondary` (`#2C2C2C`) it was (W03-2).
                    Text(
                      l10n.schoolRegistrationSubtitle,
                      style: AppType.bodyLarge.copyWith(color: ext.bodyMuted),
                    ),
                    const SizedBox(height: _gap),

                    // TODO(design): dateOfBirth not in Figma —
                    // see docs/DESIGN_ISSUES.md #2. Contract-required.
                    DateOfBirthField(
                      value: draft.dateOfBirth,
                      errorText: errorFor(RegFields.dateOfBirth),
                      onChanged: (date) =>
                          _edit(() => controller.setDateOfBirth(date)),
                    ),
                    const SizedBox(height: _gap),

                    // 1 — Country (frame order starts here). Drives the whole
                    // geography branch via the row's own requiresGovernorate.
                    ReferenceDropdown(
                      fieldKey: 'field-countryCode',
                      label: l10n.countryLabel,
                      value: draft.countryCode,
                      options: _countryOptions(),
                      errorText: errorFor(RegFields.countryCode),
                      onRetry: () => ref.invalidate(countriesProvider),
                      onSelected: (code) => _edit(() {
                        final matches =
                            ref
                                .read(countriesProvider)
                                .value
                                ?.where((c) => c.code == code) ??
                            const <Country>[];
                        if (matches.isEmpty) return;
                        final country = matches.first;
                        controller.setCountry(
                          countryCode: country.code,
                          requiresGovernorate: country.requiresGovernorate,
                        );
                      }),
                    ),
                    const SizedBox(height: _gap),

                    // 2 — Governorate. EGYPT ONLY: forbidden elsewhere, so the
                    // field is not merely disabled, it is absent.
                    if (requiresGovernorate) ...[
                      ReferenceDropdown(
                        fieldKey: 'field-governorateId',
                        label: l10n.governorateLabel,
                        value: draft.governorateId,
                        options: _governorateOptions(draft.countryCode),
                        enabled: draft.countryCode != null,
                        disabledHint: l10n.selectCountryFirst,
                        errorText: errorFor(RegFields.governorateId),
                        onRetry: () => ref.invalidate(
                          governoratesProvider(draft.countryCode!),
                        ),
                        onSelected: (id) =>
                            _edit(() => controller.setGovernorate(id)),
                      ),
                      const SizedBox(height: _gap),
                    ],

                    // 3 — City. Egypt must scope by governorate (the contract
                    // 400s on `/reference/cities?countryCode=EG` without one),
                    // so the picker stays gated until one is chosen. The
                    // adr-028 §1 free-text escape is NOT gated by that — a
                    // missing city row must not be compounded by the list's
                    // own scoping.
                    CityField(
                      cityId: draft.cityId,
                      cityName: draft.cityName,
                      options: _cityOptions(
                        draft.countryCode,
                        draft.governorateId,
                        requiresGovernorate,
                      ),
                      enabled:
                          draft.countryCode != null &&
                          (!requiresGovernorate || draft.governorateId != null),
                      disabledHint: requiresGovernorate
                          ? l10n.selectGovernorateFirst
                          : l10n.selectCountryFirst,
                      errorText:
                          errorFor(RegFields.cityId) ??
                          errorFor(RegFields.cityName),
                      onRetry: () => ref.invalidate(
                        citiesProvider((
                          countryCode: draft.countryCode!,
                          governorateId: draft.governorateId,
                        )),
                      ),
                      onCitySelected: (id) =>
                          _edit(() => controller.setCity(id)),
                      onCityNameChanged: (name) =>
                          _edit(() => controller.setCityName(name)),
                    ),
                    const SizedBox(height: _gap),

                    // 4 — Education System. Each row carries the server's own
                    // `status`: `active` selects, `soon` shows "Soon" and does
                    // not. A `422` that refuses the system scrolls back here.
                    KeyedSubtree(
                      key: _systemBlockKey,
                      child: ReferenceDropdown(
                        fieldKey: 'field-educationSystem',
                        label: l10n.educationSystemLabel,
                        value: draft.educationSystem,
                        options: _educationSystemOptions(systems),
                        rowMarks: _educationSystemMarks(l10n, systems),
                        errorText: errorFor(RegFields.educationSystem),
                        onRetry: () => ref.invalidate(educationSystemsProvider),
                        onSelected: (code) =>
                            _edit(() => controller.setEducationSystem(code)),
                      ),
                    ),
                    const SizedBox(height: _gap),

                    // 5 — Grade (the design's label for the contract's `stage`).
                    // The six rows and their labels are the app's own; which of
                    // them is open comes from `GET /reference/school-stages`
                    // (`active` | `soon`), which carries no names.
                    KeyedSubtree(
                      key: _stageBlockKey,
                      child: ReferenceDropdown(
                        fieldKey: 'field-stage',
                        label: l10n.stageLabel,
                        value: draft.stage,
                        options: _stageOptions(l10n, stages),
                        rowMarks: _stageMarks(l10n, stages),
                        errorText: errorFor(RegFields.stage),
                        onRetry: () => ref.invalidate(schoolStagesProvider),
                        onSelected: (stage) =>
                            _edit(() => controller.setStage(stage)),
                      ),
                    ),

                    // 6 — School. EGYPT ONLY (adr-028 §2): the coded list is
                    // Egyptian, so outside Egypt there is nothing to choose
                    // from and nothing to type — the block is absent, not
                    // disabled, exactly like the governorate branch above.
                    if (requiresGovernorate) ...[
                      const SizedBox(height: _gap),
                      SchoolPickerField(
                        governorateId: draft.governorateId,
                        // Null under a free-text city — the search then scopes
                        // by governorate alone rather than being disabled.
                        cityId: draft.cityId,
                        // From the draft, not this screen's state, so the
                        // picked name (or the skip) is still shown when the
                        // student leaves the form and comes back (BUG-027).
                        selected: draft.pickedSchool,
                        skipped: draft.schoolSkipped,
                        errorText: errorFor(RegFields.schoolId),
                        onSelected: (school) => _edit(
                          () => controller.setSchool(school.id, row: school),
                        ),
                        onSkip: () => _edit(controller.skipSchool),
                      ),
                    ],

                    // A refused name is shown on Sign Up_1, where this form
                    // is already sliding back to; it gets no banner here.
                    if (submitState.hasError &&
                        !restartsRegistration(submitState.error) &&
                        !isNameNotAllowed(submitState.error))
                      SubmitFailureBanner(
                        message: registrationErrorMessage(
                          l10n,
                          submitState.error,
                        ),
                      ),
                    const SizedBox(height: _gap),

                    // Disabled until both status lists have loaded without
                    // error, and while a submit is in flight: registering on a
                    // slow or failed status read would be a guess.
                    PrimaryCta(
                      enabled: canSubmit,
                      child: FilledButton(
                        onPressed: canSubmit
                            ? () {
                                final current = ref.read(
                                  registrationControllerProvider,
                                );
                                _sent = (
                                  stage: current?.stage,
                                  educationSystem: current?.educationSystem,
                                );
                                ref
                                    .read(registrationSubmitProvider.notifier)
                                    .submit();
                              }
                            : null,
                        child: submitState.isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                l10n.startLearning,
                                style: AppType.buttonLarge,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// The frame shows Egypt pre-selected. Seeded from the server's own country
  /// list once it is available — the code never invents a country row, it just
  /// picks Egypt out of what the endpoint returned (falling back to the first
  /// row if EG ever stops being in the launch set).
  ///
  /// Runs after the frame so it mutates the draft outside build.
  void _seedDefaultCountry(String? currentCode) {
    if (currentCode != null) return;
    final countries = ref.watch(countriesProvider).value;
    if (countries == null || countries.isEmpty) return;

    final egypt = countries.where((c) => c.code == 'EG');
    final preset = egypt.isNotEmpty ? egypt.first : countries.first;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (ref.read(registrationControllerProvider)?.countryCode != null) return;
      ref
          .read(registrationControllerProvider.notifier)
          .setCountry(
            countryCode: preset.code,
            requiresGovernorate: preset.requiresGovernorate,
          );
    });
  }

  /// 201 → `/home`; a token/phone failure → restart at `/login`; a refused
  /// stage or education system → stay here and fix the choice.
  void _handleSubmitOutcome(AppLocalizations l10n) {
    ref.listen(registrationSubmitProvider, (_, next) {
      if (!mounted) return;

      if (next.value != null) {
        // Tokens are stored and AuthController is already authenticated.
        // `registrationRequired` means no account existed for this phone, so a
        // new registrant is never the student whose session ended: forget any
        // remembered return target and land on Home.
        ref.read(returnTargetProvider).clear();
        context.go('/home');
        // Drop the consumed registrationToken AFTER the frame, so this screen
        // is gone before the draft-null guard could flash the expiry view.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(registrationControllerProvider.notifier).reset();
        });
        return;
      }

      if (next.hasError && isSchoolStageNotAvailable(next.error)) {
        _refuseChoice(stage: true);
        return;
      }

      if (next.hasError && isEducationSystemNotAvailable(next.error)) {
        _refuseChoice(stage: false);
        return;
      }

      if (next.hasError && isNameNotAllowed(next.error)) {
        // `422 name_not_allowed`: the name is asked on Sign Up_1, so that is
        // where it gets fixed. The draft and its token are kept, and the error
        // stays in the submit provider for Sign Up_1 to mark the name with.
        // `go` rebuilds the one-screen stack OTP left, and the screens after it
        // refill from the draft, the picked school's name included (BUG-027).
        // Nothing is resent from here.
        context.go('/register');
        return;
      }

      if (next.hasError && restartsRegistration(next.error)) {
        // `registration_token_invalid` / `phone_already_registered` — the
        // contract's answer to both is to start again at phone → OTP.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(registrationErrorMessage(l10n, next.error))),
        );
        ref.read(registrationControllerProvider.notifier).reset();
        context.go('/login');
      }
    });
  }

  /// A `422` that says the choice is not open: `school_stage_not_available`
  /// ([stage] true) or `education_system_not_available` (false). The student
  /// stays on this form with the draft and its token — the token is not
  /// consumed — and fixes it. The refused selection is forgotten, both status
  /// lists are read again (they have just proved out of date, or the student
  /// would have been shown a closed row as open), and the refused field is
  /// scrolled back into view: the banner that names the problem sits far below
  /// it. Nothing is resubmitted from here; the next request is the student's own
  /// Start learning.
  ///
  /// The draft is changed directly rather than through [_edit], which would
  /// clear the very error the banner and the field mark are showing.
  ///
  /// The `422` answers the request that was SENT (see [_sent]), and the pickers
  /// stay enabled while it is in flight. So the field is cleared only if the
  /// draft still holds the value that was refused: a valid value the student
  /// picked meanwhile is not wiped. With no value recorded (never expected) it
  /// is cleared, as it always was.
  void _refuseChoice({required bool stage}) {
    final controller = ref.read(registrationControllerProvider.notifier);
    final draft = ref.read(registrationControllerProvider);
    final sent = _sent;
    if (stage) {
      if (sent == null || draft?.stage == sent.stage) controller.clearStage();
    } else {
      if (sent == null || draft?.educationSystem == sent.educationSystem) {
        controller.clearEducationSystem();
      }
    }
    ref.invalidate(schoolStagesProvider);
    ref.invalidate(educationSystemsProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final target = (stage ? _stageBlockKey : _systemBlockKey).currentContext;
      if (target == null) return;
      Scrollable.ensureVisible(
        target,
        alignment: 0.1,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  /// A settled status list: it has loaded, is not being reloaded (a refresh
  /// that still holds the old rows is NOT settled — Riverpod 3 keeps the old
  /// value on a refreshing state), and failed with nothing.
  bool _isSettled<T>(AsyncValue<List<T>> status) =>
      !status.isLoading && !status.hasError && status.hasValue;

  /// No stale choice. When the server's statuses are in and the draft still
  /// holds a stage or education system that is not `active` there — closed,
  /// unknown, or missing from the answer altogether — the choice is forgotten,
  /// quietly: no banner, no snackbar. This is what keeps a draft restored from
  /// an earlier visit, or one made before the server closed an option, from
  /// being submitted.
  ///
  /// After the frame, re-reading both the draft and the lists, so nothing
  /// mutates during build and a choice the student has just changed is judged
  /// on what it is now.
  void _clearStaleChoices({
    required String? stage,
    required String? educationSystem,
    required AsyncValue<List<SchoolStageRef>> stages,
    required AsyncValue<List<EducationSystemRef>> systems,
  }) {
    if (!_isStaleStage(stage, stages) &&
        !_isStaleSystem(educationSystem, systems)) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final current = ref.read(registrationControllerProvider);
      if (current == null) return;
      final controller = ref.read(registrationControllerProvider.notifier);
      if (_isStaleStage(current.stage, ref.read(schoolStagesProvider))) {
        controller.clearStage();
      }
      if (_isStaleSystem(
        current.educationSystem,
        ref.read(educationSystemsProvider),
      )) {
        controller.clearEducationSystem();
      }
    });
  }

  bool _isStaleStage(String? stage, AsyncValue<List<SchoolStageRef>> stages) =>
      stage != null &&
      _isSettled(stages) &&
      _stageStatus(stages.requireValue, stage) != _active;

  bool _isStaleSystem(
    String? educationSystem,
    AsyncValue<List<EducationSystemRef>> systems,
  ) =>
      educationSystem != null &&
      _isSettled(systems) &&
      _systemStatus(systems.requireValue, educationSystem) != _active;

  /// The status the server gave [stage], or null when the answer omits it.
  /// Items whose `stage` this build's `Stage` enum does not know never match a
  /// row, so they are ignored.
  String? _stageStatus(List<SchoolStageRef> served, String stage) {
    for (final item in served) {
      if (item.stage == stage) return item.status;
    }
    return null;
  }

  /// The status the server gave the education system [code], or null.
  String? _systemStatus(List<EducationSystemRef> served, String code) {
    for (final item in served) {
      if (item.code == code) return item.status;
    }
    return null;
  }

  // --- Options mapping: bilingual rows in, {id,label} out ------------------

  /// What a status-driven picker is told. Loading — INCLUDING a refresh that
  /// still holds the old rows, which would otherwise show a closed row as open
  /// for as long as the answer takes — and error are passed on as such; only a
  /// settled, error-free list becomes data. Loading wins over an error that is
  /// being retried.
  AsyncValue<List<PickerOption>> _whenSettled<T>(
    AsyncValue<List<T>> status,
    List<PickerOption> Function(List<T> served) rows,
  ) {
    if (status.isLoading) return const AsyncLoading();
    if (status.hasError) {
      return AsyncError(status.error!, status.stackTrace ?? StackTrace.empty);
    }
    if (!status.hasValue) return const AsyncLoading();
    return AsyncData(rows(status.requireValue));
  }

  AsyncValue<List<PickerOption>> _countryOptions() => ref
      .watch(countriesProvider)
      .whenData(
        (countries) => [
          for (final country in countries)
            (
              id: country.code,
              label: localizedRefName(context, country.nameAr, country.nameEn),
              leading: CountryFlag.fromCountryCode(
                country.code,
                theme: const EmojiTheme(size: 20),
              ),
              enabled: true,
            ),
        ],
      );

  AsyncValue<List<PickerOption>> _governorateOptions(String? countryCode) {
    if (countryCode == null) return const AsyncData([]);
    return ref.watch(governoratesProvider(countryCode)).whenData(_namedRefRows);
  }

  AsyncValue<List<PickerOption>> _cityOptions(
    String? countryCode,
    String? governorateId,
    bool requiresGovernorate,
  ) {
    if (countryCode == null) return const AsyncData([]);
    // Don't fire the request Egypt would 400 on.
    if (requiresGovernorate && governorateId == null) {
      return const AsyncData([]);
    }
    return ref
        .watch(
          citiesProvider((
            countryCode: countryCode,
            governorateId: governorateId,
          )),
        )
        .whenData(_namedRefRows);
  }

  /// The education systems the server served, each selectable only when its
  /// `status` is exactly `active` (`soon` and anything unknown are shown,
  /// dimmed, and refuse a tap).
  AsyncValue<List<PickerOption>> _educationSystemOptions(
    AsyncValue<List<EducationSystemRef>> systems,
  ) => _whenSettled(systems, (served) {
    return [
      for (final system in served)
        (
          id: system.code,
          label: localizedRefName(context, system.nameAr, system.nameEn),
          leading: null,
          enabled: system.status == _active,
        ),
    ];
  });

  /// "Soon" on the systems the server marks `soon` — and only those: an
  /// unknown status is disabled with no mark.
  Map<String, String>? _educationSystemMarks(
    AppLocalizations l10n,
    AsyncValue<List<EducationSystemRef>> systems,
  ) => _isSettled(systems)
      ? {
          for (final system in systems.requireValue)
            if (system.status == _soon) system.code: l10n.registrationSoonMark,
        }
      : null;

  /// The six stages in `Stage.values` order, under the app's own labels. The
  /// answer only says which are open: a stage it leaves out is disabled, a
  /// stage it names that the enum does not know is ignored.
  AsyncValue<List<PickerOption>> _stageOptions(
    AppLocalizations l10n,
    AsyncValue<List<SchoolStageRef>> stages,
  ) => _whenSettled(stages, (served) {
    return [
      for (final stage in Stage.values)
        (
          id: stage.wireValue,
          label: _stageLabel(l10n, stage),
          leading: null,
          enabled: _stageStatus(served, stage.wireValue) == _active,
        ),
    ];
  });

  /// "Soon" on the stages the server marks `soon`. A stage with an unknown
  /// status, or one the answer omits, is disabled with no mark.
  Map<String, String>? _stageMarks(
    AppLocalizations l10n,
    AsyncValue<List<SchoolStageRef>> stages,
  ) => _isSettled(stages)
      ? {
          for (final stage in Stage.values)
            if (_stageStatus(stages.requireValue, stage.wireValue) == _soon)
              stage.wireValue: l10n.registrationSoonMark,
        }
      : null;

  List<PickerOption> _namedRefRows(List<NamedRef> rows) => [
    for (final row in rows)
      (
        id: row.id,
        label: localizedRefName(context, row.nameAr, row.nameEn),
        leading: null,
        enabled: true,
      ),
  ];
}

String _stageLabel(AppLocalizations l10n, Stage stage) => switch (stage) {
  Stage.prep1 => l10n.stagePrep1,
  Stage.prep2 => l10n.stagePrep2,
  Stage.prep3 => l10n.stagePrep3,
  Stage.secondary1 => l10n.stageSecondary1,
  Stage.secondary2 => l10n.stageSecondary2,
  Stage.secondary3 => l10n.stageSecondary3,
};
