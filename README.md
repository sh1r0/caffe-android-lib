Caffe-Android-Lib
===============
## Goal
Porting [caffe](https://github.com/BVLC/caffe) to android platform

### Support
* Up-to-date caffe ([03a84bf](https://github.com/BVLC/caffe/commit/03a84bf464dd47bcec9ac943f0229a758c627f05))
* CPU only
* Without support for some IO libs (leveldb, lmdb and hdf5)

## Build
Tested with Android NDK r10e and cmake 3.2.2 on Ubuntu 14.04

```shell
git clone --recursive https://github.com/sh1r0/caffe-android-lib.git
cd caffe-android-lib
./build.sh <path/to/ndk>
```

### OpenBLAS
In general, Eigen is used as the underlying BLAS library to build caffe in this project, since OpenBLAS for Android supports arm-based processors only.
But if you hope to use OpenBLAS instead, please check the following steps.

```shell
# 1. set OpenBLAS usage explicitly
export USE_OPENBLAS=1  # if 0, Eigen is used

# 2. specify ANDROID_ABI in either case
# "armeabi-v7a with NEON": use the prebuilt library (not recommended, slower than Eigen)
# "armeabi-v7a-hard-softfp with NEON": build from the lastest sources
export ANDROID_ABI="armeabi-v7a-hard-softfp with NEON"  # or "armeabi-v7a with NEON"

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
- [ ] add IO dependency support (e.g., lmdb)
- [ ] OpenCL support
- [ ] CUDA suuport

## Optional
`.envrc` files are for [direnv](http://direnv.net/)
> direnv is an environment variable manager for your shell. It knows how to hook into bash, zsh and fish shell to load or unload environment variables depending on your current directory. This allows to have project-specific environment variables and not clutter the "~/.profile" file.

## Dependency
* Eigen 3
* ...
