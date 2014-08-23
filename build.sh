#!/bin/sh
NDK_PATH=~/android-ndk-r9
export PATH=$PATH:${NDK_PATH}

PROJECT_PATH=~/MiRA-CNN/

cd protobuf
export NDK_PROJECT_PATH=`pwd`
ndk-build

cd ../caffe-mobile
export NDK_PROJECT_PATH=`pwd`
ndk-build
\cp -r libs/ $PROJECT_PATH
cd ..

