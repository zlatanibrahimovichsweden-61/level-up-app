import 'package:freezed_annotation/freezed_annotation.dart';

part 'mistakes_subject.freezed.dart';
part 'mistakes_subject.g.dart';

/// One row of `GET /me/mistakes` — the Mistakes overview.
///
/// Contract keys are already camelCase, so NO `@JsonKey(name:)` bridge is
/// needed and none must be added.
///
/// **Server-scoped, no parameters.** The operation takes no scope value in the
/// path, the query string or a header (`openapi.yaml:876-879`); the server
/// derives everything from the token. If you ever find yourself adding one, the
/// contract is being worked around.
///
/// **The list is pre-ordered** — `name` ascending, then `id`, described as "a
/// stable order the client can render without sorting" (`:901-903`). Do not
/// sort it.
///
/// [name] arrives already in the content language (adr-018), so it is rendered
/// verbatim and never looked up in the ARB.
@freezed
abstract class MistakesSubject with _$MistakesSubject {
  const factory MistakesSubject({
    required String id,
    required String name,

    /// adr-036 term signals. **Optional AND nullable, and null is NORMAL** —
    /// school subjects carry `termId: null` outright (`:903`).
    ///
    /// Modelled exactly as `Subject` models them, and for the same reasons:
    /// `termId` is opaque (adr-026 §7), so never hardcode one and never derive
    /// an order from it; `termNumber` is the only orderable/labellable term
    /// signal on the wire, since term NAMES are never sent (adr-026 §5).
    ///
    /// ⚠️ The contract lists both under `properties` but **not** under
    /// `required` (`:921`), while the `200` description implies the key is
    /// always present. Optional-and-nullable is the tolerant reading and
    /// decodes both shapes identically. Open as `seif_fight.md` **S42**.
    String? termId,
    int? termNumber,

    /// **How many questions the student CURRENTLY has wrong in this subject.**
    ///
    /// Not how many questions the subject has. The contract publishes
    /// `minimum: 1` (`:915-920`) because a subject with zero current mistakes
    /// is **absent from the array entirely, never present with `0`**.
    ///
    /// 🔴 **This decays, and it is deliberately NOT the `mode: retakeWrong`
    /// pool** (adr-133, `:888-893`). It counts a question only while the
    /// student's most recent graded answer to it was wrong; answering it
    /// correctly later removes it immediately. The retake pool is *ever wrong*
    /// and does not decay. **Do not reconcile the two numbers and do not derive
    /// one from the other.**
    ///
    /// It is also computed on every read and never cached, so two requests
    /// seconds apart can legitimately disagree (`:882-886`).
    required int mistakeCount,
  }) = _MistakesSubject;

  factory MistakesSubject.fromJson(Map<String, dynamic> json) =>
      _$MistakesSubjectFromJson(json);
}
