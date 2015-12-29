#!/usr/bin/env sh
set -e

EIGEN_VER1=3
EIGEN_VER2=2
EIGEN_VER3=7

EIGEN_DOWNLOAD_LINK="http://bitbucket.org/eigen/eigen/get/${EIGEN_VER1}.${EIGEN_VER2}.${EIGEN_VER3}.tar.bz2"
EIGEN_TAR="eigen_${EIGEN_VER1}.${EIGEN_VER2}.${EIGEN_VER3}.tar.bz2"
EIGEN_DIR=eigen3

WD=$(readlink -f "`dirname $0`/..")
DOWNLOAD_DIR=${WD}/download
INSTALL_DIR=${WD}/android_lib

[ ! -d ${INSTALL_DIR} ] && mkdir -p ${INSTALL_DIR}

[ ! -d ${DOWNLOAD_DIR} ] && mkdir -p ${DOWNLOAD_DIR}

cd "${DOWNLOAD_DIR}"
if [ ! -f ${EIGEN_TAR} ]; then
    wget -O ${EIGEN_TAR} ${EIGEN_DOWNLOAD_LINK}
fi

if [ ! -d "${INSTALL_DIR}/${EIGEN_DIR}" ]; then
    tar -jxf ${EIGEN_TAR}
    mv eigen-eigen-*/ "${INSTALL_DIR}/${EIGEN_DIR}"
fi

cd "${WD}"
