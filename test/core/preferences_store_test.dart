import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/providers/locale_provider.dart';
import 'package:level_up_app/core/providers/theme_provider.dart';
import 'package:level_up_app/core/storage/preferences_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The two preferences that survive a launch, and the failure modes that must
/// not stop the app from starting.
///
/// The claim these tests exist for is not "a value round-trips" — that is the
/// easy half. It is that the value is in force at the FIRST read, with no
/// asynchronous gap in which the default could be painted. Every assertion on
/// [themeModeProvider] and [localeProvider] below reads the container without
/// pumping or awaiting anything first: if either controller ever went async,
/// these would start returning the default and fail.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<PreferencesStore> storeWith(Map<String, Object> initial) async {
    SharedPreferences.setMockInitialValues(initial);
    return PreferencesStore.load();
  }

  group('PreferencesStore', () {
    test('an empty file has nothing stored', () async {
      final store = await storeWith({});

      expect(store.readThemeMode(), isNull);
      expect(store.readLocale(), isNull);
    });

    test('both preferences round-trip', () async {
      final store = await storeWith({});

      await store.writeThemeMode(ThemeMode.dark);
      await store.writeLocale(const Locale('en'));

      expect(store.readThemeMode(), ThemeMode.dark);
      expect(store.readLocale(), const Locale('en'));
    });

    test('the canvas is stored by name, not by enum index', () async {
      // An index would pin the file format to the ordering of an enum that
      // belongs to Flutter, not to this app.
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      await PreferencesStore(prefs).writeThemeMode(ThemeMode.dark);

      expect(prefs.getString('pref.theme_mode'), 'dark');
    });

    test(
      'ThemeMode.system clears the key rather than storing a third value',
      () async {
        // Nothing sets `system` — the app has two canvases. If something ever
        // does, the next launch must fall back to the default rather than read
        // back a mode no Settings row can represent.
        final store = await storeWith({'pref.theme_mode': 'dark'});

        await store.writeThemeMode(ThemeMode.system);

        expect(store.readThemeMode(), isNull);
      },
    );

    test('an unrecognised value reads as nothing stored', () async {
      final store = await storeWith({
        'pref.theme_mode': 'sepia',
        'pref.locale': 'fr',
      });

      expect(store.readThemeMode(), isNull);
      // 'fr' is a perfectly well-formed language code the app does not ship.
      // Honouring it would render an untranslated app.
      expect(store.readLocale(), isNull);
    });

    test('a value of the wrong TYPE does not throw', () async {
      // The real corruption case. SharedPreferences caches
      // `Map<String, Object>` and `getString` CASTS, so a key written as an int
      // by another version of the app throws on read — on the startup path,
      // before any error handling exists.
      final store = await storeWith({
        'pref.theme_mode': 3,
        'pref.locale': true,
      });

      expect(store.readThemeMode(), isNull);
      expect(store.readLocale(), isNull);
    });

    test('a corrupt key is overwritten by the next write', () async {
      final store = await storeWith({'pref.theme_mode': 3});

      await store.writeThemeMode(ThemeMode.dark);

      expect(store.readThemeMode(), ThemeMode.dark);
    });
  });

  group('the controllers read the store at first build', () {
    ProviderContainer containerWith(PreferencesStore? store) {
      final container = ProviderContainer(
        overrides: [preferencesStoreProvider.overrideWithValue(store)],
      );
      addTearDown(container.dispose);
      return container;
    }

    test('no store at all yields the defaults', () async {
      // The unoverridden default, and what every widget test in the suite runs
      // on: light + AR, exactly as before persistence existed.
      final container = containerWith(null);

      expect(container.read(themeModeProvider), ThemeMode.light);
      expect(container.read(localeProvider), const Locale('ar'));
    });

    test(
      'a stored canvas and language are in force before anything is read',
      () async {
        final container = containerWith(
          await storeWith({'pref.theme_mode': 'dark', 'pref.locale': 'en'}),
        );

        expect(container.read(themeModeProvider), ThemeMode.dark);
        expect(container.read(localeProvider), const Locale('en'));
      },
    );

    test('a corrupt file yields the defaults and does not throw', () async {
      final container = containerWith(
        await storeWith({'pref.theme_mode': 3, 'pref.locale': 'fr'}),
      );

      expect(container.read(themeModeProvider), ThemeMode.light);
      expect(container.read(localeProvider), const Locale('ar'));
    });

    test('selecting a canvas writes it', () async {
      final store = await storeWith({});
      final container = containerWith(store);

      container.read(themeModeProvider.notifier).select(ThemeMode.dark);

      expect(container.read(themeModeProvider), ThemeMode.dark);
      expect(store.readThemeMode(), ThemeMode.dark);
    });

    test('selecting a language writes it', () async {
      final store = await storeWith({});
      final container = containerWith(store);

      container.read(localeProvider.notifier).select(const Locale('en'));

      expect(container.read(localeProvider), const Locale('en'));
      expect(store.readLocale(), const Locale('en'));
    });

    test('the language PILL writes it too — one path, not two', () async {
      // `toggle` delegates to `select`, so the six screens carrying a language
      // pill persist the choice as well. If someone ever un-delegates it, the
      // Login toggle would silently stop sticking.
      final store = await storeWith({});
      final container = containerWith(store);

      container.read(localeProvider.notifier).toggle();

      expect(store.readLocale(), const Locale('en'));
    });

    test('re-selecting the current value does not rewrite it', () async {
      final store = await storeWith({});
      final container = containerWith(store);

      container.read(themeModeProvider.notifier).select(ThemeMode.light);
      container.read(localeProvider.notifier).select(const Locale('ar'));

      // Still nothing stored: the no-op guard runs before the write, so tapping
      // the row you are already on does not touch the file.
      expect(store.readThemeMode(), isNull);
      expect(store.readLocale(), isNull);
    });
  });
}
