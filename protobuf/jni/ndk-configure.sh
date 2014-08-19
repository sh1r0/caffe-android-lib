#! /bin/sh
# ndk-configure.sh

NDK_PATH=/home/shiro/android-ndk-r9
PREBUILT=${NDK_PATH}/toolchains/arm-linux-androideabi-4.8
PLATFORM=${NDK_PATH}/platforms/android-14/arch-arm

export CC=${PREBUILT}/prebuilt/linux-x86_64/bin/arm-linux-androideabi-gcc
export CFLAGS=-'fPIC -DANDROID -nostdlib'
export LDFLAGS="-Wl,-rpath-link=${PLATFORM}/usr/lib/ -L${PLATFORM}/usr/lib/"

export CPPFLAGS=-I${PLATFORM}/usr/include

export LIBS=-lc
./configure --host=arm-eabi

