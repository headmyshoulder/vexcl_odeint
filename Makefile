all: thrust_lorenz_ensemble vex_lorenz_ensemble

thrust_lorenz_ensemble: thrust_lorenz_ensemble.cu
	nvcc -o $@ -I ../odeint-v2 -arch=sm_13 -O3 $^

vex_lorenz_ensemble: vex_lorenz_ensemble.cpp
	g++ -o $@ -std=c++0x -I ../odeint-v2 -O3 -lOpenCL $^
