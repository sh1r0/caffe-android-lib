#!/usr/bin/env python

import os
import shutil
from subprocess import call

ROOT_DIR = os.path.dirname(os.path.abspath(__file__))
CAFFE_DIR = os.path.join(ROOT_DIR, 'caffe-mobile/jni/caffe')

call(['python', os.path.join(CAFFE_DIR, 'scripts/download_model_binary.py'), os.path.join(CAFFE_DIR, 'models/bvlc_reference_caffenet')])
