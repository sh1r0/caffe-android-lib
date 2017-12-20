#!/usr/bin/env bash

set -eu

# shellcheck source=/dev/null
. "$(dirname "$0")/../config.sh"

CAFFE_ROOT=${PROJECT_DIR}/caffe
BUILD_DIR=${CAFFE_ROOT}/build

BOOST_HOME=${INSTALL_DIR}/boost
GFLAGS_HOME=${INSTALL_DIR}/gflags
GLOG_ROOT=${INSTALL_DIR}/glog
OPENCV_ROOT=${INSTALL_DIR}/opencv/sdk/native/jni
PROTOBUF_ROOT=${INSTALL_DIR}/protobuf
SNAPPY_ROOT_DIR=${INSTALL_DIR}/snappy
export LEVELDB_ROOT=${INSTALL_DIR}/leveldb
export LMDB_DIR=${INSTALL_DIR}/lmdb
export OpenBLAS_HOME="${INSTALL_DIR}/openblas"

rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
pushd "${BUILD_DIR}"

cmake -DCMAKE_TOOLCHAIN_FILE="${PROJECT_DIR}/android-cmake/android.toolchain.cmake" \
      -DANDROID_NDK="${NDK_ROOT}" \
      -DCMAKE_BUILD_TYPE=Release \
      -DANDROID_ABI="${ANDROID_ABI}" \
      -DANDROID_NATIVE_API_LEVEL=21 \
      -DANDROID_USE_OPENMP=ON \
      -DADDITIONAL_FIND_PATH="${INSTALL_DIR}" \
      -DBUILD_python=OFF \
      -DBUILD_docs=OFF \
      -DCPU_ONLY=ON \
      -DUSE_LMDB=ON \
      -DUSE_LEVELDB=ON \
      -DUSE_HDF5=OFF \
      -DBLAS=open \
      -DBOOST_ROOT="${BOOST_HOME}" \
      -DGFLAGS_INCLUDE_DIR="${GFLAGS_HOME}/include" \
      -DGFLAGS_LIBRARY="${GFLAGS_HOME}/lib/libgflags.a" \
      -DGLOG_INCLUDE_DIR="${GLOG_ROOT}/include" \
      -DGLOG_LIBRARY="${GLOG_ROOT}/lib/libglog.a" \
      -DOpenCV_DIR="${OPENCV_ROOT}" \
      -DPROTOBUF_PROTOC_EXECUTABLE="${INSTALL_DIR}/protobuf_host/bin/protoc" \
      -DPROTOBUF_INCLUDE_DIR="${PROTOBUF_ROOT}/include" \
      -DPROTOBUF_LIBRARY="${PROTOBUF_ROOT}/lib/libprotobuf.a" \
      -DSNAPPY_ROOT_DIR="${SNAPPY_ROOT_DIR}" \
      -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/caffe" \
      ..

make -j"${N_JOBS}"
rm -rf "${INSTALL_DIR}/caffe"
make install

popd
