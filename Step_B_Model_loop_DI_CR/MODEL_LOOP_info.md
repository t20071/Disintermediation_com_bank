# MODEL_Loop.m — Purpose and Workflow

## What MODEL_Loop Does

`MODEL_Loop.m` is a **parametric simulation engine** that:

1. **Runs 120 full ABM (Agent-Based Model) simulations**
   - Each simulation = 3000 time periods
   - For each combination of:
     - **B** ∈ {1, 2, 3, 4, 5, 7, 10, 13, 15, 20, 25, 30} (12 values: number of banks)
     - **alpha_cash** ∈ {-10, -5, 0, 1, 2, 3, 4, 5, 7.5, 10} (10 values: cash utility baseline)

2. **Simulates economic equilibrium** under each market structure:
   - N = 1000 households/firms choose where to deposit (banks, hold cash, or hold CBDC)
   - B banks compete on deposit rates (set via Thompson Sampling learning algorithm)
   - 1 Central Bank provides reserves, enforces reserve requirements, issues CBDC
   - Each agent borrows from one bank, makes consumption choices
   - Interest flows, dividends, and reserve management occur every period

3. **Produces two key output matrices** (12 rows × 10 columns each):
   - **tab1**: Equilibrium deposit rates across (B, alpha_cash) grid
   - **tab3**: Equilibrium cash/M ratios across (B, alpha_cash) grid
   - Plus 10 additional diagnostic tables (analytical rates, reserves, convergence, etc.)

---

## How MODEL_Loop Output Feeds into Step C

### Step A (Estimation) → Step B (Intermediate) → Step C (Polynomial Solver)

**Step A/B output:** Estimates of structural parameters (`beta`, `gamma`, `delta`, `lambda`, `rB`, `rH`, `rDC`)

**Step C input:** MODEL_Loop matrices (tab1, tab3)

**Step C workflow:**

```
MODEL_Loop output (tab1, tab3)
    ↓
    [Polynomial Estimation]
    Fit 2D polynomial surfaces:
      - deposit_rate(B, alpha_cash) = f(B, α_c) = Σ β_ij * B^i * α_c^j
      - cash_ratio(B, alpha_cash) = g(B, α_c) = Σ γ_ij * B^i * α_c^j
    ↓
    [Model Inversion]
    Given empirical data (actual deposit rates, actual cash ratios from central bank):
      - Solve: f(B_emp, α_c,emp) = deposit_rate_observed
      - Solve: g(B_emp, α_c,emp) = cash_ratio_observed
    ↓
    → Recover: Structural parameters (β, γ, etc.) that make the model fit reality
```

---

## Key Inputs to MODEL_Loop (User-Tunable)

Set at the top of the script:

