#!/usr/bin/env sh
set -e

if [ -z "$NDK_ROOT" ] && [ "$#" -eq 0 ]; then
    echo "Either \$NDK_ROOT should be set or provided as argument"
    echo "e.g., 'export NDK_ROOT=/path/to/ndk' or"
    echo "      '${0} /path/to/ndk'"
    exit 1
else
    NDK_ROOT="${1:-${NDK_ROOT}}"
fi

WD=$(readlink -f "$(dirname "$0")/..")
TOOLCHAIN_DIR=${WD}/toolchains
LEVELDB_ROOT=${WD}/leveldb
INSTALL_DIR=${WD}/android_lib/leveldb
N_JOBS=${N_JOBS:-4}

if [ "${ANDROID_ABI}" = "armeabi-v7a-hard-softfp with NEON" ]; then
	TOOLCHAIN_DIR=$TOOLCHAIN_DIR/armeabi-v7a
elif [ "${ANDROID_ABI}" = "arm64-v8a"  ]; then
	TOOLCHAIN_DIR=$TOOLCHAIN_DIR/arm64-v8a
elif [ "${ANDROID_ABI}" = "armeabi"  ]; then
	TOOLCHAIN_DIR=$TOOLCHAIN_DIR/armeabi
elif [ "${ANDROID_ABI}" = "x86"  ]; then
	TOOLCHAIN_DIR=$TOOLCHAIN_DIR/x86
elif [ "${ANDROID_ABI}" = "x86_64"  ]; then
	TOOLCHAIN_DIR=$TOOLCHAIN_DIR/x86_64
else
    echo "Error: not support $0 for ABI: ${ANDROID_ABI}"
    exit 1
fi

if [ ! -d "$TOOLCHAIN_DIR" ]; then
	"$WD/scripts/make-toolchain.sh"
fi

cd "${LEVELDB_ROOT}"

export PATH=$TOOLCHAIN_DIR/bin:$PATH
export CC=$(find "$TOOLCHAIN_DIR/bin/" -name '*-gcc' -exec basename {} \;)
export CXX=$(find "$TOOLCHAIN_DIR/bin/" -name '*-g++' -exec basename {} \;)
export TARGET_OS=OS_ANDROID_CROSSCOMPILE

make clean
make -j"${N_JOBS}" out-static/libleveldb.a
rm -rf "${INSTALL_DIR}"
mkdir -p "${INSTALL_DIR}/lib"
cp -r include/ "${INSTALL_DIR}"
cp out-static/libleveldb.a "${INSTALL_DIR}/lib"

cd "${WD}"
