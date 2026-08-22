import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../l10n/app_localizations.dart';
import '../models/reference_models.dart';
import '../models/registration_validation.dart';
import '../notifier/reference_providers.dart';
import '../notifier/registration_controller.dart';
import '../notifier/registration_submit_notifier.dart';
import '../registration_error_copy.dart';
import '../widgets/city_field.dart';
import '../widgets/date_of_birth_field.dart';
import '../widgets/reference_dropdown.dart';
import '../widgets/registration_chrome.dart';
import 'registration_expired_view.dart';

/// University Registration · Figma frame `337:10373`. Egypt-only.
///
/// **Field order deviates from the frame, deliberately.** The design draws
/// Faculty → Academic Year → City → University Name, but faculties belong to a
/// university and years belong to a faculty, so a student cannot answer the
/// first field until the last one is answered. The order here follows the data
/// cascade instead — University → Faculty → Academic Year — and the deviation is
/// logged for the designer as docs/DESIGN_ISSUES.md #4.
///
/// Two more differences from the frame, both contract-required:
/// governorate (#3) and date of birth (#2).
///
/// There is no country field: `UniversityRegistration` is Egypt-only BY SHAPE
/// (adr-010), so the governorate list is fetched for `EG` directly.
class UniversityDetailScreen extends ConsumerStatefulWidget {
  const UniversityDetailScreen({super.key});

  @override
  ConsumerState<UniversityDetailScreen> createState() =>
      _UniversityDetailScreenState();
}

