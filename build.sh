#!/usr/bin/env sh

if [ -z "$NDK_ROOT" ] && [ "$#" -eq 0 ]; then
	echo 'Either $NDK_ROOT should be set or provided as argument'
	echo "e.g., 'export NDK_ROOT=/path/to/ndk' or"
	echo "      '${0} /path/to/ndk'"
	exit 1
else
	NDK_ROOT="${1:-${NDK_ROOT}}"
fi

WD=$(readlink -f "`dirname $0`")
cd ${WD}

./scripts/build_boost.sh || exit 1
./scripts/build_gflags.sh || exit 1
./scripts/build_openblas.sh || exit 1
./scripts/build_opencv.sh || exit 1
./scripts/build_protobuf_host.sh || exit 1
./scripts/build_protobuf.sh || exit 1
./scripts/build_caffe.sh || exit 1

echo "DONE!!"
