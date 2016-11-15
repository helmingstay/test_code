#include <iostream>
#include <CL/cl.hpp>
#include "const.h"
     
int main(){
    // data structure to work on
	auto A = fill(the_dim);

    // buffer size
    const size_t the_size = sizeof(cell_t) * the_dim;
    // setup opencl infrastructure
	//get all platforms (drivers)
	std::vector<cl::Platform> all_platforms;
	cl::Platform::get(&all_platforms);
	if(all_platforms.size()==0){
		std::cout<<" No platforms found. Check OpenCL installation!\n";
		throw std::runtime_error("In opencl.cpp");
	}
	cl::Platform default_platform=all_platforms[0];
	std::cout << "Using platform: "<<default_platform.getInfo<CL_PLATFORM_NAME>()<<"\n";
 
	//get default device of the default platform
	std::vector<cl::Device> all_devices;
	default_platform.getDevices(CL_DEVICE_TYPE_ALL, &all_devices);
	if(all_devices.size()==0){
		std::cout<<" No devices found. Check OpenCL installation!\n";
		throw std::runtime_error("In opencl.cpp");
	}
	cl::Device default_device=all_devices[0];
	std::cout<< "Using device: "<<default_device.getInfo<CL_DEVICE_NAME>()<<"\n";
 
	cl::Context context({default_device});
	//create queue to push commands for device.
	cl::CommandQueue queue(context,default_device);
    // push source here
	cl::Program::Sources sources;
	// kernel - expensive computation to be repeated
	std::string kernel_code=
			"   void kernel make_work(global float* A, float _pow){      "
			"       float this = A[get_global_id(0)];"
            " A[get_global_id(0)]  = log(pow(this,_pow))/log(this)-_pow+ this+1;                 "
            // similar timing, but results differ with non-opencl for max_iter ~> 2
            //" A[get_global_id(0)]  = fmod(pow(this,_pow),1e6)+2.0;"
			"   }      "                                                                         
    "";
	sources.push_back({kernel_code.c_str(),kernel_code.length()});
	cl::Program program(context,sources);

	if(program.build({default_device})!=CL_SUCCESS){
		std::cout<<" Error building: "<<program.getBuildInfo<CL_PROGRAM_BUILD_LOG>(default_device)<<"\n";
		throw std::runtime_error("In opencl.cpp");
	}
    // done with program 

	// create buffer on device, write array 
	cl::Buffer buffer_A(context,CL_MEM_READ_WRITE,the_size);
	queue.enqueueWriteBuffer(buffer_A,CL_TRUE,0,the_size,A.data());

	//set up the kernel and run
	cl::Kernel make_work=cl::Kernel(program,"make_work");
	make_work.setArg(0,buffer_A);
	make_work.setArg(1,the_pow);
    // repeat make_work for whole array
	for(size_t ii{0}; ii<max_iter; ii++) {
        queue.enqueueNDRangeKernel(
            make_work,
            cl::NullRange,cl::NDRange(the_dim),cl::NDRange(the_grp)
        );
        queue.finish();
    }
 
	//read result C from the device to array C
	queue.enqueueReadBuffer(buffer_A,CL_TRUE,0,the_size,A.data());
 
    // print final results
    the_output(A); 
	return 0;
}

