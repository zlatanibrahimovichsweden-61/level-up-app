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

  void toggle() {
    state = state.languageCode == 'ar' ? const Locale('en') : const Locale('ar');
  }
}

final localeProvider =
    NotifierProvider<LocaleController, Locale>(LocaleController.new);
