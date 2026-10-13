import '../guards/rules.dart';

/// Reads an OPERATION's own request and response schemas out of the vendored
/// contract text, for the bodies the contract spells inline instead of naming.
///
/// **Why this exists.** `test/guards/contract_models_test.dart` binds a Dart
/// model to a `components.schemas` entry, and `contractRequiredFields` only
/// navigates `components > schemas`. The bodies of the CW04b / CW05 / CW06
/// operations are inline under `paths`, so that guard cannot bind them; this
/// reads the same `required: [...]` flow list from the operation instead, and
/// keeps the field list OUT of the test (re-vendor a contract that adds a
/// required field and the matching test fails until the model catches up).
///
/// Like the guard it is a line reader, not a YAML parser: it understands the
/// contract's own layout (a two-space path key, a four-space method key,
/// flow-style `required: [a, b]`) and RAISES on anything else instead of
/// reading it as empty - a lookup that quietly found nothing would look exactly
/// like a model that is complete.
class ContractOperation {
  ContractOperation._(this.path, this.method, this._lines);

  /// The operation `[method]` of `[path]` in [yaml] (e.g. `/me/terms-acceptance`
  /// and `get`).
  factory ContractOperation.find(
    String yaml, {
    required String path,
    required String method,
  }) {
    final all = yaml.split('\n');
    final pathStart = all.indexWhere((l) => l.trimRight() == '  $path:');
    if (pathStart < 0) {
      throw ContractShapeException('no path `$path` in the contract');
    }
    final pathEnd = _blockEnd(all, pathStart, 2);
    final methodStart = all
        .sublist(pathStart, pathEnd)
        .indexWhere((l) => l.trimRight() == '    $method:');
    if (methodStart < 0) {
      throw ContractShapeException('no `$method` under `$path`');
    }
    final absolute = pathStart + methodStart;
    return ContractOperation._(
      path,
      method,
      all.sublist(absolute, _blockEnd(all, absolute, 4)),
    );
  }

  final String path;
  final String method;
  final List<String> _lines;

  /// The operation's whole text.
  String get text => _lines.join('\n');

  String get operationId =>
      RegExp(r'operationId: (\w+)').firstMatch(text)!.group(1)!;

  bool get isStable => text.contains('x-stability: stable');

  /// `security: []` - the operation is anonymous.
  bool get isAnonymous => text.contains('security: []');

  /// The `required: [...]` of the schema of response [status].
  List<String> responseRequired(String status) =>
      _requiredIn(_responseBlock(status));

  /// The property names of the schema of response [status].
  List<String> responseProperties(String status) =>
      _propertiesIn(_responseBlock(status));

  /// The `required: [...]` of the request body's schema.
  List<String> requestRequired() => _requiredIn(_requestBlock());

  /// The property names of the request body's schema.
  List<String> requestProperties() => _propertiesIn(_requestBlock());

  /// Whether the response [status] exists on this operation.
  bool hasResponse(String status) =>
      _lines.any((l) => RegExp("^ {8}'$status':").hasMatch(l));

  List<String> _responseBlock(String status) {
    final responses = _lines.indexWhere(
      (l) => l.trimRight() == '      responses:',
    );
    if (responses < 0) {
      throw ContractShapeException('$operationId has no `responses:`');
    }
    final from = _lines.indexWhere(
      (l) => l.trimRight() == "        '$status':",
      responses,
    );
    if (from < 0) {
      throw ContractShapeException('$operationId has no response `$status`');
    }
    return _lines.sublist(from, _blockEnd(_lines, from, 8));
  }

  List<String> _requestBlock() {
    final from = _lines.indexWhere(
      (l) => l.trimRight() == '      requestBody:',
    );
    if (from < 0) {
      throw ContractShapeException('$operationId has no `requestBody:`');
    }
    return _lines.sublist(from, _blockEnd(_lines, from, 6));
  }

  /// The shallowest `required: [...]` flow list in [block] (`required: true`,
  /// the request body's own flag, is not a list and is skipped).
  List<String> _requiredIn(List<String> block) {
    int? bestIndent;
    String? best;
    for (final line in block) {
      final m = RegExp(r'^(\s*)required:\s*(\[.*\])\s*$').firstMatch(line);
      if (m == null) continue;
      final indent = m.group(1)!.length;
      if (bestIndent == null || indent < bestIndent) {
        bestIndent = indent;
        best = m.group(2);
      }
    }
    if (best == null) {
      throw ContractShapeException('no flow-style `required: [...]` in block');
    }
    return best
        .substring(1, best.length - 1)
        .split(',')
        .map((n) => n.trim())
        .where((n) => n.isNotEmpty)
        .toList();
  }

  List<String> _propertiesIn(List<String> block) {
    final head = block.indexWhere((l) => l.trim() == 'properties:');
    if (head < 0) throw ContractShapeException('no `properties:` in block');
    final headIndent = _indent(block[head]);
    final names = <String>[];
    int? childIndent;
    for (var i = head + 1; i < block.length; i++) {
      final line = block[i];
      if (line.trim().isEmpty) continue;
      final indent = _indent(line);
      if (indent <= headIndent) break;
      childIndent ??= indent;
      if (indent != childIndent) continue;
      final m = RegExp(r'^\s*(\w+):').firstMatch(line);
      if (m != null) names.add(m.group(1)!);
    }
    return names;
  }

  static int _indent(String line) => line.length - line.trimLeft().length;

  /// The index just past the block that starts at [start] and is indented
  /// [indent]: the next non-blank line indented no deeper.
  static int _blockEnd(List<String> lines, int start, int indent) {
    for (var i = start + 1; i < lines.length; i++) {
      if (lines[i].trim().isEmpty) continue;
      if (_indent(lines[i]) <= indent) return i;
    }
    return lines.length;
  }
}

/// The contract fields of [fields] that the Dart class [dartClass] in [dart]
/// does not take as constructor parameters - the same presence check
/// `contract_models_test.dart` makes, scoped to ONE class so a same-named field
/// on another class in the file cannot satisfy it.
List<String> missingModelFields(
  String dart,
  String dartClass,
  Iterable<String> fields,
) {
  final body = dartClassBody(dart, dartClass);
  if (body == null) {
    throw ContractShapeException('the source declares no `class $dartClass`');
  }
  return [
    for (final field in fields)
      if (!dartDeclaresField(body, field)) field,
  ];
}
