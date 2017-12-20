#!/usr/bin/env bash

set -eu

# shellcheck source=/dev/null
. "$(dirname "$0")/../config.sh"

GLOG_ROOT=${PROJECT_DIR}/glog
BUILD_DIR=${GLOG_ROOT}/build
GFLAGS_HOME=${INSTALL_DIR}/gflags

rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
pushd "${BUILD_DIR}"

cmake -DCMAKE_TOOLCHAIN_FILE="${PROJECT_DIR}/android-cmake/android.toolchain.cmake" \
      -DANDROID_NDK="${NDK_ROOT}" \
      -DCMAKE_BUILD_TYPE=Release \
      -DANDROID_ABI="${ANDROID_ABI}" \
      -DANDROID_NATIVE_API_LEVEL=21 \
      -DGFLAGS_INCLUDE_DIR="${GFLAGS_HOME}/include" \
      -DGFLAGS_LIBRARY="${GFLAGS_HOME}/lib/libgflags.a" \
      -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/glog" \
      ..

make -j"${N_JOBS}"
rm -rf "${INSTALL_DIR}/glog"
make install/strip

popd
