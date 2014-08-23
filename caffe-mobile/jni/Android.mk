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
include $(LOCAL_PATH)/../../opencv/jni/OpenCV.mk
LOCAL_MODULE := caffe
# LOCAL_MODULE_TAGS := optional

CXX_SRCS := \
caffe/src/caffe/syncedmem.cpp \
caffe/src/caffe/util/upgrade_proto.cpp \
caffe/src/caffe/util/math_functions.cpp \
caffe/src/caffe/util/insert_splits.cpp \
caffe/src/caffe/util/im2col.cpp \
caffe/src/caffe/util/io.cpp \
caffe/src/caffe/blob.cpp \
caffe/src/caffe/net.cpp \
caffe/src/caffe/layers/pooling_layer.cpp \
caffe/src/caffe/layers/argmax_layer.cpp \
caffe/src/caffe/layers/relu_layer.cpp \
caffe/src/caffe/layers/split_layer.cpp \
caffe/src/caffe/layers/power_layer.cpp \
caffe/src/caffe/layers/slice_layer.cpp \
caffe/src/caffe/layers/threshold_layer.cpp \
caffe/src/caffe/layers/concat_layer.cpp \
caffe/src/caffe/layers/tanh_layer.cpp \
caffe/src/caffe/layers/im2col_layer.cpp \
caffe/src/caffe/layers/softmax_layer.cpp \
caffe/src/caffe/layers/flatten_layer.cpp \
caffe/src/caffe/layers/sigmoid_layer.cpp \
caffe/src/caffe/layers/eltwise_layer.cpp \
caffe/src/caffe/layers/bnll_layer.cpp \
caffe/src/caffe/layers/conv_layer.cpp \
caffe/src/caffe/layers/lrn_layer.cpp \
caffe/src/caffe/layers/inner_product_layer.cpp \
caffe/src/caffe/layers/neuron_layer.cpp \
caffe/src/caffe/layers/accuracy_layer.cpp \
caffe/src/caffe/common.cpp \
caffe/src/caffe/layer_factory.cpp \
caffe/src/caffe/layers/euclidean_loss_layer.cpp \
caffe/src/caffe/layers/multinomial_logistic_loss_layer.cpp \
caffe/src/caffe/layers/loss_layer.cpp \
caffe/src/caffe/layers/hinge_loss_layer.cpp \
caffe/src/caffe/layers/infogain_loss_layer.cpp \
caffe/src/caffe/layers/softmax_loss_layer.cpp \
caffe/src/caffe/layers/sigmoid_cross_entropy_loss_layer.cpp \
caffe/src/caffe/layers/dropout_layer.cpp \
caffe/src/caffe/layers/image_data_layer.cpp

PRORO_CC := caffe/src/caffe/proto/caffe.pb.cc \
caffe/src/caffe/proto/caffe_pretty_print.pb.cc

LOCAL_SRC_FILES := $(CXX_SRCS) $(PRORO_CC)
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../eigen3 $(LOCAL_PATH)/caffe/include \
$(LOCAL_PATH)/../../boost/include/boost-1_55 \
$(LOCAL_PATH)/../../opencv/jni/include

LOCAL_STATIC_LIBRARIES += protobuf
LOCAL_CPPFLAGS += -fPIC -fexceptions -frtti -std=c++11 -DUSE_EIGEN -DCPU_ONLY

# boost
LOCAL_LDLIBS += -llog -L$(LOCAL_PATH)/../../boost/lib/
LOCAL_LDLIBS += -lboost_random-gcc-mt-1_55 -lboost_math_tr1-gcc-mt-1_55

# LOCAL_ARM_MODE  := arm

include $(BUILD_SHARED_LIBRARY)

#-----------------------------------------------------------------------------
include $(CLEAR_VARS)
LOCAL_MODULE := mira-cnn

LOCAL_SRC_FILES := mira-cnn.cpp
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../eigen3 $(LOCAL_PATH)/caffe/include \
$(LOCAL_PATH)/../../boost/include/boost-1_55 \
$(LOCAL_PATH)/../../opencv/jni/include

# LOCAL_STATIC_LIBRARIES += caffe
LOCAL_SHARED_LIBRARIES := caffe
LOCAL_LDLIBS := -llog
LOCAL_CPPFLAGS += -fexceptions -frtti -std=c++11 -DUSE_EIGEN -DCPU_ONLY

# LOCAL_ARM_MODE  := arm

include $(BUILD_SHARED_LIBRARY)
