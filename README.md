Caffe-Android-Lib
===============
## Goal
Porting [caffe](https://github.com/BVLC/caffe) to android platform

## Build
Tested with Android NDK r10e and cmake 3.2.2 on Ubuntu 14.04

```
git clone --recursive https://github.com/sh1r0/caffe-android-lib.git
cd caffe-android-lib
./build.sh $(NDK_PATH)
```

Note:
If you would like to have boost libraries for armeabi-v7a-hard, there are pre-built ones in [CrystaX NDK](https://www.crystax.net/android/ndk).

## TODO
- [ ] integrate using CMake's ExternalProject
- [ ] add IO dependency support (e.g., lmdb)

## Optional
`.envrc` files are for [direnv](http://direnv.net/)
> direnv is an environment variable manager for your shell. It knows how to hook into bash, zsh and fish shell to load or unload environment variables depending on your current directory. This allows to have project-specific environment variables and not clutter the "~/.profile" file.

## Dependency
* [Boost-for-Android](https://github.com/MysticTreeGames/Boost-for-Android)
* [protobuf](https://code.google.com/p/protobuf)
* ...
