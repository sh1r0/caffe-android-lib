#!/usr/bin/env sh

if [ -z "$NDK_ROOT" ] && [ "$#" -eq 0 ]; then
	echo 'Either $NDK_ROOT should be set or provided as argument'
	echo "e.g., 'export NDK_ROOT=/path/to/ndk' or"
	echo "      '${0} /path/to/ndk'"
	exit 1
else
	NDK_ROOT="${1:-${NDK_ROOT}}"
fi

WD=$(readlink -f "`dirname $0`/..")
BOOST_ROOT=${WD}/Boost-for-Android
INSTALL_DIR=${WD}/android_lib

cd "$BOOST_ROOT"
./build-android.sh -a armeabi-v7a \
	               -b 1.55.0 \
				   -i atomic \
				   -i date_time \
				   -i math \
				   -i random \
				   -i system \
				   -i thread \
				   -t arm-linux-androideabi-4.9 \
				   -o linux-x86_64 \
				   -v 'release' \
				   -n "${NDK_ROOT}"

rm -rf "${INSTALL_DIR}/boost"
cp -r build_1_55_0/armeabi-v7a/ "${INSTALL_DIR}/boost"

cd "${INSTALL_DIR}/boost/lib"
ln -fs "`pwd`/libboost_atomic-gcc-mt-1_55.a" libboost_atomic.a
ln -fs "`pwd`/libboost_math_tr1-gcc-mt-1_55.a" libboost_math.a
ln -fs "`pwd`/libboost_system-gcc-mt-1_55.a" libboost_system.a
ln -fs "`pwd`/libboost_date_time-gcc-mt-1_55.a" libboost_date_time.a
ln -fs "`pwd`/libboost_thread-gcc-mt-1_55.a" libboost_thread.a
ln -fs "`pwd`/libboost_random-gcc-mt-1_55.a" libboost_random.a

cd "${WD}"
