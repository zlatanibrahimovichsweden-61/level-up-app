import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:level_up_app/l10n/app_localizations_ar.dart';
import 'package:level_up_app/l10n/app_localizations_en.dart';
import 'package:level_up_app/features/support/models/support_models.dart';
import 'package:level_up_app/features/support/notifier/create_ticket_notifier.dart';
import 'package:level_up_app/features/support/notifier/support_tickets_notifier.dart';
import 'package:level_up_app/features/support/repository/support_repository.dart';
import 'package:level_up_app/features/support/support_error_copy.dart';
import 'package:mocktail/mocktail.dart';

import 'support_fixtures.dart';

class _MockRepo extends Mock implements SupportRepository {}

/// Opening a ticket: one submit at a time, the list invalidated on success, and
/// a failure that keeps the form's text (the screen's job) behind an error.
void main() {
  late _MockRepo repo;

  setUp(() => repo = _MockRepo());

  ProviderContainer containerWith() {
    final container = ProviderContainer(
      overrides: [supportRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
    return container;
  }

  When<Future<SupportTicket>> createCall([String? subject, String? details]) =>
      when(
        () => repo.createSupportTicket(
          subject: subject ?? any(named: 'subject'),
          details: details ?? any(named: 'details'),
        ),
      );

  /// Mounts the form the way the screen does (a live listener).
  Future<CreateSupportTicketNotifier> open(ProviderContainer container) async {
    container.listen(createSupportTicketProvider, (_, _) {});
    await container.read(createSupportTicketProvider.future);
    return container.read(createSupportTicketProvider.notifier);
  }

  AsyncValue<SupportTicket?> state(ProviderContainer container) =>
      container.read(createSupportTicketProvider);

  test('starts with nothing submitted', () async {
    final container = containerWith();
    await open(container);

    expect(state(container).hasValue, isTrue);
    expect(state(container).value, isNull);
    expect(state(container).isLoading, isFalse);
    verifyZeroInteractions(repo);
  });

  group('submit - success', () {
    test(
      'sends the subject and details and ends on the created ticket',
      () async {
        createCall('Subject', 'Details').thenAnswer(
          (_) async => ticketDetail(
            ticketIdA,
            subject: 'Subject',
            details: 'Details',
            reference: 'TK-9',
          ),
        );
        final container = containerWith();
        final n = await open(container);

        await n.submit('Subject', 'Details');

        expect(state(container).value?.ticketId, ticketIdA);
        expect(state(container).value?.reference, 'TK-9');
        expect(state(container).hasError, isFalse);
        verify(
          () =>
              repo.createSupportTicket(subject: 'Subject', details: 'Details'),
        ).called(1);
      },
    );

    test('is AsyncLoading while the request is in flight', () async {
      final gate = Completer<SupportTicket>();
      createCall().thenAnswer((_) => gate.future);
      final container = containerWith();
      final n = await open(container);

      final submit = n.submit('S', 'D');

      expect(state(container).isLoading, isTrue);
      gate.complete(ticketDetail(ticketIdA));
      await submit;
      expect(state(container).isLoading, isFalse);
      expect(state(container).value, isNotNull);
    });

    test('invalidates the ticket list so the new ticket shows first', () async {
      createCall().thenAnswer((_) async => ticketDetail(ticketIdA));
      when(
        () => repo.listMySupportTickets(cursor: null),
      ).thenAnswer((_) async => ticketsPage([ticketSummary(ticketIdB)]));
      final container = containerWith();
      container.listen(supportTicketsProvider, (_, _) {});
      await container.read(supportTicketsProvider.future);
      final n = await open(container);

      await n.submit('S', 'D');
      await container.read(supportTicketsProvider.future);

      verify(() => repo.listMySupportTickets(cursor: null)).called(2);
    });

    test('hands the text to the repository untouched (it trims)', () async {
      createCall().thenAnswer((_) async => ticketDetail(ticketIdA));
      final container = containerWith();
      final n = await open(container);

      await n.submit('  Subject ', ' Details\n');

      verify(
        () => repo.createSupportTicket(
          subject: '  Subject ',
          details: ' Details\n',
        ),
      ).called(1);
    });
  });

  group('submit - one at a time', () {
    test(
      'a second call while one is in flight is ignored: ONE request',
      () async {
        final gate = Completer<SupportTicket>();
        createCall().thenAnswer((_) => gate.future);
        final container = containerWith();
        final n = await open(container);

        final first = n.submit('S', 'D');
        final second = n.submit('S', 'D');
        gate.complete(ticketDetail(ticketIdA));
        await Future.wait([first, second]);

        verify(
          () => repo.createSupportTicket(
            subject: any(named: 'subject'),
            details: any(named: 'details'),
          ),
        ).called(1);
        expect(state(container).value?.ticketId, ticketIdA);
      },
    );

    test('a double tap spends one create, not two', () async {
      // The server allows 5 creates per student per day.
      var created = 0;
      createCall().thenAnswer((_) async {
        created++;
        await Future<void>.delayed(Duration.zero);
        return ticketDetail('t$created');
      });
      final container = containerWith();
      final n = await open(container);

      unawaited(n.submit('S', 'D'));
      await n.submit('S', 'D');

      expect(created, 1);
    });
  });

  group('submit - failure', () {
    test('ends in AsyncError carrying the very error', () async {
      const error = RateLimitedException(retryAfter: Duration(seconds: 60));
      createCall().thenAnswer((_) async => throw error);
      final container = containerWith();
      final n = await open(container);

      await n.submit('S', 'D');

      expect(state(container).hasError, isTrue);
      expect(state(container).error, same(error));
      expect(state(container).value, isNull);
    });

    test('every failure type is kept as the error', () async {
      for (final error in <Object>[
        const OfflineException(),
        const NetworkException(detail: 'timeout'),
        const ValidationException(
          errors: {
            'subject': ['too long'],
          },
        ),
        const ApiException(status: 403, code: 'account_pending_deletion'),
        const ApiException(status: 500, code: 'internal_error'),
        const UnknownException(),
      ]) {
        createCall().thenAnswer((_) async => throw error);
        final container = containerWith();
        final n = await open(container);

        await n.submit('S', 'D');

        expect(state(container).error, same(error));
      }
    });

    test('a failed create does NOT invalidate the ticket list', () async {
      createCall().thenAnswer((_) async => throw const OfflineException());
      when(
        () => repo.listMySupportTickets(cursor: null),
      ).thenAnswer((_) async => ticketsPage([ticketSummary(ticketIdB)]));
      final container = containerWith();
      container.listen(supportTicketsProvider, (_, _) {});
      await container.read(supportTicketsProvider.future);
      final n = await open(container);

      await n.submit('S', 'D');
      await pumpEventQueue();

      verify(() => repo.listMySupportTickets(cursor: null)).called(1);
    });

    test('is not retried on its own - one request per tap', () async {
      createCall().thenAnswer((_) async => throw const OfflineException());
      final container = containerWith();
      final n = await open(container);

      await n.submit('S', 'D');
      await pumpEventQueue();

      verify(
        () => repo.createSupportTicket(
          subject: any(named: 'subject'),
          details: any(named: 'details'),
        ),
      ).called(1);
    });

    test('after a failure the student can submit again', () async {
      createCall().thenAnswer((_) async => throw const OfflineException());
      final container = containerWith();
      final n = await open(container);
      await n.submit('S', 'D');
      expect(state(container).hasError, isTrue);

      createCall().thenAnswer((_) async => ticketDetail(ticketIdA));
      await n.submit('S', 'D');

      expect(state(container).hasError, isFalse);
      expect(state(container).value?.ticketId, ticketIdA);
    });
  });

  group('submit - the form closed first', () {
    test('a ticket created after the screen closed writes no state but still '
        'refreshes the list', () async {
      final gate = Completer<SupportTicket>();
      createCall().thenAnswer((_) => gate.future);
      when(
        () => repo.listMySupportTickets(cursor: null),
      ).thenAnswer((_) async => ticketsPage([ticketSummary(ticketIdB)]));
      final container = containerWith();
      container.listen(supportTicketsProvider, (_, _) {});
      await container.read(supportTicketsProvider.future);
      final subscription = container.listen(
        createSupportTicketProvider,
        (_, _) {},
      );
      await container.read(createSupportTicketProvider.future);
      final n = container.read(createSupportTicketProvider.notifier);

      final submit = n.submit('S', 'D');
      subscription.close();
      await pumpEventQueue();
      expect(container.exists(createSupportTicketProvider), isFalse);
      gate.complete(ticketDetail(ticketIdA));

      // Writing `state` on a disposed notifier throws; the guard prevents it.
      await submit;
      await container.read(supportTicketsProvider.future);
      // The ticket exists either way, so the list behind the form learns of it.
      verify(() => repo.listMySupportTickets(cursor: null)).called(2);
    });

    test(
      'a failure that lands after the screen closed is dropped quietly',
      () async {
        final gate = Completer<SupportTicket>();
        createCall().thenAnswer((_) => gate.future);
        final container = containerWith();
        final subscription = container.listen(
          createSupportTicketProvider,
          (_, _) {},
        );
        await container.read(createSupportTicketProvider.future);
        final n = container.read(createSupportTicketProvider.notifier);

        final submit = n.submit('S', 'D');
        subscription.close();
        await pumpEventQueue();
        gate.completeError(const OfflineException());

        await submit;
      },
    );
  });

  // `support_error_copy.dart` has no test file of its own in this increment's
  // list; its three functions are exercised here, beside the form failures they
  // map. Move them if a screen increment adds one.
  group('failure copy (support_error_copy.dart)', () {
    final locales = <AppLocalizations>[
      AppLocalizationsEn(),
      AppLocalizationsAr(),
    ];

    const pendingDeletion = ApiException(
      status: 403,
      code: 'account_pending_deletion',
    );
    const notFound = ApiException(status: 404, code: 'not_found');

    group('supportLoadFailureText', () {
      test('pending deletion says so; a rate limit says so; everything else is '
          'the generic error', () {
        for (final l10n in locales) {
          expect(
            supportLoadFailureText(l10n, pendingDeletion),
            l10n.accountPendingDeletion,
          );
          for (final error in <Object?>[
            const ApiException(status: 500, code: 'internal_error'),
            notFound,
            const UnknownException(),
            const UnauthorizedException(code: 'authentication_required'),
            null,
          ]) {
            expect(
              supportLoadFailureText(l10n, error),
              l10n.genericError,
              reason: '$error',
            );
          }
        }
      });

      test('a 429 reads as rateLimitedIn(seconds) when Retry-After is known, '
          'else rateLimited - never the generic error', () {
        for (final l10n in locales) {
          expect(
            supportLoadFailureText(
              l10n,
              const RateLimitedException(retryAfter: Duration(seconds: 90)),
            ),
            l10n.rateLimitedIn(90),
          );
          expect(
            supportLoadFailureText(l10n, const RateLimitedException()),
            l10n.rateLimited,
          );
          expect(l10n.rateLimited, isNot(l10n.genericError));
        }
      });

      test('offline is not handled here: it is its own screen state', () {
        for (final l10n in locales) {
          expect(
            supportLoadFailureText(l10n, const OfflineException()),
            l10n.genericError,
          );
        }
      });
    });

    group('supportRetryAllowed', () {
      test('withheld for a rate limit, a pending deletion and a 404', () {
        expect(supportRetryAllowed(const RateLimitedException()), isFalse);
        expect(
          supportRetryAllowed(
            const RateLimitedException(retryAfter: Duration(seconds: 30)),
          ),
          isFalse,
        );
        expect(supportRetryAllowed(pendingDeletion), isFalse);
        expect(supportRetryAllowed(notFound), isFalse);
      });

      test('offered for everything else', () {
        for (final error in <Object?>[
          const OfflineException(),
          const NetworkException(detail: 'timeout'),
          const ApiException(status: 500, code: 'internal_error'),
          // A 404 under another code is not "that ticket is not yours".
          const ApiException(status: 404, code: 'country_not_found'),
          const ApiException(status: 403, code: 'some_other_403'),
          const UnauthorizedException(code: 'authentication_required'),
          const ValidationException(errors: {}),
          const UnknownException(),
          null,
        ]) {
          expect(supportRetryAllowed(error), isTrue, reason: '$error');
        }
      });
    });

    group('supportActionFailureText', () {
      test('offline and transport failures read as offline', () {
        for (final l10n in locales) {
          expect(
            supportActionFailureText(l10n, const OfflineException()),
            l10n.offline,
          );
          expect(
            supportActionFailureText(
              l10n,
              const NetworkException(detail: 'timeout'),
            ),
            l10n.offline,
          );
        }
      });

      test('a rate limit with a known Retry-After counts the seconds', () {
        for (final l10n in locales) {
          expect(
            supportActionFailureText(
              l10n,
              const RateLimitedException(retryAfter: Duration(seconds: 90)),
            ),
            l10n.rateLimitedIn(90),
          );
        }
      });

      test('a rate limit with no Retry-After stands alone', () {
        for (final l10n in locales) {
          expect(
            supportActionFailureText(l10n, const RateLimitedException()),
            l10n.rateLimited,
          );
        }
      });

      test('pending deletion says so', () {
        for (final l10n in locales) {
          expect(
            supportActionFailureText(l10n, pendingDeletion),
            l10n.accountPendingDeletion,
          );
        }
      });

      test('a validation failure is the validation copy, never the server '
          'text', () {
        for (final l10n in locales) {
          final text = supportActionFailureText(
            l10n,
            const ValidationException(
              errors: {
                'subject': ['Server wording that must not be shown'],
              },
            ),
          );

          expect(text, l10n.errorValidationFailed);
          expect(text, isNot(contains('Server wording')));
        }
      });

      test('anything else is the generic error', () {
        for (final l10n in locales) {
          for (final error in <Object?>[
            const ApiException(status: 500, code: 'internal_error'),
            notFound,
            const UnknownException(),
            null,
          ]) {
            expect(
              supportActionFailureText(l10n, error),
              l10n.genericError,
              reason: '$error',
            );
          }
        }
      });
    });
  });
}
