# MODEL_Counterfactual_deposit.m - Documentation

## Overview
This MATLAB script simulates a complex economic model focused on **counterfactual scenarios for a deposit/cash-like Central Bank Digital Currency (CBDC)**. It models interactions between non-bank agents, commercial banks, and a central bank in a dynamic monetary system with deposits, cash, and CBDC.

---

## Purpose
The model simulates how monetary systems evolve when CBDC is introduced as a deposit/cash-like instrument. It:
- Tracks agent behavior in choosing between deposits, cash, and CBDC
- Simulates bank deposit rate competition through a "trading system" (TS) learning mechanism
- Analyzes counterfactual scenarios at specified break points with different policy parameters
- Generates comprehensive balance sheets and flow tracking for all entities
- Produces analytical results and visualizations

---

## Key Parameters

### Simulation Configuration
| Parameter | Value | Description |
|-----------|-------|-------------|
| `N` | 1500 | Number of non-bank agents |
| `B` | 15 | Number of commercial banks |
| `T` | 6000 | Number of periods to simulate |
| `namerun` | 'Run_5_deposit_like_nest0_...' | Unique identifier for this simulation run |
| `storefolder` | Path to storage | Destination folder for saving results |

### Counterfactual Scenario Parameters (vary by window)
| Parameter | Type | Description |
|-----------|------|-------------|
| `CFBs` | Vector | Periods where counterfactual breaks occur (6 break points) |
| `nest_` | 0/1 | Nested (1) or non-nested (0) conditional logit model for money choice |
| `alphas_` | Nx2 matrix | Base utilities for cash (col 1) and CBDC (col 2) per window |
| `beta_` | Vector | Non-banks' price sensitivity to deposit rates |
| `gamma_` | Vector | Annual velocity of money (spending rate) |
| `delta_` | Vector | Probability that deposit account move triggers loan transfer |
| `lambda_` | Vector | Required reserve ratio (% of deposits) |
| `rDC_` | Vector | Interest rate on CBDC (annual, p.a.) |

### Fixed Parameters
| Parameter | Value | Description |
|-----------|-------|-------------|
| `rB` | 0.056 | Banks' reserve borrowing rate (p.a.) |
| `rH` | [0.0, 0.0335] | Remuneration rates for required and excess reserves (p.a.) |
| `capcon` | 1 | Whether non-banks cap spending (1=YES, 0=NO) |
| `qu` | 1 | Scale model to quarterly (1=YES, 0=NO) |
| `M` | 38,000 | Total money supply (in specified currency unit) |
| `unit` | 'INR bn' | Currency and unit denomination |
| `savefigs` | 0 | Whether to save plots (1=YES, 0=NO) |

---

## Data Structure

### Key Variables

#### Simulation Tracking Arrays
| Variable | Dimensions | Description |
|----------|-----------|-------------|
| `rates` | T × (B+2) | Deposit rates (cols 1:B), cash rate (col B+1), CBDC rate (col B+2) |
| `ratesL` | T × B | Loan interest rates for each bank |
| `ratesL_S` | T × 1 | System-level weighted loan rate |
| `NatB_L` | T × N | Which bank each non-bank borrows from |
| `NatB_D` | T × N | Which bank/cash/CBDC each non-bank has deposits in |
| `NperB_L` | T × B | Count of non-banks borrowing from each bank |
| `NperB_D` | T × (B+2) | Count of non-banks at each deposit location |
| `vol1`, `vol2` | T × (B+2) | Deposit volumes before and after spending |
| `expl` | T × 1 | Explorer bank in each period (trading system mechanism) |
| `avrate` | T × 1 | Volume-weighted average deposit rate |
| `effgamma`, `effgamma_S` | T × N / T × 1 | Effective spending rates (actual vs. intended) |

#### Balance Sheet Arrays (BS structure)
```matlab
BS.NB.M  (T+1 × N)      % Non-banks' money holdings
BS.NB.L  (T+1 × N)      % Non-banks' loans from banks
BS.BA.R  (T+1 × B)      % Banks' reserve holdings
BS.BA.L  (T+1 × B)      % Banks' loans to non-banks
BS.BA.D  (T+1 × B)      % Banks' non-bank deposits
BS.BA.B  (T+1 × B)      % Banks' reserve borrowing from CB
BS.CB.B  (T+1 × 1)      % Central bank's reserve claims
BS.CB.R  (T+1 × 1)      % Central bank's reserve liabilities
BS.CB.C  (T+1 × 1)      % Central bank's cash liabilities
BS.CB.DC (T+1 × 1)      % Central bank's CBDC liabilities
```

