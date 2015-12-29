#!/usr/bin/env sh

OPENBLAS_DOWNLOAD_LINK="http://sourceforge.net/projects/openblas/files/v0.2.8-arm/openblas-v0.2.8-android-rc1.tar.gz/download"
OPENBLAS_TAR="openblas-v0.2.8-android-rc1.tar.gz"
OPENBLAS_DIR=openblas-android

WD=$(readlink -f "`dirname $0`/..")
DOWNLOAD_DIR=${WD}/download
INSTALL_DIR=${WD}/android_lib

[ ! -d ${INSTALL_DIR} ] && mkdir -p ${INSTALL_DIR}

[ ! -d ${DOWNLOAD_DIR} ] && mkdir -p ${DOWNLOAD_DIR}

cd "${DOWNLOAD_DIR}"
if [ ! -f ${OPENBLAS_TAR} ]; then
    wget -O ${OPENBLAS_TAR} ${OPENBLAS_DOWNLOAD_LINK}
fi

if [ ! -d "${INSTALL_DIR}/${OPENBLAS_DIR}" ]; then
    tar -zxf ${OPENBLAS_TAR}
    sed -i.bak -e '20d' ${OPENBLAS_DIR}/include/openblas_config.h
    rm -f ${OPENBLAS_DIR}/lib/*.so*
    mv "${OPENBLAS_DIR}" "${INSTALL_DIR}"
fi

cd "${WD}"
