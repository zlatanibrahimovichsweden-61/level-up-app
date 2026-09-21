/// Pure detection logic for the project's mechanically-enforced rules.
///
/// Every function here takes source text and returns violations. Nothing reads
/// the filesystem except [libSources], and nothing calls `expect`. That
/// separation is the whole point: `rules_test.dart` feeds these functions
/// hand-written fixtures to prove they actually detect a violation and actually
/// ignore a comment, and `project_rules_test.dart` feeds them the real
/// repository. A guard that is only ever run against a clean codebase has never
/// demonstrated that it can fail.
///
/// The lesson this design encodes came from Wave 1: the first session-scope
/// guard matched provider names with a substring search over a file that named
/// those providers in its own doc comment, so prose satisfied a rule about
/// behaviour. Every check here strips comments first.
library;

import 'dart:convert';
import 'dart:io';

/// A file's path and contents. A record so fixtures are one line to write.
typedef Source = ({String path, String text});

/// Removes block and line comments.
///
/// **The most important function in this file.** Any rule that greps raw source
/// can be satisfied by someone merely *writing about* the thing it looks for.
///
/// Known limitation, stated rather than hidden: a `//` or `/*` sequence inside
/// a string literal is treated as a comment. That would matter for a rule about
/// string contents; none of the rules here are, and the alternative is a real
/// Dart parser for a handful of regexes.
String stripComments(String source) => source
    .replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), '')
    .replaceAll(RegExp('//.*'), '');

