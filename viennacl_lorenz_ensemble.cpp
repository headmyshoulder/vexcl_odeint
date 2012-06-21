#include <iostream>
#include <vector>
#include <utility>
#include <tuple>

#include <viennacl/vector.hpp>
#include <viennacl/vector_proxy.hpp>


#include <boost/numeric/odeint.hpp>
#include <boost/numeric/odeint/algebra/fusion_algebra.hpp>
#include <boost/fusion/container.hpp>
#include <boost/numeric/ublas/vector.hpp>

namespace odeint = boost::numeric::odeint;
namespace fusion = boost::fusion;
namespace ublas = boost::numeric::ublas;

typedef double value_type;

typedef viennacl::vector< value_type > vector_type;
typedef fusion::vector<
    vector_type , vector_type , vector_type 
    > state_type;

namespace boost { namespace numeric { namespace odeint {

template<>
struct is_resizeable< state_type > : boost::true_type { };

template<>
struct resize_impl< state_type , state_type >
{
    static void resize( state_type &x1 , const state_type &x2 )
    {
	size_t size = fusion::at_c< 0 >( x2 ).size();
	fusion::at_c< 0 >( x1 ).resize( size );
	fusion::at_c< 1 >( x1 ).resize( size );
	fusion::at_c< 2 >( x1 ).resize( size );
    }
};

template<>
struct same_size_impl< state_type , state_type >
{
    static bool same_size( const state_type &x1 , const state_type &x2 )
    {
	size_t size1 = fusion::at_c< 0 >( x1 ).size();
	size_t size2 = fusion::at_c< 0 >( x2 ).size();
	return size1 == size2;
    }
};


} } }


const value_type sigma = 10.0;
const value_type b = 8.0 / 3.0;
const value_type R = 28.0;

struct sys_func
{
    const vector_type &R;
    size_t n;

    sys_func( const vector_type &_R ) : R( _R ) , n( _R.size() ) { }

    void operator()( const state_type &x , state_type &dxdt , value_type t ) const
    {
	const vector_type &X = fusion::at_c< 0 >( x ); 
	const vector_type &Y = fusion::at_c< 1 >( x );
	const vector_type &Z = fusion::at_c< 2 >( x );

	vector_type &dX = fusion::at_c< 0 >( dxdt ); 
	vector_type &dY = fusion::at_c< 1 >( dxdt );
	vector_type &dZ = fusion::at_c< 2 >( dxdt );

	// dX = -sigma * ( X - Y ) ;
	// dY = R * X - Y - X * Z ;
	// dZ = - b * Z + X * Y ;
    }
};

size_t n;
const value_type dt = 0.01;
const value_type t_max = 100.0;

int main( int argc , char **argv )
{
    using namespace std;

    n = argc > 1 ? atoi( argv[1] ) : 1024;


    value_type Rmin = 0.1 , Rmax = 50.0 , dR = ( Rmax - Rmin ) / value_type( n - 1 );
    std::vector<value_type> r( n );
    for( size_t i=0 ; i<n ; ++i ) r[i] = Rmin + dR * value_type( i );

    // std::vector< value_type > x( n , 10 );
    state_type X;
    // fusion::at_c< 0 >( X ) = ublas::scalar_vector< value_type >( n , 10.0 );
    // fusion::at_c< 1 >( X ) = ublas::scalar_vector< value_type >( n , 10.0 );
    // fusion::at_c< 2 >( X ) = ublas::scalar_vector< value_type >( n , 10.0 );

    vector_type tmp = ublas::scalar_vector< value_type >( n , 10.0 );

    // viennacl::copy( x , fusion::at_c< 0 >( X ) );
    // viennacl::copy( x , fusion::at_c< 1 >( X ) );
    // viennacl::copy( x , fusion::at_c< 2 >( X ) );


    vector_type R( n );
    viennacl::copy( r , R );

    odeint::runge_kutta4<
	    state_type , value_type , state_type , value_type ,
	    odeint::fusion_algebra , odeint::default_operations
	    > stepper;

    odeint::integrate_const( stepper , sys_func( R ) , X , value_type(0.0) , t_max , dt );

    std::vector< value_type > res( n );
    viennacl::copy( fusion::at_c< 0 >( X ).begin() , fusion::at_c< 0 >( X ).end() , res.begin() );
    for( size_t i=0 ; i<n ; ++i )
     	cout << res[i] << "\t" << r[i] << "\n";
//    cout << res[0] << endl;

}
