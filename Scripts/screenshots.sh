#!/bin/bash
# Takes the App Store screenshots with an invented sample library (Scripts/screenshots/sample-library.py):
#   iPhone 6.3" (1206x2622, required), iPhone 6.9" (1320x2868) and iPad 13" (2064x2752) from the simulators, Mac (2880x1800) from the app window.
# Output: build/screenshots/<device>/<n>-<scene>.png
#
#   Scripts/screenshots.sh            # all devices
#   Scripts/screenshots.sh iphone     # only one of: iphone iphone63 ipad mac
#
# Uses a Debug build: the -screenshot launch argument (App/ScreenshotMode.swift) opens a fixed screen and skips the
# feed refresh. On the Mac your own library is backed up first and put back afterwards.
set -euo pipefail
cd "$(dirname "$0")/.."

BUNDLE_ID=ch.martinelli.feedlet
OUT=build/screenshots
DD=build/dd-shots
LIBRARY=$(mktemp -t feedlet-library)
python3 -I Scripts/screenshots/sample-library.py > "$LIBRARY"
ONLY="${1:-all}"

scenes_iphone=(list article sidebar starred)
scenes_ipad=(article starred)
scenes_mac=(article starred list)

shoot_simulator() {   # device-name  out-dir  scenes...
    local name="$1" dir="$2"; shift 2
    local udid
    udid=$(xcrun simctl list devices available | grep -F "    $name (" | head -1 | sed -E 's/.*\(([0-9A-F-]{36})\).*/\1/')
    [[ -n "$udid" ]] || { echo "No simulator named '$name'"; exit 1; }
    echo "==> $name ($udid)"
    xcrun simctl boot "$udid" 2>/dev/null || true
    xcrun simctl bootstatus "$udid" -b >/dev/null
    xcrun simctl ui "$udid" appearance light
    xcrun simctl status_bar "$udid" override --time "9:41" --dataNetwork wifi --wifiBars 3 \
        --cellularMode active --cellularBars 4 --batteryState charged --batteryLevel 100
    xcrun simctl install "$udid" "$DD/Build/Products/Debug-iphonesimulator/Feedlet.app"
    mkdir -p "$dir"
    local n=1
    for scene in "$@"; do
        xcrun simctl terminate "$udid" "$BUNDLE_ID" 2>/dev/null || true
        local data
        data=$(xcrun simctl get_app_container "$udid" "$BUNDLE_ID" data)
        mkdir -p "$data/Library/Application Support/Feedlet"
        cp "$LIBRARY" "$data/Library/Application Support/Feedlet/library.json"
        xcrun simctl launch "$udid" "$BUNDLE_ID" -screenshot "$scene" >/dev/null
        sleep 4
        xcrun simctl io "$udid" screenshot --type=png "$dir/$n-$scene.png" >/dev/null
        echo "    $dir/$n-$scene.png"
        n=$((n + 1))
    done
    xcrun simctl terminate "$udid" "$BUNDLE_ID" 2>/dev/null || true
    xcrun simctl status_bar "$udid" clear
}

shoot_mac() {   # out-dir  scenes...
    local dir="$1"; shift
    local container="$HOME/Library/Containers/$BUNDLE_ID/Data/Library/Application Support/Feedlet"
    local app="$DD/Build/Products/Debug/Feedlet.app"
    local backup=""
    mkdir -p "$dir" "$container"
    if ! ls "$container" >/dev/null 2>&1; then
        echo "Cannot access the app container (macOS app data protection)."
        echo "Give your terminal Full Disk Access: System Settings > Privacy & Security > Full Disk Access, then restart it."
        exit 1
    fi
    if [[ -f "$container/library.json" ]]; then
        backup="$container/library.json.screenshot-backup"
        cp "$container/library.json" "$backup"
    fi
    restore() { [[ -n "$backup" ]] && mv -f "$backup" "$container/library.json"; }
    trap restore EXIT
    echo "==> Mac"
    local n=1
    for scene in "$@"; do
        osascript -e "tell application id \"$BUNDLE_ID\" to quit" 2>/dev/null || true
        sleep 1
        cp "$LIBRARY" "$container/library.json"
        open -n "$app" --args -screenshot "$scene"
        sleep 4
        open "$app"   # brings it to the front: an inactive window draws greyed out
        sleep 1
        local window
        window=$(swift Scripts/screenshots/window-id.swift Feedlet)
        screencapture -x -l "$window" "$dir/window-$scene.png"
        swift Scripts/screenshots/compose-mac.swift "$dir/window-$scene.png" "$dir/$n-$scene.png"
        rm "$dir/window-$scene.png"
        echo "    $dir/$n-$scene.png"
        n=$((n + 1))
    done
    osascript -e "tell application id \"$BUNDLE_ID\" to quit" 2>/dev/null || true
    sleep 1
    restore
    trap - EXIT
}

if [[ "$ONLY" == all || "$ONLY" == iphone* || "$ONLY" == ipad ]]; then
    xcodebuild -project Feedlet.xcodeproj -scheme Feedlet -configuration Debug \
        -destination 'generic/platform=iOS Simulator' -derivedDataPath "$DD" -quiet build
fi
if [[ "$ONLY" == all || "$ONLY" == mac ]]; then
    xcodebuild -project Feedlet.xcodeproj -scheme Feedlet -configuration Debug \
        -destination 'platform=macOS' -derivedDataPath "$DD" -allowProvisioningUpdates -quiet build
fi

[[ "$ONLY" == all || "$ONLY" == iphone63 ]] && shoot_simulator "iPhone 16 Pro" "$OUT/iphone-6.3" "${scenes_iphone[@]}"
[[ "$ONLY" == all || "$ONLY" == iphone ]] && shoot_simulator "iPhone 16 Pro Max" "$OUT/iphone-6.9" "${scenes_iphone[@]}"
[[ "$ONLY" == all || "$ONLY" == ipad ]] && shoot_simulator "iPad Pro 13-inch (M5)" "$OUT/ipad-13" "${scenes_ipad[@]}"
[[ "$ONLY" == all || "$ONLY" == mac ]] && shoot_mac "$OUT/mac" "${scenes_mac[@]}"

rm -f "$LIBRARY"
echo "Done: $OUT"
