import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/content_text_direction.dart';
import '../../../core/widgets/elevation/elevated_surface.dart';

/// The flashcard · Figma `247:3260` (instance in `225:5582`), a light object on
/// BOTH canvases.
///
/// One card that turns over: a tap flips between the question ([front]) and the
/// answer ([back]). The parent owns [flipped] (so "each new card starts on its
/// front" is the parent giving a new card a fresh widget), and this widget only
/// animates to whatever it is told.
///
/// **The flip.** A 300 ms ease-out rotation about the vertical axis (the
/// frame's Smart Animate, ease-out 0.3 s). The face is swapped at the half-way
/// point, when the card is edge-on, and the back face is turned a further half
/// turn about the same axis so that it reads the right way round: the frame's
/// back face is "pre-mirrored" for exactly this reason (`I247:3260;246:3235`,
/// `scaleX -1`). Under [MediaQuery.disableAnimations] the card jumps to the
/// other face instead of turning.
///
/// **Faces.** The frame draws one 454-tall surface with an inner shadow
/// (`flashcardCardShadows`) over both faces, so there is one surface here too
/// and only its content is swapped.
///
/// - Front, with an image ([imageUrl] non-null): the image box, then the text 43
///   under it. Every card is image-less today (`imageUrl` is `null` in every
///   environment), so this is the path a future CDN switches on.
/// - Front, without one: the text centred in the card.
/// - Back: [back] as a wrapping multi-line block. The contract says it is free
///   text that may hold SEVERAL answers, so it is never a single label.
///
/// Text that does not fit scrolls inside the card; it is never clipped and
/// never overflows.
///
/// **Direction is each face's own** ([contentTextDirection]): a card is
/// lecture content, in either language whatever the app's, and laid out in the
/// app's direction its closing "?" or "." landed at the wrong end of the line
/// (BUG-020). Both faces stay centred, so only the order within a line
/// changes.
///
/// **Semantics.** The whole card is ONE button node, labelled with the text of
/// the face that is showing; tapping it flips it. Nothing inside is separately
/// focusable, so a screen reader hears the card and not its parts.
class FlashcardFlipCard extends StatefulWidget {
  const FlashcardFlipCard({
    super.key,
    required this.front,
    required this.back,
    required this.flipped,
    required this.onFlip,
    this.imageUrl,
  });

  /// The prompt side (`FlashcardCard.front`).
  final String front;

  /// The answer side (`FlashcardCard.back`) — free multi-line text.
  final String back;

  /// `FlashcardCard.imageUrl`. Null means no image box is drawn at all.
  final String? imageUrl;

  /// Which face is up. The card animates to it when this changes.
  final bool flipped;

  /// Called on a tap. Null makes the card inert (a grade is in flight) — it
  /// still shows its face, it just does not turn — and reads as disabled to a
  /// screen reader.
  final VoidCallback? onFlip;

  /// The frame's corner radius (`I247:3260;246:3237`), the same on both
  /// canvases, so it stays here rather than becoming a token.
  static const radius = 20.0;

  /// The frame's turn: Smart Animate, ease-out, 0.3 s.
  static const flipDuration = Duration(milliseconds: 300);

  /// The frame's image box height (`image 71`, 348 x 223).
  static const imageHeight = 223.0;

  /// The frame's column sits 25 under the card's top edge.
  static const imageTop = 25.0;

  /// Image box to text.
  static const imageToText = 43.0;

  /// The frame's column is 348 wide inside a 363 card: 15 less than the card.
  /// Centred here (7.5 each side); the frame seats it 5 / 10, which reads as a
  /// resize artefact of the 358 -> 363 override.
  static const sideInset = 7.5;

  /// A little perspective, so the turn reads as a card and not as a flat squash.
  /// The frame states none; this is the subtlest value that shows depth.
  static const _perspective = 0.001;

  @override
  State<FlashcardFlipCard> createState() => _FlashcardFlipCardState();
}

