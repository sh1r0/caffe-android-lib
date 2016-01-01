#!/usr/bin/env sh
set -e

if [ -z "$NDK_ROOT" ] && [ "$#" -eq 0 ]; then
    echo 'Either $NDK_ROOT should be set or provided as argument'
    echo "e.g., 'export NDK_ROOT=/path/to/ndk' or"
    echo "      '${0} /path/to/ndk'"
    exit 1
else
    NDK_ROOT="${1:-${NDK_ROOT}}"
fi

ANDROID_ABI=${ANDROID_ABI:-"armeabi-v7a with NEON"}
WD=$(readlink -f "`dirname $0`/..")
N_JOBS=8
CAFFE_ROOT=${WD}/caffe
BUILD_DIR=${CAFFE_ROOT}/build
ANDROID_LIB_ROOT=${WD}/android_lib
OPENCV_ROOT=${ANDROID_LIB_ROOT}/opencv/sdk/native/jni
PROTOBUF_ROOT=${ANDROID_LIB_ROOT}/protobuf
GFLAGS_HOME=${ANDROID_LIB_ROOT}/gflags
BOOST_HOME=${ANDROID_LIB_ROOT}/boost_1.56.0

USE_OPENBLAS=${USE_OPENBLAS:-0}
if [ ${USE_OPENBLAS} -eq 1 ]; then
    if [ "${ANDROID_ABI}" = "armeabi-v7a-hard-softfp with NEON" ]; then
        OpenBLAS_HOME=${ANDROID_LIB_ROOT}/openblas-hard
    elif [ "${ANDROID_ABI}" = "armeabi-v7a with NEON"  ]; then
        OpenBLAS_HOME=${ANDROID_LIB_ROOT}/openblas-android
    else
        echo "Error: not support OpenBLAS for ABI: ${ANDROID_ABI}"
        exit 1
    fi

    BLAS=open
    export OpenBLAS_HOME="${OpenBLAS_HOME}"
else
    BLAS=eigen
    export EIGEN_HOME="${ANDROID_LIB_ROOT}/eigen3"
fi


rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

cmake -DCMAKE_TOOLCHAIN_FILE="${WD}/android-cmake/android.toolchain.cmake" \
      -DANDROID_NDK="${NDK_ROOT}" \
      -DCMAKE_BUILD_TYPE=Release \
      -DANDROID_ABI="${ANDROID_ABI}" \
      -DANDROID_NATIVE_API_LEVEL=21 \
      -DANDROID_TOOLCHAIN_NAME=arm-linux-androideabi-4.9 \
      -DANDROID_USE_OPENMP=ON \
      -DADDITIONAL_FIND_PATH="${ANDROID_LIB_ROOT}" \
      -DBUILD_python=OFF \
      -DBUILD_docs=OFF \
      -DCPU_ONLY=ON \
      -DUSE_GLOG=OFF \
      -DUSE_LMDB=OFF \
      -DUSE_LEVELDB=OFF \
      -DUSE_HDF5=OFF \
      -DBLAS=${BLAS} \
      -DBOOST_ROOT="${BOOST_HOME}" \
      -DGFLAGS_INCLUDE_DIR="${GFLAGS_HOME}/include" \
      -DGFLAGS_LIBRARY="${GFLAGS_HOME}/lib/libgflags.a" \
      -DOpenCV_DIR="${OPENCV_ROOT}" \
      -DPROTOBUF_PROTOC_EXECUTABLE="${ANDROID_LIB_ROOT}/protobuf_host/bin/protoc" \
      -DPROTOBUF_INCLUDE_DIR="${PROTOBUF_ROOT}/include" \
      -DPROTOBUF_LIBRARY="${PROTOBUF_ROOT}/lib/libprotobuf.a" \
      -DCMAKE_INSTALL_PREFIX="${ANDROID_LIB_ROOT}/caffe" \
      ..

make -j${N_JOBS}
rm -rf "${ANDROID_LIB_ROOT}/caffe"
make install/strip

cd "${WD}"
