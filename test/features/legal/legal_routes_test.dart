import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/account_shells/screens/legal_document_screen.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/auth/repository/auth_repository.dart';
import 'package:level_up_app/features/auth/screens/login_screen.dart';
import 'package:level_up_app/features/legal/repository/legal_repository.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import 'legal_fixtures.dart';

/// CW04a routes: the legal documents are public (owner D2), Login's legal line
/// opens them in the app (C1), and its Cookie Policy link is gone (C2).
///
/// Driven through the app's REAL [routerProvider], signed out (no stored
/// token), so the auth redirect is the production one.

class _MockSecureStorage extends Mock implements SecureStorage {}

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late ScriptedLegalRepository legal;

  setUp(() {
    legal = ScriptedLegalRepository([
      fixtureDocument(LegalDocument.terms, 'en'),
    ]);
  });

  Future<ProviderContainer> pumpSignedOut(
    WidgetTester tester, {
    String language = 'en',
  }) async {
    final storage = _MockSecureStorage();
    when(storage.readAccessToken).thenAnswer((_) async => null);
    final container = ProviderContainer(
      overrides: [
        secureStorageProvider.overrideWithValue(storage),
        authRepositoryProvider.overrideWithValue(_MockAuthRepository()),
        isOnlineProvider.overrideWith((ref) => Stream.value(true)),
        legalRepositoryProvider.overrideWithValue(legal),
      ],
    );
    addTearDown(container.dispose);
    // Tall enough for the whole Login form, so the legal line is on screen.
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          locale: Locale(language),
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: container.read(routerProvider),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(container.read(authControllerProvider), isA<AuthUnauthenticated>());
    container.read(routerProvider).go('/login');
    await tester.pumpAndSettle();
    return container;
  }

  String location(ProviderContainer container) =>
      container.read(routerProvider).state.uri.toString();

  /// Runs [body], then unmounts inside the test: the viewer watches an
  /// `autoDispose` provider (see `holdLegalDocuments`).
  void routeTest(String description, WidgetTesterCallback body) =>
      testWidgets(description, (tester) async {
        await body(tester);
        await tester.pumpWidget(const SizedBox());
        await tester.pump();
      });

  for (final language in ['en', 'ar']) {
    final l10n = lookupAppLocalizations(Locale(language));

    group('$language · from Login, signed out', () {
      routeTest('"User Agreement" opens the Terms viewer; back returns to '
          'Login', (tester) async {
        final container = await pumpSignedOut(tester, language: language);
        expect(find.byType(LoginScreen), findsOneWidget);

        await tester.ensureVisible(find.byKey(const Key('login_legal_terms')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('login_legal_terms')));
        await tester.pumpAndSettle();

        expect(location(container), '/legal/terms');
        expect(
          tester
              .widget<LegalDocumentScreen>(find.byType(LegalDocumentScreen))
              .document,
          LegalDocument.terms,
        );
        expect(legal.calls.single, (
          document: LegalDocument.terms,
          language: language,
        ));
        expect(find.text(fixtureTitle, findRichText: true), findsOneWidget);
        expect(
          container.read(authControllerProvider),
          isA<AuthUnauthenticated>(),
        );

        await tester.tap(find.byKey(const Key('legal_back')));
        await tester.pumpAndSettle();
        expect(location(container), '/login');
        expect(find.byType(LoginScreen), findsOneWidget);
      });

      routeTest('"Privacy Policy" opens the Privacy viewer', (tester) async {
        final container = await pumpSignedOut(tester, language: language);

        await tester.ensureVisible(
          find.byKey(const Key('login_legal_privacy')),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('login_legal_privacy')));
        await tester.pumpAndSettle();

        expect(location(container), '/legal/privacy');
        expect(legal.calls.single.document, LegalDocument.privacy);
        expect(legal.calls.single.language, language);
      });

      // The existing fragments, joined. Each string predates CW04a; the
      // sentence they make is NOT approved yet (O-16, owner decision pending).
      routeTest('the line has two links and no Cookie Policy, from the '
          'existing fragments, in reading order', (tester) async {
        await pumpSignedOut(tester, language: language);

        expect(find.text(l10n.cookiePolicy), findsNothing);
        expect(find.textContaining(l10n.cookiePolicy), findsNothing);
        expect(find.text(l10n.legalSeparator), findsNothing);

        final pieces = [
          find.text('${l10n.legalPrefix} '),
          find.byKey(const Key('login_legal_terms')),
          find.text(' ${l10n.legalAnd} '),
          find.byKey(const Key('login_legal_privacy')),
        ];
        for (final piece in pieces) {
          expect(piece, findsOneWidget);
        }
        expect(
          find.descendant(
            of: find.byKey(const Key('login_legal_terms')),
            matching: find.text(l10n.userAgreement),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byKey(const Key('login_legal_privacy')),
            matching: find.text(l10n.privacyPolicy),
          ),
          findsOneWidget,
        );
        // Start to end in the reading direction; the Wrap may break the line,
        // so a later piece is either on a later line or further along this one.
        for (var i = 1; i < pieces.length; i++) {
          final previous = tester.getRect(pieces[i - 1]);
          final current = tester.getRect(pieces[i]);
          final sameLine = (current.center.dy - previous.center.dy).abs() < 4;
          final along = language == 'ar'
              ? current.center.dx < previous.center.dx
              : current.center.dx > previous.center.dx;
          expect(
            sameLine ? along : current.top >= previous.bottom - 1,
            isTrue,
            reason: 'piece $i',
          );
        }
      });

      routeTest('each link is announced as a link', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpSignedOut(tester, language: language);

        for (final (key, label) in [
          ('login_legal_terms', l10n.userAgreement),
          ('login_legal_privacy', l10n.privacyPolicy),
        ]) {
          expect(
            tester.getSemantics(find.byKey(Key(key))),
            isSemantics(label: label, isLink: true, hasTapAction: true),
            reason: key,
          );
        }
        handle.dispose();
      });
    });
  }

  group('the auth redirect', () {
    routeTest('signed out, each document is reachable directly', (
      tester,
    ) async {
      final container = await pumpSignedOut(tester);

      for (final path in ['/legal/privacy', '/legal/terms']) {
        container.read(routerProvider).go(path);
        await tester.pumpAndSettle();
        expect(location(container), path);
        expect(find.byType(LegalDocumentScreen), findsOneWidget);
      }
    });

    test('signed out: exactly the two documents are let through', () {
      const signedOut = AuthUnauthenticated();
      expect(authRedirect(signedOut, '/legal/privacy'), isNull);
      expect(authRedirect(signedOut, '/legal/terms'), isNull);

      // Not a `/legal` prefix: anything else under it stays protected.
      for (final path in [
        '/legal',
        '/legal/cookies',
        '/legal/user-agreement',
        '/legal/terms/extra',
      ]) {
        expect(authRedirect(signedOut, path), '/login', reason: path);
      }
    });

    test('signed out: every other protected route still goes to /login', () {
      const signedOut = AuthUnauthenticated();
      for (final path in [
        '/home',
        '/profile',
        '/profile/edit',
        '/settings',
        '/support',
        '/support/new',
        '/notifications',
        '/friends',
        '/refer',
        '/leaderboard',
        '/mistakes',
        '/quiz/setup',
      ]) {
        expect(authRedirect(signedOut, path), '/login', reason: path);
      }
      // The signed-out routes that were already public are unchanged.
      for (final path in ['/', '/login', '/login/otp', '/register']) {
        expect(authRedirect(signedOut, path), isNull, reason: path);
      }
    });

    test('signed in: the documents stay reachable (from Profile); the '
        'pre-auth landings still bounce to /home', () {
      const signedIn = AuthAuthenticated();
      expect(authRedirect(signedIn, '/legal/privacy'), isNull);
      expect(authRedirect(signedIn, '/legal/terms'), isNull);
      expect(authRedirect(signedIn, '/login'), '/home');
      expect(authRedirect(signedIn, '/'), '/home');
    });

    test('while auth is still resolving nothing is redirected', () {
      expect(authRedirect(const AuthUnknown(), '/legal/terms'), isNull);
    });
  });

  test('no placeholder legal host is left in lib/', () {
    final offenders = [
      for (final file in Directory('lib').listSync(recursive: true))
        if (file is File &&
            file.path.endsWith('.dart') &&
            file.readAsStringSync().contains('levelup.example'))
          file.path,
    ];
    expect(offenders, isEmpty);
  });
}
