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

ANDROID_ABI=${ANDROID_ABI:-"armeabi-v7a with NEON"}
WD=$(readlink -f "`dirname $0`/..")
OPENCV_ROOT=${WD}/opencv
BUILD_DIR=$OPENCV_ROOT/platforms/build_android
INSTALL_DIR=${WD}/android_lib
N_JOBS=${N_JOBS:-4}

if [ "${ANDROID_ABI}" = "armeabi" ]; then
    API_LEVEL=19
else
    API_LEVEL=21
fi

rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

cmake -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
      -DCMAKE_TOOLCHAIN_FILE="${WD}/android-cmake/android.toolchain.cmake" \
      -DANDROID_NDK="${NDK_ROOT}" \
      -DANDROID_NATIVE_API_LEVEL=${API_LEVEL} \
      -DANDROID_ABI="${ANDROID_ABI}" \
      -D WITH_CUDA=OFF \
      -D WITH_MATLAB=OFF \
      -D BUILD_ANDROID_EXAMPLES=OFF \
      -D BUILD_DOCS=OFF \
      -D BUILD_PERF_TESTS=OFF \
      -D BUILD_TESTS=OFF \
      -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/opencv" \
      ../..

make -j${N_JOBS}
rm -rf "${INSTALL_DIR}/opencv"
make install/strip
git clean -fd

cd "${WD}"
