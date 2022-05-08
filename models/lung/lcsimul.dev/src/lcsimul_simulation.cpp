#include "lcsimul_headers.h"

#define C_WELL 'o'
#define C_LC_LIMITED '<'
#define C_LC_ADVANCED '>'
#define C_LC_EXTENSIVE '!'
#define C_SURVIVAL '*'
#define C_LC_DEATH '.'
#define C_OTHER_DEATH '+'

#define C_WELL_S 's'

#define C_WELL_D 'O'
#define C_LC_LIMITED_D 'L'
#define C_LC_ADVANCED_D 'A'
#define C_LC_EXTENSIVE_D 'E'

#define C_ERR 'x'


inline char state_char(byte state, bool smoker, bool diagnosed){
  
  if (diagnosed) {
    switch (state) {
    case 0: return C_WELL_D;
    case 1: return C_LC_LIMITED_D;
    case 2: return C_LC_ADVANCED_D;
    case 3: return C_LC_EXTENSIVE_D;
    }
  }
  
  if (state == 0) {
    if (diagnosed) return C_WELL_D;
    if (smoker) return C_WELL_S;
    return C_WELL;
  }
  
  switch (state) {
  
  case 0: return smoker?C_WELL_S:C_WELL;
  case 1: return C_LC_LIMITED;
  case 2: return C_LC_ADVANCED;
  case 3: return C_LC_EXTENSIVE;
  case 4: return C_SURVIVAL;
  case 5: return C_LC_DEATH;
  case 6: return C_OTHER_DEATH;

  }
  
  return C_ERR;
  
}

void print_history(Person* cohort, int cohort_size, int n_cycles) {
  for (int i = 0; i < cohort_size; ++i) {
    Rcout << "Patient #" << setw(5) << i << ": " << setw(5) << cohort[i].quit_date << setw(5) << cohort[i].lc_diagnosis << "  ";
    for (int j = 0; j <= n_cycles; ++j) {
      Rcout << state_char(cohort[i].nh[j],
                          cohort[i].quit_date == 0 or (cohort[i].quit_date > 0 and j <= cohort[i].quit_date), 
                          cohort[i].lc_diagnosis >= 0 and cohort[i].lc_diagnosis <= j);
      if (j%12 == 0) Rcout << " ";
    }
    Rcout << endl;
    if ((i+1)%5 == 0) {
      if ((i+1)%50 == 0) {
        Rcout << setw(33) << "[35]";
        for (int y = 40; y < 80; y+=5)
          Rcout << setw(62) << "[" << y << "]";
      }
      else if ((i+1)%25 == 0) {
        Rcout << setw(10) << "  [LEGEND]";
        for (int k = 0; k < 3; ++k)
          Rcout << setw(22-(k?5:0)) << "(" << "undiagnosed) o: well      <: lc-lim    >: lc-adv    !: lc-ext"
                << setw( 5) << "(" << "diagnosed)  O: well      L: lc-lim    A: lc-adv    E: lc-ext"
                << setw( 9) << "[" << "s: smoker]"
                << setw( 7) << "(" << "dead)   .: lc     +: other";
      }
      Rcout << endl;
    }
  }
}

