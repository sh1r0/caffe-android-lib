#!/usr/bin/env bash

set -eu

# shellcheck source=/dev/null
. "$(dirname "$0")/config.sh"

pushd "${PROJECT_DIR}"

if ! ./scripts/build_openblas.sh; then
    echo "Failed to build OpenBLAS"
    exit 1
fi

./scripts/build_boost.sh
./scripts/build_gflags.sh
./scripts/build_glog.sh
./scripts/build_lmdb.sh
./scripts/build_snappy.sh
./scripts/build_leveldb.sh
./scripts/build_opencv.sh
./scripts/build_protobuf_host.sh
./scripts/build_protobuf.sh
./scripts/build_caffe.sh

popd

echo "DONE!!"
