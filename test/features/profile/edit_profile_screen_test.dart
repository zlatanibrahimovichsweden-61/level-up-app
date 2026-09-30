import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/core/widgets/form_fields.dart';
import 'package:level_up_app/core/widgets/offline_banner.dart';
import 'package:level_up_app/features/profile/models/profile_update.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:level_up_app/features/profile/screens/edit_profile_screen.dart';
import 'package:level_up_app/features/profile/widgets/avatar_disc.dart';
import 'package:level_up_app/features/profile/widgets/avatar_sheets.dart';
import 'package:level_up_app/features/profile/widgets/read_only_field.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
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

    group('a failed avatar load is recoverable, not permanent', () {
      /// A repo the TEST decides when to heal, rather than one that heals on
      /// its own second call.
      ///
      /// That distinction is load-bearing here. `avatarsProvider` used to
      /// inherit Riverpod 3's automatic exponential-backoff retry — a failing
      /// `getAvatars` was called 7 times in ~15 s off one sheet open — so a
      /// fixture that succeeded on call 2 would have been healed by the loop
      /// and the test would have passed without a student ever tapping
      /// anything. It would have proved the opposite of what it claims.
      ({MockReferenceRepository repo, void Function() heal})
      healableAvatarRepo() {
        final repo = MockReferenceRepository();
        var failing = true;
        when(repo.getAvatars).thenAnswer((_) async {
          if (failing) throw const NetworkException();
          return avatarChoices;
        });
        return (repo: repo, heal: () => failing = false);
      }

      testWidgets('a failed load offers a Retry', (tester) async {
        // `avatarsProvider` is a plain, non-autoDispose FutureProvider and is
        // deliberately OUTSIDE the session scope (global reference data), so
        // nothing invalidates it. Before this button, one failed load meant the
        // student could not change their avatar again until app restart.
        final reference = MockReferenceRepository();
        when(
          reference.getAvatars,
        ).thenAnswer((_) async => throw const NetworkException());

        await pumpEditProfile(
          tester,
          profile: editRepo(),
          reference: reference,
        );
        await tapProfileKey(tester, 'edit_avatar_button');
        await tapProfileKey(tester, 'avatar_use_default');

        expect(find.byKey(const Key('avatar_sheet_retry')), findsOneWidget);
      });

      testWidgets('tapping Retry re-fetches and renders the avatars', (
        tester,
      ) async {
        final (:repo, :heal) = healableAvatarRepo();

        await pumpEditProfile(tester, profile: editRepo(), reference: repo);
        await tapProfileKey(tester, 'edit_avatar_button');
        await tapProfileKey(tester, 'avatar_use_default');

        expect(find.byKey(const Key('avatar_choice_avatar-01')), findsNothing);
        // Exactly once: no silent background loop is running.
        verify(repo.getAvatars).called(1);

        heal();
        await tester.tap(find.byKey(const Key('avatar_sheet_retry')));
        await tester.pumpAndSettle();

        verify(repo.getAvatars).called(1);
        expect(
          find.byKey(const Key('avatar_choice_avatar-01')),
          findsOneWidget,
        );
      });

      testWidgets('a successful load shows no Retry — no regression', (
        tester,
      ) async {
        await pumpEditProfile(
          tester,
          profile: editRepo(),
          reference: avatarReferenceRepo(),
        );
        await tapProfileKey(tester, 'edit_avatar_button');
        await tapProfileKey(tester, 'avatar_use_default');

        expect(find.byKey(const Key('avatar_sheet_retry')), findsNothing);
        expect(
          find.byKey(const Key('avatar_choice_avatar-01')),
          findsOneWidget,
        );
      });
    });

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
      // The frame's sheet has no ✕ (216:3341): the scrim dismisses it.
      await tester.tapAt(const Offset(400, 100));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('avatar_upload_photo')), findsNothing);
      await save(tester);
      verifyNever(() => repo.updateMe(any()));
    });
  });

  group('read-only fields (conflict 1 / S20)', () {
    // The frame's rows (`176:1201`; owner ruling, API→UI Wave 20, #105).
    const readOnlyKeys = [
      'edit_phone_field',
      'edit_city_field',
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
      expect(
        find.byKey(const Key('edit_education_system_field')),
        findsNothing,
      );
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

  // API→UI Wave 20: the frames. Light school `176:1201`, university `180:6349`
  // (dark `337:7795`, RTL `549:21413`); the action sheet `216:3341` (dark
  // `337:8135`); the picker `180:4153` (dark `337:8024`). Distances are read
  // off the frames in dp; the test surface is wider than a phone, so each one
  // is measured from its own reference edge, never from the screen's.
  group('Wave 20: the frames (176:1201 · 216:3341 · 180:4153)', () {
    final en = lookupAppLocalizations(const Locale('en'));

    Future<void> openActionSheet(WidgetTester tester) =>
        tapProfileKey(tester, 'edit_avatar_button');

    Future<void> openPicker(WidgetTester tester) async {
      await openActionSheet(tester);
      await tapProfileKey(tester, 'avatar_use_default');
    }

    Finder badgeGlyph() => find.byKey(const Key('edit_avatar_badge_glyph'));

    Rect badgeRect(WidgetTester tester) => tester.getRect(
      find
          .ancestor(of: badgeGlyph(), matching: find.byType(ElevatedSurface))
          .first,
    );

    group('the avatar block (176:1343 · 176:1346)', () {
      for (final locale in ['en', 'ar']) {
        testWidgets('$locale: the disc 25 under the bar, the badge 14 below '
            'the disc, the first label 1 under the badge', (tester) async {
          await pumpEditProfile(tester, profile: editRepo(), locale: locale);

          // The back chip is the whole 35 dp bar's height.
          final bar = tester.getRect(
            find.byKey(const Key('edit_profile_back')),
          );
          final disc = tester.getRect(
            find.byKey(const Key('edit_avatar_disc')),
          );
          final badge = badgeRect(tester);
          final firstLabel = tester.getRect(find.byType(FieldLabel).first);

          expect(bar.height, 35);
          expect(disc.top - bar.bottom, moreOrLessEquals(25));
          expect(disc.size, const Size(151, 151));
          expect(badge.size, const Size(34, 34));
          expect(badge.center.dx, moreOrLessEquals(disc.center.dx));
          expect(badge.bottom - disc.bottom, moreOrLessEquals(14));
          expect(firstLabel.top - badge.bottom, moreOrLessEquals(1));
        });
      }

      testWidgets('the skeleton puts its first block where the form puts '
          'its first label', (tester) async {
        final repo = profileRepo();
        when(repo.getMe).thenAnswer((_) => Completer<StudentProfile>().future);
        await pumpEditProfile(tester, profile: repo, settle: false);

        final bar = tester.getRect(find.byKey(const Key('edit_profile_back')));
        final blocks = find.descendant(
          of: find.byType(EditProfileChrome),
          matching: find.byType(Container),
        );
        final disc = tester.getRect(blocks.first);
        final firstBlock = tester.getRect(blocks.at(1));
        expect(disc.top - bar.bottom, moreOrLessEquals(25));
        // 151 + 14 + 1: the form's disc, badge overhang and gap.
        expect(firstBlock.top - disc.top, moreOrLessEquals(166));
      });

      for (final dark in [false, true]) {
        final ink = dark ? const Color(0xFFFCFBF9) : const Color(0xFF384F47);
        testWidgets('${dark ? 'dark' : 'light'}: the badge carries the '
            "frame's pencil, 17 x 17, centred, in "
            '${dark ? '#FCFBF9' : '#384F47'}', (tester) async {
          await pumpEditProfile(
            tester,
            profile: editRepo(),
            theme: dark ? AppTheme.dark : null,
          );

          final glyph = tester.widget<SvgPicture>(badgeGlyph());
          expect(glyph.colorFilter, ColorFilter.mode(ink, BlendMode.srcIn));
          final rect = tester.getRect(badgeGlyph());
          expect(rect.size, const Size(17, 17));
          expect(rect.center, badgeRect(tester).center);
          // No Material stand-in left behind.
          expect(
            find.descendant(
              of: find.byKey(const Key('edit_avatar_button')),
              matching: find.byIcon(Icons.edit),
            ),
            findsNothing,
          );
        });
      }

      testWidgets("the disc is the frame's radial gradient under the image", (
        tester,
      ) async {
        await pumpEditProfile(tester, profile: editRepo());

        final box = tester.widget<Container>(
          find
              .descendant(
                of: find.byKey(const Key('edit_avatar_disc')),
                matching: find.byType(Container),
              )
              .first,
        );
        final decoration = box.decoration! as BoxDecoration;
        final gradient = decoration.gradient! as RadialGradient;
        expect(decoration.shape, BoxShape.circle);
        expect(gradient.colors, const [Color(0xFF4B675E), Color(0xFF95CDBB)]);

        // Derived here from the frame's own `gradientTransform` (`176:1343`,
        // read over the MCP), not from the widget's constants: Figma maps the
        // box to a space where the gradient is the circle at (0.5, 0.5) with
        // radius 0.5, so the centre is the inverse image of (0.5, 0.5) and the
        // radius is 0.5 over the transform's scale.
        const a = -0.014609374105930328, b = 0.6789889335632324;
        const c = 0.14206984639167786, d = -0.6789889335632324;
        const e = -0.014609374105930328, f = 0.8647710084915161;
        const det = a * e - b * d;
        final u = ((0.5 - c) * e - b * (0.5 - f)) / det;
        final v = (a * (0.5 - f) - d * (0.5 - c)) / det;
        final center = gradient.center as Alignment;
        expect(center.x, moreOrLessEquals(2 * u - 1, epsilon: 1e-3));
        expect(center.y, moreOrLessEquals(2 * v - 1, epsilon: 1e-3));
        expect(
          gradient.radius,
          moreOrLessEquals(0.5 / math.sqrt(a * a + b * b), epsilon: 1e-3),
        );
      });
    });

    group('the locked rows follow the frames (owner ruling, #105)', () {
      Rect rowOf(WidgetTester tester, String key) =>
          tester.getRect(find.byKey(Key(key)));

      void expectInOrder(WidgetTester tester, List<String> keys) {
        for (var i = 1; i < keys.length; i++) {
          expect(
            rowOf(tester, keys[i]).top - rowOf(tester, keys[i - 1]).bottom,
            moreOrLessEquals(25),
            reason: '${keys[i]} 25 under ${keys[i - 1]}',
          );
        }
      }

      testWidgets('school (176:1201): Phone, City, School name', (
        tester,
      ) async {
        await pumpEditProfile(tester, profile: editRepo());

        expectInOrder(tester, const [
          'edit_phone_field',
          'edit_city_field',
          'edit_school_field',
        ]);
        // Hidden layers in the frame: not built.
        expect(
          find.byKey(const Key('edit_education_system_field')),
          findsNothing,
        );
        expect(find.byKey(const Key('edit_stage_field')), findsNothing);
      });

      testWidgets('university (180:6349): Phone, Faculty, Academic Year, '
          'City, University name', (tester) async {
        await pumpEditProfile(
          tester,
          profile: editRepo(me: universityProfile()),
        );

        expectInOrder(tester, const [
          'edit_phone_field',
          'edit_faculty_field',
          'edit_study_year_field',
          'edit_city_field',
          'edit_university_field',
        ]);
      });

      testWidgets('a payload with both track blocks follows its track, with '
          'one City row and no duplicate key', (tester) async {
        // Not a shape `GET /me` sends (adr-010), but the schema does not forbid
        // it, and the City row is one keyed widget.
        final both = StudentProfile.fromJson(<String, dynamic>{
          ...universityProfileJson(),
          'track': 'school',
          'school': schoolProfileJson()['school'],
        });
        await pumpEditProfile(tester, profile: editRepo(me: both));

        expect(tester.takeException(), isNull);
        expect(find.byKey(const Key('edit_city_field')), findsOneWidget);
        expect(find.byKey(const Key('edit_school_field')), findsOneWidget);
        expect(find.byKey(const Key('edit_faculty_field')), findsNothing);
      });

      testWidgets('I2: a locked row is announced once: its label, its value '
          'and why it is locked', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpEditProfile(tester, profile: editRepo());

        final node = tester.getSemantics(
          find.byKey(const Key('edit_city_field')),
        );
        expect(
          node,
          isSemantics(
            isReadOnly: true,
            label: en.cityLabel,
            value: readOnly(tester, 'edit_city_field'),
            hint: en.fieldLockedHint,
          ),
        );
        // It read "City\nCity\nCairo", with the value "Cairo", before.
        expect(node.label, isNot(contains('\n')));
        expect(node.childrenCount, 0);
        handle.dispose();
      });
    });

    group('the action sheet (216:3341)', () {
      testWidgets('a drag handle over two plain, full-width rows and one '
          'hairline: no title, no ✕, no icons', (tester) async {
        await pumpEditProfile(tester, profile: editRepo());
        await openActionSheet(tester);

        final card = tester.getRect(find.byType(AvatarActionSheet));
        final handleFinder = find.byKey(const Key('avatar_sheet_handle'));
        final handle = tester.getRect(handleFinder);
        expect(handle.size, const Size(94, 4));
        expect(handle.top - card.top, 15);
        expect(handle.center.dx, moreOrLessEquals(card.center.dx));
        expect(
          (tester.widget<Container>(handleFinder).decoration! as BoxDecoration)
              .color,
          const Color(0xFF000000),
        );

        final upload = tester.getRect(
          find.byKey(const Key('avatar_upload_photo')),
        );
        final use = tester.getRect(find.byKey(const Key('avatar_use_default')));
        expect(upload.top - card.top, 39);
        expect(upload.height, 44);
        expect(use.height, 44);
        expect(use.top - upload.bottom, 13);
        expect(upload.left, card.left);
        expect(upload.width, card.width);
        expect(tester.getRect(find.text(en.uploadPhoto)).left - card.left, 20);
        expect(tester.getRect(find.text(en.useAvatar)).left - card.left, 20);

        // The one hairline, under the first row.
        final divider = find.byKey(const Key('avatar_sheet_divider'));
        expect(
          find.descendant(
            of: find.byType(AvatarActionSheet),
            matching: divider,
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byKey(const Key('avatar_upload_photo')),
            matching: divider,
          ),
          findsOneWidget,
        );
        final decoration =
            tester.widget<DecoratedBox>(divider).decoration as BoxDecoration;
        final border = decoration.border! as Border;
        expect(
          border.bottom,
          const BorderSide(color: Color(0x994B675E), width: 0.5),
        );
        expect(border.top, BorderSide.none);

        // None of the old chrome.
        expect(
          find.descendant(
            of: find.byType(AvatarActionSheet),
            matching: find.text(en.changeAvatarTitle),
          ),
          findsNothing,
        );
        expect(find.byKey(const Key('avatar_sheet_dismiss')), findsNothing);
        expect(
          find.descendant(
            of: find.byType(AvatarActionSheet),
            matching: find.byType(Icon),
          ),
          findsNothing,
        );
        // The reason Upload photo does nothing stays (owner ruling, #106).
        expect(
          find.byKey(const Key('avatar_upload_unavailable_note')),
          findsOneWidget,
        );
      });

      testWidgets('dark (337:8135): the handle #FCFBF9, the hairline the same '
          '#4B675E at 60%', (tester) async {
        await pumpEditProfile(
          tester,
          profile: editRepo(),
          theme: AppTheme.dark,
        );
        await openActionSheet(tester);

        final handle = tester.widget<Container>(
          find.byKey(const Key('avatar_sheet_handle')),
        );
        expect(
          (handle.decoration! as BoxDecoration).color,
          const Color(0xFFFCFBF9),
        );
        final divider = tester.widget<DecoratedBox>(
          find.byKey(const Key('avatar_sheet_divider')),
        );
        final border = (divider.decoration as BoxDecoration).border! as Border;
        expect(border.bottom.color, const Color(0x994B675E));
      });

      testWidgets('the scrim dismisses it, and nothing changes', (
        tester,
      ) async {
        final repo = editRepo();
        await pumpEditProfile(tester, profile: repo);
        await openActionSheet(tester);

        await tester.tapAt(const Offset(400, 100));
        await tester.pumpAndSettle();

        expect(find.byType(AvatarActionSheet), findsNothing);
        await save(tester);
        verifyNever(() => repo.updateMe(any()));
      });
    });

    group('the picker (180:4153)', () {
      for (final dark in [false, true]) {
        final ink = dark ? const Color(0xFFFCFBF9) : const Color(0xFF3F3F3F);
        testWidgets("${dark ? 'dark (337:8024)' : 'light'}: the frame's ✕, "
            "27 from the card's start, with a 48 x 48 target", (tester) async {
          await pumpEditProfile(
            tester,
            profile: editRepo(),
            theme: dark ? AppTheme.dark : null,
          );
          await openPicker(tester);

          final card = tester.getRect(find.byType(ChooseAvatarSheet));
          final dismiss = find.byKey(const Key('avatar_sheet_dismiss'));
          final glyph = find.descendant(
            of: dismiss,
            matching: find.byType(SvgPicture),
          );
          final target = tester.getRect(dismiss);
          final cross = tester.getRect(glyph);

          expect(target.size, const Size(48, 48));
          expect(cross.size, const Size(23, 23));
          expect(cross.left - card.left, 27);
          expect(target.center, cross.center);
          // Centred on the frame's 35 dp bar, 30 under the card's top.
          expect(target.center.dy - card.top, 47.5);
          expect(
            tester.widget<SvgPicture>(glyph).colorFilter,
            ColorFilter.mode(ink, BlendMode.srcIn),
          );
        });
      }

      testWidgets("Arabic: the ✕ mirrors to 27 from the card's right", (
        tester,
      ) async {
        await pumpEditProfile(tester, profile: editRepo(), locale: 'ar');
        await openPicker(tester);

        final card = tester.getRect(find.byType(ChooseAvatarSheet));
        final cross = tester.getRect(
          find.descendant(
            of: find.byKey(const Key('avatar_sheet_dismiss')),
            matching: find.byType(SvgPicture),
          ),
        );
        expect(card.right - cross.right, 27);
      });

      testWidgets('the strip starts 21 in and 24 under the bar, and every '
          'cell is the gradient disc', (tester) async {
        await pumpEditProfile(tester, profile: editRepo());
        await openPicker(tester);

        final card = tester.getRect(find.byType(ChooseAvatarSheet));
        final first = tester.getRect(
          find.byKey(const Key('avatar_choice_avatar-01')),
        );
        expect(first.size, const Size(69, 69));
        expect(first.left - card.left, 21);
        expect(first.top - card.top, 89);
        expect(
          find.descendant(
            of: find.byType(ChooseAvatarSheet),
            matching: find.byType(AvatarDisc),
          ),
          findsNWidgets(avatarChoices.length),
        );
      });
    });

    testWidgets('I1: the system Back on a dirty form asks too (PopScope)', (
      tester,
    ) async {
      final container = await pumpEditProfile(tester, profile: editRepo());

      await tester.enterText(input('edit_name_field'), 'Ahmed Ali');
      await tester.pump();
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.text('Discard changes?'), findsOneWidget);
      expect(locationOf(container), '/profile/edit');
    });

    testWidgets('offline over a loaded form: the banner shows and the form '
        'stays', (tester) async {
      await pumpEditProfile(tester, profile: editRepo(), online: false);

      expect(find.byType(OfflineBanner), findsOneWidget);
      expect(find.byKey(const Key('edit_save_button')), findsOneWidget);
      expect(find.byType(ReadOnlyField), findsWidgets);
    });

    testWidgets('a second tap on Save while the first is in flight sends '
        'nothing more', (tester) async {
      final repo = profileRepo();
      final pending = Completer<StudentProfile>();
      when(() => repo.updateMe(any())).thenAnswer((_) => pending.future);
      await pumpEditProfile(tester, profile: repo);

      await tester.enterText(input('edit_name_field'), 'Ahmed Ali');
      await tester.pump();
      await tester.tap(find.byKey(const Key('edit_save_button')));
      await tester.pump();
      await tester.tap(
        find.byKey(const Key('edit_save_button')),
        warnIfMissed: false,
      );
      await tester.pump();

      verify(() => repo.updateMe(any())).called(1);
      pending.complete(schoolProfile());
      await tester.pumpAndSettle();
    });
  });
}
