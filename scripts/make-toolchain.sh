#!/usr/bin/env bash

set -eu

# shellcheck source=/dev/null
. "$(dirname "$0")/../config.sh"

[ -d "$TOOLCHAIN_DIR" ] && exit 0

mkdir -p "$TOOLCHAIN_DIR"
"$NDK_ROOT/build/tools/make-standalone-toolchain.sh" --install-dir="$TOOLCHAIN_DIR" --platform=android-21 --toolchain="$TOOLCHAIN"
