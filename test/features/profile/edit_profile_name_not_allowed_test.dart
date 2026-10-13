import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/core/session/session_scope.dart';
import 'package:level_up_app/core/widgets/form_fields.dart';
import 'package:level_up_app/features/profile/models/profile_update.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:level_up_app/features/profile/notifier/edit_profile_notifier.dart';
import 'package:level_up_app/features/profile/profile_error_copy.dart';
import 'package:level_up_app/features/profile/repository/profile_repository.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import 'profile_fixtures.dart';
import 'profile_harness.dart';

/// `422 name_not_allowed` on `PATCH /me` (upstream contract 3.47.0-m1, built
/// ahead of the vendored 3.46.0-m1 pin on the owner's word, 2026-10-10;
/// staging already enforces it).
///
/// Before this, the refusal read "Something went wrong" with no field marked.
/// It now marks the name field with the approved "Please check this field"
/// and the banner reads the approved validation line, exactly as a `400` on
/// the name does. No new copy.
///
/// O-17 (owner, 2026-10-11): sign-up's rule applies here too. A refused name
/// is never sent again on this visit to Edit Profile: Save with it, spaces
/// around it or not, sends nothing and states the refusal again. Only a
/// different name takes the mark off, and that name is sent once, as usual.
/// Other failures are not remembered, and a save without the name goes out.

/// The server's refusal. The response does not repeat the name.
const _nameNotAllowed = ApiException(status: 422, code: 'name_not_allowed');

/// Any name will do: the server decides what is blocked, the app never does.
const _refused = 'Refused Name';
const _corrected = 'Another Name';

/// The fixture student's saved name (`profile_fixtures.dart`).
const _saved = 'Ahmed Mohamed';

/// Sign-out's real session reset, run from a live ref.
final _sessionReset = Provider<void Function()>(
  (ref) =>
      () => invalidateSessionScope(ref),
);

