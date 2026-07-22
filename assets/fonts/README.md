# Fonts — drop the .ttf files here

`pubspec.yaml` declares these **10 files**. The app will not build until they exist
in this folder (a declared font asset that's missing is a build error). All three
families are open-source (OFL) and free to bundle.

## Required files (exact names — must match pubspec)

| Family | Files | Weights |
|---|---|---|
| **Inter** | `Inter_18pt-Regular.ttf` `Inter_18pt-Medium.ttf` `Inter_18pt-SemiBold.ttf` `Inter_18pt-Bold.ttf` | 400 / 500 / 600 / 700 |
| **Tajawal** | `Tajawal-Regular.ttf` `Tajawal-Medium.ttf` `Tajawal-Bold.ttf` | 400 / 500 / 700 |
| **Cairo** | `Cairo-Regular.ttf` `Cairo-SemiBold.ttf` `Cairo-Bold.ttf` | 400 / 600 / 700 |

> Inter ships optical sizes — use the **18pt** static files (the UI size). Ignore the
> variable-font files, italics, and the 24pt/28pt sets.

## Where to get them

1. https://fonts.google.com/specimen/Inter → "Get font" → "Download all" → unzip.
2. https://fonts.google.com/specimen/Tajawal → same.
3. https://fonts.google.com/specimen/Cairo → same.

Modern Google Fonts downloads ship a **variable** `.ttf` plus a **`static/`** subfolder
with the individual weights. Copy the **static** weight files listed above into this
folder and rename if needed so the names match the table exactly (e.g. the static
`Inter_18pt-Regular.ttf` → `Inter-Regular.ttf`).

## Why bundled, not `google_fonts`

- No runtime download — instant first paint, works offline (Egyptian networks).
- Deterministic: the exact weights the design uses, no CDN dependency.
- Arabic coverage: Inter has no Arabic glyphs; `app_theme.dart` falls Arabic back to
  Tajawal automatically.

After adding the files: `flutter pub get` then `flutter run -t lib/main_dev.dart`.
