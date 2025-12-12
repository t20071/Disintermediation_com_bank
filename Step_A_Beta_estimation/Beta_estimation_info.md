# Mathematical Derivation of Beta Estimation

## Overview

Beta (β) is the **price sensitivity coefficient** in the discrete choice model. It measures how much an agent's utility decreases when the deposit interest rate offered by a bank increases by one unit. In other words, it captures the elasticity of demand with respect to price (or equivalently, the inverse elasticity with respect to the interest rate offered).

---

## 1. The Utility Function (Discrete Choice Framework)

### 1.1 Individual Utility Specification

Each agent i faces a choice among J alternatives (banks, cash, CBDC) at each time period t. The agent's utility from choosing alternative j is:

$$U_{ij} = V_{ij} + \varepsilon_{ij}$$

where:
- **$V_{ij}$** = systematic (observable) utility from alternative j for agent i
- **$\varepsilon_{ij}$** = random error term (unobserved taste variation)

### 1.2 Systematic Utility Specification

The systematic utility is linear in parameters:

$$V_{ij} = \alpha_j + \beta \cdot r_j$$

or more generally:

$$V_{ij} = \alpha_j + \beta \cdot r_j + \sum_{k} \gamma_k \cdot x_{jk}$$

where:
- **$\alpha_j$** = alternative-specific constant (base utility/preference for option j)
- **$r_j$** = interest rate offered on option j (e.g., deposit rate at bank j, rate on cash, rate on CBDC)
- **$\beta$** = price sensitivity coefficient (WHAT WE WANT TO ESTIMATE)
- **$\gamma_k$** = coefficients on other product characteristics $x_{jk}$

### 1.3 Interpretation of Beta

$$\beta = \frac{\partial V_{ij}}{\partial r_j}$$

- If $\beta > 0$: agents prefer higher rates (makes sense for savers/depositors)
- If $\beta < 0$: agents dislike higher rates (would not make economic sense in our context)
- **Magnitude**: $|\beta|$ tells us how much the utility changes per 1% point change in the interest rate
  - Large $|\beta|$ = agents are very responsive to rate changes (elastic demand)
  - Small $|\beta|$ = agents are not very responsive (inelastic demand)

---

## 2. Choice Probabilities (Logit Model)

### 2.1 Standard Multinomial Logit (MNL)

Assuming $\varepsilon_{ij} \sim \text{IID Gumbel}(0,1)$ across all i and j, the probability that agent i chooses alternative j is:

$$P_{ij} = \frac{\exp(V_{ij})}{\sum_{k=1}^{J} \exp(V_{ik})}$$

Substituting the utility specification:

$$P_{ij} = \frac{\exp(\alpha_j + \beta \cdot r_j)}{\sum_{k=1}^{J} \exp(\alpha_k + \beta \cdot r_k)}$$

### 2.2 Nested Logit (If Used in Model)

For nested logit with two nests (in your model: Nest 1 = banks; Nest 2 = cash+CBDC):

$$P_{ij} = P(\text{nest } m | i) \cdot P(j | \text{nest } m, i)$$

**Nest choice probability:**
$$P(\text{nest } m | i) = \frac{\exp\left(\mu_m I_{im}\right)}{\sum_{n=1}^{M} \exp\left(\mu_n I_{in}\right)}$$

**Within-nest choice probability:**
$$P(j | \text{nest } m, i) = \frac{\exp\left(\mu_m \cdot V_{ij}\right)}{\sum_{k \in \text{nest } m} \exp\left(\mu_m \cdot V_{ik}\right)}$$

where:
- $I_{im} = \frac{1}{\mu_m} \ln\left(\sum_{k \in \text{nest } m} \exp(\mu_m V_{ik})\right)$ = inclusive value (or log-sum term)
- $\mu_m$ = nesting parameter (scale parameter for nest m)
  - If $\mu = 1$: reduces to standard logit
  - If $\mu < 1$: agents view within-nest options as more dissimilar
  - If $\mu > 1$: agents view within-nest options as more similar

---

## 3. Likelihood Function (Estimation from Choice Data)

### 3.1 Maximum Likelihood Estimation (MLE)

If you have **individual choice data** (agent i chose alternative j at time t), the log-likelihood is:

$$\mathcal{L}(\beta, \alpha, \gamma) = \sum_{i=1}^{N} \sum_{t=1}^{T} \ln P_{ij(t)}(t)$$

where $j(t)$ is the alternative actually chosen by agent i at time t.

Expanding:

$$\mathcal{L}(\beta, \alpha, \gamma) = \sum_{i=1}^{N} \sum_{t=1}^{T} \left[ V_{ij(t)}(t) - \ln\left(\sum_{k=1}^{J} \exp(V_{ik}(t))\right) \right]$$

