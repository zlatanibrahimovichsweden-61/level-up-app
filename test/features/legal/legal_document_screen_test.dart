import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderParagraph;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/account_shells/screens/legal_document_screen.dart';
import 'package:level_up_app/features/legal/legal_links.dart';
import 'package:level_up_app/features/legal/models/legal_document.dart';
import 'package:level_up_app/features/legal/repository/legal_repository.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

import '../../goldens/golden_harness.dart' show loadAppFonts;
import 'legal_fixtures.dart';

/// The legal document viewer (CW04a): `getLegalDocument` rendered in the app.
///
/// What is defended here:
/// - every state, in English (LTR) and Arabic (RTL), with existing copy only;
/// - the served text is rendered whole and in order — nothing edited, dropped
///   or summarised — and the document's own `# ` heading is the one visible
///   title (owner C3);
/// - untrusted text stays inert: no HTML is interpreted, no image is loaded,
///   and only https/mailto links open, outside the app;
/// - it stays readable at 2.0× text on a 320 dp phone, with the real fonts;
/// - nothing on it but the back chip is a control (purchase silence).
///
/// Every test unmounts the viewer before it ends: it watches an `autoDispose`
/// provider, whose disposal would otherwise be scheduled after the binding's
/// vsync is gone (see `holdLegalDocuments`).
void main() {
  setUpAll(loadAppFonts);

  final opened = <Uri>[];
  setUp(opened.clear);

  Future<bool> recordingLauncher(Uri uri) async {
    opened.add(uri);
    return true;
  }

  Widget app({
    required LegalDocument document,
    required String language,
    ThemeData? theme,
    double textScale = 1,
  }) => MaterialApp(
    locale: Locale(language),
    theme: theme ?? AppTheme.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(textScale)),
      child: child!,
    ),
    home: LegalDocumentScreen(document: document),
  );

  Future<ProviderContainer> pumpViewer(
    WidgetTester tester,
    LegalRepository repo, {
    LegalDocument document = LegalDocument.terms,
    String language = 'en',
    ThemeData? theme,
    double textScale = 1,
    Size size = const Size(400, 800),
  }) async {
    final container = ProviderContainer(
      overrides: [
        legalRepositoryProvider.overrideWithValue(repo),
        legalLinkLauncherProvider.overrideWithValue(recordingLauncher),
      ],
    );
    addTearDown(container.dispose);
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: app(
          document: document,
          language: language,
          theme: theme,
          textScale: textScale,
        ),
      ),
    );
    await tester.pump();
    return container;
  }

  /// Runs [body], then unmounts the viewer inside the test (see the header).
  void viewerTest(String description, WidgetTesterCallback body) =>
      testWidgets(description, (tester) async {
        await body(tester);
        await tester.pumpWidget(const SizedBox());
        await tester.pump();
      });

  Finder block(String text) => find.text(text, findRichText: true);

  String barTitle(WidgetTester tester) => tester
      .widget<Text>(
        find
            .descendant(of: find.byType(Stack), matching: find.byType(Text))
            .first,
      )
      .data!;

  for (final language in ['en', 'ar']) {
    final l10n = lookupAppLocalizations(Locale(language));
    final direction = language == 'ar' ? TextDirection.rtl : TextDirection.ltr;

    group('$language · states', () {
      viewerTest('loading: a spinner, and the bar names the document', (
        tester,
      ) async {
        final pending = Completer<LegalDocumentContent>();
        final repo = ScriptedLegalRepository([pending]);
        await pumpViewer(tester, repo, language: language);

        expect(find.byKey(const Key('legal_loading')), findsOneWidget);
        expect(barTitle(tester), l10n.profileTermsConditions);
        expect(find.byKey(const Key('legal_back')), findsOneWidget);
        expect(repo.calls.single, (
          document: LegalDocument.terms,
          language: language,
        ));

        pending.complete(fixtureDocument(LegalDocument.terms, language));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('legal_loading')), findsNothing);
        expect(block(fixtureTitle), findsOneWidget);
      });

      viewerTest('shown: the whole document, in order, and its own heading '
          'is the only visible title', (tester) async {
        final repo = ScriptedLegalRepository([
          fixtureDocument(LegalDocument.privacy, language),
        ]);
        await pumpViewer(
          tester,
          repo,
          document: LegalDocument.privacy,
          language: language,
          size: const Size(400, 2000),
        );
        await tester.pumpAndSettle();

        expect(repo.calls.single.document, LegalDocument.privacy);
        expect(repo.calls.single.language, language);
        for (final text in fixtureBlocks) {
          expect(block(text), findsOneWidget, reason: text);
        }
        // Reading order, top to bottom (table cells by row).
        double top(String text) => tester.getTopLeft(block(text)).dy;
        const ordered = [
          fixtureTitle,
          'Bullet alpha',
          'Nested bullet beta',
          'Bullet gamma',
          'Ordered one',
          'Ordered two',
          '2. Second section',
          'Cell A1',
          'Bold A2',
        ];
        for (var i = 1; i < ordered.length; i++) {
          expect(
            top(ordered[i]),
            greaterThan(top(ordered[i - 1])),
            reason: '${ordered[i - 1]} → ${ordered[i]}',
          );
        }
        expect(top(fixtureBlocks[1]), greaterThan(top(fixtureTitle)));
        expect(top('1. First section'), greaterThan(top(fixtureBlocks[1])));

        // C3: the bar keeps only the back chip; the heading is the title, once.
        expect(barTitle(tester), isEmpty);
        expect(find.text(l10n.profilePrivacyPolicy), findsNothing);
        expect(find.byKey(const Key('legal_back')), findsOneWidget);
        expect(
          Directionality.of(tester.element(block(fixtureBlocks[1]))),
          direction,
        );
      });

      viewerTest('404 legal_document_unavailable: "not published yet", with '
          'no Retry', (tester) async {
        final repo = ScriptedLegalRepository([
          const ApiException(status: 404, code: 'legal_document_unavailable'),
        ]);
        await pumpViewer(tester, repo, language: language);
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('legal_unavailable')), findsOneWidget);
        expect(find.text(l10n.legalNotPublished), findsOneWidget);
        expect(find.byKey(const Key('legal_retry')), findsNothing);
        expect(barTitle(tester), l10n.profileTermsConditions);
        expect(
          Directionality.of(tester.element(find.text(l10n.legalNotPublished))),
          direction,
        );
      });

      viewerTest('a 200 with no text is not a document: "not published yet"', (
        tester,
      ) async {
        final repo = ScriptedLegalRepository([
          fixtureDocument(LegalDocument.terms, language, markdown: '  \n'),
        ]);
        await pumpViewer(tester, repo, language: language);
        await tester.pumpAndSettle();

        expect(find.text(l10n.legalNotPublished), findsOneWidget);
        expect(barTitle(tester), l10n.profileTermsConditions);
      });

      viewerTest('offline: the offline line, and Retry asks again', (
        tester,
      ) async {
        final repo = ScriptedLegalRepository([
          const NetworkException(detail: 'connection error'),
          fixtureDocument(LegalDocument.terms, language),
        ]);
        await pumpViewer(tester, repo, language: language);
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('legal_offline')), findsOneWidget);
        expect(find.text(l10n.offline), findsOneWidget);
        expect(repo.calls, hasLength(1));

        await tester.tap(find.byKey(const Key('legal_retry')));
        await tester.pumpAndSettle();
        expect(repo.calls, hasLength(2));
        expect(block(fixtureTitle), findsOneWidget);
      });

      viewerTest('429: the rate-limit line (with Retry-After), and Retry', (
        tester,
      ) async {
        final repo = ScriptedLegalRepository([
          const RateLimitedException(retryAfter: Duration(seconds: 30)),
        ]);
        await pumpViewer(tester, repo, language: language);
        await tester.pumpAndSettle();

        expect(find.text(l10n.rateLimitedIn(30)), findsOneWidget);
        expect(find.byKey(const Key('legal_retry')), findsOneWidget);
      });

      viewerTest('429 without Retry-After: the plain rate-limit line', (
        tester,
      ) async {
        final repo = ScriptedLegalRepository([const RateLimitedException()]);
        await pumpViewer(tester, repo, language: language);
        await tester.pumpAndSettle();

        expect(find.text(l10n.rateLimited), findsOneWidget);
      });

      viewerTest('any other failure: "Something went wrong" and Retry', (
        tester,
      ) async {
        final repo = ScriptedLegalRepository([
          const ApiException(status: 500, code: 'internal_error'),
          fixtureDocument(LegalDocument.terms, language),
        ]);
        await pumpViewer(tester, repo, language: language);
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('legal_error')), findsOneWidget);
        expect(find.text(l10n.genericError), findsOneWidget);
        await tester.tap(find.byKey(const Key('legal_retry')));
        await tester.pumpAndSettle();
        expect(block(fixtureTitle), findsOneWidget);
      });
    });
  }

  group('failures are told apart', () {
    final l10n = lookupAppLocalizations(const Locale('en'));

    final generic = <String, Object>{
      '404 not_found (not the legal code)': const ApiException(
        status: 404,
        code: 'not_found',
      ),
      '400 validation_failed': const ValidationException(
        errors: {
          'language': ['bad'],
        },
      ),
      'a body that broke the contract': const UnknownException(
        detail: 'parse: TypeError',
      ),
    };
    for (final MapEntry(key: label, value: error) in generic.entries) {
      viewerTest('$label → generic, with Retry', (tester) async {
        await pumpViewer(tester, ScriptedLegalRepository([error]));
        await tester.pumpAndSettle();

        expect(find.text(l10n.genericError), findsOneWidget);
        expect(find.text(l10n.legalNotPublished), findsNothing);
        expect(find.byKey(const Key('legal_retry')), findsOneWidget);
      });
    }

    viewerTest('Retry shows the loading state while it asks again, not the old '
        'failure', (tester) async {
      final again = Completer<LegalDocumentContent>();
      final repo = ScriptedLegalRepository([
        const NetworkException(detail: 'timeout'),
        again,
      ]);
      await pumpViewer(tester, repo);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('legal_offline')), findsOneWidget);

      await tester.tap(find.byKey(const Key('legal_retry')));
      await tester.pump();

      expect(repo.calls, hasLength(2));
      expect(find.byKey(const Key('legal_loading')), findsOneWidget);
      expect(find.byKey(const Key('legal_offline')), findsNothing);
      expect(find.byKey(const Key('legal_retry')), findsNothing);

      again.complete(fixtureDocument(LegalDocument.terms, 'en'));
      await tester.pumpAndSettle();
      expect(block(fixtureTitle), findsOneWidget);
    });

    viewerTest('nothing is retried on its own', (tester) async {
      final repo = ScriptedLegalRepository([
        const ApiException(status: 503, code: 'unknown'),
      ]);
      await pumpViewer(tester, repo);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(minutes: 2));

      expect(repo.calls, hasLength(1));
    });
  });

  group('language and document', () {
    viewerTest('switching the language while open fetches the other one', (
      tester,
    ) async {
      final repo = ScriptedLegalRepository([
        fixtureDocument(LegalDocument.terms, 'en'),
      ]);
      final container = await pumpViewer(tester, repo);
      await tester.pumpAndSettle();
      expect(repo.calls.single.language, 'en');

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: app(document: LegalDocument.terms, language: 'ar'),
        ),
      );
      await tester.pumpAndSettle();

      expect(repo.calls.map((c) => c.language), ['en', 'ar']);
      expect(
        Directionality.of(tester.element(block(fixtureTitle))),
        TextDirection.rtl,
      );
    });

    for (final document in LegalDocument.values) {
      viewerTest('${document.name}: asks for it, and its bar title names it', (
        tester,
      ) async {
        final l10n = lookupAppLocalizations(const Locale('en'));
        final repo = ScriptedLegalRepository([
          Completer<LegalDocumentContent>(),
        ]);
        await pumpViewer(tester, repo, document: document);

        expect(repo.calls.single.document, document);
        expect(
          barTitle(tester),
          document == LegalDocument.privacy
              ? l10n.profilePrivacyPolicy
              : l10n.profileTermsConditions,
        );
      });
    }
  });

  group('rendering the served Markdown', () {
    Future<void> showMarkdown(
      WidgetTester tester,
      String markdown, {
      String language = 'en',
      ThemeData? theme,
    }) async {
      await pumpViewer(
        tester,
        ScriptedLegalRepository([
          fixtureDocument(LegalDocument.terms, language, markdown: markdown),
        ]),
        language: language,
        theme: theme,
        size: const Size(400, 2000),
      );
      await tester.pumpAndSettle();
    }

    viewerTest('a soft line break is a space, even inside bold', (
      tester,
    ) async {
      await showMarkdown(tester, fixtureMarkdown);

      final paragraph = tester.widget<RichText>(block(fixtureBlocks[1]));
      final spans = <TextSpan>[];
      paragraph.text.visitChildren((span) {
        if (span is TextSpan && span.text != null) spans.add(span);
        return true;
      });
      final bold = spans.singleWhere(
        (s) => s.text == 'bold that also crosses the break',
      );
      expect(bold.style?.fontWeight, FontWeight.w500);
    });

    viewerTest('headings are announced as headings; the title names the '
        'screen', (tester) async {
      final handle = tester.ensureSemantics();
      await showMarkdown(tester, fixtureMarkdown);

      expect(
        tester.getSemantics(find.text(fixtureTitle)),
        isSemantics(label: fixtureTitle, isHeader: true, namesRoute: true),
      );
      expect(
        tester.getSemantics(find.text('1. First section')),
        isSemantics(label: '1. First section', isHeader: true),
      );
      handle.dispose();
    });

    for (final language in ['en', 'ar']) {
      viewerTest('$language: table columns and cells follow the reading '
          'direction', (tester) async {
        await showMarkdown(tester, fixtureMarkdown, language: language);

        final a = tester.getCenter(block('Head A')).dx;
        final b = tester.getCenter(block('Head B')).dx;
        expect(language == 'ar' ? a > b : a < b, isTrue);
        for (final cell in ['Head A', 'Cell A1', 'Cell B2']) {
          expect(
            tester.widget<RichText>(block(cell)).textAlign,
            TextAlign.start,
            reason: cell,
          );
        }
        // List markers, numbered by the package from 1.
        expect(find.text('1.'), findsOneWidget);
        expect(find.text('2.'), findsOneWidget);
        expect(find.text('•'), findsNWidgets(3));
      });
    }

    for (final (name, theme, ext) in [
      ('light', AppTheme.light, AppColors.light),
      ('dark', AppTheme.dark, AppColors.dark),
    ]) {
      viewerTest('$name: theme colours only', (tester) async {
        await showMarkdown(tester, fixtureMarkdown, theme: theme);

        expect(
          tester.widget<Text>(find.text(fixtureTitle)).style?.color,
          ext.textPrimary,
        );
        // The span the Markdown built, not the default style `Text.rich`
        // wraps around it.
        Color? spanColor(String text) {
          Color? colour;
          tester.widget<RichText>(block(text)).text.visitChildren((span) {
            if (span is TextSpan && span.text == text) {
              colour = span.style?.color;
              return false;
            }
            return true;
          });
          return colour;
        }

        expect(spanColor('Bullet alpha'), ext.textSecondary);
        expect(spanColor('Cell A1'), ext.textSecondary);
        final table = tester.widget<Table>(find.byType(Table));
        expect(table.border?.top.color, theme.colorScheme.outlineVariant);
      });
    }

    viewerTest('raw HTML is shown as its characters, never interpreted or '
        'dropped', (tester) async {
      await showMarkdown(
        tester,
        'Before <b>inline</b> after.\n\n<script>alert(1)</script>\n\n'
        '<div>A block</div>\n\nEnd.',
      );

      expect(block('Before <b>inline</b> after.'), findsOneWidget);
      expect(block('<script>alert(1)</script>'), findsOneWidget);
      expect(block('<div>A block</div>'), findsOneWidget);
      expect(block('End.'), findsOneWidget);
    });

    viewerTest('a malformed table does not take the document down: it reads '
        'as text', (tester) async {
      await showMarkdown(
        tester,
        'Intro line\n| a | b | c |\n|---|---|\n| 1 | 2 | 3 |\n\n'
        'Effective date\n---|---\nbody\n\nLast line.',
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(Table), findsNothing);
      expect(find.textContaining('Intro line', findRichText: true), findsOne);
      expect(
        find.textContaining('| a | b | c |', findRichText: true),
        findsOne,
      );
      expect(
        find.textContaining('Effective date', findRichText: true),
        findsOne,
      );
      expect(block('Last line.'), findsOneWidget);
    });

    viewerTest('a footnote mark in a heading does not take the document '
        'down; the heading and the note keep their words', (tester) async {
      await showMarkdown(
        tester,
        '## Data we keep[^1]\n\nBody.\n\n[^1]: The note words.',
      );

      expect(tester.takeException(), isNull);
      expect(find.textContaining('Data we keep'), findsOneWidget);
      expect(block('Body.'), findsOneWidget);
      expect(
        find.textContaining('The note words.', findRichText: true),
        findsOneWidget,
      );
    });

    viewerTest('alt text survives in a heading and when the address does not '
        'parse', (tester) async {
      await showMarkdown(
        tester,
        '# ![Alt heading](x.png)\n\n'
        '## Intro ![alt words](a.png) end\n\n'
        'Before ![Alt two](http://[::1) after.',
      );

      expect(find.byType(Image), findsNothing);
      expect(find.text('Alt heading'), findsOneWidget);
      expect(find.text('Intro alt words end'), findsOneWidget);
      expect(
        find.textContaining('Alt two', findRichText: true),
        findsOneWidget,
      );
    });

    for (final language in ['en', 'ar']) {
      for (final scale in [1.15, 2.0]) {
        viewerTest('$language · $scale×: a two-digit list number stays on '
            'one line', (tester) async {
          await pumpViewer(
            tester,
            ScriptedLegalRepository([
              fixtureDocument(
                LegalDocument.terms,
                language,
                markdown: [
                  for (var i = 1; i <= 12; i++) '$i. Item number $i',
                ].join('\n'),
              ),
            ]),
            language: language,
            textScale: scale,
            size: const Size(360, 3000),
          );
          await tester.pumpAndSettle();

          final one = tester.getSize(find.text('1.')).height;
          for (final marker in ['10.', '11.', '12.']) {
            expect(tester.getSize(find.text(marker)).height, one);
            // …and it fits its column: nothing is painted past the edge.
            final paragraph = tester.renderObject<RenderParagraph>(
              find.text(marker),
            );
            expect(
              paragraph.getMaxIntrinsicWidth(double.infinity),
              lessThanOrEqualTo(paragraph.size.width + 0.5),
              reason: marker,
            );
          }
          expect(tester.takeException(), isNull);
        });
      }

      viewerTest('$language · 2.0×: a three-digit list number is never split '
          'over two lines', (tester) async {
        await pumpViewer(
          tester,
          ScriptedLegalRepository([
            fixtureDocument(
              LegalDocument.terms,
              language,
              markdown: '99. Item ninety-nine\n100. Item one hundred',
            ),
          ]),
          language: language,
          textScale: 2,
          size: const Size(360, 1200),
        );
        await tester.pumpAndSettle();

        expect(
          tester.getSize(find.text('100.')).height,
          tester.getSize(find.text('99.')).height,
        );
        expect(tester.takeException(), isNull);
      });
    }

    viewerTest('an image is never loaded; its alt text stands in', (
      tester,
    ) async {
      await showMarkdown(
        tester,
        'Text ![Alt words](https://levelup.test/a.png) more.\n\n'
        '![](file:///etc/hosts)',
      );

      expect(find.byType(Image), findsNothing);
      // Set in the line, where the image was.
      expect(block('Text Alt words more.'), findsOneWidget);
    });

    viewerTest('links: only https and mailto open, outside the app', (
      tester,
    ) async {
      const links = {
        'Https link': 'https://levelup.test/terms',
        'Mail link': 'mailto:privacy@levelup.test',
        'Plain http': 'http://levelup.test/x',
        'Script': 'javascript:alert(1)',
        'File': 'file:///etc/hosts',
        'Relative': '/legal/terms',
        'Intent': 'intent://levelup.test#Intent;end',
      };
      await showMarkdown(
        tester,
        links.entries.map((e) => '[${e.key}](${e.value})').join('\n\n'),
      );

      for (final label in links.keys) {
        await tester.tap(block(label));
        await tester.pump();
      }
      expect(opened, [
        Uri.parse('https://levelup.test/terms'),
        Uri.parse('mailto:privacy@levelup.test'),
      ]);
    });

    viewerTest('nothing on the document is a control but the back chip', (
      tester,
    ) async {
      await showMarkdown(tester, fixtureMarkdown);

      expect(find.byType(InkWell), findsOneWidget);
      for (final type in [
        FilledButton,
        TextButton,
        ElevatedButton,
        OutlinedButton,
      ]) {
        expect(find.byType(type), findsNothing, reason: '$type');
      }
    });
  });

  group('at 2.0× text on a 320 dp phone, with the real fonts', () {
    for (final language in ['en', 'ar']) {
      viewerTest('$language: the document scrolls to its last cell without '
          'overflowing', (tester) async {
        await pumpViewer(
          tester,
          ScriptedLegalRepository([
            fixtureDocument(LegalDocument.privacy, language),
          ]),
          document: LegalDocument.privacy,
          language: language,
          textScale: 2,
          size: const Size(320, 640),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        await tester.scrollUntilVisible(
          block('Cell B2'),
          200,
          scrollable: find.descendant(
            of: find.byKey(const Key('legal_body')),
            matching: find.byType(Scrollable),
          ),
        );
        expect(block('Cell B2').hitTestable(), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      viewerTest('$language: a failure state does not overflow either', (
        tester,
      ) async {
        await pumpViewer(
          tester,
          ScriptedLegalRepository([
            const RateLimitedException(retryAfter: Duration(seconds: 30)),
          ]),
          language: language,
          textScale: 2,
          size: const Size(320, 480),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.byKey(const Key('legal_retry')), findsOneWidget);
      });
    }
  });
}
