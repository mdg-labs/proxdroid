# Launcher icon sources (PNG)

[`flutter_launcher_icons`](https://pub.dev/packages/flutter_launcher_icons) only accepts **PNG** (or a hex color for the Android adaptive **background**). SVGs in this folder are for design reference only until you export PNGs.

## What to add (one-time)

| File | Role |
|------|------|
| **`proxdroid_launcher_icon.png`** | **Full** icon (background + droid), square. Used for **iOS** and as the main raster. Typical size **1024×1024** px. |
| **`proxdroid_icon_foreground.png`** | **Android adaptive foreground** only: droid on a **transparent** background. Same canvas size (e.g. 1024×1024); keep important content in the center **~66%** “safe zone” so OEM masks do not clip it. |

You do **not** need a separate background PNG unless you want a **non-flat** adaptive background (gradient, texture). Right now `pubspec.yaml` uses a solid **`#0D1117`** adaptive background instead.

## After the two PNGs exist

From the project root:

```bash
dart run flutter_launcher_icons
```

That overwrites the generated launcher assets under `android/` and `ios/`. Commit those native changes together with the PNGs (or keep PNGs private and only commit generated `mipmap` / `AppIcon` — your choice).
