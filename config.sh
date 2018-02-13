#!/usr/bin/env bash

BOOTSTRAPPED=${BOOTSTRAPPED:-}
if [ ! -z "$BOOTSTRAPPED" ]; then
    return
fi

PROJECT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
export PROJECT_DIR
export INSTALL_DIR=${PROJECT_DIR}/android_lib
export TOOLCHAIN_DIR=${PROJECT_DIR}/toolchains
export N_JOBS=${N_JOBS:-4}
export NDK_ROOT=${NDK_ROOT:-"/opt/android-ndk-r11c"}

case "$(uname -s)" in
    Darwin)
        OS=darwin
    ;;
    Linux)
        OS=linux
    ;;
    CYGWIN*|MINGW*|MSYS*)
        OS=windows
    ;;
    *)
        echo "Unknown OS"
        exit 1
    ;;
esac
export OS

if [ "$(uname -m)" = "x86_64" ]; then
    ARCH=x86_64
else
    ARCH=x86
fi
export ARCH

ANDROID_ABI=${ANDROID_ABI:-"arm64-v8a"}
TARGET_ANDROID_ABI=$ANDROID_ABI
case "$TARGET_ANDROID_ABI" in
    "armeabi-v7a")
        TOOLCHAIN=arm-linux-androideabi-4.9
        ANDROID_ABI="armeabi-v7a-hard-softfp with NEON"
        ;;
    "arm64-v8a")
        TOOLCHAIN=aarch64-linux-android-4.9
        ;;
    "armeabi")
        TOOLCHAIN=arm-linux-androideabi-4.9
        ;;
    "x86")
        TOOLCHAIN=x86-4.9
        ;;
    "x86_64")
        TOOLCHAIN=x86_64-4.9
        ;;
    *)
        echo "Error: ${ANDROID_ABI} is not supported"
        exit 1
        ;;
esac
export ANDROID_ABI
export TOOLCHAIN
export TOOLCHAIN_DIR=${PROJECT_DIR}/toolchains/$TARGET_ANDROID_ABI

export BOOTSTRAPPED=1