| Parameter | Current Value | Meaning |
|-----------|---------------|---------|
| **N** | 1000 | Number of non-bank agents |
| **T** | 3000 | Number of time periods per scenario |
| **S** | 750 | Periods at end of run used for summary stats |
| **BB** | [1 2 3 ... 30] | Vector of bank counts to test (12 values) |
| **alpha_cash** | [-10 -5 0 ... 10] | Vector of cash utility baselines (10 values) |
| **beta** | 75 | Price sensitivity coefficient (agents' deposit choice elasticity) |
| **gamma** | 1.221 | Velocity of money (annual) |
| **delta** | 0.75 | Probability of moving loans when changing deposit bank |
| **lambda** | 0.10 | Reserve requirement ratio (10% of deposits) |
| **rB** | 0.056 | Central bank lending rate (annual, 5.6%) |
| **rH** | [0.0 0.0335] | CB remuneration: required & excess reserve rates (annual) |
| **rDC** | 0.0 | CBDC interest rate (annual) |
| **nest** | 0 or 1 | Logit model type: non-nested (0) or nested (1) |
| **mu** | 1 or 100 | Scale parameter for nested logit (1 if nest=0, 100 if nest=1) |

---

## Key Outputs from MODEL_Loop (12 Tables)

After all 120 scenarios complete, MODEL_Loop populates these 12 output tables:

| Table | Rows × Cols | Content |
|-------|-------------|---------|
| **tab1** | 12 × 10 | Simulated equilibrium **deposit rates** |
| **tab2** | 12 × 10 | Analytical equilibrium **deposit rates** (for comparison) |
| **tab3** | 12 × 10 | Simulated **cash/M ratios** (cash demand) |
| **tab4** | 12 × 10 | Analytical **cash/M ratios** |
| **tab5** | 12 × 10 | Simulated **CBDC/M ratios** |
| **tab6** | 12 × 10 | Analytical **CBDC/M ratios** |
| **tab7** | 12 × 10 | End-of-period **reserve holdings** (banks' assets) |
| **tab8** | 12 × 10 | Effective system **lending rates** (loan interest) |
| **tab9** | 12 × 10 | Count of non-banks **unable to pay full loan interest** |
| **tab10** | 12 × 10 | Final grid size **G*** (convergence) |
| **tab11** | 12 × 10 | Convergence achieved (1=YES, 0=NO) |
| **tab12** | 12 × 10 | Periods spent at **G*** (if converged) |

**For Step C, the critical matrices are:**
- **tab1** (or tab2 analytical): used to fit polynomial for deposit_rate(B, alpha_cash)
- **tab3** (or tab4 analytical): used to fit polynomial for cash_ratio(B, alpha_cash)

---

## Model Loop Flow (Per Scenario)

For each (B, alpha_cash) pair:

```
Initialization:
  - distrib(N, B) → distribute 1000 agents evenly across B banks
  - Setup balance sheets, learning grids, tracking matrices

For t = 1 to 3000:
  ├─ carryover.m           [Copy balance sheets t → t+1]
  ├─ Step 1: Banks set deposit rates (rate grid with Thompson Sampling learning)
  ├─ Step 2: sim_data_CL_nested.m [Agents choose deposits/cash/CBDC]
  ├─ Step 3: Deposit & loan account transfers
  ├─ Step 4: net_CBD.m [Reserve netting & requirement enforcement]
  ├─ Step 5: Non-bank consumption spending
  ├─ Step 6: net_CBD.m [Reserve netting again]
  ├─ Step 7: interest_flows.m [Compute all interest flows & dividends]
  │          (calls net_CBD.m twice internally)
  ├─ Step 8: Update deposit rate learning (Thompson Sampling)
  └─ Step 9: assess_IQR.m [Check rate convergence, maybe expand grid]

Post-simulation (after T=3000):
  - nash_analytical_heterog_partialexog_nested.m [Compute analytical equilibrium]
  - Average last S=750 periods to get steady-state summary stats
  - Populate tab1-tab12 for this (B, alpha_cash) scenario

Output: One row added to each tab1-tab12 matrix
```

---

## How Long Does MODEL_Loop Take?

- **Per scenario (one B, one alpha_cash):** ~30–120 seconds (depending on machine & T)
- **Total for 120 scenarios:** ~1–4 hours
- **Optimization tip:** If S (summary window) is large and T is large, runtime increases quadratically. Reduce T or S to speed up testing.

---

## Why MODEL_Loop Exists (Context)

In the original **published model**:
- User runs `MODEL.m` once for **one specific market structure** (one B, one alpha_cash, one scenario)
- Output: deposit rates and cash ratios for that scenario
- If you want to see how results vary across market structures, you must manually re-run MODEL.m multiple times

**MODEL_Loop.m solution:**
- Automates this by looping over a grid of market structures
- Produces a complete **sensitivity table** showing how equilibrium depends on B and alpha_cash
- This table is essential for Step C polynomial fitting (you need many data points to fit a good polynomial surface)

---

## Typical Workflow

1. **Run MODEL_Loop.m**
   ```matlab
   MODEL_Loop
   % ~1–4 hours later...
   % Produces: tab1, tab2, tab3, tab4 (and others) in workspace
   ```

2. **Save outputs**
   ```matlab
   save('MODEL_Loop_output.mat', 'tab1', 'tab2', 'tab3', 'tab4', ...);
   ```

3. **Feed into Step C**
   ```matlab
   % Step C loads tab1 and tab3
   % Fits polynomials
   % Uses polynomials to invert the model given empirical data
   Poly_Estimation_and_Solving
   ```

---

## Key Takeaway

**MODEL_Loop produces the "lookup table" of model equilibria that Step C uses to invert the model against real-world data.**

- Input: Structural assumptions (beta=75, gamma=1.221, reserve req=10%, etc.)
- Process: Simulate 120 market structures, record equilibrium outcomes
- Output: Lookup table (tab1, tab3) showing how outcomes vary with market structure
- Use: Fit polynomial surfaces and solve for structural parameters that match observed data

---

*