IntegerVector spont_diag_a_posteriori(Person* cohort, int cohort_size, int N_states, int N_cycles, int periods_per_year, const List& costs_p, vector<sp_mat>& costs_m) {
  // 1. Per a cada persona:
  // 1.1. Detectar si ha tingut càncer
  // 1.2. Determinar l'estat de diagnòstic en funció de la distribució de diagnòstic
  // 1.3. Determinar el cicle de diagnòstic
  // 1.4. Aplicar el diagnòstic en funció de si hi ha hagut diagnòstic per screening
  //      * Ignorar, si és posterior al diagnòstic existent
  //      * Reportar com a anomalia, si és anterior al diagnòstic existent
  // 2. Afegir el cost al cicle i persona de diagnòstic
  // 3. Afegir el diagnòstic al comptador de diagnòstics
  
  //IntegerVector ret(N_cycles,0);
  vector<int> ret(N_cycles,0);
  int anomaly_counter = 0;
  
  for (int i = 0; i < cohort_size; ++i) {
      if (cohort[i].nh[N_cycles] == 0)
        continue;  // if well at last cycle, nothing to explore
      
      // 1. (Init)
      bool explore = true;
      int cancer_start = -1;
      int cancer_end = -1;
      double diag_distrib_1 = .182, diag_distrib_2 = 0.401, diag_distrib_3 = 0.934; // Probabilitats diagnòstic espontani
      
      // 1.1.
      for (int j = 0; j <= N_cycles and explore; ++j) {
        int st = cohort[i].nh[j];
        if (st >= N_states-2) {
          explore = false;  // dead
        }
        else if (st == 1 or st == 2 or st == 3) { // TODO parametritzar?
          cancer_start = cancer_end = j;
          while (st == 1 or st == 2 or st == 3) { // TODO idem parametritzar?
            cancer_end++;
            if (cancer_end <= N_cycles) st = cohort[i].nh[cancer_end];
            else st = -1;
          }
          explore = false;
        }
      }
      
      if (cancer_start < 0)
        continue; // no cancer, nothing to explore 
      
      // 1.2.
      double r = unif_rand();
      int diag_state = -1;
      if (r < diag_distrib_1) diag_state = 1;
      else if (r < diag_distrib_2) diag_state = 2;
      else if (r < diag_distrib_3) diag_state = 3;
      
      // 1.3.
      int diag_step = -1;
      if (diag_state >= 0) {
        // Cerca interval en què s'ha estat en aquest estat
        int j = cancer_start;
        while (j < cancer_end and cohort[i].nh[j] < diag_state) ++j;
        int diag_st_start = j;
        while (j < cancer_end and cohort[i].nh[j] <= diag_state) ++j;
        int diag_st_end = j;
        
        // Si no s'ha pogut trobar l'estat, s'ignora
        if (diag_st_start == cancer_end) diag_step = -1;
        // Si l'interval és buit, s'assumeix el cicle intermig
        if (diag_st_start == diag_st_end) diag_step = diag_st_start;
        // altrament se selecciona un nombre de l'interval
        
        int rand_int = (int)((diag_st_end-diag_st_start)*unif_rand());
        diag_step = diag_st_start + rand_int;
        if (diag_step >= diag_st_end) diag_step = diag_st_start; // només podria passar si unif_rand dona 1...
        
        //Rcout << "#"<< setw(5) << i <<  ", Diag Step: " <<setw(3) << diag_step << ", cancerstart-cancerend: " << cancer_start << " " << cancer_end << 
        //  ", diagstart-diagend: " << diag_st_start << " " << diag_st_end << endl;
      }
      
      // 1.4.
      bool diag = false; // JODEEEEEEEEEEER
      if (diag_step >= 0) {
        if (cohort[i].lc_diagnosis < 0) {
          cohort[i].lc_diagnosis = diag_step;
          diag = true;
        }
        else {
          if (cohort[i].lc_diagnosis >= diag_step) {
            diag = false;
          }
          else {
            // Anomalia. Diagnòstic espontani abans de diagnòstic per screening
            // Ignorat (erròniament?!)
            anomaly_counter++;
            diag = false;
          }
        }
      }
      
      // s'ha escollit com a estat de diagnòstic un estat pel que el pacient no ha passat i per tant no es pot diagnosticar
      if (diag_step >= cancer_end or diag_step > N_cycles) diag = false;
      
      if (diag) {
        // 2. Cost
        vector<double> postdx_treatment_costs = get_costs_vector(costs_p, "postdx_treatment");
        for (int k = 0; k < 3; ++k) {
          if (postdx_treatment_costs[k] > 0) {
            //Rcout << setw(3) << (diag_step-1)/periods_per_year << " ";
            costs_m[k].coeffRef((diag_step-1)/periods_per_year, i) += postdx_treatment_costs[k];
          }
        }

        // 3. Comptador
        ret[diag_step-1]++;
      }
      
    
  } // end for (cohort)
 
 
  Rcout << "Anomalies detected in spontaneous diagnosis: " << anomaly_counter << endl;
  
  IntegerVector ret_r(N_cycles);
  for (int i = 0; i < N_cycles; ++i) ret_r(i) = ret[i];
  return ret_r;
}

