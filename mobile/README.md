# Vice Codes — Mobile release through A+ Publisher

Project: https://github.com/hsdarestani/gtacheat
Live web app (unchanged): https://gta.smarbiz.sbs/
Publisher portal: https://publisher.smarbiz.sbs/apps/
Publisher source: https://github.com/hsdarestani/publisher

## What has been created

This repository now contains a **real Flutter app**, not a WebView wrapper. It bundles 19 researched GTA VI direction sequences in `mobile/assets/cheats.json`. It works without a login or data connection and includes native filters, search, Favorites, completion tracking, clipboard and share functionality. Its UI and launcher icon are original; it does not package Rockstar screenshots.

Flutter native `android/` and `ios/` folders are generated in the build job using `flutter create`; they are intentionally ignored in git so signing keys and generated build files are never committed. The build scripts create these on demand.

## Register this as a NEW Publisher app

**Important: this record has not been created in Publisher yet.** The admin UI requires login, and no authenticated admin session is available to this workflow.

After signing in, open **https://publisher.smarbiz.sbs/apps/new/**. Use the values in [`.publisher/vice-codes.json`](../.publisher/vice-codes.json):

| Field | Value |
| --- | --- |
| Name | Vice Codes |
| Slug | `vice-codes` |
| Platform | Android + iOS |
| Framework | Flutter |
| Android package / iOS bundle | `de.smarbiz.vicecodes` |
| Repository | `https://github.com/hsdarestani/gtacheat` |
| Branch | `main` |
| Status | Setup |
| Requires login | No |
| Google track for first release | Internal |
| Version / build | 1.0.0 / 1 |
| Auto-submit | False |

Paste this **build_config** into the app configuration field:

```json
{
  "android_command": "bash mobile/scripts/build-android.sh",
  "android_artifact": "mobile/build/app/outputs/bundle/release/*.aab",
  "ios_command": "bash mobile/scripts/build-ios.sh",
  "ios_artifact": "mobile/build/ios/ipa/*.ipa",
  "env": {}
}
```

Save the app. Link the existing Google and Apple Store accounts **only if they actually own the new app identifiers**. Both the Google Play Console and App Store Connect may require creating the **first app listing** and accepting one-time agreements. Add the `de-DE` localization from the JSON preset. Set a correct GDPR privacy policy URL and support URL before submission.

## Native build prerequisites

- **Android:** A+ Publisher creates/manages an encrypted upload signing key and supplies it to the job-scoped Linux Cloud Agent. The Android build script accepts the key from `ANDROID_KEYSTORE_PATH` or `ANDROID_KEYSTORE_BASE64` plus the three Publisher-provided key alias/password variables. The Gradle build refuses unsigned release bundles.
- **iOS:** A+ Publisher's macOS agent must have current Flutter, CocoaPods, Xcode, a distribution certificate and a matching provisioning profile for `de.smarbiz.vicecodes`. Publisher's Mac supplies `IOS_TEAM_ID` and `IOS_PROVISIONING_PROFILE_SPECIFIER`; the iOS build script applies them to the generated Xcode project and sets an App Store export options plist. If the Cloud Mac workflow lacks Flutter, it must be installed there before the build job.
- `mobile/scripts/create-icons.py` generates the original 1024px PNG store icon and platform app icons without external image dependencies.
- `mobile/scripts/patch-native-metadata.py` sets the device-displayed name to **Vice Codes**.

## QA

`mobile-ci.yml` runs Flutter static analysis, Flutter tests (source data, search and German UI title), original icon generation and **unsigned Android debug APK** smoke-build. CI success demonstrates that the source builds, not that a store-signed AAB/IPA or store submission has been completed.

## Store readiness blockers

1. Publisher new-app record and account linking, plus a verified signing identity for each store.
2. Google Play + App Store Connect first app records and app/legal agreements.
3. App privacy-policy URL with the **actual** legal publisher name and contact information (not supplied; intentionally left blank).
4. Genuine iOS/Android screenshots, store icon uploads, content ratings, age rating, and store declarations.
5. Signed AAB and IPA from Publisher's build agents, then device QA and internal testing.
6. Legal review of GTA/Rockstar trademark use and verification of cheat-code functionality. The current app is a **nonaffiliated fan guide**, but the app-store reviewer may require a more independent presentation or additional native utility.
7. Only after passing the readiness gates: submit each app to review through Publisher. **No build has been submitted to a store yet.**

Refer to the actual Publisher README, read-only code and readiness rules in [hsdarestani/publisher](https://github.com/hsdarestani/publisher).
