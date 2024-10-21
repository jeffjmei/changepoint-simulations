generate_data <- function(params) {
  e <- rnorm(params$n, 0, params$sd)
  X <- params$h + e
  return(X)
}

cp_detect <- function(data, method, penalty = ...) {
  if (method == "PELT") {
    cp_obj <- cpt.mean(data, method = "PELT")
    cp_est <- cpts(cp_obj)
    if (length(cp_est) == 0) {
      NULL
    } else {
      cp_est
    }
  } else if (method == "BINSEG") {
    cp_obj <- cpt.mean(data,
      method = "BinSeg",
      pen.value = penalty
    )
    cp_est <- cpts(cp_obj)
    if (length(cp_est) == 0) {
      NULL
    } else {
      cp_est
    }
  }
}

export_sim <- function(sim_obj, filepath) {
  write.table(as.data.frame(sim_obj), filepath,
    sep = ",",
    append = TRUE, col.names = FALSE, row.names = FALSE
  )
}

plot_params <- function(sim_params, title = NULL) {
  X <- data.frame(
    idx = 1:sim_params$n,
    h = sim_params$h,
    x = generate_data(sim_params)
  )
  ggplot(data = X, aes(x = idx, y = x)) +
    geom_point() +
    geom_step(aes(x = idx, y = h)) +
    labs(
      title = title,
      x = "index",
      y = "X"
    ) +
    theme_bw()
}

cp_simulate <- function(
    num_sims,
    sample_size,
    scenario_num,
    signal_strength,
    cp_method,
    cp_penalty,
    cp_penalty_val,
    eval_method) {
  # Update Simulation Parameters
  scenario_params <- uni_scenario(
    scenario_num = scenario_num,
    n = n,
    signal = signal_strength,
    sd = sd
  )

  # Generate Data
  sim_data <- replicate(N,
    generate_data(scenario_params),
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
        cp_true = scenario_params$cp,
        method = eval_method,
        n = n
      )
    }
  ) %>% unlist()

  # Export Results
  sim_obj <- list(
    num_sims = N,
    sample_size = scenario_params$n,
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
  return(sim_obj)
}
