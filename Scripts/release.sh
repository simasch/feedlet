#!/bin/bash
# Archives Feedlet for iOS and macOS and exports App Store packages into build/release/.
#
#   DEVELOPMENT_TEAM=ABCDE12345 Scripts/release.sh            # archive + export (.ipa / .pkg)
#   DEVELOPMENT_TEAM=ABCDE12345 Scripts/release.sh --upload   # archive + upload to App Store Connect
#
# Requires an Apple Developer Program membership and the account added in Xcode → Settings → Accounts.
# The build number defaults to the git commit count, so every upload from a new commit is higher.
set -euo pipefail
cd "$(dirname "$0")/.."

: "${DEVELOPMENT_TEAM:?Set DEVELOPMENT_TEAM to your Apple team ID (developer.apple.com → Membership)}"
BUILD_NUMBER="${BUILD_NUMBER:-$(git rev-list --count HEAD)}"
OUT=build/release

DESTINATION=export
[[ "${1:-}" == "--upload" ]] && DESTINATION=upload

rm -rf "$OUT"
mkdir -p "$OUT"
sed "s#<string>export</string>#<string>$DESTINATION</string>#" Scripts/ExportOptions.plist > "$OUT/ExportOptions.plist"

for PLATFORM in iOS macOS; do
    ARCHIVE="$OUT/Feedlet-$PLATFORM.xcarchive"
    echo "==> Archiving $PLATFORM (build $BUILD_NUMBER)"
    xcodebuild -project Feedlet.xcodeproj -scheme Feedlet -configuration Release \
        -destination "generic/platform=$PLATFORM" -archivePath "$ARCHIVE" \
        -allowProvisioningUpdates -quiet \
        DEVELOPMENT_TEAM="$DEVELOPMENT_TEAM" CURRENT_PROJECT_VERSION="$BUILD_NUMBER" \
        archive

    echo "==> Exporting $PLATFORM ($DESTINATION)"
    xcodebuild -exportArchive -archivePath "$ARCHIVE" \
        -exportOptionsPlist "$OUT/ExportOptions.plist" -exportPath "$OUT/$PLATFORM" \
        -allowProvisioningUpdates -quiet
done

echo "Done: $OUT"
