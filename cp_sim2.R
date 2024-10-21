"""
DESCRIPTION: 

The purpose of this file is to have a blueprint for quickly generating simulations
"""

# ============
# Source Files
# ============
filepath <- "~/Documents/Research/Code/Simulations/Changepoint/sim_results.csv"
project_directory <- "~/Documents/Research/Code/Simulations/Changepoint/"
source(paste(project_directory, "cp_eval.R", sep = ""))
source(paste(project_directory, "cp_functions.R", sep = ""))
source(paste(project_directory, "cp_scenarios.R", sep = ""))
library(tidyverse)
library(changepoint)


# ==================
# Set Parameter Grid
# ==================
num_sims <- 10000
n_seq <- c(500, 1000, 5000, 10000, 15000, 20000)
scenario_num <- c(2, 3, 4, 5)
signal_strength <- c(0.25, 0.5, 1.0)
cp_method <- "PELT"
cp_penalty <- NA
cp_penalty_val <- NA
eval_method <- c("count")

param_grid <- expand.grid(
    num_sims = num_sims, 
    sample_size = n_seq,
    scenario_num = scenario_num,
    signal_strength = signal_strength,
    cp_method = cp_method, 
    cp_penalty = cp_penalty,
    cp_penalty_val = cp_penalty_val,
    eval_method = eval_method
) %>% as_tibble()


# =========
# Read Data
# =========
filepath <- "~/Documents/Research/Code/Simulations/Changepoint/sim_results.csv"
sim_results <- read_csv(filepath)

param_cols <- c(
    "num_sims", 
    "sample_size",
    "scenario_num",
    "signal_strength",
    "cp_method", 
    "cp_penalty",
    "cp_penalty_val",
    "eval_method"
)

# ============================
# Identify Missing Simulations
# ============================
sim_params <- anti_join(
  param_grid, 
  sim_results,
  by = param_cols
)

# ==========================
# Generate/Write Simulations
# ==========================
sim_params %>% 
  pmap(cp_simulate) %>% 
  map(function(sim_obj) export_sim(sim_obj, filepath))

