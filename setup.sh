#!/bin/bash
#

PROTOBUF_DIR=protobuf
if [ ! -f "$PROTOBUF_DIR/jni/comfigure"]; then
	if [ ! -f "protobuf-2.5.0.tar.bz2"]; then
		wget https://protobuf.googlecode.com/files/protobuf-2.5.0.tar.bz2
	fi
	tar jxf protobuf-2.5.0.tar.bz2 -C "$PROTOBUF_DIR"
	mv $PROTOBUF_DIR/protobuf-2.5.0/* $PROTOBUF_DIR/jni
	rmdir $PROTOBUF_DIR/protobuf-2.5.0/
fi

EIGEN_DIR=eigen3
if [ ! -d "caffe-mobile/jni/$EIGEN_DIR"]; then
	if [ ! -f "3.2.2.tar.bz2"]; then
		wget http://bitbucket.org/eigen/eigen/get/3.2.2.tar.bz2
	fi
	tar jxf 3.2.2.tar.bz2
	mv eigen-eigen-1306d75b4a21 $EIGEN_DIR
fi
