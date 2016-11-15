#include <boost/compute.hpp>
#include <vector>
#include <algorithm>
#include "const.h"

namespace compute = boost::compute;
using boost::compute::lambda::_1;

BOOST_COMPUTE_CLOSURE(cell_t, make_work, (cell_t num), (the_pow,do_mod, the_mod, _one, _two), {
    if (do_mod) {
        return fmod(pow(num,the_pow),the_mod) + _two;
    } else {
        return log(pow(num,the_pow))/log(num) - the_pow + num + _one;
    }
});

int main()
{
    // get the default compute device
    compute::device gpu = compute::system::default_device();
    // create a compute context and command queue
    compute::context ctx(gpu);
    compute::command_queue queue(ctx, gpu);

    auto host_vector = fill(the_dim);
    //std::generate(host_vector.begin(), host_vector.end(), rand);

    // create vector on the device
    compute::vector<cell_t> device_vector(the_dim, ctx);
    // copy data to the device
    compute::copy(
        host_vector.begin(), host_vector.end(), device_vector.begin(), queue
    );


    for (size_t ii{0}; ii<max_iter; ii++){ 
        queue.finish();
        compute::transform(
            device_vector.begin(), device_vector.end(), device_vector.begin(), make_work, queue
        );
        //queue.finish();
    }

    // copy data back to the host
    compute::copy(
        device_vector.begin(), device_vector.end(), host_vector.begin(), queue
    );
    //
    the_output(host_vector);

    return 0;
}
