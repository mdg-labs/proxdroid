# Android release signing (maintainers)

Release APKs must be signed with **one fixed upload keystore** so installs from GitHub (e.g. Obtanium) can **update in place**. CI previously used the **debug** keystore, which is not stable across GitHub runners, so every build had a different signature.

## One-time: create the keystore (on your machine)

From the repo root:

```bash
keytool -genkey -v \
  -keystore android/proxdroid-release.jks \
  -alias upload \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000
```

- Choose a strong keystore password and key password (you can use the same for both while learning; use distinct passwords for production).
- **Back up `android/proxdroid-release.jks`** somewhere safe (password manager + encrypted backup). If you lose it, you cannot ship updates to the same app id on Play; users would need to uninstall.

Files `*.jks` and `key.properties` are **gitignored** — never commit them.

## One-time: local `key.properties` (optional, for local `flutter build apk --release`)

Create `android/key.properties` (same folder as `android/build.gradle.kts`’s siblings — the **`android/`** directory):

```properties
storePassword=your-keystore-password
keyPassword=your-key-password
keyAlias=upload
storeFile=proxdroid-release.jks
```

Put `proxdroid-release.jks` in **`android/`** (next to `key.properties`).

## One-time: GitHub Actions secrets

Repository → **Settings → Secrets and variables → Actions → New repository secret**:

| Secret | Value |
|--------|--------|
| `KEYSTORE_BASE64` | Base64 of the **entire** `.jks` file (no newlines in the secret value) |
| `KEYSTORE_PASSWORD` | Keystore password |
| `KEY_PASSWORD` | Key password |
| `KEY_ALIAS` | `upload` (or whatever `-alias` you used) |

**Encode the keystore (Linux):**

```bash
base64 -w0 android/proxdroid-release.jks
```

Copy the single line into `KEYSTORE_BASE64`.

**macOS:**

```bash
base64 -i android/proxdroid-release.jks | tr -d '\n'
```

After secrets exist, **Build release APK** on a beta tag will write `android/proxdroid-release.jks` and `android/key.properties` on the runner, then build a **release-signed** APK.

## First install after switching signing

Anyone who installed an older APK signed with a **different** key (e.g. old CI debug signing or your local debug build) must **uninstall once**, then install the new signed APK. After that, **in-place updates** should work for all future builds signed with this keystore.

## If CI fails with “Set GitHub Actions secrets”

Add all four secrets above. The workflow fails fast if `KEYSTORE_BASE64` is missing so you do not accidentally publish another randomly signed APK.
