uni_scenario1 <- function(n = 100, sd = 1, signal = 1) {
  # No Change Point
  h <- signal * rep(0, n)
  obj <- list(n = n, sd = sd, h = h, cp = NULL)
  return(obj)
}

uni_scenario2 <- function(n = 100, sd = 1, signal = 1) {
  # Single Change Point
  h <- signal * c(rep(-1 / 2, n / 2), rep(1 / 2, n / 2))
  cp <- which(h[2:length(h)] != h[1:(length(h) - 1)])
  obj <- list(n = n, sd = sd, h = h, cp = cp)
  return(obj)
}

uni_scenario3 <- function(n = 100, sd = 1, signal = 1) {
  # Dense Change Points (min seg len = 2)
  h <- signal * rep(c(1, 1, -1, -1), n / 4)
  cp <- which(h[2:length(h)] != h[1:(length(h) - 1)])
  obj <- list(n = n, sd = sd, h = h, cp = cp)
  return(obj)
}

uni_scenario4 <- function(n = 100, sd = 1, signal = 1, seed = 321) {
  # Wild Style
  K <- n / 10
  cp1 <- 2 * sort(sample(1:(n / 2 - 1), K, replace = F))
  cp1 <- c(0, cp1, n)
  mu1 <- rnorm(K + 1, 0, 1)
  h1 <- unlist(sapply(1:(K + 1), function(i) rep(mu1[i], cp1[i + 1] - cp1[i])))
  h <- signal * h1

  # Return Parameter Object
  cp <- which(h[2:length(h)] != h[1:(length(h) - 1)])
  obj <- list(n = n, sd = sd, h = h, cp = cp)
  return(obj)
}

uni_scenario5 <- function(n = 100, sd = 1, signal = 1) {
  # Moderately Dense Change Points (fixed number of change points: 10)
  h <- signal * rep(rep(c(1, -1), each = n / 20), 10)
  cp <- which(h[2:length(h)] != h[1:(length(h) - 1)])
  obj <- list(n = n, sd = sd, h = h, cp = cp)
  return(obj)
}



uni_scenario <- function(scenario_num, n = 100, sd = 1, signal = 1) {
  if (scenario_num == 1) {
    uni_scenario1(n = n, sd = sd, signal = signal)
  } else if (scenario_num == 2) {
    uni_scenario2(n = n, sd = sd, signal = signal)
  } else if (scenario_num == 3) {
    uni_scenario3(n = n, sd = sd, signal = signal)
  } else if (scenario_num == 4) {
    uni_scenario4(n = n, sd = sd, signal = signal)
  } else if (scenario_num == 5) {
    uni_scenario5(n = n, sd = sd, signal = signal)
  } else {
    return(0)
  }
}
