Caffe-Android-Lib
===============
## Goal
Porting [caffe](https://github.com/BVLC/caffe) to android platform

## Build
Tested with Android NDK r10e and cmake 3.2.2 on Ubuntu 14.04

```
git clone --recursive https://github.com/sh1r0/caffe-android-lib.git
cd caffe-android-lib
./build.sh <path/to/ndk>
```

## TODO
- [ ] integrate using CMake's ExternalProject
- [ ] add IO dependency support (e.g., lmdb)

## Optional
`.envrc` files are for [direnv](http://direnv.net/)
> direnv is an environment variable manager for your shell. It knows how to hook into bash, zsh and fish shell to load or unload environment variables depending on your current directory. This allows to have project-specific environment variables and not clutter the "~/.profile" file.

## Dependency
* Eigen 3
* ...
