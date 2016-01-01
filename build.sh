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

export ANDROID_ABI="${ANDROID_ABI:-"armeabi-v7a with NEON"}"
export USE_OPENBLAS=${USE_OPENBLAS:-0}

if [ ${USE_OPENBLAS} -eq 1 ]; then
    if [ "${ANDROID_ABI}" = "armeabi-v7a-hard-softfp with NEON" ]; then
        ./scripts/build_openblas_hard.sh
    elif [ "${ANDROID_ABI}" = "armeabi-v7a with NEON"  ]; then
        ./scripts/get_openblas.sh
    else
        echo "Warning: not support OpenBLAS for ABI: ${ANDROID_ABI}, use Eigen instead"
        export USE_OPENBLAS=0
        ./scripts/get_eigen.sh
    fi
else
    ./scripts/get_eigen.sh
fi

./scripts/build_boost.sh
./scripts/build_gflags.sh
./scripts/build_opencv.sh
./scripts/build_protobuf_host.sh
./scripts/build_protobuf.sh
./scripts/build_caffe.sh

echo "DONE!!"