$$= \sum_{i=1}^{N} \sum_{t=1}^{T} \left[ \alpha_{j(t)} + \beta \cdot r_{j(t)}(t) - \ln\left(\sum_{k=1}^{J} \exp(\alpha_k + \beta \cdot r_k(t))\right) \right]$$

### 3.2 Estimation Procedure

To estimate $\hat{\beta}$, $\hat{\alpha}$, solve:

$$(\hat{\beta}, \hat{\alpha}, \hat{\gamma}) = \arg\max_{\beta, \alpha, \gamma} \mathcal{L}(\beta, \alpha, \gamma)$$

**Numerical methods** (Newton-Raphson, BFGS, etc.):
- Compute gradient vector $g(\theta) = \frac{\partial \mathcal{L}}{\partial \theta}$
- Compute Hessian matrix $H(\theta) = \frac{\partial^2 \mathcal{L}}{\partial \theta \partial \theta'}$
- Iterate: $\theta_{n+1} = \theta_n - H(\theta_n)^{-1} g(\theta_n)$
- Continue until convergence

### 3.3 Standard Errors (Asymptotic Distribution)

Under regularity conditions, the MLE estimator is asymptotically normal:

$$\sqrt{N} (\hat{\theta} - \theta^*) \xrightarrow{d} \mathcal{N}(0, I(\theta^*)^{-1})$$

where $I(\theta^*) = -E[H(\theta^*)]$ is the **Fisher information matrix**.

In practice, we estimate standard errors as:

$$\widehat{\text{SE}}(\hat{\theta}) = \sqrt{\text{diag}\left(-H(\hat{\theta})^{-1}\right)}$$

or using robust/sandwich estimator:

$$\widehat{\text{Var}}(\hat{\theta}) = H(\hat{\theta})^{-1} \sum_{i=1}^{N} s_i s_i' H(\hat{\theta})^{-1}$$

where $s_i = \sum_t \frac{\partial \ln P_{ij(t)}}{\partial \theta}$ is the score for agent i.

---

## 4. Implied Market Shares (Aggregate Level)

### 4.1 From Micro Choice Probabilities to Macro Shares

If N agents make independent choices and each has the same choice probabilities, then the **equilibrium market share** of alternative j is:

$$s_j = \frac{1}{N} \sum_{i=1}^{N} P_{ij} = E_i[P_{ij}]$$

**Special case**: If all agents are homogeneous (identical $\alpha_j$, $\beta$, etc.), then:

$$s_j = \frac{\exp(\alpha_j + \beta \cdot r_j)}{\sum_{k=1}^{J} \exp(\alpha_k + \beta \cdot r_k)}$$

### 4.2 Log-Odds Ratio (Logit Inversion)

Rearranging the MNL formula:

$$\frac{s_j}{s_0} = \frac{\exp(\alpha_j + \beta \cdot r_j)}{\exp(\alpha_0 + \beta \cdot r_0)}$$

Taking natural logarithm:

$$\ln\left(\frac{s_j}{s_0}\right) = (\alpha_j - \alpha_0) + \beta(r_j - r_0)$$

$$\Delta_{j0} := \ln\left(\frac{s_j}{s_0}\right) = \alpha_j + \beta \cdot r_j \quad \text{(normalizing } \alpha_0=0, r_0=0\text{)}$$

### 4.3 Linear Regression on Market Share Data

If you have **market share data** (not individual choices), you can estimate by linear regression:

$$\Delta_j = \alpha_j + \beta \cdot r_j + u_j$$

where $u_j$ is an error term (demand shock).

**OLS Estimator:**
$$\hat{\beta}_{OLS} = \frac{\text{Cov}(r_j, \Delta_j)}{\text{Var}(r_j)}$$

**Standard errors** (assuming homoskedastic errors):
$$\widehat{\text{SE}}(\hat{\beta}) = \sqrt{\frac{\hat{\sigma}^2}{\sum_j (r_j - \bar{r})^2}}$$

where $\hat{\sigma}^2 = \frac{1}{J-K} \sum_j \hat{u}_j^2$ and K is number of parameters.

---

## 5. Endogeneity & Instrumental Variables (IV)

### 5.1 The Problem

In many settings, interest rates $r_j$ are **endogenous** (determined by banks in response to demand shocks):

$$E[u_j \cdot r_j] \neq 0$$

This violates the exogeneity assumption, biasing $\hat{\beta}_{OLS}$.

### 5.2 IV Solution

Find instruments $Z_j$ such that:
1. **Relevance**: $\text{Cov}(Z_j, r_j) \neq 0$ (correlated with price)
2. **Exogeneity**: $\text{Cov}(Z_j, u_j) = 0$ (uncorrelated with demand shock)

**2SLS Estimator:**

**First stage:**
$$r_j = \pi_0 + \pi_1 Z_j + v_j$$
$$\hat{r}_j = \hat{\pi}_0 + \hat{\pi}_1 Z_j$$

**Second stage:**
$$\Delta_j = \alpha + \beta \hat{r}_j + \varepsilon_j$$
$$\hat{\beta}_{2SLS} = \frac{\text{Cov}(\hat{r}_j, \Delta_j)}{\text{Var}(\hat{r}_j)}$$

**Asymptotic variance** (under homoskedasticity):
$$\widehat{\text{Var}}(\hat{\beta}_{2SLS}) = \frac{\hat{\sigma}^2}{SST_{adj}^2}$$

where $SST_{adj}^2 = \text{Var}(\hat{r}_j)$ from first stage.

### 5.3 Overidentification Tests (If Multiple Instruments)

If K > 1 instruments for 1 endogenous variable, can test if extra instruments are valid:

**Hansen J-test statistic:**
$$J = \mathbf{u}' \mathbf{Z} (\mathbf{Z}' \mathbf{Z})^{-1} \mathbf{Z}' \mathbf{u} / \hat{\sigma}^2$$

