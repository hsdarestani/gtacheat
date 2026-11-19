#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT/mobile"

[[ "$(uname -s)" == "Darwin" ]] || { echo "iOS requires the Publisher macOS runner"; exit 2; }
command -v flutter >/dev/null || { echo "Flutter SDK required"; exit 2; }
command -v xcodebuild >/dev/null || { echo "Xcode required"; exit 2; }
command -v security >/dev/null || { echo "macOS Security CLI required"; exit 2; }

# Publisher creates, installs and validates Distribution signing in its own
# ephemeral keychain. Keep all secret material out of git and the shell log.
if [[ -z "${APPLE_TEAM_ID:-}" && -n "${IOS_TEAM_ID:-}" ]]; then export APPLE_TEAM_ID="$IOS_TEAM_ID"; fi
[[ -n "${APPLE_TEAM_ID:-}" ]] || { echo "Publisher Apple team missing"; exit 3; }
[[ "${IOS_SIGNING_STYLE:-}" == "Manual" ]] || { echo "Publisher manual signing configuration missing"; exit 3; }
[[ -n "${IOS_PROVISIONING_PROFILE_SPECIFIER:-}" ]] || { echo "Publisher App Store provisioning profile missing"; exit 3; }
[[ -n "${IOS_SIGNING_KEYCHAIN:-}" && -f "$IOS_SIGNING_KEYCHAIN" ]] || { echo "Publisher ephemeral signing keychain missing"; exit 3; }
[[ "${IOS_BUNDLE_ID:-de.smarbiz.vicecodes}" == "de.smarbiz.vicecodes" ]] || { echo "Unexpected iOS bundle identifier"; exit 3; }

if ! security find-identity -v -p codesigning "$IOS_SIGNING_KEYCHAIN" | grep -q 'Apple Distribution'; then
  echo "Apple Distribution identity not available in Publisher keychain"
  exit 3
fi

flutter create --platforms=android,ios --org=de.smarbiz --project-name=vicecodes .
flutter pub get
python3 scripts/create-icons.py
python3 scripts/patch-native-metadata.py

# Flutter's "build ipa" performs a device-development-certificate preflight that
# fails on an otherwise valid distribution-only ephemeral keychain. Compile
# the Flutter iOS output without signing, then archive & export explicitly via
# Xcode with the Publisher-managed Apple Distribution identity and profile.
flutter build ios --release --no-codesign \
  --build-name "${APP_VERSION_NAME:-1.0.0}" \
  --build-number "${APP_BUILD_NUMBER:-1}"
# Flutter may regenerate the Xcode project during unsigned compilation.
# Apply manual Distribution signing afterwards, only to the Runner project.
python3 scripts/patch-ios-team.py
[[ -f ios/ExportOptions.plist ]] || { echo "Manual App Store export settings missing"; exit 3; }

mkdir -p build/ios/archive build/ios/ipa
# The Runner target already has manual signing/profile in its Xcode project.
# Do NOT pass PROVISIONING_PROFILE_SPECIFIER as a global build setting,
# because Swift Package targets cannot use app provisioning profiles.
xcodebuild -workspace ios/Runner.xcworkspace \
  -scheme Runner -configuration Release \
  -destination 'generic/platform=iOS' \
  -archivePath build/ios/archive/Runner.xcarchive \
  archive \
  "DEVELOPMENT_TEAM=$APPLE_TEAM_ID" \
  "OTHER_CODE_SIGN_FLAGS=--keychain $IOS_SIGNING_KEYCHAIN"

xcodebuild -exportArchive \
  -archivePath build/ios/archive/Runner.xcarchive \
  -exportPath build/ios/ipa \
  -exportOptionsPlist ios/ExportOptions.plist

shopt -s nullglob
files=(build/ios/ipa/*.ipa)
[[ ${#files[@]} -gt 0 ]] || { echo "Signed IPA export missing"; exit 4; }
echo "Vice Codes signed iOS IPA exported to mobile/build/ios/ipa/"
