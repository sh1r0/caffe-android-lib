#!/usr/bin/env sh

WD=$(readlink -f "`dirname $0`/..")
PROTOBUF_ROOT=${WD}/protobuf
INSTALL_DIR=${WD}/android_lib
N_JOBS=8

if [ -f "${INSTALL_DIR}/protobuf_host/bin/protoc" ]; then
	echo "Found host protoc"
	exit 0
fi

cd "${PROTOBUF_ROOT}"
rm -rf build_host/
mkdir build_host/
cd build_host/

cmake -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/protobuf_host" \
	  -DBUILD_TESTING=OFF \
      ../cmake

make -j${N_JOBS}
rm -rf "${INSTALL_DIR}/protobuf_host"
make install/strip

cd "${WD}"
