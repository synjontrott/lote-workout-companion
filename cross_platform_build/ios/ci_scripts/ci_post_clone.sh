#!/bin/sh

# Fail this script if any subcommand fails.
set -e

# Install Flutter using git clone.
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

# Precache iOS artifacts.
flutter precache --ios

# Run pub get in the Flutter project directory.
cd "$CI_PRIMARY_REPOSITORY_PATH/cross_platform_build"
flutter pub get
flutter build ios --config-only

# Install CocoaPods dependencies.
cd ios
pod install

exit 0
