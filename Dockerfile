FROM ubuntu:16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    automake \
    build-essential \
    ca-certificates \
    curl \
    cmake \
    file \
    libtool \
    pkg-config \
    unzip \
    wget

RUN curl -SL \
    http://dl.google.com/android/repository/android-ndk-r11c-linux-x86_64.zip \
    -o /tmp/android-ndk.zip \
    && unzip -q -d /opt /tmp/android-ndk.zip \
    && rm -f /tmp/android-ndk.zip

COPY . /caffe-android-lib

WORKDIR /caffe-android-lib
