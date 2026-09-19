/// Modal routes that wear the design's own scrim.
library;

import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../theme/app_elevation.dart';

/// Shows a dialog under [scrim].
///
/// With `scrim == null` this is `showDialog` verbatim — same route, same
/// defaults, same barrier. With a scrim, the barrier takes [ScrimStyle.color],
/// and when [ScrimStyle.sigma] is above zero the page behind it is blurred by
/// that sigma.
///
/// **How the blur is done, and why not another way.** `ModalRoute` already has
/// a [ModalRoute.filter] hook whose entire documented purpose is this — it
/// wraps the barrier in a `BackdropFilter` (`routes.dart`
/// `_buildModalBarrier`). Neither `DialogRoute` nor `ModalBottomSheetRoute`
/// forwards it, so the two private routes below override the getter and change
/// nothing else.
///
/// The alternatives were tried against the SDK source first and all fail:
///
/// * a `BackdropFilter` inside the dialog's own page is wrapped by
///   `showDialog`'s `FadeTransition`, and a backdrop filter inside an opacity
///   layer has no backdrop to read — it would render no blur at all until the
///   entrance animation finished and `RenderAnimatedOpacity` dropped its layer;
/// * a `BackdropFilter` inside a bottom sheet's builder sits *inside* the
///   sheet's own `Material`, so it would blur and smear the sheet's panel and
///   its rounded top edge rather than the page;
/// * a manually inserted `OverlayEntry` does not survive: `Navigator`'s
///   `_flushHistoryUpdates` calls `overlay.rearrange(_allRouteOverlayEntries)`,
///   which re-inserts every non-route entry **above** the routes — i.e. on top
///   of the modal.
///
/// The filter paints under the barrier colour, which is CSS
/// `backdrop-filter` order and Figma's: blur the page, then lay the tint over
/// it. For a flat tint that is identical to tinting first and blurring both.
///
/// The blur is not animated. `ModalRoute.filter` is a fixed `ImageFilter` read
/// when the barrier entry builds, which is how the framework's own
/// `showCupertinoModalPopup` behaves; the barrier *colour* still fades in over
/// the route's transition.
Future<T?> showAppDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  ScrimStyle? scrim,
  bool barrierDismissible = true,
}) {
  final sigma = scrim?.sigma ?? 0;
  if (sigma <= 0) {
    return showDialog<T>(
      context: context,
      builder: builder,
      // Null falls through to the framework's own resolution chain
      // (`DialogTheme.barrierColor`, then its built-in default), so a
      // scrim-less call is unchanged.
      barrierColor: scrim?.color,
      barrierDismissible: barrierDismissible,
    );
  }

  // Mirrors `showDialog` (dialog.dart, SDK 3.44.7): root navigator, captured
  // themes, closed-loop traversal. `DialogRoute` resolves the barrier label
  // from MaterialLocalizations itself.
  final navigator = Navigator.of(context, rootNavigator: true);
  return navigator.push<T>(
    _BlurredDialogRoute<T>(
      context: context,
      builder: builder,
      themes: InheritedTheme.capture(from: context, to: navigator.context),
      barrierColor: scrim!.color,
      barrierDismissible: barrierDismissible,
      traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
      sigma: sigma,
    ),
  );
}

/// Shows a modal bottom sheet under [scrim]. See [showAppDialog] for how the
/// blur is implemented and why.
///
/// With `scrim == null` this is `showModalBottomSheet` verbatim.
Future<T?> showAppModalSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  ScrimStyle? scrim,
  bool isScrollControlled = false,
  bool showDragHandle = false,
  Color? backgroundColor,
}) {
  final sigma = scrim?.sigma ?? 0;
  if (sigma <= 0) {
    return showModalBottomSheet<T>(
      context: context,
      builder: builder,
      barrierColor: scrim?.color,
      isScrollControlled: isScrollControlled,
      showDragHandle: showDragHandle,
      backgroundColor: backgroundColor,
    );
  }

  // Mirrors `showModalBottomSheet` (bottom_sheet.dart, SDK 3.44.7) — note it
  // uses the NEAREST navigator, not the root one, unlike `showDialog`.
  final navigator = Navigator.of(context);
  final localizations = MaterialLocalizations.of(context);
  return navigator.push<T>(
    _BlurredModalBottomSheetRoute<T>(
      builder: builder,
      capturedThemes: InheritedTheme.capture(
        from: context,
        to: navigator.context,
      ),
      isScrollControlled: isScrollControlled,
      showDragHandle: showDragHandle,
      backgroundColor: backgroundColor,
      barrierLabel: localizations.scrimLabel,
      barrierOnTapHint: localizations.scrimOnTapHint(
        localizations.bottomSheetLabel,
      ),
      modalBarrierColor: scrim!.color,
      sigma: sigma,
    ),
  );
}

/// `DialogRoute` with [ModalRoute.filter] supplied. Nothing else differs.
///
/// `filter` is a final field on `ModalRoute` that `DialogRoute` does not
/// forward; a subclass may override the getter it induces, and
/// `_buildModalBarrier` dispatches to the override.
class _BlurredDialogRoute<T> extends DialogRoute<T> {
  _BlurredDialogRoute({
    required super.context,
    required super.builder,
    required double sigma,
    super.themes,
    super.barrierColor,
    super.barrierDismissible,
    super.traversalEdgeBehavior,
  }) : _filter = ImageFilter.blur(sigmaX: sigma, sigmaY: sigma);

  final ImageFilter _filter;

  @override
  ImageFilter? get filter => _filter;
}

/// `ModalBottomSheetRoute` with [ModalRoute.filter] supplied. See
/// [_BlurredDialogRoute].
class _BlurredModalBottomSheetRoute<T> extends ModalBottomSheetRoute<T> {
  _BlurredModalBottomSheetRoute({
    required super.builder,
    required super.isScrollControlled,
    required double sigma,
    super.capturedThemes,
    super.showDragHandle,
    super.backgroundColor,
    super.barrierLabel,
    super.barrierOnTapHint,
    super.modalBarrierColor,
  }) : _filter = ImageFilter.blur(sigmaX: sigma, sigmaY: sigma);

  final ImageFilter _filter;

  @override
  ImageFilter? get filter => _filter;
}
