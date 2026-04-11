# ProxDroid

**A modern, open-source Android client for Proxmox Virtual Environment (PVE)**

![CI](https://github.com/mdg-labs/proxdroid/actions/workflows/ci.yml/badge.svg)
![Release APK](https://github.com/mdg-labs/proxdroid/actions/workflows/build.yml/badge.svg)

ProxDroid fills the gap of high-quality, modern Proxmox VE clients on Android. Built with Flutter and Material 3, it offers VM and container management, real-time resource charts, multi-server support, and a clean dark-theme UI.

---

## Features

- Multi-server support — add and switch between multiple PVE instances
- API token and username/password authentication
- Self-signed SSL certificate support (mandatory for homelab setups)
- Node overview with CPU and RAM usage
- VM and LXC container list with live status indicators
- Start, Stop, Force Stop, and Reboot actions for VMs and containers
- Real-time CPU, RAM, Network I/O, and Disk I/O charts
- Storage overview and backup list
- Task viewer with log output
- Dark theme by default (light theme optional)
- Localization-ready (English base, ARB files)

---

## Download

**GitHub Releases:** Prebuilt APKs are attached as **`proxdroid-<tag>.apk`** (for example `proxdroid-v1.0.0-beta.12+1.apk`, matching the `version:` line in `pubspec.yaml`). See [Releases](https://github.com/mdg-labs/proxdroid/releases).

- **Beta:** push to the **`beta`** branch with a change to **`pubspec.yaml`**. The version must include **`-beta`**. If the Git tag `v<version>` does not exist yet, [Release APK](https://github.com/mdg-labs/proxdroid/actions/workflows/build.yml) builds a signed APK, creates the tag, and publishes a **pre-release** (release notes: commits since the previous tag).
- **Stable:** push to **`main`** with a **`pubspec.yaml`** change. The version must **not** include `-beta`. If the tag is new, CI publishes a **draft** release (aggregate notes from beta pre-releases in that cycle); publish the draft on GitHub when ready — it becomes **latest** then.

**Play Store** and **F-Droid** are planned but not available yet.

Maintainers: keep `CHANGELOG.md` updated; release bodies are generated in CI as above (edit the stable draft on GitHub before publishing if needed).

---

## Setup Instructions

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel, 3.x or later)
- Android SDK (API 26+)
- Dart (included with Flutter)

### Steps

```bash
git clone https://github.com/mdg-labs/proxdroid.git
cd proxdroid
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for local setup, code style, PR process, and commit conventions.

### HTTPS proxies and Cloudflare Tunnel

The app uses Proxmox’s JSON API at **`/api2/json/`**. If you use a reverse proxy or Cloudflare Tunnel, that path must reach Proxmox (see [CONTRIBUTING.md](CONTRIBUTING.md)). For clearer errors when adding a server, use **Settings → Troubleshooting → Verbose connection errors**.

**Release APKs** must include the `INTERNET` permission in `android/app/src/main/AndroidManifest.xml`. If every connection fails with DNS-style errors on a sideloaded build but **debug** works, check that permission is in the **main** manifest (not only under `src/debug/`).

---

## License

MIT — see [LICENSE](LICENSE) for details.
