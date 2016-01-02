#!/usr/bin/env sh
set -e

VIENNACL_VER1=1
VIENNACL_VER2=7
VIENNACL_VER3=0

VIENNACL_DOWNLOAD_LINK="http://sourceforge.net/projects/viennacl/files/${VIENNACL_VER1}.${VIENNACL_VER2}.x/ViennaCL-${VIENNACL_VER1}.${VIENNACL_VER2}.${VIENNACL_VER3}.tar.gz/download"
VIENNACL_TAR="ViennaCL-${VIENNACL_VER1}.${VIENNACL_VER2}.${VIENNACL_VER3}.tar.gz"
VIENNACL_DIR=ViennaCL-${VIENNACL_VER1}.${VIENNACL_VER2}.${VIENNACL_VER3}

WD=$(readlink -f "`dirname $0`/..")
DOWNLOAD_DIR=${WD}/download
INSTALL_DIR=${WD}/android_lib

[ ! -d ${INSTALL_DIR} ] && mkdir -p ${INSTALL_DIR}

[ ! -d ${DOWNLOAD_DIR} ] && mkdir -p ${DOWNLOAD_DIR}

cd "${DOWNLOAD_DIR}"
if [ ! -f ${VIENNACL_TAR} ]; then
    wget -O ${VIENNACL_TAR} ${VIENNACL_DOWNLOAD_LINK}
fi

if [ ! -d "${INSTALL_DIR}/${VIENNACL_DIR}" ]; then
    tar -zxf ${VIENNACL_TAR}
    mv "${VIENNACL_DIR}" "${INSTALL_DIR}"
fi

cd "${WD}"
