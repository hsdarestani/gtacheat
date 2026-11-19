#!/usr/bin/env python3
"""Set explicit App Store signing ONLY on the Runner target's Release/Profile.

Flutter's generated .pbxproj has separate XCBuildConfiguration blocks for:
  - the PBXProject ("Runner")
  - RunnerTests
  - PBXNativeTarget "Runner" (Debug, Release, Profile)

Earlier logic edited only existing CODE_SIGN_STYLE settings belonging to
RunnerTests, while the actual Runner Release had no such setting. This
version resolves the Runner XCConfigurationList and edits its real IDs.
No secrets, certificate files, or Swift Package Manager targets are edited.
"""
import os
import plistlib
import re
from pathlib import Path

team = os.environ["APPLE_TEAM_ID"]
if not re.fullmatch(r"[A-Z0-9]{10}", team):
    raise SystemExit("APPLE_TEAM_ID must be ten uppercase alphanumeric characters.")
bundle = os.environ.get("IOS_BUNDLE_ID") or "de.smarbiz.vicecodes"
profile = os.environ.get("IOS_PROVISIONING_PROFILE_SPECIFIER", "").strip()
if os.environ.get("IOS_SIGNING_STYLE", "").lower() != "manual" or not profile:
    raise SystemExit("App Store build requires Publisher manual signing and a profile.")

project = Path("ios/Runner.xcodeproj/project.pbxproj")
if not project.is_file():
    raise SystemExit("Runner Xcode project was not generated.")
content = project.read_text()

# Find the XCConfigurationList belonging to the actual app target, not to
# RunnerTests or to the project configuration. Xcode generated IDs may vary.
config_list = re.search(
    r'[A-F0-9]{24} /\* Build configuration list for PBXNativeTarget "Runner" \*/'
    r'\s*=\s*\{(?P<body>.*?)\n\s*\};',
    content,
    flags=re.S,
)
if config_list is None:
    raise SystemExit("Could not identify the Runner target configuration list.")
configs = {
    name: object_id
    for object_id, name in re.findall(
        r'([A-F0-9]{24}) /\* (Debug|Release|Profile) \*/',
        config_list.group("body"),
    )
}
if not {"Release", "Profile"}.issubset(configs):
    raise SystemExit("Runner Release/Profile configurations not found.")

# Use a stable object-ID reference so that no RunnerTests or PBXProject
# build settings can be accidentally changed.
style_values = {
    "DEVELOPMENT_TEAM": team,
    "CODE_SIGN_STYLE": "Manual",
    "CODE_SIGN_IDENTITY": '"Apple Distribution"',
    '"CODE_SIGN_IDENTITY[sdk=iphoneos*]"': '"Apple Distribution"',
    "PROVISIONING_PROFILE_SPECIFIER": '"' + profile.replace('"', r'\"') + '"',
}
for name in ("Release", "Profile"):
    object_id = configs[name]
    match = re.search(
        rf'(?P<head>{object_id} /\* {name} \*/\s*=\s*\{{'
        rf'(?:(?!\n\s*\}};).)*?buildSettings\s*=\s*\{{\n)'
        rf'(?P<settings>.*?)'
        rf'(?P<tail>\n\s*\}};\s*\n\s*name\s*=\s*{name};\s*\n\s*\}};)',
        content,
        flags=re.S,
    )
    if match is None:
        raise SystemExit(f"Could not edit Runner {name} buildSettings.")
    settings = match.group("settings")
    # Drop both quoted SDK-conditional and unquoted signing keys.
    for key in style_values:
        settings = re.sub(
            rf'(?m)^\s*{re.escape(key)}\s*=\s*[^;]*;\s*$',
            "",
            settings,
        )
    # No leftover conflicting SDK certificate or provisioning settings.
    if re.search(r'(?m)^\s*"?CODE_SIGN_IDENTITY', settings):
        raise SystemExit(f"Unexpected Runner {name} identity setting.")
    if re.search(r'(?m)^\s*PROVISIONING_PROFILE', settings):
        raise SystemExit(f"Unexpected Runner {name} profile setting.")
    settings = settings.rstrip() + "".join(
        f"\n\t\t\t\t{key} = {value};" for key, value in style_values.items()
    )
    content = (
        content[:match.start("settings")]
        + settings
        + content[match.end("settings"):]
    )

project.write_text(content)
with Path("ios/ExportOptions.plist").open("wb") as output:
    plistlib.dump(
        {
            "method": "app-store-connect",
            "signingStyle": "manual",
            "teamID": team,
            "signingCertificate": "Apple Distribution",
            "provisioningProfiles": {bundle: profile},
            "manageAppVersionAndBuildNumber": False,
        },
        output,
    )
print("Configured Runner Release/Profile for Publisher Apple Distribution signing.")
