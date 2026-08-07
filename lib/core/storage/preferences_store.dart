// material, not widgets: `ThemeMode` is a Material concept, and this store
// speaks the same vocabulary the Settings rows and `MaterialApp` do.
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/app_localizations.dart';

/// Device-local, non-secret preferences: the canvas and the language.
///
/// **Deliberately NOT [SecureStorage].** That store exists for tokens and the
/// `device_id`, and its own doc explains the Keychain policy those need — a
/// `first_unlock_this_device` accessibility class, no iCloud sync, an encrypted
/// Android backend. A theme choice is not a secret, is not personal data, and
/// putting it behind Keychain/Keystore would mean a preference read has to
/// survive the same threat model as a refresh token. Wrong tool.
///
/// Everything here is **synchronous to read**: `SharedPreferences` caches the
/// whole file in memory when it loads, so `readThemeMode()` is a map lookup.
/// That is the property the no-flash startup depends on — see `bootstrap()`,
/// which loads the store *before* `runApp` so the very first frame is already
/// painted in the stored canvas rather than flipping into it a frame later.
///
/// Reads and writes both swallow their own failures and fall back to "no stored
/// value". A damaged preferences file must not be able to stop the app from
/// starting, and losing a theme choice is not worth a crash.
class PreferencesStore {
  PreferencesStore(this._prefs);

  /// Loads the backing file. Awaited once, in `bootstrap()`.
  static Future<PreferencesStore> load() async =>
      PreferencesStore(await SharedPreferences.getInstance());

  final SharedPreferences _prefs;

  static const _kThemeMode = 'pref.theme_mode';
  static const _kLocale = 'pref.locale';

  static const _light = 'light';
  static const _dark = 'dark';

  /// The stored canvas, or null when nothing valid is stored — a first launch,
  /// a cleared file, or a value this version does not recognise. The caller
  /// supplies the default; this class does not know what it is.
  ThemeMode? readThemeMode() => switch (_read(_kThemeMode)) {
        _light => ThemeMode.light,
        _dark => ThemeMode.dark,
        _ => null,
      };

  /// Stores the canvas as a **name**, not `ThemeMode.index`. An index would tie
  /// the file format to the ordering of a Flutter enum we do not control.
  ///
  /// `ThemeMode.system` clears the key rather than storing a third value: the
  /// app offers two canvases and nothing sets `system` (see [ThemeModeController]
  /// and `seif_fight.md` S26). Storing it would mean the next launch reads back
  /// a mode no row on the Settings screen can represent.
  Future<void> writeThemeMode(ThemeMode mode) => switch (mode) {
        ThemeMode.light => _write(_kThemeMode, _light),
        ThemeMode.dark => _write(_kThemeMode, _dark),
        ThemeMode.system => _remove(_kThemeMode),
      };

  /// The stored language, or null when nothing valid is stored.
  ///
  /// Validated against [AppLocalizations.supportedLocales] rather than a local
  /// list of codes, so this cannot drift out of step with the ARB files: a
  /// locale the app no longer ships reads back as "nothing stored" and the
  /// student gets the default instead of an untranslated app.
  Locale? readLocale() {
    final code = _read(_kLocale);
    if (code == null) return null;
    for (final locale in AppLocalizations.supportedLocales) {
      if (locale.languageCode == code) return locale;
    }
    return null;
  }

  /// Stores the language code only. The app's locales carry no country or
  /// script subtag, and writing a full tag would make the read above miss.
  Future<void> writeLocale(Locale locale) =>
      _write(_kLocale, locale.languageCode);

  /// Every read funnels through here.
  ///
  /// `getString` does not merely return null for a key holding another type —
  /// it throws, because the cache is `Map<String, Object>` and the getter casts.
  /// A file written by a different version of this app, or a partial write, is
  /// therefore a crash on the startup path unless it is caught here.
  String? _read(String key) {
    try {
      return _prefs.getString(key);
    } catch (_) {
      // Left in place rather than removed: a self-healing delete would be a
      // write on the read path, and the next write overwrites it anyway.
      return null;
    }
  }

  Future<void> _write(String key, String value) async {
    try {
      await _prefs.setString(key, value);
    } catch (_) {
      // Fire-and-forget from the controllers, so an unhandled failure here
      // would reach the zone error handler and take the app down over a
      // preference. Dropped on purpose.
    }
  }

  Future<void> _remove(String key) async {
    try {
      await _prefs.remove(key);
    } catch (_) {
      // Same reason as _write.
    }
  }
}
