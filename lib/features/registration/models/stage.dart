/// The contract's `Stage` enum (`openapi.yaml` → `components.schemas.Stage`):
/// `prep1 | prep2 | prep3 | secondary1 | secondary2 | secondary3`.
///
/// Unlike `EducationSystem` (documented as extensible — "clients must tolerate
/// unknown values", so it stays a `String`), `Stage` is a CLOSED enum in the
/// contract, so a real Dart enum is safe here and gives the Grade dropdown an
/// exhaustive, ordered source.
///
/// The design labels this field "Grade"; the contract calls it `stage`. The
/// glossary term `stage` is used in code, "Grade" only as display copy.
library;

enum Stage {
  prep1,
  prep2,
  prep3,
  secondary1,
  secondary2,
  secondary3;

  /// The wire value submitted as `stage` — identical to the Dart name, which is
  /// exactly how the contract spells each value.
  String get wireValue => name;

  /// Parse a wire value back to a [Stage]; `null` for anything unrecognized so a
  /// stale/unknown draft value can never be silently submitted as valid.
  static Stage? tryParse(String? value) {
    if (value == null) return null;
    for (final stage in Stage.values) {
      if (stage.wireValue == value) return stage;
    }
    return null;
  }
}