where $\mathbf{u}$ are residuals from 2SLS, $\mathbf{Z}$ is instrument matrix.

Under $H_0$ (overidentifying restrictions valid):
$$J \sim \chi^2_{K-1}$$

High p-value suggests instruments are valid; low p-value suggests instrument invalidity.

---

## 6. Application to Your Paper's Model

### 6.1 Model Setup

**Agents' money holding choice:**

Each agent i chooses to hold money in form j ∈ {Bank 1, ..., Bank B, Cash, CBDC}.

**Utility function (from your paper):**

$$V_{ij} = \alpha_j + \beta \cdot r_j$$

where:
- $\alpha_j$ = base utility of asset j
  - $\alpha_{\text{Bank}} < \alpha_{\text{Cash}} < \alpha_{\text{CBDC}}$ typically (but depends on parameters tested)
- $r_j$ = interest rate on asset j
- $\beta$ > 0 = price sensitivity (higher rates more attractive)

**In your MODEL_Loop.m:**
- $\beta$ is held **constant** at 75 (fixed parameter)
- You vary $\alpha_{\text{Cash}}$ and number of banks B to trace out how equilibrium outcomes change
- **Step C** then inverts this: given observed deposit rates and cash ratios, solve for what β must have been

### 6.2 Nested Logit Extension

If agents choose in two stages (your `sim_data_CL_nested.m`):

**Stage 1:** Choose nest (banks vs. cash/CBDC)
**Stage 2:** Choose specific option within chosen nest

Then choice probabilities become (as shown in Section 2.2):

$$P_{ij} = P(\text{nest } m) \times P(j | \text{nest } m)$$

with inclusive value:
$$I_m = \frac{1}{\mu_m} \ln\left(\sum_{k \in m} \exp(\mu_m V_{ik})\right)$$

This affects the **elasticity** of choices:
- Cross-elasticity within nest: higher (options are closer substitutes)
- Cross-elasticity across nests: lower (options are more distant)

The nesting parameter $\mu$ controls this trade-off.

---

## 7. Elasticity Interpretation of Beta

### 7.1 Own-Price (Interest Rate) Elasticity

The **own-price elasticity** of demand for alternative j with respect to its own rate is:

$$\varepsilon_{jj} = \frac{\partial \ln s_j}{\partial r_j} = \beta \left( 1 - s_j \right)$$

**Interpretation:**
- If $\beta = 75$ and $s_j = 0.3$ (30% market share):
  - $\varepsilon_{jj} = 75 \times (1 - 0.3) = 52.5$
  - A 1% increase in rate → 52.5% increase in demand (highly elastic!)

### 7.2 Cross-Price Elasticity

The elasticity of demand for j with respect to the rate on alternative k ≠ j:

$$\varepsilon_{jk} = -\frac{\partial \ln s_j}{\partial r_k} = -\beta \cdot s_j \cdot s_k$$

**Interpretation:**
- If bank j and bank k have equal market shares ($s_j = s_k = 0.5$):
  - $\varepsilon_{jk} = -75 \times 0.5 \times 0.5 = -18.75$
  - Competitor raising their rate by 1% reduces demand for j by 18.75%

### 7.3 Relationship to Money Velocity

In your model, agents' consumption spending is:
$$C_i = \gamma \cdot M_i$$

where $\gamma$ is the velocity of money. This links to β through the model's equilibrium structure but is **not directly mechanically derived** from β.

---

## 8. Your Estimation File: `estimate_beta_logit.m`

### 8.1 What Your Code Does

Your current script in `Beta_Estimation_Real_Data.m` uses:

$$y_i = \log\left(\frac{CR_i}{1 - CR_i}\right)$$

where $CR_i$ = cash ratio at time i (ratio of cash to total money holdings).

