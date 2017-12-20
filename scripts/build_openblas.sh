#!/usr/bin/env bash

set -eu

# shellcheck source=/dev/null
. "$(dirname "$0")/../config.sh"

OPENBLAS_ROOT=${PROJECT_DIR}/OpenBLAS

case "$ANDROID_ABI" in
    "armeabi-v7a-hard-softfp with NEON")
        CROSS_SUFFIX=$NDK_ROOT/toolchains/arm-linux-androideabi-4.9/prebuilt/${OS}-${ARCH}/bin/arm-linux-androideabi-
        SYSROOT=$NDK_ROOT/platforms/android-21/arch-arm
        NO_LAPACK=${NO_LAPACK:-1}
        TARGET=ARMV7
        BINARY=32
        ;;
    "arm64-v8a")
        CROSS_SUFFIX=$NDK_ROOT/toolchains/aarch64-linux-android-4.9/prebuilt/${OS}-${ARCH}/bin/aarch64-linux-android-
        SYSROOT=$NDK_ROOT/platforms/android-21/arch-arm64
        NO_LAPACK=${NO_LAPACK:-1}
        TARGET=ARMV8
        BINARY=64
        ;;
    "armeabi")
        CROSS_SUFFIX=$NDK_ROOT/toolchains/arm-linux-androideabi-4.9/prebuilt/${OS}-${ARCH}/bin/arm-linux-androideabi-
        SYSROOT=$NDK_ROOT/platforms/android-21/arch-arm
        NO_LAPACK=1
        TARGET=ARMV5
        BINARY=32
        ;;
    "x86")
        CROSS_SUFFIX=$NDK_ROOT/toolchains/x86-4.9/prebuilt/${OS}-${ARCH}/bin/i686-linux-android-
        SYSROOT=$NDK_ROOT/platforms/android-21/arch-x86
        NO_LAPACK=1
        TARGET=ATOM
        BINARY=32
        ;;
    "x86_64")
        CROSS_SUFFIX=$NDK_ROOT/toolchains/x86_64-4.9/prebuilt/${OS}-${ARCH}/bin/x86_64-linux-android-
        SYSROOT=$NDK_ROOT/platforms/android-21/arch-x86_64
        NO_LAPACK=1
        TARGET=ATOM
        BINARY=64
        ;;
    *)
        echo "Error: $0 is not supported for ABI: ${ANDROID_ABI}"
        exit 1
        ;;
esac

pushd "${OPENBLAS_ROOT}"

make clean
make -j"${N_JOBS}" \
     CC="${CROSS_SUFFIX}gcc --sysroot=$SYSROOT" \
     FC="${CROSS_SUFFIX}gfortran --sysroot=$SYSROOT" \
     CROSS_SUFFIX="$CROSS_SUFFIX" \
     HOSTCC=gcc USE_THREAD=1 NUM_THREADS=8 USE_OPENMP=1 \
     NO_LAPACK=$NO_LAPACK TARGET=$TARGET BINARY=$BINARY \
     libs

rm -rf "$INSTALL_DIR/openblas"
make PREFIX="$INSTALL_DIR/openblas" install

popd
