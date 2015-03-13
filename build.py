#!/usr/bin/env python

import os
import sys
import argparse
import shutil
from subprocess import call
from distutils.dir_util import copy_tree


NDK_PATH = None
PROJECT_LIB = None
BUILD_DIR = None

PROTOBUF_VER = '2.5.0'
PROTOBUF_ARCHIVE = 'protobuf-{0}.tar.bz2'.format(PROTOBUF_VER)
PROTOBUF_URL = 'https://protobuf.googlecode.com/files/{0}'.format(PROTOBUF_ARCHIVE)
PROTOBUF_DIR = 'protobuf-{0}'.format(PROTOBUF_VER)

EIGEN_VER = '3.2.4'
EIGEN_ARCHIVE = '{0}.tar.bz2'.format(EIGEN_VER)
EIGEN_URL = 'http://bitbucket.org/eigen/eigen/get/{0}'.format(EIGEN_ARCHIVE)
EIGEN_TEMP_DIR = 'eigen-eigen-10219c95fe65'

OPENCV_VER = '2.4.9'
OPENCV_ARCHIVE = 'OpenCV-{0}-android-sdk.zip'.format(OPENCV_VER)
OPENCV_URL = 'http://sourceforge.net/projects/opencvlibrary/files/opencv-android/{0}/{1}/download'.format(OPENCV_VER, OPENCV_ARCHIVE)
OPENCV_TEMP_DIR = 'OpenCV-{0}-android-sdk'.format(OPENCV_VER)


def setup():
    # protobuf
    if not os.path.isfile('protobuf/jni/configure'):
        if not os.path.exists(PROTOBUF_ARCHIVE):
            call(['curl', '-O', PROTOBUF_URL])
        call(['tar', 'jxf', PROTOBUF_ARCHIVE])
        for c in os.listdir(PROTOBUF_DIR):
            shutil.move(os.path.join(PROTOBUF_DIR, c), 'protobuf/jni')
        os.rmdir(PROTOBUF_DIR)

    # eigen
    if not os.path.isdir('eigen3'):
        if not os.path.exists(EIGEN_ARCHIVE):
            call(['curl', '-LO', EIGEN_URL])
        call(['tar', 'jxf', EIGEN_ARCHIVE])
        os.rename(EIGEN_TEMP_DIR, 'eigen3')

    # opencv
    if not os.path.isdir('opencv'):
        if not os.path.exists(OPENCV_ARCHIVE):
            call(['curl', '-L', '-o', OPENCV_ARCHIVE, OPENCV_URL])
        call(['unzip', '-u', OPENCV_ARCHIVE])
        shutil.move('{0}/sdk/native'.format(OPENCV_TEMP_DIR), 'opencv')
        shutil.rmtree(OPENCV_TEMP_DIR)


def build_protobuf():
    os.chdir('protobuf')
    os.environ['NDK_PROJECT_PATH'] = os.getcwd()
    call(['ndk-build'])
    os.chdir(BUILD_DIR)


def build_boost():
    if not os.path.isdir('Boost-for-Android/build'):
        os.chdir('Boost-for-Android')
        call(['./build-android.sh', NDK_PATH, '--boost=1.55.0', '--with-libraries=date_time,math,random,thread,system'])
        os.chdir(BUILD_DIR)


def build_caffe():
    os.chdir('caffe-mobile')
    os.environ['NDK_PROJECT_PATH'] = os.getcwd()
    call(['ndk-build'])
    if PROJECT_LIB:
        copy_tree("libs/", PROJECT_LIB)
    os.chdir(BUILD_DIR)


def main(argv):
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "ndk_path",
        help="path to your android ndk"
    )
    parser.add_argument(
        "-L",
        "--project_lib",
        default="",
        help="path to the lib directory of your android project"
    )
    args = parser.parse_args()

    global NDK_PATH
    NDK_PATH = args.ndk_path
    os.environ['PATH'] += os.pathsep + NDK_PATH

    global PROJECT_LIB
    PROJECT_LIB = args.project_lib if args.project_lib else None

    global BUILD_DIR
    BUILD_DIR = os.path.dirname(os.path.abspath(__file__))
    os.chdir(BUILD_DIR)

    setup()

    build_protobuf()
    build_boost()
    build_caffe()


if __name__ == '__main__':
    main(sys.argv[1:])
