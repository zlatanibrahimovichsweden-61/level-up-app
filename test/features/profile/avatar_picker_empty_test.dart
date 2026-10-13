import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/profile/widgets/avatar_sheets.dart';
import 'package:level_up_app/features/registration/models/reference_models.dart';
import 'package:level_up_app/features/registration/notifier/reference_providers.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import 'profile_harness.dart';

/// "Choose Avatar" when `GET /reference/avatars` answers with an EMPTY list
/// (NR-33).
///
/// The server answered; there is nothing to retry away. The sheet used to say
/// "Something went wrong" - a failure the student did not have - and now says
/// the neutral empty line the app already has (`nothingHere`, the
/// Notifications inbox's), with no Retry. The failure and loading states are
/// not touched.
void main() {
  Future<void> pumpSheet(
    WidgetTester tester, {
    required String locale,
    required Future<List<Avatar>> Function() avatars,
    Brightness brightness = Brightness.light,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [avatarsProvider.overrideWith((ref) => avatars())],
        child: MaterialApp(
          theme: brightness == Brightness.light
              ? AppTheme.light
              : AppTheme.dark,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale(locale),
          home: const Scaffold(body: Center(child: ChooseAvatarSheet())),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
  }

  for (final locale in ['en', 'ar']) {
    for (final brightness in Brightness.values) {
      testWidgets('$locale · ${brightness.name} · an empty list reads '
          '"nothing here", with no Retry and no error', (tester) async {
        await pumpSheet(
          tester,
          locale: locale,
          brightness: brightness,
          avatars: () async => const <Avatar>[],
        );
        final l10n = AppLocalizations.of(
          tester.element(find.byType(ChooseAvatarSheet)),
        );

        expect(find.text(l10n.nothingHere), findsOneWidget);
        expect(find.text(l10n.genericError), findsNothing);
        expect(find.byKey(const Key('avatar_sheet_retry')), findsNothing);
        expect(find.text(l10n.retry), findsNothing);
        // And the strip itself is absent: there is nothing to choose.
        expect(find.byKey(const Key('avatar_choice_strip')), findsNothing);
        expect(tester.takeException(), isNull);
      });
    }
  }

  // The states beside it are untouched.
  for (final locale in ['en', 'ar']) {
    testWidgets('$locale · a FAILED load still says so, with a Retry', (
      tester,
    ) async {
      await pumpSheet(
        tester,
        locale: locale,
        avatars: () async => throw const UnknownException(),
      );
      final l10n = AppLocalizations.of(
        tester.element(find.byType(ChooseAvatarSheet)),
      );

      expect(find.text(l10n.genericError), findsOneWidget);
      expect(find.text(l10n.nothingHere), findsNothing);
      expect(find.byKey(const Key('avatar_sheet_retry')), findsOneWidget);
    });

    testWidgets('$locale · an OFFLINE load still says so, with a Retry', (
      tester,
    ) async {
      await pumpSheet(
        tester,
        locale: locale,
        avatars: () async => throw const OfflineException(),
      );
      final l10n = AppLocalizations.of(
        tester.element(find.byType(ChooseAvatarSheet)),
      );

      expect(find.text(l10n.offline), findsOneWidget);
      expect(find.text(l10n.nothingHere), findsNothing);
      expect(find.byKey(const Key('avatar_sheet_retry')), findsOneWidget);
    });

    testWidgets('$locale · a list with avatars shows the strip, not the '
        'empty line', (tester) async {
      await pumpSheet(
        tester,
        locale: locale,
        avatars: () async => avatarChoices,
      );
      final l10n = AppLocalizations.of(
        tester.element(find.byType(ChooseAvatarSheet)),
      );

      expect(find.byKey(const Key('avatar_choice_strip')), findsOneWidget);
      expect(find.text(l10n.nothingHere), findsNothing);
    });
  }

  // Through Edit Profile, the way a student reaches it.
  for (final locale in ['en', 'ar']) {
    testWidgets('$locale · from Edit Profile: Choose avatar over an empty '
        'catalogue says "nothing here"', (tester) async {
      final reference = MockReferenceRepository();
      when(reference.getAvatars).thenAnswer((_) async => const <Avatar>[]);

      await pumpEditProfile(
        tester,
        profile: profileRepo(),
        reference: reference,
        locale: locale,
      );
      await tapProfileKey(tester, 'edit_avatar_button');
      await tapProfileKey(tester, 'avatar_use_default');

      final l10n = AppLocalizations.of(
        tester.element(find.byType(ChooseAvatarSheet)),
      );
      expect(find.text(l10n.nothingHere), findsOneWidget);
      expect(find.text(l10n.genericError), findsNothing);
      expect(find.byKey(const Key('avatar_sheet_retry')), findsNothing);
      verify(reference.getAvatars).called(1);
    });
  }
}
