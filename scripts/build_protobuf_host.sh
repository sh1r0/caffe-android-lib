#!/usr/bin/env sh
set -e

WD=$(readlink -f "`dirname $0`/..")
PROTOBUF_ROOT=${WD}/protobuf
BUILD_DIR=${PROTOBUF_ROOT}/build_host
INSTALL_DIR=${WD}/android_lib
N_JOBS=${N_JOBS:-4}

if [ -f "${INSTALL_DIR}/protobuf_host/bin/protoc" ]; then
    echo "Found host protoc"
    exit 0
fi

rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

cmake -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/protobuf_host" \
      -Dprotobuf_BUILD_TESTS=OFF \
      ../cmake

make -j${N_JOBS}
rm -rf "${INSTALL_DIR}/protobuf_host"
make install/strip
git clean -fd

cd "${WD}"
