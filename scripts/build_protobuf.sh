#!/usr/bin/env bash

set -eu

# shellcheck source=/dev/null
. "$(dirname "$0")/../config.sh"

PROTOBUF_ROOT=${PROJECT_DIR}/protobuf
BUILD_DIR=${PROTOBUF_ROOT}/build_dir

rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
pushd "${BUILD_DIR}"

cmake -DCMAKE_TOOLCHAIN_FILE="${PROJECT_DIR}/android-cmake/android.toolchain.cmake" \
      -DANDROID_NDK="${NDK_ROOT}" \
      -DCMAKE_BUILD_TYPE=Release \
      -DANDROID_ABI="${ANDROID_ABI}" \
      -DANDROID_NATIVE_API_LEVEL=21 \
      -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/protobuf" \
      -Dprotobuf_BUILD_TESTS=OFF \
      ../cmake

make -j"${N_JOBS}"
rm -rf "${INSTALL_DIR}/protobuf"
make install/strip
git clean -fd 2> /dev/null || true

popd
