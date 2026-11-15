#!/bin/bash
# Builds a Release "Feedlet.app" for macOS into build/ (signed to run locally unless a team is set).
set -euo pipefail
cd "$(dirname "$0")/.."

xcodebuild -project Feedlet.xcodeproj -scheme Feedlet -configuration Release \
    -destination 'platform=macOS' -derivedDataPath build/dd -quiet build

rm -rf "build/Feedlet.app"
cp -R "build/dd/Build/Products/Release/Feedlet.app" build/
echo "Built build/Feedlet.app"
