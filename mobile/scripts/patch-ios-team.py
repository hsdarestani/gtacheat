#!/usr/bin/env python3
"""Set Apple team in Xcode project. Signing cert/profile remain on Publisher Mac."""
import os
import re
from pathlib import Path

team_id = os.environ["APPLE_TEAM_ID"]
if not re.fullmatch(r"[A-Z0-9]{10}", team_id):
    raise SystemExit("APPLE_TEAM_ID must have ten uppercase alphanumeric characters.")
pbx = Path("ios/Runner.xcodeproj/project.pbxproj")
if not pbx.is_file():
    raise SystemExit("Xcode project missing. Run flutter create first.")
data = pbx.read_text()
if "DEVELOPMENT_TEAM =" in data:
    data = re.sub(r"DEVELOPMENT_TEAM = [A-Z0-9]*;", "DEVELOPMENT_TEAM = " + team_id + ";", data)
else:
    data = data.replace("CODE_SIGN_STYLE = Automatic;", "CODE_SIGN_STYLE = Automatic;\n\t\t\t\tDEVELOPMENT_TEAM = " + team_id + ";")
if "DEVELOPMENT_TEAM = " + team_id + ";" not in data:
    raise SystemExit("Could not configure team in generated Xcode project.")
pbx.write_text(data)
