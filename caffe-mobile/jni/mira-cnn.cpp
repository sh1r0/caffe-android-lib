#include <string.h>
#include <jni.h>
#include <android/log.h>
#include <string>

#include "caffe/caffe.hpp"
#include "test.hpp"

#define  LOG_TAG    "MiRA-CNN"
#define  LOGV(...)  __android_log_print(ANDROID_LOG_VERBOSE,LOG_TAG, __VA_ARGS__)
#define  LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG,LOG_TAG, __VA_ARGS__)
#define  LOGI(...)  __android_log_print(ANDROID_LOG_INFO,LOG_TAG, __VA_ARGS__)
#define  LOGW(...)  __android_log_print(ANDROID_LOG_WARN,LOG_TAG, __VA_ARGS__)
#define  LOGE(...)  __android_log_print(ANDROID_LOG_ERROR,LOG_TAG, __VA_ARGS__)

#ifdef __cplusplus
extern "C" {
#endif

int getTimeSec();

jstring JNIEXPORT JNICALL
Java_com_sh1r0_cnn_MainActivity_runTest(JNIEnv* env, jobject thiz)
{
    caffe::LogMessage::Enable(true);
    int t_s = getTimeSec();
    int result = test(string("/sdcard/cnn_test/model.prototxt"), string("/sdcard/cnn_test/caffe_reference_imagenet_model"));
    int t_e = getTimeSec();
    LOGD("time elapsed: %d s", t_e - t_s);
    LOGD("result: %d", result);

    return env->NewStringUTF("OK!");
}

int getTimeSec() {
    struct timespec now;
    clock_gettime(CLOCK_MONOTONIC, &now);
    return (int) now.tv_sec;
}

JavaVM *g_jvm = NULL;
jobject g_obj = NULL;

void JNIEXPORT JNICALL
Java_com_sh1r0_cnn_MainActivity_setJNIEnv(JNIEnv* env, jobject obj)
{
    env->GetJavaVM(&g_jvm);
    g_obj = env->NewGlobalRef(obj);
}

jint JNIEXPORT JNICALL JNI_OnLoad(JavaVM *vm, void *reserved)
{
    JNIEnv* env = NULL;
    jint result = -1;

    if (vm->GetEnv((void**)&env, JNI_VERSION_1_6) != JNI_OK) {
        LOGE("GetEnv failed!");
        return result;
    }

    return JNI_VERSION_1_6;
}

#ifdef __cplusplus
}
#endif
