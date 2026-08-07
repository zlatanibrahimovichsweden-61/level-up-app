import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core_providers.dart';

/// Drives the app's canvas. Light is the default — the design's primary canvas
/// and what every fidelity pass since Day 7b was measured against.
///
/// **This is the switch that was missing, not a new palette.** `AppTheme.light`
/// and `AppTheme.dark` have both existed since Day 0 and `MaterialApp` has been
/// handed both since then, but `themeMode` was pinned to `ThemeMode.light` with
/// a comment saying it would move "when a theme toggle lands in Settings"
/// (`app.dart`). Settings is that screen, so this is that toggle. Nothing about
/// either palette changes; `docs/DESIGN_ISSUES.md` #10 is what closes.
///
/// Deliberately shaped exactly like [LocaleController]: a plain [Notifier] over
/// an enum, one explicit setter, the same preference store behind it. The two
/// are the same kind of preference and a reader who understands one should not
/// have to learn the other.
///
/// **`ThemeMode.system` is not offered.** The frame draws a choice between
/// canvases, not a follow-the-OS option, and the app has exactly two of them —
/// see `seif_fight.md` S26 for the third circle the frame draws and this app
/// cannot fill. `system` stays in the type because it is Flutter's, not ours;
/// nothing sets it.
///
/// **The choice survives a launch.** [build] reads the stored canvas
/// synchronously, which is the whole reason `preferencesStoreProvider` is
/// injected before `runApp` rather than loaded lazily: a student who picks dark
/// gets dark on the first frame of the next launch, not after a visible flip.
/// A missing, unrecognised or unreadable stored value falls back here to
/// [ThemeMode.light] — see `PreferencesStore`, where the failure handling lives.
class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() =>
      ref.watch(preferencesStoreProvider)?.readThemeMode() ?? ThemeMode.light;

  /// Sets the canvas. Idempotent — re-selecting the current mode is a no-op, so
  /// tapping the already-selected row does not rebuild the whole app, and does
  /// not rewrite the preference either.
  void select(ThemeMode mode) {
    if (mode == state) return;
    state = mode;

    // Fire-and-forget: the canvas has already changed and the student is
    // looking at it. Awaiting would make every caller async to no visible end.
    // Safe to leave unhandled because the store swallows its own write errors.
    final store = ref.read(preferencesStoreProvider);
    if (store != null) unawaited(store.writeThemeMode(mode));
  }
}

final themeModeProvider =
    NotifierProvider<ThemeModeController, ThemeMode>(ThemeModeController.new);
