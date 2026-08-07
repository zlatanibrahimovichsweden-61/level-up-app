import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
/// an enum, no persistence, one explicit setter. The two are the same kind of
/// preference and a reader who understands one should not have to learn the
/// other.
///
/// **`ThemeMode.system` is not offered.** The frame draws a choice between
/// canvases, not a follow-the-OS option, and the app has exactly two of them —
/// see `seif_fight.md` S26 for the third circle the frame draws and this app
/// cannot fill. `system` stays in the type because it is Flutter's, not ours;
/// nothing sets it.
///
/// Persistence across launches is deferred for the same reason the locale's is:
/// no requirement, no storage layer for preferences, and inventing one here
/// would be a bigger decision than this step is allowed to make. A student who
/// picks dark gets dark until they close the app.
class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.light;

  /// Sets the canvas. Idempotent — re-selecting the current mode is a no-op, so
  /// tapping the already-selected row does not rebuild the whole app.
  void select(ThemeMode mode) {
    if (mode == state) return;
    state = mode;
  }
}

final themeModeProvider =
    NotifierProvider<ThemeModeController, ThemeMode>(ThemeModeController.new);
