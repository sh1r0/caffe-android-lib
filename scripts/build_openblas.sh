#!/usr/bin/env sh

if [ -z "$NDK_ROOT" ] && [ "$#" -eq 0 ]; then
	echo 'Either $NDK_ROOT should be set or provided as argument'
	echo "e.g., 'export NDK_ROOT=/path/to/ndk' or"
	echo "      '${0} /path/to/ndk'"
	exit 1
else
	NDK_ROOT="${1:-${NDK_ROOT}}"
fi

#export OPENBLAS_NUM_THREADS=1
TOOLCHAIN_DIR=$NDK_ROOT/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin
WD=$(readlink -f "`dirname $0`/..")
INSTALL_DIR=${WD}/android_lib
N_JOBS=8

cd OpenBLAS

make clean
make -j${N_JOBS} \
	 CC="$TOOLCHAIN_DIR/arm-linux-androideabi-gcc --sysroot=$NDK_ROOT/platforms/android-21/arch-arm" \
	 CROSS_SUFFIX=$TOOLCHAIN_DIR/arm-linux-androideabi- \
	 HOSTCC=gcc NO_LAPACK=1 TARGET=ARMV7

rm -rf "$INSTALL_DIR/openblas"
make PREFIX="$INSTALL_DIR/openblas" install

cd "${WD}"
