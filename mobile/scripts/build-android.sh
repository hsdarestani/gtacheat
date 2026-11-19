#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT/mobile"
command -v flutter >/dev/null || { echo "Flutter SDK required on Publisher Linux agent"; exit 2; }
command -v python3 >/dev/null || { echo "Python 3 required"; exit 2; }
flutter create --platforms=android,ios --org=de.smarbiz --project-name=vicecodes .
flutter pub get
python3 scripts/create-icons.py
if [[ -z "${ANDROID_KEYSTORE_BASE64:-}" || -z "${ANDROID_KEYSTORE_PASSWORD:-}" || -z "${ANDROID_KEY_ALIAS:-}" || -z "${ANDROID_KEY_PASSWORD:-}" ]]; then
  echo "Android release signing environment variables missing. Configure encrypted signing material in Publisher agent."
  exit 3
fi
printf "%s" "$ANDROID_KEYSTORE_BASE64" | base64 --decode > android/app/upload-keystore.jks
chmod 600 android/app/upload-keystore.jks
trap 'rm -f android/app/upload-keystore.jks' EXIT
python3 scripts/patch-gradle.py
flutter build appbundle --release --build-name "${APP_VERSION_NAME:-1.0.0}" --build-number "${APP_BUILD_NUMBER:-1}"
echo "Android AAB created in mobile/build/app/outputs/bundle/release/"
