#include <string>
#include <vector>

#include "caffe/caffe.hpp"

using std::string;

using caffe::Blob;
using caffe::Caffe;
using caffe::Net;
using caffe::vector;

// Test: score a model.
int test(string model_path, string weights_path) {
	CHECK_GT(model_path.size(), 0) << "Need a model definition to score.";
	CHECK_GT(weights_path.size(), 0) << "Need model weights to score.";

	Caffe::set_mode(Caffe::CPU);
	// Instantiate the caffe net.
	Caffe::set_phase(Caffe::TEST);
	Net<float> caffe_net(model_path);
	caffe_net.CopyTrainedLayersFrom(weights_path);
	LOG(INFO) << "start forwarding";
	const vector<Blob<float>*>& result = caffe_net.ForwardPrefilled();
	LOG(INFO) << "forward done";

	int max_i = 0;
	float max_val = result[1]->cpu_data()[0];
	for (int i = 1; i < result[1]->count(); i++) {
		if (result[1]->cpu_data()[i] > max_val) {
			max_i = i;
			max_val = result[1]->cpu_data()[i];
		}
	}

	return max_i;
}
