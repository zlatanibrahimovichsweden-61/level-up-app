import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/features/account_shells/screens/customer_support_screen.dart';
import 'package:level_up_app/features/registration/models/reference_models.dart';
import 'package:level_up_app/features/support/models/support_models.dart';
import 'package:level_up_app/features/support/repository/support_repository.dart';
import 'package:level_up_app/features/support/screens/create_support_ticket_screen.dart';
import 'package:level_up_app/features/support/screens/support_ticket_screen.dart';
import 'package:level_up_app/features/support/widgets/support_closed_pill.dart';
import 'package:level_up_app/features/support/widgets/support_ticket_row.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import 'support_fixtures.dart';

class _MockRepo extends Mock implements SupportRepository {}

/// The support list · `CustomerSupportScreen` · Figma `178:2800`.
///
/// The four states in English and Arabic, the rows and the one pill, paging,
/// both destinations, RTL, both canvases, text scale, semantics and the
/// accessibility guidelines.
///
/// The widget tests run on the test font, whose glyph widths are far from
/// Inter's: they assert STRUCTURE, text, direction and sizes that do not depend
/// on glyph width, never pixel widths of text.
void main() {
  late _MockRepo repo;

  setUp(() {
    repo = _MockRepo();
  });

  When<Future<CursorPage<SupportTicketSummary>>> listCall({String? cursor}) =>
      when(() => repo.listMySupportTickets(cursor: cursor));

  VerificationResult verifyList({String? cursor}) =>
      verify(() => repo.listMySupportTickets(cursor: cursor));

  /// Mounts the list under a router that knows the three support paths, the
  /// way the app's own table does, with a stub underneath so Back has
  /// somewhere to go. Returns the router so a test can read where it is.
  Future<GoRouter> pumpList(
    WidgetTester tester, {
    String language = 'en',
    Brightness brightness = Brightness.light,
    TextScaler textScaler = TextScaler.noScaling,
    Size size = const Size(402, 1200),
  }) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final router = GoRouter(
      initialLocation: '/start',
      routes: [
        GoRoute(
          path: '/start',
          builder: (_, _) => const Scaffold(body: Text('start')),
        ),
        GoRoute(
          path: '/support',
          builder: (_, _) => const CustomerSupportScreen(),
        ),
        GoRoute(
          path: '/support/new',
          builder: (_, _) => const CreateSupportTicketScreen(),
        ),
        GoRoute(
          path: '/support/tickets/:ticketId',
          builder: (_, state) =>
              SupportTicketScreen(ticketId: state.pathParameters['ticketId']!),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [supportRepositoryProvider.overrideWithValue(repo)],
        child: MaterialApp.router(
          routerConfig: router,
          locale: Locale(language),
          theme: brightness == Brightness.light
              ? AppTheme.light
              : AppTheme.dark,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: textScaler),
            child: child!,
          ),
        ),
      ),
    );
    await tester.pump();

    router.push('/support');
    // The route transition, then the build future, then a second frame
    // because a REJECTED future reaches the widget a microtask later.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();
    return router;
  }

  Future<AppLocalizations> l10nFor(String language) =>
      AppLocalizations.delegate.load(Locale(language));

  Finder rowFor(String id) => find.byKey(Key('support_ticket_row_$id'));
  final card = find.byKey(const Key('support_create_card'));
  final retry = find.byKey(const Key('support_retry'));

  String location(GoRouter router) => router.state.uri.toString();

  const languages = ['en', 'ar'];

  // -------------------------------------------------------------------------
  group('the four states', () {
    for (final language in languages) {
      group(language, () {
        testWidgets('loading: a spinner, with the create card above it', (
          tester,
        ) async {
          final l10n = await l10nFor(language);
          final pending = Completer<CursorPage<SupportTicketSummary>>();
          listCall().thenAnswer((_) => pending.future);

          await pumpList(tester, language: language);

          expect(find.byType(CircularProgressIndicator), findsOneWidget);
          expect(card, findsOneWidget);
          expect(find.text(l10n.supportRecentTickets), findsOneWidget);
          expect(find.byType(SupportTicketRow), findsNothing);

          pending.complete(ticketsPage([]));
          await tester.pump();
        });

        testWidgets('empty: nothingHere, the card stays, no Retry', (
          tester,
        ) async {
          final l10n = await l10nFor(language);
          listCall().thenAnswer((_) async => ticketsPage([]));

          await pumpList(tester, language: language);

          expect(find.text(l10n.nothingHere), findsOneWidget);
          expect(card, findsOneWidget);
          expect(find.text(l10n.supportRecentTickets), findsOneWidget);
          expect(retry, findsNothing);
          expect(find.byType(SupportTicketRow), findsNothing);
        });

        testWidgets('a first page with no rows but hasMore is NOT empty', (
          tester,
        ) async {
          final l10n = await l10nFor(language);
          listCall().thenAnswer(
            (_) async => ticketsPage([], hasMore: true, nextCursor: 'c2'),
          );

          await pumpList(tester, language: language);

          expect(find.text(l10n.nothingHere), findsNothing);
          expect(find.byKey(const Key('support_load_more')), findsOneWidget);
        });

        testWidgets('error: genericError, the card stays, a Retry that '
            're-asks', (tester) async {
          final l10n = await l10nFor(language);
          listCall().thenAnswer(
            (_) async => throw const ApiException(
              status: 500,
              code: 'internal_server_error',
            ),
          );

          await pumpList(tester, language: language);

          expect(find.text(l10n.genericError), findsOneWidget);
          expect(card, findsOneWidget);
          expect(retry, findsOneWidget);

          listCall().thenAnswer(
            (_) async => ticketsPage([ticketSummary(ticketIdA)]),
          );
          await tester.tap(retry);
          await tester.pump();
          await tester.pump();

          expect(find.byType(SupportTicketRow), findsOneWidget);
          expect(find.text(l10n.genericError), findsNothing);
          verifyList().called(2);
        });

        testWidgets('offline: its own copy, the card stays, a Retry', (
          tester,
        ) async {
          final l10n = await l10nFor(language);
          listCall().thenAnswer((_) async => throw const OfflineException());

          await pumpList(tester, language: language);

          expect(find.text(l10n.offline), findsOneWidget);
          expect(find.text(l10n.genericError), findsNothing);
          expect(card, findsOneWidget);
          expect(retry, findsOneWidget);

          listCall().thenAnswer(
            (_) async => ticketsPage([ticketSummary(ticketIdA)]),
          );
          await tester.tap(retry);
          await tester.pump();
          await tester.pump();

          expect(find.byType(SupportTicketRow), findsOneWidget);
        });

        testWidgets('pending deletion: its own copy and NO Retry, nothing '
            're-asked', (tester) async {
          final l10n = await l10nFor(language);
          listCall().thenAnswer(
            (_) async => throw const ApiException(
              status: 403,
              code: 'account_pending_deletion',
            ),
          );

          await pumpList(tester, language: language);

          expect(find.text(l10n.accountPendingDeletion), findsOneWidget);
          expect(find.text(l10n.genericError), findsNothing);
          expect(retry, findsNothing);
          expect(find.text(l10n.retry), findsNothing);
          verifyList().called(1);
        });

        testWidgets('rate limited: it says so, and no Retry to hammer it '
            'with', (tester) async {
          final l10n = await l10nFor(language);
          listCall().thenAnswer(
            (_) async => throw const RateLimitedException(),
          );

          await pumpList(tester, language: language);

          expect(find.text(l10n.rateLimited), findsOneWidget);
          expect(find.text(l10n.genericError), findsNothing);
          expect(retry, findsNothing);
        });

        testWidgets('rate limited with a Retry-After: rateLimitedIn(seconds)', (
          tester,
        ) async {
          final l10n = await l10nFor(language);
          listCall().thenAnswer(
            (_) async => throw const RateLimitedException(
              retryAfter: Duration(seconds: 120),
            ),
          );

          await pumpList(tester, language: language);

          expect(find.text(l10n.rateLimitedIn(120)), findsOneWidget);
          expect(find.text(l10n.genericError), findsNothing);
          expect(retry, findsNothing);
        });
      });
    }
  });

  // -------------------------------------------------------------------------
  group('the rows', () {
    testWidgets('a row shows the subject in full, then TK-n · yyyy-MM-dd', (
      tester,
    ) async {
      const subject =
          'A long subject that a student wrote about not being able to open '
          'a lecture after the update, kept whole because nothing else shows it';
      listCall().thenAnswer(
        (_) async => ticketsPage([
          ticketSummary(
            ticketIdA,
            reference: 'TK-1042',
            subject: subject,
            createdAt: DateTime.utc(2026, 10, 9, 12),
          ),
        ]),
      );

      await pumpList(tester);

      // In full: not cut to one line, not elided.
      final text = tester.widget<Text>(find.text(subject));
      expect(text.maxLines, isNull);
      expect(text.overflow, isNot(TextOverflow.ellipsis));
      final date = DateFormat(
        'yyyy-MM-dd',
        'en',
      ).format(DateTime.utc(2026, 10, 9, 12).toLocal());
      expect(find.text('TK-1042 · $date'), findsOneWidget);
    });

    testWidgets('the date is formatted in the UI\'s locale · ar', (
      tester,
    ) async {
      final l10n = await l10nFor('ar');
      final created = DateTime.utc(2026, 10, 9, 12);
      listCall().thenAnswer(
        (_) async => ticketsPage([
          ticketSummary(ticketIdA, reference: 'TK-7', createdAt: created),
        ]),
      );

      await pumpList(tester, language: 'ar');

      final date = DateFormat('yyyy-MM-dd', 'ar').format(created.toLocal());
      expect(find.text(l10n.supportTicketMeta('TK-7', date)), findsOneWidget);
    });

    testWidgets('only a CLOSED ticket gets a pill; open, in_progress, pending '
        'and an unknown status get none', (tester) async {
      listCall().thenAnswer(
        (_) async => ticketsPage([
          ticketSummary('t-open', status: 'open'),
          ticketSummary('t-progress', status: 'in_progress'),
          ticketSummary('t-pending', status: 'pending'),
          ticketSummary('t-closed', status: 'closed'),
          // A value this build predates: "in progress, not closed".
          ticketSummary('t-escalated', status: 'escalated'),
        ]),
      );

      await pumpList(tester);

      expect(find.byType(SupportClosedPill), findsOneWidget);
      expect(
        find.byKey(const Key('support_status_pill_t-closed')),
        findsOneWidget,
      );
      for (final id in ['t-open', 't-progress', 't-pending', 't-escalated']) {
        expect(
          find.descendant(
            of: rowFor(id),
            matching: find.byType(SupportClosedPill),
          ),
          findsNothing,
          reason: id,
        );
      }
      // The pill's text is the approved Closed, and no other status word is
      // drawn anywhere (no approved copy exists for them).
      expect(find.text('Closed'), findsOneWidget);
      for (final word in ['Open', 'In progress', 'Pending']) {
        expect(find.text(word), findsNothing, reason: word);
      }
    });

    testWidgets('the pill is shown in Arabic UI as the English fallback', (
      tester,
    ) async {
      // CW12a copy register: no approved Arabic exists, so the Arabic UI shows
      // the English text rather than an unapproved translation.
      listCall().thenAnswer(
        (_) async => ticketsPage([ticketSummary('t-closed', status: 'closed')]),
      );

      await pumpList(tester, language: 'ar');

      expect(find.text('Closed'), findsOneWidget);
    });

    testWidgets('the reference is a label: the row is keyed and routed by the '
        'ticketId', (tester) async {
      listCall().thenAnswer(
        (_) async => ticketsPage([
          ticketSummary(ticketIdA, reference: 'TK-1'),
          ticketSummary(ticketIdB, reference: 'TK-2'),
        ]),
      );
      await pumpList(tester);

      expect(rowFor(ticketIdA), findsOneWidget);
      expect(rowFor(ticketIdB), findsOneWidget);
      expect(find.byKey(const Key('support_ticket_row_TK-1')), findsNothing);
    });

    testWidgets('a one-line open row is the frame\'s 75.315 high (178:3104), '
        'its content centred in it', (tester) async {
      listCall().thenAnswer(
        (_) async => ticketsPage([ticketSummary(ticketIdA, subject: 'Short')]),
      );

      await pumpList(tester);

      final row = tester.getRect(rowFor(ticketIdA));
      expect(row.height, closeTo(75.315, 0.01));
      // The text column is centred in the row, not hung from the top padding.
      final column = tester.getRect(
        find.descendant(of: rowFor(ticketIdA), matching: find.byType(Column)),
      );
      expect(column.center.dy, closeTo(row.center.dy, 0.01));
    });

    testWidgets('a wrapped subject grows the row past the minimum', (
      tester,
    ) async {
      listCall().thenAnswer(
        (_) async => ticketsPage([
          ticketSummary(
            ticketIdA,
            subject:
                'A very long subject that has to wrap over several lines on '
                    'a phone-width screen, ' *
                3,
          ),
        ]),
      );

      await pumpList(tester);

      expect(
        tester.getSize(rowFor(ticketIdA)).height,
        greaterThan(75.315 + 20),
      );
    });

    testWidgets('a closed row puts 8 between the text and the pill '
        '(gap-[8px], 178:3105)', (tester) async {
      listCall().thenAnswer(
        (_) async => ticketsPage([
          ticketSummary(ticketIdA, subject: 'Short', status: 'closed'),
        ]),
      );

      await pumpList(tester);

      final column = tester.getRect(
        find.descendant(of: rowFor(ticketIdA), matching: find.byType(Column)),
      );
      final pill = tester.getRect(
        find.descendant(
          of: rowFor(ticketIdA),
          matching: find.byType(SupportClosedPill),
        ),
      );
      expect(pill.left - column.right, closeTo(8, 0.01));
    });
  });

  // -------------------------------------------------------------------------
  group('paging', () {
    for (final language in languages) {
      testWidgets('Load more appends the next page · $language', (
        tester,
      ) async {
        final l10n = await l10nFor(language);
        listCall().thenAnswer(
          (_) async => ticketsPage(
            [ticketSummary(ticketIdA, reference: 'TK-1')],
            hasMore: true,
            nextCursor: 'c2',
          ),
        );
        listCall(cursor: 'c2').thenAnswer(
          (_) async =>
              ticketsPage([ticketSummary(ticketIdB, reference: 'TK-2')]),
        );

        await pumpList(tester, language: language);
        expect(find.byType(SupportTicketRow), findsOneWidget);
        expect(find.text(l10n.loadMore), findsOneWidget);

        await tester.tap(find.byKey(const Key('support_load_more')));
        await tester.pump();
        await tester.pump();

        expect(find.byType(SupportTicketRow), findsNWidgets(2));
        expect(rowFor(ticketIdB), findsOneWidget);
        // Finished: the button is gone, and nothing takes its place.
        expect(find.text(l10n.loadMore), findsNothing);
        verifyList(cursor: 'c2').called(1);
      });
    }

    testWidgets('hasMore with no cursor offers no Load more to tap', (
      tester,
    ) async {
      listCall().thenAnswer(
        (_) async => ticketsPage([ticketSummary(ticketIdA)], hasMore: true),
      );

      await pumpList(tester);

      expect(find.byType(SupportTicketRow), findsOneWidget);
      expect(find.byKey(const Key('support_load_more')), findsNothing);
    });

    testWidgets('a failed append keeps the rows and offers its own Retry', (
      tester,
    ) async {
      listCall().thenAnswer(
        (_) async => ticketsPage(
          [ticketSummary(ticketIdA)],
          hasMore: true,
          nextCursor: 'c2',
        ),
      );
      listCall(cursor: 'c2').thenAnswer(
        (_) async => throw const ApiException(
          status: 500,
          code: 'internal_server_error',
        ),
      );

      await pumpList(tester);
      await tester.tap(find.byKey(const Key('support_load_more')));
      await tester.pump();
      await tester.pump();

      // The page on screen survives; the whole list is NOT an error.
      expect(find.byType(SupportTicketRow), findsOneWidget);
      expect(
        find.text('Something went wrong. Please try again.'),
        findsNothing,
      );
      expect(find.byKey(const Key('support_append_retry')), findsOneWidget);

      listCall(
        cursor: 'c2',
      ).thenAnswer((_) async => ticketsPage([ticketSummary(ticketIdB)]));
      await tester.tap(find.byKey(const Key('support_append_retry')));
      await tester.pump();
      await tester.pump();

      expect(find.byType(SupportTicketRow), findsNWidgets(2));
      expect(find.byKey(const Key('support_append_retry')), findsNothing);
      verifyList(cursor: 'c2').called(2);
    });

    testWidgets('a rate-limited append keeps its text and offers no button', (
      tester,
    ) async {
      final l10n = await l10nFor('en');
      listCall().thenAnswer(
        (_) async => ticketsPage(
          [ticketSummary(ticketIdA)],
          hasMore: true,
          nextCursor: 'c2',
        ),
      );
      listCall(
        cursor: 'c2',
      ).thenAnswer((_) async => throw const RateLimitedException());

      await pumpList(tester);
      await tester.tap(find.byKey(const Key('support_load_more')));
      await tester.pump();
      await tester.pump();

      expect(find.byType(SupportTicketRow), findsOneWidget);
      expect(find.text(l10n.rateLimited), findsOneWidget);
      expect(find.text(l10n.genericError), findsNothing);
      expect(find.byKey(const Key('support_append_retry')), findsNothing);
      expect(find.byKey(const Key('support_load_more')), findsNothing);
      verifyList(cursor: 'c2').called(1);
    });
  });

  // -------------------------------------------------------------------------
  group('navigation', () {
    testWidgets('a row tap goes to /support/tickets/<ticketId>', (
      tester,
    ) async {
      listCall().thenAnswer(
        (_) async => ticketsPage([
          ticketSummary(ticketIdA, reference: 'TK-1'),
          ticketSummary(ticketIdB, reference: 'TK-2'),
        ]),
      );
      final router = await pumpList(tester);
      expect(location(router), '/support');

      // The thread's own requests are not under test here.
      when(
        () => repo.getMySupportTicket(any()),
      ).thenAnswer((_) async => ticketDetail(ticketIdB, reference: 'TK-2'));
      when(
        () => repo.listMySupportTicketMessages(
          any(),
          cursor: any(named: 'cursor'),
        ),
      ).thenAnswer((_) async => messagesPage([]));

      await tester.tap(rowFor(ticketIdB));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(location(router), '/support/tickets/$ticketIdB');
      expect(find.byType(SupportTicketScreen), findsOneWidget);
    });

    testWidgets('the card goes to /support/new, in every state', (
      tester,
    ) async {
      listCall().thenAnswer((_) async => ticketsPage([]));
      final router = await pumpList(tester);

      await tester.tap(card);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(location(router), '/support/new');
      expect(find.byType(CreateSupportTicketScreen), findsOneWidget);
    });

    testWidgets('the card still opens a new ticket when the list failed', (
      tester,
    ) async {
      listCall().thenAnswer((_) async => throw const OfflineException());
      final router = await pumpList(tester);

      await tester.tap(card);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(location(router), '/support/new');
    });

    testWidgets('the back chip pops to where the student came from', (
      tester,
    ) async {
      listCall().thenAnswer((_) async => ticketsPage([]));
      final router = await pumpList(tester);

      await tester.tap(find.byKey(const Key('support_back')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(location(router), '/start');
    });
  });

  // -------------------------------------------------------------------------
  group('direction', () {
    testWidgets('LTR: back chip, headset disc and title start at the left, the '
        'add button at the right', (tester) async {
      listCall().thenAnswer(
        (_) async => ticketsPage([ticketSummary('t-closed', status: 'closed')]),
      );
      await pumpList(tester);

      final screen = tester.element(find.byType(CustomerSupportScreen));
      expect(Directionality.of(screen), TextDirection.ltr);

      final cardRect = tester.getRect(card);
      expect(cardRect.left, 20);
      expect(cardRect.right, 402 - 20);

      final back = tester.getCenter(find.byKey(const Key('support_back')));
      expect(back.dx, lessThan(201));

      // The card's first glyph is the headset disc, 18 in from the start; the
      // last surface inside it is the add button, 24 in from the end.
      final disc = tester.getRect(
        find.descendant(of: card, matching: find.byType(SvgPicture)).first,
      );
      expect(disc.left - cardRect.left, closeTo(18, 0.01));
      final surfaces = find.descendant(
        of: card,
        matching: find.byType(ElevatedSurface),
      );
      final add = tester.getRect(surfaces.last);
      expect(add.center.dx, greaterThan(cardRect.center.dx));
      expect(cardRect.right - add.right, closeTo(24, 0.01));

      // The pill is at the END of its row.
      final row = tester.getRect(rowFor('t-closed'));
      final pill = tester.getCenter(find.byType(SupportClosedPill));
      expect(pill.dx, greaterThan(row.center.dx));
    });

    testWidgets('RTL: everything mirrors, the title is Arabic and the new copy '
        'falls back to English', (tester) async {
      listCall().thenAnswer(
        (_) async => ticketsPage([ticketSummary('t-closed', status: 'closed')]),
      );
      await pumpList(tester, language: 'ar');

      final screen = tester.element(find.byType(CustomerSupportScreen));
      expect(Directionality.of(screen), TextDirection.rtl);

      // The approved Arabic title; the card's lines have no approved Arabic,
      // so the English fallback shows (CW12a_PLAN §4.2).
      expect(find.text('دعم العملاء'), findsOneWidget);
      expect(find.text('Create a New Ticket'), findsOneWidget);
      expect(find.text('Describe your issue'), findsOneWidget);
      expect(find.text('Recent Tickets'), findsOneWidget);

      final cardRect = tester.getRect(card);
      expect(cardRect.left, 20);
      expect(cardRect.right, 402 - 20);

      // The back chip is the start element: at the RIGHT.
      expect(
        tester.getCenter(find.byKey(const Key('support_back'))).dx,
        greaterThan(201),
      );

      // The headset disc (the card's first child) is at the right, and the add
      // button at the left, 24 from the card's left edge.
      final disc = tester.getRect(
        find.descendant(of: card, matching: find.byType(SvgPicture)).first,
      );
      expect(disc.center.dx, greaterThan(cardRect.center.dx));
      expect(cardRect.right - disc.right, closeTo(18, 0.01));
      final surfaces = find.descendant(
        of: card,
        matching: find.byType(ElevatedSurface),
      );
      final add = tester.getRect(surfaces.last);
      expect(add.center.dx, lessThan(cardRect.center.dx));
      expect(add.left - cardRect.left, closeTo(24, 0.01));

      // And the pill moves to the left end of its row.
      final row = tester.getRect(rowFor('t-closed'));
      final pill = tester.getCenter(find.byType(SupportClosedPill));
      expect(pill.dx, lessThan(row.center.dx));
    });
  });

  // -------------------------------------------------------------------------
  group('both canvases', () {
    for (final brightness in Brightness.values) {
      for (final language in languages) {
        testWidgets('${brightness.name} · $language builds a loaded page '
            'with the canvas\'s own tokens', (tester) async {
          final palette = brightness == Brightness.light
              ? AppColors.light
              : AppColors.dark;
          final elevation = brightness == Brightness.light
              ? AppElevation.light
              : AppElevation.dark;
          listCall().thenAnswer(
            (_) async => ticketsPage(
              [
                ticketSummary(ticketIdA),
                ticketSummary(ticketIdB, status: 'closed'),
              ],
              hasMore: true,
              nextCursor: 'c2',
            ),
          );

          await pumpList(tester, language: language, brightness: brightness);

          expect(tester.takeException(), isNull);
          expect(find.byType(SupportTicketRow), findsNWidgets(2));

          ElevatedSurface outer(Finder of) => tester.widget<ElevatedSurface>(
            find
                .descendant(of: of, matching: find.byType(ElevatedSurface))
                .first,
          );

          final row = outer(rowFor(ticketIdA));
          expect(row.color, palette.supportSurfaceFill);
          expect(row.shadows, elevation.supportRowShadows);
          expect(row.glass, elevation.supportRowGlass);
          final create = outer(card);
          expect(create.color, palette.supportCardFill);
          expect(create.shadows, elevation.supportCreateCardShadows);
          expect(create.glass, elevation.supportCreateCardGlass);

          // Light raises with a shadow and no Glass; dark with Glass and no
          // shadow (designer ruling 2026-09-16/17).
          expect(
            brightness == Brightness.light
                ? row.shadows.isNotEmpty && row.glass == null
                : row.shadows.isEmpty && row.glass != null,
            isTrue,
          );
        });
      }
    }
  });

  // -------------------------------------------------------------------------
  group('text scale', () {
    for (final language in languages) {
      for (final (name, answer)
          in <(String, Future<CursorPage<SupportTicketSummary>> Function())>[
            (
              'loaded',
              () async => ticketsPage(
                [
                  ticketSummary(
                    ticketIdA,
                    subject:
                        'A subject long enough to wrap onto several lines at twice '
                        'the text size without any of it being clipped',
                  ),
                  ticketSummary(ticketIdB, status: 'closed'),
                ],
                hasMore: true,
                nextCursor: 'c2',
              ),
            ),
            ('empty', () async => ticketsPage([])),
            ('error', () async => throw const OfflineException()),
          ]) {
        testWidgets('2.0x · $name · $language lays out without overflow', (
          tester,
        ) async {
          listCall().thenAnswer((_) => answer());

          await pumpList(
            tester,
            language: language,
            textScaler: const TextScaler.linear(2.0),
            size: const Size(402, 800),
          );

          expect(tester.takeException(), isNull);
          expect(card, findsOneWidget);
          // The card grew past its 104 minimum rather than clipping its lines.
          expect(tester.getSize(card).height, greaterThanOrEqualTo(104));
        });
      }
    }
  });

  // -------------------------------------------------------------------------
  group('semantics', () {
    testWidgets('the card is ONE button reading the title and the subtitle', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      listCall().thenAnswer((_) async => ticketsPage([]));
      await pumpList(tester);

      final node = tester.getSemantics(card);
      expect(node.flagsCollection.isButton, isTrue);
      expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
      // The glyphs are excluded: an SVG inside a button is an ImageView.
      expect(node.flagsCollection.isImage, isFalse);
      expect(node.label, contains('Create a New Ticket'));
      expect(node.label, contains('Describe your issue'));
      expect(_nodesWithTap(node), [node], reason: 'no second tap target');
      handle.dispose();
    });

    testWidgets('a row is ONE button: subject, meta and status read together', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      listCall().thenAnswer(
        (_) async => ticketsPage([
          ticketSummary(
            ticketIdA,
            reference: 'TK-9',
            subject: 'Cannot open a lecture',
            status: 'closed',
          ),
          ticketSummary(ticketIdB, subject: 'Another question'),
        ]),
      );
      await pumpList(tester);

      final closed = tester.getSemantics(rowFor(ticketIdA));
      expect(closed.flagsCollection.isButton, isTrue);
      expect(closed.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
      expect(closed.flagsCollection.isImage, isFalse);
      expect(closed.label, contains('Cannot open a lecture'));
      expect(closed.label, contains('TK-9'));
      expect(closed.label, contains('Closed'));
      expect(_nodesWithTap(closed), [closed], reason: 'one node per row');

      final open = tester.getSemantics(rowFor(ticketIdB));
      expect(open.label, contains('Another question'));
      expect(open.label, isNot(contains('Closed')));
      // No status word is invented for a ticket that is not closed.
      for (final word in ['open', 'pending', 'in progress']) {
        expect(open.label.toLowerCase(), isNot(contains(word)));
      }
      handle.dispose();
    });

    testWidgets('the heading is a header', (tester) async {
      final handle = tester.ensureSemantics();
      listCall().thenAnswer((_) async => ticketsPage([]));
      await pumpList(tester);

      final node = tester.getSemantics(find.text('Recent Tickets'));
      expect(node.flagsCollection.isHeader, isTrue);
      handle.dispose();
    });

    for (final language in languages) {
      testWidgets('every tappable node is labelled · $language', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();
        listCall().thenAnswer(
          (_) async => ticketsPage(
            [
              ticketSummary(ticketIdA, status: 'closed'),
              ticketSummary(ticketIdB),
            ],
            hasMore: true,
            nextCursor: 'c2',
          ),
        );
        await pumpList(tester, language: language);

        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        handle.dispose();
      });

      testWidgets('every tappable node is at least 48 dp, bar the shared back '
          'chip · $language', (tester) async {
        final handle = tester.ensureSemantics();
        listCall().thenAnswer(
          (_) async => ticketsPage(
            [
              ticketSummary(ticketIdA, status: 'closed'),
              ticketSummary(ticketIdB),
            ],
            hasMore: true,
            nextCursor: 'c2',
          ),
        );
        await pumpList(tester, language: language);

        await expectOnlyTheBackChipIsSmall(tester);
        handle.dispose();
      });
    }
  });
}

