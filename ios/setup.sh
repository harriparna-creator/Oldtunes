#!/bin/bash
# Builds the Xcode project for Old Tunes and opens it.
set -e
cd "$(dirname "$0")"

if ! command -v xcodegen >/dev/null 2>&1; then
  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew is needed to install XcodeGen. Install it from https://brew.sh, then run this again."
    exit 1
  fi
  echo "Installing XcodeGen…"
  brew install xcodegen
fi

xcodegen generate
open OldTunes.xcodeproj
echo "Opened OldTunes.xcodeproj in Xcode."
