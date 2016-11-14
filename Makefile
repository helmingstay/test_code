LDLIBS += -lOpenCL
#TARGETS = $(wildcard *.cpp)
CXXFLAGS += -Wall -std=c++11
CXX = g++

all: opencl straight

opencl: opencl.cpp const.h
	$(CXX) $(CXXFLAGS) $(LDLIBS) -o opencl opencl.cpp 

straight: straight.cpp const.h
	$(CXX) $(CXXFLAGS) -o straight straight.cpp 


clean:
	@rm opencl straight
