#include "lcsimul_headers.h"
#include <cmath>

void init_simul(Person** cohort_ptr, State** states_ptr,
                int n_people, int n_states, int n_cycles,
                double p_smoker) {
  // Pre: n_people == probs.size()
  
  
  // Memory allocation: cohort
  Person* cohort = (Person*) malloc(n_people*sizeof(Person));
  *cohort_ptr = cohort;
  
  // Initialize cohort
  for (int i = 0; i < n_people; ++i) {
    cohort[i].person_id = i;
    cohort[i].quit_date = (unif_rand() < p_smoker)?0:-1;
    cohort[i].lc_diagnosis = -1;
    //cohort[i].screening_age = 0; //DISTR_SCREENING
    cohort[i].dx_screening = false;
    cohort[i].next_in_state = &cohort[i]+1;
    cohort[i].prev_in_state = &cohort[i]-1;
    cohort[i].nh = (byte*) malloc(n_cycles*sizeof(byte));
    *cohort[i].nh = (byte)0;  // everybody is healthy at the beginning
    //for(int k = 0; k < MAX_QUITTING_INTS; ++k) cohort[i].quitting_age[k] = (short)0; //DISTR_SCREENING
  }
  cohort[0].prev_in_state = NULL;
  cohort[n_people-1].next_in_state = NULL;
  
  // Memory allocation: states
  State* states = (State*) malloc(n_states*sizeof(State));
  *states_ptr = states;
  
  // Initialize states
  states[0].last_p = &cohort[n_people-1];
  states[0].np = n_people;
  states[0].smoking_dependent_transition = 1; // TODO shouldn't be hardcoded

  for (int i = 1; i < n_states; ++i) {
    states[i].last_p = NULL;
    states[i].np = 0;
    states[i].smoking_dependent_transition = -1; // TODO shouldn't be hardcoded
  }
}

void update_transition_vectors(vector<NumericVector>& t_vectors, State states[], const List& tps, int index,
                               double p_smoker, double rr_smoker) {
  NumericMatrix tp = as<NumericMatrix>(tps[index]);
  int N_states = t_vectors.size();
  
  for (int i = 0; i < N_states; ++i) {
    
    // Normal update
    bool one_found = false;
    for (int j = 0; j < N_states; ++j) {
      t_vectors[i](j) = tp(i,j);
      if (t_vectors[i](j) == 1) {
        states[i].forced_transition = (byte)j;
        one_found = true;
      }
    }
    if (not one_found) states[i].forced_transition = 0xFF;
    
    
    // Smoking dependent update
    int sdt = (int)states[i].smoking_dependent_transition;
    // Rcerr << "eeeh: " << i << "=" << sdt << endl;
    if (sdt >= 0) {
      // double initial_trans_p = t_vectors[i](sdt);
      // 
      // double trans_p_not_smoker = initial_trans_p/(rr_smoker*p_smoker + (1-p_smoker));
      // double trans_p_smoker = (rr_smoker-1)*trans_p_not_smoker;
      // 
      // t_vectors[i](sdt) = trans_p_not_smoker;
      // t_vectors[i](N_states) = trans_p_smoker;
      
      
      // Implementació de l'aplicació de l'RR més enllà del període mensual
      // double transform_periods = 40*12; // TODO super provisional
      // double transform_periods = 12; // TODO super provisional
      // double transform_periods = 1; // TODO super provisional

      double life_expectancy[] = {43.717386, 
                                  38.889116, 
                                  34.162496, 
                                  29.611711, 
                                  25.274860, 
                                  21.173415, 
                                  17.274295, 
                                  13.636638, 
                                  10.926503}; // TODO SUPERPARCHACO. PERQUÈ NOMÉS SERVEIX PER ALS GRUPS 35-39 TO 75-79, I PERQUÈ S'HAN FET MITJANES A LO CUTRE
      
      
      double transform_periods = life_expectancy[index]*12; // TODO super provisional


      double initial_trans_p = t_vectors[i](sdt);
      double transformed_p = 1-pow(1-initial_trans_p, transform_periods);

      double transf_p_not_smoker = transformed_p/(rr_smoker*p_smoker + (1-p_smoker));
      double transf_p_smoker = rr_smoker*transf_p_not_smoker;

      double p_not_smoker = 1-pow(1-transf_p_not_smoker, 1./transform_periods);
      double p_smoker = 1-pow(1-transf_p_smoker, 1./transform_periods);

      t_vectors[i](sdt) = p_not_smoker;
      t_vectors[i](N_states) = max(p_smoker - p_not_smoker, 0.);

    }
    
    
    // Strange case: forced transition AND smoking dependent transition
    // could not be a forced transition anymore
    if (sdt >= 0 and (p_smoker > 0 and rr_smoker > 1)) {
      states[i].forced_transition = 0xFF;
    }
    
  } // end for (each state)
  
}

void free_nhs(Person* cohort, int n_people) {
  for (int i = 0; i < n_people; ++i) {
    free(cohort[i].nh);
  }
}

