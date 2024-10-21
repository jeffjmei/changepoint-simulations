# Change Point Simulations
This project compares various change point detection methods. 

Simulations are conducted and are stored within the `sim_results.csv`. Then, the `cp_analyze.Rmd` file aggregates all of the results by reading the saved simulation results and makes figures to document findings.

**Files:**  
- `cp_analyze.Rmd`: documents all findings
- `sim_results.csv`: all simulation results are stored here
- `cp_functions.R`: general R functions
- `cp_eval.R`: R functions for change point evaluation
- `cp_scenarios.R`: R functions for setting up scenarios
- `cp_sim.R`: runs a single simulation
- `cp_sim2.R`: runs multiple simulations

**Methods Available**:  
- Pruned Exact Linear Time (PELT)
- Binary Segmentation

**Evaluation Methods**:  
- `count`: difference between number of true change points and the number of detected change points
- `RandIndex`: squared error between true segmentation and estimated segmentation
- `haussdorf`: robustness statistic for the worst-estimated change point

