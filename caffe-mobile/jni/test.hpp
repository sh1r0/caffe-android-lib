#include <string>
// #include <vector>

#include "caffe/caffe.hpp"

using std::string;
using std::shared_ptr;
using std::static_pointer_cast;

using caffe::Blob;
using caffe::Caffe;
using caffe::Net;
using caffe::vector;
using caffe::ImageDataLayer;

// Test: score a model.
int test(string model_path, string weights_path, string img_path) {
	CHECK_GT(model_path.size(), 0) << "Need a model definition to score.";
	CHECK_GT(weights_path.size(), 0) << "Need model weights to score.";

	Caffe::set_mode(Caffe::CPU);
	Caffe::set_phase(Caffe::TEST);

	Net<float> caffe_net(model_path);
	caffe_net.CopyTrainedLayersFrom(weights_path);
/*
	const vector<Blob<float>*>& result = caffe_net.ForwardPrefilled();
*/
	float loss;
	cv::Mat image = cv::imread(img_path.c_str());
	vector<cv::Mat> images(1, image);
	vector<int> labels(1, 0);
	const shared_ptr<ImageDataLayer<float> > image_data_layer =
		static_pointer_cast<ImageDataLayer<float>>(
			caffe_net.layer_by_name("data"));
	image_data_layer->AddImagesAndLabels(images, labels);
	vector<Blob<float>* > dummy_bottom_vec;
	const vector<Blob<float>*>& result = caffe_net.Forward(dummy_bottom_vec, &loss);

	LOG(INFO)<< "Output result size: "<< result.size();

	const float* argmaxs = result[1]->cpu_data();
	for (int i = 0; i < result[1]->num(); ++i) {
		LOG(INFO)<< " Image: "<< i << " class:" << argmaxs[i];
	}

	return 0;
}
