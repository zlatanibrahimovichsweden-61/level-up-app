import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../models/screen_state.dart';
import '../widgets/circle_back_button.dart';
import '../widgets/state_widget.dart';

/// What `GoRouter.errorBuilder` renders for a location no route matches.
///
/// Built only from parts that already exist: the shared error presentation
/// ([StateWidget]'s error state, with the existing `genericError` copy and NO
/// Retry — re-running an unknown location cannot succeed) and the design's
/// circle back chip. Back pops when there is something to pop (the unknown
/// location was pushed over a screen) and otherwise goes Home, because a cold
/// link to an unknown location leaves nothing underneath.
///
/// A signed-out student on an unknown location is normally redirected to
/// `/login` by `authRedirect` before this renders. The two edges where they
/// would not be — an unmatched cold-start location while the status is still
/// `AuthUnknown`, and an unmatched `/register…` path, which `authRedirect`
/// treats as an auth route — are not reachable through any URL or deep-link
/// entry point the app ships (no intent filters beyond MAIN/LAUNCHER, no URL
/// types), and every in-app `/register` navigation is a fixed valid path. Only
/// a platform route override (an explicit launch carrying a route, or a test
/// harness) can supply such a cold-start location. See the `errorBuilder` note
/// in `app_router.dart`.
///
/// Deliberately shows nothing about the location or the router's exception —
/// neither is copy, and the location may carry a student's ids.
class RouteErrorScreen extends StatelessWidget {
  const RouteErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24, 8, 24, 0),
              child: Row(
                children: [CircleBackButton(onPressed: () => _back(context))],
              ),
            ),
            Expanded(
              child: StateWidget<void>(
                // `StateWidget`'s default error view prints `messageKey` as
                // given, and its message widget is private — so this hands it
                // the already-resolved existing `genericError` string. There is
                // no `onRetry`, so no Retry button is drawn.
                state: ScreenError<void>(l10n.genericError),
                onLoaded: (_) => const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _back(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }
}
