import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/features/account_shells/screens/customer_support_screen.dart';
import 'package:level_up_app/features/profile/repository/profile_repository.dart';
import 'package:level_up_app/features/support/models/support_models.dart';
import 'package:level_up_app/features/support/repository/support_repository.dart';
import 'package:level_up_app/features/support/screens/create_support_ticket_screen.dart';
import 'package:level_up_app/features/support/screens/support_ticket_screen.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import 'support_fixtures.dart';

class _MockRepo extends Mock implements SupportRepository {}

class _MockProfileRepo extends Mock implements ProfileRepository {}

/// The create-ticket screen · `CreateSupportTicketScreen` · Figma `178:3222`.
///
/// The form's pre-flight and the server's rejections, the single in-flight
/// submit, the replace-with-thread success, every failure's copy, the limits,
/// RTL with the English fallback for the unapproved strings, both canvases,
/// text scale and the accessibility guidelines.
void main() {
  late _MockRepo repo;
  late _MockProfileRepo profile;

  setUp(() {
    repo = _MockRepo();
    profile = _MockProfileRepo();
    // The thread (success lands on it) reads `GET /me` for the avatar; it is
    // not under test here, and a failure leaves the disc on its gradient.
    when(profile.getMe).thenAnswer(
      (_) async => throw const ApiException(status: 500, code: 'internal'),
    );
    when(
      () => repo.listMySupportTickets(cursor: any(named: 'cursor')),
    ).thenAnswer((_) async => ticketsPage([]));
    when(
      () => repo.getMySupportTicket(any()),
    ).thenAnswer((_) async => ticketDetail(ticketIdA));
    when(
      () =>
          repo.listMySupportTicketMessages(any(), cursor: any(named: 'cursor')),
    ).thenAnswer((_) async => messagesPage([]));
  });

  When<Future<SupportTicket>> createCall() => when(
    () => repo.createSupportTicket(
      subject: any(named: 'subject'),
      details: any(named: 'details'),
    ),
  );

  VerificationResult verifyCreate({String? subject, String? details}) => verify(
    () => repo.createSupportTicket(
      subject: subject ?? any(named: 'subject'),
      details: details ?? any(named: 'details'),
    ),
  );

  /// Mounts the create screen. With [viaList] the list is under it, as when a
  /// student taps the card, so a success can be seen refetching it and Back
  /// from the new thread can be seen landing on it.
  Future<GoRouter> pumpCreate(
    WidgetTester tester, {
    String language = 'en',
    Brightness brightness = Brightness.light,
    TextScaler textScaler = TextScaler.noScaling,
    Size size = const Size(402, 1200),
    bool viaList = false,
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
        overrides: [
          supportRepositoryProvider.overrideWithValue(repo),
          profileRepositoryProvider.overrideWithValue(profile),
        ],
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

    if (viaList) {
      router.push('/support');
      await settle(tester);
    }
    router.push('/support/new');
    await settle(tester);
    return router;
  }

  Future<AppLocalizations> l10nFor(String language) =>
      AppLocalizations.delegate.load(Locale(language));

  final subjectField = find.byKey(const Key('support_subject_field'));
  final detailsField = find.byKey(const Key('support_details_field'));
  final submitButton = find.byKey(const Key('support_submit'));
  final createError = find.byKey(const Key('support_create_error'));

  String location(GoRouter router) => router.state.uri.toString();

  /// Types into a field the way a student does.
  Future<void> typeInto(WidgetTester tester, Finder field, String text) async {
    await tester.enterText(field, text);
    await tester.pump();
  }

  Future<void> submit(WidgetTester tester) async {
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pump();
    await tester.pump();
  }

  /// Fills both fields and submits.
  Future<void> fillAndSubmit(WidgetTester tester) async {
    await typeInto(tester, subjectField, 'Cannot open a lecture');
    await typeInto(tester, detailsField, 'It spins forever after the update.');
    await submit(tester);
  }

  /// A field's inline error line, by the `Text` it shows under the field's
  /// section.
  Finder errorUnder(String sectionKey, String text) => find.descendant(
    of: find.byKey(Key(sectionKey)),
    matching: find.text(text),
  );

  const languages = ['en', 'ar'];

  // -------------------------------------------------------------------------
  group('the form', () {
    for (final language in languages) {
      testWidgets('shows the heading, both fields and the button · $language', (
        tester,
      ) async {
        final l10n = await l10nFor(language);
        await pumpCreate(tester, language: language);

        // `createTicket` is approved in both languages; everything else here
        // has no approved Arabic and shows the English text (the copy register).
        expect(find.text(l10n.createTicket), findsOneWidget);
        expect(find.text(l10n.supportNewTicketTitle), findsOneWidget);
        expect(find.text(l10n.supportCreateTicketSubtitle), findsOneWidget);
        expect(find.text(l10n.supportSubjectLabel), findsOneWidget);
        expect(find.text(l10n.supportDetailsLabel), findsOneWidget);
        expect(find.text(l10n.supportDetailsHint), findsOneWidget);
        expect(find.text(l10n.supportSubmitTicket), findsOneWidget);
        expect(subjectField, findsOneWidget);
        expect(detailsField, findsOneWidget);
        expect(submitButton, findsOneWidget);
        // Photos and voice are not part of this wave: nothing is drawn for them.
        expect(find.byIcon(Icons.camera_alt), findsNothing);
        expect(find.byIcon(Icons.mic), findsNothing);
      });
    }

    testWidgets('the subject has no hint, the details has the frame\'s', (
      tester,
    ) async {
      await pumpCreate(tester);

      expect(
        tester.widget<TextField>(subjectField).decoration!.hintText,
        isNull,
      );
      expect(
        tester.widget<TextField>(detailsField).decoration!.hintText,
        'Describe the issue in detail...',
      );
    });

    testWidgets('the details field is multiline, the subject is one line', (
      tester,
    ) async {
      await pumpCreate(tester);

      final subject = tester.widget<TextField>(subjectField);
      expect(subject.maxLines, 1);
      expect(subject.textInputAction, TextInputAction.next);
      final details = tester.widget<TextField>(detailsField);
      expect(details.maxLines, isNull, reason: 'grows with its text');
      expect(details.keyboardType, TextInputType.multiline);
    });

    testWidgets('the inputs are DRAWN the frame\'s 43 and 94 high, inside '
        'fields that are at least 48', (tester) async {
      await pumpCreate(tester);

      Finder surfaces(String section) => find.descendant(
        of: find.byKey(Key(section)),
        matching: find.byType(ElevatedSurface),
      );

      // The field is the tap target: Android's 48 minimum (the details field
      // is already taller than that).
      expect(tester.getSize(subjectField).height, closeTo(48, 0.01));
      expect(tester.getSize(detailsField).height, closeTo(94, 0.01));

      // The drawing is the frame's. `.at(0)` is the section, `.at(1)` the input.
      final subjectInput = tester.getRect(
        surfaces('support_create_subject_section').at(1),
      );
      expect(subjectInput.height, closeTo(43, 0.01));
      final field = tester.getRect(subjectField);
      expect(subjectInput.top - field.top, closeTo(2.5, 0.01));
      expect(field.bottom - subjectInput.bottom, closeTo(2.5, 0.01));
      expect(
        tester.getRect(surfaces('support_create_details_section').at(1)).height,
        closeTo(94, 0.01),
      );

      // Both sections keep the frame's height (107 and 165), give or take the
      // label line: the app's 14 / 18 against the frame's 17.2.
      expect(
        tester
            .getSize(find.byKey(const Key('support_create_subject_section')))
            .height,
        closeTo(107, 1),
      );
      expect(
        tester
            .getSize(find.byKey(const Key('support_create_details_section')))
            .height,
        closeTo(165, 1),
      );
    });

    testWidgets('the limits are enforced as you type: 120 and 4000', (
      tester,
    ) async {
      await pumpCreate(tester);

      await typeInto(tester, subjectField, 'a' * 130);
      await typeInto(tester, detailsField, 'b' * 4100);

      expect(
        tester.widget<TextField>(subjectField).controller!.text.length,
        120,
      );
      expect(
        tester.widget<TextField>(detailsField).controller!.text.length,
        4000,
      );
      // No counter text: the cap is a formatter, not a visible budget.
      expect(find.text('120/120'), findsNothing);
      expect(find.text('4000/4000'), findsNothing);
    });

    testWidgets('Back pops to where the student came from', (tester) async {
      final router = await pumpCreate(tester);

      await tester.tap(find.byKey(const Key('support_new_back')));
      await settle(tester);

      expect(location(router), '/start');
    });
  });

  // -------------------------------------------------------------------------
  group('validation before the request', () {
    for (final language in languages) {
      testWidgets('empty fields: fieldRequired under BOTH, no request · '
          '$language', (tester) async {
        final l10n = await l10nFor(language);
        await pumpCreate(tester, language: language);

        await submit(tester);

        expect(
          errorUnder('support_create_subject_section', l10n.fieldRequired),
          findsOneWidget,
        );
        expect(
          errorUnder('support_create_details_section', l10n.fieldRequired),
          findsOneWidget,
        );
        verifyNever(
          () => repo.createSupportTicket(
            subject: any(named: 'subject'),
            details: any(named: 'details'),
          ),
        );
      });
    }

    testWidgets('whitespace only counts as empty', (tester) async {
      await pumpCreate(tester);

      await typeInto(tester, subjectField, '    ');
      await typeInto(tester, detailsField, '\n \t ');
      await submit(tester);

      expect(find.text('This field is required'), findsNWidgets(2));
      verifyNever(
        () => repo.createSupportTicket(
          subject: any(named: 'subject'),
          details: any(named: 'details'),
        ),
      );
    });

    testWidgets('only the empty field is flagged', (tester) async {
      await pumpCreate(tester);

      await typeInto(tester, subjectField, 'A subject');
      await submit(tester);

      expect(
        errorUnder('support_create_subject_section', 'This field is required'),
        findsNothing,
      );
      expect(
        errorUnder('support_create_details_section', 'This field is required'),
        findsOneWidget,
      );
    });

    testWidgets('editing a flagged field clears ITS error only', (
      tester,
    ) async {
      await pumpCreate(tester);
      await submit(tester);
      expect(find.text('This field is required'), findsNWidgets(2));

      await typeInto(tester, subjectField, 'x');

      expect(find.text('This field is required'), findsOneWidget);
      expect(
        errorUnder('support_create_details_section', 'This field is required'),
        findsOneWidget,
      );
    });
  });

  // -------------------------------------------------------------------------
  group('submitting', () {
    testWidgets('sends the TRIMMED subject and details, once', (tester) async {
      createCall().thenAnswer((_) async => ticketDetail(ticketIdA));
      await pumpCreate(tester);

      await typeInto(tester, subjectField, '  Cannot open a lecture  ');
      await typeInto(tester, detailsField, '\n It spins forever. \n');
      await submit(tester);
      await settle(tester);

      verifyCreate(
        subject: 'Cannot open a lecture',
        details: 'It spins forever.',
      ).called(1);
    });

    for (final language in languages) {
      testWidgets('while in flight: spinner, disabled fields, a disabled '
          'button and a second tap sends nothing · $language', (tester) async {
        final l10n = await l10nFor(language);
        final pending = Completer<SupportTicket>();
        createCall().thenAnswer((_) => pending.future);
        await pumpCreate(tester, language: language);

        await fillAndSubmit(tester);

        final button = tester.widget<FilledButton>(submitButton);
        expect(button.onPressed, isNull, reason: 'no tap target in flight');
        expect(
          find.descendant(
            of: submitButton,
            matching: find.byType(CircularProgressIndicator),
          ),
          findsOneWidget,
        );
        expect(find.text(l10n.supportSubmitTicket), findsNothing);
        expect(tester.widget<TextField>(subjectField).enabled, isFalse);
        expect(tester.widget<TextField>(detailsField).enabled, isFalse);

        await tester.tap(submitButton, warnIfMissed: false);
        await tester.pump();
        verifyCreate().called(1);

        pending.complete(ticketDetail(ticketIdA));
        await settle(tester);
      });
    }

    testWidgets('success REPLACES the form with the new thread: Back lands on '
        'the list, and the list is asked again', (tester) async {
      createCall().thenAnswer(
        (_) async => ticketDetail(ticketIdB, subject: 'Cannot open a lecture'),
      );
      when(
        () => repo.getMySupportTicket(ticketIdB),
      ).thenAnswer((_) async => ticketDetail(ticketIdB));
      final router = await pumpCreate(tester, viaList: true);
      expect(location(router), '/support/new');
      verify(() => repo.listMySupportTickets(cursor: null)).called(1);

      await fillAndSubmit(tester);
      await settle(tester);

      expect(location(router), '/support/tickets/$ticketIdB');
      expect(find.byType(SupportTicketScreen), findsOneWidget);
      expect(find.byType(CreateSupportTicketScreen), findsNothing);

      // Back from the thread is the LIST, not the form that was just sent.
      await tester.tap(find.byKey(const Key('support_thread_back')));
      await settle(tester);

      expect(location(router), '/support');
      expect(find.byType(CreateSupportTicketScreen), findsNothing);
      // The new ticket belongs at the top of the list, which is asked again.
      // (The list was behind the form, a paused listener: Riverpod 3 rebuilds
      // an invalidated provider when its listener is visible again.)
      verify(() => repo.listMySupportTickets(cursor: null)).called(1);
    });
  });

  // -------------------------------------------------------------------------
  group('failure', () {
    for (final language in languages) {
      group(language, () {
        testWidgets('a 400 field map: fieldRejected under the named field, '
            'the banner, and the text stays', (tester) async {
          final l10n = await l10nFor(language);
          createCall().thenAnswer(
            (_) async => throw const ValidationException(
              errors: {
                'subject': ['too short'],
              },
            ),
          );
          await pumpCreate(tester, language: language);

          await fillAndSubmit(tester);

          expect(
            errorUnder('support_create_subject_section', l10n.fieldRejected),
            findsOneWidget,
          );
          expect(
            errorUnder('support_create_details_section', l10n.fieldRejected),
            findsNothing,
          );
          expect(
            find.descendant(
              of: createError,
              matching: find.text(l10n.errorValidationFailed),
            ),
            findsOneWidget,
          );
          // The server's own words are never shown.
          expect(find.text('too short'), findsNothing);
          expect(
            tester.widget<TextField>(subjectField).controller!.text,
            'Cannot open a lecture',
          );
          expect(
            tester.widget<TextField>(detailsField).controller!.text,
            'It spins forever after the update.',
          );
        });

        testWidgets('a 400 naming the details field flags the details', (
          tester,
        ) async {
          final l10n = await l10nFor(language);
          createCall().thenAnswer(
            (_) async => throw const ValidationException(
              errors: {
                'details': ['bad'],
              },
            ),
          );
          await pumpCreate(tester, language: language);

          await fillAndSubmit(tester);

          expect(
            errorUnder('support_create_details_section', l10n.fieldRejected),
            findsOneWidget,
          );
          expect(
            errorUnder('support_create_subject_section', l10n.fieldRejected),
            findsNothing,
          );
        });

        testWidgets('a 400 naming a field the form lacks: the banner only', (
          tester,
        ) async {
          final l10n = await l10nFor(language);
          createCall().thenAnswer(
            (_) async => throw const ValidationException(
              errors: {
                'attachmentIds': ['no'],
              },
            ),
          );
          await pumpCreate(tester, language: language);

          await fillAndSubmit(tester);

          expect(find.text(l10n.fieldRejected), findsNothing);
          expect(
            find.descendant(
              of: createError,
              matching: find.text(l10n.errorValidationFailed),
            ),
            findsOneWidget,
          );
        });

        testWidgets('429 with a Retry-After: rateLimitedIn(seconds)', (
          tester,
        ) async {
          final l10n = await l10nFor(language);
          createCall().thenAnswer(
            (_) async => throw const RateLimitedException(
              retryAfter: Duration(seconds: 3600),
            ),
          );
          await pumpCreate(tester, language: language);

          await fillAndSubmit(tester);

          expect(
            find.descendant(
              of: createError,
              matching: find.text(l10n.rateLimitedIn(3600)),
            ),
            findsOneWidget,
          );
        });

        testWidgets('429 without a Retry-After: rateLimited', (tester) async {
          final l10n = await l10nFor(language);
          createCall().thenAnswer(
            (_) async => throw const RateLimitedException(),
          );
          await pumpCreate(tester, language: language);

          await fillAndSubmit(tester);

          expect(
            find.descendant(
              of: createError,
              matching: find.text(l10n.rateLimited),
            ),
            findsOneWidget,
          );
        });

        testWidgets('offline: its own copy, and a second try is possible', (
          tester,
        ) async {
          final l10n = await l10nFor(language);
          createCall().thenAnswer((_) async => throw const OfflineException());
          await pumpCreate(tester, language: language);

          await fillAndSubmit(tester);

          expect(
            find.descendant(of: createError, matching: find.text(l10n.offline)),
            findsOneWidget,
          );
          expect(find.text(l10n.genericError), findsNothing);
          // Not stuck: the button is live again and the text is still there.
          expect(
            tester.widget<FilledButton>(submitButton).onPressed,
            isNotNull,
          );
          expect(tester.widget<TextField>(subjectField).enabled, isTrue);

          createCall().thenAnswer((_) async => ticketDetail(ticketIdA));
          await submit(tester);
          await settle(tester);
          verifyCreate().called(2);
        });

        testWidgets('the failure banner is a live region, so a screen reader '
            'announces it', (tester) async {
          final l10n = await l10nFor(language);
          final handle = tester.ensureSemantics();
          createCall().thenAnswer((_) async => throw const OfflineException());
          await pumpCreate(tester, language: language);

          await fillAndSubmit(tester);

          final node = tester.getSemantics(createError);
          expect(node.flagsCollection.isLiveRegion, isTrue);
          expect(node.label, contains(l10n.offline));
          handle.dispose();
        });

        testWidgets('pending deletion: its own copy', (tester) async {
          final l10n = await l10nFor(language);
          createCall().thenAnswer(
            (_) async => throw const ApiException(
              status: 403,
              code: 'account_pending_deletion',
            ),
          );
          await pumpCreate(tester, language: language);

          await fillAndSubmit(tester);

          expect(
            find.descendant(
              of: createError,
              matching: find.text(l10n.accountPendingDeletion),
            ),
            findsOneWidget,
          );
        });

        testWidgets('anything else: genericError', (tester) async {
          final l10n = await l10nFor(language);
          createCall().thenAnswer(
            (_) async => throw const ApiException(
              status: 500,
              code: 'internal_server_error',
            ),
          );
          await pumpCreate(tester, language: language);

          await fillAndSubmit(tester);

          expect(
            find.descendant(
              of: createError,
              matching: find.text(l10n.genericError),
            ),
            findsOneWidget,
          );
        });
      });
    }

    testWidgets('editing after a failure clears the banner and the rejected '
        'mark', (tester) async {
      createCall().thenAnswer(
        (_) async => throw const ValidationException(
          errors: {
            'subject': ['x'],
          },
        ),
      );
      await pumpCreate(tester);
      await fillAndSubmit(tester);
      expect(createError, findsOneWidget);
      expect(find.text('Please check this field'), findsOneWidget);

      await typeInto(tester, subjectField, 'A better subject');

      expect(createError, findsNothing);
      expect(find.text('Please check this field'), findsNothing);
    });
  });

  // -------------------------------------------------------------------------
  group('direction', () {
    testWidgets('LTR: the labels and the back chip start at the left', (
      tester,
    ) async {
      await pumpCreate(tester);

      final screen = tester.element(find.byType(CreateSupportTicketScreen));
      expect(Directionality.of(screen), TextDirection.ltr);

      final label = tester.getRect(find.text('Subject'));
      final section = tester.getRect(
        find.byKey(const Key('support_create_subject_section')),
      );
      expect(label.left - section.left, closeTo(20, 0.5));
      expect(
        tester.getCenter(find.byKey(const Key('support_new_back'))).dx,
        lessThan(201),
      );
    });

    testWidgets('RTL: the labels and the back chip start at the RIGHT, and '
        'the unapproved copy is English', (tester) async {
      await pumpCreate(tester, language: 'ar');

      final screen = tester.element(find.byType(CreateSupportTicketScreen));
      expect(Directionality.of(screen), TextDirection.rtl);

      final label = tester.getRect(find.text('Subject'));
      final section = tester.getRect(
        find.byKey(const Key('support_create_subject_section')),
      );
      // Start is the right edge: 20 in from it.
      expect(section.right - label.right, closeTo(20, 0.5));
      expect(
        tester.getCenter(find.byKey(const Key('support_new_back'))).dx,
        greaterThan(201),
      );
      // The heading is the approved Arabic; the rest has no approved Arabic.
      expect(find.text('إنشاء تذكرة'), findsOneWidget);
      expect(find.text('New Ticket'), findsOneWidget);
      expect(
        find.text('Describe your issue and we\'ll help you'),
        findsOneWidget,
      );
      expect(find.text('Subject'), findsOneWidget);
      expect(find.text('Details'), findsOneWidget);
      expect(find.text('Describe the issue in detail...'), findsOneWidget);
      expect(find.text('Submit Ticket'), findsOneWidget);
    });

    testWidgets('RTL: a rejected field and the banner follow the direction', (
      tester,
    ) async {
      createCall().thenAnswer(
        (_) async => throw const ValidationException(
          errors: {
            'subject': ['x'],
          },
        ),
      );
      await pumpCreate(tester, language: 'ar');

      await fillAndSubmit(tester);

      final l10n = await l10nFor('ar');
      final section = tester.getRect(
        find.byKey(const Key('support_create_subject_section')),
      );
      final icon = tester.getRect(
        find.descendant(
          of: find.byKey(const Key('support_create_subject_section')),
          matching: find.byIcon(Icons.error_outline),
        ),
      );
      expect(find.text(l10n.fieldRejected), findsOneWidget);
      // The error icon leads at the right.
      expect(icon.center.dx, greaterThan(section.center.dx));
    });
  });

  // -------------------------------------------------------------------------
  group('both canvases', () {
    for (final brightness in Brightness.values) {
      for (final language in languages) {
        testWidgets('${brightness.name} · $language builds, with the '
            'canvas\'s own tokens, errors included', (tester) async {
          final palette = brightness == Brightness.light
              ? AppColors.light
              : AppColors.dark;
          final elevation = brightness == Brightness.light
              ? AppElevation.light
              : AppElevation.dark;
          createCall().thenAnswer((_) async => throw const OfflineException());
          await pumpCreate(tester, language: language, brightness: brightness);
          await submit(tester);
          await typeInto(tester, subjectField, 'Subject');
          await typeInto(tester, detailsField, 'Details');
          await submit(tester);

          expect(tester.takeException(), isNull);

          final section = tester.widget<ElevatedSurface>(
            find
                .descendant(
                  of: find.byKey(const Key('support_create_subject_section')),
                  matching: find.byType(ElevatedSurface),
                )
                .first,
          );
          expect(section.color, palette.supportCardFill);
          expect(section.shadows, elevation.supportFieldSectionShadows);
          expect(section.glass, elevation.supportFieldSectionGlass);
          expect(
            brightness == Brightness.light
                ? section.glass == null && section.shadows.isNotEmpty
                : section.glass != null && section.shadows.isEmpty,
            isTrue,
            reason: 'light raises with a shadow, dark with Glass',
          );
        });
      }
    }
  });

  // -------------------------------------------------------------------------
  group('text scale', () {
    for (final language in languages) {
      testWidgets('2.0x · $language lays out without overflow, errors and '
          'all', (tester) async {
        createCall().thenAnswer(
          (_) async => throw const RateLimitedException(
            retryAfter: Duration(seconds: 3600),
          ),
        );
        await pumpCreate(
          tester,
          language: language,
          textScaler: const TextScaler.linear(2.0),
          size: const Size(402, 800),
        );

        // Both flagged, then a server failure under the button.
        await submit(tester);
        expect(tester.takeException(), isNull);

        await typeInto(tester, subjectField, 'x' * 100);
        await typeInto(tester, detailsField, 'y' * 400);
        await submit(tester);

        expect(tester.takeException(), isNull);
        expect(createError, findsOneWidget);
        // The inputs grew past their minimum with the text instead of clipping.
        expect(tester.getSize(detailsField).height, greaterThanOrEqualTo(94));
      });
    }
  });

  // -------------------------------------------------------------------------
  group('semantics', () {
    testWidgets('each field is named by its label, once', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpCreate(tester);

      final subject = tester.getSemantics(subjectField);
      expect(subject.flagsCollection.isTextField, isTrue);
      expect(subject.label, contains('Subject'));
      final details = tester.getSemantics(detailsField);
      expect(details.flagsCollection.isTextField, isTrue);
      expect(details.label, contains('Details'));
      handle.dispose();
    });

    // Only the "Create Ticket" heading is asserted: the bar's own title comes
    // from the shared `TitledChrome`, which marks no header (not this wave's to
    // change), so the old name's claim about "the screen title" was not true.
    testWidgets('the Create Ticket heading is a header', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpCreate(tester);

      expect(
        tester
            .getSemantics(find.text('Create Ticket'))
            .flagsCollection
            .isHeader,
        isTrue,
      );
      handle.dispose();
    });

    for (final language in languages) {
      testWidgets('every tappable node is labelled · $language', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();
        createCall().thenAnswer((_) async => throw const OfflineException());
        await pumpCreate(tester, language: language);
        await submit(tester);

        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        handle.dispose();
      });

      testWidgets('every tappable node is at least 48 dp, bar the shared back '
          'chip · $language', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpCreate(tester, language: language);
        await submit(tester);

        await expectOnlyTheBackChipIsSmall(tester);
        handle.dispose();
      });
    }

    testWidgets('the submit button reads as one labelled button', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpCreate(tester);

      final node = tester.getSemantics(submitButton);
      expect(node.flagsCollection.isButton, isTrue);
      expect(node.label, 'Submit Ticket');
      handle.dispose();
    });
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
