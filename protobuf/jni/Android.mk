LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

COMPILER_SRC_FILES :=  \
src/google/protobuf/descriptor.cc \
src/google/protobuf/descriptor.pb.cc \
src/google/protobuf/descriptor_database.cc \
src/google/protobuf/dynamic_message.cc \
src/google/protobuf/extension_set.cc \
src/google/protobuf/extension_set_heavy.cc \
src/google/protobuf/generated_message_reflection.cc \
src/google/protobuf/generated_message_util.cc \
src/google/protobuf/message.cc \
src/google/protobuf/message_lite.cc \
src/google/protobuf/reflection_ops.cc \
src/google/protobuf/repeated_field.cc \
src/google/protobuf/service.cc \
src/google/protobuf/text_format.cc \
src/google/protobuf/unknown_field_set.cc \
src/google/protobuf/wire_format.cc \
src/google/protobuf/wire_format_lite.cc \
src/google/protobuf/io/coded_stream.cc \
src/google/protobuf/io/gzip_stream.cc \
src/google/protobuf/io/printer.cc \
src/google/protobuf/io/tokenizer.cc \
src/google/protobuf/io/zero_copy_stream.cc \
src/google/protobuf/io/zero_copy_stream_impl.cc \
src/google/protobuf/io/zero_copy_stream_impl_lite.cc \
src/google/protobuf/stubs/common.cc \
src/google/protobuf/stubs/once.cc \
src/google/protobuf/stubs/structurally_valid.cc \
src/google/protobuf/stubs/strutil.cc \
src/google/protobuf/stubs/stringprintf.cc \
src/google/protobuf/stubs/substitute.cc

# C++ full library
# =======================================================
#include $(CLEAR_VARS)

LOCAL_MODULE := protobuf
LOCAL_MODULE_TAGS := optional

LOCAL_CPP_EXTENSION := .cc

LOCAL_SRC_FILES := $(COMPILER_SRC_FILES)

LOCAL_C_INCLUDES := $(LOCAL_PATH)/src

LOCAL_C_INCLUDES := \
$(LOCAL_PATH)/android \
bionic \
$(LOCAL_PATH)/src \
$(JNI_H_INCLUDE)

# LOCAL_SHARED_LIBRARIES := libz libcutils libutils
# LOCAL_LDLIBS := -lz

# stlport conflicts with the host stl library
#ifneq ($(TARGET_SIMULATOR),true)
#LOCAL_C_INCLUDES += external/stlport/stlport
#LOCAL_SHARED_LIBRARIES += libstlport
#endif

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
LOCAL_CPPFLAGS   += -frtti
LOCAL_CFLAGS   += -frtti
# LOCAL_CFLAGS := -DGOOGLE_PROTOBUF_NO_RTTI

include $(BUILD_STATIC_LIBRARY)
