import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/home/screens/home_screen.dart';
import 'package:level_up_app/features/leaderboard/repository/leaderboard_repository.dart';
import 'package:level_up_app/features/notifications/repository/notifications_repository.dart';
import 'package:level_up_app/features/notifications/screens/notifications_screen.dart';
import 'package:level_up_app/features/profile/repository/profile_repository.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import '../leaderboard/leaderboard_fixtures.dart';
import '../notifications/notification_fixtures.dart';
import '../profile/profile_fixtures.dart';

/// The Home bell opens the notifications inbox (CW07a).
///
/// Driven through the REAL router, so the route's registration, its place
/// outside the shell and the auth redirect are exercised rather than assumed.
/// The unread dot stays off — that is `home_header_unread_test.dart`'s subject.

class _MockStorage extends Mock implements SecureStorage {}

class _MockProfileRepository extends Mock implements ProfileRepository {}

class _MockNotificationsRepository extends Mock
    implements NotificationsRepository {}

void main() {
  late _MockStorage storage;
  late _MockProfileRepository profile;
  late _MockNotificationsRepository notifications;

  setUp(() {
    storage = _MockStorage();
    when(() => storage.readAccessToken()).thenAnswer((_) async => 'access');
    when(() => storage.clearTokens()).thenAnswer((_) async {});

    profile = _MockProfileRepository();
    when(profile.getMe).thenAnswer((_) async => schoolProfile());
    when(profile.getEntitlements).thenAnswer((_) async => [baseEntitlement]);

    notifications = _MockNotificationsRepository();
    when(
      () => notifications.listMyNotifications(
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
        category: any(named: 'category'),
      ),
    ).thenAnswer((_) async => inboxPage([announcementItem('1')]));
  });

  Future<ProviderContainer> openHome(
    WidgetTester tester, {
    String language = 'en',
  }) async {
    final container = ProviderContainer(
      overrides: [
        secureStorageProvider.overrideWithValue(storage),
        profileRepositoryProvider.overrideWithValue(profile),
        leaderboardRepositoryProvider.overrideWithValue(
          QuietLeaderboardRepository(),
        ),
        notificationsRepositoryProvider.overrideWithValue(notifications),
        isOnlineProvider.overrideWith((ref) => Stream.value(true)),
      ],
    );
    addTearDown(container.dispose);
    holdBoards(container);
    container.read(authControllerProvider.notifier).markAuthenticated();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          locale: Locale(language),
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: container.read(routerProvider),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    return container;
  }

  /// Where the real router is: `state.uri`, NOT `currentConfiguration.uri`,
  /// which misses an imperative `push`.
  String locationOf(ProviderContainer container) =>
      container.read(routerProvider).state.uri.toString();

  final bell = find.byKey(const Key('home_bell'));

  testWidgets('tapping the bell pushes /notifications, and back returns Home', (
    tester,
  ) async {
    final container = await openHome(tester);
    expect(locationOf(container), '/home');

    await tester.tap(bell);
    await tester.pumpAndSettle();

    expect(locationOf(container), '/notifications');
    expect(find.byType(NotificationsScreen), findsOneWidget);
    // The inbox is a real list, not a placeholder.
    expect(find.text('English title'), findsOneWidget);

    await tester.tap(find.byKey(const Key('notifications_back')));
    await tester.pumpAndSettle();

    expect(locationOf(container), '/home');
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(NotificationsScreen), findsNothing);
  });

  test('/notifications is reachable by a signed-in student only', () {
    // Default-deny: not an auth route, so the redirect needs a session. A
    // signed-out student is sent to /login — and a signed-in one is not.
    expect(
      authRedirect(const AuthUnauthenticated(), '/notifications'),
      '/login',
    );
    expect(authRedirect(const AuthAuthenticated(), '/notifications'), isNull);
  });

  testWidgets('the bell is ONE labelled button, not an image', (tester) async {
    final handle = tester.ensureSemantics();
    await openHome(tester);

    final node = tester.getSemantics(bell);
    expect(node.flagsCollection.isButton, isTrue);
    // The glyph's own image role would turn the node into an ImageView.
    expect(node.flagsCollection.isImage, isFalse);
    expect(node.label, 'Notifications', reason: 'named once');
    handle.dispose();
  });

  test('/notifications is not a shell location, so return-to-target never '
      'remembers it', () {
    // A top-level route outside the StatefulShellRoute: remembered, it would be
    // reopened with `go`, with nothing beneath it and a dead back chip. Read
    // from the real router configuration, not from a list.
    final container = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);
    final configuration = container.read(routerProvider).configuration;

    expect(
      rememberableLocation(configuration, Uri.parse('/notifications')),
      isNull,
    );
    // The control: a shell location IS remembered, so a null above is a
    // reading and not a blanket null.
    expect(rememberableLocation(configuration, Uri.parse('/home')), '/home');
  });

  testWidgets('the bell exposes exactly one node, and it carries the tap', (
    tester,
  ) async {
    // The ring's InkWell used to add a second, unlabelled clickable node inside
    // the labelled button (uiautomator showed it at the ring's bounds).
    final handle = tester.ensureSemantics();
    await openHome(tester);

    final root = tester.getSemantics(bell);
    var nodes = 0;
    final withTap = <SemanticsNode>[];
    void walk(SemanticsNode node) {
      nodes++;
      if (node.getSemanticsData().hasAction(SemanticsAction.tap)) {
        withTap.add(node);
      }
      node.visitChildren((child) {
        walk(child);
        return true;
      });
    }

    walk(root);

    expect(nodes, 1, reason: 'no unlabelled clickable inside the button');
    expect(withTap, [root]);
    expect(root.label, 'Notifications');
    expect(root.flagsCollection.isButton, isTrue);
    handle.dispose();
  });

  testWidgets('the bell is named in Arabic', (tester) async {
    final handle = tester.ensureSemantics();
    await openHome(tester, language: 'ar');

    expect(tester.getSemantics(bell).label, 'الإشعارات');
    handle.dispose();
  });

  for (final language in ['en', 'ar']) {
    testWidgets('the target is 48 x 48 around the 37 chip, which stays flush '
        'to the end edge · $language', (tester) async {
      await openHome(tester, language: language);

      final target = tester.getRect(bell);
      expect(target.width, 48);
      expect(target.height, 48);

      // The drawn ring (36.5, inside the 37 box) did not move: the box is
      // flush to the END edge and centred vertically, which is what keeps the
      // two header goldens identical.
      final ring = tester.getRect(
        find.descendant(of: bell, matching: find.byType(ElevatedSurface)),
      );
      expect(ring.size, const Size(36.5, 36.5));
      expect(ring.center.dy, closeTo(target.center.dy, 0.01));
      if (language == 'en') {
        expect(target.right - ring.right, closeTo(0.25, 0.01));
      } else {
        expect(ring.left - target.left, closeTo(0.25, 0.01));
      }
    });
  }

  testWidgets('a tap in the slack around the chip still opens the inbox', (
    tester,
  ) async {
    final container = await openHome(tester);

    // The 48 target's start edge, 5 inside it: outside the drawn 37 chip.
    final target = tester.getRect(bell);
    await tester.tapAt(Offset(target.left + 5, target.center.dy));
    await tester.pumpAndSettle();

    expect(locationOf(container), '/notifications');
  });
}