void main() {
  setUpAll(() => registerFallbackValue(const ProfileUpdate()));

  MockProfileRepository refusingRepo([Object failure = _nameNotAllowed]) {
    final repo = profileRepo();
    when(() => repo.updateMe(any())).thenThrow(failure);
    return repo;
  }

  /// Refuses the first save and accepts every later one.
  MockProfileRepository refusingOnce() {
    final repo = profileRepo();
    var calls = 0;
    when(() => repo.updateMe(any())).thenAnswer((_) async {
      if (++calls == 1) throw _nameNotAllowed;
      return schoolProfile();
    });
    return repo;
  }

  Finder input(String key) => find.descendant(
    of: find.byKey(Key(key)),
    matching: find.byType(TextField),
  );

  PlainTextField field(WidgetTester tester, String key) =>
      tester.widget<PlainTextField>(find.byKey(Key(key)));

  String nameText(WidgetTester tester) =>
      tester.widget<TextField>(input('edit_name_field')).controller!.text;

  Finder banner(String text) => find.descendant(
    of: find.byKey(const Key('edit_save_error')),
    matching: find.text(text),
  );

  Future<void> save(WidgetTester tester) =>
      tapProfileKey(tester, 'edit_save_button');

  Future<void> typeName(WidgetTester tester, String name) async {
    await tester.enterText(input('edit_name_field'), name);
    await tester.pumpAndSettle();
  }

  /// The one request since the last verification, as sent.
  Map<String, dynamic> sentOnce(MockProfileRepository repo) =>
      (verify(() => repo.updateMe(captureAny())).captured.single
              as ProfileUpdate)
          .toJson();

  for (final language in ['en', 'ar']) {
    final l10n = lookupAppLocalizations(Locale(language));

    group(language, () {
      testWidgets('a refused name marks the name field with the approved '
          'line, keeps what was typed, and is not resent', (tester) async {
        final repo = refusingRepo();
        final container = await pumpEditProfile(
          tester,
          profile: repo,
          locale: language,
        );

        await tester.enterText(input('edit_name_field'), _refused);
        await save(tester);

        // The approved field line, under the name and above the email.
        final line = find.text(l10n.fieldRejected);
        expect(line, findsOneWidget);
        expect(
          tester.getTopLeft(line).dy,
          greaterThan(
            tester.getBottomLeft(find.byKey(const Key('edit_name_field'))).dy,
          ),
        );
        expect(
          tester.getTopLeft(line).dy,
          lessThan(
            tester.getTopLeft(find.byKey(const Key('edit_email_field'))).dy,
          ),
        );
        expect(field(tester, 'edit_name_field').hasError, isTrue);
        expect(field(tester, 'edit_email_field').hasError, isFalse);

        // The banner is the approved validation line, not the generic one.
        expect(banner(l10n.errorValidationFailed), findsOneWidget);
        expect(find.text(l10n.genericError), findsNothing);
        if (language == 'ar') {
          expect(Directionality.of(tester.element(line)), TextDirection.rtl);
        }

        // What the student typed is still there, and the screen did not leave.
        expect(nameText(tester), _refused);
        expect(locationOf(container), '/profile/edit');

        // One request, with the name only; nothing resent on its own.
        expect(sentOnce(repo), <String, dynamic>{'name': _refused});
        await tester.pump(const Duration(seconds: 30));
        verifyNever(() => repo.updateMe(any()));
      });

      testWidgets('Save again with the same name sends nothing; the name '
          'stays marked and the screen stays', (tester) async {
        final repo = refusingRepo();
        final container = await pumpEditProfile(
          tester,
          profile: repo,
          locale: language,
        );
        await tester.enterText(input('edit_name_field'), _refused);
        await save(tester);
        verify(() => repo.updateMe(any())).called(1);

        await save(tester);
        await save(tester);

        verifyNever(() => repo.updateMe(any()));
        expect(find.text(l10n.fieldRejected), findsOneWidget);
        expect(field(tester, 'edit_name_field').hasError, isTrue);
        expect(banner(l10n.errorValidationFailed), findsOneWidget);
        expect(nameText(tester), _refused);
        expect(locationOf(container), '/profile/edit');
      });

      testWidgets('spaces around the refused name do not make it another '
          'name', (tester) async {
        final repo = refusingRepo();
        await pumpEditProfile(tester, profile: repo, locale: language);
        await tester.enterText(input('edit_name_field'), _refused);
        await save(tester);
        verify(() => repo.updateMe(any())).called(1);

        await typeName(tester, '  $_refused  ');

        // Any edit takes the banner off, as before; the mark stays, because
        // the name that would be sent is still the refused one.
        expect(find.byKey(const Key('edit_save_error')), findsNothing);
        expect(find.text(l10n.fieldRejected), findsOneWidget);
        expect(field(tester, 'edit_name_field').hasError, isTrue);

        await save(tester);

        verifyNever(() => repo.updateMe(any()));
        expect(banner(l10n.errorValidationFailed), findsOneWidget);
        expect(find.text(l10n.fieldRejected), findsOneWidget);
      });

      testWidgets('editing the name takes the mark and the banner off', (
        tester,
      ) async {
        await pumpEditProfile(
          tester,
          profile: refusingRepo(),
          locale: language,
        );
        await tester.enterText(input('edit_name_field'), _refused);
        await save(tester);
        expect(find.text(l10n.fieldRejected), findsOneWidget);

        await typeName(tester, _corrected);

        expect(find.text(l10n.fieldRejected), findsNothing);
        expect(find.byKey(const Key('edit_save_error')), findsNothing);
        expect(field(tester, 'edit_name_field').hasError, isFalse);
      });

      testWidgets('a different name is sent once, and its success returns to '
          'the hub as before', (tester) async {
        final repo = refusingOnce();
        final container = await pumpEditProfile(
          tester,
          profile: repo,
          locale: language,
        );
        await tester.enterText(input('edit_name_field'), _refused);
        await save(tester);
        verify(() => repo.updateMe(any())).called(1);

        await typeName(tester, _corrected);
        await save(tester);

        expect(sentOnce(repo), <String, dynamic>{'name': _corrected});
        expect(locationOf(container), '/profile');
        // The existing success flow: `/me` read on first paint, and again
        // because the save invalidated it.
        verify(repo.getMe).called(2);
      });

      testWidgets('typing the refused name back brings the mark back, and '
          'Save sends nothing', (tester) async {
        final repo = refusingOnce();
        await pumpEditProfile(tester, profile: repo, locale: language);
        await tester.enterText(input('edit_name_field'), _refused);
        await save(tester);
        verify(() => repo.updateMe(any())).called(1);

        await typeName(tester, _corrected);
        expect(find.text(l10n.fieldRejected), findsNothing);
        await typeName(tester, _refused);
        expect(find.text(l10n.fieldRejected), findsOneWidget);
        expect(find.byKey(const Key('edit_save_error')), findsNothing);

        await save(tester);

        verifyNever(() => repo.updateMe(any()));
        expect(banner(l10n.errorValidationFailed), findsOneWidget);
      });
    });
  }

  testWidgets('the refused name holds back the whole save: an email changed '
      'beside it is not sent, and goes out once the name is back to the '
      'saved one', (tester) async {
    final l10n = lookupAppLocalizations(const Locale('en'));
    final repo = refusingOnce();
    final container = await pumpEditProfile(tester, profile: repo);
    await tester.enterText(input('edit_name_field'), _refused);
    await save(tester);
    verify(() => repo.updateMe(any())).called(1);

    await tester.enterText(input('edit_email_field'), 'student@example.com');
    await tester.pumpAndSettle();
    expect(find.text(l10n.fieldRejected), findsOneWidget);
    await save(tester);
    verifyNever(() => repo.updateMe(any()));
    expect(banner(l10n.errorValidationFailed), findsOneWidget);

    // The saved name is not a change, so the name leaves the body.
    await typeName(tester, _saved);
    expect(find.text(l10n.fieldRejected), findsNothing);
    await save(tester);

    expect(sentOnce(repo), <String, dynamic>{'email': 'student@example.com'});
    expect(locationOf(container), '/profile');
  });

  group('other failures are not remembered: Save sends again', () {
    final failures = <String, Object>{
      '500 internal_error': const ApiException(
        status: 500,
        code: 'internal_error',
      ),
      '400 validation_failed on the name': const ValidationException(
        errors: {
          'name': ['invalid'],
        },
      ),
      'a 422 with another code': const ApiException(
        status: 422,
        code: 'unprocessable',
      ),
      'offline': const OfflineException(),
    };

    for (final MapEntry(key: label, value: failure) in failures.entries) {
      testWidgets(label, (tester) async {
        final repo = refusingRepo(failure);
        await pumpEditProfile(tester, profile: repo);
        await tester.enterText(input('edit_name_field'), _refused);

        await save(tester);
        await save(tester);

        verify(() => repo.updateMe(any())).called(2);
      });
    }
  });

  group('other failures keep their existing lines', () {
    final l10n = lookupAppLocalizations(const Locale('en'));
    final failures = <String, Object>{
      '500 internal_error': const ApiException(
        status: 500,
        code: 'internal_error',
      ),
      'a 422 with another code': const ApiException(
        status: 422,
        code: 'unprocessable',
      ),
    };

    for (final MapEntry(key: label, value: failure) in failures.entries) {
      testWidgets('$label: the generic line, no field marked', (tester) async {
        await pumpEditProfile(tester, profile: refusingRepo(failure));
        await tester.enterText(input('edit_name_field'), _refused);
        await save(tester);

        expect(banner(l10n.genericError), findsOneWidget);
        expect(find.text(l10n.fieldRejected), findsNothing);
        expect(field(tester, 'edit_name_field').hasError, isFalse);
      });
    }
  });

  group('in flight, leaving, coming back', () {
    final l10n = lookupAppLocalizations(const Locale('en'));

    testWidgets('a second tap while the save is in flight sends nothing '
        'more, and the refusal that lands then holds', (tester) async {
      final repo = profileRepo();
      final pending = Completer<StudentProfile>();
      when(() => repo.updateMe(any())).thenAnswer((_) => pending.future);
      await pumpEditProfile(tester, profile: repo);
      await tester.enterText(input('edit_name_field'), _refused);
      await tester.pump();

      await tester.tap(find.byKey(const Key('edit_save_button')));
      await tester.pump();
      await tester.tap(
        find.byKey(const Key('edit_save_button')),
        warnIfMissed: false,
      );
      await tester.pump();
      verify(() => repo.updateMe(any())).called(1);

      pending.completeError(_nameNotAllowed);
      await tester.pumpAndSettle();
      expect(find.text(l10n.fieldRejected), findsOneWidget);
      expect(banner(l10n.errorValidationFailed), findsOneWidget);

      await save(tester);
      verifyNever(() => repo.updateMe(any()));
    });

    testWidgets('a name changed while the refused save was in flight is not '
        'marked, and Save sends it', (tester) async {
      final repo = profileRepo();
      final pending = Completer<StudentProfile>();
      var calls = 0;
      when(() => repo.updateMe(any())).thenAnswer(
        (_) => ++calls == 1 ? pending.future : Future.value(schoolProfile()),
      );
      final container = await pumpEditProfile(tester, profile: repo);
      await tester.enterText(input('edit_name_field'), _refused);
      await tester.pump();
      await tester.tap(find.byKey(const Key('edit_save_button')));
      await tester.pump();

      // The field stays editable while the save is in flight.
      await tester.enterText(input('edit_name_field'), _corrected);
      await tester.pump();
      pending.completeError(_nameNotAllowed);
      await tester.pumpAndSettle();

      // The save failed and the banner says so, but the box holds a name the
      // server never saw, so it is not marked.
      expect(nameText(tester), _corrected);
      expect(find.text(l10n.fieldRejected), findsNothing);
      expect(field(tester, 'edit_name_field').hasError, isFalse);
      expect(banner(l10n.errorValidationFailed), findsOneWidget);

      // The refused name typed back is marked.
      await typeName(tester, _refused);
      expect(find.text(l10n.fieldRejected), findsOneWidget);

      await typeName(tester, _corrected);
      await save(tester);
      final sent = verify(() => repo.updateMe(captureAny())).captured;
      expect(sent, hasLength(2));
      expect((sent.last as ProfileUpdate).toJson(), <String, dynamic>{
        'name': _corrected,
      });
      expect(locationOf(container), '/profile');
    });

    testWidgets('leaving mid-save: the refusal that lands afterwards touches '
        'nothing, and the next visit starts from the saved name', (
      tester,
    ) async {
      final repo = profileRepo();
      final pending = Completer<StudentProfile>();
      when(() => repo.updateMe(any())).thenAnswer((_) => pending.future);
      final container = await pumpEditProfile(tester, profile: repo);
      await tester.enterText(input('edit_name_field'), _refused);
      await tester.pump();
      await tester.tap(find.byKey(const Key('edit_save_button')));
      await tester.pump();
      verify(() => repo.updateMe(any())).called(1);

      // The form is dirty, so leaving asks first. Fixed-length pumps: the
      // Save spinner never settles while the request is open.
      await tester.tap(find.byKey(const Key('edit_profile_back')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.byKey(const Key('discard_confirm')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(locationOf(container), '/profile');

      pending.completeError(_nameNotAllowed);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(locationOf(container), '/profile');

      // A new visit: the saved name, unmarked, no banner.
      container.read(routerProvider).push('/profile/edit');
      await tester.pumpAndSettle();
      expect(nameText(tester), _saved);
      expect(find.text(l10n.fieldRejected), findsNothing);
      expect(find.byKey(const Key('edit_save_error')), findsNothing);

      // The record lives for one visit, so this visit sends the name once
      // and keeps it from then on.
      await tester.enterText(input('edit_name_field'), _refused);
      await save(tester);
      verify(() => repo.updateMe(any())).called(1);
      expect(find.text(l10n.fieldRejected), findsOneWidget);
      await save(tester);
      verifyNever(() => repo.updateMe(any()));
    });

    testWidgets('leaving after a refusal and coming back: the saved name, '
        'unmarked, no banner', (tester) async {
      final repo = refusingRepo();
      final container = await pumpEditProfile(tester, profile: repo);
      await tester.enterText(input('edit_name_field'), _refused);
      await save(tester);
      expect(find.text(l10n.fieldRejected), findsOneWidget);

      await tapProfileKey(tester, 'edit_profile_back');
      await tapProfileKey(tester, 'discard_confirm');
      expect(locationOf(container), '/profile');

      container.read(routerProvider).push('/profile/edit');
      await tester.pumpAndSettle();

      expect(nameText(tester), _saved);
      expect(find.text(l10n.fieldRejected), findsNothing);
      expect(find.byKey(const Key('edit_save_error')), findsNothing);
      expect(field(tester, 'edit_name_field').hasError, isFalse);
      verify(() => repo.updateMe(any())).called(1);
    });
  });

  group('the command', () {
    /// The command with the screen's lifetime: one listener keeps the
    /// `autoDispose` notifier alive between calls, as the open screen does.
    ProviderContainer commandContainer(MockProfileRepository repo) {
      final container = ProviderContainer(
        overrides: [profileRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);
      container.listen(editProfileProvider, (_, _) {});
      return container;
    }

    test(
      'a refusal records the name as it was sent, and only that name',
      () async {
        final container = commandContainer(refusingRepo());
        final notifier = container.read(editProfileProvider.notifier);

        expect(
          await notifier.save(const ProfileUpdate(name: _refused)),
          isFalse,
        );

        expect(notifier.isRefused(_refused), isTrue);
        expect(notifier.isRefused(_corrected), isFalse);
        expect(notifier.isRefused(null), isFalse);
        expect(
          isProfileNameNotAllowed(container.read(editProfileProvider).error),
          isTrue,
        );
      },
    );

    test('the form sends a name trimmed, so spaces reach the record as the '
        'same name', () {
      final update = ProfileUpdate.diff(
        current: schoolProfile(),
        name: '  $_refused  ',
        email: '',
      );
      expect(update.name, _refused);
    });

    test('spaces around a refused name are the same name to the command '
        'too, whoever builds the body', () async {
      final repo = refusingRepo();
      final notifier = commandContainer(
        repo,
      ).read(editProfileProvider.notifier);
      await notifier.save(const ProfileUpdate(name: _refused));
      verify(() => repo.updateMe(any())).called(1);

      final saved = await notifier.save(
        const ProfileUpdate(name: '  $_refused  '),
      );

      expect(saved, isFalse);
      verifyNever(() => repo.updateMe(any()));
      expect(notifier.isRefused('  $_refused  '), isTrue);
    });

    test('a refused body with spaces is recorded trimmed', () async {
      final repo = refusingRepo();
      final notifier = commandContainer(
        repo,
      ).read(editProfileProvider.notifier);
      await notifier.save(const ProfileUpdate(name: '  $_refused  '));
      verify(() => repo.updateMe(any())).called(1);

      expect(await notifier.save(const ProfileUpdate(name: _refused)), isFalse);
      verifyNever(() => repo.updateMe(any()));
    });

    test("sign-out's session reset empties the record", () async {
      final container = commandContainer(refusingRepo());
      await container
          .read(editProfileProvider.notifier)
          .save(const ProfileUpdate(name: _refused));
      expect(
        container.read(editProfileProvider.notifier).isRefused(_refused),
        isTrue,
      );

      container.read(_sessionReset)();
      container.read(editProfileProvider);

      expect(
        container.read(editProfileProvider.notifier).isRefused(_refused),
        isFalse,
      );
    });

    test('the same name again: no request, the refusal stated afresh, with '
        'whatever else changed beside it', () async {
      final repo = refusingRepo();
      final container = commandContainer(repo);
      final notifier = container.read(editProfileProvider.notifier);
      await notifier.save(const ProfileUpdate(name: _refused));
      final first = container.read(editProfileProvider);
      notifier.clearError();

      final saved = await notifier.save(
        const ProfileUpdate(
          name: _refused,
          email: EmailPatch.set('student@example.com'),
        ),
      );

      expect(saved, isFalse);
      verify(() => repo.updateMe(any())).called(1);
      final again = container.read(editProfileProvider);
      expect(isProfileNameNotAllowed(again.error), isTrue);
      expect(again, isNot(same(first)));
    });

    test('a save without the name still goes out after a refusal', () async {
      final repo = refusingOnce();
      final container = commandContainer(repo);
      final notifier = container.read(editProfileProvider.notifier);
      await notifier.save(const ProfileUpdate(name: _refused));
      verify(() => repo.updateMe(any())).called(1);

      final saved = await notifier.save(
        const ProfileUpdate(email: EmailPatch.set('student@example.com')),
      );

      expect(saved, isTrue);
      expect(sentOnce(repo), <String, dynamic>{'email': 'student@example.com'});
    });

    test('other failures record nothing', () async {
      for (final failure in <Object>[
        const ApiException(status: 500, code: 'internal_error'),
        const ApiException(status: 422, code: 'unprocessable'),
        const ValidationException(
          errors: {
            'name': ['invalid'],
          },
        ),
        const OfflineException(),
      ]) {
        final repo = refusingRepo(failure);
        final notifier = commandContainer(
          repo,
        ).read(editProfileProvider.notifier);

        await notifier.save(const ProfileUpdate(name: _refused));
        await notifier.save(const ProfileUpdate(name: _refused));

        expect(notifier.isRefused(_refused), isFalse, reason: '$failure');
        verify(() => repo.updateMe(any())).called(2);
      }
    });
  });

  group('the copy mapping', () {
    test('rejectedFields: the refusal lands on `name`; the rest unchanged', () {
      expect(rejectedFields(_nameNotAllowed), {'name'});
      expect(
        rejectedFields(const ApiException(status: 422, code: 'unprocessable')),
        isEmpty,
      );
      expect(
        rejectedFields(
          const ValidationException(
            errors: {
              'email': ['invalid'],
            },
          ),
        ),
        {'email'},
      );
      expect(rejectedFields(const OfflineException()), isEmpty);
      expect(rejectedFields(null), isEmpty);
    });

    test('isProfileNameNotAllowed: only the 422 with that code', () {
      expect(isProfileNameNotAllowed(_nameNotAllowed), isTrue);
      expect(
        isProfileNameNotAllowed(
          const ApiException(status: 422, code: 'unprocessable'),
        ),
        isFalse,
      );
      expect(
        isProfileNameNotAllowed(
          const ValidationException(errors: {'name': []}),
        ),
        isFalse,
      );
      expect(isProfileNameNotAllowed(null), isFalse);
    });

    for (final language in ['en', 'ar']) {
      test('$language: the banner is the approved validation line', () {
        final l10n = lookupAppLocalizations(Locale(language));
        expect(
          profileSaveErrorMessage(l10n, _nameNotAllowed),
          l10n.errorValidationFailed,
        );
        expect(
          profileSaveErrorMessage(
            l10n,
            const ApiException(status: 500, code: 'internal_error'),
          ),
          l10n.genericError,
        );
      });
    }
  });
}
