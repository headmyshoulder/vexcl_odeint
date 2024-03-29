NVCC = /usr/local/cuda/bin/nvcc
ODEINT_ROOT = /home/karsten/src/odeint-v2
VEXCL_ROOT = /home/karsten/boost/vexcl
CUDA_INC = /usr/local/cuda/include
VIENNACL_ROOT = /home/karsten/boost/testing/ViennaCL-1.3.0


all: thrust_lorenz_ensemble \
	thrust_lorenz_ensemble_openmp \
	thrust_phase_oscillator_chain \
	vex_lorenz_ensemble \
	vex_phase_oscillator_chain \
	vex_phase_oscillator_chain_v2 \
#	viennacl_lorenz_ensemble

thrust_lorenz_ensemble: thrust_lorenz_ensemble.cu
	$(NVCC) -o $@ -I$(ODEINT_ROOT) -I$(BOOST_ROOT) -arch=sm_13 --compiler-bindir=/usr/bin/g++-4.4 -O3 $^

thrust_lorenz_ensemble_openmp: thrust_lorenz_ensemble.cu
	$(NVCC) -o $@ -I$(ODEINT_ROOT) -I$(BOOST_ROOT) -arch=sm_13 --compiler-bindir=/usr/bin/g++-4.4 -O3 -Xcompiler -fopenmp -DTHRUST_DEVICE_BACKEND=THRUST_DEVICE_BACKEND_OMP $^

thrust_phase_oscillator_chain : thrust_phase_oscillator_chain.cu
	$(NVCC) -o $@ -I$(ODEINT_ROOT) -I$(BOOST_ROOT) -arch=sm_13 --compiler-bindir=/usr/bin/g++-4.4 -O3 $^

vex_lorenz_ensemble: vex_lorenz_ensemble.cpp
	g++ -o $@ -std=c++0x -I$(ODEINT_ROOT) -I$(BOOST_ROOT) -I$(VEXCL_ROOT) -I$(CUDA_INC) -O3 $^ -lOpenCL

vex_phase_oscillator_chain : vex_phase_oscillator_chain.cpp
	g++ -o $@ -std=c++0x -I$(ODEINT_ROOT) -I$(BOOST_ROOT) -I$(VEXCL_ROOT) -I$(CUDA_INC) -O3 $^ -lOpenCL

vex_phase_oscillator_chain_v2 : vex_phase_oscillator_chain_v2.cpp
	g++ -o $@ -std=c++0x -I$(ODEINT_ROOT) -I$(BOOST_ROOT) -I$(VEXCL_ROOT) -I$(CUDA_INC) -O3 $^ -lOpenCL

viennacl_lorenz_ensemble : viennacl_lorenz_ensemble.cpp
	g++ -o $@ -std=c++0x -I$(ODEINT_ROOT) -I$(BOOST_ROOT) -I$(VIENNACL_ROOT) -I$(CUDA_INC) -O3 $^ -lOpenCL
