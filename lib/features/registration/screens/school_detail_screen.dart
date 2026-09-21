import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/core_providers.dart';
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
  /// The chosen school row, kept locally so the field can show its NAME while
  /// the draft carries only the opaque id that gets submitted.
  NamedRef? _selectedSchool;

  /// adr-028 §2 — the student used "I can't find my school". Distinct from
  /// "nothing chosen yet": both submit without a `schoolId`, but only this one
  /// should render as a resolved field.
  bool _schoolSkipped = false;

  /// Anything that invalidates the school scope drops both the selection and
  /// the skip: the field is scoped by city, so a new city means a new question.
  void _clearSchool() => setState(() {
    _selectedSchool = null;
    _schoolSkipped = false;
  });

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
                    const SizedBox(height: 8),
                    Text(
                      l10n.schoolRegistrationTitle,
                      style: AppType.h1.copyWith(color: ext.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.schoolRegistrationSubtitle,
                      style: AppType.bodyLarge.copyWith(
                        color: ext.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // TODO(design): dateOfBirth not in Figma —
                    // see docs/DESIGN_ISSUES.md #2. Contract-required.
                    DateOfBirthField(
                      value: draft.dateOfBirth,
                      errorText: errorFor(RegFields.dateOfBirth),
                      onChanged: (date) =>
                          _edit(() => controller.setDateOfBirth(date)),
                    ),
                    const SizedBox(height: 16),

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
                        _clearSchool();
                      }),
                    ),
                    const SizedBox(height: 16),

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
                        onSelected: (id) => _edit(() {
                          controller.setGovernorate(id);
                          setState(() => _selectedSchool = null);
                        }),
                      ),
                      const SizedBox(height: 16),
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
                      onCitySelected: (id) => _edit(() {
                        controller.setCity(id);
                        _clearSchool();
                      }),
                      onCityNameChanged: (name) => _edit(() {
                        controller.setCityName(name);
                        _clearSchool();
                      }),
                    ),
                    const SizedBox(height: 16),

                    // 4 — Education System.
                    ReferenceDropdown(
                      fieldKey: 'field-educationSystem',
                      label: l10n.educationSystemLabel,
                      value: draft.educationSystem,
                      options: _educationSystemOptions(),
                      errorText: errorFor(RegFields.educationSystem),
                      onRetry: () => ref.invalidate(educationSystemsProvider),
                      onSelected: (code) =>
                          _edit(() => controller.setEducationSystem(code)),
                    ),
                    const SizedBox(height: 16),

                    // 5 — Grade (the design's label for the contract's `stage`).
                    // A closed contract enum, so it needs no endpoint.
                    ReferenceDropdown(
                      fieldKey: 'field-stage',
                      label: l10n.stageLabel,
                      value: draft.stage,
                      options: AsyncData(_stageOptions(l10n)),
                      errorText: errorFor(RegFields.stage),
                      onSelected: (stage) =>
                          _edit(() => controller.setStage(stage)),
                    ),
                    const SizedBox(height: 16),

                    // 6 — School. EGYPT ONLY (adr-028 §2): the coded list is
                    // Egyptian, so outside Egypt there is nothing to choose
                    // from and nothing to type — the block is absent, not
                    // disabled, exactly like the governorate branch above.
                    if (requiresGovernorate)
                      SchoolPickerField(
                        governorateId: draft.governorateId,
                        // Null under a free-text city — the search then scopes
                        // by governorate alone rather than being disabled.
                        cityId: draft.cityId,
                        selected: _selectedSchool,
                        skipped: _schoolSkipped,
                        errorText: errorFor(RegFields.schoolId),
                        onSelected: (school) => _edit(() {
                          setState(() {
                            _selectedSchool = school;
                            _schoolSkipped = false; // picking un-skips
                          });
                          controller.setSchool(school.id);
                        }),
                        onSkip: () => _edit(() {
                          setState(() {
                            _selectedSchool = null;
                            _schoolSkipped = true;
                          });
                          controller.clearSchool();
                        }),
                      ),

                    if (submitState.hasError &&
                        !restartsRegistration(submitState.error))
                      SubmitFailureBanner(
                        message: registrationErrorMessage(
                          l10n,
                          submitState.error,
                        ),
                      ),
                    const SizedBox(height: 28),

                    PrimaryCta(
                      enabled: !submitState.isLoading,
                      child: FilledButton(
                        onPressed: submitState.isLoading
                            ? null
                            : () => ref
                                  .read(registrationSubmitProvider.notifier)
                                  .submit(),
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

  /// 201 → `/home`; a token/phone failure → restart at `/login`.
  void _handleSubmitOutcome(AppLocalizations l10n) {
    ref.listen(registrationSubmitProvider, (_, next) {
      if (!mounted) return;

      if (next.value != null) {
        // Tokens are stored and AuthController is already authenticated.
        context.go('/home');
        // Drop the consumed registrationToken AFTER the frame, so this screen
        // is gone before the draft-null guard could flash the expiry view.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(registrationControllerProvider.notifier).reset();
        });
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

  // --- Options mapping: bilingual rows in, {id,label} out ------------------

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

  AsyncValue<List<PickerOption>> _educationSystemOptions() => ref
      .watch(educationSystemsProvider)
      .whenData(
        (systems) => [
          for (final system in systems)
            (
              id: system.code,
              label: localizedRefName(context, system.nameAr, system.nameEn),
              leading: null,
              enabled: true,
            ),
        ],
      );

  List<PickerOption> _stageOptions(AppLocalizations l10n) => [
    for (final stage in Stage.values)
      (
        id: stage.wireValue,
        label: _stageLabel(l10n, stage),
        leading: null,
        enabled: true,
      ),
  ];

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
