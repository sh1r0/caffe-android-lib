#!/usr/bin/env bash

set -eu

# shellcheck source=/dev/null
. "$(dirname "$0")/../config.sh"

LMDB_ROOT=${PROJECT_DIR}/lmdb/libraries/liblmdb

case "$ANDROID_ABI" in
    armeabi*)
        TOOLCHAIN_DIR=$NDK_ROOT/toolchains/arm-linux-androideabi-4.9/prebuilt/${OS}-${ARCH}/bin
        CC="$TOOLCHAIN_DIR/arm-linux-androideabi-gcc --sysroot=$NDK_ROOT/platforms/android-21/arch-arm"
        AR=$TOOLCHAIN_DIR/arm-linux-androideabi-ar
        ;;
    arm64-v8a)
        TOOLCHAIN_DIR=$NDK_ROOT/toolchains/aarch64-linux-android-4.9/prebuilt/${OS}-${ARCH}/bin
        CC="$TOOLCHAIN_DIR/aarch64-linux-android-gcc --sysroot=$NDK_ROOT/platforms/android-21/arch-arm64"
        AR=$TOOLCHAIN_DIR/aarch64-linux-android-ar
        ;;
    x86)
        TOOLCHAIN_DIR=$NDK_ROOT/toolchains/x86-4.9/prebuilt/${OS}-${ARCH}/bin
        CC="$TOOLCHAIN_DIR/i686-linux-android-gcc --sysroot=$NDK_ROOT/platforms/android-21/arch-x86"
        AR=$TOOLCHAIN_DIR/i686-linux-android-ar
        ;;
    x86_64)
        TOOLCHAIN_DIR=$NDK_ROOT/toolchains/x86_64-4.9/prebuilt/${OS}-${ARCH}/bin
        CC="$TOOLCHAIN_DIR/x86_64-linux-android-gcc --sysroot=$NDK_ROOT/platforms/android-21/arch-x86_64"
        AR=$TOOLCHAIN_DIR/x86_64-linux-android-ar
        ;;
    *)
        echo "Error: $0 is not supported for ABI: ${ANDROID_ABI}"
        exit 1
        ;;
esac

pushd "${LMDB_ROOT}"

make clean
make -j"${N_JOBS}" CC="${CC}" AR="${AR}" XCFLAGS="-DMDB_DSYNC=O_SYNC -DMDB_USE_ROBUST=0"

rm -rf "$INSTALL_DIR/lmdb"
make prefix="$INSTALL_DIR/lmdb" install

popd
