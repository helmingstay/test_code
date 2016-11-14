# Complete test: Simple OpenCL math benchmark

## Overview
Intel's [Broadwell](https://en.wikipedia.org/wiki/Broadwell_%28microarchitecture%29) chips (and higher) all have an onboard GPU that is OpenCL compatible.  The GPU won't win any speed awards, but it really does work by default, and makes a nice test platform.

Floating-point powers and logarithms are [surprisingly expensive](https://en.wikipedia.org/wiki/Computational_complexity_of_mathematical_operations). Here I've written a simple worker function (i.e., kernel) that evaluates floating point "elementary functions" that cancel each other out, resulting in a simple increment each time through the loop. 

I've tested the same worker function with vanilla C++/STL and OpenCL (using Cpp wrappers). The vanilla `straight.cpp` implementation is very simple and easy to read.  The `opencl.cpp` has a tremendous amount of boilerplate, argument passing, etc.  But I find the later to be ~20x faster, which is on par with the number of compute nodes my GPU has (24). So, the benefit seems quite real. Here's hoping Cpp17 and SYCL will simplify the logistics for us soon.


## Details

* Tested with intel i5-5300U (broadwell), Debian Jessie
* Install prereqs: `sudo apt-get install opencl-clhpp-headers beignet-dev beignet-opencl-icd intel-gpu-tools`
* Run with: `make; time./opencl; time ./straight`
* Credits: [OpenCL example](http://simpleopencl.blogspot.com/2013/06/tutorial-simple-start-with-opencl-and-c.html)

## Testing
* Play with values in `const.h`
  * `the_dim` and `max_iter` determine job size
  * `opencl` fails for small `the_dim`, and some sizes of `the_grp`
* Try an alternate kernel (uncomment) to see how functions can differ between C++ STL and OpenCL
