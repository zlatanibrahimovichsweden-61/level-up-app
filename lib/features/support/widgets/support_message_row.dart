import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/content_text_direction.dart';
import '../../../l10n/app_localizations.dart';
import '../../profile/widgets/avatar_disc.dart';

/// Who wrote a line of the thread.
enum SupportMessageAuthor {
  /// The signed-in student: named "You", wearing their own avatar.
  student,

  /// Customer Support: named "Customer Support", wearing the support avatar.
  /// The contract gives a staff reply no identity at all and says to show it
  /// as Customer support (`openapi.yaml:2769`, `:3972`).
  staff,
}

/// One line of a support thread · Figma `178:3410`: a 31 disc, a name in
/// SemiBold, and the text under it in full.
///
/// The thread's FIRST row is not a reply: it is the ticket's `details`, the
/// student's opening text, which the contract keeps out of the message list.
/// The caller passes it as a student row.
///
/// **The name is the label, never the server's.** A staff reply carries no
/// identity, so the name is the approved `profileCustomerSupport`; the
/// student's is the approved `leaderboardYou`. Nothing from a message other
/// than its own text is printed.
///
/// **An empty [body] draws the name only.** A reply made of photos alone (from
/// another client) has an empty `body`; there is no text to draw and no
/// placeholder for it.
///
/// **One semantics node**: the name and the text read together. The disc is an
/// image and is excluded, so the merged node is not an ImageView on Android.
///
/// **Content direction.** The text is written by a person, in whichever
/// language they chose, so it takes the direction of its first strong
/// character (BUG-020's rule); the row itself, the disc side included, follows
/// the app.
class SupportMessageRow extends StatelessWidget {
  const SupportMessageRow({
    super.key,
    required this.author,
    required this.body,
    this.avatarUrl,
  });

  final SupportMessageAuthor author;
  final String body;

  /// The student's own `avatar.url` from `GET /me`, or null while it has not
  /// loaded (or failed to). Ignored for a staff row.
  final String? avatarUrl;

  /// `178:3410`: a 31 disc, 13 before the column.
  static const _disc = 31.0;
  static const _discGap = 13.0;

  /// The staff avatar's drawn size inside the disc (`178:3424`: w 36, h 35).
  static const _staffWidth = 36.0;
  static const _staffHeight = 35.0;

  /// The name and the text sit 1 apart.
  static const _lineGap = 1.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    final name = switch (author) {
      SupportMessageAuthor.student => l10n.leaderboardYou,
      SupportMessageAuthor.staff => l10n.profileCustomerSupport,
    };

    return MergeSemantics(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeSemantics(
            child: AvatarDisc(
              size: _disc,
              child: switch (author) {
                SupportMessageAuthor.student => _StudentImage(url: avatarUrl),
                // Drawn at its frame size, 36 x 35, centred in the 31 disc and
                // clipped to it by the disc's own `ClipOval` (`178:3424` inside
                // `178:3423`) - not squeezed to 31. The disc hands its child a
                // tight 31 x 31, so the box has to be allowed to overflow it.
                SupportMessageAuthor.staff => OverflowBox(
                  minWidth: 0,
                  minHeight: 0,
                  maxWidth: _staffWidth,
                  maxHeight: _staffHeight,
                  child: Image.asset(
                    'assets/images/support_staff_avatar.png',
                    width: _staffWidth,
                    height: _staffHeight,
                    fit: BoxFit.cover,
                    excludeFromSemantics: true,
                  ),
                ),
              },
            ),
          ),
          const SizedBox(width: _discGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppType.h4.copyWith(color: ext.supportInk)),
                if (body.isNotEmpty) ...[
                  const SizedBox(height: _lineGap),
                  Text(
                    body,
                    textDirection: contentTextDirection(
                      body,
                      fallback: Directionality.of(context),
                    ),
                    style: AppType.bodyLarge.copyWith(color: ext.supportInk),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The student's avatar inside the disc: the profile header's cached-network
/// pattern. While it loads, when it fails, and while `GET /me` has not landed
/// (no URL) it draws nothing, so the disc's own gradient shows: a broken-image
/// icon where a student's own face should be is a worse failure than a plain
/// disc.
class _StudentImage extends StatelessWidget {
  const _StudentImage({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final url = this.url;
    if (url == null || url.isEmpty) return const SizedBox.shrink();

    return CachedNetworkImage(
      imageUrl: url,
      width: SupportMessageRow._disc,
      height: SupportMessageRow._disc,
      fit: BoxFit.cover,
      // Decode at the drawn size, not the source's (see home_header.dart).
      memCacheWidth:
          (SupportMessageRow._disc * MediaQuery.devicePixelRatioOf(context))
              .round(),
      placeholder: (_, _) => const SizedBox.shrink(),
      errorWidget: (_, _, _) => const SizedBox.shrink(),
    );
  }
}
