#!/usr/bin/env bash

set -eu

# shellcheck source=/dev/null
. "$(dirname "$0")/../config.sh"

SNAPPY_ROOT=${PROJECT_DIR}/snappy

"$PROJECT_DIR/scripts/make-toolchain.sh"

pushd "${SNAPPY_ROOT}"

if [ ! -f configure ]; then
    ./autogen.sh
fi

./configure --prefix="$INSTALL_DIR/snappy" --with-gflags=no --host="$(uname -m)"
make clean
make -j"${N_JOBS}"\
    CC="$(find "$TOOLCHAIN_DIR/bin/" -name '*-gcc')" \
    CXX="$(find "$TOOLCHAIN_DIR/bin/" -name '*-g++')"
rm -rf "${INSTALL_DIR}/snappy"
make install
git clean -fd 2> /dev/null || true

popd
