import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/profile/models/profile_update.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:level_up_app/features/profile/screens/edit_profile_screen.dart';
import 'package:level_up_app/features/profile/widgets/read_only_field.dart';
import 'package:mocktail/mocktail.dart';

import 'profile_fixtures.dart';
import 'profile_harness.dart';

/// Edit Profile · Figma `180:3989` — the screen behind `PATCH /me`.
///
/// Three claims are load-bearing and each is asserted structurally rather than
/// by eyeballing a render:
///
/// 1. **Only what changed is sent.** Proved on the body the screen actually
///    handed the repository, not on the form's state.
/// 2. **The six read-only facts cannot reach the wire.** Proved by asserting
///    the body's whole key set, so adding a field later fails this test.
/// 3. **Read-only is read-only.** No `TextField` and no `InkWell` anywhere in
///    a [ReadOnlyField]'s subtree — a dimmed input that swallows taps would
///    pass a "looks disabled" check and fail a student.
void main() {
  setUpAll(() => registerFallbackValue(const ProfileUpdate()));

  /// A `/me` stub that also answers `PATCH /me`.
  MockProfileRepository editRepo({
    StudentProfile? me,
    StudentProfile? updated,
    Object? failure,
  }) {
    final repo = profileRepo(me: me);
    if (failure != null) {
      when(() => repo.updateMe(any())).thenThrow(failure);
    } else {
      when(
        () => repo.updateMe(any()),
      ).thenAnswer((_) async => updated ?? me ?? schoolProfile());
    }
    return repo;
  }

  /// The body the screen actually submitted.
  ProfileUpdate sent(MockProfileRepository repo) =>
      verify(() => repo.updateMe(captureAny())).captured.single
          as ProfileUpdate;

  Finder input(String key) => find.descendant(
    of: find.byKey(Key(key)),
    matching: find.byType(TextField),
  );

  /// The resolved value on a read-only row. Read off the widget rather than by
  /// text search: the fixture's governorate, city and school are all `Cairo`,
  /// so a bare `find.text` cannot say WHICH row is being asserted.
  String readOnly(WidgetTester tester, String key) =>
      tester.widget<ReadOnlyField>(find.byKey(Key(key))).value;

  Future<void> save(WidgetTester tester) =>
      tapProfileKey(tester, 'edit_save_button');

  group('the form is seeded from the /me already in memory', () {
    testWidgets('name and email arrive pre-filled', (tester) async {
      await pumpEditProfile(tester, profile: editRepo(me: profileWithEmail()));

      expect(find.text('Ahmed Mohamed'), findsWidgets);
      expect(find.text('ahmed@example.com'), findsOneWidget);
    });

    testWidgets('no second GET /me — the hub already fetched it', (
      tester,
    ) async {
      final repo = editRepo();
      await pumpEditProfile(tester, profile: repo);

      // One call total, across Home mounting and Edit Profile being pushed.
      verify(repo.getMe).called(1);
    });

    testWidgets('a student with no email gets an empty box, not "null"', (
      tester,
    ) async {
      await pumpEditProfile(tester, profile: editRepo()); // email: null

      expect(find.text('null'), findsNothing);
      expect(
        tester.widget<TextField>(input('edit_email_field')).controller!.text,
        isEmpty,
      );
    });
  });

  group('only changed fields are submitted', () {
    testWidgets('an untouched form sends no request at all', (tester) async {
      final repo = editRepo();
      await pumpEditProfile(tester, profile: repo);

      await save(tester);

      verifyNever(() => repo.updateMe(any()));
    });

    testWidgets('changing the name sends `name` and nothing else', (
      tester,
    ) async {
      final repo = editRepo();
      await pumpEditProfile(tester, profile: repo);

      await tester.enterText(input('edit_name_field'), 'Ahmed Ali');
      await save(tester);

      expect(sent(repo).toJson(), <String, dynamic>{'name': 'Ahmed Ali'});
    });

    testWidgets('the six read-only facts never appear in the body', (
      tester,
    ) async {
      final repo = editRepo();
      await pumpEditProfile(tester, profile: repo);

      await tester.enterText(input('edit_name_field'), 'Ahmed Ali');
      await tester.enterText(input('edit_email_field'), 'a@b.com');
      await save(tester);

      final body = sent(repo).toJson();
      expect(body.keys, unorderedEquals(<String>['name', 'email']));
      for (final key in const [
        'phone',
        'parentPhone',
        'city',
        'cityId',
        'cityName',
        'school',
        'schoolId',
        'educationSystem',
        'stage',
      ]) {
        expect(
          body.containsKey(key),
          isFalse,
          reason: '$key is immutable (S20)',
        );
      }
    });
  });

  group('email — the three states, through the form', () {
    testWidgets('UNTOUCHED: retyping the same address sends nothing', (
      tester,
    ) async {
      final repo = editRepo(me: profileWithEmail());
      await pumpEditProfile(tester, profile: repo);

      await tester.enterText(input('edit_email_field'), 'ahmed@example.com');
      await save(tester);

      verifyNever(() => repo.updateMe(any()));
    });

    testWidgets('TYPED: a new address is sent as a string', (tester) async {
      final repo = editRepo();
      await pumpEditProfile(tester, profile: repo);

      await tester.enterText(input('edit_email_field'), 'new@example.com');
      await save(tester);

      expect(sent(repo).toJson(), <String, dynamic>{
        'email': 'new@example.com',
      });
    });

    testWidgets(
      'CLEARED: emptying the box sends the key with an explicit null',
      (tester) async {
        final repo = editRepo(me: profileWithEmail());
        await pumpEditProfile(tester, profile: repo);

        await tester.enterText(input('edit_email_field'), '');
        await save(tester);

        final body = sent(repo).toJson();
        // The assertion that dies if `includeIfNull: false` is ever applied to
        // this field: a dropped key means "unchanged", and the address the
        // student just deleted would quietly survive.
        expect(body.containsKey('email'), isTrue);
        expect(body['email'], isNull);
      },
    );

    testWidgets('the screen says out loud that an empty box deletes', (
      tester,
    ) async {
      await pumpEditProfile(tester, profile: editRepo());

      expect(
        find.text('Leave this empty to remove your email.'),
        findsOneWidget,
      );
    });
  });

  group('avatar', () {
    testWidgets(
      'Use Avatar opens the reference picker and round-trips the id',
      (tester) async {
        final repo = editRepo();
        await pumpEditProfile(tester, profile: repo);

        await tapProfileKey(tester, 'edit_avatar_button');
        await tapProfileKey(tester, 'avatar_use_default');
        await tapProfileKey(tester, 'avatar_choice_avatar-99');
        await save(tester);

        expect(sent(repo).toJson(), <String, dynamic>{'avatarId': 'avatar-99'});
      },
    );

    testWidgets(
      'the picker reads the SAME /reference/avatars registration does',
      (tester) async {
        final reference = avatarReferenceRepo();
        await pumpEditProfile(
          tester,
          profile: editRepo(),
          reference: reference,
        );

        await tapProfileKey(tester, 'edit_avatar_button');
        await tapProfileKey(tester, 'avatar_use_default');

        verify(reference.getAvatars).called(1);
        expect(
          find.byKey(const Key('avatar_choice_avatar-01')),
          findsOneWidget,
        );
      },
    );

    testWidgets('Upload photo is present and genuinely non-interactive', (
      tester,
    ) async {
      await pumpEditProfile(tester, profile: editRepo());
      await tapProfileKey(tester, 'edit_avatar_button');

      final row = find.byKey(const Key('avatar_upload_photo'));
      expect(row, findsOneWidget);
      // No tap target anywhere in the subtree — not a live one with a dead
      // callback. `PUT /me/avatar` is draft and moderated (S29).
      expect(
        find.descendant(of: row, matching: find.byType(InkWell)),
        findsNothing,
      );
      expect(
        tester
            .widget<IgnorePointer>(
              find.descendant(of: row, matching: find.byType(IgnorePointer)),
            )
            .ignoring,
        isTrue,
      );
      final handle = tester.ensureSemantics();
      expect(
        tester.getSemantics(row),
        isSemantics(
          isButton: true,
          hasEnabledState: true,
          isEnabled: false,
          hint: "Uploading your own photo isn't available yet.",
        ),
      );
      handle.dispose();
    });

    testWidgets('tapping Upload photo changes nothing', (tester) async {
      final repo = editRepo();
      await pumpEditProfile(tester, profile: repo);
      await tapProfileKey(tester, 'edit_avatar_button');

      await tapProfileKey(tester, 'avatar_upload_photo', warnIfMissed: false);

      // The sheet is still open and nothing was picked.
      expect(find.byKey(const Key('avatar_upload_photo')), findsOneWidget);
      await tapProfileKey(tester, 'avatar_sheet_dismiss');
      await save(tester);
      verifyNever(() => repo.updateMe(any()));
    });
  });

  group('read-only fields (conflict 1 / S20)', () {
    const readOnlyKeys = [
      'edit_phone_field',
      'edit_city_field',
      'edit_education_system_field',
      'edit_stage_field',
      'edit_school_field',
    ];

    testWidgets('each renders, and none of them is an input', (tester) async {
      await pumpEditProfile(tester, profile: editRepo());

      for (final key in readOnlyKeys) {
        final field = find.byKey(Key(key));
        expect(field, findsOneWidget, reason: '$key should render');
        expect(
          find.descendant(of: field, matching: find.byType(TextField)),
          findsNothing,
          reason: '$key must not be editable',
        );
        expect(
          find.descendant(of: field, matching: find.byType(InkWell)),
          findsNothing,
          reason: '$key must not be tappable',
        );
      }
    });

    testWidgets('the phone is the value GET /me returned, verbatim', (
      tester,
    ) async {
      await pumpEditProfile(tester, profile: editRepo());

      expect(readOnly(tester, 'edit_phone_field'), '+201001234567');
    });

    testWidgets('a "Parent\'s Number" row is not built — /me has no source', (
      tester,
    ) async {
      await pumpEditProfile(tester, profile: editRepo());

      // `parentPhone` exists only on the registration bodies (openapi.yaml
      // :1277/:1302). Same call as the omitted Rank card: no source, no row.
      expect(find.text("Parent's Number"), findsNothing);
    });

    testWidgets('a skipped school reads as resolved, not as missing data', (
      tester,
    ) async {
      final me = StudentProfile.fromJson(<String, dynamic>{
        ...schoolProfileJson(),
        'school': <String, dynamic>{
          'school': null,
          'stage': 'secondary2',
          'educationSystem': 'ig',
        },
      });
      await pumpEditProfile(tester, profile: editRepo(me: me));

      expect(readOnly(tester, 'edit_school_field'), 'No school selected');
    });
  });

  group('ProfileCity — the union at its first call site', () {
    testWidgets('a CODED city renders the English name in EN', (tester) async {
      await pumpEditProfile(tester, profile: editRepo());

      expect(readOnly(tester, 'edit_city_field'), 'Cairo');
    });

    testWidgets('a CODED city renders the Arabic name in AR', (tester) async {
      await pumpEditProfile(tester, profile: editRepo(), locale: 'ar');

      expect(readOnly(tester, 'edit_city_field'), 'القاهرة');
    });

    testWidgets('a FREE-TEXT city renders its plain string', (tester) async {
      // adr-028 §1: no id, no locales — this is the arm that would have thrown
      // under v1.0, when `city` was a bare NamedRef.
      await pumpEditProfile(
        tester,
        profile: editRepo(me: freeTextCityProfile()),
      );

      expect(readOnly(tester, 'edit_city_field'), 'Al Ain');
    });

    testWidgets(
      'a FREE-TEXT city has nothing to localize, so AR shows it too',
      (tester) async {
        await pumpEditProfile(
          tester,
          profile: editRepo(me: freeTextCityProfile()),
          locale: 'ar',
        );

        expect(readOnly(tester, 'edit_city_field'), 'Al Ain');
      },
    );
  });

  group('a university student sees their own academic block', () {
    testWidgets('university, faculty and year replace the school rows', (
      tester,
    ) async {
      await pumpEditProfile(tester, profile: editRepo(me: universityProfile()));

      expect(find.byKey(const Key('edit_university_field')), findsOneWidget);
      expect(find.byKey(const Key('edit_faculty_field')), findsOneWidget);
      expect(find.byKey(const Key('edit_study_year_field')), findsOneWidget);
      // `school` is null on this payload (adr-010 — the tracks have different
      // shapes), so its three rows must not be drawn empty.
      expect(find.byKey(const Key('edit_school_field')), findsNothing);
      expect(find.byKey(const Key('edit_stage_field')), findsNothing);
    });
  });

  group('save', () {
    testWidgets('invalidates /me so the hub and Home repaint', (tester) async {
      final repo = editRepo();
      await pumpEditProfile(tester, profile: repo);

      await tester.enterText(input('edit_name_field'), 'Ahmed Ali');
      await save(tester);

      // Once on first paint, once because the save invalidated the provider.
      verify(repo.getMe).called(2);
    });

    testWidgets('returns to the hub on success', (tester) async {
      final container = await pumpEditProfile(tester, profile: editRepo());
      expect(locationOf(container), '/profile/edit');

      await tester.enterText(input('edit_name_field'), 'Ahmed Ali');
      await save(tester);

      expect(locationOf(container), '/profile');
    });

    testWidgets('400 validation_failed lands as an inline error on the field', (
      tester,
    ) async {
      final repo = editRepo(
        failure: const ValidationException(
          errors: <String, List<String>>{
            'email': <String>['must be a valid email address'],
          },
        ),
      );
      final container = await pumpEditProfile(tester, profile: repo);

      await tester.enterText(input('edit_email_field'), 'nope');
      await save(tester);

      // The server's English string is NOT rendered — only the field name
      // crosses over, mapped to localized copy.
      expect(find.text('must be a valid email address'), findsNothing);
      expect(find.text('Please check this field'), findsOneWidget);
      expect(find.byKey(const Key('edit_save_error')), findsOneWidget);
      // Still on the screen: a rejected save must not navigate away.
      expect(locationOf(container), '/profile/edit');
    });

    testWidgets('editing after a failure clears the stale error', (
      tester,
    ) async {
      final repo = editRepo(
        failure: const ValidationException(
          errors: <String, List<String>>{
            'name': <String>['too long'],
          },
        ),
      );
      await pumpEditProfile(tester, profile: repo);

      await tester.enterText(input('edit_name_field'), 'Ahmed Ali');
      await save(tester);
      expect(find.byKey(const Key('edit_save_error')), findsOneWidget);

      await tester.enterText(input('edit_name_field'), 'Ahmed Aly');
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('edit_save_error')), findsNothing);
    });

    testWidgets('an empty name is rejected before a request is made', (
      tester,
    ) async {
      final repo = editRepo();
      await pumpEditProfile(tester, profile: repo);

      await tester.enterText(input('edit_name_field'), '   ');
      await save(tester);

      verifyNever(() => repo.updateMe(any()));
      expect(find.text('Please enter your name'), findsOneWidget);
    });

    testWidgets('offline shows the offline line, not a generic error', (
      tester,
    ) async {
      final repo = editRepo(failure: const OfflineException());
      await pumpEditProfile(tester, profile: repo);

      await tester.enterText(input('edit_name_field'), 'Ahmed Ali');
      await save(tester);

      expect(find.text('You are offline'), findsWidgets);
    });
  });

  group('unsaved-changes guard', () {
    testWidgets('a clean form leaves without asking', (tester) async {
      final container = await pumpEditProfile(tester, profile: editRepo());

      await tapProfileKey(tester, 'edit_profile_back');

      expect(find.text('Discard changes?'), findsNothing);
      expect(locationOf(container), '/profile');
    });

    testWidgets('a dirty form asks, and "Keep editing" stays put', (
      tester,
    ) async {
      final container = await pumpEditProfile(tester, profile: editRepo());

      await tester.enterText(input('edit_name_field'), 'Ahmed Ali');
      await tapProfileKey(tester, 'edit_profile_back');
      expect(find.text('Discard changes?'), findsOneWidget);

      await tapProfileKey(tester, 'discard_keep_editing');

      expect(locationOf(container), '/profile/edit');
    });

    testWidgets('a dirty form asks, and "Discard" leaves', (tester) async {
      final repo = editRepo();
      final container = await pumpEditProfile(tester, profile: repo);

      await tester.enterText(input('edit_name_field'), 'Ahmed Ali');
      await tapProfileKey(tester, 'edit_profile_back');
      await tapProfileKey(tester, 'discard_confirm');

      expect(locationOf(container), '/profile');
      // Discarding is not saving.
      verifyNever(() => repo.updateMe(any()));
    });
  });

  group('states', () {
    testWidgets(
      'loading renders the skeleton, and the back chip still exists',
      (tester) async {
        final repo = profileRepo();
        // Never resolves — the loading branch is what the student sees while
        // `/me` is in flight, and they must still be able to leave.
        when(repo.getMe).thenAnswer((_) => Completer<StudentProfile>().future);
        when(
          () => repo.updateMe(any()),
        ).thenAnswer((_) async => schoolProfile());

        await pumpEditProfile(tester, profile: repo, settle: false);

        expect(find.byType(EditProfileChrome), findsWidgets);
        expect(find.byKey(const Key('edit_profile_back')), findsOneWidget);
        expect(find.byType(ReadOnlyField), findsNothing);
        expect(find.byKey(const Key('edit_save_button')), findsNothing);
      },
    );

    testWidgets('an error shows the generic line plus a user-tapped retry', (
      tester,
    ) async {
      final repo = profileRepo();
      when(repo.getMe).thenThrow(const UnknownException());
      when(() => repo.updateMe(any())).thenAnswer((_) async => schoolProfile());

      await pumpEditProfile(tester, profile: repo);

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('offline gets its own view, not the generic error', (
      tester,
    ) async {
      final repo = profileRepo();
      when(repo.getMe).thenThrow(const OfflineException());
      when(() => repo.updateMe(any())).thenAnswer((_) async => schoolProfile());

      await pumpEditProfile(tester, profile: repo);

      expect(find.text('You are offline'), findsWidgets);
      expect(find.text('Something went wrong'), findsNothing);
    });
  });

  group('locales and themes', () {
    testWidgets('AR lays out RTL with Arabic labels', (tester) async {
      await pumpEditProfile(tester, profile: editRepo(), locale: 'ar');

      expect(find.text('تعديل الملف الشخصي'), findsWidgets);
      expect(find.text('حفظ التغييرات'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.byType(EditProfileChrome))),
        TextDirection.rtl,
      );
    });

    testWidgets('EN lays out LTR', (tester) async {
      await pumpEditProfile(tester, profile: editRepo());

      expect(find.text('Save Changes'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.byType(EditProfileChrome))),
        TextDirection.ltr,
      );
    });

    testWidgets('dark renders the same form on the dark canvas', (
      tester,
    ) async {
      await pumpEditProfile(tester, profile: editRepo(), theme: AppTheme.dark);

      expect(find.byKey(const Key('edit_save_button')), findsOneWidget);
      expect(find.byType(ReadOnlyField), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('AR + dark together', (tester) async {
      await pumpEditProfile(
        tester,
        profile: editRepo(),
        locale: 'ar',
        theme: AppTheme.dark,
      );

      expect(find.text('حفظ التغييرات'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
