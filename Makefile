NVCC = /usr/local/cuda/bin/nvcc
ODEINT_ROOT = /home/karsten/src/odeint-v2
VEXCL_ROOT = /home/karsten/boost/vexcl
CUDA_INC = /usr/local/cuda/include
VIENNACL_ROOT = /home/karsten/boost/testing/ViennaCL-1.3.0


all: thrust_lorenz_ensemble vex_lorenz_ensemble thrust_lorenz_ensemble_openmp viennacl_lorenz_ensemble

thrust_lorenz_ensemble: thrust_lorenz_ensemble.cu
	$(NVCC) -o $@ -I$(ODEINT_ROOT) -I$(BOOST_ROOT) -arch=sm_13 -O3 $^

thrust_lorenz_ensemble_openmp: thrust_lorenz_ensemble.cu
	$(NVCC) -o $@ -I$(ODEINT_ROOT) -I$(BOOST_ROOT) -arch=sm_13 -O3 -Xcompiler -fopenmp -DTHRUST_DEVICE_BACKEND=THRUST_DEVICE_BACKEND_OMP $^

vex_lorenz_ensemble: vex_lorenz_ensemble.cpp
	g++ -o $@ -std=c++0x -I$(ODEINT_ROOT) -I$(BOOST_ROOT) -I$(VEXCL_ROOT) -I$(CUDA_INC) -O3 $^ -lOpenCL

viennacl_lorenz_ensemble : viennacl_lorenz_ensemble.cpp
	g++ -o $@ -std=c++0x -I$(ODEINT_ROOT) -I$(BOOST_ROOT) -I$(VIENNACL_ROOT) -I$(CUDA_INC) -O3 $^ -lOpenCL
