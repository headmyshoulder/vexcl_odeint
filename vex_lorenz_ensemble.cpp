#include <iostream>
#include <vector>
#include <utility>
#include <tuple>

#include <vexcl/vexcl.hpp>

#include <boost/numeric/odeint.hpp>
#include <boost/numeric/odeint/algebra/vector_space_algebra.hpp>

namespace odeint = boost::numeric::odeint;

typedef vex::vector< double >    vector_type;
typedef vex::multivector< double, 3 > state_type;

namespace boost { namespace numeric { namespace odeint {

template<>
struct is_resizeable< state_type > : boost::true_type { };

template<>
struct resize_impl< state_type , state_type >
{
    static void resize( state_type &x1 , const state_type &x2 )
    {
	x1.resize( x2.queue_list() , x2.size() );
    }
};

template<>
struct same_size_impl< state_type , state_type >
{
    static bool same_size( const state_type &x1 , const state_type &x2 )
    {
	return x1.size() == x2.size();
    }
};


} } }


const double sigma = 10.0;
const double b = 8.0 / 3.0;
const double R = 28.0;

struct sys_func
{
    const vector_type &R;

    sys_func( const vector_type &_R ) : R( _R ) { }

    void operator()( const state_type &x , state_type &dxdt , double t ) const
    {
	dxdt(0) = -sigma * ( x(0) - x(1) );
	dxdt(1) = R * x(0) - x(1) - x(0) * x(2);
	dxdt(2) = - b * x(2) + x(0) * x(1);
    }
};

const size_t n = 1024 * 64;
const double dt = 0.01;
const double t_max = 100.0;

int main( int argc , char **argv )
{
    using namespace std;

    vex::Context ctx( vex::Filter::Type(CL_DEVICE_TYPE_GPU) && vex::Filter::Env );
    // std::cout << ctx << std::endl;



    double Rmin = 0.1 , Rmax = 50.0 , dR = ( Rmax - Rmin ) / double( n - 1 );
    std::vector<double> r( n );
    for( size_t i=0 ; i<n ; ++i ) r[i] = Rmin + dR * double( i );

    state_type X(ctx.queue(), n);
    X(0) = 10.0;
    X(1) = 10.0;
    X(2) = 10.0;

    vector_type R( ctx.queue() , r );

    odeint::runge_kutta4<
	    state_type , double , state_type , double ,
	    odeint::vector_space_algebra , odeint::default_operations
	    > stepper;

    odeint::integrate_const( stepper , sys_func( R ) , X , 0.0 , t_max , dt );

    std::vector< double > res( 3 * n );
    vex::copy( X(0) , res );
    // for( size_t i=0 ; i<n ; ++i )
    // 	cout << res[i] << "\t" << r[i] << "\n";
    cout << res[0] << endl;

}
