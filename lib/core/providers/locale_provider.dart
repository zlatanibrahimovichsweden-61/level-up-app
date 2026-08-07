import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Drives the app locale. AR is the primary audience, so it is the default.
/// The Login language-toggle pill flips between AR and EN via [toggle]; the
/// root [MaterialApp.router] watches this and `Directionality` follows the
/// locale automatically (RTL for ar, LTR for en).
///
/// Persistence across launches is deferred — not required by the two-screen
/// scope; add a SharedPreferences-backed load/save when settings lands.
class LocaleController extends Notifier<Locale> {
  @override
  Locale build() => const Locale('ar');

  /// The language pill's flip. Six screens carry one, and none of them offers a
  /// choice — there are two locales, so "the other one" is unambiguous.
  void toggle() =>
      select(state.languageCode == 'ar' ? const Locale('en') : const Locale('ar'));

  /// Picks a language outright, for the Settings list where both options are on
  /// screen at once and "toggle" is the wrong verb: tapping the row you are
  /// already on must do nothing, not flip you away from it.
  ///
  /// [toggle] delegates here so there is one place where the locale changes.
  void select(Locale locale) {
    if (locale == state) return;
    state = locale;
  }
}

final localeProvider =
    NotifierProvider<LocaleController, Locale>(LocaleController.new);
