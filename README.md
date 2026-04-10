# ProxDroid

**A modern, open-source Android client for Proxmox Virtual Environment (PVE)**

![CI](https://github.com/mdg-labs/proxdroid/actions/workflows/ci.yml/badge.svg)

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

Coming soon — Play Store, F-Droid, GitHub Releases

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

---

## License

MIT — see [LICENSE](LICENSE) for details.
