#!/usr/bin/env sh
set -e

if [ -z "$NDK_ROOT" ] && [ "$#" -eq 0 ]; then
    echo 'Either $NDK_ROOT should be set or provided as argument'
    echo "e.g., 'export NDK_ROOT=/path/to/ndk' or"
    echo "      '${0} /path/to/ndk'"exit 1
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

TOOLCHAIN_DIR=$NDK_ROOT/toolchains/arm-linux-androideabi-4.9/prebuilt/${OS}-${BIT}/bin
WD=$(readlink -f "`dirname $0`/..")
OPENBLAS_ROOT=${WD}/OpenBLAS
INSTALL_DIR=${WD}/android_lib
N_JOBS=8

cd "${OPENBLAS_ROOT}"

make clean
make -j${N_JOBS} \
     CC="$TOOLCHAIN_DIR/arm-linux-androideabi-gcc --sysroot=$NDK_ROOT/platforms/android-21/arch-arm" \
     CROSS_SUFFIX=$TOOLCHAIN_DIR/arm-linux-androideabi- \
     HOSTCC=gcc NO_LAPACK=1 TARGET=ARMV7 \
     USE_THREAD=1 NUM_THREADS=8 USE_OPENMP=1

rm -rf "$INSTALL_DIR/openblas-hard"
make PREFIX="$INSTALL_DIR/openblas-hard" install

cd "${WD}"
