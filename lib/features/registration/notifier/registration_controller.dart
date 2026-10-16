import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/reference_models.dart';
import '../models/registration_args.dart';
import '../models/registration_draft.dart';

/// The registration spine. Holds the [RegistrationDraft] accumulated across the
/// wizard (identity → track → Day-3 field screens) plus the token deadline.
///
/// State is nullable: `null` = no registration in progress. It is seeded from
/// the OTP `registrationRequired` fork via [start] and mutated step by step;
/// Day 3 adds the geography/academic setters and the final `POST /auth/register`.
///
/// This is sync, mixed state (not fetch-on-build), so a plain [Notifier] — not
/// an AsyncNotifier — is the right tool.
class RegistrationController extends Notifier<RegistrationDraft?> {
  @override
  RegistrationDraft? build() => null;

  /// Seed a fresh draft from the OTP step. Idempotent on re-entry: if a draft
  /// for the SAME token already exists (e.g. navigating back to the identity
  /// screen), the accumulated fields are preserved rather than reset. A new
  /// token (a fresh OTP verify) starts a clean draft.
  void start(RegistrationArgs args) {
    final current = state;
    if (current != null &&
        current.registrationToken == args.registrationToken) {
      return;
    }
    state = RegistrationDraft(
      registrationToken: args.registrationToken,
      tokenExpiresAt: DateTime.now().add(
        Duration(seconds: args.expiresInSeconds),
      ),
      phone: args.phone,
    );
  }

  /// Sign Up_1 → store identity. `referralCode` is collected but never submitted
  /// (conflict #1). No-op if there is no active draft.
  void setIdentity({
    required String name,
    required String parentPhone,
    String? referralCode,
  }) {
    final draft = state;
    if (draft == null) return;
    state = draft.copyWith(
      name: name,
      parentPhone: parentPhone,
      referralCode: referralCode,
    );
  }

  /// Sign Up_2 → set the track discriminator. No-op if there is no active draft.
  void setTrack(RegTrack track) {
    final draft = state;
    if (draft == null) return;
    state = draft.copyWith(track: track);
  }

  /// Day-3 · date of birth. Contract-required on BOTH tracks but absent from
  /// both Figma frames — see docs/DESIGN_ISSUES.md #2.
  void setDateOfBirth(DateTime dateOfBirth) =>
      _update((draft) => draft.copyWith(dateOfBirth: dateOfBirth));

  // --- School geography cascade (adr-010) ---------------------------------
  //
  // Each setter CLEARS everything downstream of it. This is what makes the
  // "forbidden" half of the conditionality unreachable: switching EG → UAE must
  // not leave a governorate/school id behind, or the body would carry a field
  // the server forbids. The body factory hard-nulls them too (belt and braces),
  // but clearing here is what keeps the visible form honest.
  //
  // The school is one answer in three fields — the id, the picked row and the
  // skip — and every setter that drops the id drops all three: the school is
  // scoped by city, so a new place means a new question (BUG-027).

  /// Country picked. [requiresGovernorate] comes from the country row itself
  /// (`GET /reference/countries`) — the adr-010 switch. Changing country resets
  /// the whole geography branch, since governorates/cities/schools are all
  /// scoped to it.
  void setCountry({
    required String countryCode,
    required bool requiresGovernorate,
  }) {
    _update((draft) {
      if (draft.countryCode == countryCode) return draft;
      return draft.copyWith(
        countryCode: countryCode,
        requiresGovernorate: requiresGovernorate,
        governorateId: null,
        cityId: null,
        cityName: null,
        schoolId: null,
        pickedSchool: null,
        schoolSkipped: false,
      );
    });
  }

  /// Governorate picked (EG only) — cities and schools are filtered by it.
  void setGovernorate(String governorateId) {
    _update((draft) {
      if (draft.governorateId == governorateId) return draft;
      return draft.copyWith(
        governorateId: governorateId,
        cityId: null,
        schoolId: null,
        pickedSchool: null,
        schoolSkipped: false,
      );
    });
  }

  /// Coded city picked — the school search is filtered by it. Clears the
  /// free-text half of the adr-028 §1 union: the two are never both populated,
  /// which is what makes `cityUnionFromDraft`'s "both → throw" unreachable.
  void setCity(String cityId) {
    _update((draft) {
      if (draft.cityId == cityId && draft.cityName == null) return draft;
      return draft.copyWith(
        cityId: cityId,
        cityName: null,
        schoolId: null,
        pickedSchool: null,
        schoolSkipped: false,
      );
    });
  }

