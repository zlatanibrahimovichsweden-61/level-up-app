import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screen_protector/screen_protector.dart';

/// Screenshot protection, behind a seam.
///
/// `screen_protector` talks over a platform channel, so calling it directly
/// from the quiz screen would make "protection is on while taking a quiz, and
/// off afterwards" untestable — a widget test would only ever see a
/// `MissingPluginException`. The Day 7 requirement is explicit that this must
/// be VERIFIED rather than assumed (it closes a HIGH finding in
/// docs/LEVEL_UP_AUDIT_2026-07-28.md §3), so it goes through a provider a test
/// can override and assert on.
///
/// The contract's own justification: *"Correct answers never ship with
/// questions (content protection — the bank is the product)."*
///
/// Scope is the quiz screens ONLY. Leaving it on globally would block
/// screenshots of Home, the leaderboard and settings, which nothing asks for.
abstract class ScreenProtection {
  const ScreenProtection();

  Future<void> enable();

  Future<void> disable();
}

class PluginScreenProtection extends ScreenProtection {
  const PluginScreenProtection();

  /// Android gets `FLAG_SECURE` — a hard block. iOS gets the secure-layer
  /// trick: captures come out blank and recording is detectable, but it is NOT
  /// a hard block, and nothing in this app should promise otherwise.
  @override
  Future<void> enable() => ScreenProtector.preventScreenshotOn();

  @override
  Future<void> disable() => ScreenProtector.preventScreenshotOff();
}

final screenProtectionProvider = Provider<ScreenProtection>(
  (ref) => const PluginScreenProtection(),
);
