# Install necessary packages
echo "Installing necessary packages"
sudo apt-get update && sudo apt-get install -y --no-install-recommends \
    automake \
    build-essential \
    ca-certificates \
    curl \
    cmake \
    file \
    libtool \
    pkg-config \
    unzip \
    wget
echo "Package Installation completed"

echo "Getting OpenBLAS"
git clone --recursive https://github.com/solrex/caffe-mobile.git

# Setup Patch - Caffe Mobile
cp patch/caffe-mobile/build-openblas.sh caffe-mobile/third_party/

echo "Using NDK: "
echo $NDK_ROOT

echo "Building OpenBLAS"
# Build openblas lib for all ANDROID_ABIs
cd caffe-mobile/third_party
export ANDROID_ABI=arm64-v8a
./build-openblas.sh
export ANDROID_ABI=x86_64
./build-openblas.sh
export ANDROID_ABI=armeabi
./build-openblas.sh
cd ../../

# (DIR caffe-android-lib)

echo "Building Caffe"
# Build Caffe for ANDROID_ABI = arm64-v8a
mkdir -p android_lib
cp -r caffe-mobile/third_party/arm64-v8a-21-OpenBLAS/. android_lib/
export ANDROID_ABI=arm64-v8a
./build-single.sh
mv android_lib android_lib_arm64-v8a

# Build Caffe for ANDROID_ABI = x86_64
mkdir -p android_lib
cp -r caffe-mobile/third_party/x86_64-21-OpenBLAS/. android_lib/
export ANDROID_ABI=x86_64
./build-single.sh
mv android_lib android_lib_x86_64

# Build Caffe for ANDROID_ABI = armeabi
mkdir -p android_lib
cp -r caffe-mobile/third_party/armeabi-21-OpenBLAS/. android_lib/
export ANDROID_ABI=armeabi
./build-single.sh
mv android_lib android_lib_armeabi


echo "Collecting Builds"
# Copy output header files to single distribution directory
mkdir -p distribution/caffe/include
cp -r android_lib_arm64-v8a/include/. distribution/caffe/include
cp -r android_lib_arm64-v8a/boost/include/. distribution/caffe/include
cp -r android_lib_arm64-v8a/caffe/include/. distribution/caffe/include
cp -r android_lib_arm64-v8a/gflags/include/. distribution/caffe/include
cp -r android_lib_arm64-v8a/glog/include/. distribution/caffe/include
cp -r android_lib_arm64-v8a/protobuf/include/. distribution/caffe/include
cp -r opencv/include/. distribution/caffe/include
rm distribution/caffe/include/CMakeLists.txt

# Copy output .so files to single distribution directory
mkdir -p distribution/caffe/lib/arm64-v8a
cp android_lib_arm64-v8a/caffe/lib/libcaffe.so distribution/caffe/lib/arm64-v8a
cp android_lib_arm64-v8a/caffe/lib/libcaffe_jni.so distribution/caffe/lib/arm64-v8a

mkdir -p distribution/caffe/lib/x86_64
cp android_lib_x86_64/caffe/lib/libcaffe.so distribution/caffe/lib/x86_64
cp android_lib_x86_64/caffe/lib/libcaffe_jni.so distribution/caffe/lib/x86_64

mkdir -p distribution/caffe/lib/armeabi
cp android_lib_armeabi/caffe/lib/libcaffe.so distribution/caffe/lib/armeabi
cp android_lib_armeabi/caffe/lib/libcaffe_jni.so distribution/caffe/lib/armeabi

echo ""
echo "Android Caffe Build Completed. Get it from distribution directory"
echo "Copy distribution directory to your android project and give its path in CMakeList"
echo ""