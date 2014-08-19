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
LOCAL_MODULE := libcaffe
# LOCAL_MODULE_TAGS := optional

CXX_SRC :=  \
src/caffe/syncedmem.cpp \
src/caffe/util/upgrade_proto.cpp \
src/caffe/util/math_functions.cpp \
src/caffe/util/insert_splits.cpp \
src/caffe/util/im2col.cpp \
src/caffe/util/io.cpp \
src/caffe/blob.cpp \
src/caffe/net.cpp \
src/caffe/layers/pooling_layer.cpp \
src/caffe/layers/argmax_layer.cpp \
src/caffe/layers/relu_layer.cpp \
src/caffe/layers/split_layer.cpp \
src/caffe/layers/euclidean_loss_layer.cpp \
src/caffe/layers/power_layer.cpp \
src/caffe/layers/slice_layer.cpp \
src/caffe/layers/threshold_layer.cpp \
src/caffe/layers/dropout_layer.cpp \
src/caffe/layers/concat_layer.cpp \
src/caffe/layers/multinomial_logistic_loss_layer.cpp \
src/caffe/layers/tanh_layer.cpp \
src/caffe/layers/loss_layer.cpp \
src/caffe/layers/im2col_layer.cpp \
src/caffe/layers/softmax_layer.cpp \
src/caffe/layers/flatten_layer.cpp \
src/caffe/layers/sigmoid_layer.cpp \
src/caffe/layers/eltwise_layer.cpp \
src/caffe/layers/bnll_layer.cpp \
src/caffe/layers/hinge_loss_layer.cpp \
src/caffe/layers/infogain_loss_layer.cpp \
src/caffe/layers/softmax_loss_layer.cpp \
src/caffe/layers/sigmoid_cross_entropy_loss_layer.cpp \
src/caffe/layers/conv_layer.cpp \
src/caffe/layers/lrn_layer.cpp \
src/caffe/layers/inner_product_layer.cpp \
src/caffe/layers/neuron_layer.cpp \
src/caffe/layers/accuracy_layer.cpp \
src/caffe/common.cpp \
src/caffe/layer_factory.cpp

LOCAL_SRC_FILES := $(CXX_SRC)
LOCAL_C_INCLUDES := $(LOCAL_PATH)/eigen3 $(LOCAL_PATH)/src $(LOCAL_PATH)/include

LOCAL_STATIC_LIBRARIES += protobuf

# LOCAL_SHARED_LIBRARIES := libz libcutils libutils
# LOCAL_LDLIBS := -lz

# Define the header files to be copied
#LOCAL_COPY_HEADERS := \
#    src/google/protobuf/stubs/once.h \
#    src/google/protobuf/stubs/common.h \
#    src/google/protobuf/io/coded_stream.h \
#    src/google/protobuf/generated_message_util.h \
#    src/google/protobuf/repeated_field.h \
#    src/google/protobuf/extension_set.h \
#    src/google/protobuf/wire_format_lite_inl.h
#
#LOCAL_COPY_HEADERS_TO := $(LOCAL_MODULE)
LOCAL_CPPFLAGS   += -fexceptions -frtti -std=c++11 -DUSE_EIGEN -DCPU_ONLY

include $(BUILD_STATIC_LIBRARY)
