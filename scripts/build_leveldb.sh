#!/usr/bin/env bash

set -eu

# shellcheck source=/dev/null
. "$(dirname "$0")/../config.sh"

LEVELDB_ROOT=${PROJECT_DIR}/leveldb

"$PROJECT_DIR/scripts/make-toolchain.sh"

pushd "${LEVELDB_ROOT}"

make clean
make -j"${N_JOBS}"\
    CC="$(find "$TOOLCHAIN_DIR/bin/" -name '*-gcc')" \
    CXX="$(find "$TOOLCHAIN_DIR/bin/" -name '*-g++')" \
    TARGET_OS=OS_ANDROID_CROSSCOMPILE \
    out-static/libleveldb.a
rm -rf "${INSTALL_DIR}/leveldb"
mkdir -p "${INSTALL_DIR}/leveldb/lib"
cp -r include/ "${INSTALL_DIR}/leveldb"
cp out-static/libleveldb.a "${INSTALL_DIR}/leveldb/lib"

popd
