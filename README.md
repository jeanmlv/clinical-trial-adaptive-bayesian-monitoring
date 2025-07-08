# Clinical Trial — Bayesian Adaptive Monitoring

> A Bayesian adaptive simulation of treatment versus control in clinical trials with dynamic posterior updates, sequential decision-making, and early stopping rules for efficacy or futility.

---

## 🎯 Objective

This repository presents a simulated Bayesian adaptive clinical trial that compares a **Treatment Group vs. Control Group** using:

✔ Posterior probability estimation with Beta-Binomial conjugate models  
✔ Dynamic cohort-based data collection and monitoring  
✔ Early stopping decisions for **efficacy** or **futility**  
✔ Visual comparison of posterior distributions  
✔ Probabilistic interpretation of treatment effect

The goal is to replicate real-world adaptive design strategies that improve trial efficiency and ethical standards by reducing unnecessary patient exposure.

---

## 🧰 Technologies

- **Language**: R  
- **Core Packages**:  
  - `tidyverse` – Data wrangling and plotting  
  - `brms` or `rstanarm` – Bayesian modeling (optionally extendable)  
  - `tidybayes` – Posterior extraction and visualization  
  - `bayesplot` – Diagnostic and density plots  
  - `patchwork` – Plot composition  
- **Reporting Tools**:  
  - `rmarkdown` – Reporting and reproducibility  
  - `ggplot2` – Custom plot design

---

## 📊 Analysis Workflow

1. **Trial Simulation**
   - Generate patient outcomes for treatment and control using `rbinom()`
   - Simulate cohorts iteratively and update posteriors

2. **Bayesian Posterior Estimation**
   - Use `rbeta()` to simulate the posterior for each arm  
   - Calculate posterior probability \( P(Treatment > Control) \)

3. **Sequential Monitoring**
   - Evaluate stopping criteria after each cohort:
     - **Stop for efficacy** if \( P > 0.99 \)
     - **Stop for futility** if \( P < 0.10 \)

4. **Output Generation**
   - Posterior density plots  
   - Tabular summary of trial progression  
   - Export simulation results as `.rds`

---

## 📝 Example Output

### Posterior Distributions After Final Cohort

![Posterior Plot](./posterior_plot_example.png)

> Clear separation between treatment and control posterior densities, indicating a strong signal for treatment efficacy.

---

### Trial Summary Table

| **Cohort** | **N Total** | **P(Treatment > Control)** | **Decision**      |
|------------|-------------|-----------------------------|-------------------|
| 1          | 10          | 0.727                       | Continue          |
| 2          | 20          | 0.670                       | Continue          |
| 3          | 30          | 0.874                       | Continue          |
| 4          | 40          | 0.907                       | Continue          |
| 5          | 50          | 0.958                       | Continue          |
| 6          | 60          | **0.996**                   | **Stop – Efficacy** ✅ |

---

## 🔄 Possible Extensions

- 🧠 Incorporate **time-to-event data** and **survival analysis**
- 📉 Include **frequentist comparison** (Log-rank test or Fisher's Exact Test)
- 🌐 Build an interactive **Shiny dashboard** for real-time trial simulation
- 📊 Add **forest plots** for subgroup Bayesian estimates
- 📁 Automate RMarkdown report generation for full reproducibility

---

## 📚 Use Case

This simulation is ideal for:
- Clinical researchers exploring adaptive trial frameworks  
- Biostatistics students learning Bayesian decision-making  
- Portfolio showcase of applied R programming in clinical analytics  
- Rapid prototyping of trial design strategies before implementation

---

> 📎 _This project is for educational and demonstration purposes only. It simulates hypothetical data and is not based on real clinical trial results._
