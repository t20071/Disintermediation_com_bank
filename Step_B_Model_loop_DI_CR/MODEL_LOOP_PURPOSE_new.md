**Model Loop Purpose**

- **File:** `Step_B_Model_loop_DI_CR/MODEL_Loop.m`
- **This doc:** `MODEL_LOOP_PURPOSE.md` (root workspace)

**Purpose:**
- **Summary:**: Runs the monetary-agent-based model (loop version) across a grid of bank counts and cash base-utility values, collects equilibrium statistics (deposit rates, cash share, CBDC share, reserve holdings, lending rates, convergence diagnostics) and saves the results to a `.mat` file for later estimation/analysis.

**Where it lives:**
- **Script path:**: `Step_B_Model_loop_DI_CR/MODEL_Loop.m`

**Quick run / Example:**
- **In MATLAB (recommended):**
  - Open MATLAB and change folder to the script directory:

    `cd('C:\Users\HP\Desktop\only_code\Step_B_Model_loop_DI_CR')`
    `MODEL_Loop`

- **From PowerShell (MATLAB must be on PATH):**
  - Run as a batch job:

    `matlab -batch "cd('C:\Users\HP\Desktop\only_code\Step_B_Model_loop_DI_CR'); MODEL_Loop"`

**Main behavior & outputs:**
- **Grid:**: Iterates over `BB` (vector of bank counts) and `alpha_cash` (vector of cash base utilities).
- **Sim:**: For each grid point the script simulates `T` periods for `N` non-bank agents, computes statistics over the last `S` periods, and stores results in `tab1..tab12` variables.
- **Saved file:**: At the end (if `store_once_done==1`) the workspace is saved to `\<storefolder>\<namerun>.mat`.

**Important saved output variables:**
- **`tab1`**: Nash deposit rate (median over final sample)
- **`tab2`**: Analytical counterpart of deposit rate
- **`tab3`**: Cash / M (median cash share)
- **`tab4`**: Analytical cash share
- **`tab5`**: CBDC / M (CBDC share)
- **`tab6`**: Mean end-of-period reserve holdings
- **`tab7`**: Effective system lending rate (median)
- **`tab9`**: Median number of non-banks paying less than full loan interest
- **`tab10`**: G* (grid length chosen) per run
- **`tab11`**: Convergence flag for G* (1 if achieved)
- **`tab12`**: Number of periods in G* position (if `tab11==1`)

**Key parameters (defaults in script):**
- **`N`**: number of non-bank agents (default `1000`)
- **`T`**: simulation periods (default `3000`)
- **`S`**: final window for statistics (default `750`)
- **`BB`**: bank-count vector (e.g. `[1 2 3 4 5 7 10 ...]`)
- **`alpha_cash`**: cash base-utility grid (e.g. `[-10 -5 0 1 2 3 4 5 7.5 10]`)
- **`alpha_cbdc`**: base utility for CBDC (default `-100`)
- **`beta`**: non-banks' price sensitivity (default `75`)
- **`rB, rH, rDC`**: rates (annual by default; script converts to quarterly when `qu==1`)
- **`lambda`**: reserve requirement fraction (default `0.03`)
- **`M`**: total money stock (unit-agnostic)
- **`dynG`**: whether to search for G dynamically (default `1`)
- **`qu`**: scale to quarterly (`1`) or keep annual (`0`)

**Files and functions this script depends on (must be on MATLAB path):**
- **Local helper scripts used inside loop:** `carryover.m`, `net_CBD.m`, `interest_flows.m`, `assess_IQR.m`, `distrib.m`
- **Simulation/choice helpers:** `sim_data_CL_nested.m` (called to simulate non-bank choices)
- **Analytical functions:** `nash_analytical_heterog_partialexog_nested.m`
- **Other files commonly used in the repo:** `Step_A_Beta_estimation/*`, visualization scripts in `Visualization_of_output/` (for plotting results after running)

**What the script does (step-by-step):**
- **Initialisation:**: sets parameters, grids `BB` and `alpha_cash`, prepares result matrices `tab1..tab12`.
- **For each grid point:**: sets initial balance sheets and assignments (via `distrib`), loops `t=1..T` doing:
  - carryover previous balances (`carryover`)
  - banks set deposit rates (includes Thompson Sampling / learning mechanism)
  - non-banks choose where to deposit/hold cash and loan refinancings (`sim_data_CL_nested`)
  - deposit account moves and loan transfers update bank/CB balance sheets
  - non-bank consumption flows update money distributions
  - compute net CB reserve positions (`net_CBD`)
  - compute interest flows and dividends (`interest_flows`)
  - adjust learning/gridding (`assess_IQR`) and possibly update `G`
- **Post-sim:**: compute analytical counterparts (when B>1), rescale rates back to annual if needed, compute summary statistics stored in `tab*` arrays.

**Notes & tips:**
- **Store path:**: change `storefolder` and `namerun` at the top of the script to control saved location/name.
- **MATLAB path:**: ensure the workspace folder and its subfolders are added to MATLAB path (use `addpath` or set Current Folder) before running.
- **Experimentation:**: to speed up testing, reduce `N`, `T`, and the lengths of `BB` / `alpha_cash` vectors.
- **Reproducibility:**: the script uses random draws (e.g., TS, consumption partners). To reproduce results add a fixed `rng(seed)` near the top.

**Where results are used next:**
- The `.mat` output is intended for the project's estimation/analysis steps (e.g., Step A and Step C scripts and plotting in `Visualization_of_output/`).

**Contact / authorship:**
- **Repo:** local workspace `c:\Users\HP\Desktop\only_code`
- **Created:** automated documentation generated from `MODEL_Loop.m`.
