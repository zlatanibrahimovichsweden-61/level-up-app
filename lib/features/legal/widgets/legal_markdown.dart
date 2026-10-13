import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown/markdown.dart' as md;

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../legal_links.dart';

/// Renders a served legal document's `contentMarkdown` — all of it, in order,
/// exactly as served, its own `# ` title line included (owner C3/D4,
/// 2026-10-10: the text is neither edited, shortened nor summarised here).
///
/// **Untrusted input.** The text comes from the server, so:
/// - raw HTML is never interpreted. It shows as the literal characters that
///   were served, a block as well as a tag inside a line (the package would
///   otherwise drop an HTML block and its words with it);
/// - images are never loaded: no URL in the text can make the app fetch from
///   the network or read a file. An image's alt text stands in for it, in the
///   line or the heading where the image was, so no words are lost;
/// - a link opens only through [openLegalLink] (https or mailto, outside the
///   app).
/// The documents served today have no HTML, images or links (staging,
/// 2026-10-08); these are fences for later text.
///
/// **Styling (owner D3).** There is no Figma frame for this screen yet (DG-05,
/// NEW FRAME REQUIRED), so the body is drawn from the existing type scale and
/// theme only — no new token and no colour of its own: headings use the screen
/// title styles, text the body styles, rules and table lines the theme's
/// Material divider role (`ColorScheme.outlineVariant`). It is an interim for
/// the designer to replace, not an approved design.
///
/// **Direction.** Arabic is laid out right-to-left by the ambient
/// [Directionality]. Two package defaults are physical rather than
/// directional and are overridden: table cells (left-aligned unless the table
/// says otherwise) and list markers (a right-hand gap).
class LegalMarkdown extends ConsumerWidget {
  const LegalMarkdown({super.key, required this.data});

  /// The served `contentMarkdown`, verbatim.
  final String data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ext = Theme.of(context).extension<AppColors>()!;
    final rule = Theme.of(context).colorScheme.outlineVariant;
    final body = AppType.bodyMedium.copyWith(color: ext.textSecondary);

    return MarkdownBody(
      data: data,
      // A lone newline inside a paragraph is a space, as Markdown says: the
      // served text is wrapped at ~120 columns, sometimes inside **bold**.
      softLineBreak: false,
      extensionSet: _extensions,
      blockSyntaxes: const [_LiteralHtmlBlockSyntax()],
      onTapLink: (_, href, _) =>
          openLegalLink(ref.read(legalLinkLauncherProvider), href),
      bulletBuilder: (parameters) => _ListMarker(parameters, style: body),
      builders: {
        // The document's own heading is the page's visible title (C3), so it
        // also names the route for a screen reader; every heading is
        // announced as one.
        'h1': _Heading(namesRoute: true),
        for (final tag in const ['h2', 'h3', 'h4', 'h5', 'h6'])
          tag: _Heading(namesRoute: false),
        // An image is never loaded: its alt text is set in the line instead.
        // A builder rather than `imageBuilder`, which the package skips (and
        // so drops the alt text) when the address does not parse.
        'img': _AltText(),
      },
      styleSheet: MarkdownStyleSheet(
        h1: AppType.h2.copyWith(color: ext.textPrimary),
        h2: AppType.h3.copyWith(color: ext.textPrimary),
        h3: AppType.h4.copyWith(color: ext.textPrimary),
        h4: AppType.h4.copyWith(color: ext.textPrimary),
        h5: AppType.h4.copyWith(color: ext.textPrimary),
        h6: AppType.h4.copyWith(color: ext.textPrimary),
        p: body,
        strong: AppType.bodyMediumStrong.copyWith(color: ext.textPrimary),
        a: body.copyWith(
          color: ext.link,
          decoration: TextDecoration.underline,
          decorationColor: ext.link,
        ),
        listBullet: body,
        listBulletPadding: EdgeInsets.zero,
        // The marker column grows with the text, so "10." still fits on one
        // line at a large text size (the package keeps it at 24 dp).
        listIndent: MediaQuery.textScalerOf(context).scale(24),
        tableHead: AppType.labelLarge.copyWith(color: ext.textPrimary),
        tableBody: body,
        tableBorder: TableBorder.all(color: rule),
        tableCellsPadding: const EdgeInsets.all(8),
        tableHeadCellsPadding: const EdgeInsets.all(8),
        blockSpacing: 12,
        blockquoteDecoration: const BoxDecoration(),
        horizontalRuleDecoration: BoxDecoration(
          border: Border(top: BorderSide(color: rule)),
        ),
      ),
    );
  }
}