class _UniversityDetailScreenState
    extends ConsumerState<UniversityDetailScreen> {
  /// The university track is Egypt-only by shape — there is no country picker
  /// to read this from, so the geography lookups are scoped to EG.
  static const _countryCode = 'EG';

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

    if (draft == null || draft.isExpired) {
      return const RegistrationExpiredView();
    }

    final controller = ref.read(registrationControllerProvider.notifier);
    final universities = ref.watch(universitiesProvider);

    // The cascade, resolved from the tree the endpoint returned. A selection
    // that no longer exists (e.g. the list changed) resolves to null, which
    // re-gates the fields below it rather than submitting a dangling id.
    final selectedUniversity = _findUniversity(
      universities.value,
      draft.universityId,
    );
    final selectedFaculty = _findFaculty(selectedUniversity, draft.facultyId);

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
                      l10n.universityRegistrationTitle,
                      style: AppType.h1.copyWith(color: ext.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.universityRegistrationSubtitle,
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

                    // 1 — University. Must come first: faculties hang off it.
                    ReferenceDropdown(
                      fieldKey: 'field-universityId',
                      label: l10n.universityLabel,
                      value: draft.universityId,
                      options: universities.whenData(
                        (rows) => [
                          for (final university in rows)
                            (
                              id: university.id,
                              label: localizedRefName(
                                context,
                                university.nameAr,
                                university.nameEn,
                              ),
                              leading: null,
                            ),
                        ],
                      ),
                      errorText: errorFor(RegFields.universityId),
                      onRetry: () => ref.invalidate(universitiesProvider),
                      onSelected: (id) =>
                          _edit(() => controller.setUniversity(id)),
                    ),
                    const SizedBox(height: 16),

                    // 2 — Faculty, from the selected university's own list.
                    // Gated: no university → nothing to choose from.
                    ReferenceDropdown(
                      fieldKey: 'field-facultyId',
                      label: l10n.facultyLabel,
                      value: draft.facultyId,
                      enabled: selectedUniversity != null,
                      disabledHint: l10n.selectUniversityFirst,
                      options: AsyncData([
                        for (final faculty
                            in selectedUniversity?.faculties ??
                                const <FacultyRef>[])
                          (
                            id: faculty.id,
                            label: localizedRefName(
                              context,
                              faculty.nameAr,
                              faculty.nameEn,
                            ),
                            leading: null,
                          ),
                      ]),
                      errorText: errorFor(RegFields.facultyId),
                      onSelected: (id) =>
                          _edit(() => controller.setFaculty(id)),
                    ),
                    const SizedBox(height: 16),

                    // 3 — Academic Year. ACTIVE years only: the contract says a
                    // `soon` year answers `validation_failed`, so it is never
                    // offered rather than offered-and-rejected.
                    ReferenceDropdown(
                      fieldKey: 'field-studyYearId',
                      label: l10n.studyYearLabel,
                      value: draft.studyYearId,
                      enabled: selectedFaculty != null,
                      disabledHint: l10n.selectFacultyFirst,
                      options: AsyncData([
                        for (final year
                            in selectedFaculty?.years ?? const <StudyYearRef>[])
                          if (year.status == _activeYear)
                            (
                              id: year.id,
                              label: l10n.studyYearNumber(year.yearNumber),
                              leading: null,
                            ),
                      ]),
                      errorText: errorFor(RegFields.studyYearId),
                      onSelected: (id) =>
                          _edit(() => controller.setStudyYear(id)),
                    ),
                    const SizedBox(height: 16),

                    // 4 — TODO(design): governorateId not in Figma —
                    // see docs/DESIGN_ISSUES.md #3. Contract-required, and it
                    // has to precede City so the city list can be scoped.
                    ReferenceDropdown(
                      fieldKey: 'field-governorateId',
                      label: l10n.governorateLabel,
                      value: draft.governorateId,
                      options: ref
                          .watch(governoratesProvider(_countryCode))
                          .whenData(_namedRefRows),
                      errorText: errorFor(RegFields.governorateId),
                      onRetry: () =>
                          ref.invalidate(governoratesProvider(_countryCode)),
                      onSelected: (id) =>
                          _edit(() => controller.setGovernorate(id)),
                    ),
                    const SizedBox(height: 16),

                    // 5 — City, scoped by governorate (Egypt 400s without one),
                    // with the adr-028 §1 escape. The notice applies it to
                    // BOTH tracks — university registration collects a city
                    // too, and the coded list is just as capable of missing it.
                    CityField(
                      cityId: draft.cityId,
                      cityName: draft.cityName,
                      enabled: draft.governorateId != null,
                      disabledHint: l10n.selectGovernorateFirst,
                      options: _cityOptions(draft.governorateId),
                      errorText:
                          errorFor(RegFields.cityId) ??
                          errorFor(RegFields.cityName),
                      onRetry: () => ref.invalidate(
                        citiesProvider((
                          countryCode: _countryCode,
                          governorateId: draft.governorateId,
                        )),
                      ),
                      onCitySelected: (id) =>
                          _edit(() => controller.setCity(id)),
                      onCityNameChanged: (name) =>
                          _edit(() => controller.setCityName(name)),
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

                    FilledButton(
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// The contract's selectable year status; `soon` years are hidden.
  static const _activeYear = 'active';

  /// 201 → `/home`; a token/phone failure → restart at `/login`.
  void _handleSubmitOutcome(AppLocalizations l10n) {
    ref.listen(registrationSubmitProvider, (_, next) {
      if (!mounted) return;

      if (next.value != null) {
        context.go('/home');
        // Drop the consumed registrationToken after the frame, so this screen
        // is gone before the draft-null guard could flash the expiry view.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(registrationControllerProvider.notifier).reset();
        });
        return;
      }

      if (next.hasError && restartsRegistration(next.error)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(registrationErrorMessage(l10n, next.error))),
        );
        ref.read(registrationControllerProvider.notifier).reset();
        context.go('/login');
      }
    });
  }

  AsyncValue<List<PickerOption>> _cityOptions(String? governorateId) {
    // Don't fire the request Egypt would 400 on.
    if (governorateId == null) return const AsyncData([]);
    return ref
        .watch(
          citiesProvider((
            countryCode: _countryCode,
            governorateId: governorateId,
          )),
        )
        .whenData(_namedRefRows);
  }

  List<PickerOption> _namedRefRows(List<NamedRef> rows) => [
    for (final row in rows)
      (
        id: row.id,
        label: localizedRefName(context, row.nameAr, row.nameEn),
        leading: null,
      ),
  ];

  UniversityRef? _findUniversity(List<UniversityRef>? rows, String? id) {
    if (rows == null || id == null) return null;
    final matches = rows.where((u) => u.id == id);
    return matches.isEmpty ? null : matches.first;
  }

  FacultyRef? _findFaculty(UniversityRef? university, String? id) {
    if (university == null || id == null) return null;
    final matches = university.faculties.where((f) => f.id == id);
    return matches.isEmpty ? null : matches.first;
  }
}
