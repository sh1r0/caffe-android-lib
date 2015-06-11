LOCAL_PATH := $(call my-dir)

# C++ full library
# =======================================================
## Import Protocolbuffer
include $(CLEAR_VARS)
LOCAL_MODULE := protobuf
LOCAL_SRC_FILES = $(LOCAL_PATH)/../../protobuf/obj/local/$(TARGET_ARCH_ABI)/libprotobuf.a
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/../../protobuf/jni/src
include $(PREBUILT_STATIC_LIBRARY)

#-----------------------------------------------------------------------------
include $(CLEAR_VARS)

OpenCV_INSTALL_MODULES := on
OPENCV_CAMERA_MODULES := off
OPENCV_LIB_TYPE := STATIC
include $(LOCAL_PATH)/../../opencv/jni/OpenCV.mk

LOCAL_MODULE := caffe
# LOCAL_MODULE_TAGS := optional

CAFFE_CXX_SRCS := \
src/caffe/blob.cpp \
src/caffe/common.cpp \
src/caffe/data_transformer.cpp \
src/caffe/internal_thread.cpp \
src/caffe/layer_factory.cpp \
src/caffe/layers/absval_layer.cpp \
src/caffe/layers/accuracy_layer.cpp \
src/caffe/layers/argmax_layer.cpp \
src/caffe/layers/base_conv_layer.cpp \
src/caffe/layers/base_data_layer.cpp \
src/caffe/layers/bnll_layer.cpp \
src/caffe/layers/concat_layer.cpp \
src/caffe/layers/contrastive_loss_layer.cpp \
src/caffe/layers/conv_layer.cpp \
src/caffe/layers/deconv_layer.cpp \
src/caffe/layers/dropout_layer.cpp \
src/caffe/layers/dummy_data_layer.cpp \
src/caffe/layers/eltwise_layer.cpp \
src/caffe/layers/euclidean_loss_layer.cpp \
src/caffe/layers/exp_layer.cpp \
src/caffe/layers/flatten_layer.cpp \
src/caffe/layers/hinge_loss_layer.cpp \
src/caffe/layers/im2col_layer.cpp \
src/caffe/layers/image_data_layer.cpp \
src/caffe/layers/infogain_loss_layer.cpp \
src/caffe/layers/inner_product_layer.cpp \
src/caffe/layers/loss_layer.cpp \
src/caffe/layers/lrn_layer.cpp \
src/caffe/layers/memory_data_layer.cpp \
src/caffe/layers/multinomial_logistic_loss_layer.cpp \
src/caffe/layers/mvn_layer.cpp \
src/caffe/layers/neuron_layer.cpp \
src/caffe/layers/pooling_layer.cpp \
src/caffe/layers/power_layer.cpp \
src/caffe/layers/relu_layer.cpp \
src/caffe/layers/sigmoid_cross_entropy_loss_layer.cpp \
src/caffe/layers/sigmoid_layer.cpp \
src/caffe/layers/silence_layer.cpp \
src/caffe/layers/slice_layer.cpp \
src/caffe/layers/softmax_layer.cpp \
src/caffe/layers/softmax_loss_layer.cpp \
src/caffe/layers/split_layer.cpp \
src/caffe/layers/tanh_layer.cpp \
src/caffe/layers/threshold_layer.cpp \
src/caffe/layers/window_data_layer.cpp \
src/caffe/net.cpp \
src/caffe/solver.cpp \
src/caffe/syncedmem.cpp \
src/caffe/util/benchmark.cpp \
src/caffe/util/im2col.cpp \
src/caffe/util/insert_splits.cpp \
src/caffe/util/io.cpp \
src/caffe/util/math_functions_eigen.cpp \
src/caffe/util/upgrade_proto.cpp \

PRORO_CC := caffe/src/caffe/proto/caffe.pb.cc

LOCAL_SRC_FILES := $(PRORO_CC) \
    $(foreach caffe_cxx_src,$(CAFFE_CXX_SRCS),caffe/$(caffe_cxx_src))
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../eigen3 \
    $(LOCAL_PATH)/caffe/include $(LOCAL_PATH)/caffe/include/caffe/proto \
    $(LOCAL_PATH)/../../Boost-for-Android/build/include/boost-1_55 \
    $(LOCAL_PATH)/../../opencv/jni/include

LOCAL_STATIC_LIBRARIES += protobuf
LOCAL_CPPFLAGS += -pthread -fPIC -fexceptions -frtti -std=c++11 -DUSE_EIGEN -DCPU_ONLY

# boost
LOCAL_LDLIBS += -lm -llog -L$(LOCAL_PATH)/../../Boost-for-Android/build/lib/
LOCAL_LDLIBS += -lboost_random-gcc-mt-1_55 \
                -lboost_math_tr1-gcc-mt-1_55 \
                -lboost_system-gcc-mt-1_55 \
                -lboost_thread-gcc-mt-1_55 \
                -lboost_date_time-gcc-mt-1_55 \
                -lboost_atomic-gcc-mt-1_55

LOCAL_ARM_MODE := arm
ifeq ($(TARGET_ARCH_ABI), armeabi-v7a)
LOCAL_ARM_NEON := true
endif

include $(BUILD_SHARED_LIBRARY)

#-----------------------------------------------------------------------------
include $(CLEAR_VARS)
LOCAL_MODULE := caffe_jni

LOCAL_SRC_FILES := caffe_jni.cpp caffe_mobile.cpp
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../eigen3 $(LOCAL_PATH)/caffe/include \
$(LOCAL_PATH)/../../Boost-for-Android/build/include/boost-1_55 \
$(LOCAL_PATH)/../../opencv/jni/include

# LOCAL_STATIC_LIBRARIES += caffe
LOCAL_SHARED_LIBRARIES := caffe
LOCAL_LDLIBS := -lm -llog
LOCAL_CPPFLAGS += -fexceptions -frtti -std=c++11 -DUSE_EIGEN -DCPU_ONLY

LOCAL_ARM_MODE  := arm

include $(BUILD_SHARED_LIBRARY)
# include $(BUILD_EXECUTABLE)