NumericVector compute_mpst(Person* cohort, int cohort_size, int N_cycles, IntegerVector& states, int N_states) {
  // Es calcula el mpst a partir del temps total que ha estat cada persona en cada estat (tb si torna a un estat anterior)
  // S'assumeix que tota persona que acaba a l'estat 0 no ha passat per cap altre estat
  vector<int> total_time(states.size(), 0);
  vector<int> n_patients(states.size(), 0);
  
  for (int i = 0; i < cohort_size; ++i) {
    if (cohort[i].nh[N_cycles] == 0)
      continue;  // if well at last cycle, nothing to explore
    
    vector<int> person_time(states.size(),0);
    bool explore = true;
    for (int j = 0; j <= N_cycles and explore; ++j) {
      if (cohort[i].nh[j] >= N_states-2) {
        explore = false;  // dead
      }
      else {
        for (int k = 0; k < states.size(); ++k) {
          if (cohort[i].nh[j] == (byte)states[k]) {
            person_time[k]++;
          }
        }
      }
    }
    
    for (int k = 0; k < states.size(); ++k) {
      if (person_time[k] > 0) {
        total_time[k] += person_time[k];
        n_patients[k]++;
      }
    }
  }
  
  NumericVector mpst(states.size());
  for (int k = 0; k < states.size(); ++k) {
    mpst(k) = (double)total_time[k]/n_patients[k];
  }
  
  return mpst;
}


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
                   double periods_per_year) {

  vector<Person*> mid_pool_end = vector<Person*>(N_states, NULL);  // mid_pool_end[j] contains people changing to state j
  vector<Person*> mid_pool_begin = vector<Person*>(N_states, NULL);  // mid_pool_begin[j] contains reference to beginning
  vector<int> n_pool = vector<int>(N_states, 0);
  
  // passem per cada estat
  for (int i_st = 0; i_st < N_states; ++i_st) {

    // si la transicio des d'aquest estat �s for�ada (transicio a un estat amb prob 1), el nou estat ser� el que toqui
    //movem totes les persones a aqeull estat i ja. (en el cas de pulmo les uniques transicions for�ades son les de qudar-se en els estats de mort)
    if (states[i_st].forced_transition > 0) {
      // There is a forced transition
      byte new_st = states[i_st].forced_transition;
      
      if (new_st != (byte)i_st) {
        // TODO
        stop("NOT IMPLEMENTED. El cas en què hi ha una transició forçada des "
               "d'un estat a un altre estat diferent no està implementat encara.");
      }
      else {
        Person* p = states[i_st].last_p;
        while (p != NULL) {
          p->nh[step] = new_st;
          p = p->prev_in_state;
        }
      }
      
    }
    else {
      char smoking_dep_dest = states[i_st].smoking_dependent_transition;

      IntegerVector new_states;

      // Number of possible outcomes depends on size of vector of probabilities
      // due to smoking dependent transitions
      int possible_outcomes = probs_current[i_st].size();
      //a les persones d'aquest estat els hi assignem el nou estat en funcio de les probabilitats de transicio
      new_states = as<IntegerVector>(sample(possible_outcomes, states[i_st].np, true, probs_current[i_st]));
      
      Person* p = states[i_st].last_p;
      
      int counter = 0;
      while (p != NULL) {
        // 1. Guardar següent persona a visitar
        // 2. Guardar l'estat següent i comprovar si cal canviar d'estat. Si no, passar a 5.
        // 3. Treure la persona de l'estat anterior
        // 4. Afegir la persona a l'estat intermig (pool)
        // 5. Passar a la següent persona
        
        // 1.
        Person* pp = p->prev_in_state;

        // 2.
        byte new_st = (byte)(new_states[counter++] - 1);
        
        // Cas especial: Pacient diagnosticat, supervivent i en un estat que no és ni healthy ni death
        //     Això és perquè l'acabem de diagnosticar i tractar => Cal passar-lo a l'estat healthy sí o sí
        if (p->dx_screening and p->postdx_survival and i_st > 0 and i_st < N_states-2) {
          new_st = 0;
          p->nh[step] = 0;
        }
        // Cas general
        else {
          if (new_st == (byte)N_states) p->nh[step] = (byte)i_st; // d'entrada, no fem el canvi
          else p->nh[step] = new_st;
        }
        
        if (new_st != (byte)i_st) {
          bool change_state;
          
          // Cas especial 1: Pacient ja diagnosticat per screening
          if (p->dx_screening) {
            // Rcerr << "[Step " << setw(3) << step << "] Valorant canvi d'estat del pacient #" << setw(5) << p->person_id << ": " << i_st << "->" << (int)new_st << " => ";

            // diagnosticat per screening, cal modificar el curs de la nh:
            // 1. Si supervivent i estat actual és healthy, només fem el canvi si és cap a other death: desfem canvi
            if (p->postdx_survival and i_st == 0 and new_st != (byte)(N_states-1)) {
              p->nh[step] = (byte)i_st;
              change_state = false;
            }
            // 2. Si no supervivent, no hi ha "other death": desfem canvi
            else if (not p->postdx_survival and new_st == (byte)(N_states-1)) {
              p->nh[step] = (byte)i_st;
              change_state = false;
            }
            // 3. En els altres casos es deixa seguir la nh
            else {
              change_state = true;
            }

            // Rcerr << (change_state?"SÍ":"NO") << " hi ha canvi" << endl;
          }
          // Cas especial 2: not p->dx_screening, pero smoking dependent transition
          else if (smoking_dep_dest != -1) {
            if (new_st < (byte)N_states) {
              change_state = true;
            }
            else {
              // som a l'estat auxiliar. Hi ha canvi d'estat
              // en funcio de l'estatus de fumador de la persona

              if (is_at_smokers_risk(p, step, quitting_effect,
                                     quitting_ref_years,
                                     quitting_rr_at_ref_years,
                                     periods_per_year,
                                     rr_smoker)) {
                change_state = true;
                // Cal canviar l'estat a la nh, no ho hem fet abans
                p->nh[step] = smoking_dep_dest;
                new_st = smoking_dep_dest;
              }
              else {
                change_state = false;
              }
            }
          }
          // Cas general
          else {
            change_state = true;
          }
          
          // 3. i 4.          
          if (change_state) {
            // 3.
            // lliguem cap enrere
            if (pp) pp->next_in_state = p->next_in_state;

            // lliguem cap endavant
            if (p->next_in_state) p->next_in_state->prev_in_state = pp;
            else states[i_st].last_p = pp;  // perquè p és l'últim de l'estat
            
            states[i_st].np--;

            // 4.
            if (mid_pool_end[new_st]) {
              mid_pool_end[new_st]->next_in_state = p;
              p->prev_in_state = mid_pool_end[new_st];
            }
            else {
              mid_pool_begin[new_st] = p; // primer en entrar en aquest step a aquest estat, el guardem
              p->prev_in_state = NULL;
            }
            mid_pool_end[new_st] = p;
            p->next_in_state = NULL;
            n_pool[new_st]++;

            // Actualitzacio incidencia
            if (inc_matrix[i_st][new_st] != 0) {
              inc[step-1]++;
              // Smoker incidence parametrized: "ever smoker" or "current smoker"
              if (inc_smoker_if_ever) {
                if (has_ever_smoked(p)) inc_smokers[step-1]++;
              }
              else {
                if (is_smoker(p,step)) inc_smokers[step-1]++;
              }
            }
            
            // Actualització vector lc deaths
            if (new_st == N_states-2) {
              lc_deaths(i_st)++;
            }
            
          }
        } // [END] if (new_st != (byte)i_st)
        
        // 5.
        p = pp;
      }
    }
    
  }
  
  // Acabat l'step, unim cada pool al seu nou estat
  for (int i_st = 0; i_st < N_states; ++i_st) {
    if (mid_pool_end[i_st]) {
      // lliguem les dues llistes
      mid_pool_begin[i_st]->prev_in_state = states[i_st].last_p;
      if (states[i_st].last_p) states[i_st].last_p->next_in_state = mid_pool_begin[i_st];
      // canviem el punter al final de la llista de l'estat
      states[i_st].last_p = mid_pool_end[i_st];
      // Actualitzem comptador
      states[i_st].np += n_pool[i_st];
    }
  }
  
}



