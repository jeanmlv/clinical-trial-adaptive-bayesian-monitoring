# Adaptive Bayesian Monitoring in Clinical Trials (ABMCT)

# Required packages
install.packages(c("tidyverse", "brms", "tidybayes", "bayesplot", "patchwork"))
library(tidyverse)
library(brms)        # for Bayesian modeling
library(tidybayes)   # for posterior visualization
library(bayesplot)   # for nice plots
library(patchwork)   # for combining ggplots

# Function to simulate a trial with adaptive Bayesian monitoring
simulate_bayesian_trial <- function(n_total = 100, 
                                    cohort_size = 10,
                                    p_control = 0.5,
                                    p_treatment = 0.7,
                                    prob_eff = 0.99,
                                    prob_fut = 0.10,
                                    prior_alpha = 1,
                                    prior_beta = 1) {
  
  results <- tibble(
    cohort = integer(),
    n_total = integer(),
    prob_superior = numeric(),
    stop_for = character()
  )
  n_cohorts <- n_total / cohort_size
  
  control_outcomes <- c()
  treatment_outcomes <- c()
  
  for (i in 1:n_cohorts) {
    # Simulate outcomes for each arm
    new_control <- rbinom(cohort_size / 2, 1, p_control)
    new_treatment <- rbinom(cohort_size / 2, 1, p_treatment)
    
    control_outcomes <- c(control_outcomes, new_control)
    treatment_outcomes <- c(treatment_outcomes, new_treatment)
    
    # Posterior from Beta-Binomial model
    post_control <- rbeta(10000, sum(control_outcomes) + prior_alpha, length(control_outcomes) - sum(control_outcomes) + prior_beta)
    post_treatment <- rbeta(10000, sum(treatment_outcomes) + prior_alpha, length(treatment_outcomes) - sum(treatment_outcomes) + prior_beta)
    
    prob_superior <- mean(post_treatment > post_control)
    
    # Record results
    results <- results |> add_row(
      cohort = i,
      n_total = length(control_outcomes) + length(treatment_outcomes),
      prob_superior = prob_superior,
      stop_for = case_when(
        prob_superior > prob_eff ~ "efficacy",
        prob_superior < prob_fut ~ "futility",
        TRUE ~ "continue"
      )
    )
    
    if (results$stop_for[i] != "continue") break
  }
  
  return(list(data = results, control = control_outcomes, treatment = treatment_outcomes))
}

# Run the simulation
set.seed(123)
sim <- simulate_bayesian_trial()

# Plot posterior at last analysis
last_control <- sim$control
last_treatment <- sim$treatment

post_control <- rbeta(10000, sum(last_control) + 1, length(last_control) - sum(last_control) + 1)
post_treatment <- rbeta(10000, sum(last_treatment) + 1, length(last_treatment) - sum(last_treatment) + 1)

posterior_df <- tibble(
  value = c(post_control, post_treatment),
  group = rep(c("Control", "Treatment"), each = 10000)
)

posterior_df %>%
  ggplot(aes(x = value, fill = group)) +
  geom_density(alpha = 0.6) +
  labs(title = "Posterior Distributions", x = "Probability of Success", y = "Density") +
  theme_minimal()

# Print trial decision summary
print(sim$data)

# Save output to RDS for reproducibility
saveRDS(sim, file = "simulation_output.rds")
