import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:level_up_app/features/leaderboard/models/leaderboard_models.dart';
import 'package:level_up_app/features/leaderboard/notifier/leaderboard_notifier.dart';
import 'package:level_up_app/features/leaderboard/repository/leaderboard_repository.dart';
import 'package:level_up_app/features/registration/models/reference_models.dart';

/// One board row. [rank] doubles as the id seed so rows are distinguishable
/// without every test spelling out six fields.
LeaderboardEntry entry(int rank, {bool isMe = false, int? points}) {
  return LeaderboardEntry(
    rank: rank,
    studentId: '0199c0de-0000-7000-8000-00000000000$rank',
    name: 'Student $rank',
    avatarUrl: 'https://cdn.example/avatar/$rank.png',
    // Descending with rank, the way a real board is ordered.
    points: points ?? (1000 - rank * 10),
    isMe: isMe,
  );
}

/// A page of the board.
///
/// [hasMore] defaults to `false` so a fixture is a COMPLETE board unless a test
/// deliberately says otherwise — the short-page and paging tests are the ones
/// that should have to be explicit, not the ordinary ones.
CursorPage<LeaderboardEntry> boardPage({
  required List<int> ranks,
  int? meRank,
  bool hasMore = false,
  String? nextCursor,
}) {
  return CursorPage<LeaderboardEntry>(
    items: [for (final r in ranks) entry(r, isMe: r == meRank)],
    hasMore: hasMore,
    nextCursor: nextCursor,
  );
}

/// A board that answers at once with three rows — for harnesses that render
/// Home only on the way to their own screen. Since API→UI Wave 05 Home's Top
/// Student block reads `GET /leaderboard`; without this a harness would send a
/// real request and leave its timer pending when the test ends.
class QuietLeaderboardRepository implements LeaderboardRepository {
  @override
  Future<CursorPage<LeaderboardEntry>> getLeaderboard({
    required LeaderboardScope scope,
    String? cursor,
    int? limit,
  }) async => boardPage(ranks: const [1, 2, 3]);
}

/// Holds every board for the life of [container], for harnesses that pass
/// through Home without testing it.
///
/// Home's Top Student block watches an `autoDispose` board. When the test
/// binding tears the tree down, the flutter vsync is already gone, so Riverpod
/// schedules that board's disposal on a zero-length `Timer` — which the binding
/// then reports as pending ("A Timer is still pending even after the widget
/// tree was disposed"). A container-level listener keeps the board alive, so
/// no disposal is scheduled; `container.dispose()` in the tear-down releases it.
void holdBoards(ProviderContainer container) {
  for (final scope in LeaderboardScope.values) {
    container.listen(leaderboardProvider(scope), (_, _) {});
  }
}

/// A page carrying no rows while the server still says there is more.
///
/// Contract-legal since 3.7.0-m1: the endpoint bounds the work ONE request
/// does, so a page may return fewer rows than asked for — including zero —
/// while `hasMore` is `true`. This fixture exists so that behaviour is testable
/// at all; it does not reproduce on a small happy-path board.
CursorPage<LeaderboardEntry> shortPage({String nextCursor = 'cursor-2'}) =>
    CursorPage<LeaderboardEntry>(
      items: const [],
      hasMore: true,
      nextCursor: nextCursor,
    );
