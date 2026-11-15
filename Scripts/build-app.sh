#!/bin/bash
# Builds a Release "Feedlet.app" for macOS into build/, signed with the team set in the project
# (Xcode creates the development certificate and profile if needed).
set -euo pipefail
cd "$(dirname "$0")/.."

xcodebuild -project Feedlet.xcodeproj -scheme Feedlet -configuration Release \
    -destination 'platform=macOS' -derivedDataPath build/dd -allowProvisioningUpdates -quiet build

rm -rf "build/Feedlet.app"
cp -R "build/dd/Build/Products/Release/Feedlet.app" build/
echo "Built build/Feedlet.app"
