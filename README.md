Caffe-Android-Lib
===============
## Goal
Porting [caffe](https://github.com/BVLC/caffe) to android platform

### Support
* Up-to-date caffe ([d91572d](https://github.com/BVLC/caffe/commit/d91572da2ea5e63c9eaacaf013dfbcbc0ada5f67))
* CPU only
* Without support for some IO libs (leveldb and hdf5)

## Build
Tested with Android NDK r11c and cmake 3.3.2 on Ubuntu 14.04

```shell
git clone --recursive https://github.com/sh1r0/caffe-android-lib.git
cd caffe-android-lib
export ANDROID_ABI="arm64-v8a" # Optional, see the note below
./build.sh <path/to/ndk>
```

### Qualcomm Snapdragon Math Libraries (QSML)
QSML is a high performance implementation of BLAS and LAPACK for Snapdragon.  QSML can be
downloaded from the Qualcomm Developer Network [here](https://developer.qualcomm.com/software/snapdragon-math-libraries).
Once QSML is installed, it can be enabled by setting:

```
export USE_QSML=1
```

By default, we assume QSML version 0.15.2, this can be changed by changing the appropriate environment variable below.  We also assume the default installation directory.  For instance:

```
export QSML_VERSION=0.15.2

export QSML\_ROOT\_DIR=/opt/Qualcomm/QSML-$QSML_VERSION/
```

If you run into any problems or have any questions, feel free to contact us at our [forums](https://developer.qualcomm.com/forums/software/snapdragon-math-libraries) or via [email](qsml@qti.qualcomm.com).

### NOTE: OpenBLAS
OpenBLAS is one of the supported BLAS choices, and the supported ABIs are the following:

* `armeabi`
* `armeabi-v7a-hard-softfp with NEON`
* `arm64-v8a` (default)
* `x86`
* `x86_64`

## Issues

Any comments, issues or PRs are welcomed.
Thanks.

## TODO
- [ ] integrate using CMake's ExternalProject
- [ ] add IO dependency support (i.e., leveldb and hdf5)
- [ ] OpenCL support
- [ ] CUDA suuport

## Optional
`.envrc` files are for [direnv](http://direnv.net/)
> direnv is an environment variable manager for your shell. It knows how to hook into bash, zsh and fish shell to load or unload environment variables depending on your current directory. This allows to have project-specific environment variables and not clutter the "~/.profile" file.
