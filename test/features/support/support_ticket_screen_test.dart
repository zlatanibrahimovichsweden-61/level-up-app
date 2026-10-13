import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderParagraph;
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/theme/app_typography.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/features/profile/repository/profile_repository.dart';
import 'package:level_up_app/features/profile/widgets/avatar_disc.dart';
import 'package:level_up_app/features/support/models/support_models.dart';
import 'package:level_up_app/features/support/notifier/support_tickets_notifier.dart';
import 'package:level_up_app/features/support/repository/support_repository.dart';
import 'package:level_up_app/features/support/screens/create_support_ticket_screen.dart';
import 'package:level_up_app/features/support/screens/support_ticket_screen.dart';
import 'package:level_up_app/features/support/widgets/support_closed_pill.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import '../profile/profile_fixtures.dart';
import 'support_fixtures.dart';

class _MockRepo extends Mock implements SupportRepository {}

class _MockProfileRepo extends Mock implements ProfileRepository {}

/// The ticket thread · `SupportTicketScreen` · Figma `178:3378`.
///
/// The four states, the details-first thread and who wrote what, the composer
/// and its keyboard Send action, a send's success and each failure, the closed
/// bar (from the server and from a `409`), paging, scrolling to the end, RTL
/// with the English fallback for the unapproved strings, both canvases, text
/// scale and the accessibility guidelines.
void main() {
  late _MockRepo repo;
  late _MockProfileRepo profile;

  const subject = 'Cannot open a lecture';
  const details = 'It spins forever after the update.';

  setUp(() {
    repo = _MockRepo();
    profile = _MockProfileRepo();
    // `GET /me` supplies the student's avatar. By default it fails, which
    // leaves the disc on its gradient; the avatar test supplies a profile.
    when(profile.getMe).thenAnswer(
      (_) async => throw const ApiException(status: 500, code: 'internal'),
    );
    when(
      () => repo.listMySupportTickets(cursor: any(named: 'cursor')),
    ).thenAnswer((_) async => ticketsPage([]));
  });

  /// Stubs the ticket and ONE page of replies.
  void stubThread({
    SupportTicket? ticket,
    List<SupportTicketMessage> messages = const [],
  }) {
    when(() => repo.getMySupportTicket(ticketIdA)).thenAnswer(
      (_) async =>
          ticket ?? ticketDetail(ticketIdA, subject: subject, details: details),
    );
    when(
      () => repo.listMySupportTicketMessages(
        ticketIdA,
        cursor: any(named: 'cursor'),
      ),
    ).thenAnswer((_) async => messagesPage(messages));
  }

  When<Future<SupportTicketMessage>> postCall([String? body]) =>
      when(() => repo.postMySupportTicketMessage(ticketIdA, body ?? any()));

  VerificationResult verifyPost([String? body]) =>
      verify(() => repo.postMySupportTicketMessage(ticketIdA, body ?? any()));

  When<Future<dynamic>> pageCall({String? cursor}) =>
      when(() => repo.listMySupportTicketMessages(ticketIdA, cursor: cursor));

  /// Mounts the thread under a router that knows the three support paths, with
  /// a stub underneath so Back has somewhere to go.
  Future<({GoRouter router, ProviderContainer container})> pumpThread(
    WidgetTester tester, {
    String language = 'en',
    Brightness brightness = Brightness.light,
    TextScaler textScaler = TextScaler.noScaling,
    Size size = const Size(402, 900),
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

    final container = ProviderContainer(
      overrides: [
        supportRepositoryProvider.overrideWithValue(repo),
        profileRepositoryProvider.overrideWithValue(profile),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
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

    router.push('/support/tickets/$ticketIdA');
    await settle(tester);
    return (router: router, container: container);
  }

  Future<AppLocalizations> l10nFor(String language) =>
      AppLocalizations.delegate.load(Locale(language));

  Finder messageRow(String id) => find.byKey(Key('support_message_$id'));
  final detailsRow = find.byKey(const Key('support_ticket_details'));
  final composerField = find.byKey(const Key('support_composer_field'));
  final sendButton = find.byKey(const Key('support_send'));
  final closedBar = find.byKey(const Key('support_closed_bar'));
  final retry = find.byKey(const Key('support_thread_retry'));
  final sendError = find.byKey(const Key('support_send_error'));

  String location(GoRouter router) => router.state.uri.toString();

  Future<void> typeReply(WidgetTester tester, String text) async {
    await tester.enterText(composerField, text);
    await tester.pump();
  }

  Future<void> tapSend(WidgetTester tester) async {
    await tester.tap(sendButton);
    await settle(tester);
  }

  const languages = ['en', 'ar'];

  // -------------------------------------------------------------------------
  group('the four states', () {
    for (final language in languages) {
      group(language, () {
        testWidgets('loading: a spinner, and the way back is already there', (
          tester,
        ) async {
          final pending = Completer<SupportTicket>();
          when(
            () => repo.getMySupportTicket(ticketIdA),
          ).thenAnswer((_) => pending.future);
          when(
            () => repo.listMySupportTicketMessages(
              ticketIdA,
              cursor: any(named: 'cursor'),
            ),
          ).thenAnswer((_) async => messagesPage([]));

          await pumpThread(tester, language: language);

          expect(find.byType(CircularProgressIndicator), findsOneWidget);
          expect(find.byKey(const Key('support_thread_back')), findsOneWidget);
          expect(composerField, findsNothing);
          expect(closedBar, findsNothing);

          pending.complete(ticketDetail(ticketIdA));
          await tester.pump();
        });

        testWidgets('error: genericError and a Retry that re-asks both', (
          tester,
        ) async {
          final l10n = await l10nFor(language);
          when(() => repo.getMySupportTicket(ticketIdA)).thenAnswer(
            (_) async => throw const ApiException(
              status: 500,
              code: 'internal_server_error',
            ),
          );
          when(
            () => repo.listMySupportTicketMessages(
              ticketIdA,
              cursor: any(named: 'cursor'),
            ),
          ).thenAnswer((_) async => messagesPage([]));

          await pumpThread(tester, language: language);

          expect(find.text(l10n.genericError), findsOneWidget);
          expect(retry, findsOneWidget);
          expect(composerField, findsNothing);

          stubThread();
          await tester.tap(retry);
          await settle(tester);

          expect(find.text(l10n.genericError), findsNothing);
          expect(detailsRow, findsOneWidget);
          verify(() => repo.getMySupportTicket(ticketIdA)).called(2);
        });

        testWidgets('offline: its own copy and a Retry', (tester) async {
          final l10n = await l10nFor(language);
          when(
            () => repo.getMySupportTicket(ticketIdA),
          ).thenAnswer((_) async => throw const OfflineException());
          when(
            () => repo.listMySupportTicketMessages(
              ticketIdA,
              cursor: any(named: 'cursor'),
            ),
          ).thenAnswer((_) async => throw const OfflineException());

          await pumpThread(tester, language: language);

          expect(find.text(l10n.offline), findsOneWidget);
          expect(find.text(l10n.genericError), findsNothing);
          expect(retry, findsOneWidget);

          stubThread();
          await tester.tap(retry);
          await settle(tester);

          expect(detailsRow, findsOneWidget);
        });

        testWidgets('404 not_found: genericError and NO Retry', (tester) async {
          final l10n = await l10nFor(language);
          when(() => repo.getMySupportTicket(ticketIdA)).thenAnswer(
            (_) async =>
                throw const ApiException(status: 404, code: 'not_found'),
          );
          when(
            () => repo.listMySupportTicketMessages(
              ticketIdA,
              cursor: any(named: 'cursor'),
            ),
          ).thenAnswer(
            (_) async =>
                throw const ApiException(status: 404, code: 'not_found'),
          );

          await pumpThread(tester, language: language);

          expect(find.text(l10n.genericError), findsOneWidget);
          expect(retry, findsNothing);
          expect(find.byKey(const Key('support_thread_back')), findsOneWidget);
        });

        testWidgets('pending deletion: its own copy and NO Retry', (
          tester,
        ) async {
          final l10n = await l10nFor(language);
          const refusal = ApiException(
            status: 403,
            code: 'account_pending_deletion',
          );
          when(
            () => repo.getMySupportTicket(ticketIdA),
          ).thenAnswer((_) async => throw refusal);
          when(
            () => repo.listMySupportTicketMessages(
              ticketIdA,
              cursor: any(named: 'cursor'),
            ),
          ).thenAnswer((_) async => throw refusal);

          await pumpThread(tester, language: language);

          expect(find.text(l10n.accountPendingDeletion), findsOneWidget);
          expect(retry, findsNothing);
          verify(() => repo.getMySupportTicket(ticketIdA)).called(1);
        });

        testWidgets('rate limited: it says so, and no Retry to hammer it '
            'with', (tester) async {
          final l10n = await l10nFor(language);
          when(
            () => repo.getMySupportTicket(ticketIdA),
          ).thenAnswer((_) async => throw const RateLimitedException());
          when(
            () => repo.listMySupportTicketMessages(
              ticketIdA,
              cursor: any(named: 'cursor'),
            ),
          ).thenAnswer((_) async => throw const RateLimitedException());

          await pumpThread(tester, language: language);

          expect(find.text(l10n.rateLimited), findsOneWidget);
          expect(find.text(l10n.genericError), findsNothing);
          expect(retry, findsNothing);
        });
      });
    }
  });

  // -------------------------------------------------------------------------
  group('the thread', () {
    final header = find.byKey(const Key('support_thread_header'));

    /// The laid-out paragraph of the header's title.
    RenderParagraph titleParagraph(WidgetTester tester, String text) =>
        tester.renderObject<RenderParagraph>(
          find.descendant(of: header, matching: find.text(text)),
        );

    /// How many lines the title took, at the unscaled `h3` line height.
    int titleLines(WidgetTester tester, String text) =>
        (titleParagraph(tester, text).size.height /
                (AppType.h3.fontSize! * AppType.h3.height!))
            .round();

    testWidgets('a long subject takes at most two lines, then an ellipsis '
        '(the subject is shown nowhere else on the thread)', (tester) async {
      final longSubject = 'A very long subject ' * 12;
      stubThread(
        ticket: ticketDetail(ticketIdA, subject: longSubject, details: details),
      );
      await pumpThread(tester);

      final title = tester.widget<Text>(
        find.descendant(of: header, matching: find.text(longSubject)),
      );
      expect(title.maxLines, 2);
      expect(title.overflow, TextOverflow.ellipsis);
      expect(titleLines(tester, longSubject), 2);
      expect(titleParagraph(tester, longSubject).didExceedMaxLines, isTrue);
    });

    testWidgets('a subject that needs two lines gets both, whole, and the '
        'header is still the frame\'s 63 (two lines fit in it)', (
      tester,
    ) async {
      // On the test font a glyph is one em wide, so this breaks after "open"
      // in the 266 between the back chip and the edge.
      const twoLines = 'Cannot open lecture video';
      stubThread(
        ticket: ticketDetail(ticketIdA, subject: twoLines, details: details),
      );
      await pumpThread(tester);

      expect(titleLines(tester, twoLines), 2);
      expect(titleParagraph(tester, twoLines).didExceedMaxLines, isFalse);
      expect(tester.getSize(header).height, closeTo(63, 0.01));
    });

    testWidgets('a larger text scale grows the header past 63: the title and '
        'the chip stay centred and the divider stays at the bottom', (
      tester,
    ) async {
      const twoLines = 'Cannot open lecture video';
      stubThread(
        ticket: ticketDetail(ticketIdA, subject: twoLines, details: details),
      );
      await pumpThread(tester, textScaler: const TextScaler.linear(2.0));

      final rect = tester.getRect(header);
      expect(rect.height, greaterThan(63));
      expect(tester.takeException(), isNull);
      // The content area is the header less the 1.18 divider at its bottom.
      final contentCenter = rect.top + (rect.height - 1.18) / 2;
      expect(
        tester
            .getCenter(find.descendant(of: header, matching: find.byType(Text)))
            .dy,
        closeTo(contentCenter, 0.01),
      );
      expect(
        tester.getCenter(find.byKey(const Key('support_thread_back'))).dy,
        closeTo(contentCenter, 0.01),
      );
      final container = tester.widget<Container>(header);
      final border = (container.decoration! as BoxDecoration).border! as Border;
      expect(border.bottom.width, 1.18);
      expect(border.top, BorderSide.none);
    });

    testWidgets('an Arabic subject in the English app is laid out RTL '
        '(BUG-020)', (tester) async {
      const arabic = 'لا أستطيع فتح المحاضرة';
      stubThread(
        ticket: ticketDetail(ticketIdA, subject: arabic, details: details),
      );
      await pumpThread(tester);

      final screen = tester.element(find.byType(SupportTicketScreen));
      expect(Directionality.of(screen), TextDirection.ltr);
      final title = tester.widget<Text>(
        find.descendant(of: header, matching: find.text(arabic)),
      );
      expect(title.textDirection, TextDirection.rtl);
    });

    testWidgets('an English subject in the Arabic app is laid out LTR '
        '(BUG-020)', (tester) async {
      stubThread();
      await pumpThread(tester, language: 'ar');

      final screen = tester.element(find.byType(SupportTicketScreen));
      expect(Directionality.of(screen), TextDirection.rtl);
      final title = tester.widget<Text>(
        find.descendant(of: header, matching: find.text(subject)),
      );
      expect(title.textDirection, TextDirection.ltr);
    });

    testWidgets('the header is 63 high with a 1.18 divider in the token', (
      tester,
    ) async {
      stubThread();
      await pumpThread(tester);

      expect(
        tester.getSize(header).height,
        closeTo(63, 0.01),
        reason: 'a short subject is exactly the frame\'s header',
      );
      final container = tester.widget<Container>(header);
      final border = (container.decoration! as BoxDecoration).border! as Border;
      expect(border.bottom.width, 1.18);
      expect(border.bottom.color, AppColors.light.supportThreadDivider);
      expect(border.top, BorderSide.none);
      expect(
        tester.getSize(find.byKey(const Key('support_thread_back'))).height,
        35,
      );
      // The chip sits 21 in from the start edge.
      expect(
        tester.getTopLeft(find.byKey(const Key('support_thread_back'))).dx,
        21,
      );
    });

    testWidgets('the FIRST row is the ticket\'s details, written as You', (
      tester,
    ) async {
      stubThread(
        messages: [supportMessage('m1', body: 'Please send a photo.')],
      );
      await pumpThread(tester);

      expect(detailsRow, findsOneWidget);
      expect(
        find.descendant(of: detailsRow, matching: find.text('You')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: detailsRow, matching: find.text(details)),
        findsOneWidget,
      );
      // And it is above the first reply.
      expect(
        tester.getTopLeft(detailsRow).dy,
        lessThan(tester.getTopLeft(messageRow('m1')).dy),
      );
    });

    testWidgets('replies follow in order: staff as Customer Support, the '
        'student as You, any other kind as staff', (tester) async {
      stubThread(
        messages: [
          supportMessage('m1', authorKind: 'staff', body: 'First reply'),
          supportMessage('m2', authorKind: 'student', body: 'Second reply'),
          supportMessage('m3', authorKind: 'bot', body: 'Third reply'),
        ],
      );
      await pumpThread(tester);

      String nameOf(String id) {
        final texts = tester
            .widgetList<Text>(
              find.descendant(of: messageRow(id), matching: find.byType(Text)),
            )
            .toList();
        return texts.first.data!;
      }

      expect(nameOf('m1'), 'Customer Support');
      expect(nameOf('m2'), 'You');
      expect(nameOf('m3'), 'Customer Support');
      final ys = [
        for (final id in ['m1', 'm2', 'm3'])
          tester.getTopLeft(messageRow(id)).dy,
      ];
      expect(ys, [...ys]..sort());
      expect(find.text('First reply'), findsOneWidget);
      expect(find.text('Third reply'), findsOneWidget);
    });

    testWidgets('the 20 gap between rows and the 21 side insets', (
      tester,
    ) async {
      stubThread(messages: [supportMessage('m1', authorKind: 'staff')]);
      await pumpThread(tester);

      final first = tester.getRect(detailsRow);
      final second = tester.getRect(messageRow('m1'));
      expect(second.top - first.bottom, closeTo(20, 0.01));
      expect(first.left, 21);
      expect(first.right, 402 - 21);
    });

    testWidgets('a reply with an empty body draws the name only', (
      tester,
    ) async {
      stubThread(
        messages: [supportMessage('m1', authorKind: 'staff', body: '')],
      );
      await pumpThread(tester);

      expect(
        find.descendant(of: messageRow('m1'), matching: find.byType(Text)),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: messageRow('m1'),
          matching: find.text('Customer Support'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('the staff disc wears the support avatar, the student\'s '
        'stays on its gradient until /me lands', (tester) async {
      stubThread(messages: [supportMessage('m1', authorKind: 'staff')]);
      await pumpThread(tester);

      // Both discs are the shared AvatarDisc at 31.
      for (final row in [detailsRow, messageRow('m1')]) {
        final disc = find.descendant(
          of: row,
          matching: find.byType(AvatarDisc),
        );
        expect(disc, findsOneWidget);
        expect(tester.getSize(disc), const Size(31, 31));
      }
      final staff = tester.widget<Image>(
        find.descendant(of: messageRow('m1'), matching: find.byType(Image)),
      );
      expect(
        (staff.image as AssetImage).assetName,
        'assets/images/support_staff_avatar.png',
      );
      // Drawn at its frame size, 36 x 35 (178:3424), centred in the 31 disc and
      // clipped to it by the disc's own ClipOval - not squeezed to 31.
      final staffImage = find.descendant(
        of: messageRow('m1'),
        matching: find.byType(Image),
      );
      expect(tester.getSize(staffImage), const Size(36, 35));
      final staffDisc = find.descendant(
        of: messageRow('m1'),
        matching: find.byType(AvatarDisc),
      );
      expect(tester.getSize(staffDisc), const Size(31, 31));
      expect(
        tester.getCenter(staffImage).dx,
        closeTo(tester.getCenter(staffDisc).dx, 0.01),
      );
      expect(
        tester.getCenter(staffImage).dy,
        closeTo(tester.getCenter(staffDisc).dy, 0.01),
      );
      expect(
        find.descendant(of: staffDisc, matching: find.byType(ClipOval)),
        findsOneWidget,
      );
      expect(
        find.ancestor(of: staffImage, matching: find.byType(ClipOval)),
        findsOneWidget,
      );
      // /me failed: no network image, just the disc's gradient.
      expect(
        find.descendant(
          of: detailsRow,
          matching: find.byType(CachedNetworkImage),
        ),
        findsNothing,
      );
    });

    testWidgets('the student\'s disc holds their own avatar.url from /me', (
      tester,
    ) async {
      // CachedNetworkImage's cache manager asks path_provider for a folder.
      const pathProvider = MethodChannel('plugins.flutter.io/path_provider');
      final messenger = tester.binding.defaultBinaryMessenger;
      messenger.setMockMethodCallHandler(
        pathProvider,
        (_) async => '.dart_tool/support_avatar_cache',
      );
      addTearDown(() => messenger.setMockMethodCallHandler(pathProvider, null));
      when(profile.getMe).thenAnswer((_) async => schoolProfile());
      stubThread(messages: [supportMessage('m1', authorKind: 'staff')]);

      await pumpThread(tester);

      final image = tester.widget<CachedNetworkImage>(
        find.descendant(
          of: detailsRow,
          matching: find.byType(CachedNetworkImage),
        ),
      );
      expect(image.imageUrl, schoolProfile().avatar.url);
      // The staff row never takes the student's avatar.
      expect(
        find.descendant(
          of: messageRow('m1'),
          matching: find.byType(CachedNetworkImage),
        ),
        findsNothing,
      );
    });

    testWidgets('a message that opens with Arabic is laid out RTL in the '
        'English app, one that opens with English stays LTR', (tester) async {
      stubThread(
        messages: [
          supportMessage('m1', authorKind: 'staff', body: 'مرحبا، كيف نساعدك؟'),
          supportMessage(
            'm2',
            authorKind: 'staff',
            body: 'Hello, how can we help?',
          ),
        ],
      );
      await pumpThread(tester);

      TextDirection? directionOf(String text) =>
          tester.widget<Text>(find.text(text)).textDirection;
      expect(directionOf('مرحبا، كيف نساعدك؟'), TextDirection.rtl);
      expect(directionOf('Hello, how can we help?'), TextDirection.ltr);
    });
  });

  // -------------------------------------------------------------------------
  group('paging and scrolling', () {
    testWidgets('Load more appends the next page', (tester) async {
      when(() => repo.getMySupportTicket(ticketIdA)).thenAnswer(
        (_) async =>
            ticketDetail(ticketIdA, subject: subject, details: details),
      );
      // Ten pages is the walk's bound; an eleventh is the button's.
      var page = 0;
      when(
        () => repo.listMySupportTicketMessages(
          ticketIdA,
          cursor: any(named: 'cursor'),
        ),
      ).thenAnswer((invocation) async {
        final cursor = invocation.namedArguments[#cursor] as String?;
        if (cursor == null) page = 0;
        page++;
        return messagesPage(
          [supportMessage('p$page', authorKind: 'staff', body: 'Page $page')],
          hasMore: page < 11,
          nextCursor: page < 11 ? 'c$page' : null,
        );
      });

      await pumpThread(tester);
      expect(find.byKey(const Key('support_thread_load_more')), findsOneWidget);

      await tester.ensureVisible(
        find.byKey(const Key('support_thread_load_more')),
      );
      await tester.tap(find.byKey(const Key('support_thread_load_more')));
      await settle(tester);

      expect(messageRow('p11'), findsOneWidget);
      expect(find.byKey(const Key('support_thread_load_more')), findsNothing);
    });

    testWidgets('a failed page keeps the thread and offers its own Retry', (
      tester,
    ) async {
      stubThread();
      pageCall().thenAnswer(
        (_) async => messagesPage(
          [supportMessage('m1', authorKind: 'staff')],
          hasMore: true,
          nextCursor: 'c2',
        ),
      );
      pageCall(cursor: 'c2').thenAnswer(
        (_) async => throw const ApiException(
          status: 500,
          code: 'internal_server_error',
        ),
      );

      await pumpThread(tester);

      // The page already on screen survives; the thread is NOT an error.
      expect(messageRow('m1'), findsOneWidget);
      expect(retry, findsNothing);
      expect(
        find.byKey(const Key('support_thread_append_retry')),
        findsOneWidget,
      );

      pageCall(cursor: 'c2').thenAnswer(
        (_) async => messagesPage([supportMessage('m2', authorKind: 'staff')]),
      );
      await tester.ensureVisible(
        find.byKey(const Key('support_thread_append_retry')),
      );
      await tester.tap(find.byKey(const Key('support_thread_append_retry')));
      await settle(tester);

      expect(messageRow('m2'), findsOneWidget);
    });

    testWidgets('it opens scrolled to the END of a long thread', (
      tester,
    ) async {
      stubThread(
        messages: [
          for (var i = 1; i <= 30; i++)
            supportMessage(
              'm$i',
              authorKind: i.isEven ? 'staff' : 'student',
              body:
                  'Reply number $i, long enough to take a couple of lines '
                  'on a phone-width screen so the list is tall.',
            ),
        ],
      );

      await pumpThread(tester, size: const Size(402, 700));

      final position = tester
          .state<ScrollableState>(
            find
                .descendant(
                  of: find.byType(ListView),
                  matching: find.byType(Scrollable),
                )
                .first,
          )
          .position;
      expect(position.maxScrollExtent, greaterThan(0));
      expect(position.pixels, closeTo(position.maxScrollExtent, 1));
      // The newest is in view; the details at the top are not.
      expect(messageRow('m30').hitTestable(), findsOneWidget);
      expect(detailsRow.hitTestable(), findsNothing);
    });

    testWidgets('a send scrolls to the end', (tester) async {
      stubThread(
        messages: [
          for (var i = 1; i <= 30; i++)
            supportMessage(
              'm$i',
              authorKind: 'staff',
              body: 'Reply number $i.',
            ),
        ],
      );
      postCall().thenAnswer(
        (_) async => supportMessage('mine', body: 'A new question'),
      );
      await pumpThread(tester, size: const Size(402, 700));

      // Scroll up first, so the send has to bring the end back.
      await tester.drag(find.byType(ListView), const Offset(0, 3000));
      await tester.pump();
      expect(messageRow('m30').hitTestable(), findsNothing);

      await typeReply(tester, 'A new question');
      await tapSend(tester);

      expect(messageRow('mine'), findsOneWidget);
      expect(messageRow('mine').hitTestable(), findsOneWidget);
    });
  });

  // -------------------------------------------------------------------------
  group('the composer', () {
    testWidgets('an open ticket shows the field with its hint and a send '
        'glyph, no closed bar', (tester) async {
      stubThread();
      await pumpThread(tester);

      expect(composerField, findsOneWidget);
      expect(find.text('Write your message'), findsOneWidget);
      expect(sendButton, findsOneWidget);
      expect(closedBar, findsNothing);
      final field = tester.widget<TextField>(composerField);
      expect(field.textInputAction, TextInputAction.send);
      expect(field.minLines, 1);
      expect(field.maxLines, 4);
    });

    testWidgets('the field holds at most 4000 characters', (tester) async {
      stubThread();
      await pumpThread(tester);

      await typeReply(tester, 'a' * 4100);

      expect(
        tester.widget<TextField>(composerField).controller!.text.length,
        4000,
      );
    });

    testWidgets(
      'the field is at least 56 high and the bar sits at the bottom',
      (tester) async {
        stubThread();
        await pumpThread(tester);

        final field = find.ancestor(
          of: composerField,
          matching: find.byType(ElevatedSurface),
        );
        expect(tester.getSize(field.first).height, greaterThanOrEqualTo(56));
        final bar = tester.getRect(field.last);
        expect(bar.bottom, 900);
      },
    );

    testWidgets('the send tap target is exactly 48 x 48 (the glyph itself is '
        '24), disabled, enabled and in flight', (tester) async {
      stubThread();
      final pending = Completer<SupportTicketMessage>();
      postCall().thenAnswer((_) => pending.future);
      await pumpThread(tester);
      expect(tester.getSize(sendButton), const Size(48, 48));

      await typeReply(tester, 'Ready');
      expect(tester.getSize(sendButton), const Size(48, 48));
      expect(
        tester.getSize(
          find.descendant(of: sendButton, matching: find.byType(SvgPicture)),
        ),
        isNot(const Size(48, 48)),
        reason: 'the 48 is the target around the 24 glyph, not the glyph',
      );

      await tester.tap(sendButton);
      await tester.pump();
      expect(tester.getSize(sendButton), const Size(48, 48));

      pending.complete(supportMessage('mine', body: 'Ready'));
      await settle(tester);
    });

    testWidgets('a tap anywhere on the pill, its padding included, focuses '
        'the field', (tester) async {
      stubThread();
      await pumpThread(tester);

      final pill = tester.getRect(
        find
            .ancestor(of: composerField, matching: find.byType(ElevatedSurface))
            .first,
      );
      final field = tester.getRect(composerField);
      // The whole pill is the field: it is as tall as the pill, not just the
      // 24 of one text line.
      expect(field.height, pill.height);
      expect(field.height, greaterThanOrEqualTo(56));

      // 3 px under the pill's top edge is padding, not text.
      await tester.tapAt(Offset(pill.left + 60, pill.top + 3));
      await tester.pump();

      expect(
        tester.widget<TextField>(composerField).focusNode!.hasFocus,
        isTrue,
      );
    });

    testWidgets('nothing to send: the glyph does nothing, an empty or blank '
        'text sends nothing', (tester) async {
      stubThread();
      await pumpThread(tester);
      expect(tester.widget<InkResponse>(sendButton).onTap, isNull);

      await tester.tap(sendButton, warnIfMissed: false);
      await settle(tester);
      verifyNever(() => repo.postMySupportTicketMessage(any(), any()));

      await typeReply(tester, '   \n  ');
      expect(tester.widget<InkResponse>(sendButton).onTap, isNull);
      // …and neither does the keyboard's Send.
      await tester.testTextInput.receiveAction(TextInputAction.send);
      await settle(tester);
      verifyNever(() => repo.postMySupportTicketMessage(any(), any()));

      await typeReply(tester, 'Hello');
      expect(tester.widget<InkResponse>(sendButton).onTap, isNotNull);
    });

    testWidgets('tapping the glyph sends the TRIMMED text, appends it as You, '
        'clears the field and asks the list again', (tester) async {
      stubThread(messages: [supportMessage('m1', authorKind: 'staff')]);
      postCall().thenAnswer(
        (_) async => supportMessage('mine', body: 'Thank you'),
      );
      final pumped = await pumpThread(tester);
      // The list is open behind the thread, as when a row was tapped.
      pumped.container.listen(supportTicketsProvider, (_, _) {});
      await pumped.container.read(supportTicketsProvider.future);
      verify(() => repo.listMySupportTickets(cursor: null)).called(1);

      await typeReply(tester, '  Thank you  ');
      await tapSend(tester);

      verifyPost('Thank you').called(1);
      expect(messageRow('mine'), findsOneWidget);
      expect(
        find.descendant(of: messageRow('mine'), matching: find.text('You')),
        findsOneWidget,
      );
      expect(tester.widget<TextField>(composerField).controller!.text, isEmpty);
      expect(tester.widget<InkResponse>(sendButton).onTap, isNull);
      // A reply moves the ticket in the list: it is asked again.
      verify(() => repo.listMySupportTickets(cursor: null)).called(1);
    });

    testWidgets('the keyboard\'s Send action sends, exactly like the glyph', (
      tester,
    ) async {
      stubThread();
      postCall().thenAnswer(
        (_) async => supportMessage('mine', body: 'From the keyboard'),
      );
      await pumpThread(tester);

      await typeReply(tester, 'From the keyboard');
      await tester.testTextInput.receiveAction(TextInputAction.send);
      await settle(tester);

      verifyPost('From the keyboard').called(1);
      expect(messageRow('mine'), findsOneWidget);
      expect(tester.widget<TextField>(composerField).controller!.text, isEmpty);
    });

    testWidgets('in flight: a spinner replaces the glyph, a second send is '
        'ignored, the text stays until it lands', (tester) async {
      stubThread();
      final pending = Completer<SupportTicketMessage>();
      postCall().thenAnswer((_) => pending.future);
      await pumpThread(tester);

      await typeReply(tester, 'One at a time');
      await tester.tap(sendButton);
      await tester.pump();

      expect(
        find.descendant(
          of: sendButton,
          matching: find.byType(CircularProgressIndicator),
        ),
        findsOneWidget,
      );
      expect(tester.widget<InkResponse>(sendButton).onTap, isNull);
      await tester.testTextInput.receiveAction(TextInputAction.send);
      await tester.pump();
      verifyPost().called(1);
      expect(
        tester.widget<TextField>(composerField).controller!.text,
        'One at a time',
      );

      pending.complete(supportMessage('mine', body: 'One at a time'));
      await settle(tester);
      expect(messageRow('mine'), findsOneWidget);
      expect(tester.widget<TextField>(composerField).controller!.text, isEmpty);
    });

    for (final language in languages) {
      group('a failed send · $language', () {
        testWidgets('offline: its own copy, the text stays, sending again is '
            'possible', (tester) async {
          final l10n = await l10nFor(language);
          stubThread();
          postCall().thenAnswer((_) async => throw const OfflineException());
          await pumpThread(tester, language: language);

          await typeReply(tester, 'Keep this');
          await tapSend(tester);

          expect(
            find.descendant(of: sendError, matching: find.text(l10n.offline)),
            findsOneWidget,
          );
          expect(
            tester.widget<TextField>(composerField).controller!.text,
            'Keep this',
          );
          expect(tester.widget<InkResponse>(sendButton).onTap, isNotNull);

          postCall().thenAnswer(
            (_) async => supportMessage('mine', body: 'Keep this'),
          );
          await tapSend(tester);
          expect(messageRow('mine'), findsOneWidget);
          expect(sendError, findsNothing);
        });

        testWidgets('the failure row is a live region, so a screen reader '
            'announces it', (tester) async {
          final l10n = await l10nFor(language);
          final handle = tester.ensureSemantics();
          stubThread();
          postCall().thenAnswer((_) async => throw const OfflineException());
          await pumpThread(tester, language: language);

          await typeReply(tester, 'Keep this');
          await tapSend(tester);

          final node = tester.getSemantics(sendError);
          expect(node.flagsCollection.isLiveRegion, isTrue);
          expect(node.label, contains(l10n.offline));
          handle.dispose();
        });

        testWidgets('429 with a Retry-After: rateLimitedIn(seconds)', (
          tester,
        ) async {
          final l10n = await l10nFor(language);
          stubThread();
          postCall().thenAnswer(
            (_) async => throw const RateLimitedException(
              retryAfter: Duration(seconds: 1800),
            ),
          );
          await pumpThread(tester, language: language);

          await typeReply(tester, 'Too many');
          await tapSend(tester);

          expect(
            find.descendant(
              of: sendError,
              matching: find.text(l10n.rateLimitedIn(1800)),
            ),
            findsOneWidget,
          );
        });

        testWidgets('anything else: genericError; editing clears it', (
          tester,
        ) async {
          final l10n = await l10nFor(language);
          stubThread();
          postCall().thenAnswer(
            (_) async => throw const ApiException(
              status: 500,
              code: 'internal_server_error',
            ),
          );
          await pumpThread(tester, language: language);

          await typeReply(tester, 'Oops');
          await tapSend(tester);
          expect(
            find.descendant(
              of: sendError,
              matching: find.text(l10n.genericError),
            ),
            findsOneWidget,
          );

          await typeReply(tester, 'Oops again');
          expect(sendError, findsNothing);
        });

        testWidgets('pending deletion: its own copy', (tester) async {
          final l10n = await l10nFor(language);
          stubThread();
          postCall().thenAnswer(
            (_) async => throw const ApiException(
              status: 403,
              code: 'account_pending_deletion',
            ),
          );
          await pumpThread(tester, language: language);

          await typeReply(tester, 'Hello?');
          await tapSend(tester);

          expect(
            find.descendant(
              of: sendError,
              matching: find.text(l10n.accountPendingDeletion),
            ),
            findsOneWidget,
          );
        });
      });
    }
  });

  // -------------------------------------------------------------------------
  group('closed', () {
    testWidgets('a closed ticket shows the closed bar and NO composer', (
      tester,
    ) async {
      stubThread(ticket: closedTicket(ticketIdA));
      await pumpThread(tester);

      expect(closedBar, findsOneWidget);
      expect(composerField, findsNothing);
      expect(sendButton, findsNothing);
      expect(find.byType(TextField), findsNothing);
      expect(
        find.descendant(
          of: closedBar,
          matching: find.byType(SupportClosedPill),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(of: closedBar, matching: find.text('Closed')),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: closedBar,
          matching: find.text('Create a New Ticket'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('the bar\'s button opens the create screen', (tester) async {
      stubThread(ticket: closedTicket(ticketIdA));
      final pumped = await pumpThread(tester);

      await tester.tap(find.byKey(const Key('support_closed_new_ticket')));
      await settle(tester);

      expect(location(pumped.router), '/support/new');
    });

    testWidgets('an unknown status is "in progress, not closed": the composer '
        'stays', (tester) async {
      stubThread(ticket: ticketDetail(ticketIdA, status: 'escalated'));
      await pumpThread(tester);

      expect(composerField, findsOneWidget);
      expect(closedBar, findsNothing);
    });

    testWidgets('a 409 ticket_closed on send turns the composer into the '
        'closed bar', (tester) async {
      stubThread();
      postCall().thenAnswer(
        (_) async =>
            throw const ApiException(status: 409, code: 'ticket_closed'),
      );
      await pumpThread(tester);
      expect(composerField, findsOneWidget);

      // The ticket is closed by the time it is re-read.
      when(
        () => repo.getMySupportTicket(ticketIdA),
      ).thenAnswer((_) async => closedTicket(ticketIdA));
      await typeReply(tester, 'Too late');
      await tapSend(tester);

      expect(closedBar, findsOneWidget);
      expect(composerField, findsNothing);
      // The closed bar IS the explanation: no error line on top of it.
      expect(sendError, findsNothing);
      // The thread is still readable.
      expect(detailsRow, findsOneWidget);
    });

    testWidgets('a 409 closes the bar even when the re-read fails', (
      tester,
    ) async {
      stubThread();
      postCall().thenAnswer(
        (_) async =>
            throw const ApiException(status: 409, code: 'ticket_closed'),
      );
      await pumpThread(tester);

      when(
        () => repo.getMySupportTicket(ticketIdA),
      ).thenAnswer((_) async => throw const OfflineException());
      await typeReply(tester, 'Too late');
      await tapSend(tester);

      expect(closedBar, findsOneWidget);
      expect(composerField, findsNothing);
    });
  });

  // -------------------------------------------------------------------------
  group('direction', () {
    testWidgets('LTR: the disc is at the left, the chip is at the left, the '
        'send glyph at the right', (tester) async {
      stubThread(messages: [supportMessage('m1', authorKind: 'staff')]);
      await pumpThread(tester);

      final screen = tester.element(find.byType(SupportTicketScreen));
      expect(Directionality.of(screen), TextDirection.ltr);

      final row = tester.getRect(detailsRow);
      final disc = tester.getRect(
        find.descendant(of: detailsRow, matching: find.byType(AvatarDisc)),
      );
      expect(disc.left, row.left);
      expect(
        tester.getCenter(find.byKey(const Key('support_thread_back'))).dx,
        lessThan(201),
      );
      expect(tester.getCenter(sendButton).dx, greaterThan(201));
      // The glyph is 24 wide and 16 from the FIELD's end edge (178:3468).
      final glyph = tester.getRect(
        find.descendant(of: sendButton, matching: find.byType(SvgPicture)),
      );
      final field = tester.getRect(
        find
            .ancestor(of: composerField, matching: find.byType(ElevatedSurface))
            .first,
      );
      expect(glyph.width, 24);
      expect(field.right - glyph.right, closeTo(16, 0.01));
    });

    testWidgets('RTL: everything mirrors, the names are Arabic and the new '
        'copy is English', (tester) async {
      stubThread(messages: [supportMessage('m1', authorKind: 'staff')]);
      await pumpThread(tester, language: 'ar');

      final screen = tester.element(find.byType(SupportTicketScreen));
      expect(Directionality.of(screen), TextDirection.rtl);

      // The disc is the START item: at the right of its row.
      final row = tester.getRect(detailsRow);
      final disc = tester.getRect(
        find.descendant(of: detailsRow, matching: find.byType(AvatarDisc)),
      );
      expect(disc.right, row.right);
      expect(row.left, 21);
      expect(row.right, 402 - 21);
      // The back chip is at the right, the send glyph at the left.
      expect(
        tester.getCenter(find.byKey(const Key('support_thread_back'))).dx,
        greaterThan(201),
      );
      expect(tester.getCenter(sendButton).dx, lessThan(201));

      // Approved Arabic for both names; the composer hint has none.
      expect(
        find.descendant(of: detailsRow, matching: find.text('أنت')),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: messageRow('m1'),
          matching: find.text('دعم العملاء'),
        ),
        findsOneWidget,
      );
      expect(find.text('Write your message'), findsOneWidget);
    });

    /// Whether `flutter_svg` laid a horizontal flip (a negative x scale) over
    /// the send glyph - what `matchTextDirection` does in an RTL context.
    bool sendGlyphMirrored(WidgetTester tester) => tester
        .widgetList<Transform>(
          find.descendant(
            of: find.descendant(
              of: sendButton,
              matching: find.byType(SvgPicture),
            ),
            matching: find.byType(Transform),
          ),
        )
        .any((t) => t.transform.storage[0] < 0);

    testWidgets('the send glyph points to the right: drawn as-is in LTR', (
      tester,
    ) async {
      stubThread();
      await pumpThread(tester);

      final glyph = tester.widget<SvgPicture>(
        find.descendant(of: sendButton, matching: find.byType(SvgPicture)),
      );
      expect(glyph.matchTextDirection, isTrue);
      expect(sendGlyphMirrored(tester), isFalse);
    });

    testWidgets('the send glyph points to the right: MIRRORED in RTL', (
      tester,
    ) async {
      stubThread();
      await pumpThread(tester, language: 'ar');

      expect(sendGlyphMirrored(tester), isTrue);
    });

    testWidgets('RTL: the closed bar mirrors and shows the English fallback', (
      tester,
    ) async {
      stubThread(ticket: closedTicket(ticketIdA));
      await pumpThread(tester, language: 'ar');

      final bar = tester.getRect(closedBar);
      final pill = tester.getCenter(find.byType(SupportClosedPill));
      final action = tester.getCenter(
        find.byKey(const Key('support_closed_new_ticket')),
      );
      // The pill leads at the right, the action ends at the left.
      expect(pill.dx, greaterThan(bar.center.dx));
      expect(action.dx, lessThan(bar.center.dx));
      expect(find.text('Closed'), findsOneWidget);
      expect(find.text('Create a New Ticket'), findsOneWidget);
    });
  });

  // -------------------------------------------------------------------------
  group('both canvases', () {
    for (final brightness in Brightness.values) {
      for (final language in languages) {
        testWidgets('${brightness.name} · $language builds, composer and '
            'error included, with the canvas\'s own tokens', (tester) async {
          final palette = brightness == Brightness.light
              ? AppColors.light
              : AppColors.dark;
          final elevation = brightness == Brightness.light
              ? AppElevation.light
              : AppElevation.dark;
          stubThread(messages: [supportMessage('m1', authorKind: 'staff')]);
          postCall().thenAnswer((_) async => throw const OfflineException());
          await pumpThread(tester, language: language, brightness: brightness);
          await typeReply(tester, 'x');
          await tapSend(tester);

          expect(tester.takeException(), isNull);
          expect(sendError, findsOneWidget);

          final bar = tester.widget<ElevatedSurface>(
            find
                .ancestor(
                  of: composerField,
                  matching: find.byType(ElevatedSurface),
                )
                .last,
          );
          expect(bar.color, palette.supportCardFill);
          expect(bar.shadows, elevation.supportComposerBarShadows);
          expect(bar.glass, elevation.supportComposerBarGlass);
          expect(
            brightness == Brightness.light
                ? bar.glass == null && bar.shadows.isNotEmpty
                : bar.glass != null && bar.shadows.isEmpty,
            isTrue,
            reason: 'light raises with a shadow, dark with Glass',
          );
        });

        testWidgets('${brightness.name} · $language builds the closed bar', (
          tester,
        ) async {
          stubThread(ticket: closedTicket(ticketIdA));
          await pumpThread(tester, language: language, brightness: brightness);

          expect(tester.takeException(), isNull);
          expect(closedBar, findsOneWidget);
        });
      }
    }
  });

  // -------------------------------------------------------------------------
  group('text scale', () {
    for (final language in languages) {
      testWidgets('2.0x · $language lays out without overflow: thread, '
          'composer with an error', (tester) async {
        stubThread(
          ticket: ticketDetail(
            ticketIdA,
            subject: 'A subject long enough to need an ellipsis at this size',
            details:
                'Details that wrap onto several lines when the text is '
                'twice the size, without any of it being clipped.',
          ),
          messages: [
            supportMessage(
              'm1',
              authorKind: 'staff',
              body: 'A long reply ' * 8,
            ),
          ],
        );
        postCall().thenAnswer(
          (_) async => throw const RateLimitedException(
            retryAfter: Duration(seconds: 90),
          ),
        );
        await pumpThread(
          tester,
          language: language,
          textScaler: const TextScaler.linear(2.0),
          size: const Size(402, 800),
        );
        expect(tester.takeException(), isNull);

        await typeReply(tester, 'Hello ' * 40);
        await tapSend(tester);

        expect(tester.takeException(), isNull);
        expect(sendError, findsOneWidget);
      });

      testWidgets('2.0x · $language lays out the closed bar', (tester) async {
        stubThread(ticket: closedTicket(ticketIdA));
        await pumpThread(
          tester,
          language: language,
          textScaler: const TextScaler.linear(2.0),
          size: const Size(402, 800),
        );

        expect(tester.takeException(), isNull);
        expect(closedBar, findsOneWidget);
      });
    }
  });

  // -------------------------------------------------------------------------
  group('semantics', () {
    testWidgets('the send glyph is EXCLUDED from semantics: no node, no tap '
        'action, no label', (tester) async {
      final handle = tester.ensureSemantics();
      stubThread();
      await pumpThread(tester);
      await typeReply(tester, 'Ready to send');

      // Structurally excluded…
      expect(
        tester
            .widget<ExcludeSemantics>(
              find
                  .ancestor(
                    of: sendButton,
                    matching: find.byType(ExcludeSemantics),
                  )
                  .first,
            )
            .excluding,
        isTrue,
      );
      // …so the nearest node above it is not a control: no tap action, not a
      // button. (Were the glyph exposed it would be its own tappable node.)
      final nearest = tester.getSemantics(sendButton);
      expect(
        nearest.getSemanticsData().hasAction(SemanticsAction.tap),
        isFalse,
      );
      expect(nearest.flagsCollection.isButton, isFalse);
      // And no label anywhere names it.
      for (final label in ['Send', 'إرسال']) {
        expect(find.bySemanticsLabel(label), findsNothing);
      }
      handle.dispose();
    });

    testWidgets('the composer field is a text field named by its hint', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      stubThread();
      await pumpThread(tester);

      // The field's node is the EditableText's: the TextField widget itself
      // has no node of its own.
      final node = tester.getSemantics(
        find.descendant(of: composerField, matching: find.byType(EditableText)),
      );
      expect(node.flagsCollection.isTextField, isTrue);
      expect(node.flagsCollection.isMultiline, isTrue);
      expect(node.hint + node.label, contains('Write your message'));
      handle.dispose();
    });

    testWidgets('a message is ONE node: the name and the text, no image role', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      stubThread(
        messages: [
          supportMessage('m1', authorKind: 'staff', body: 'We are looking.'),
        ],
      );
      await pumpThread(tester);

      for (final (row, name, body) in [
        (detailsRow, 'You', details),
        (messageRow('m1'), 'Customer Support', 'We are looking.'),
      ]) {
        final node = tester.getSemantics(row);
        expect(node.label, contains(name));
        expect(node.label, contains(body));
        expect(node.flagsCollection.isImage, isFalse);
        expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
      }
      handle.dispose();
    });

    testWidgets('the title is a header', (tester) async {
      final handle = tester.ensureSemantics();
      stubThread();
      await pumpThread(tester);

      expect(
        tester.getSemantics(find.text(subject)).flagsCollection.isHeader,
        isTrue,
      );
      handle.dispose();
    });

    for (final language in languages) {
      for (final closed in [false, true]) {
        testWidgets('${closed ? 'closed' : 'open'} · every tappable node IN '
            'SEMANTICS is labelled; the send glyph is excluded from semantics '
            'and measured separately ("the send tap target is exactly 48 x '
            '48") · $language', (tester) async {
          final handle = tester.ensureSemantics();
          stubThread(
            ticket: closed
                ? closedTicket(ticketIdA)
                : ticketDetail(ticketIdA, subject: subject, details: details),
            messages: [supportMessage('m1', authorKind: 'staff')],
          );
          await pumpThread(tester, language: language);
          if (!closed) await typeReply(tester, 'Draft');

          await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
          handle.dispose();
        });

        testWidgets('${closed ? 'closed' : 'open'} · every tappable node IN '
            'SEMANTICS is at least 48 dp, bar the shared back chip; the send '
            'glyph is excluded from semantics and measured separately '
            '("the send tap target is exactly 48 x 48") · $language', (
          tester,
        ) async {
          final handle = tester.ensureSemantics();
          stubThread(
            ticket: closed
                ? closedTicket(ticketIdA)
                : ticketDetail(ticketIdA, subject: subject, details: details),
            messages: [supportMessage('m1', authorKind: 'staff')],
          );
          await pumpThread(tester, language: language);

          await expectOnlyTheBackChipIsSmall(tester);
          handle.dispose();
        });
      }
    }
  });
}

/// Pumps long enough for a route transition and the frames after it.
Future<void> settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pump();
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
