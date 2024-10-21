filepath <- "~/Documents/Research/Code/Simulations/Changepoint/sim_results.csv"
project_directory <- "~/Documents/Research/Code/Simulations/Changepoint/"
source(paste(project_directory, "cp_eval.R", sep = ""))
source(paste(project_directory, "cp_functions.R", sep = ""))
source(paste(project_directory, "cp_scenarios.R", sep = ""))
library(tidyverse)
library(changepoint)

# Simulation Parameters
N <- 10000
n <- 15000
scenario_num <- 5
cp_method <- "PELT"
cp_penalty <- NA
cp_penalty_val <- NA
eval_method <- "count"
signal_strength <- 0.25

# Update Simulation Parameters
sim_params <- uni_scenario(
  scenario_num = scenario_num,
  n = n,
  signal = signal_strength,
  sd = 1
)

# Generate Data
sim_data <- replicate(N,
  generate_data(sim_params),
  simplify = F
)

# Estimate Change Points
start_time <- proc.time()
sim_cp <- map(
  sim_data,
  function(X) {
    cp_detect(
      data = X,
      method = cp_method
    )
  }
)
end_time <- proc.time()
sim_time <- (end_time - start_time)["elapsed"] / N

# Evaluate Performance
sim_eval <- map(
  sim_cp,
  function(cp_est) {
    cp_evaluate(
      cp_est = cp_est,
      cp_true = sim_params$cp,
      method = eval_method,
      n = n
    )
  }
) %>% unlist()

# Export Results
sim_obj <- list(
  num_sims = N,
  sample_size = sim_params$n,
  scenario_num = scenario_num,
  signal_strength = signal_strength,
  cp_method = cp_method,
  cp_penalty = cp_penalty,
  cp_penalty_val = cp_penalty_val,
  eval_method = eval_method,
  eval_value_mean = mean(sim_eval, na.rm = TRUE),
  eval_value_sd = sd(sim_eval, na.rm = TRUE),
  eval_value_na = sum(is.na(sim_eval)),
  runtime = sim_time,
  datetime = Sys.time()
)

# Write Data
export_sim(sim_obj, filepath)