class _FlashcardFlipCardState extends State<FlashcardFlipCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _turn;

  /// Set when the image could not be loaded: the image box, its top margin and
  /// the gap under it all collapse, and the front reads as an image-less card.
  bool _imageFailed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: FlashcardFlipCard.flipDuration,
      value: widget.flipped ? 1 : 0,
    );
    // Ease-out both ways: the reverse turn is the mirror image in time, so it
    // decelerates into the front face just as the forward one does into the
    // back.
    _turn = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeOut.flipped,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reduced motion switched on mid-turn: land on the target face now.
    if (MediaQuery.disableAnimationsOf(context) && _controller.isAnimating) {
      _controller.value = widget.flipped ? 1 : 0;
    }
  }

  @override
  void didUpdateWidget(FlashcardFlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) _imageFailed = false;
    if (oldWidget.flipped == widget.flipped) return;

    if (MediaQuery.disableAnimationsOf(context)) {
      // Instant: no turn at all, the other face is simply there.
      _controller.value = widget.flipped ? 1 : 0;
    } else if (widget.flipped) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _turn.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;
    // The face that is (or is turning to be) up, not the one mid-turn.
    final label = widget.flipped ? widget.back : widget.front;

    return Semantics(
      container: true,
      button: true,
      enabled: widget.onFlip != null,
      label: label,
      // The label's own direction, as its face lays it out.
      textDirection: _directionOf(label),
      onTap: widget.onFlip,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onFlip,
        child: AnimatedBuilder(
          animation: _turn,
          builder: (context, _) {
            final progress = _turn.value;
            final showBack = progress >= 0.5;
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, FlashcardFlipCard._perspective)
                ..rotateY(math.pi * progress),
              child: ElevatedSurface(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(FlashcardFlipCard.radius),
                ),
                color: ext.flashcardCardFill,
                shadows: elevation.flashcardCardShadows,
                child: showBack ? _backFace(ext) : _frontFace(ext),
              ),
            );
          },
        ),
      ),
    );
  }

  TextDirection _directionOf(String text) =>
      contentTextDirection(text, fallback: Directionality.of(context));

  Widget _frontFace(AppColors ext) {
    final text = Text(
      widget.front,
      textDirection: _directionOf(widget.front),
      textAlign: TextAlign.center,
      // The frame sets Inter Bold 25 / 25.6; the scale's nearest is h1 (24/30).
      style: AppType.h1.copyWith(color: ext.flashcardCardText),
    );

    final url = widget.imageUrl;
    if (url == null || _imageFailed) return _CenteredScroll(child: text);

    return LayoutBuilder(
      builder: (context, box) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          FlashcardFlipCard.sideInset,
          FlashcardFlipCard.imageTop,
          FlashcardFlipCard.sideInset,
          FlashcardFlipCard.imageTop,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              url,
              width: box.maxWidth - 2 * FlashcardFlipCard.sideInset,
              height: FlashcardFlipCard.imageHeight,
              fit: BoxFit.cover,
              // The card's own semantics name it; the contract carries no alt
              // text for the picture, so there is nothing more to say.
              excludeFromSemantics: true,
              errorBuilder: (context, error, stackTrace) {
                // Collapses to nothing rather than a broken-image glyph — and
                // takes the box's margin and gap with it. Nothing about the
                // failure (URL, error) is kept or logged.
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted && !_imageFailed) {
                    setState(() => _imageFailed = true);
                  }
                });
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: FlashcardFlipCard.imageToText),
            text,
          ],
        ),
      ),
    );
  }

  Widget _backFace(AppColors ext) {
    return Transform(
      // The half turn that undoes the mirroring the parent's rotation gives
      // this face once it is past edge-on.
      alignment: Alignment.center,
      transform: Matrix4.rotationY(math.pi),
      child: _CenteredScroll(
        child: Text(
          widget.back,
          textDirection: _directionOf(widget.back),
          textAlign: TextAlign.center,
          // The frame's 55 dp single word; the scale's largest is
          // displayLarge (28/34), and a multi-line answer needs to wrap in it.
          style: AppType.displayLarge.copyWith(color: ext.flashcardCardText),
        ),
      ),
    );
  }
}

/// Centres [child] in the card, and lets it scroll when it is taller than the
/// card instead of overflowing.
class _CenteredScroll extends StatelessWidget {
  const _CenteredScroll({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: box.maxHeight),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: FlashcardFlipCard.sideInset,
                vertical: FlashcardFlipCard.imageTop,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
