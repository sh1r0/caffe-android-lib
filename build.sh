#!/usr/bin/env sh
set -e

if [ -z "$NDK_ROOT" ] && [ "$#" -eq 0 ]; then
	echo 'Either $NDK_ROOT should be set or provided as argument'
	echo "e.g., 'export NDK_ROOT=/path/to/ndk' or"
	echo "      '${0} /path/to/ndk'"
	exit 1
else
	NDK_ROOT=$(readlink -f "${1:-${NDK_ROOT}}")
	export NDK_ROOT="${NDK_ROOT}"
fi

WD=$(readlink -f "`dirname $0`")
cd ${WD}

./scripts/get_eigen.sh
./scripts/build_boost.sh
./scripts/build_gflags.sh
#./scripts/build_openblas.sh
./scripts/build_opencv.sh
./scripts/build_protobuf_host.sh
./scripts/build_protobuf.sh
./scripts/build_caffe.sh

echo "DONE!!"
