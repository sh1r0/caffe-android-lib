#!/usr/bin/env python

import os
import shutil
from subprocess import call
from distutils.dir_util import copy_tree


NDK_PATH = '/home/shiro/android-ndk-r9'
PROJECT_LIB_PATH = '/home/shiro/MiRA-CNN/libs' # optional, android project path
BUILD_DIR = ''

PROTOBUF_URL = 'https://protobuf.googlecode.com/files/protobuf-2.5.0.tar.bz2'
EIGEN_URL = 'http://bitbucket.org/eigen/eigen/get/3.2.2.tar.bz2'
OPENCV_URL = 'http://sourceforge.net/projects/opencvlibrary/files/opencv-android/2.4.9/OpenCV-2.4.9-android-sdk.zip/download'


def setup():
    # protobuf
    if not os.path.isfile('protobuf/jni/configure'):
        if not os.path.exists('protobuf-2.5.0.tar.bz2'):
            call(['wget', PROTOBUF_URL])
        call(['tar', 'jxf', 'protobuf-2.5.0.tar.bz2'])
        for c in os.listdir('protobuf-2.5.0'):
            shutil.move(os.path.join('protobuf-2.5.0', c), 'protobuf/jni')
        os.rmdir('protobuf-2.5.0')

    # eigen
    if not os.path.isdir('eigen3'):
        if not os.path.exists('3.2.2.tar.bz2'):
            call(['wget', EIGEN_URL])
        call(['tar', 'jxf', '3.2.2.tar.bz2'])
        os.rename('eigen-eigen-1306d75b4a21', 'eigen3')

    # opencv
    if not os.path.isdir('opencv'):
        if not os.path.exists('OpenCV-2.4.9-android-sdk.zip'):
            call(['wget', '-O', 'OpenCV-2.4.9-android-sdk.zip', OPENCV_URL])
        call(['unzip', '-u', 'OpenCV-2.4.9-android-sdk.zip'])
        shutil.move('OpenCV-2.4.9-android-sdk/sdk/native', 'opencv')
        shutil.rmtree('OpenCV-2.4.9-android-sdk')


def build_protobuf():
    os.chdir('protobuf')
    os.environ['NDK_PROJECT_PATH'] = os.getcwd()
    call(['ndk-build'])
    os.chdir(BUILD_DIR)


def build_boost():
    if not os.path.isdir('Boost-for-Android/build'):
        os.chdir('Boost-for-Android')
        call(['./build-android.sh', NDK_PATH, '--boost=1.55.0', '--with-libraries=math,random'])
        os.chdir(BUILD_DIR)


def build_caffe():
    os.chdir('caffe-mobile')
    os.environ['NDK_PROJECT_PATH'] = os.getcwd()
    call(['ndk-build'])
    if PROJECT_LIB_PATH:
        copy_tree("libs/", PROJECT_LIB_PATH)
    os.chdir(BUILD_DIR)


def main():
    os.environ['PATH'] += os.pathsep + NDK_PATH

    global BUILD_DIR
    BUILD_DIR = os.path.dirname(os.path.abspath(__file__))
    os.chdir(BUILD_DIR)

    setup()

    build_protobuf()
    build_boost()
    build_caffe()


if __name__ == '__main__':
    main()
