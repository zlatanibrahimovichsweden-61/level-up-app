import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/home/screens/home_screen.dart';
import 'package:level_up_app/features/home/widgets/coming_soon_section.dart';
import 'package:level_up_app/features/home/widgets/level_card.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:level_up_app/features/profile/repository/profile_repository.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import '../profile/profile_fixtures.dart';

/// Home · Figma `337:5303`. Covers the four screen states (there is no Empty —
/// `/me` either returns a profile or fails), both locales, and both themes.

class _MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late _MockProfileRepository repo;

  setUp(() {
    repo = _MockProfileRepository();
    // Entitlements are fetched independently of Home's own rendering; stub it
    // so nothing is left unstubbed if the provider is ever read here.
    when(repo.getEntitlements).thenAnswer((_) async => [baseEntitlement]);
  });

  Future<void> pumpHome(
    WidgetTester tester, {
    Locale locale = const Locale('en'),
    ThemeData? theme,
    bool offline = false,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          profileRepositoryProvider.overrideWithValue(repo),
          isOnlineProvider.overrideWith((ref) => Stream.value(!offline)),
        ],
        child: MaterialApp(
          locale: locale,
          theme: theme ?? AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const HomeScreen(),
        ),
      ),
    );
    // Two frames: one for the connectivity stream and the resolved /me future,
    // a second because a REJECTED future reaches the widget a microtask later
    // than a resolved one.
    await tester.pump();
    await tester.pump();
  }

  group('loaded', () {
    setUp(() => when(repo.getMe).thenAnswer((_) async => schoolProfile()));

    testWidgets('renders the header and the level card from GET /me', (
      tester,
    ) async {
      await pumpHome(tester);

      expect(find.text('Welcome back,'), findsOneWidget);
      expect(find.text('Ahmed Mohamed'), findsOneWidget);
      // Server-authoritative values, rendered exactly as returned.
      expect(find.text('LEVEL 8'), findsOneWidget);
      expect(find.text('2,450'), findsOneWidget);
      expect(find.text('Pts Balance'), findsOneWidget);
      // Progress toward level 9, from the CLIENT constant (DESIGN_ISSUES #13).
      expect(find.text('Level 8'), findsOneWidget);
      expect(find.text('Level 9'), findsOneWidget);
      expect(find.text('2,450 / 4,000'), findsOneWidget);
    });

    testWidgets('the three draft-endpoint sections are stubbed, not faked', (
      tester,
    ) async {
      await pumpHome(tester);

      expect(find.text('Daily Tasks'), findsOneWidget);
      expect(find.text('Continue Learning'), findsOneWidget);
      expect(find.text('Top Student'), findsOneWidget);
      expect(find.text('Coming soon'), findsNWidgets(3));

      // None of the designer's mock rows may reach a real student.
      for (final fake in [
        'Complete 2 Quizzes',
        'Physics',
        'Sara Mohamed',
        '18,200',
      ]) {
        expect(find.text(fake), findsNothing, reason: '$fake is mock data');
      }
    });

    testWidgets('renders in dark theme too', (tester) async {
      await pumpHome(tester, theme: AppTheme.dark);

      expect(find.text('LEVEL 8'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders Arabic under RTL directionality', (tester) async {
      await pumpHome(tester, locale: const Locale('ar'));

      expect(find.text('أهلًا بعودتك،'), findsOneWidget);
      expect(find.text('المهام اليومية'), findsOneWidget); // dailyTasks
      expect(
        Directionality.of(tester.element(find.text('أهلًا بعودتك،'))),
        TextDirection.rtl,
      );
    });
  });

  group('states', () {
    testWidgets('loading → a skeleton, not a bare spinner', (tester) async {
      // Never completes: the screen stays in its loading state.
      when(repo.getMe).thenAnswer((_) => Completer<StudentProfile>().future);
      await pumpHome(tester);

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('LEVEL 8'), findsNothing);
      // The skeleton blocks stand in for the header + level card.
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('error → localized copy + a Retry that re-calls /me', (
      tester,
    ) async {
      when(repo.getMe).thenAnswer(
        (_) => Future<StudentProfile>.error(
          const ApiException(status: 500, code: 'internal_error'),
        ),
      );
      await pumpHome(tester);

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(
        find.text('You are offline'),
        findsNothing,
      ); // not an offline error

      // Retry re-triggers the same request — on tap, never silently.
      when(repo.getMe).thenAnswer((_) async => schoolProfile());
      await tester.tap(find.widgetWithText(FilledButton, 'Retry'));
      await tester.pump();
      await tester.pump();

      expect(find.text('LEVEL 8'), findsOneWidget);
      verify(repo.getMe).called(2);
    });

    testWidgets('offline error → the offline view, not the generic error', (
      tester,
    ) async {
      when(repo.getMe).thenAnswer(
        (_) => Future<StudentProfile>.error(const OfflineException()),
      );
      await pumpHome(tester);

      expect(find.text('You are offline'), findsOneWidget);
      expect(find.text('Something went wrong'), findsNothing);
      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
    });

    testWidgets('connectivity down with data on screen → pinned banner', (
      tester,
    ) async {
      when(repo.getMe).thenAnswer((_) async => schoolProfile());
      await pumpHome(tester, offline: true);

      // Both: the banner AND the loaded content.
      expect(find.text('You are offline'), findsOneWidget);
      expect(find.text('LEVEL 8'), findsOneWidget);
    });

    testWidgets('offline view is localized in Arabic', (tester) async {
      when(repo.getMe).thenAnswer(
        (_) => Future<StudentProfile>.error(const OfflineException()),
      );
      await pumpHome(tester, locale: const Locale('ar'));

      expect(find.text('أنت غير متصل بالإنترنت'), findsOneWidget);
    });
  });

  /// Figma `125:2373` vs `337:5303`. ONE screen serves both tracks: `GET /me`
  /// is track-agnostic and so is everything Home renders from it. The frames
  /// differ in exactly one place, and that difference is asserted here rather
  /// than described in a comment.
  group('university (Figma 125:2373)', () {
    testWidgets('renders from a university /me — the shared parts are shared', (
      tester,
    ) async {
      when(repo.getMe).thenAnswer((_) async => universityProfile());
      await pumpHome(tester);

      expect(find.text('Mona Adel'), findsOneWidget);
      // Server-authoritative points, from the university pool this time.
      expect(find.byType(LevelCard), findsOneWidget);
      expect(find.text('Daily Tasks'), findsOneWidget);
      expect(find.text('Continue Learning'), findsOneWidget);
      expect(find.text('Top Student'), findsOneWidget);
    });

    testWidgets('adds Learning Tools, stubbed like every other section', (
      tester,
    ) async {
      // The frame draws five shortcut cards behind a premium crown. Not one of
      // them has an endpoint in M1 (quiz creation is Day 7; Flashcard has no
      // content endpoint at all), so the section is a header + "Coming soon".
      when(repo.getMe).thenAnswer((_) async => universityProfile());
      await pumpHome(tester);

      expect(find.text('Learning Tools'), findsOneWidget);
      expect(find.text('Coming soon'), findsNWidgets(4));
      // Never drawn as tappable cards a student can fall into.
      expect(find.text('Flash Card'), findsNothing);
      expect(find.text('Practices'), findsNothing);
    });

    testWidgets('school Home does NOT get the section', (tester) async {
      when(repo.getMe).thenAnswer((_) async => schoolProfile());
      await pumpHome(tester);

      expect(find.text('Learning Tools'), findsNothing);
      expect(find.text('Coming soon'), findsNWidgets(3));
    });

    testWidgets('Arabic labels the section in Arabic', (tester) async {
      when(repo.getMe).thenAnswer((_) async => universityProfile());
      await pumpHome(tester, locale: const Locale('ar'));

      expect(find.text('أدوات التعلّم'), findsOneWidget);
    });
  });

  /// edit3.md #1 / #3. The screen's job here is ROUTING a value, not styling:
  /// it hands each placeholder the surface its Figma section has, and hands the
  /// level card the track whose back-light it should draw. Both are values that
  /// compile and render fine when wrong, so they are asserted rather than
  /// trusted — the surfaces themselves are `coming_soon_section_test.dart`.
  group('section surfaces and the level card track (edit3)', () {
    List<ComingSoonSurface> surfaces(WidgetTester tester) => tester
        .widgetList<ComingSoonSection>(find.byType(ComingSoonSection))
        .map((s) => s.surface)
        .toList();

    testWidgets('school: Daily Tasks, Continue Learning, Top Student', (
      tester,
    ) async {
      when(repo.getMe).thenAnswer((_) async => schoolProfile());
      await pumpHome(tester);

      expect(surfaces(tester), [
        ComingSoonSurface.dailyTasks,
        ComingSoonSurface.continueLearning,
        ComingSoonSurface.topStudent,
      ]);
    });

    testWidgets('university inserts Learning Tools, and it stays PLAIN', (
      tester,
    ) async {
      // The frame gives Learning Tools no surface of its own — its five tiles
      // are recorded unbuilt (DESIGN_ISSUES #20) — so it must not borrow the
      // Daily Tasks surface it sits next to.
      when(repo.getMe).thenAnswer((_) async => universityProfile());
      await pumpHome(tester);

      expect(surfaces(tester), [
        ComingSoonSurface.dailyTasks,
        ComingSoonSurface.plain,
        ComingSoonSurface.continueLearning,
        ComingSoonSurface.topStudent,
      ]);
    });

    for (final (label, profile, track) in [
      ('school', schoolProfile, Track.school),
      ('university', universityProfile, Track.university),
    ]) {
      testWidgets('$label · the track reaches the card and every section', (
        tester,
      ) async {
        when(repo.getMe).thenAnswer((_) async => profile());
        await pumpHome(tester);

        expect(tester.widget<LevelCard>(find.byType(LevelCard)).track, track);
        for (final section in tester.widgetList<ComingSoonSection>(
          find.byType(ComingSoonSection),
        )) {
          expect(section.track, track, reason: section.title);
        }
      });
    }
  });

  group('levelProgressFraction (the one derived value on this screen)', () {
    test('is the fraction of the current level earned so far', () {
      // Level 8 starts at 3,500 (7 × 500); 2,450 is below it → clamped to 0.
      expect(levelProgressFraction(level: 8, totalPoints: 2450), 0);
      // Mid-level: 1,250 total at level 3 → 250 of 500 earned.
      expect(levelProgressFraction(level: 3, totalPoints: 1250), 0.5);
      expect(levelProgressFraction(level: 1, totalPoints: 0), 0);
      expect(levelProgressFraction(level: 1, totalPoints: 500), 1);
    });

    test('clamps instead of overflowing when server and constant disagree', () {
      // If kPointsPerLevel is wrong, the bar is full or empty — never broken.
      expect(levelProgressFraction(level: 2, totalPoints: 99999), 1);
      expect(levelProgressFraction(level: 5, totalPoints: 0), 0);
    });

    test('level 12 is the top — no next level to progress toward', () {
      expect(levelProgressFraction(level: kMaxLevel, totalPoints: 6000), 1);
      expect(levelProgressFraction(level: kMaxLevel, totalPoints: 99999), 1);
    });
  });
}
