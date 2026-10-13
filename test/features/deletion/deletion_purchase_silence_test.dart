import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The app is purchase-silent (adr-049 section 3): no paywall, price, upgrade
/// link or checkout hand-off of any kind - purchases happen entirely on the
/// website. The pinned contract's deletion text still talks about money (the
/// old confirm-step wording, `openapi.yaml:1282-1288`), and that wording must
/// NOT be copied into the app. This scans the files written for CW04b / CW05 /
/// CW06 - code AND comments, because a comment is where a quoted sentence would
/// hide - for any of those words.
///
/// It is a tripwire for the words, not a proof of the principle; the principle
/// is also held by the review and by there being no screen in this change.
void main() {
  /// Stems, matched case-insensitively anywhere in a word.
  const forbidden = <String>[
    'paid',
    'refund',
    'subscri',
    'price',
    'pricing',
    'payment',
    'checkout',
    'upgrade',
    'paywall',
    'purchas',
    'billing',
    'forfeit',
    'premium',
    'invoice',
    'entitle',
  ];

  /// Every `file:line` in [text] carrying a forbidden stem.
  List<String> offences(String path, String text) {
    final out = <String>[];
    final lines = text.split('\n');
    for (var i = 0; i < lines.length; i++) {
      final lower = lines[i].toLowerCase();
      for (final stem in forbidden) {
        if (lower.contains(stem)) out.add('$path:${i + 1} ($stem)');
      }
    }
    return out;
  }

  /// The hand-written files this change adds to `lib/`.
  List<File> newFiles() {
    final files = <File>[
      File('lib/features/legal/models/terms_acceptance.dart'),
      File('lib/features/legal/repository/terms_repository.dart'),
      File('lib/features/legal/terms_errors.dart'),
      File('lib/dev/mock_terms.dart'),
      File('lib/dev/mock_deletion.dart'),
      File('lib/dev/mock_recovery.dart'),
    ];
    for (final dir in ['lib/features/deletion', 'lib/features/recovery']) {
      files.addAll(
        Directory(dir)
            .listSync(recursive: true)
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart')),
      );
    }
    return files;
  }

  test('the scan is looking at the files it should', () {
    final paths = newFiles().map((f) => f.path.replaceAll(r'\', '/')).toSet();
    expect(
      paths,
      containsAll(<String>[
        'lib/features/deletion/models/deletion_window.dart',
        'lib/features/deletion/repository/deletion_repository.dart',
        'lib/features/deletion/deletion_errors.dart',
        'lib/dev/mock_deletion.dart',
        'lib/features/recovery/repository/recovery_repository.dart',
        'lib/features/recovery/recovery_errors.dart',
        'lib/features/recovery/notifier/recovery_flow_notifier.dart',
      ]),
    );
    for (final f in newFiles()) {
      expect(f.existsSync(), isTrue, reason: f.path);
      expect(f.readAsStringSync(), isNotEmpty, reason: f.path);
    }
  });

  test('the detector actually detects (positive control)', () {
    expect(offences('x', 'An active paid plan is lost'), isNotEmpty);
    expect(offences('x', '// no REFUND is given'), isNotEmpty);
    expect(offences('x', 'flashcard_subscription'), isNotEmpty);
    expect(offences('x', 'the checkout page'), isNotEmpty);
    expect(offences('x', 'a deletion request and its grace window'), isEmpty);
  });

  test('no new file says anything about money, plans or subscriptions', () {
    final found = <String>[
      for (final f in newFiles())
        ...offences(f.path.replaceAll(r'\', '/'), f.readAsStringSync()),
    ];
    expect(
      found,
      isEmpty,
      reason:
          'The app is purchase-silent. The deletion confirm step carries no '
          'paid / refund / subscription wording (and the contract\'s old text '
          'for it is not to be copied). Offending lines:\n${found.join('\n')}',
    );
  });
}
