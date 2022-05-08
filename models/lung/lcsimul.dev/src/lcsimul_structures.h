#ifndef LCSIMUL_STRUCTURES_H
#define LCSIMUL_STRUCTURES_H

#include <vector>
#include <Rcpp.h>

typedef unsigned char byte;

typedef struct Person Person;
struct Person {
  int person_id;
  int quit_date;  // -1 never smoked, 0 still smoking, n>0 quit date
  int lc_diagnosis;  // -1 not diagnosed, n>0 diagnosis date
  //short screening_age; // DISTR_SCREENING
  bool dx_screening; // true if diagnosed by screening
  bool postdx_survival;
  //bool step_screened; // DISTR_SCREENING
  Person* next_in_state;
  Person* prev_in_state;
  byte* nh;
};

typedef struct State State;
struct State {
  Person* last_p;
  int np;
  char forced_transition; // if >=0: destination of forced transition
  char smoking_dependent_transition; // if >=0: destination of smoking dep. transition
};

typedef struct QuittingIntervention QuittingIntervention;
struct QuittingIntervention {
  double coverage;
  double success_rate;
  std::vector<int> interv_steps;
  
  void init(const Rcpp::List& R_quitting_int);
};

#endif
