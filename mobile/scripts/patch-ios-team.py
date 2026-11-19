#!/usr/bin/env python3
"""Apply Publisher-managed signing to the generated Runner Xcode project only.

This never edits generated Flutter Swift Package project settings and never
reads private certificate material. Publisher has already installed the Apple
Distribution identity and the App Store provisioning profile on the Mac.
"""
import os
import plistlib
import re
from pathlib import Path

team = os.environ["APPLE_TEAM_ID"]
if not re.fullmatch(r"[A-Z0-9]{10}", team):
    raise SystemExit("APPLE_TEAM_ID must have ten uppercase letters or digits.")
bundle = os.environ.get("IOS_BUNDLE_ID") or "de.smarbiz.vicecodes"
project = Path("ios/Runner.xcodeproj/project.pbxproj")
if not project.is_file():
    raise SystemExit("Missing generated Runner Xcode project.")

data = project.read_text()
# Handle both blank/quoted and existing team settings in Debug, Release and Profile.
data, replaced = re.subn(
    r"\bDEVELOPMENT_TEAM\s*=\s*[^;]*;",
    f"DEVELOPMENT_TEAM = {team};",
    data,
)
if replaced == 0:
    data = data.replace(
        "CODE_SIGN_STYLE = Automatic;",
        f"CODE_SIGN_STYLE = Automatic;\n\t\t\t\tDEVELOPMENT_TEAM = {team};",
    )
# The generated Runner project must not retain any empty or other-team value.
team_values = re.findall(r"\bDEVELOPMENT_TEAM\s*=\s*([^;]*);", data)
if not team_values or any(v.strip() != team for v in team_values):
    raise SystemExit("Could not set Apple development team in every Runner build setting.")

if os.environ.get("IOS_SIGNING_STYLE", "").lower() == "manual":
    profile = os.environ.get("IOS_PROVISIONING_PROFILE_SPECIFIER", "").strip()
    if not profile:
        raise SystemExit("Publisher manual App Store profile is missing.")
    if "CODE_SIGN_STYLE = Automatic;" not in data and "CODE_SIGN_STYLE = Manual;" not in data:
        raise SystemExit("Runner Xcode template lacks supported signing style.")
    escaped = profile.replace('"', '\\"')
    data = data.replace(
        "CODE_SIGN_STYLE = Automatic;",
        'CODE_SIGN_STYLE = Manual;\n\t\t\t\tPROVISIONING_PROFILE_SPECIFIER = "' + escaped + '";',
    )
    # Keep the Apple Distribution identity scoped to Runner project, not
    # globally on the command line where it would affect Swift dependencies.
    data = re.sub(
        r'(CODE_SIGN_IDENTITY(?:\[sdk=iphoneos\*\])?\s*=\s*)[^;]+;',
        r'\1"Apple Distribution";',
        data,
    )
    if 'CODE_SIGN_IDENTITY = "Apple Distribution";' not in data:
        data = data.replace(
            "CODE_SIGN_STYLE = Manual;",
            'CODE_SIGN_STYLE = Manual;\n\t\t\t\tCODE_SIGN_IDENTITY = "Apple Distribution";',
        )
    if "PROVISIONING_PROFILE_SPECIFIER =" not in data:
        raise SystemExit("Could not set Runner App Store profile.")
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
else:
    print("Automatic Xcode signing selected; manual profile not configured.")

project.write_text(data)
print("Runner Apple team and App Store signing configured.")
