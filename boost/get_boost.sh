#!/usr/bin/env sh
set -e

BOOST_VER1=1
BOOST_VER2=56
BOOST_VER3=0

BOOST_DOWNLOAD_LINK="http://downloads.sourceforge.net/project/boost/boost/$BOOST_VER1.$BOOST_VER2.$BOOST_VER3/boost_${BOOST_VER1}_${BOOST_VER2}_${BOOST_VER3}.tar.bz2?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fboost%2Ffiles%2Fboost%2F${BOOST_VER1}.${BOOST_VER2}.${BOOST_VER3}%2F&ts=1291326673&use_mirror=garr"
BOOST_TAR="boost_${BOOST_VER1}_${BOOST_VER2}_${BOOST_VER3}.tar.bz2"
BOOST_DIR="boost_${BOOST_VER1}_${BOOST_VER2}_${BOOST_VER3}"

if [ ! -e $BOOST_TAR ]; then
    echo "downloadng boost..."
    wget -O $BOOST_TAR $BOOST_DOWNLOAD_LINK
fi

if [ ! -d $BOOST_DIR ]; then
    tar -jxf $BOOST_TAR
fi

patch -N -r - $BOOST_DIR/boost/thread/pthread/thread_data.hpp < patches/thread_data.hpp.patch || exit 0
