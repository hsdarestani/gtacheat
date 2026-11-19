#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT/mobile"
[[ "$(uname -s)" == "Darwin" ]] || { echo "iOS requires macOS Publisher build agent"; exit 2; }
command -v flutter >/dev/null || { echo "Flutter SDK required"; exit 2; }
command -v xcodebuild >/dev/null || { echo "Xcode required"; exit 2; }
flutter create --platforms=android,ios --org=de.smarbiz --project-name=vicecodes .
flutter pub get
python3 scripts/create-icons.py
python3 scripts/patch-native-metadata.py
if [[ -z "${APPLE_TEAM_ID:-}" && -n "${IOS_TEAM_ID:-}" ]]; then export APPLE_TEAM_ID="$IOS_TEAM_ID"; fi
if [[ -z "${APPLE_TEAM_ID:-}" ]]; then echo "Missing Apple team ID in Publisher macOS signing payload."; exit 3; fi
python3 scripts/patch-ios-team.py
if [[ -f ios/ExportOptions.plist ]]; then
  flutter build ipa --release --export-options-plist=ios/ExportOptions.plist --build-name "${APP_VERSION_NAME:-1.0.0}" --build-number "${APP_BUILD_NUMBER:-1}"
else
  flutter build ipa --release --build-name "${APP_VERSION_NAME:-1.0.0}" --build-number "${APP_BUILD_NUMBER:-1}"
fi
echo "iOS IPA created in mobile/build/ios/ipa/"
