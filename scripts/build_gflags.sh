#!/usr/bin/env sh

if [ -z "$NDK_ROOT" ] && [ "$#" -eq 0 ]; then
	echo 'Either $NDK_ROOT should be set or provided as argument'
	echo "e.g., 'export NDK_ROOT=/path/to/ndk' or"
	echo "      '${0} /path/to/ndk'"
	exit 1
else
	NDK_ROOT="${1:-${NDK_ROOT}}"
fi

LINK=https://github.com/gflags/gflags/archive/v2.1.2.tar.gz
TARBALL=gflags_v2.1.2.tar.gz
WD=$(readlink -f "`dirname $0`/..")
GFLAGS_ROOT=${WD}/gflags-2.1.2
INSTALL_DIR=${WD}/android_lib
N_JOBS=8


if [ ! -f ${TARBALL} ]; then
	wget ${LINK} -O ${TARBALL}
fi

rm -rf ${GFLAGS_ROOT}
tar zxvf ${TARBALL}
cd ${GFLAGS_ROOT}

rm -rf build/
mkdir build/
cd build/

cmake -DCMAKE_TOOLCHAIN_FILE="${WD}/android-cmake/android.toolchain.cmake" \
      -DANDROID_NDK="${NDK_ROOT}" \
      -DCMAKE_BUILD_TYPE=Release \
      -DANDROID_ABI="armeabi-v7a with NEON" \
      -DANDROID_NATIVE_API_LEVEL=21 \
      -DANDROID_TOOLCHAIN_NAME=arm-linux-androideabi-4.9 \
      -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/gflags" \
      ..

make -j8
rm -rf "${INSTALL_DIR}/gflags"
make install/strip

cd "${WD}"