/**
*
* tps ha de contenir les matrius de transició
* tp_limits ha de contenir l'edat d'inici de cada una de les matrius incloses a tps
*/
List lc_simulate_cpp(List tps, NumericVector tp_limits,
                     int start_age, int end_age, int periods_per_year,
                     int N_states, int initial_healthy_population,
                     // IntegerVector incidence_from_states, List incidence_to_states,
                     List interventions_p,
                     List options_p,
                     List costs_p) {
  
  // Error check
  if (tps.size() != tp_limits.size())
    stop("Lengths of tps and tp_limits must match");
  if (N_states >= 256)
    stop("Number of states can't be >255"); // due to byte representation of samples

  // Obtenció paràmetres intervencions (amb error check)
    // interventions_p must have been checked at R level, except for vector 
    //   entries: diag_screen and diag_spont, that can be a single 0
  NumericVector diag_screen = as<NumericVector>(interventions_p["diag_screen"]);

    if (diag_screen.size() == 1) {
    if (diag_screen(0) == 0) diag_screen = NumericVector(N_states); // defaults to 0
    else stop("N_states and size of parameter 'diag_screen' must match");
  }
  else if (diag_screen.size() != N_states) {
    stop("N_states and size of parameter 'diag_screen' must match");
  }
  
  NumericVector diag_spont = as<NumericVector>(interventions_p["diag_spont"]);
  if (diag_spont.size() == 1) {
    if (diag_spont(0) == 0) diag_spont = NumericVector(N_states); // defaults to 0|
    else stop("N_states and size of parameter 'diag_spont' must match");
  }
  else if (diag_spont.size() != N_states) {
    stop("N_states and size of parameter 'diag_spont' must match");
  }
  // [END] Error check
  
  

  // Inicialització paràmetres calculables
  int tp_index = 0;
  while (tp_index+1 < tp_limits.size() and tp_limits(tp_index+1) <= start_age)
    tp_index++;
  
  int N_years=end_age-start_age;
  int N_cycles=N_years*periods_per_year;
  
  
  // Inicialització estructures simulació
  Person* cohort;
  State* states;
  init_simul(&cohort, &states, initial_healthy_population, N_states, N_cycles+1, interventions_p["p_smoker"]);
  
  
  // Inicialització matriu de probabilitats
  vector<NumericVector> probs_current(N_states);
  for (int i = 0; i < N_states; ++i) {
    if (states[i].smoking_dependent_transition < 0) probs_current[i] = NumericVector(N_states);
    else probs_current[i] = NumericVector(N_states + 1);
  }
  update_transition_vectors(probs_current, states, tps, tp_index, 
                            interventions_p["p_smoker"], interventions_p["rr_smoker"]);
  
  
  // Inicialització vector d'incidències i matriu auxiliar
  // Vector per emmagatzemar
  IntegerVector inc(N_cycles,0);
  IntegerVector inc_smokers(N_cycles,0);
  // Matriu auxiliar precalculada
  IntegerVector incidence_from_states;
  List incidence_to_states;
  
  incidence_from_states = as<IntegerVector>(as<List>(options_p["incidence"])["from"]);  
  incidence_to_states = as<List>(as<List>(options_p["incidence"])["to"]);
  
  // Inicialització vector de lc_deaths i diagnòstics per estat
  IntegerVector lc_deaths(N_states,0);
  IntegerVector scr_diagnosis_state(N_states,0);
  int screened_total = 0;

  vector<vector<int> > inc_matrix = vector<vector<int> >(N_states, vector<int>(N_states,0));
  for (int i = 0; i < incidence_from_states.size(); ++i) {
    int from = incidence_from_states[i];
    IntegerVector to_vector = as<IntegerVector>(incidence_to_states[i]);
    for (int j = 0; j < to_vector.size(); ++j) 
      inc_matrix[from][to_vector[j]] = -1;
  }

  // Inicialització variable configuració inc_smoker 
  bool inc_smoker_if_ever = (options_p.containsElementNamed("smoker_inc_type") and as<string>(options_p["smoker_inc_type"]) == "ever");

  // Inicialització vector costos
  NumericVector costs(3,0.); // TODO to be deprecated
  vector<sp_mat> costs_m(3, sp_mat(N_years, initial_healthy_population));
  // vector<sp_mat> costs_m(3, sp_mat(N_years, initial_healthy_population));
  // vector<mat> costs_m(3, mat(N_years, initial_healthy_population));
  // costs_m[0].insert(10,20) = 42;
  // costs_m[0].insert(20,10) = 420;
  // costs_m[0].makeCompressed();
  // Rcout << costs_m[0] << endl;
  vector<NumericVector> usual_care_costs = get_costs_matrix(costs_p, "usual.care", N_states);
  vector<double> postdx_treatment_costs = get_costs_vector(costs_p, "postdx_treatment");
  
  // Inicialització quitting interventions
  List quit_ints_R = as<List>(interventions_p["quitting_interventions"]);
  int n_quitting = quit_ints_R.size();
  printf("n_quitting=%d\n", n_quitting);
  vector<QuittingIntervention> quitting_ints(n_quitting);
  for (int i = 0; i < n_quitting; ++i) quitting_ints[i].init(as<List>(quit_ints_R[i]));
  
  // Inicialització quitting effects
  int quitting_effect = QUIT_UNDEFINED; // undefined by default
  if (interventions_p.containsElementNamed("quitting_effect_type")) {
    string eff = interventions_p["quitting_effect_type"];
    if (eff == "constant") quitting_effect = QUIT_CONSTANT;
    else if (eff == "exponential") quitting_effect = QUIT_EXPONENTIAL;
    else if (eff == "linear") quitting_effect = QUIT_LINEAR;
    else if (eff == "logistic") quitting_effect = QUIT_LOGISTIC;
  }
  int quitting_risk_y = interventions_p.containsElementNamed("quitting_ref_years")?
                        as<int>(interventions_p["quitting_ref_years"]):0;
  double quitting_rr  = interventions_p.containsElementNamed("quitting_rr_after_ref_years")?
                        as<double>(interventions_p["quitting_rr_after_ref_years"]):1;
  
  
  // Inicialització vectors diagnòstic 
  int screening_periods = ((as<int>(interventions_p["screening_end_age"]) - as<int>(interventions_p["screening_start_age"]))*periods_per_year)/as<int>(interventions_p["screening_periodicity"]);
  if (((as<int>(interventions_p["screening_end_age"]) - as<int>(interventions_p["screening_start_age"]))*periods_per_year) % as<int>(interventions_p["screening_periodicity"]) != 0) screening_periods++;

  IntegerVector screening_diagnosed(screening_periods);
  //IntegerVector spontaneous_diagnosed(N_cycles);

  ////////////////////////////////////
  // SIMULACIÓ STEP BY STEP
  ////////
  for (int step=1; step <= N_cycles; ++step) {
    ////////////////////////////////
    // Simulació step: Diagnòstic per cribratge (si s'escau)
    ////////
    int scr_step = screening_step(step, 
                                  interventions_p["screening_start_age"],
                                  interventions_p["screening_end_age"],
                                  interventions_p["screening_periodicity"],
                                  start_age, periods_per_year);
      
    if (scr_step >= 0) {
      vector<Person*> scr_diag_people;
      
      /*
       * DISTR_SCREENING
       
       // PARCHACO TEST
       NumericVector test_dist(3);
       test_dist(0) = 0.5; test_dist(1) = 0.2; test_dist(2) = 0.3;
       
       scr_diag_people = simul_scr_distributed(states, diag_screen, 
                                              test_dist,*/
      
      scr_diag_people = simul_scr(states, diag_screen,
                                  interventions_p["screening_coverage"],
                                  N_states, step, step/periods_per_year,
                                  interventions_p["screening_not_smokers"],
                                  interventions_p["screening_quitters_years"],
                                  costs, costs_m,
                                  get_costs_vector(costs_p, "screening"),
                                  scr_diagnosis_state,
                                  screened_total);

      screening_diagnosed(scr_step) = scr_diag_people.size();
      
      // Costs tractament postdiagnòstic (cas cribratge)
      // TODO encapsular
      for (int k = 0; k < 3; ++k) {
        for (int i = 0; i < scr_diag_people.size(); ++i) {
          if (postdx_treatment_costs[k] > 0) {
            // costs_m[k].coeffRef((step-1)/periods_per_year, scr_diag_people[i]->person_id) += postdx_treatment_costs[k];
            costs_m[k].coeffRef((step-1)/periods_per_year, 0) += postdx_treatment_costs[k];
          }
        }
      }
      
      // Els diagnosticats per cribratge els classifiquem en supervivents o no, per poder modificar conseqüentment la seva història natural
      // TODO encapsular
      double p_survival = as<double>(interventions_p["survival_after_scr_dx"]);
      for (int i = 0; i < scr_diag_people.size(); ++i) {
        if (unif_rand() < p_survival) {
          scr_diag_people[i]->postdx_survival = true;
        }
        else {
          scr_diag_people[i]->postdx_survival = false;
        }
        // Rcerr << "Pacient #" << setw(5) << scr_diag_people[i]->person_id << " diagnosticat per screening a l'step" << setw(4) << step << ", postdx_survival = " << scr_diag_people[i]->postdx_survival << endl;
      }

      
    }
    
    ////////////////////////////////
    // Simulació step: Diagnòstic espontani
    ////////
    /*
    vector<Person*> sp_diag_people = simul_diag(states, diag_spont, N_states, step);
    
    spontaneous_diagnosed(step-1) = sp_diag_people.size();
    
    // Costs tractament postdiagnòstic (cas espontani)
    // TODO encapsular
    for (int k = 0; k < 3; ++k) {
      for (int i = 0; i < sp_diag_people.size(); ++i) {
        if (postdx_treatment_costs[k] > 0) {
          costs_m[k].coeffRef((step-1)/periods_per_year, sp_diag_people[i]->person_id) += postdx_treatment_costs[k];
        }
      }
    }*/

    
    ////////////////////////////////
    // Simulació step: Quitting intervention
    ////////
    for (int i = 0; i < n_quitting; ++i) {
      if (is_quitting_step(step, quitting_ints[i].interv_steps)) {
        vector<Person*> quitters = quitting_intervention(
          cohort, 
          initial_healthy_population,
          quitting_ints[i],
          N_states,
          step, step/periods_per_year,
          costs, costs_m,
          get_costs_vector(costs_p, "quitting.int"));
      }
    }

    
    ////////////////////////////////
    // Simulació step: Càlcul de costos de l'step (abans de progressar al següent)
    ////////
    for (int i_st = 0; i_st < N_states; ++i_st) {
      for (int k = 0; k < 3; ++k)
        costs[k] += (states[i_st].np*usual_care_costs[k](i_st));
    }
    
    ////////////////////////////////
    // Simulació step: Simulació de la història natural de l'step
    ////////
    simul_nh_step(cohort, states, N_states,
                  probs_current,
                  inc_matrix, inc, inc_smokers, inc_smoker_if_ever,
                  lc_deaths,
                  step,
                  interventions_p["p_smoker"], interventions_p["rr_smoker"],
                  quitting_effect,
                  quitting_risk_y,
                  quitting_rr,
                  periods_per_year);


    ////////////////////////////////
    // Simulació step: Canvi de matriu de transicions, si s'escau
    ////////
    if (tp_index+1 < tp_limits.size() and
          start_age + step/periods_per_year >= tp_limits[tp_index+1]) {
      tp_index++;
      update_transition_vectors(probs_current, states, tps, tp_index, 
                                interventions_p["p_smoker"], interventions_p["rr_smoker"]);
    }
    
  } // [END] Simulació step
  
  IntegerMatrix nh_counts(N_cycles+1, N_states);
  for (int i = 0; i < initial_healthy_population; ++i) {
    for (int j = 0; j <= N_cycles; ++j) {
      nh_counts(j, (unsigned int)cohort[i].nh[j])++;
    }
  }
  
  // Càlcul de costos per usual care. TODO encapsular
  // Rcerr << "pato!" << endl;
  bool well_is_free = (usual_care_costs[0](0) == 0 and usual_care_costs[1](0) == 0 and usual_care_costs[2](0) == 0);
  // Rcerr << "cuac! (" << well_is_free << ")" << endl;
  
  // for (int i = 0; i < 7; ++i) Rcerr << usual_care_costs[0](i) << " ";
  // Rcerr << endl;
  // Rcerr << "**********************" << endl;
  // Rcerr << "**********************" << endl;
  // Rcerr << "**********************" << endl;
  
  for (int i = 0; i < initial_healthy_population; ++i) {
    // Rcerr << endl << "holiii!";
    if (well_is_free and cohort[i].nh[N_cycles] == 0)
      continue;  // if well at last cycle, nothing to explore
    // Rcerr << endl << "Not well at last cycle:" << setw(6) << i;
    
    int j = 0;
    if (well_is_free)
      while (cohort[i].nh[j] == 0) ++j; // skip well states
    
    // Rcerr << " Since cycle " << j << "(" << (int)cohort[i].nh[j] << ", cost directe="<< usual_care_costs[0](cohort[i].nh[j]) << ")";
    
    while (j < N_cycles and cohort[i].nh[j] < N_states-2) {
      int st = cohort[i].nh[j];
      for (int k = 0; k < 3; ++k) {
        if (usual_care_costs[k](st) != 0) {
          costs_m[k].coeffRef((j)/periods_per_year, i) += usual_care_costs[k](cohort[i].nh[j]);
        }
      }
      
      ++j;
    }
    
    // Rcerr << "#";
  }
   
  for (int k = 0; k < 3; ++k)
    costs_m[k].makeCompressed();
  
  // Spontaneous diagnosis a posteriori
  IntegerVector spontaneous_diagnosed = spont_diag_a_posteriori(cohort, initial_healthy_population, N_states, N_cycles, periods_per_year, costs_p, costs_m);
  
  // Optional computations
  NumericVector mpst;
  if (options_p.containsElementNamed("print") and as<bool>(options_p["print"])) {
    print_history(cohort, initial_healthy_population, N_cycles);
  }
  if (options_p.containsElementNamed("mpst_computation_states")) {
    // vector<byte> aux(3); aux[0]=1; aux[1]=2; aux[2]=3; // TODO parametritzar
    IntegerVector mpst_states = options_p["mpst_computation_states"];
    if (mpst_states.size() > 0) {
      mpst = compute_mpst(cohort, initial_healthy_population, N_cycles, 
                          mpst_states, N_states);
    }
    
  }
  
  // Prepare to return
  for (int k = 0; k < 3; ++k)
    costs_m[k].makeCompressed();

  // Free memory!
  free_nhs(cohort, initial_healthy_population);
  free(cohort);
  free(states);
  
  return List::create(_("nh") = nh_counts,
                      _("incidence") = inc,
                      _("incidence_smokers") = inc_smokers,
                      _("lc_deaths") = lc_deaths,
                      _("screening_diagnosed") = screening_diagnosed,
                      _("scr_diagnosis_state") = scr_diagnosis_state,
                      _("screened_total") = screened_total,
                      _("spontaneous_diagnosed") = spontaneous_diagnosed,
                      _("mpst") = mpst,
                      // _("costs") = costs);
                      _("costs") = costs,
                      _("costs_m") = costs_m);
}


