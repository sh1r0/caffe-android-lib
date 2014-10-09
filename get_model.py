#!/usr/bin/env python

import os
import shutil
from subprocess import call


AUX_SH_URL = 'https://raw.githubusercontent.com/sh1r0/caffe/master/data/ilsvrc12/get_ilsvrc_aux.sh'
MODEL_SH_URL = 'https://raw.githubusercontent.com/sh1r0/caffe/master/examples/imagenet/get_caffe_reference_imagenet_model.sh'

ROOT_DIR = os.path.dirname(os.path.abspath(__file__))
TEMP_DIR = os.path.join(ROOT_DIR, 'temp')
CNN_TEST_DIR = os.path.join(ROOT_DIR, 'cnn_test')


os.mkdir(TEMP_DIR)
os.chdir(TEMP_DIR)

call(['curl', '-O', AUX_SH_URL])
call(['curl', '-O', MODEL_SH_URL])

call(['sh', 'get_ilsvrc_aux.sh'])
shutil.move('imagenet_mean.binaryproto', CNN_TEST_DIR)

call(['sh', 'get_caffe_reference_imagenet_model.sh'])
shutil.move('caffe_reference_imagenet_model', CNN_TEST_DIR)

os.chdir(ROOT_DIR)
shutil.rmtree(TEMP_DIR)