/// Hand-written Dart under `lib/`. Generated output is never a violation of a
/// hand-written-code rule.
List<Source> libSources({String root = 'lib'}) {
  return Directory(root)
      .listSync(recursive: true)
      .whereType<File>()
      .map((f) => f.path.replaceAll(r'\', '/'))
      .where((p) => p.endsWith('.dart'))
      .where((p) => !p.endsWith('.g.dart'))
      .where((p) => !p.endsWith('.freezed.dart'))
      .where((p) => !p.contains('/l10n/app_localizations'))
      .map<Source>((p) => (path: p, text: File(p).readAsStringSync()))
      .toList();
}

/// The body of the first `{...}` block starting at or after [from], brace
/// matched. Returns null if unbalanced.
String? _blockAfter(String s, int from) {
  final open = s.indexOf('{', from);
  if (open < 0) return null;
  var depth = 0;
  for (var i = open; i < s.length; i++) {
    if (s[i] == '{') depth++;
    if (s[i] == '}') {
      depth--;
      if (depth == 0) return s.substring(open + 1, i);
    }
  }
  return null;
}

// ---------------------------------------------------------------------------
// RULE: Bloc is confined to the quiz feature.
// ---------------------------------------------------------------------------

/// `package:flutter_bloc` imported outside `lib/features/quiz/`.
///
/// The project rule (`State_Management.md`, `.claude/skills/bloc/SKILL.md`) is
/// that Riverpod is the app's state management and Bloc exists *only* for the
/// quiz engine, because that is the one place with three concurrent async
/// sources. A third pattern arriving by drift is how a codebase ends up with
/// three ways to do one thing.
List<String> blocOutsideQuiz(List<Source> sources) => [
  for (final s in sources)
    if (stripComments(s.text).contains('package:flutter_bloc') &&
        !s.path.contains('/features/quiz/'))
      s.path,
];

// ---------------------------------------------------------------------------
// RULE: no provider mutation during widget build (the literal BUG-001 guard).
// ---------------------------------------------------------------------------

/// `initState` bodies that mutate a Riverpod provider without deferring.
///
/// This is BUG-001 as a test. Writing to a provider inside `initState` runs
/// during element mount, which is part of the build phase, and Riverpod asserts
/// on it — red-screening the whole registration wizard on a real device while
/// 216 widget tests stayed green, because a direct-pump test mounts during the
/// INITIAL build where the guard flag is not set. Only router-driven navigation
/// reaches it.
///
/// A `.notifier` read is only a violation if the body does not also defer via
/// `addPostFrameCallback` — reading a provider in `initState` is legal, and
/// scheduling a write for after the frame is the documented fix.
List<String> providerMutationInInitState(List<Source> sources) {
  final out = <String>[];
  for (final s in sources) {
    final code = stripComments(s.text);
    for (final m in RegExp(r'void\s+initState\s*\(\s*\)').allMatches(code)) {
      final body = _blockAfter(code, m.end);
      if (body == null) continue;
      if (body.contains('.notifier') &&
          !body.contains('addPostFrameCallback')) {
        out.add(s.path);
      }
    }
  }
  return out;
}

// ---------------------------------------------------------------------------
// RULE: autoDispose notifiers that await must track their own disposal.
// ---------------------------------------------------------------------------

/// Files declaring an `autoDispose` notifier that `await`s but has no disposal
/// flag wired to `ref.onDispose`.
///
/// An `autoDispose` provider is disposed the moment its last listener goes.
/// If that happens while an `await` is in flight — the student pops the OTP
/// screen mid-verify, closes the school picker mid-page, leaves Edit Profile
/// mid-save — the continuation resumes and assigns to `state` on a dead
/// notifier, which throws. It surfaces as an unhandled async error rather than
/// a crash, which is why a green suite never saw it.
///
/// Deliberately NOT applied to non-`autoDispose` providers: those live for the
/// container's lifetime and cannot be disposed mid-await, so a guard there
/// would be cargo-culting. Wave-3 finding K-13 named "9 sites"; only the
/// `autoDispose` ones are real.
///
/// The check is structural, not a proof: it asserts the *mechanism* exists, not
/// that every assignment is guarded. A reviewer still has to place the guard
/// after any side effect that must survive disposal — in `OtpNotifier.verify`
/// the tokens and `markAuthenticated()` must happen regardless.
List<String> autoDisposeNotifiersWithoutDisposalFlag(List<Source> sources) {
  final out = <String>[];
  for (final s in sources) {
    final code = stripComments(s.text);
    if (!code.contains('autoDispose')) continue;
    if (!RegExp(r'\bawait\b').hasMatch(code)) continue;
    // Must both declare the flag and set it from onDispose.
    final declares = RegExp(r'bool\s+_disposed\s*=\s*false').hasMatch(code);
    final wires = RegExp(
      r'onDispose\([\s\S]{0,120}?_disposed\s*=\s*true',
    ).hasMatch(code);
    if (!declares || !wires) out.add(s.path);
  }
  return out;
}

// ---------------------------------------------------------------------------
// RULE: user-facing copy goes through AppLocalizations.
// ---------------------------------------------------------------------------

/// `Text('literal')` / `Text("literal")` outside the allowlist.
///
/// Arabic is this project's baseline locale, not an edge case, so a hardcoded
/// English string is a bug in half the product. Some literals are legitimately
/// untranslatable — a flag emoji, a punctuation joiner between two localized
/// halves — so the rule is an allowlist of `path:line`, not a ban.
List<String> rawTextLiterals(
  List<Source> sources, {
  Set<String> allow = const {},
}) {
  final out = <String>[];
  // Capture the WHOLE literal, not just its opening quote, so its content can
  // be judged. Single- and double-quoted are separate patterns rather than one
  // with a backreference: clearer, and it cannot mis-pair the delimiters.
  final quoted = [
    RegExp(r"""Text\(\s*'((?:\\.|[^'])*)'"""),
    RegExp(r'''Text\(\s*"((?:\\.|[^"])*)"'''),
  ];
  // `${...}` and bare `$identifier`.
  final interpolation = RegExp(r'\$\{[^}]*\}|\$[A-Za-z_][A-Za-z0-9_]*');

  for (final s in sources) {
    final lines = stripComments(s.text).split('\n');
    for (var i = 0; i < lines.length; i++) {
      for (final p in quoted) {
        final m = p.firstMatch(lines[i]);
        if (m == null) continue;
        // A literal made ENTIRELY of interpolation has nothing to translate.
        // `Text('$value')` renders a number — there is no copy in it, and
        // flagging it is exactly the false positive this file already warns
        // gets a guard deleted. It surfaced when the typography migration let
        // `dart format` collapse that call onto one line, so a line-based
        // matcher suddenly saw it; the code had not changed at all.
        //
        // `Text('${l10n.legalPrefix} ')` is deliberately NOT exempt: strip the
        // interpolation and a real space remains, and those joiners are the
        // allowlisted sites this rule exists to keep counting.
        if (m.group(1)!.replaceAll(interpolation, '').isEmpty) continue;
        final site = '${s.path}:${i + 1}';
        if (!allow.contains(site)) out.add(site);
        break;
      }
    }
  }
  return out;
}

// ---------------------------------------------------------------------------
// RULE (ratchet): typography comes from the theme, not from call sites.
// ---------------------------------------------------------------------------

/// Count of hardcoded `fontSize:` values in hand-written UI code.
///
/// There is no `TextTheme` in this app and 153 call sites set `fontSize`
/// inline, so this cannot be enforced at zero without a refactor that is out of
/// scope. It is therefore a **ratchet**: the number may fall, never rise. That
/// converts "we should add a TextTheme one day" from an aspiration into a
/// boundary — new screens cannot make it worse while the existing debt is paid
/// down deliberately.
int hardcodedFontSizeCount(List<Source> sources) {
  var n = 0;
  for (final s in sources) {
    // `lib/core/theme/` is exempt, exactly as it is for colour: it is where
    // type metrics are SUPPOSED to live. Before the scale existed this
    // exemption was pointless — there was nothing in the theme to exempt. Now
    // `AppType` holds all 18 sizes there, so counting them would mean this
    // ratchet could never reach zero and would silently stop meaning anything.
    if (s.path.contains('lib/core/theme/')) continue;
    n += RegExp(r'fontSize:\s*[0-9]').allMatches(stripComments(s.text)).length;
  }
  return n;
}

// ---------------------------------------------------------------------------
// RULE: both localizations carry the same keys.
// ---------------------------------------------------------------------------

/// Keys present in one ARB but not the other.
///
/// A key missing from `app_ar.arb` does not throw — gen-l10n falls back to
/// English silently, so the failure mode is an Arabic screen with an English
/// word in it that nobody notices until a user does.
/// ARB is JSON, so it is PARSED rather than pattern-matched.
///
/// The first version of this used a regex for `"key":` and produced five false
/// positives — it matched keys nested inside `@metadata` objects
/// (`"placeholders"`, `"count"`, `"description"`…), which exist in the English
/// file and legitimately do not exist in the Arabic one. A guard that cries
/// wolf gets deleted, so a false positive is a worse defect here than a missed
/// violation. Only TOP-LEVEL, non-`@` keys are real message keys.
({Set<String> missingInAr, Set<String> extraInAr}) arbKeyDrift(
  String enArb,
  String arArb,
) {
  Set<String> keys(String src) {
    final decoded = jsonDecode(src) as Map<String, dynamic>;
    return decoded.keys.where((k) => !k.startsWith('@')).toSet();
  }

  final en = keys(enArb);
  final ar = keys(arArb);
  return (missingInAr: en.difference(ar), extraInAr: ar.difference(en));
}

// ---------------------------------------------------------------------------
// RULE (ratchet): elevation effects come from the theme, not from call sites.
// ---------------------------------------------------------------------------

/// Paths where raw shadow/blur/backdrop code is legitimate.
///
/// `lib/core/theme/` holds the tokens; `lib/core/widgets/elevation/` holds the
/// only code allowed to turn one into paint. Exactly the same exemption shape
/// as the colour and typography rules, for the same reason: a design system
/// needs one place where the primitive is allowed to exist.
bool _elevationExempt(String path) {
  final p = path.replaceAll(r'\', '/');
  return p.contains('lib/core/theme/') ||
      p.contains('lib/core/widgets/elevation/');
}

/// `path:line` for every raw elevation effect outside those two folders.
///
/// **Why this rule exists.** A shadow decided at a call site is the same defect
/// class the palette guard was built for, and it went uncaught for as long.
/// Five `BoxShadow`s shipped with `blurRadius` set to Figma's *blur* number —
/// two different units — and with a colour that only read on one canvas
/// (docs/DESIGN_ISSUES.md #47). None of that is visible in review; all of it is
/// visible to this function.
///
/// What counts:
/// * `BoxShadow(` — the Flutter shadow, whose `blurRadius` is not Figma's blur;
/// * `elevation:` with anything but a literal `0` — including the ternary
///   `elevation: selected ? 0 : 2`, which a "non-zero literal" check would miss;
/// * `shadowColor:` — a colour decided next to a shadow is still a colour
///   decided at a call site;
/// * `MaskFilter.blur`, `ImageFilter.blur`, `BackdropFilter`, `PhysicalModel(`
///   — the blur and backdrop primitives the Glass work introduced. Left
///   unguarded, the second implementation of Glass arrives the first time
///   somebody needs one and cannot find `ElevatedSurface`.
///
/// A ratchet rather than a ban, because eleven sites exist today and migrating
/// them belongs to the edits that own those components.
List<String> rawElevationEffects(List<Source> sources) {
  final out = <String>[];
  final banned = <RegExp>[
    RegExp(r'BoxShadow\('),
    RegExp(r'shadowColor:'),
    RegExp(r'MaskFilter\.blur'),
    RegExp(r'ImageFilter\.blur'),
    RegExp('BackdropFilter'),
    RegExp(r'PhysicalModel\('),
  ];
  // Captures up to the first `,` or `)` so a ternary is read whole.
  final elevation = RegExp(r'elevation:\s*([^,)]*)');

  for (final s in sources) {
    if (_elevationExempt(s.path)) continue;
    final lines = stripComments(s.text).split('\n');
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      var hit = banned.any((p) => p.hasMatch(line));
      if (!hit) {
        final m = elevation.firstMatch(line);
        if (m != null) {
          final value = m.group(1)!.trim();
          // `elevation: 0` is how a widget says "flat", which is the state this
          // rule wants. Flagging it would push people to remove the line and
          // inherit Material's default instead — the opposite of the intent.
          hit = value != '0' && value != '0.0';
        }
      }
      if (hit) out.add('${s.path}:${i + 1}');
    }
  }
  return out;
}

// ---------------------------------------------------------------------------
// Contract `required:` vs the Dart model
// ---------------------------------------------------------------------------

/// Thrown when the contract cannot be read the way this guard assumes.
///
/// Deliberately an exception rather than an empty result. A navigator that
/// returned `[]` for a schema it failed to find would make the guard PASS —
/// silently, and for every field at once. The failure this guard exists to
/// catch is a field that is present in the contract and absent from the model;
/// a lookup that quietly finds nothing looks exactly like a model that is
/// complete.
class ContractShapeException implements Exception {
  ContractShapeException(this.message);
  final String message;
  @override
  String toString() => 'ContractShapeException: $message';
}

/// The names in the `required: [...]` list of the schema block at [path].
///
/// [path] is spelled in the contract's own YAML terms, `properties` and all —
/// e.g. `['StudentProfile', 'properties', 'school']`. Naming the intermediate
/// keys is deliberate: an OpenAPI document nests `required` under whichever
/// object owns it, and a path that skipped `properties` would have to guess.
///
/// Only the flow form (`required: [a, b]`) is understood, which is the only
/// form this contract uses. A block form would raise rather than silently read
/// as empty.
List<String> contractRequiredFields(String yaml, List<String> path) {
  if (path.isEmpty) throw ContractShapeException('empty path');
  final lines = yaml.split('\n');

  bool blank(String l) => l.trim().isEmpty || l.trimLeft().startsWith('#');
  int indentOf(String l) => l.length - l.trimLeft().length;

  /// The half-open line range of the block under `key:` at [indent], searched
  /// within `[from, to)`.
  (int, int) child(String key, int indent, int from, int to) {
    final head = RegExp('^ {$indent}${RegExp.escape(key)}:');
    for (var i = from; i < to; i++) {
      if (blank(lines[i]) || !head.hasMatch(lines[i])) continue;
      for (var j = i + 1; j < to; j++) {
        if (blank(lines[j])) continue;
        if (indentOf(lines[j]) <= indent) return (i + 1, j);
      }
      return (i + 1, to);
    }
    throw ContractShapeException(
      "no `$key:` at indent $indent within lines ${from + 1}-$to",
    );
  }

  var (from, to) = child('components', 0, 0, lines.length);
  (from, to) = child('schemas', 2, from, to);

  // Schema names sit at indent 4; each further step is nested one level deeper.
  var indent = 4;
  for (final seg in path) {
    (from, to) = child(seg, indent, from, to);
    indent += 2;
  }

  // `required:` is a sibling of the block's own keys, i.e. at the child indent.
  // Adjacent literals, the second raw: `'\s'` in an ordinary Dart string is a
  // plain `s`, not the whitespace class.
  final want = RegExp(
    '^ {$indent}required:'
    r'\s*(.*)$',
  );
  for (var i = from; i < to; i++) {
    if (indentOf(lines[i]) != indent) continue;
    final m = want.firstMatch(lines[i]);
    if (m == null) continue;
    final raw = m.group(1)!.trim();
    if (!raw.startsWith('[') || !raw.endsWith(']')) {
      throw ContractShapeException(
        'line ${i + 1}: `required:` is not a flow list — got "$raw"',
      );
    }
    final names = raw
        .substring(1, raw.length - 1)
        .split(',')
        .map((n) => n.trim())
        .where((n) => n.isNotEmpty)
        .toList();
    if (names.isEmpty) {
      throw ContractShapeException('line ${i + 1}: empty `required:` list');
    }
    return names;
  }
  throw ContractShapeException(
    'no `required:` at indent $indent for ${path.join(" > ")}',
  );
}

/// Whether [dart] declares [field] as a constructor parameter.
///
/// Comments are stripped first, for the reason [stripComments] exists at all:
/// this file's whole history is a guard that was satisfied by prose. A doc
/// comment explaining why `hasFlashcards` is not modelled must NOT count as
/// modelling it.
///
/// The match is the parameter position specifically — the name followed by a
/// `,`, `)` or `}` — so `json['hasFlashcards']` inside a hand-written parser
/// does not count either. A field is modelled when the constructor takes it.
///
/// ⚠️ **Scope is the FILE, not the class.** [dart] is a whole file's source and
/// nothing here parses class bodies, so a field of the same name on ANY other
/// class in the same file satisfies the match. The models in this repo share a
/// file per feature and repeat names like `id`, `name` and `track` across them,
/// so the masking is real rather than theoretical — see the limitations list in
/// `contract_models_test.dart` for what that does and does not cost. Making the
/// detection class-scoped is future hardening, deliberately not done here.
///
/// Built by concatenating RAW strings rather than interpolating into one: in an
/// ordinary Dart string `'\b'` is a backspace character and `'\s'` is a plain
/// `s`, so the interpolated form compiles, runs, and matches nothing like what
/// it appears to. It passed its own positive fixture only by accident of what
/// it did still match.
bool dartDeclaresField(String dart, String field) => RegExp(
  r'\b' + RegExp.escape(field) + r'\s*[,)}]',
).hasMatch(stripComments(dart));
