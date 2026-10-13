import 'package:level_up_app/features/friends/models/friend_models.dart';

/// Sample ids. Plain UUID-shaped strings are enough for the data layer - the
/// app treats `studentId` and `requestId` as opaque handles.
const studentIdA = '5f000000-0000-4000-8000-00000000000a';
const studentIdB = '5f000000-0000-4000-8000-00000000000b';
const requestIdA = '5f100000-0000-4000-8000-00000000000a';
const requestIdB = '5f100000-0000-4000-8000-00000000000b';

/// Obviously fake display names. Tests that assert a name never reaches an
/// error detail or a `toString` look for exactly these.
const sampleNameA = 'Sample Student A';
const sampleNameB = 'Sample Student B';

// ---------------------------------------------------------------------------
// Wire shapes - what the server sends, spelled out as the contract does
// ---------------------------------------------------------------------------

/// A `StudentCard` (`openapi.yaml:4665`): name and avatar only.
Map<String, dynamic> wireCard({
  String studentId = studentIdA,
  String name = sampleNameA,
  String avatarUrl = 'https://example.test/avatar-a.png',
}) => {'studentId': studentId, 'name': name, 'avatarUrl': avatarUrl};

/// A `Friend` (`openapi.yaml:4675`). [points] is OMITTED from the map when
/// [hidePoints] is set, which is how the server hides a score; pass
/// [explicitNullPoints] to spell it as a present-but-null key instead.
Map<String, dynamic> wireFriend({
  String studentId = studentIdA,
  String name = sampleNameA,
  String avatarUrl = 'https://example.test/avatar-a.png',
  int level = 4,
  int points = 640,
  bool hidePoints = false,
  bool explicitNullPoints = false,
  String friendsSince = '2026-10-01T09:30:00Z',
}) => {
  'studentId': studentId,
  'name': name,
  'avatarUrl': avatarUrl,
  'level': level,
  if (explicitNullPoints) 'points': null,
  if (!hidePoints && !explicitNullPoints) 'points': points,
  'friendsSince': friendsSince,
};

/// A `FriendRequest` (`openapi.yaml:4693`).
Map<String, dynamic> wireRequest({
  String requestId = requestIdA,
  String direction = 'incoming',
  Map<String, dynamic>? student,
  String createdAt = '2026-10-09T12:00:00Z',
}) => {
  'requestId': requestId,
  'direction': direction,
  'student': student ?? wireCard(),
  'createdAt': createdAt,
};

/// A `CursorPage` envelope. [hasMore] defaults to `false`, so a fixture is a
/// COMPLETE list unless a test deliberately says otherwise.
Map<String, dynamic> wirePage(
  List<Map<String, dynamic>> items, {
  bool hasMore = false,
  String? nextCursor,
}) => {'items': items, 'nextCursor': nextCursor, 'hasMore': hasMore};

// ---------------------------------------------------------------------------
// Models
// ---------------------------------------------------------------------------

StudentCard studentCard({
  String studentId = studentIdA,
  String name = sampleNameA,
  String avatarUrl = 'https://example.test/avatar-a.png',
}) => StudentCard(studentId: studentId, name: name, avatarUrl: avatarUrl);

Friend friend({
  String studentId = studentIdA,
  String name = sampleNameA,
  int level = 4,
  int? points = 640,
}) => Friend(
  studentId: studentId,
  name: name,
  avatarUrl: 'https://example.test/avatar-a.png',
  level: level,
  points: points,
  friendsSince: DateTime.utc(2026, 10, 1, 9, 30),
);