/// The parser of GitHub-flavoured Markdown (the package's default), with its
/// table syntax swapped for [_StartAlignedTableSyntax]. Swapped, not added:
/// two table syntaxes that both decline a malformed table (a header whose
/// column count differs from its delimiter row) leave the parser with no way
/// forward, and it throws — so one typo in a served table would have taken the
/// whole document down. With one, such a table reads as a paragraph.
final _extensions = md.ExtensionSet([
  for (final syntax in md.ExtensionSet.gitHubFlavored.blockSyntaxes)
    syntax is md.TableSyntax ? const _StartAlignedTableSyntax() : syntax,
], md.ExtensionSet.gitHubFlavored.inlineSyntaxes);

/// A heading as its own text with header semantics: every word of it, image
/// alt text included, in order.
///
/// The package hands every piece of text inside a heading to this builder.
/// Each gets a placeholder so the package's own bookkeeping for inline
/// elements (a footnote mark, a link) still has a widget to work on; the
/// heading itself is then drawn whole from the element.
class _Heading extends MarkdownElementBuilder {
  _Heading({required this.namesRoute});

  final bool namesRoute;

  @override
  Widget? visitText(md.Text text, TextStyle? preferredStyle) =>
      const SizedBox.shrink();

  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) => Semantics(
    header: true,
    namesRoute: namesRoute ? true : null,
    child: Text(_words(element), style: preferredStyle),
  );

  static String _words(md.Node node) => switch (node) {
    md.Element(tag: 'img', :final attributes) => attributes['alt'] ?? '',
    md.Element(:final children) =>
      (children ?? const <md.Node>[]).map(_words).join(),
    _ => node.textContent,
  };
}

/// An image's alt text, set in the line where the image was; nothing is
/// fetched or read.
class _AltText extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    final alt = element.attributes['alt'] ?? '';
    return alt.isEmpty
        ? const SizedBox.shrink()
        : Text.rich(TextSpan(text: alt, style: parentStyle));
  }
}

/// The list marker, with its gap on the side facing the text in both
/// directions (the package's default pads the right-hand side only).
/// Numbering is the package's own: the item's position, from 1.
class _ListMarker extends StatelessWidget {
  const _ListMarker(this.parameters, {required this.style});

  final MarkdownBulletParameters parameters;
  final TextStyle style;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(end: 4),
    child: Text(
      parameters.style == BulletStyle.unorderedList
          ? '•'
          : '${parameters.index + 1}.',
      textAlign: parameters.style == BulletStyle.unorderedList
          ? TextAlign.center
          : TextAlign.end,
      // A clause number is never split over two lines.
      maxLines: 1,
      softWrap: false,
      overflow: TextOverflow.visible,
      style: style,
    ),
  );
}

/// GitHub-flavoured tables whose columns carry no alignment of their own read
/// from the START edge, so Arabic cells sit on the right. The package
/// otherwise left-aligns them in both directions. Only the layout hint changes;
/// every cell's text is exactly as served.
class _StartAlignedTableSyntax extends md.TableSyntax {
  const _StartAlignedTableSyntax();

  @override
  md.Node? parse(md.BlockParser parser) {
    final table = super.parse(parser);
    if (table is md.Element) _alignStart(table);
    return table;
  }

  static void _alignStart(md.Element element) {
    final children = element.children;
    if (children == null) return;
    for (final child in children) {
      if (child is! md.Element) continue;
      if (child.tag == 'th' || child.tag == 'td') {
        // Not one of the package's left/center/right, so it falls back to
        // TextAlign.start.
        child.attributes.putIfAbsent('align', () => 'start');
      }
      _alignStart(child);
    }
  }
}

/// An HTML block (`<div>…`, `<script>…`, a comment) becomes a paragraph of its
/// own literal characters instead of a node the package drops: nothing the
/// server sent is interpreted, and nothing it sent disappears.
class _LiteralHtmlBlockSyntax extends md.HtmlBlockSyntax {
  const _LiteralHtmlBlockSyntax();

  @override
  md.Node parse(md.BlockParser parser) => md.Element('p', [
    md.UnparsedContent(super.parse(parser).textContent.trim()),
  ]);
}
