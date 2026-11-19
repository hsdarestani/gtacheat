#!/usr/bin/env python3
"""Regression test for Publisher's generated Xcode signing configuration."""
import os
import plistlib
import subprocess
import sys
import tempfile
from pathlib import Path

patch = Path(__file__).with_name("patch-ios-team.py")
sample = '''
buildSettings = {
  DEVELOPMENT_TEAM = "";
  CODE_SIGN_STYLE = Automatic;
  CODE_SIGN_IDENTITY = "Apple Development";
};
buildSettings = {
  DEVELOPMENT_TEAM = OLDTEAM999;
  CODE_SIGN_STYLE = Automatic;
  CODE_SIGN_IDENTITY = "Apple Development";
};
'''
with tempfile.TemporaryDirectory() as root:
    out = Path(root) / "ios" / "Runner.xcodeproj"
    out.mkdir(parents=True)
    pbx = out / "project.pbxproj"
    pbx.write_text(sample)
    env = os.environ.copy()
    env.update(
        APPLE_TEAM_ID="884MVA2MD5",
        IOS_BUNDLE_ID="de.smarbiz.vicecodes",
        IOS_SIGNING_STYLE="Manual",
        IOS_PROVISIONING_PROFILE_SPECIFIER="A+ Publisher AppStore Test Profile",
    )
    subprocess.run([sys.executable, str(patch.resolve())], cwd=root, env=env, check=True)
    text = pbx.read_text()
    assert text.count("DEVELOPMENT_TEAM = 884MVA2MD5;") == 2, text
    assert "DEVELOPMENT_TEAM = \"\";" not in text
    assert "OLDTEAM999" not in text
    assert text.count("CODE_SIGN_STYLE = Manual;") == 2
    assert "CODE_SIGN_IDENTITY = \"Apple Distribution\";" in text
    assert "PROVISIONING_PROFILE_SPECIFIER" in text
    with (Path(root) / "ios" / "ExportOptions.plist").open("rb") as fp:
        settings = plistlib.load(fp)
    assert settings["signingStyle"] == "manual"
    assert settings["teamID"] == "884MVA2MD5"
    assert settings["provisioningProfiles"]["de.smarbiz.vicecodes"] == "A+ Publisher AppStore Test Profile"
print("Runner signing fixture: passed")
