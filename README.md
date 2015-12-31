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
By defalut, Eigen is used as the underlying BLAS library to build caffe in this project.
And according to my experiments, there is little performance difference between the builds based on Eigen and OpenBLAS (issue [#27](https://github.com/sh1r0/caffe-android-lib/issues/27)).
But if you really desire to use OpenBLAS instead, please check the following steps.

```shell
# 1. set OpenBLAS usage explicitly
export USE_OPENBLAS=1  # if 0, eigen is used

# 2. specify ANDROID_ABI in either case
# "armeabi-v7a with NEON": use the prebuilt library (bad performance)
# "armeabi-v7a-hard with NEON": build from the lastest sources (see the note below)
export ANDROID_ABI="armeabi-v7a-hard with NEON"  # or "armeabi-v7a with NEON"

# 3. Build
./build.sh <path/to/ndk>
```
Note: For "armeabi-v7a-hard with NEON", you can set `NUM_THREADS` to fit your need in `scripts/build_openblas_hard.sh`.
By default, it's 1 which means single-threaded.

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
