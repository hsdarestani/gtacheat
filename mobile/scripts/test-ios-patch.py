#!/usr/bin/env python3
"""A realistic generated Flutter/Xcode project regression fixture.

Runner Release/Profile have NO CODE_SIGN_STYLE in the Flutter template.
RunnerTests DO have automatic signing, while the PBXProject has
"CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "iPhone Developer".
The patch must touch only the actual Runner target Release/Profile IDs.
"""
import os
import plistlib
import subprocess
import sys
import tempfile
from pathlib import Path

patch = Path(__file__).with_name("patch-ios-team.py").resolve()
sample = '''
/* Begin XCBuildConfiguration section */
        AAAAAAAAAAAAAAAAAAAAAAAA /* Release */ = {
            isa = XCBuildConfiguration;
            buildSettings = {
                "CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "iPhone Developer";
            };
            name = Release;
        };
        BBBBBBBBBBBBBBBBBBBBBBBB /* Release */ = {
            isa = XCBuildConfiguration;
            buildSettings = {
                BUNDLE_LOADER = "$(TEST_HOST)";
                CODE_SIGN_STYLE = Automatic;
            };
            name = Release;
        };
        CCCCCCCCCCCCCCCCCCCCCCCC /* Release */ = {
            isa = XCBuildConfiguration;
            baseConfigurationReference = DEADBEEFDEADBEEFDEADBEEF /* Release.xcconfig */;
            buildSettings = {
                ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
                PRODUCT_BUNDLE_IDENTIFIER = de.smarbiz.vicecodes;
                PRODUCT_NAME = "$(TARGET_NAME)";
                DEVELOPMENT_TEAM = "";
            };
            name = Release;
        };
        DDDDDDDDDDDDDDDDDDDDDDDDDD /* Profile */ = {
            isa = XCBuildConfiguration;
            buildSettings = {
                PRODUCT_BUNDLE_IDENTIFIER = de.smarbiz.vicecodes;
                PRODUCT_NAME = "$(TARGET_NAME)";
            };
            name = Profile;
        };
/* End XCBuildConfiguration section */
/* Begin XCConfigurationList section */
        EEEEEEEEEEEEEEEEEEEEEEEE /* Build configuration list for PBXNativeTarget "RunnerTests" */ = {
            isa = XCConfigurationList;
            buildConfigurations = (
                BBBBBBBBBBBBBBBBBBBBBBBB /* Release */,
            );
        };
        FFFFFFFFFFFFFFFFFFFFFFFF /* Build configuration list for PBXProject "Runner" */ = {
            isa = XCConfigurationList;
            buildConfigurations = (
                AAAAAAAAAAAAAAAAAAAAAAAA /* Release */,
            );
        };
        1234567890ABCDEF12345678 /* Build configuration list for PBXNativeTarget "Runner" */ = {
            isa = XCConfigurationList;
            buildConfigurations = (
                CCCCCCCCCCCCCCCCCCCCCCCC /* Release */,
                DDDDDDDDDDDDDDDDDDDDDDDD /* Profile */,
            );
        };
/* End XCConfigurationList section */
'''
with tempfile.TemporaryDirectory() as root:
    folder = Path(root) / "ios" / "Runner.xcodeproj"
    folder.mkdir(parents=True)
    project = folder / "project.pbxproj"
    project.write_text(sample)
    env = os.environ.copy()
    env.update(
        APPLE_TEAM_ID="884MVA2MD5",
        IOS_BUNDLE_ID="de.smarbiz.vicecodes",
        IOS_SIGNING_STYLE="Manual",
        IOS_PROVISIONING_PROFILE_SPECIFIER="A+ Publisher AppStore Test Profile",
    )
    result = subprocess.run(
        [sys.executable, str(patch)],
        cwd=root,
        env=env,
        capture_output=True,
        text=True,
    )
    assert result.returncode == 0, result.stdout + "\n" + result.stderr
    data = project.read_text()
    assert data.count("DEVELOPMENT_TEAM = 884MVA2MD5;") == 2
    assert data.count('CODE_SIGN_STYLE = Manual;') == 2
    assert data.count('CODE_SIGN_IDENTITY = "Apple Distribution";') == 2
    assert data.count('"CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "Apple Distribution";') == 2
    assert data.count('PROVISIONING_PROFILE_SPECIFIER = "A+ Publisher AppStore Test Profile";') == 2
    # No changes to project-wide signing or RunnerTests:
    assert data.count('CODE_SIGN_STYLE = Automatic;') == 1
    assert data.count('"CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "iPhone Developer";') == 1
    assert 'DEVELOPMENT_TEAM = "";' not in data
    with (Path(root) / "ios" / "ExportOptions.plist").open("rb") as inp:
        export = plistlib.load(inp)
    assert export["signingStyle"] == "manual"
    assert export["teamID"] == "884MVA2MD5"
    assert export["provisioningProfiles"]["de.smarbiz.vicecodes"] == "A+ Publisher AppStore Test Profile"
print("Flutter Runner Release/Profile signing regression test passed.")
