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
}
