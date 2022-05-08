#ifndef LCSIMUL_HEADERS_H
#define LCSIMUL_HEADERS_H

/*
 * This file contains the header of each cpp function used in lcsimul
 */

#include "lcsimul_structures.h"
#include <Rcpp.h>
#include <RcppEigen.h>
using namespace Rcpp;
using namespace Eigen;
using namespace std;

typedef Eigen::SparseMatrix<double> sp_mat;

// Structure and memory management
void init_simul(Person** cohort_ptr, State** states_ptr,
                int n_people, int n_states, int n_cycles,
                double p_smoker);
void free_nhs(Person* cohort, int n_people);
void update_transition_vectors(vector<NumericVector>& t_vectors, 
                               State states[], const List& tps, int index,
                               double p_smoker, double rr_smoker);

// Interventions management
const int QUIT_UNDEFINED   = 0;
const int QUIT_CONSTANT    = 1;
const int QUIT_LINEAR      = 2;
const int QUIT_EXPONENTIAL = 3;
const int QUIT_LOGISTIC    = 4;

bool nu_rand_simplify(double quitting_rr, double rr_smoker);
bool is_at_smokers_risk(Person* p, int current_step, 
                        int quitting_effect,
                        double quitting_ref_years,
                        double quitting_rr_at_ref_years,
                        double periods_per_year,
                        double rr_smoker);
bool is_smoker(Person* p, int current_step);
bool has_ever_smoked(Person* p);
bool is_at_risk_for_screening(Person* p, int current_step, 
                              bool screen_not_smokers, int quitters_screening_periods);

vector<double> get_costs_vector(const List& costs_p, const char item[]);
vector<NumericVector> get_costs_matrix(const List& costs_p, const char item[], int N_states);

// DISTR_SCREENING
// void init_step_screen(State* states, int N_states);
int screening_step(int step, 
                   int screening_start_age, 
                   int screening_end_age,
                   int screening_periodicity,
                   int start_age,
                   int periods_per_year) ;
vector<Person*> simul_diag(State* states, const NumericVector& p_diag,
                           int N_states, int step);
vector<Person*> simul_scr(State* states, const NumericVector& p_diag,
                          double coverage, int N_states, int step, int year,
                          bool not_smokers, int quitters_scr_years,
                          NumericVector& costs, 
                          vector<sp_mat>& costs_m,
                          const vector<double>& unit_costs,
                          IntegerVector& scr_diagnosis_state,
                          int& screened_total);
/*
 * DISTR_SCREENING
 vector<Person*> simul_scr_distributed(State* states, 
                                      const NumericVector& p_diag,
                                      const NumericVector& people_dist,
                                      double coverage, int N_states,
                                      int step, int year,
                                      bool not_smokers, int quitters_scr_years,
                                      NumericVector& costs, 
                                      vector<sp_mat>& costs_m,
                                      const vector<double>& unit_costs);
*/

bool is_quitting_step(int step, const vector<int>& quitting_int_steps);
vector<Person*> quitting_intervention(Person* cohort, int cohort_size, 
                                      const QuittingIntervention& q_int,
                                      int N_states, int step, int year,
                                      NumericVector& costs, 
                                      vector<sp_mat>& costs_m,
                                      const vector<double>& unit_costs);

// Info
void print_history(Person* cohort, int cohort_size, int n_cycles);
NumericVector compute_mpst(Person* cohort, int cohort_size, int N_cycles, IntegerVector& states, int N_states);


// Simulation
void simul_nh_step(Person* cohort, State* states, int N_states,
                   const vector<NumericVector>& probs_current,
                   const vector<vector<int> >& inc_matrix,
                   IntegerVector& inc,
                   IntegerVector& inc_smokers,
                   bool inc_smoker_if_ever,
                   IntegerVector& lc_deaths,
                   int step,
                   double p_smoker, 
                   double rr_smoker,
                   int quitting_effect,
                   double quitting_ref_years,
                   double quitting_rr_at_ref_years,
                   double periods_per_year);

// [[Rcpp::export]]
List lc_simulate_cpp(List tps, NumericVector tp_limits,
                     int start_age, int end_age, int periods_per_year,
                     int N_states, int initial_healthy_population,
                     List interventions_p,
                     List options_p,
                     List costs_p);


#endif