#### Flow Arrays (FL structure - Interest flows, spending, income)
```matlab
FL.NB.*  % Non-bank income/expense flows:
    .incD     - Deposit interest income
    .incDC    - CBDC interest income
    .incS     - Seigniorage income
    .incC     - Income from spending by others
    .expC     - Spending expenses
    .expL     - Loan interest expenses
    .incDIV   - Dividend income

FL.BA.*  % Bank flows:
    .incR     - Reserve interest income
    .incL     - Loan interest income
    .expR     - Reserve borrowing expense
    .expD     - Deposit interest expense
    .ni       - Net income (before dividends)
    .div      - Dividend payouts

FL.CB.*  % Central bank flows:
    .incR     - Reserve lending income
    .expR     - Reserve remuneration expense
    .expDC    - CBDC interest expense
    .seign    - Seigniorage distribution
```

---

## Simulation Workflow

### Initialization Phase
1. **Setup**: Clear workspace, initialize tracking arrays for T periods
2. **Non-bank assignment** (`distrib.m`): Distribute N non-banks across B banks for loans/deposits
3. **Rate conversion**: Convert annual rates to quarterly if `qu==1`
4. **Initial balance sheets**: Set up T=0 balance sheets with initial loans and reserves

### Main Simulation Loop (t = 1 to T)

#### Step 0: Carryover Balance Sheets
Execute `carryover.m` to advance balance sheet positions from t to t+1

#### Step 1: Banks Set Deposit Rates
- **Period 1**: Set rates at analytical equilibrium
- **Period 2-3**: Hold previous rates (TS initialization)
- **After counterfactual breaks**: Reset to mid-grid rate
- **Other periods**: Apply trading system (TS) learning mechanism
  - Explorer bank randomly selected: `bb = randi([1 B])`
  - Beta distribution learning on interest rate grid
  - Step up/down on grid based on success/failure

#### Step 2: Non-bank Choices
Execute `sim_data_CL_nested.m` for discrete choice:
- **Deposit choice**: Choose among B banks, cash (B+1), or CBDC (B+2)
- **Loan choice**: Either stay with current bank (`delta` probability) or match deposit bank

#### Step 3: Deposit/Loan Transfers
- Track reserve flows: `trackRin` and `trackRout` for flows in/out of each entity
- Update balance sheets for deposit migrations
- Transfer loans when agents switch banks (loan refinancing)
- Account for cash/CBDC conversions

#### Step 4: Net CB Reserve Position (before spending)
Execute `net_CBD.m` to assess:
- Banks' reserve positions relative to requirements
- Track 4 cases of CB reserve situations (`cCBcases1`)

#### Step 5: Non-Bank Spending
- Calculate maximum spending (`cmax`): Cap based on loan interest capacity if `capcon==1`
- Effective spending: `effgamma = FL.NB.expC / BS.NB.M`
- Random partner selection: `Ntar = e(...)`
- Update balance sheets for spending flows
- Track spending-related reserve flows

#### Step 6: Net CB Reserve Position (after spending)
Execute `net_CBD.m` again, track 4 cases (`cCBcases2`)

#### Step 7: Interest Flows and Dividends
Execute `interest_flows.m` to:
- Calculate interest income/expense for all entities
- Determine bank net income
- Distribute seigniorage and dividends

#### Step 8: Trading System Learning
Update beta distribution parameters based on explorer's performance:
- **Success** (profit > previous reference): Increase successful direction parameter, reset TS
- **Failure** (profit ≤ reference): Increase alternative direction parameter, continue TS

### Post-Simulation

#### Rate Conversion
Convert rates back to annual basis if `qu==1` (multiply by 4)

#### Visualization
Execute `counterfactual_plots.m` to generate results visualization

#### Save Results
If `store_once_done==1`, save all workspace variables to `.mat` file

---

## Counterfactual Breaks (CFBs)

