#include "lcsimul_headers.h"

bool nu_rand_simplify(double quitter_rr, double rr_smoker) {
  double r = quitter_rr/rr_smoker;
  double nu = rr_smoker*(1-r)/(rr_smoker-1);

  // Rcerr << "quit RR=" << setprecision(4) << quitter_rr << "; nu=" << setw(6) << nu << endl; 
  
  return (unif_rand() >= nu);
}

bool is_at_smokers_risk(Person* p, int current_step, 
                        int quitting_effect,
                        double quitting_ref_years,
                        double quitting_rr_at_ref_years,
                        double periods_per_year,
                        double rr_smoker) {

  int qdate = p->quit_date;
  
  if (qdate < 0)
    return false; // never smoked
  
  if (qdate == 0)
    return true;  // currently smoking
  
  // quitter
  if (rr_smoker == 1) return false; // és indiferent
  
  if (quitting_effect == QUIT_CONSTANT) {
    double risk_periods = quitting_ref_years*periods_per_year;
    return (current_step - qdate < risk_periods);
  }
  
  if (quitting_effect == QUIT_LINEAR) {
    warning("Linear quitting effect not implemented. Using exponential instead");
    quitting_effect = QUIT_EXPONENTIAL;
  }
  
  // Rcerr << fixed;
  // Rcerr << "At step " << setw(3) << current_step << ", quitted " << setw(3) << qdate << " (" << setw(4) << setprecision(1) << (current_step-qdate)/12. << "y ago); ";
  
  if (quitting_effect == QUIT_LOGISTIC) {
    double x = double(current_step - qdate)/periods_per_year; // x = years since quitting
    if (x < quitting_ref_years) {
      double y0 = rr_smoker*(quitting_rr_at_ref_years*exp(quitting_ref_years/6)+quitting_rr_at_ref_years-1)/exp(quitting_ref_years/6);
      //rr.smokers*(quit.rr.after.years*exp(quit.effect.years/6)+quit.rr.after.years-1)/exp(quit.effect.years/6)
      
      double qrr = y0 + (rr_smoker-y0)/(1+exp((x-2*quitting_ref_years/3)/2));
      //Y <- y0 + (rr.smokers-y0)/(1+exp((X-2*quit.effect.years/3)/2))  
      
      // Rcerr << "using LOGISTIC    >> ";
      
      // Uso el "resultat de la probabilitat \nu"
      return nu_rand_simplify(qrr, rr_smoker);
    }
    else {
      quitting_effect = QUIT_EXPONENTIAL;
    }
  }
  
  if (quitting_effect == QUIT_EXPONENTIAL) {
    double quitting_rr_per_period = pow(quitting_rr_at_ref_years,1./(quitting_ref_years*periods_per_year));

    double quitter_rr = rr_smoker*pow(quitting_rr_per_period, current_step - qdate);
    if (quitter_rr <= 1) {
      // Rcerr << "treated as a never-smoker" << endl;
      return false;   // already a never-smoker
    }
    
    // Rcerr << "using EXPONENTIAL >> ";
    
    // Uso el "resultat de la probabilitat \nu"
    return nu_rand_simplify(quitter_rr, rr_smoker);
    
    /*
     * deprecated. Code used before implementation of nu_rand_simplify function

    double nu = rr_smoker*(1-quitting_rr)/(rr_smoker-1);
    bool ret;
    if (unif_rand() < nu)
      ret = false;
    else
      ret = true;
    
    Rcerr << fixed;
    Rcerr << "At step " << setw(3) << current_step << ", quitted " << setw(3) << qdate << " (" << setw(4) << setprecision(1) << (current_step-qdate)/12. << "y ago); " <<
      "quit RR=" << setprecision(4) << quitting_rr << "; nu=" << setw(6) << nu << "; returned=" << ret << endl;
    return ret;*/
  }
  
  warning("No quitting effect defined");
  return true;
  
}

bool is_smoker(Person* p, int current_step) {
  return (p->quit_date == 0 or p->quit_date > current_step);
}

bool has_ever_smoked(Person* p) {
  return (p->quit_date >= 0);
}


bool is_at_risk_for_screening(Person* p, int current_step, 
                              bool screen_not_smokers, int quitters_screening_periods) {
  // Verificar que no estigui diagnosticat
  if (p->lc_diagnosis > 0)
    return false;
  
  // Si es fa screening als no fumadors, ja estem
  if (screen_not_smokers)
    return true;
  
  int qdate = p->quit_date;
  // Never smoked?
  if (qdate < 0)
    return false;
  
  // Smoker
  if (qdate == 0)
    return true;
  
  // Quitter
  return (current_step - qdate < quitters_screening_periods);

}

