#!/usr/bin/env python3
"""Configure Publisher-managed Apple Team and App Store manual signing on generated Flutter iOS project.

Publisher Cloud Mac installs the Apple Distribution certificate and provisioning
profile into a temporary keychain. This script references only public profile
names/UUIDs, never embeds private signing credentials.
"""
import os
import plistlib
import re
from pathlib import Path

team = os.environ["APPLE_TEAM_ID"]
if not re.fullmatch(r"[A-Z0-9]{10}", team):
    raise SystemExit("APPLE_TEAM_ID must be a 10-character Apple team ID.")
app_id = os.environ.get("IOS_BUNDLE_ID") or "de.smarbiz.vicecodes"
pbx = Path("ios/Runner.xcodeproj/project.pbxproj")
if not pbx.is_file():
    raise SystemExit("iOS Xcode project missing. Run flutter create before signing.")
data = pbx.read_text()
data = re.sub(r"DEVELOPMENT_TEAM = [A-Z0-9]*;", "DEVELOPMENT_TEAM = " + team + ";", data)
if "DEVELOPMENT_TEAM = " + team + ";" not in data:
    data = data.replace("CODE_SIGN_STYLE = Automatic;", "CODE_SIGN_STYLE = Automatic;\n\t\t\t\tDEVELOPMENT_TEAM = " + team + ";")
if "DEVELOPMENT_TEAM = " + team + ";" not in data:
    raise SystemExit("Unable to set Apple Team in Runner project.")

sign_style = os.environ.get("IOS_SIGNING_STYLE", "").strip()
profile = os.environ.get("IOS_PROVISIONING_PROFILE_SPECIFIER", "").strip()
if sign_style.lower() == "manual":
    if not profile:
        raise SystemExit("Publisher Mac selected manual signing without an App Store profile.")
    escaped = profile.replace('"', '\\"')
    data = data.replace(
        "CODE_SIGN_STYLE = Automatic;",
        'CODE_SIGN_STYLE = Manual;\n\t\t\t\tPROVISIONING_PROFILE_SPECIFIER = "' + escaped + '";'
    )
    # Only the generated Runner Xcode project is edited, never Swift Packages.
    # Release signing must select Apple Distribution in the project itself.
    data = re.sub(
        r'(CODE_SIGN_IDENTITY(?:\\[sdk=iphoneos\\*\\])?\\s*=\\s*)[^;]+;',
        r'\\1"Apple Distribution";',
        data,
    )
    if 'CODE_SIGN_IDENTITY = "Apple Distribution";' not in data:
        data = data.replace(
            "CODE_SIGN_STYLE = Manual;",
            'CODE_SIGN_STYLE = Manual;\n\t\t\t\tCODE_SIGN_IDENTITY = "Apple Distribution";',
        )
    if "PROVISIONING_PROFILE_SPECIFIER =" not in data:
        raise SystemExit("Could not set manual code signing profile in Xcode project.")
    export = {
        "method": "app-store-connect",
        "signingStyle": "manual",
        "teamID": team,
        "signingCertificate": "Apple Distribution",
        "provisioningProfiles": {app_id: profile},
        "manageAppVersionAndBuildNumber": False,
        "uploadBitcode": False,
    }
    with Path("ios/ExportOptions.plist").open("wb") as fp:
        plistlib.dump(export, fp)
else:
    print("Publisher Mac manual signing not requested; default Xcode signing settings retained.")
pbx.write_text(data)
