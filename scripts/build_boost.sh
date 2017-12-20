#!/usr/bin/env bash

set -eu

# shellcheck source=/dev/null
. "$(dirname "$0")/../config.sh"

BOOST_ROOT=${PROJECT_DIR}/boost
BUILD_DIR=${BOOST_ROOT}/build

pushd "${BOOST_ROOT}"
./get_boost.sh
popd

rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"

pushd "${BUILD_DIR}"

cmake -DCMAKE_TOOLCHAIN_FILE="${PROJECT_DIR}/android-cmake/android.toolchain.cmake" \
      -DANDROID_NDK="${NDK_ROOT}" \
      -DCMAKE_BUILD_TYPE=Release \
      -DANDROID_ABI="${ANDROID_ABI}" \
      -DANDROID_NATIVE_API_LEVEL=21 \
      -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/boost" \
      ..

make -j"${N_JOBS}"
rm -rf "${INSTALL_DIR}/boost"
make install/strip

rm -rf "${BUILD_DIR}"