vector<double> get_costs_vector(const List& costs_p, const char item[]) {
  vector<double> ret(3,0.);
  
  if (costs_p.containsElementNamed(item)) {
    List item_costs = as<List>(costs_p[item]);
    if (item_costs.containsElementNamed("md"))  ret[0] = as<double>(item_costs["md"]);
    if (item_costs.containsElementNamed("nmd")) ret[1] = as<double>(item_costs["nmd"]);
    if (item_costs.containsElementNamed("i"))   ret[2] = as<double>(item_costs["i"]);
  }
  
  return ret;
}

vector<NumericVector> get_costs_matrix(const List& costs_p, const char item[], int N_states) {
  vector<NumericVector> ret(3, NumericVector(N_states));
  
  if (costs_p.containsElementNamed(item)) {
    List item_costs = as<List>(costs_p[item]);
    if (item_costs.containsElementNamed("md")) {
      ret[0] = as<NumericVector>(item_costs["md"]);
      if (ret[0].size() != N_states) stop("Error. Cost definition is not correct");
    }
    if (item_costs.containsElementNamed("nmd")) {
      ret[1] = as<NumericVector>(item_costs["nmd"]);
      if (ret[1].size() != N_states) stop("Error. Cost definition is not correct");
    }
    if (item_costs.containsElementNamed("i")) {
      ret[2] = as<NumericVector>(item_costs["i"]);
      if (ret[2].size() != N_states) stop("Error. Cost definition is not correct");
    }
  }
  
  return ret;
}

// Retorna -1 si (el pas que va de step-1 a step) no és un screening_step
// Retorna l'screening step corresponent si sí ho és
int screening_step(int step, 
                   int screening_start_age, 
                   int screening_end_age,
                   int screening_periodicity,
                   int start_age,
                   int periods_per_year) {
  int current_age = start_age + (step-1)/periods_per_year;
  if (current_age < screening_start_age or current_age >= screening_end_age)
    return -1;
  
  if ((step-1)%screening_periodicity == 0) {
    return ((step-1) - periods_per_year*max(screening_start_age-start_age,0))/screening_periodicity;
  }
  else {
    return -1;
  }
}


vector<Person*> simul_diag(State* states, const NumericVector& p_diag,
                           int N_states, int step) {
  vector<Person*> ret(0);
  
  for (int i_st = 0; i_st < N_states; ++i_st) {
    double p = p_diag(i_st);
    if (p == 0) continue;
    
    // A partir d'aquí, p > 0

    // Guardem paral·lement un punter a les persones dins de l'estat
    // Aquest punter només s'actualitza quan cal modificar-ne algun
    int modifying_idx = 0;
    Person* modifying_ptr = states[i_st].last_p;
    
    // Es van generant tants nombres aleatoris com persones hi ha a l'estat
    for (int ip = 0; ip < states[i_st].np; ++ip) {
      if(unif_rand() < p) {
        while (modifying_idx < ip) {
          modifying_ptr = modifying_ptr->prev_in_state;
          modifying_idx++;
        }
        // could have already been diagnosed, check it first!
        if (modifying_ptr->lc_diagnosis < 0) {
          modifying_ptr->lc_diagnosis = step;
          ret.push_back(modifying_ptr);
        }
      }
      // else no cal modificar res
    }
  }
  
  return ret;
}

vector<Person*> simul_scr(State* states, const NumericVector& p_diag,
                           double coverage, int N_states, int step, int year,
                           bool not_smokers, int quitters_scr_years,
                           NumericVector& costs, 
                           vector<sp_mat>& costs_m,
                           const vector<double>& unit_costs,
                           IntegerVector& scr_diagnosis_state,
                           int& screened_total) {
  vector<Person*> ret(0);
  int screened = 0;
  int auxESBORRAR = 0;
  
  // Es recorren tots els estats excepte els de mort
  for (int i_st = 0; i_st < N_states-2; ++i_st) {
    double p = p_diag(i_st);
    // if (p <= 0) continue;
    
    // Es recorren totes les persones de l'estat.
    // Entren al programa si no ho han fet en aquest step i es consideren "de risc"
    Person* it_p = states[i_st].last_p;
    while (it_p) {
      // DISTR_SCREENING if (not it_p->step_screened and is_at_risk_for_screening(it_p, step, not_smokers, quitters_scr_years)) {
      if (is_at_risk_for_screening(it_p, step, not_smokers, quitters_scr_years)) {
        // Les persones a risc entren a screening amb probabilitat segons cobertura
        // Les que entren imputen sempre cost
        if (unif_rand() < coverage) {
          if (p > 0 and unif_rand() < p) {
            it_p->lc_diagnosis = step;
            it_p->dx_screening = true;
            ret.push_back(it_p);

            int diag_st;
            if (step > 0) diag_st = it_p->nh[step-1];
            else diag_st = 0;
            scr_diagnosis_state[diag_st]++;
          }

          // Update counter for cost computing
          screened++;

          // // Cost computing in sparse matrices
          // for (int k = 0; k < unit_costs.size(); ++k) {
          //   if (unit_costs[k] != 0)
          //     costs_m[k].coeffRef(year, it_p->person_id) += unit_costs[k];
          // }
        }
      }
      
      it_p = it_p->prev_in_state;
    }

    /*for (int k = 0; k < unit_costs.size(); ++k) {
      costs(k) += screened*unit_costs[k];
    }*/
    
    // TODO OJO PARCHE Cost computing in sparse matrices
    for (int k = 0; k < unit_costs.size(); ++k) {
      if (unit_costs[k] != 0)
        costs_m[k].coeffRef(year, 0) += screened*unit_costs[k];
    }
    screened_total += screened;
    
    // Rcerr << "Step " << setw(3) << step << ": State " << i_st << ", " << setw(5) << screened-auxESBORRAR << " of " << setw(5) << states[i_st].np << " people screened" << endl;
    auxESBORRAR = screened;
  }
  
  return ret;
}

