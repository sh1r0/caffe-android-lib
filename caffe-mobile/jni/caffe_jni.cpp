#include <string.h>
#include <jni.h>
#include <android/log.h>
#include <string>

#include "caffe/caffe.hpp"
#include "caffe_mobile.hpp"

#define  LOG_TAG    "MiRA-CNN"
#define  LOGV(...)  __android_log_print(ANDROID_LOG_VERBOSE,LOG_TAG, __VA_ARGS__)
#define  LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG,LOG_TAG, __VA_ARGS__)
#define  LOGI(...)  __android_log_print(ANDROID_LOG_INFO,LOG_TAG, __VA_ARGS__)
#define  LOGW(...)  __android_log_print(ANDROID_LOG_WARN,LOG_TAG, __VA_ARGS__)
#define  LOGE(...)  __android_log_print(ANDROID_LOG_ERROR,LOG_TAG, __VA_ARGS__)

#ifdef __cplusplus
extern "C" {
#endif

caffe::CaffeMobile *caffe_mobile;

int getTimeSec();

static int pfd[2];
static pthread_t thr;
static const char *tag = "myapp";

static void *thread_func(void*) {
    ssize_t rdsz;
    char buf[1024];
    while ((rdsz = read(pfd[0], buf, sizeof(buf) - 1)) > 0) {
        buf[rdsz] = 0;  // add null-terminator
        __android_log_write(ANDROID_LOG_DEBUG, tag, buf);
    }
    return 0;
}

static int start_logger() {
    /* make stdout line-buffered and stderr unbuffered */
    // setvbuf(stdout, 0, _IOLBF, 0);
    setvbuf(stderr, 0, _IONBF, 0);

    /* create the pipe and redirect stdout and stderr */
    pipe(pfd);
    // dup2(pfd[1], 1);
    dup2(pfd[1], 2);

    /* spawn the logging thread */
    if(pthread_create(&thr, 0, thread_func, 0) == -1)
        return -1;
    pthread_detach(thr);
    return 0;
}

void JNIEXPORT JNICALL
Java_com_sh1r0_caffe_1android_1demo_CaffeMobile_enableLog(JNIEnv* env, jobject thiz, jboolean enabled)
{
    start_logger();
    caffe::LogMessage::Enable(enabled != JNI_FALSE);
}

jint JNIEXPORT JNICALL
Java_com_sh1r0_caffe_1android_1demo_CaffeMobile_loadModel(JNIEnv* env, jobject thiz, jstring modelPath, jstring weightsPath)
{
    const char *model_path = env->GetStringUTFChars(modelPath, 0);
    const char *weights_path = env->GetStringUTFChars(weightsPath, 0);
    caffe_mobile = new caffe::CaffeMobile(string(model_path), string(weights_path));
    env->ReleaseStringUTFChars(modelPath, model_path);
    env->ReleaseStringUTFChars(weightsPath, weights_path);
    return 0;
}

jint JNIEXPORT JNICALL
Java_com_sh1r0_caffe_1android_1demo_CaffeMobile_predictImage(JNIEnv* env, jobject thiz, jstring imgPath)
{
    const char *img_path = env->GetStringUTFChars(imgPath, 0);
    caffe::vector<int> top_k = caffe_mobile->predict_top_k(string(img_path), 3);
    LOGD("top-1 result: %d", top_k[0]);

    env->ReleaseStringUTFChars(imgPath, img_path);

    return top_k[0];
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

int main(int argc, char const *argv[])
{
    string usage("usage: main <model> <weights> <img>");
    if (argc < 4) {
        std::cerr << usage << std::endl;
        return 1;
    }

    caffe::LogMessage::Enable(true); // enable logging
    caffe_mobile = new caffe::CaffeMobile(string(argv[1]), string(argv[2]));
    caffe::vector<int> top_3 = caffe_mobile->predict_top_k(string(argv[3]));
    for (auto k : top_3) {
        std::cout << k << std::endl;
    }
    return 0;
}

#ifdef __cplusplus
}
#endif
