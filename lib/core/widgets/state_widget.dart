import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../models/screen_state.dart';

/// The ONLY place that switches on `ScreenState`. If a screen re-derives its
/// own state enum or booleans, fix that first.
///
/// Defaults are deliberately plain — real screens pass `loading` (a skeleton
/// matching the content), `empty` (localized message + illustration), etc.
class StateWidget<T> extends StatelessWidget {
  const StateWidget({
    super.key,
    required this.state,
    required this.onLoaded,
    this.onRetry,
    this.loading,
    this.empty,
    this.error,
    this.offline,
  });

  final ScreenState<T> state;
  final Widget Function(T data) onLoaded;
  final VoidCallback? onRetry;
  final Widget? loading;
  final Widget? empty;
  final Widget? error;
  final Widget? offline;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      ScreenLoading<T>() =>
        loading ?? const Center(child: CircularProgressIndicator()),
      ScreenEmpty<T>() =>
        empty ??
            const _CenterMessage(icon: Icons.inbox_outlined, text: 'Empty'),
      ScreenLoaded<T>(:final data) => onLoaded(data),
      // messageKey is a localization key; real screens resolve it via l10n.
      ScreenError<T>(:final messageKey) =>
        error ??
            _CenterMessage(
              icon: Icons.error_outline,
              text: messageKey,
              onRetry: onRetry,
            ),
      ScreenOffline<T>() =>
        offline ??
            _CenterMessage(
              icon: Icons.wifi_off,
              text: 'Offline',
              onRetry: onRetry,
            ),
    };
  }
}

class _CenterMessage extends StatelessWidget {
  const _CenterMessage({required this.icon, required this.text, this.onRetry});
  final IconData icon;
  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48),
          const SizedBox(height: 12),
          Text(text),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            // Retry re-triggers the same request on tap — never silent auto-retry.
            //
            // The label reads the existing `retry` ARB key rather than a
            // hardcoded 'Retry'. Nine other retry buttons across the app already
            // did; this shared fallback — the one reached from EVERY screen that
            // has no custom error view — was the only English holdout, in an app
            // whose baseline locale is Arabic.
            FilledButton(
              onPressed: onRetry,
              child: Text(AppLocalizations.of(context).retry),
            ),
          ],
        ],
      ),
    );
  }
}
