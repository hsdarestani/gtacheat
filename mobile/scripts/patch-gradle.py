#!/usr/bin/env python3
"""Apply production signing to a generated Flutter Android Kotlin Gradle app."""
from pathlib import Path

gradle = Path("android/app/build.gradle.kts")
if not gradle.is_file():
    raise SystemExit("Expected Flutter Android build.gradle.kts. Run flutter create first.")
body = gradle.read_text()
if "vicecodes.release.signing" not in body:
    marker = "    buildTypes {"
    old = 'signingConfig = signingConfigs.getByName("debug")'
    if marker not in body or old not in body:
        raise SystemExit("Flutter Gradle template changed; refusing unverified signing.")
    signing = """    // vicecodes.release.signing: secrets from Publisher build agent environment.
    signingConfigs {
        create("releaseUpload") {
            storeFile = file("upload-keystore.jks")
            storePassword = System.getenv("ANDROID_KEYSTORE_PASSWORD")
            keyAlias = System.getenv("ANDROID_KEY_ALIAS")
            keyPassword = System.getenv("ANDROID_KEY_PASSWORD")
        }
    }
"""
    body = body.replace(marker, signing + marker, 1)
    body = body.replace(old, 'signingConfig = signingConfigs.getByName("releaseUpload")', 1)
gradle.write_text(body)
