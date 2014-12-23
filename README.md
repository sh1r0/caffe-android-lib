Caffe-Android-Lib
===============
## Goal
Porting [caffe](https://github.com/BVLC/caffe) to android platform

## Build
```
git clone --recursive https://github.com/sh1r0/caffe-android-lib.git
cd caffe-android-lib
./build.py $(NDK_PATH)
```

## Usage
- put required stuff into your device

	```
	./get_model.py
	adb shell mkdir -p /sdcard/caffe_mobile/
	adb push caffe-mobile/jni/caffe/data/ilsvrc12/imagenet_mean.binaryproto /sdcard/caffe_mobile/
	adb push caffe-mobile/jni/caffe/models/bvlc_reference_caffenet/ /sdcard/caffe_mobile/bvlc_reference_caffenet/
	```
- copy `caffe-mobile/libs/armeabi-v7a/*.so` to your jni lib directory
- in your main activity

	```java
	static {
		System.loadLibrary("caffe");
		System.loadLibrary("mira-cnn");
	}
	```
- create `ImageNet.java`

	```java
	package com.sh1r0.caffe_android_demo;

	public class ImageNet {
		public native void enableLog(boolean enabled);
		public native int initTest(String modelPath, String weightsPath);
		public native int runTest(String imgPath);
	}
	```
- call native methods

	```java
	ImageNet imageNet = new ImageNet()
	imageNet.initTest(); // init once
	...
	imageNet.runTest(imgPath);
	```

## Optional
`.envrc` files are for [direnv](http://direnv.net/)
> direnv is an environment variable manager for your shell. It knows how to hook into bash, zsh and fish shell to load or unload environment variables depending on your current directory. This allows to have project-specific environment variables and not clutter the "~/.profile" file.

## Dependency
* [Boost-for-Android](https://github.com/MysticTreeGames/Boost-for-Android)
* [protobuf](https://code.google.com/p/protobuf)
* [Eigen](http://eigen.tuxfamily.org)

## Credits
* [caffe-compact](https://github.com/chyh1990/caffe-compact)
