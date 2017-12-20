#!/usr/bin/env bash

set -eu

# shellcheck source=/dev/null
. "$(dirname "$0")/../config.sh"

OPENCV_ROOT=${PROJECT_DIR}/opencv
BUILD_DIR=$OPENCV_ROOT/platforms/build_android

if [ "${ANDROID_ABI}" = "armeabi" ]; then
    API_LEVEL=19
else
    API_LEVEL=21
fi

rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
pushd "${BUILD_DIR}"

cmake -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
      -DCMAKE_TOOLCHAIN_FILE="${PROJECT_DIR}/android-cmake/android.toolchain.cmake" \
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

make -j"${N_JOBS}"
rm -rf "${INSTALL_DIR}/opencv"
make install/strip
git clean -fd 2> /dev/null || true

popd