/*
 DISTR_SCREENING
void init_step_screen(State* states, int N_states) {
  // Es recorren tots els estats excepte els de mort, marcant tots els individus com not screened
  for (int i_st = 0; i_st < N_states-2; ++i_st) {
    Person* it_p = states[i_st].last_p;
    while (it_p) {
      it_p->step_screened = false;
      it_p = it_p->prev_in_state;
    }
  }
}
*/

/*

 Hem descartat aquest approach. És massa complex, sobretot a l'hora d'explicar-lo.
 En cas que es vulgui recuperar, caldrà descomentar codi al voltant del token "DISTR_SCREENING"
 
 /// TODO comprovar que people_dist és correcte
vector<Person*> simul_scr_distributed(State* states, 
                                      const NumericVector& p_diag,
                                      const NumericVector& people_dist,
                                      double coverage, int N_states,
                                      int step, int year,
                                      bool not_smokers, int quitters_scr_years,
                                      NumericVector& costs, 
                                      vector<sp_mat>& costs_m,
                                      const vector<double>& unit_costs) {
  
  
  
  vector<Person*> ret_dist(0);
  init_step_screen(states, N_states);
  double uncovered = 1;
  
  for (int group=0; group < people_dist.size(); ++group) {
    double current_coverage = people_dist(group)*coverage/uncovered;
    
    Rcerr << "[Step " << setw(3) << step << ", grup " << group << "] ";
    Rcerr << "Total cov. " << coverage << ", Dist=" << people_dist(group) << " Uncovered=" << uncovered << ", Cobertura " << current_coverage << "\t\t";
    vector<Person*> scr_dx_current = simul_scr(states, p_diag, current_coverage, N_states, step, year, not_smokers, quitters_scr_years, costs, costs_m, unit_costs);
    // concatena ret_dist i scr_dx_current
    ret_dist.insert(ret_dist.end(), scr_dx_current.begin(), scr_dx_current.end());
    
    Rcerr << "dx " << setw(2) << scr_dx_current.size() << endl;
    
    uncovered -= current_coverage;
  }
  
  return ret_dist;
}*/



void QuittingIntervention::init(const List& R_quitting_int) {
  coverage = R_quitting_int["coverage"];
  success_rate = R_quitting_int["success_rate"];
  interv_steps = as<vector<int> >(R_quitting_int["interv_steps"]);
}

bool is_quitting_step(int step, const vector<int>& quitting_int_steps) {
  for (int i = 0; i < quitting_int_steps.size(); ++i) {
    if (step-1 == quitting_int_steps[i]) {
      return true;
    }
  }
  
  return false;
}


vector<Person*> quitting_intervention(Person* cohort, int cohort_size, const QuittingIntervention& q_int, int N_states, int step, int year,
                                      NumericVector& costs, 
                                      vector<sp_mat>& costs_m,
                                      const vector<double>& unit_costs) {
  if (q_int.coverage == 0 or q_int.success_rate == 0) return vector<Person*>();
  
  vector<Person*> ret(0);
  int intervened = 0;
  for (int i = 0; i < cohort_size; ++i) {
    if (cohort[i].nh[step-1] < (N_states-2) and cohort[i].quit_date == 0) {
      // Alive and smoker
      if (unif_rand() < q_int.coverage) {
        // Patient in quitting intervention
        intervened++;
        
        // Is the intervention successful?
        if (unif_rand() < q_int.success_rate) {
          // Successful quitting intervention
          cohort[i].quit_date = step-1;
          ret.push_back(cohort + i);
        }
        
        // Cost computing in sparse matrices
        for (int k = 0; k < unit_costs.size(); ++k) {
          if (unit_costs[k] != 0)
            costs_m[k].coeffRef(year, cohort[i].person_id) += unit_costs[k];
        }
        
      }  
    }
  }
  
  // Costs computing
  for (int i = 0; i < unit_costs.size(); ++i) {
    costs(i) += intervened*unit_costs[i];
  }
  
  return ret; 
}