  /// adr-028 §1 — the "my city isn't listed" fallback. Blank normalizes to null
  /// so the key is omitted from the body rather than sent empty.
  ///
  /// Clears `cityId` (the other half of the union) AND `schoolId`: the school
  /// search is scoped by city, so an uncoded city invalidates a school that was
  /// chosen under the coded one.
  void setCityName(String? cityName) {
    final trimmed = cityName?.trim();
    final normalized = (trimmed == null || trimmed.isEmpty) ? null : trimmed;
    _update(
      (draft) => draft.copyWith(
        cityName: normalized,
        cityId: null,
        schoolId: null,
        pickedSchool: null,
        schoolSkipped: false,
      ),
    );
  }

  /// EG: the coded school id from the searchable list. Optional since adr-028
  /// §2 — a student who cannot find their school simply never calls this.
  ///
  /// [row] is the picked row itself, kept so the School form can show the
  /// school's NAME again when the student comes back to it (BUG-027); without
  /// it the field can only show the search hint. Only the id is submitted.
  /// Picking un-skips.
  void setSchool(String schoolId, {NamedRef? row}) => _update(
    (draft) => draft.copyWith(
      schoolId: schoolId,
      pickedSchool: row,
      schoolSkipped: false,
    ),
  );

  /// adr-028 §2 — "I can't find my school". Drops any previously-picked id so
  /// the body omits `schoolId` entirely, and records that the student answered
  /// rather than just left it blank.
  void skipSchool() => _update(
    (draft) =>
        draft.copyWith(schoolId: null, pickedSchool: null, schoolSkipped: true),
  );

  // --- School academic -----------------------------------------------------

  /// The design labels this "Grade"; the contract field is `stage`.
  void setStage(String stage) =>
      _update((draft) => draft.copyWith(stage: stage));

  /// The wire `code` from `GET /reference/education-systems`, submitted verbatim
  /// (the enum is extensible — unknown values are tolerated, never re-mapped).
  void setEducationSystem(String educationSystem) =>
      _update((draft) => draft.copyWith(educationSystem: educationSystem));

  /// Forget the chosen stage: the server says it is not open for registration
  /// (`status: soon`, or a `422 school_stage_not_available`). No-op without a
  /// draft. Nothing else on the draft moves, and the token stays.
  void clearStage() => _update((draft) => draft.copyWith(stage: null));

  /// Forget the chosen education system, for the same reason as [clearStage]
  /// (`422 education_system_not_available`). No-op without a draft.
  void clearEducationSystem() =>
      _update((draft) => draft.copyWith(educationSystem: null));

  // --- University cascade (university → faculty → year) --------------------

  /// Faculties belong to a university, so changing it invalidates faculty+year.
  void setUniversity(String universityId) {
    _update((draft) {
      if (draft.universityId == universityId) return draft;
      return draft.copyWith(
        universityId: universityId,
        facultyId: null,
        studyYearId: null,
      );
    });
  }

  /// Years belong to a faculty, so changing it invalidates the year.
  void setFaculty(String facultyId) {
    _update((draft) {
      if (draft.facultyId == facultyId) return draft;
      return draft.copyWith(facultyId: facultyId, studyYearId: null);
    });
  }

  /// Must be an `active` year — `soon` years are never offered by the picker
  /// (the server answers `validation_failed` for them).
  void setStudyYear(String studyYearId) =>
      _update((draft) => draft.copyWith(studyYearId: studyYearId));

  /// The server refused [name] with `422 name_not_allowed`. Recorded only on
  /// the draft of the [registrationToken] it was submitted with: a refusal that
  /// lands after that draft was dropped or replaced belongs to no one now.
  void refuseName({required String registrationToken, required String name}) {
    _update((draft) {
      if (draft.registrationToken != registrationToken) return draft;
      if (draft.refusedNames.contains(name)) return draft;
      return draft.copyWith(refusedNames: {...draft.refusedNames, name});
    });
  }

  /// Abandon the registration (e.g. token expired, or user backs out to login).
  void reset() => state = null;

  /// Apply [change] to the active draft; no-op when there is none.
  void _update(RegistrationDraft Function(RegistrationDraft draft) change) {
    final draft = state;
    if (draft == null) return;
    state = change(draft);
  }
}

final registrationControllerProvider =
    NotifierProvider<RegistrationController, RegistrationDraft?>(
      RegistrationController.new,
    );
