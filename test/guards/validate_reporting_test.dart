import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards on the validator's own reporting.
///
/// `tool/validate.*` is the one command this project trusts. On 2026-09-12 it
/// was caught reporting **`923 passed / 0 failed` while one test had failed**,
/// and never reporting the skipped count at all. `OVERALL` was still `FAIL` —
/// it keys off the exit code — so the gate held and only the human-readable
/// summary lied. That is precisely the class of defect this project keeps
/// paying for: the thing that reports the truth had nothing checking it.
///
/// Cause: the expanded reporter's counter is `+<passed> ~<skipped> -<failed>`,
/// and both scripts read `-<failed>` as *optional-directly-after* `+<passed>`.
/// On `00:16 +355 ~1 -1:` the `~1 ` sits between them, the failed group never
/// matches, and the default `0` is printed as though it were measured.
///
/// So the rule is mechanised rather than written down — `ENFORCEMENT.md`'s
/// standing finding is that prose rules decay and only mechanised ones hold.
/// The PowerShell pattern is deliberately kept free of inline `(?m)` and of
/// `\d`, so this test can extract that exact literal and run it. The guard is
/// therefore testing the shipped pattern, not a copy of it that could drift.
void main() {
  final ps1 = File('tool/validate.ps1').readAsStringSync();
  final sh = File('tool/validate.sh').readAsStringSync();

  /// The counter pattern as `tool/validate.ps1` actually defines it.
  String powerShellCounterPattern() {
    final m = RegExp(r"""\$counterPattern\s*=\s*'([^']*)'""").firstMatch(ps1);
    expect(
      m,
      isNotNull,
      reason:
          'tool/validate.ps1 no longer defines a single-quoted '
          r'$counterPattern. This guard extracts that literal so it tests the '
          'shipped pattern rather than a copy. If the parser was restructured, '
          'restructure this guard with it — do not delete it.',
    );
    return m!.group(1)!;
  }

  /// (passed, skipped, failed) as the script would compute them: the LAST
  /// counter match wins, and an absent group counts as zero.
  ({String pass, String skip, String fail}) parse(String reporterOutput) {
    final re = RegExp(powerShellCounterPattern(), multiLine: true);
    final all = re.allMatches(reporterOutput).toList();
    expect(
      all,
      isNotEmpty,
      reason: 'no counter line matched in:\n$reporterOutput',
    );
    final last = all.last;
    return (
      pass: last.group(1) ?? '?',
      skip: last.group(2) ?? '0',
      fail: last.group(3) ?? '0',
    );
  }

  group('the validator reads the test tally correctly', () {
    test('a failing run reports its failures — the 2026-09-12 defect', () {
      // The exact shape that was misread. If this ever returns fail: '0'
      // again, the validator is lying about a red suite.
      final r = parse('00:16 +355 ~1 -1: some/test.dart: a thing [E]');
      expect(r.pass, '355');
      expect(r.skip, '1');
      expect(
        r.fail,
        '1',
        reason:
            'the failed count was read as 0 because "~1 " sits between '
            '"+355" and "-1". This is the regression that prompted the guard.',
      );
    });

    test('a passing run still reports its skipped tests', () {
      // The live suite's own shape on 2026-09-12: 943 passed, 1 skipped
      // (the leaderboard test parked behind D-008). The old parser dropped
      // the "~1" silently, so a skip could be introduced and never noticed.
      final r = parse('00:41 +943 ~1: All tests passed!');
      expect(r.pass, '943');
      expect(r.skip, '1');
      expect(r.fail, '0');
    });

    test('a clean run with neither skips nor failures', () {
      final r = parse('00:03 +12: some/test.dart: a thing');
      expect((r.pass, r.skip, r.fail), ('12', '0', '0'));
    });

    test('failures without skips — the shape the old parser did handle', () {
      final r = parse('00:05 +10 -2: some/test.dart: a thing [E]');
      expect((r.pass, r.skip, r.fail), ('10', '0', '2'));
    });

    test('the final tally wins, not the first', () {
      final r = parse('''
00:01 +0: loading
00:07 +120 ~1: some/test.dart: a thing
00:16 +355 ~1 -1: some/test.dart: another thing [E]
''');
      expect((r.pass, r.skip, r.fail), ('355', '1', '1'));
    });

    test('a "+N" inside test output is not mistaken for a tally', () {
      // Anchoring on the timestamp is what makes this safe. An expectation
      // diff that prints "+7" mid-run must not become the reported count.
      final r = parse('''
00:05 +10 ~2 -1: some/test.dart: adding things [E]
  Expected: +7
    Actual: +9
''');
      expect(
        (r.pass, r.skip, r.fail),
        ('10', '2', '1'),
        reason: 'the counter must come from a counter line, not from output',
      );
    });
  });

  group('the POSIX twin parses the same shape', () {
    // tool/validate.sh cannot share the pattern — POSIX ERE has no
    // non-capturing groups — so it is checked structurally instead. The two
    // scripts are documented as producing the same artefact; a fix applied to
    // one and not the other is how they drift apart.
    test('validate.sh captures the skipped counter', () {
      expect(
        RegExp(r'grep -oE.*~\[0-9\]').hasMatch(sh),
        isTrue,
        reason:
            'tool/validate.sh does not extract the "~<skipped>" counter. It '
            'carried the identical defect to the PowerShell twin and must be '
            'fixed alongside it.',
      );
    });

    test('validate.sh anchors its counter read on the timestamp', () {
      expect(
        sh.contains(r'^[[:blank:]]*[0-9]{2,}:[0-9]{2}'),
        isTrue,
        reason:
            'an unanchored read can pick up a "+N" printed inside test output',
      );
    });

    test('both scripts surface the skipped count in their summary', () {
      expect(
        ps1.contains(r'$tstSkip skipped'),
        isTrue,
        reason: 'validate.ps1 computes a skipped count but never prints it',
      );
      expect(
        sh.contains(r'$tst_skip skipped'),
        isTrue,
        reason: 'validate.sh computes a skipped count but never prints it',
      );
    });
  });

  group('the gate is not the exit code alone', () {
    // The exit code stays authoritative. These are additional ways to FAIL —
    // never a way to PASS — so that a run which printed failures while
    // somehow exiting 0, or died before printing a tally, still fails.
    test('validate.ps1 fails on an unparseable tally', () {
      expect(
        ps1.contains(r"elseif ($tstPass -eq '?')"),
        isTrue,
        reason:
            "an unreadable tally must fail, never be reported as 0 failures",
      );
      expect(
        ps1.contains(r"elseif ($tstFail -ne '0')"),
        isTrue,
        reason: 'a parsed failure count must fail the run on its own',
      );
    });

    test('validate.ps1 requires the reporter to have finished', () {
      expect(
        ps1.contains('All tests passed!') &&
            ps1.contains(r'Some tests failed\.'),
        isTrue,
        reason:
            'a run cut short partway through prints neither completion line '
            'and must not be reported as a pass',
      );
    });

    test('validate.sh applies the same three extra failure conditions', () {
      expect(
        sh.contains(r'[ "$tst_fail" != "0" ]'),
        isTrue,
        reason: 'a parsed failure count must fail the run on its own',
      );
      expect(
        sh.contains(r'[ "$tst_pass" = "?" ]'),
        isTrue,
        reason: 'an unreadable tally must fail',
      );
      expect(
        sh.contains(r'[ "$saw_completion" -ne 1 ]'),
        isTrue,
        reason: 'a run cut short must fail',
      );
    });
  });
}
