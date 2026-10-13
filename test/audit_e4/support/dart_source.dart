/// Source-scan helpers for the E4 static census tests. Not product code.
library;

import 'dart:io';

/// Every hand-written `.dart` file under `lib/` (generated `.g.dart` /
/// `.freezed.dart` and the l10n output are skipped) as `path -> comment-free
/// source`.
Map<String, String> libCode({bool includeDev = true}) {
  final out = <String, String>{};
  for (final entity in Directory('lib').listSync(recursive: true)) {
    if (entity is! File) continue;
    final path = entity.path.replaceAll(r'\', '/');
    if (!path.endsWith('.dart')) continue;
    if (path.endsWith('.g.dart') || path.endsWith('.freezed.dart')) continue;
    if (path.startsWith('lib/l10n/')) continue;
    if (!includeDev && path.startsWith('lib/dev/')) continue;
    out[path] = stripComments(entity.readAsStringSync());
  }
  return out;
}

/// Removes `//` and `/* */` comments while leaving string literals intact (so a
/// `'https://...'` is not mistaken for a comment start, and prose that names a
/// forbidden call is not mistaken for a call).
String stripComments(String src) {
  final out = StringBuffer();
  var i = 0;
  final n = src.length;
  while (i < n) {
    final c = src[i];
    final next = i + 1 < n ? src[i + 1] : '';

    // Line comment.
    if (c == '/' && next == '/') {
      while (i < n && src[i] != '\n') {
        i++;
      }
      continue;
    }
    // Block comment (Dart block comments nest).
    if (c == '/' && next == '*') {
      var depth = 1;
      i += 2;
      while (i < n && depth > 0) {
        if (src[i] == '/' && i + 1 < n && src[i + 1] == '*') {
          depth++;
          i += 2;
        } else if (src[i] == '*' && i + 1 < n && src[i + 1] == '/') {
          depth--;
          i += 2;
        } else {
          if (src[i] == '\n') out.write('\n');
          i++;
        }
      }
      continue;
    }
    // String literal: copy through its closing quote.
    if (c == "'" || c == '"') {
      final raw = i > 0 && src[i - 1] == 'r';
      final triple = i + 2 < n && src[i + 1] == c && src[i + 2] == c;
      final quote = triple ? c * 3 : c;
      out.write(quote);
      i += quote.length;
      while (i < n) {
        if (!raw && src[i] == r'\') {
          out.write(src.substring(i, i + 2 > n ? n : i + 2));
          i += 2;
          continue;
        }
        if (src.startsWith(quote, i)) {
          out.write(quote);
          i += quote.length;
          break;
        }
        out.write(src[i]);
        i++;
      }
      continue;
    }
    out.write(c);
    i++;
  }
  return out.toString();
}

/// Blanks the CONTENT of string literals (keeping the quotes), for scans that
/// look for code tokens and must not match inside user-facing text.
String blankStrings(String code) {
  final out = StringBuffer();
  var i = 0;
  final n = code.length;
  while (i < n) {
    final c = code[i];
    if (c == "'" || c == '"') {
      final raw = i > 0 && code[i - 1] == 'r';
      final triple = i + 2 < n && code[i + 1] == c && code[i + 2] == c;
      final quote = triple ? c * 3 : c;
      out.write(quote);
      i += quote.length;
      while (i < n) {
        if (!raw && code[i] == r'\') {
          i += 2;
          continue;
        }
        if (code.startsWith(quote, i)) {
          out.write(quote);
          i += quote.length;
          break;
        }
        if (code[i] == '\n') out.write('\n');
        i++;
      }
      continue;
    }
    out.write(c);
    i++;
  }
  return out.toString();
}
