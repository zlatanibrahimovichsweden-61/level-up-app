/// Harness for the Settings and shell-screen widget tests.
///
/// These pump **`LevelUpApp` itself**, not a hand-rolled `MaterialApp`. Two of
/// the claims in this suite are about the root widget — that picking a canvas
/// changes `themeMode` and that picking a language changes `locale` — and a
/// test that builds its own `MaterialApp` proves only that a provider changed
/// value. The wiring in `app.dart` is the thing under test, so it has to be in
/// the tree.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/app.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/providers/locale_provider.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/profile/models/profile_update.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:level_up_app/features/profile/repository/profile_repository.dart';
import 'package:level_up_app/features/profile/widgets/profile_menu_row.dart'
    show kProfileDisabledOpacity;
import 'package:mocktail/mocktail.dart';

import '../profile/profile_fixtures.dart';
import '../profile/profile_harness.dart';

export '../profile/profile_harness.dart' show MockProfileRepository;

/// Boots the signed-in app and pushes [route].
///
/// The Account tab is NOT tapped first: `/settings` and the shells are pushed
/// over the shell route, which is exactly what `context.push` from the Profile
/// hub does.
Future<ProviderContainer> pumpAppAt(
  WidgetTester tester,
  String route, {
  MockProfileRepository? profile,
  String locale = 'en',
  bool online = true,
}) async {
  final container = ProviderContainer(
    overrides: [
      secureStorageProvider.overrideWithValue(signedInStorage()),
      profileRepositoryProvider.overrideWithValue(profile ?? settingsRepo()),
      isOnlineProvider.overrideWith((ref) => Stream.value(online)),
    ],
  );
  addTearDown(container.dispose);

  // Settings is ~850pt of sections and the default viewport is 600. Taller
  // here rather than scrolling before every tap: what this file proves is what
  // reaches the wire and what a control does, and a tap that lands off-screen
  // is noise rather than a finding.
  await tester.binding.setSurfaceSize(const Size(800, 1600));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  container.read(authControllerProvider.notifier).markAuthenticated();
  // AR is the app default; EN is set the way Settings itself sets it.
  container.read(localeProvider.notifier).select(Locale(locale));

  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const LevelUpApp()),
  );
  await tester.pumpAndSettle();

  container.read(routerProvider).push(route);
  await tester.pumpAndSettle();
  return container;
}

/// `/me` plus a stubbed `PATCH /me`.
///
/// [failure] and [updated] are mutually exclusive: one makes the write fail,
/// the other decides what the server says the profile became.
MockProfileRepository settingsRepo({
  StudentProfile? me,
  StudentProfile? updated,
  Object? failure,
}) {
  // Registered here, not in a per-file `setUpAll`: `any<ProfileUpdate>()` is
  // used two lines down, so a file that forgets the ceremony fails on the first
  // pump with a message about mocktail rather than about what it was testing.
  registerFallbackValue(const ProfileUpdate());
  final repo = profileRepo(me: me);
  if (failure != null) {
    when(() => repo.updateMe(any())).thenThrow(failure);
  } else {
    when(() => repo.updateMe(any()))
        .thenAnswer((_) async => updated ?? me ?? schoolProfile());
  }
  return repo;
}

/// The single [ProfileUpdate] handed to `PATCH /me`.
ProfileUpdate sentUpdate(MockProfileRepository repo) =>
    verify(() => repo.updateMe(captureAny())).captured.single as ProfileUpdate;

/// The palette actually in force at [finder] — the proof a Mode row changed the
/// canvas rather than just a provider's value.
AppColors paletteAt(WidgetTester tester, Finder finder) =>
    Theme.of(tester.element(finder)).extension<AppColors>()!;

/// Asserts a control renders, is dimmed, refuses pointers, and has no ink
/// response anywhere beneath it.
///
/// The last clause is the one that matters: `onChanged: null` on a Material
/// control still leaves a live widget in the tap-target tree, and this cluster's
/// contract is that a dead control is structurally dead.
void expectDeadControl(WidgetTester tester, String key) {
  final finder = find.byKey(Key(key));
  expect(finder, findsOneWidget, reason: '$key must render');

  expect(
    find.descendant(of: finder, matching: find.byType(InkWell)),
    findsNothing,
    reason: '$key must have no ink response',
  );

  // `.first` on both: a Material control renders its own disabled state with
  // more of these inside it, and the one being asserted is OURS — the
  // outermost, the wrapper that makes the whole row dead rather than just the
  // switch look grey.
  final ignore = tester.widget<IgnorePointer>(
    find.descendant(of: finder, matching: find.byType(IgnorePointer)).first,
  );
  expect(ignore.ignoring, isTrue, reason: '$key must refuse pointers');

  final opacity = tester.widget<Opacity>(
    find.descendant(of: finder, matching: find.byType(Opacity)).first,
  );
  expect(opacity.opacity, kProfileDisabledOpacity, reason: '$key must be dimmed');
}
