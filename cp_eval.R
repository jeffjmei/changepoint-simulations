hausdorff <- function(A, B) {
  if (is.null(A)) {
    NA
  } else {
    max(
      max(sapply(A, function(a) {
        min(sapply(B, function(b) {
          abs(a - b)
        }))
      })),
      max(sapply(B, function(a) {
        min(sapply(A, function(b) {
          abs(a - b)
        }))
      }))
    )
  }
}

rand_index <- function(cp_est, cp_true, n) {
  # Generate True Partition
  A <- matrix(0, nrow = n, ncol = n)
  B <- matrix(0, nrow = n, ncol = n)

  # Modify Change Point Positions
  cp_true_mod <- c(1, cp_true, n)
  cp_est_mod <- c(1, cp_est, n)

  # Calculate Rand Index for True Change Points
  idx_start <- cp_true_mod[1:(length(cp_true_mod) - 1)]
  idx_end <- cp_true_mod[2:length(cp_true_mod)]
  for (i in 1:length(idx_start)) {
    A[idx_start[i]:idx_end[i], idx_start[i]:idx_end[i]] <- 1
  }

  # Calculate Rand Index for Estimated Change Points
  idx_start <- cp_est_mod[1:(length(cp_est_mod) - 1)]
  idx_end <- cp_est_mod[2:length(cp_est_mod)]
  for (i in 1:length(idx_start)) {
    B[idx_start[i]:idx_end[i], idx_start[i]:idx_end[i]] <- 1
  }
  sum(abs(A - B)) / n^2
}

cp_evaluate <- function(cp_est, cp_true, method, n = ...) {
  if (method == "count") {
    length(cp_true) - length(cp_est)
  } else if (method == "hausdorff") {
    hausdorff(cp_est, cp_true)
  } else if (method == "randindex") {
    rand_index(cp_est, cp_true, n)
  }
}