Then regresses:
$$y_i = \alpha + \beta \cdot r_i + \varepsilon_i$$

where $r_i$ = interest rate at time i.

**This is equivalent to:**
- Assuming the logit model with outside option (non-cash) having utility 0
- Inferring the cash ratio from logit choice probabilities
- Running OLS on the log-odds of cash vs. no-cash

### 8.2 OLS vs. IV Trade-off

Your current version uses **OLS**. This is appropriate if:
- Interest rates are **exogenous** (set by policy, not responding to demand)
- No unobserved demand shocks

If rates are **endogenous** (banks set rates in response to cash demand shocks), use **IV**:
- Good instruments: cost shifters (wage growth, reserve requirement changes), competitor rates
- Bad instruments: contemporaneous demand shocks, lagged cash ratios

### 8.3 Computing Standard Errors

**For OLS:**
$$\widehat{\text{SE}}(\hat{\beta}) = \sqrt{\frac{\sum_i \hat{\varepsilon}_i^2 / (T - K)}{(T - K)^{-1} \sum_i (r_i - \bar{r})^2}}$$

**Robust (HC) version:**
$$\widehat{\text{SE}}_{\text{robust}}(\hat{\beta}) = \sqrt{\frac{\sum_i \hat{\varepsilon}_i^2 (r_i - \bar{r})^2}{(\sum_i (r_i - \bar{r})^2)^2}}$$

Both are computed in your updated `estimate_beta_logit.m` function.

---

## 9. Summary Table: Beta Estimation Methods

| Method | Data Type | Assumptions | Pros | Cons |
|--------|-----------|-------------|------|------|
| **MLE (Logit)** | Individual choices | IID errors, correct spec | Efficient, tests goodness-of-fit | Complex, needs individual data |
| **OLS (Log-odds)** | Market shares/aggregate | Exogenous prices, homoskedastic | Simple, fast | Endogeneity bias if prices respond to demand |
| **IV (2SLS)** | Market shares + instruments | Valid instruments | Addresses endogeneity | Weak instruments → poor estimates |
| **GMM** | Market shares/moments | Moment conditions | Flexible | Computational complexity |

---

## 10. Key Equations Summary (Cheat Sheet)

### Utility & Probability
$$V_{ij} = \alpha_j + \beta r_j$$
$$P_{ij} = \frac{\exp(V_{ij})}{\sum_k \exp(V_{ik})}$$

### Market Share & Log-Odds
$$s_j = E[P_{ij}]$$
$$\ln\left(\frac{s_j}{s_0}\right) = \alpha_j + \beta r_j$$

### Log-Likelihood (Individual Data)
$$\mathcal{L} = \sum_{i,t} \ln P_{ij(t)}(t)$$

### OLS Estimator (Aggregate Data)
$$\hat{\beta}_{OLS} = \frac{\sum_j (r_j - \bar{r})\ln(s_j/s_0)}{\sum_j (r_j - \bar{r})^2}$$

### 2SLS Estimator (With Instruments)
$$\hat{\beta}_{2SLS} = \left(\hat{X}' X\right)^{-1} \hat{X}' y$$
where $\hat{X} = Z(Z'Z)^{-1}Z'X$ is instrumented price

### Elasticity
$$\varepsilon_{jj} = \beta(1 - s_j)$$
$$\varepsilon_{jk} = -\beta \cdot s_j \cdot s_k$$

### Standard Error (OLS)
$$\widehat{\text{SE}}(\hat{\beta}) = \sqrt{\text{diag}\left((X'X)^{-1} X' \hat{\Sigma} X (X'X)^{-1}\right)}$$
where $\hat{\Sigma}$ is diagonal matrix of squared residuals (robust version)

---

## 11. Papers & References 

1. **Train, K. E. (2009).** *Discrete Choice Methods with Simulation* (2nd ed.). Cambridge University Press.
   - Chapter 3: Logit Model
   - Chapter 5: Nested Logit

2. **McFadden, D. (1974).** "The Measurement of Urban Travel Demand." *Journal of Public Economics*, 3(4), 303–328.
   - Original discrete choice theory

3. **Nevo, A. (2001).** "Measuring Market Power in the Ready-to-Eat Cereal Industry." *Econometrica*, 69(2), 307–342.
   - Excellent applied example of BLP (nested logit) estimation with instruments

4. **Berry, S., Levinsohn, J., & Pakes, A. (1995).** "Automobile Prices in Market Equilibrium." *Econometrica*, 63(4), 841–890.
   - The classic "BLP" paper on discrete choice with endogeneity and inversion

5. **Cameron, A. C., & Trivedi, P. K. (2005).** *Microeconometrics: Methods and Applications*. Cambridge University Press.
   - Chapter 15: Discrete Choice

---

*Mathematical derivations prepared for academic explanation of beta estimation (December 2025)*
