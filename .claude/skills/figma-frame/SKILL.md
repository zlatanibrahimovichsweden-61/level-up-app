---
name: figma-frame
description: Pull a Figma frame and its design tokens via the Figma MCP and implement Level Up UI to them exactly. Use this skill whenever a figma.com URL appears, whenever the user asks to implement/match/check a design, screen, or frame, and whenever choosing colors, spacing, radii, or text styles for any Level Up widget — tokens must come from Figma, never be eyeballed or invented.
---

# Figma Frame → Flutter (tokens, never eyeballed values)

The Level Up rule is "design tokens, never one-off values". A hex code guessed from a screenshot looks right until the designer updates the palette and half the app doesn't follow. Tokens flow: Figma variables → `core/theme/app_theme.dart` (Material 3) → widgets. Widgets never hold raw values.

## Pulling a frame

1. Extract `fileKey` and `nodeId` from the URL (`figma.com/design/:fileKey/...?node-id=X-Y` → nodeId `X:Y`). No node-id in the URL → ask for a frame-specific link; don't guess.
2. `get_screenshot` first for visual ground truth (the Level Up file is huge — never pull the root node's design context).
3. `get_design_context` on the specific frame for structure, and `get_variable_defs` for the token values it uses.
4. Reference code returned by the MCP is web-oriented — treat it as a spec (spacing, hierarchy, states), not as code to port literally.

## Mapping to the app

- **Colors/typography/spacing/radii** → check `app_theme.dart` first. Token already mapped → use the theme reference. New token → add it to the theme with the Figma variable's name, then use it. Never inline the raw value at the call site.
- **Components** → reuse `core/widgets/` shared components before creating new ones; a new recurring pattern belongs in core, not copy-pasted per feature.
- **Assets** (illustrations, icons) → download via the MCP into `assets/`, declare in `pubspec.yaml`. Direction-semantic icons need RTL mirroring.
- **Track/theme variants:** the file carries light + dark canvases and School (green) / University (purple) accents. Map these to theme variants — never branch on hardcoded colors in widgets.

## What the frame does NOT tell you

Stay honest about gaps instead of inventing:

- Frames are LTR/EN unless an AR frame exists — the RTL layout is derived by the directional rules (`screen-states` skill), not by mirroring pixel positions manually.
- Missing state designs (empty/offline/skeleton) → use the shared `StateWidget` defaults and flag the gap to the designer; don't invent bespoke visuals.
- Interaction details (pressed/disabled, motion) absent from the frame → Material 3 defaults + flag.

## Done means

Widget matches the frame's layout and tokens · every value traces to a theme token · gaps between design and implementation listed explicitly for the designer/user rather than silently patched.
