#!/usr/bin/env sh
set -e

if [ -z "$NDK_ROOT" ] && [ "$#" -eq 0 ]; then
    echo 'Either $NDK_ROOT should be set or provided as argument'
    echo "e.g., 'export NDK_ROOT=/path/to/ndk' or"
    echo "      '${0} /path/to/ndk'"
    exit 1
else
    NDK_ROOT="${1:-${NDK_ROOT}}"
fi

if [ "$(uname)" = "Darwin" ]; then
    OS=darwin
elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
    OS=linux
elif [ "$(expr substr $(uname -s) 1 10)" = "MINGW32_NT" ||
       "$(expr substr $(uname -s) 1 9)" = "CYGWIN_NT" ]; then
    OS=windows
else
    echo "Unknown OS"
    exit 1
fi

if [ "$(uname -m)" = "x86_64"  ]; then
    BIT=x86_64
else
    BIT=x86
fi

WD=$(readlink -f "`dirname $0`/..")
LMDB_ROOT=${WD}/lmdb/libraries/liblmdb
INSTALL_DIR=${WD}/android_lib
N_JOBS=${N_JOBS:-4}

cd "${LMDB_ROOT}"

if [ `expr substr "${ANDROID_ABI}" 1 7` = "armeabi" ]; then
    TOOLCHAIN_DIR=$NDK_ROOT/toolchains/arm-linux-androideabi-4.9/prebuilt/${OS}-${BIT}/bin
    CC="$TOOLCHAIN_DIR/arm-linux-androideabi-gcc --sysroot=$NDK_ROOT/platforms/android-21/arch-arm"
    AR=$TOOLCHAIN_DIR/arm-linux-androideabi-ar
elif [ "${ANDROID_ABI}" = "arm64-v8a" ]; then
    TOOLCHAIN_DIR=$NDK_ROOT/toolchains/aarch64-linux-android-4.9/prebuilt/${OS}-${BIT}/bin
    CC="$TOOLCHAIN_DIR/aarch64-linux-android-gcc --sysroot=$NDK_ROOT/platforms/android-21/arch-arm64"
    AR=$TOOLCHAIN_DIR/aarch64-linux-android-ar
elif [ "${ANDROID_ABI}" = "x86" ]; then
    TOOLCHAIN_DIR=$NDK_ROOT/toolchains/x86-4.9/prebuilt/${OS}-${BIT}/bin
    CC="$TOOLCHAIN_DIR/i686-linux-android-gcc --sysroot=$NDK_ROOT/platforms/android-21/arch-x86"
    AR=$TOOLCHAIN_DIR/i686-linux-android-ar
elif [ "${ANDROID_ABI}" = "x86_64" ]; then
    TOOLCHAIN_DIR=$NDK_ROOT/toolchains/x86_64-4.9/prebuilt/${OS}-${BIT}/bin
    CC="$TOOLCHAIN_DIR/x86_64-linux-android-gcc --sysroot=$NDK_ROOT/platforms/android-21/arch-x86_64"
    AR=$TOOLCHAIN_DIR/x86_64-linux-android-ar
else
    echo "Error: not support LMDB for ABI: ${ANDROID_ABI}"
    exit 1
fi

make clean
make -j${N_JOBS} CC="${CC}" AR="${AR}" XCFLAGS="-DMDB_DSYNC=O_SYNC -DMDB_USE_ROBUST=0"

rm -rf "$INSTALL_DIR/lmdb"
make prefix="$INSTALL_DIR/lmdb" install

cd "${WD}"
