LDLIBS += -lOpenCL
IBOOST := -I$(HOME)/src/compute/include
#TARGETS = $(wildcard *.cpp)
CXXFLAGS += -Wall -std=c++11
CXX = g++

all: opencl straight boost

opencl: opencl.cpp const.h
	$(CXX) $(CXXFLAGS) $(LDLIBS) -o opencl opencl.cpp 

straight: straight.cpp const.h
	$(CXX) $(CXXFLAGS) -o straight straight.cpp 

boost: boost.cpp const.h
	$(CXX) $(IBOOST) $(CXXFLAGS) $(LDLIBS) -o boost boost.cpp 

clean:
	@rm opencl straight boost
