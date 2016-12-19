#!/usr/bin/env bash
set -e

if [ -z "$NDK_ROOT" ] && [ "$#" -eq 0 ]; then
    echo "Either NDK_ROOT should be set or provided as argument"
    echo "e.g., 'export NDK_ROOT=/path/to/ndk' or"
    echo "      '${0} /path/to/ndk'"
    exit 1
else
    NDK_ROOT=$(readlink -f "${1:-${NDK_ROOT}}")
    export NDK_ROOT="${NDK_ROOT}"
fi

WD=$(readlink -f "$(dirname "$0")")
cd "${WD}"

export ANDROID_ABI="${ANDROID_ABI:-"arm64-v8a"}"
export N_JOBS=${N_JOBS:-1}

if [ ${USE_QSML} ]; then

    export QSML_VERSION=${QSML_VERSION:-"0.15.2"}

    export QSML_ROOT_DIR=${QSML_ROOT_DIR:-"/opt/Qualcomm/QSML-${QSML_VERSION}/android"}

    if [ "$ANDROID_ABI" = "armeabi-v7a with NEON" ]; then
      export QSML_DIR="${QSML_ROOT_DIR}/arm32/lp64/ndk-r11/"
    elif [ "$ANDROID_ABI" = "arm64-v8a" ]; then
      export QSML_DIR="${QSML_ROOT_DIR}/arm64/lp64/ndk-r11/"
    else
      echo "**** ERROR **** ANDROID_ABI incorrectly set, only \"armeabi-v7a with NEON\" or \"arm64-v8a\" are supported with QSML"
    fi

    echo "Using QSML from $QSML_DIR"

else
    if ! ./scripts/build_openblas.sh ; then
      echo "Failed to build OpenBLAS"
      exit 1
    fi
fi

./scripts/build_boost.sh
./scripts/build_gflags.sh
./scripts/build_glog.sh
./scripts/build_lmdb.sh
./scripts/build_opencv.sh
./scripts/build_protobuf_host.sh
./scripts/build_protobuf.sh
./scripts/build_caffe.sh

echo "DONE!!"