The model supports multiple counterfactual windows with different parameter values:
- **CFBs = [1, 1000, 2000, 3000, 4000, 5000]**: 6 scenario windows
- At each break point, agent memory of rate history is erased
- New equilibrium is computed using `nash_analytical_heterog_partialexog_nested.m`
- Allows studying policy scenarios progressively

### Example Scenario Windows
| Window | Break | Description |
|--------|-------|-------------|
| 1 | Period 1 | Baseline scenario (CBDC alpha = -100, no remuneration) |
| 2 | Period 1000 | CBDC with modified parameters (alpha = 0) |
| 3-6 | Periods 2000-5000 | Additional policy scenarios |

---

## Key Mechanisms

### 1. Trading System (TS) Learning
Banks learn optimal deposit rates through:
- **Exploration**: One randomly selected explorer bank varies its rate
- **Learning**: Beta distribution parameters track successful directions
- **Exploitation**: Non-explorers copy successful explorer's rate

Parameters:
- Grid length: `G` (7 points from 0 to `rB`)
- Learning matrix: `mA`, `mB` (beta distribution parameters)

### 2. Agent Choice Model
Non-banks choose deposit locations using nested logit:
- **Alternatives**: B banks + cash (B+1) + CBDC (B+2)
- **Nesting**: Can be nested (mu=100) or non-nested (mu=1)
- **Utility**: `U = alpha + beta*rate + log(share_residual)`

### 3. Money Circulation
- Non-banks spend `gamma` fraction of money holdings each period
- Recipients are random (excluding self)
- Spending between banks creates cross-bank flows

### 4. Loan Market
- Deposit account ties determine borrowing relationship (with probability `delta`)
- Loan transfers between banks involve reserve flows
- Interest rate determined by loan supply/demand

---

## Key Outputs

### Generated Variables
- `rates`: Time series of all deposit and CBDC interest rates
- `ratesL_S`: System loan rate over time
- `NperB_D`, `NperB_L`: Agent distribution across banks
- `BS.*`: Complete balance sheet history
- `FL.*`: Complete flow history
- `eqi`: Analytical equilibrium deposit rates per window
- `eqms`: Analytical cash/CBDC share equilibria

### Saved Results
When `store_once_done==1`:
- File: `[storefolder]\[namerun].mat`
- Contains: All workspace variables for post-simulation analysis

---

## External Dependencies

The script calls the following functions (must be in path):
| Function | Purpose |
|----------|---------|
| `distrib.m` | Distribute agents across banks |
| `carryover.m` | Advance balance sheet states |
| `sim_data_CL_nested.m` | Simulate agent choice (discrete choice logit) |
| `net_CBD.m` | Assess central bank reserve positions |
| `interest_flows.m` | Calculate and distribute flows |
| `nash_analytical_heterog_partialexog_nested.m` | Compute equilibrium rates |
| `counterfactual_plots.m` | Generate visualization |
| `progressline.m` | Display progress indicator |

---

## Mathematical Notes

### Utility Function (Agent Choice)
$$U_{ij} = \alpha_j + \beta \cdot r_j + \epsilon_{ij}$$

Where:
- $i$ = agent, $j$ = alternative (bank or cash/CBDC)
- $\alpha_j$ = base utility parameter
- $\beta$ = price sensitivity
- $r_j$ = deposit rate
- $\epsilon_{ij}$ = logit error term

### Effective Gamma
$$\text{effgamma}_{it} = \frac{\text{Spending}_{it}}{M_{it}}$$

Measures actual spending rate vs. target gamma (affects liquidity constraints)

### Required Reserves
$$R^{req}_b = \lambda \cdot D_b$$

Where:
- $\lambda$ = reserve requirement ratio
- $D_b$ = deposits at bank $b$

---

## Notes on Version

**Current Configuration**: Deposit/cash-like CBDC (Run_5)
- Single stream of counterfactual windows
- Annex version with superimposed dual streams available from authors
- Quarterly scaling enabled (`qu=1`)
- Spending cap enabled (`capcon=1`)
- Results saved to specified folder

---

## Suggested Extensions

1. Adjust counterfactual parameters to study policy scenarios
2. Vary agent population (N) and bank count (B) for robustness
3. Modify trading system learning parameters
4. Analyze comparative statics across scenarios
5. Extract and analyze specific flow channels (e.g., seigniorage)

---

## Citation Notes
This model appears designed for academic research on CBDC impact, likely related to IMF working papers (folder reference: "wp239")
