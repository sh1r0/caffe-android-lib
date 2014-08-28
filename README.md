MiRA-CNN-Mobile
===============
## Goal
Porting [caffe](https://github.com/BVLC/caffe) to android platform for running convolutional neural network prediction on mobile

## Usage
```
git clone --recursive https://github.com/sh1r0/mira-cnn-mobile.git
(specify your NDK_PATH, PROJECT_LIB_PATH in build.py)
./build.py
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
