import 'package:freezed_annotation/freezed_annotation.dart';

import '../../profile/models/student_profile.dart';

part 'leaderboard_models.freezed.dart';
part 'leaderboard_models.g.dart';

/// Which board the student is looking at — contract enum
/// `[system, governorate, cohort, global]` on `GET /leaderboard`.
///
/// The parameter is **required**: there is no "default board", and the server
/// derives the concrete population from the CALLER's registration, so the app
/// never sends anything that identifies another student's board.
///
/// The set is CLOSED and split by track. Asking for the other track's scope is
/// `400 validation_failed`, so the switcher is built from [scopesFor] and can
/// never offer one that would 400.
enum LeaderboardScope {
  system,
  governorate,
  cohort,
  global;

  /// The scopes this student may ask for, in the order the switcher draws them.
  /// The first is the board shown on open.
  ///
  /// `governorate` is an **Egypt-only** sub-scope (contract: *"governorate for
  /// non-EG … `validation_failed`"*), so a school student registered outside
  /// Egypt gets a single-scope list and the switcher hides itself rather than
  /// offering a segment that is guaranteed to fail.
  static List<LeaderboardScope> scopesFor(StudentProfile me) {
    return switch (me.track) {
      Track.school => [
        system,
        if (me.geography.countryCode.toUpperCase() == 'EG') governorate,
      ],
      Track.university => const [global, cohort],
    };
  }

  /// The board a student sees first. The Leaderboard tab opens on it, and
  /// Home's Top Student block shows its top three (owner, API→UI Wave 05,
  /// 2026-09-24) — so both read the SAME `leaderboardProvider` instance and one
  /// request serves the two.
  static LeaderboardScope defaultFor(StudentProfile me) => scopesFor(me).first;

  /// The wire value. `name` already matches the contract's spelling exactly;
  /// this getter exists so call sites read as wire values rather than as Dart
  /// enum names that happen to coincide.
  String get wire => name;
}

/// One row of `GET /leaderboard`.
///
/// **All six fields are `required` in the contract and all six are required
/// here.** In particular `points` is required *because* suppression removes the
/// whole row: a student with `leaderboardVisible: false` or `scoreHidden: true`
/// is excluded before ranking (adr-111), so a row that exists always has a
/// score. There is no "hidden score" row to render.
///
/// There is deliberately **no `level`**. The Figma podium writes
/// "level 7,3000Pts", but the contract carries no level on this endpoint and
/// inventing one would author a number the server never sent. The podium
/// renders [points] only.
///
/// [rank] is the student's exact position in the visible population — NOT an
/// index into the page. Ranks are dense: excluded students are removed before
/// ranking, so the numbers around them close and leave no gap.
///
/// `toString` is redacted to the type name: a row is ANOTHER student's id,
/// name and avatar, and the project rule is that none of them reaches a log, an
/// error detail or a test report by accident (the friends models do the same).
/// Equality is the generated field-by-field one.
@freezed
abstract class LeaderboardEntry with _$LeaderboardEntry {
  const LeaderboardEntry._();

  const factory LeaderboardEntry({
    required int rank,
    required String studentId,
    required String name,
    required String avatarUrl,
    required int points,

    /// The caller's own row. The server decides this — never compare
    /// [studentId] against a locally held id to re-derive it.
    ///
    /// May be true on **no** row at all: the board renders at most the top 200,
    /// so a student ranked below that appears on no page. That is a legal,
    /// expected board, not a bug (see `LeaderboardNotifier`).
    required bool isMe,
  }) = _LeaderboardEntry;

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntryFromJson(json);

  @override
  String toString() => 'LeaderboardEntry(<redacted>)';
}