/// Android's 48 dp tap-target guideline, run for real, with ONE known
/// exception stated exactly: the shared `CircleBackButton` is drawn 35 dp
/// (Figma `90:208`) on every screen that has it, and that widget is not this
/// wave's to change. The check passes when nothing is small, and when the only
/// thing that is small is that chip; anything else small fails it.
Future<void> expectOnlyTheBackChipIsSmall(WidgetTester tester) async {
  final evaluation = await androidTapTargetGuideline.evaluate(tester);
  if (evaluation.passed) return;

  final reason = evaluation.reason!;
  expect(
    'expected tap target size'.allMatches(reason).length,
    1,
    reason: 'more than one tap target is below 48 dp: $reason',
  );
  expect(reason, contains('Size(35.0, 35.0)'));
  expect(
    reason,
    anyOf(contains('label: "Back"'), contains('label: "رجوع"')),
    reason: 'the one small target must be the back chip: $reason',
  );
}

/// Every node at or under [root] that carries a tap action.
List<SemanticsNode> _nodesWithTap(SemanticsNode root) {
  final found = <SemanticsNode>[];
  void walk(SemanticsNode node) {
    if (node.getSemanticsData().hasAction(SemanticsAction.tap)) {
      found.add(node);
    }
    node.visitChildren((child) {
      walk(child);
      return true;
    });
  }

  walk(root);
  return found;
}
