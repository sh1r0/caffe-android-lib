#!/usr/bin/env bash

set -eu

# shellcheck source=/dev/null
. "$(dirname "$0")/../config.sh"

PROTOBUF_ROOT=${PROJECT_DIR}/protobuf
BUILD_DIR=${PROTOBUF_ROOT}/build_host

if [ -f "${INSTALL_DIR}/protobuf_host/bin/protoc" ]; then
    echo "Found host protoc"
    exit 0
fi

rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
pushd "${BUILD_DIR}"

cmake -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/protobuf_host" \
      -Dprotobuf_BUILD_TESTS=OFF \
      ../cmake

make -j"${N_JOBS}"
rm -rf "${INSTALL_DIR}/protobuf_host"
make install/strip
git clean -fd 2> /dev/null || true

popd
