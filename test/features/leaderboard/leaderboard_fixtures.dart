import 'package:level_up_app/features/leaderboard/models/leaderboard_models.dart';
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
