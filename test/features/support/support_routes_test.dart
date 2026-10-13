import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/account_shells/screens/customer_support_screen.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/home/screens/home_screen.dart';
import 'package:level_up_app/features/leaderboard/repository/leaderboard_repository.dart';
import 'package:level_up_app/features/notifications/repository/notifications_repository.dart';
import 'package:level_up_app/features/profile/repository/profile_repository.dart';
import 'package:level_up_app/features/support/repository/support_repository.dart';
import 'package:level_up_app/features/support/screens/create_support_ticket_screen.dart';
import 'package:level_up_app/features/support/screens/support_ticket_screen.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import '../leaderboard/leaderboard_fixtures.dart';
import '../notifications/notification_fixtures.dart';
import '../profile/profile_fixtures.dart';
import 'support_fixtures.dart';

class _MockStorage extends Mock implements SecureStorage {}

class _MockProfileRepository extends Mock implements ProfileRepository {}

class _MockNotificationsRepository extends Mock
    implements NotificationsRepository {}

class _MockSupportRepository extends Mock implements SupportRepository {}

/// The support routes (CW12a): `/support`, `/support/new` and
/// `/support/tickets/:ticketId`.
///
/// Driven through the REAL router, so the table's registration, its place
/// outside the shell and the auth redirect are exercised rather than assumed.
void main() {
  late _MockStorage storage;
  late _MockProfileRepository profile;
  late _MockNotificationsRepository notifications;
  late _MockSupportRepository support;

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

    support = _MockSupportRepository();
    when(
      () => support.listMySupportTickets(cursor: any(named: 'cursor')),
    ).thenAnswer(
      (_) async => ticketsPage([
        ticketSummary(ticketIdA, reference: 'TK-1', subject: 'First question'),
      ]),
    );
    when(() => support.getMySupportTicket(any())).thenAnswer(
      (invocation) async => ticketDetail(
        invocation.positionalArguments.single as String,
        subject: 'First question',
        details: 'The details',
      ),
    );
    when(
      () => support.listMySupportTicketMessages(
        any(),
        cursor: any(named: 'cursor'),
      ),
    ).thenAnswer((_) async => messagesPage([]));
  });

  Future<ProviderContainer> openApp(
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
        supportRepositoryProvider.overrideWithValue(support),
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

  RouteConfiguration configurationOf() {
    final container = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);
    return container.read(routerProvider).configuration;
  }

  group('the table', () {
    for (final path in ['/support', '/support/new', '/support/tickets/x']) {
      test('$path is a route', () {
        final match = configurationOf().findMatch(Uri.parse(path));
        expect(match.isError, isFalse);
      });
    }

    test('the two new routes sit OUTSIDE the shell, like /support', () {
      final configuration = configurationOf();
      for (final path in ['/support', '/support/new', '/support/tickets/x']) {
        final match = configuration.findMatch(Uri.parse(path));
        expect(
          match.routes.whereType<StatefulShellRoute>(),
          isEmpty,
          reason: '$path must not be a shell branch',
        );
      }
      // The control: a shell location IS inside it, so the empty lists above
      // are a reading and not a blanket result.
      expect(
        configuration
            .findMatch(Uri.parse('/home'))
            .routes
            .whereType<StatefulShellRoute>(),
        isNotEmpty,
      );
    });

    test('return-to-target never remembers a support location', () {
      final configuration = configurationOf();
      for (final path in [
        '/support',
        '/support/new',
        '/support/tickets/x',
        '/support/tickets/5c000000-0000-4000-8000-00000000000a',
      ]) {
        expect(
          rememberableLocation(configuration, Uri.parse(path)),
          isNull,
          reason: path,
        );
      }
      // The control: a shell location is remembered.
      expect(rememberableLocation(configuration, Uri.parse('/home')), '/home');
    });

    test('they are reachable by a signed-in student only', () {
      // Default-deny: not auth routes, so the redirect needs a session. A
      // signed-out student is sent to /login, a signed-in one is not.
      for (final path in ['/support', '/support/new', '/support/tickets/x']) {
        expect(
          authRedirect(const AuthUnauthenticated(), path),
          '/login',
          reason: path,
        );
        expect(authRedirect(const AuthAuthenticated(), path), isNull);
      }
    });
  });

  group('through the real router', () {
    testWidgets('/support/new resolves to the create screen, without a nav '
        'bar', (tester) async {
      final container = await openApp(tester);

      container.read(routerProvider).push('/support/new');
      await tester.pumpAndSettle();

      expect(locationOf(container), '/support/new');
      expect(find.byType(CreateSupportTicketScreen), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(CreateSupportTicketScreen),
          matching: find.byType(NavigationBar),
        ),
        findsNothing,
      );
      // And it is pushed over Home: Back lands on Home.
      await tester.tap(find.byKey(const Key('support_new_back')));
      await tester.pumpAndSettle();
      expect(locationOf(container), '/home');
    });

    testWidgets('/support/tickets/x resolves to the thread for "x"', (
      tester,
    ) async {
      final container = await openApp(tester);

      container.read(routerProvider).push('/support/tickets/x');
      await tester.pumpAndSettle();

      expect(locationOf(container), '/support/tickets/x');
      final screen = tester.widget<SupportTicketScreen>(
        find.byType(SupportTicketScreen),
      );
      expect(screen.ticketId, 'x');
      verify(() => support.getMySupportTicket('x')).called(1);
      expect(find.text('First question'), findsOneWidget);
    });

    testWidgets('the id is decoded from the path: an encoded id reaches the '
        'repository whole', (tester) async {
      final container = await openApp(tester);

      container.read(routerProvider).push('/support/tickets/a%20b');
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<SupportTicketScreen>(find.byType(SupportTicketScreen))
            .ticketId,
        'a b',
      );
      verify(() => support.getMySupportTicket('a b')).called(1);
    });

    testWidgets('list, card, form, back; list, row, thread, back', (
      tester,
    ) async {
      final container = await openApp(tester);
      final router = container.read(routerProvider);

      router.push('/support');
      await tester.pumpAndSettle();
      expect(locationOf(container), '/support');
      expect(find.byType(CustomerSupportScreen), findsOneWidget);
      expect(find.text('First question'), findsOneWidget);

      await tester.tap(find.byKey(const Key('support_create_card')));
      await tester.pumpAndSettle();
      expect(locationOf(container), '/support/new');

      await tester.tap(find.byKey(const Key('support_new_back')));
      await tester.pumpAndSettle();
      expect(locationOf(container), '/support');

      await tester.tap(find.byKey(Key('support_ticket_row_$ticketIdA')));
      await tester.pumpAndSettle();
      expect(locationOf(container), '/support/tickets/$ticketIdA');
      expect(find.text('The details'), findsOneWidget);

      await tester.tap(find.byKey(const Key('support_thread_back')));
      await tester.pumpAndSettle();
      expect(locationOf(container), '/support');

      await tester.tap(find.byKey(const Key('support_back')));
      await tester.pumpAndSettle();
      expect(locationOf(container), '/home');
    });

    testWidgets('a signed-out session is sent to /login from the new routes', (
      tester,
    ) async {
      final container = await openApp(tester);

      await container
          .read(authControllerProvider.notifier)
          .forceLogout(LogoutReason.sessionExpired);
      container.read(routerProvider).go('/support/new');
      await tester.pumpAndSettle();

      expect(locationOf(container), '/login');
      expect(find.byType(CreateSupportTicketScreen), findsNothing);
    });
  });
}
