import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core_providers.dart';

/// Drives the app locale. AR is the primary audience, so it is the default.
/// The Login language-toggle pill flips between AR and EN via [toggle], and the
/// Settings Languages section picks one outright via [select]; the root
/// [MaterialApp.router] watches this and `Directionality` follows the locale
/// automatically (RTL for ar, LTR for en).
///
/// **The choice survives a launch**, as of the theme-wiring pass. This used to
/// carry a deferral — *"add a SharedPreferences-backed load/save when settings
/// lands"* — which named its own trigger condition; Settings landed in Day 8
/// step 3 and the condition fired. [build] reads the stored language
/// synchronously so the first frame is already in the right language and
/// direction; an absent or unrecognised value falls back to AR. The failure
/// handling lives in `PreferencesStore`.
class LocaleController extends Notifier<Locale> {
  @override
  Locale build() =>
      ref.watch(preferencesStoreProvider)?.readLocale() ?? const Locale('ar');

  /// The language pill's flip. Six screens carry one, and none of them offers a
  /// choice — there are two locales, so "the other one" is unambiguous.
  void toggle() => select(
    state.languageCode == 'ar' ? const Locale('en') : const Locale('ar'),
  );

  /// Picks a language outright, for the Settings list where both options are on
  /// screen at once and "toggle" is the wrong verb: tapping the row you are
  /// already on must do nothing, not flip you away from it.
  ///
  /// [toggle] delegates here so there is one place where the locale changes —
  /// and now one place where it is written down.
  void select(Locale locale) {
    if (locale == state) return;
    state = locale;

    // Fire-and-forget for the reason given on [ThemeModeController.select].
    final store = ref.read(preferencesStoreProvider);
    if (store != null) unawaited(store.writeLocale(locale));
  }
}

final localeProvider = NotifierProvider<LocaleController, Locale>(
  LocaleController.new,
);
