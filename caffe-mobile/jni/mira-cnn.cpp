#include <string.h>
#include <jni.h>
#include <android/log.h>
#include <string>

#include "caffe/caffe.hpp"
#include "imagenet_test.hpp"

#define  LOG_TAG    "MiRA-CNN"
#define  LOGV(...)  __android_log_print(ANDROID_LOG_VERBOSE,LOG_TAG, __VA_ARGS__)
#define  LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG,LOG_TAG, __VA_ARGS__)
#define  LOGI(...)  __android_log_print(ANDROID_LOG_INFO,LOG_TAG, __VA_ARGS__)
#define  LOGW(...)  __android_log_print(ANDROID_LOG_WARN,LOG_TAG, __VA_ARGS__)
#define  LOGE(...)  __android_log_print(ANDROID_LOG_ERROR,LOG_TAG, __VA_ARGS__)

#ifdef __cplusplus
extern "C" {
#endif

caffe::ImageNet *image_net;

int getTimeSec();

jint JNIEXPORT JNICALL
Java_com_sh1r0_caffe_1android_1demo_ImageNet_initTest(JNIEnv* env, jobject thiz)
{
    caffe::LogMessage::Enable(true);
    image_net = new caffe::ImageNet(string("/sdcard/cnn_test/model.prototxt"), string("/sdcard/cnn_test/caffe_reference_imagenet_model"));

    return 0;
}

jint JNIEXPORT JNICALL
Java_com_sh1r0_caffe_1android_1demo_ImageNet_runTest(JNIEnv* env, jobject thiz, jstring imgPath)
{
    caffe::LogMessage::Enable(true);

    const char *img_path = env->GetStringUTFChars(imgPath, 0);
    // /sdcard/cnn_test/images/cat.jpg

    int result = image_net->test(string(img_path));

    LOGD("result: %d", result);

    env->ReleaseStringUTFChars(imgPath, img_path);

    return result;
}

int getTimeSec() {
    struct timespec now;
    clock_gettime(CLOCK_MONOTONIC, &now);
    return (int) now.tv_sec;
}
/*
JavaVM *g_jvm = NULL;
jobject g_obj = NULL;

void JNIEXPORT JNICALL
Java_com_sh1r0_caffe_1android_1demo_MainActivity_MainActivity_setJNIEnv(JNIEnv* env, jobject obj)
{
    env->GetJavaVM(&g_jvm);
    g_obj = env->NewGlobalRef(obj);
}
*/
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
