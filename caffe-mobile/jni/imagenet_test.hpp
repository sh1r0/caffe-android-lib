#ifndef IMAGENET_TEST_HPP_
#define IMAGENET_TEST_HPP_

#include <string>
#include "caffe/caffe.hpp"

using std::string;

namespace caffe {

class ImageNet
{
public:
	ImageNet(string model_path, string weights_path);
	~ImageNet();

	int test(string img_path);

	vector<int> predict_top_k(string img_path, int k=3);

private:
	Net<float> *caffe_net;
};

} // namespace caffe

#endif
