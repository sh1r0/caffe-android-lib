Caffe-Android-Lib
===============
## Goal
Porting [caffe](https://github.com/BVLC/caffe) to android platform

### Support
* Up-to-date caffe ([e79bc8f](https://github.com/BVLC/caffe/commit/e79bc8f1f6df4db3a293ef057b7ca5299c01074a))
* CPU only
* Without support for some IO libs (leveldb and hdf5)

## Build
Tested with Android NDK r11c and cmake 3.3.2 on Ubuntu 14.04

```shell
git clone --recursive https://github.com/sh1r0/caffe-android-lib.git
cd caffe-android-lib
./build.sh <path/to/ndk>
```

### OpenBLAS
In general, Eigen is used as the underlying BLAS library to build caffe in this project.
But if you hope to use OpenBLAS instead, please check the following steps.

```shell
# 1. set OpenBLAS usage explicitly
export USE_OPENBLAS=1  # if 0, Eigen is used

# 2. only following ANDROID_ABIs are supported
# "armeabi", "armeabi-v7a-hard-softfp with NEON", "arm64-v8a", and "x86_64"
export ANDROID_ABI="armeabi-v7a-hard-softfp with NEON"  # for example

# 3. Build
./build.sh <path/to/ndk>
```

## Issues
- Caffe build with Eigen cannot pass some tests ([ref](https://github.com/BVLC/caffe/pull/2619#issuecomment-113224948))

If anyone has any idea about the above issues, please let me know.
Any comments or issues are also welcomed.
Thanks.

## TODO
- [ ] integrate using CMake's ExternalProject
- [ ] add IO dependency support (i.e., leveldb and hdf5)
- [ ] OpenCL support
- [ ] CUDA suuport

## Optional
`.envrc` files are for [direnv](http://direnv.net/)
> direnv is an environment variable manager for your shell. It knows how to hook into bash, zsh and fish shell to load or unload environment variables depending on your current directory. This allows to have project-specific environment variables and not clutter the "~/.profile" file.

## Dependency
* Eigen 3
* ...
