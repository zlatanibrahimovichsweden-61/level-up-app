import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/bootstrap.dart';
import 'package:level_up_app/core/config/app_config.dart';

/// CW18a, boot assertion: the compiled [Flavor] and the platform build flavor
/// (`--flavor X`, read at runtime as `appFlavor`) must agree, or `bootstrap()`
/// stops before it initialises anything.
///
/// The comparison is a MAPPING, not an equality. Android has two installable
/// identities, `prod` and `staging`; `Flavor.dev` is a runtime mode of the
/// staging identity (D-021 Q2). An equality check would reject every dev boot,
/// so the dev rows below are the ones that matter most.
void main() {
  tearDown(AppConfig.resetForTesting);

  group('the mapping (pure)', () {
    test('dev and staging run under the staging platform flavor', () {
      expect(AppConfig.platformFlavorAgrees(Flavor.dev, 'staging'), isTrue);
      expect(AppConfig.platformFlavorAgrees(Flavor.staging, 'staging'), isTrue);
    });

    test('prod runs under the prod platform flavor', () {
      expect(AppConfig.platformFlavorAgrees(Flavor.prod, 'prod'), isTrue);
    });

    test('an ABSENT platform flavor is tolerated for every flavor '
        '(iOS before Wave 3, flutter run without --flavor, flutter test)', () {
      for (final flavor in Flavor.values) {
        expect(
          AppConfig.platformFlavorAgrees(flavor, null),
          isTrue,
          reason: flavor.name,
        );
      }
    });

    test(
      'the production identity never runs the dev or staging entrypoint',
      () {
        expect(AppConfig.platformFlavorAgrees(Flavor.dev, 'prod'), isFalse);
        expect(AppConfig.platformFlavorAgrees(Flavor.staging, 'prod'), isFalse);
      },
    );

    test('the staging identity never runs the production entrypoint', () {
      expect(AppConfig.platformFlavorAgrees(Flavor.prod, 'staging'), isFalse);
    });

    test('there is no `dev` platform flavor, and names are exact', () {
      // Android has no `dev` product flavor, so a platform flavor called `dev`
      // is a misconfiguration to refuse, not a spelling of staging.
      for (final flavor in Flavor.values) {
        expect(AppConfig.platformFlavorAgrees(flavor, 'dev'), isFalse);
        expect(AppConfig.platformFlavorAgrees(flavor, ''), isFalse);
        expect(AppConfig.platformFlavorAgrees(flavor, 'Prod'), isFalse);
        expect(AppConfig.platformFlavorAgrees(flavor, 'STAGING'), isFalse);
      }
    });

    test('every compiled flavor has an accepted platform flavor', () {
      // A new Flavor value must be classified here (the switch is exhaustive,
      // so this also fails to compile before it can fail to pass).
      for (final flavor in Flavor.values) {
        expect(AppConfig.platformFlavorsFor(flavor), isNotEmpty);
      }
    });
  });

  group('verifyPlatformFlavor', () {
    test(
      'returns normally when the flavors agree or the platform has none',
      () {
        expect(
          () => AppConfig.verifyPlatformFlavor(Flavor.dev, 'staging'),
          returnsNormally,
        );
        expect(
          () => AppConfig.verifyPlatformFlavor(Flavor.prod, 'prod'),
          returnsNormally,
        );
        expect(
          () => AppConfig.verifyPlatformFlavor(Flavor.prod, null),
          returnsNormally,
        );
      },
    );

    test('throws a StateError that names both sides, on a mismatch', () {
      expect(
        () => AppConfig.verifyPlatformFlavor(Flavor.prod, 'staging'),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            allOf(contains('"staging"'), contains('Flavor.prod')),
          ),
        ),
      );
      expect(
        () => AppConfig.verifyPlatformFlavor(Flavor.dev, 'prod'),
        throwsStateError,
      );
    });
  });

  group('bootstrap()', () {
    test(
      'a mismatch fails the boot BEFORE the config is initialised',
      () async {
        AppConfig.resetForTesting();

        await expectLater(
          bootstrap(Flavor.prod, platformFlavor: 'staging'),
          throwsStateError,
        );

        // Nothing past the check ran: no config, so no base URL for a request.
        expect(AppConfig.maybeInstance, isNull);
      },
    );

    test(
      'the staging entrypoint cannot boot under the prod platform flavor',
      () async {
        await expectLater(
          bootstrap(Flavor.staging, platformFlavor: 'prod'),
          throwsStateError,
        );
        expect(AppConfig.maybeInstance, isNull);
      },
    );
  });

  group('AppConfig.maybeInstance', () {
    test('is null until init, then the initialised config', () {
      AppConfig.resetForTesting();
      expect(AppConfig.maybeInstance, isNull);

      AppConfig.init(Flavor.staging);
      expect(AppConfig.maybeInstance?.flavor, Flavor.staging);
      expect(identical(AppConfig.maybeInstance, AppConfig.instance), isTrue);
    });

    test('resetForTesting returns instance to its not-initialised throw', () {
      AppConfig.init(Flavor.dev);
      AppConfig.resetForTesting();
      expect(() => AppConfig.instance, throwsStateError);
    });
  });
}
