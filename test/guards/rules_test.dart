import 'package:flutter_test/flutter_test.dart';

import 'rules.dart';

/// Tests for the guards themselves.
///
/// A guard that has only ever run against a clean codebase has never
/// demonstrated that it can fail. These feed each detector a hand-written
/// violation and assert it is caught, then feed it a comment that merely
/// *mentions* the violation and assert it is not.
///
/// That second half is the whole reason this file exists. In Wave 1 the
/// session-scope guard matched provider names with a substring search over a
/// file whose doc comment listed those providers — so prose satisfied a rule
/// about behaviour, and the guard reported four providers as cleared when none
/// of them was. It reached the right verdict by luck. Every rule below is
/// therefore tested against a comment-only version of its own violation.
Source src(String text, {String path = 'lib/features/x/x.dart'}) =>
    (path: path, text: text);

void main() {
  group('stripComments — the primitive everything else depends on', () {
    test('removes line comments', () {
      expect(stripComments('a(); // b();').trim(), 'a();');
    });

    test('removes doc comments', () {
      expect(stripComments('/// b();\na();').trim(), 'a();');
    });

    test('removes block comments, including multi-line', () {
      expect(stripComments('a();/* b();\nc(); */d();').trim(), 'a();d();');
    });

    test('leaves real code alone', () {
      expect(stripComments('final x = 1;'), 'final x = 1;');
    });
  });

  group('bloc containment', () {
    test('flags flutter_bloc outside the quiz feature', () {
      final v = blocOutsideQuiz([
        src(
          "import 'package:flutter_bloc/flutter_bloc.dart';",
          path: 'lib/features/home/home_bloc.dart',
        ),
      ]);
      expect(v, ['lib/features/home/home_bloc.dart']);
    });

    test('allows flutter_bloc inside the quiz feature', () {
      final v = blocOutsideQuiz([
        src(
          "import 'package:flutter_bloc/flutter_bloc.dart';",
          path: 'lib/features/quiz/bloc/quiz_bloc.dart',
        ),
      ]);
      expect(v, isEmpty);
    });

    test('a COMMENT mentioning flutter_bloc is not a violation', () {
      final v = blocOutsideQuiz([
        src(
          '// we deliberately do not use package:flutter_bloc here',
          path: 'lib/features/home/home_notifier.dart',
        ),
      ]);
      expect(v, isEmpty, reason: 'prose must not trip a structural rule');
    });
  });

  group('provider mutation in initState (the BUG-001 guard)', () {
    test('flags a bare notifier write', () {
      final v = providerMutationInInitState([
        src('''
void initState() {
  super.initState();
  ref.read(registrationControllerProvider.notifier).start(args);
}'''),
      ]);
      expect(v, isNotEmpty);
    });

    test('allows a write deferred to after the frame', () {
      final v = providerMutationInInitState([
        src('''
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ref.read(someProvider.notifier).start();
  });
}'''),
      ]);
      expect(v, isEmpty, reason: 'addPostFrameCallback is the documented fix');
    });

    test('allows initState that only READS a provider', () {
      final v = providerMutationInInitState([
        src('''
void initState() {
  super.initState();
  final draft = ref.read(registrationControllerProvider);
}'''),
      ]);
      expect(v, isEmpty, reason: 'reading in initState is legal');
    });

    test('a COMMENT describing the violation is not a violation', () {
      final v = providerMutationInInitState([
        src('''
void initState() {
  super.initState();
  // never call ref.read(x.notifier).start() here — see BUG-001
}'''),
      ]);
      expect(v, isEmpty);
    });

    test('nested braces do not truncate the body scan', () {
      final v = providerMutationInInitState([
        src('''
void initState() {
  super.initState();
  if (a) { if (b) { c(); } }
  ref.read(p.notifier).go();
}'''),
      ]);
      expect(v, isNotEmpty, reason: 'brace matching must span nested blocks');
    });
  });

  group('raw Text literals', () {
    test('flags a hardcoded string', () {
      expect(rawTextLiterals([src("Text('Retry')")]), isNotEmpty);
    });

    test('does not flag a localized call', () {
      expect(rawTextLiterals([src('Text(l10n.retry)')]), isEmpty);
    });

    test('respects the allowlist', () {
      final v = rawTextLiterals(
        [src("Text('🇪🇬')", path: 'lib/a.dart')],
        allow: {'lib/a.dart:1'},
      );
      expect(v, isEmpty);
    });

    test('a COMMENT containing Text(\'..\') is not a violation', () {
      expect(rawTextLiterals([src("// avoid Text('hardcoded')")]), isEmpty);
    });
  });

  group('hardcoded fontSize ratchet', () {
    test('counts real occurrences', () {
      expect(hardcodedFontSizeCount([src('TextStyle(fontSize: 14)')]), 1);
    });

    test('does not count a themed lookup', () {
      expect(
        hardcodedFontSizeCount([src('TextStyle(fontSize: t.bodySize)')]),
        0,
      );
    });

    test('does not count a commented example', () {
      expect(hardcodedFontSizeCount([src('// TextStyle(fontSize: 14)')]), 0);
    });
  });

  group('raw elevation effects', () {
    test('flags a BoxShadow at a call site', () {
      expect(
        rawElevationEffects([src('BoxShadow(blurRadius: 1)')]),
        isNotEmpty,
      );
    });

    test('flags a non-zero elevation, including a ternary', () {
      expect(
        rawElevationEffects([src('elevation: selected ? 0 : 2,')]),
        isNotEmpty,
        reason:
            'a "non-zero literal" check would read the 0 and pass; this is '
            'the exact expression shipped in quiz_review_screen.dart',
      );
    });

    test('flags shadowColor', () {
      expect(
        rawElevationEffects([src('shadowColor: ext.elevationShadow,')]),
        isNotEmpty,
      );
    });

    test('flags the blur and backdrop primitives', () {
      for (final line in [
        'MaskFilter.blur(BlurStyle.normal, 2)',
        'ImageFilter.blur(sigmaX: 4, sigmaY: 4)',
        'BackdropFilter(filter: f, child: c)',
        'PhysicalModel(color: c, child: x)',
      ]) {
        expect(
          rawElevationEffects([src(line)]),
          isNotEmpty,
          reason: 'not caught: $line',
        );
      }
    });

    test('does NOT flag elevation: 0 — flat is the state this rule wants', () {
      expect(rawElevationEffects([src('elevation: 0,')]), isEmpty);
      expect(rawElevationEffects([src('elevation: 0.0)')]), isEmpty);
    });

    test('a COMMENT describing a BoxShadow is not a violation', () {
      expect(
        rawElevationEffects([src('// never write BoxShadow( here')]),
        isEmpty,
        reason: 'prose must not trip a structural rule',
      );
    });

    test('both design-system folders are exempt', () {
      expect(
        rawElevationEffects([
          src('BoxShadow(', path: 'lib/core/theme/app_elevation.dart'),
          src(
            'MaskFilter.blur(BlurStyle.normal, 2)',
            path: 'lib/core/widgets/elevation/glass_surface.dart',
          ),
        ]),
        isEmpty,
        reason:
            'the tokens and the one painter that consumes them are where '
            'this code is SUPPOSED to live',
      );
    });

    test('reports path:line so a failure names the site', () {
      final v = rawElevationEffects([
        src('final a = 1;\nBoxShadow(', path: 'lib/a.dart'),
      ]);
      expect(v, ['lib/a.dart:2']);
    });
  });

  group('ARB key drift', () {
    test('detects a key missing from Arabic', () {
      final d = arbKeyDrift('{"a":"A","b":"B"}', '{"a":"أ"}');
      expect(d.missingInAr, {'b'});
      expect(d.extraInAr, isEmpty);
    });

    test('detects an orphan Arabic key', () {
      final d = arbKeyDrift('{"a":"A"}', '{"a":"أ","z":"ز"}');
      expect(d.extraInAr, {'z'});
    });

    test('ignores @-metadata entries', () {
      final d = arbKeyDrift('{"a":"A","@a":{"x":"y"}}', '{"a":"أ"}');
      expect(d.missingInAr, isEmpty);
    });

    test('agrees when both sides match', () {
      final d = arbKeyDrift('{"a":"A"}', '{"a":"أ"}');
      expect(d.missingInAr, isEmpty);
      expect(d.extraInAr, isEmpty);
    });
  });

  group('contract required-field extraction', () {
    // A miniature of the real document's shape: two nesting depths, a flow
    // `required` at each, and a nested object whose own `required` sits deeper.
    const yaml = '''
openapi: 3.1.0
components:
  schemas:
    Widget:
      type: object
      properties:
        id: { type: string }
        nested:
          type: object
          properties:
            deep: { type: string }
          required: [deep]
      required: [id, nested]
    Other:
      type: object
      required: [z]
''';

    test('reads a top-level required list', () {
      expect(contractRequiredFields(yaml, ['Widget']), ['id', 'nested']);
    });

    test('reads a NESTED required list, not the outer one', () {
      expect(contractRequiredFields(yaml, ['Widget', 'properties', 'nested']), [
        'deep',
      ]);
    });

    test('does not leak into the next schema', () {
      expect(contractRequiredFields(yaml, ['Other']), ['z']);
    });

    test('raises — never returns empty — when the schema is absent', () {
      // The failure mode that would make every binding pass vacuously.
      expect(
        () => contractRequiredFields(yaml, ['NoSuchSchema']),
        throwsA(isA<ContractShapeException>()),
      );
    });

    test('raises when the block has no required list', () {
      const noRequired = '''
components:
  schemas:
    Bare:
      type: object
      properties:
        a: { type: string }
''';
      expect(
        () => contractRequiredFields(noRequired, ['Bare']),
        throwsA(isA<ContractShapeException>()),
      );
    });

    test('raises on a block-style required list, never reads it as empty', () {
      const blockStyle = '''
components:
  schemas:
    Bare:
      type: object
      required:
        - a
''';
      expect(
        () => contractRequiredFields(blockStyle, ['Bare']),
        throwsA(isA<ContractShapeException>()),
      );
    });
  });

  group('Dart field declaration', () {
    test('detects a declared constructor parameter', () {
      expect(
        dartDeclaresField(
          'const factory X({required bool hasFlashcards}) = _X;',
          'hasFlashcards',
        ),
        isTrue,
      );
    });

    test('detects one followed by a trailing comma', () {
      expect(
        dartDeclaresField(
          'const factory X({\n  required bool hasFlashcards,\n}) = _X;',
          'hasFlashcards',
        ),
        isTrue,
      );
    });

    test('a doc comment mentioning the field does NOT count', () {
      // The lesson this whole file exists for: prose must never satisfy a rule
      // about behaviour. A comment explaining why a field is unmodelled is the
      // likeliest thing to be sitting right next to a missing field.
      expect(
        dartDeclaresField(
          '/// TODO: hasFlashcards, not modelled yet.\n'
              'const factory X({required String id}) = _X;',
          'hasFlashcards',
        ),
        isFalse,
      );
    });

    test('a JSON key read in a hand-written parser does NOT count', () {
      expect(
        dartDeclaresField(
          "X.fromJson(Map j) => X(id: j['hasFlashcards'] as String);",
          'hasFlashcards',
        ),
        isFalse,
      );
    });

    test('reports a genuinely missing field', () {
      expect(
        dartDeclaresField(
          'const factory X({required String id}) = _X;',
          'hasFlashcards',
        ),
        isFalse,
      );
    });
  });

  group('Dart class scoping', () {
    /// Two freezed models in one file, each with an `id` — the exact shape that
    /// made file-scoped detection maskable across this repo's model files.
    const twoModels = '''
@freezed
abstract class Alpha with _\$Alpha {
  const factory Alpha({required String id, required String alphaOnly}) = _Alpha;
}

@freezed
abstract class Beta with _\$Beta {
  const factory Beta({required String id, required String betaOnly}) = _Beta;
}
''';

    test('returns only the named class body', () {
      final alpha = dartClassBody(twoModels, 'Alpha')!;

      expect(alpha, contains('alphaOnly'));
      expect(alpha, isNot(contains('betaOnly')));
    });

    test('🔴 THE POINT — a sibling class no longer answers for this one', () {
      // File-scoped, both of these were true. That is the masking: `Beta`'s
      // parameter satisfying a binding that names `Alpha`.
      expect(
        dartDeclaresField(twoModels, 'betaOnly'),
        isTrue,
        reason: 'file scope still sees it — this is what we are narrowing',
      );
      expect(
        dartDeclaresField(dartClassBody(twoModels, 'Alpha')!, 'betaOnly'),
        isFalse,
        reason: 'class scope must not',
      );
    });

    test('the field each class DOES declare still resolves', () {
      // Narrowing must not overshoot into false positives: the guard failing on
      // a correctly-modelled field would get it switched off.
      expect(
        dartDeclaresField(dartClassBody(twoModels, 'Alpha')!, 'id'),
        isTrue,
      );
      expect(
        dartDeclaresField(dartClassBody(twoModels, 'Beta')!, 'betaOnly'),
        isTrue,
      );
    });

    test('an unknown class is null, NOT the whole file', () {
      // The fail-loud contract. Falling back to the file here would silently
      // restore file scope for a binding whose model was renamed.
      expect(dartClassBody(twoModels, 'Gamma'), isNull);
    });

    test('a brace inside a doc comment does not unbalance the body', () {
      const withComment = '''
/// Shaped like {id, name} on the wire.
abstract class Alpha with _\$Alpha {
  const factory Alpha({required String id}) = _Alpha;
}
abstract class Beta with _\$Beta {
  const factory Beta({required String betaOnly}) = _Beta;
}
''';
      final alpha = dartClassBody(withComment, 'Alpha')!;

      expect(dartDeclaresField(alpha, 'id'), isTrue);
      expect(dartDeclaresField(alpha, 'betaOnly'), isFalse);
    });

    test('`sealed` and `abstract` classes are found', () {
      expect(dartClassBody('sealed class S { const S(); }', 'S'), isNotNull);
      expect(dartClassBody('abstract class A { const A(); }', 'A'), isNotNull);
    });

    test('a prefix name does not match — `Profile` is not `ProfileSchool`', () {
      // `\\b` on the trailing side matters: two bindings in the real table are
      // `ProfileSchool` and `ProfilePoints`, and a prefix match would hand the
      // wrong body to whichever came first in the file.
      const src = 'class ProfileSchool { const ProfileSchool({this.stage}); }';

      expect(dartClassBody(src, 'ProfileSchool'), isNotNull);
      expect(dartClassBody(src, 'Profile'), isNull);
    });

    test('an enum is not a class', () {
      // Enums declare no constructor parameters, so a contract field can never
      // bind to one; matching them would only produce confusing bodies.
      expect(dartClassBody('enum Grade { gotIt, again }', 'Grade'), isNull);
    });
  });

  group('mirror-glyph swaps (the RTL double flip)', () {
    test('flags the helper Wave 07 removed, across lines', () {
      final v = mirroredGlyphSwaps([
        src('''
IconData forwardChevron(BuildContext context) =>
    Directionality.of(context) == TextDirection.rtl
    ? Icons.chevron_left
    : Icons.chevron_right;
'''),
      ]);
      expect(v, [
        'lib/features/x/x.dart: Icons.chevron_left / Icons.chevron_right',
      ]);
    });

    test('flags any condition and the back-arrow pair, in either order', () {
      final v = mirroredGlyphSwaps([
        src(
          'final i = rtl ? Icons.arrow_forward_ios : Icons.arrow_back_ios_new;',
        ),
      ]);
      expect(v, hasLength(1));
    });

    test('allows the unconditional LTR glyph', () {
      final v = mirroredGlyphSwaps([
        src('const IconData forwardChevron = Icons.chevron_right;'),
      ]);
      expect(v, isEmpty);
    });

    test('allows a conditional between unrelated glyphs', () {
      final v = mirroredGlyphSwaps([
        src('Icon(hidden ? Icons.visibility : Icons.visibility_off)'),
      ]);
      expect(v, isEmpty);
    });

    test('a COMMENT showing the old helper is not a violation', () {
      final v = mirroredGlyphSwaps([
        src('// was: rtl ? Icons.chevron_left : Icons.chevron_right'),
      ]);
      expect(v, isEmpty, reason: 'prose must not trip a structural rule');
    });
  });
}
