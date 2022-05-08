/* */ // [[Rcpp::plugins(cpp11)]]

#include <Rcpp.h>
#include <RcppEigen.h>
#include <vector>
// #include <random>
using namespace Rcpp;
using namespace Eigen;
using namespace std;

#define DATE __DATE__
#define TIME __TIME__

// [[Rcpp::export]]
CharacterVector lcsimul_dev_comp_time() {
  string d = DATE, t = TIME;
  return d+" "+t ;
}



/*asdfasdf// [[Rcpp::export]]
arma::sp_mat doubleSparseMatrix(arma::sp_mat m) {
  sp_mat A(50,1e5);
  
  
  
  return A;
}*/

/*asdfasdf// [[Rcpp::export]]
Eigen::SparseMatrix<double> doubleSparseMatrix(Eigen::SparseMatrix<double> m) {
  Eigen::SparseMatrix<double>  A(50,1e5);
  
  A.coeffRef(10,20) += 42;
  A.makeCompressed();
  
  return A;
}*/


