%% Complete export: Variables AND Figures

% Set export parameters
exportMainFolder = 'simulation_results';
timestamp = datestr(now, 'dd_mm_yyyy_@_HH_MM_SS');
exportFolder = fullfile(exportMainFolder, ['Run_5_deposit_like_nest0_alphacash3_alphaCBDC0_B15_' timestamp]);

% Create folders
if ~exist(exportFolder, 'dir')
    mkdir(exportFolder);
end
csvFolder = fullfile(exportFolder, 'csv_data');
figFolder = fullfile(exportFolder, 'figures');
mkdir(csvFolder);
mkdir(figFolder);

%% Export Variables
fprintf('Exporting variables...\n');

% Export BS (Balance Sheet) structure - Non-Banks
writematrix(BS.NB.M, fullfile(csvFolder, 'BS_NB_M_BalanceSheet_NonBank_MoneyHoldings.csv'));
writematrix(BS.NB.L, fullfile(csvFolder, 'BS_NB_L_BalanceSheet_NonBank_Loans.csv'));

% Export BS (Balance Sheet) structure - Banks
writematrix(BS.BA.R, fullfile(csvFolder, 'BS_BA_R_BalanceSheet_Bank_Reserves.csv'));
writematrix(BS.BA.L, fullfile(csvFolder, 'BS_BA_L_BalanceSheet_Bank_LoansGranted.csv'));
writematrix(BS.BA.D, fullfile(csvFolder, 'BS_BA_D_BalanceSheet_Bank_Deposits.csv'));
writematrix(BS.BA.B, fullfile(csvFolder, 'BS_BA_B_BalanceSheet_Bank_ReserveBorrowing.csv'));

% Export BS (Balance Sheet) structure - Central Bank
writematrix(BS.CB.B, fullfile(csvFolder, 'BS_CB_B_BalanceSheet_CentralBank_ReserveClaims.csv'));
writematrix(BS.CB.R, fullfile(csvFolder, 'BS_CB_R_BalanceSheet_CentralBank_ReserveDeposits.csv'));
writematrix(BS.CB.C, fullfile(csvFolder, 'BS_CB_C_BalanceSheet_CentralBank_Cash.csv'));
writematrix(BS.CB.DC, fullfile(csvFolder, 'BS_CB_DC_BalanceSheet_CentralBank_CBDC.csv'));

% Export FL (Flows) structure - Non-Banks
writematrix(FL.NB.incD, fullfile(csvFolder, 'FL_NB_incD_Flows_NonBank_DepositInterestIncome.csv'));
writematrix(FL.NB.incDC, fullfile(csvFolder, 'FL_NB_incDC_Flows_NonBank_CBDCInterestIncome.csv'));
writematrix(FL.NB.incS, fullfile(csvFolder, 'FL_NB_incS_Flows_NonBank_SeigniorageIncome.csv'));
writematrix(FL.NB.incC, fullfile(csvFolder, 'FL_NB_incC_Flows_NonBank_ConsumptionIncome.csv'));
writematrix(FL.NB.expC, fullfile(csvFolder, 'FL_NB_expC_Flows_NonBank_ConsumptionExpense.csv'));
writematrix(FL.NB.expL, fullfile(csvFolder, 'FL_NB_expL_Flows_NonBank_LoanInterestExpense.csv'));
writematrix(FL.NB.incDIV, fullfile(csvFolder, 'FL_NB_incDIV_Flows_NonBank_DividendIncome.csv'));

% Export FL (Flows) structure - Banks
writematrix(FL.BA.incR, fullfile(csvFolder, 'FL_BA_incR_Flows_Bank_ReserveInterestIncome.csv'));
writematrix(FL.BA.incL, fullfile(csvFolder, 'FL_BA_incL_Flows_Bank_LoanInterestIncome.csv'));
writematrix(FL.BA.expR, fullfile(csvFolder, 'FL_BA_expR_Flows_Bank_ReserveBorrowingExpense.csv'));
writematrix(FL.BA.expD, fullfile(csvFolder, 'FL_BA_expD_Flows_Bank_DepositInterestExpense.csv'));
writematrix(FL.BA.ni, fullfile(csvFolder, 'FL_BA_ni_Flows_Bank_NetIncome.csv'));
writematrix(FL.BA.div, fullfile(csvFolder, 'FL_BA_div_Flows_Bank_DividendPayouts.csv'));

% Export FL (Flows) structure - Central Bank
writematrix(FL.CB.incR, fullfile(csvFolder, 'FL_CB_incR_Flows_CentralBank_ReserveInterestIncome.csv'));
writematrix(FL.CB.expR, fullfile(csvFolder, 'FL_CB_expR_Flows_CentralBank_ReserveInterestExpense.csv'));
writematrix(FL.CB.expDC, fullfile(csvFolder, 'FL_CB_expDC_Flows_CentralBank_CBDCInterestExpense.csv'));
writematrix(FL.CB.seign, fullfile(csvFolder, 'FL_CB_seign_Flows_CentralBank_SeigniorageDistribution.csv'));

% Export key variables - Rates
writematrix(rates, fullfile(csvFolder, 'rates_DepositRatesAllBanks.csv'));
writematrix(ratesL, fullfile(csvFolder, 'ratesL_LoanInterestRatesByBank.csv'));
writematrix(ratesL_S, fullfile(csvFolder, 'ratesL_S_LoanInterestRateSystemAggregate.csv'));
writematrix(avrate, fullfile(csvFolder, 'avrate_AverageDepositRate.csv'));

% Export key variables - Volumes
writematrix(vol1, fullfile(csvFolder, 'vol1_VolumeBeforeSpending.csv'));
writematrix(vol2, fullfile(csvFolder, 'vol2_VolumeAfterSpending.csv'));

% Export key variables - Gamma (Velocity)
writematrix(effgamma, fullfile(csvFolder, 'effgamma_EffectiveVelocityByAgent.csv'));
writematrix(effgamma_S, fullfile(csvFolder, 'effgamma_S_EffectiveVelocitySystemAggregate.csv'));
writematrix(efficbdc, fullfile(csvFolder, 'efficbdc_EffectiveCBDCInterestRate.csv'));

% Export key variables - Agent Assignments
writematrix(NatB_D, fullfile(csvFolder, 'NatB_D_NonBankDepositBankAssignment.csv'));
writematrix(NatB_L, fullfile(csvFolder, 'NatB_L_NonBankLoanBankAssignment.csv'));
writematrix(NperB_D, fullfile(csvFolder, 'NperB_D_NumberOfNonBanksPerBankForDeposits.csv'));
writematrix(NperB_L, fullfile(csvFolder, 'NperB_L_NumberOfNonBanksPerBankForLoans.csv'));

% Export tracking variables - Reserve Flows
writematrix(trackRin(:,:,1), fullfile(csvFolder, 'trackRin_1_ReserveInflowsDepositMoves.csv'));
writematrix(trackRin(:,:,2), fullfile(csvFolder, 'trackRin_2_ReserveInflowsSpending.csv'));
writematrix(trackRout(:,:,1), fullfile(csvFolder, 'trackRout_1_ReserveOutflowsDepositMoves.csv'));
writematrix(trackRout(:,:,2), fullfile(csvFolder, 'trackRout_2_ReserveOutflowsSpending.csv'));

% Export tracking variables - Period Averages
writematrix(trackPAV_R, fullfile(csvFolder, 'trackPAV_R_PeriodAverageReserveHoldings.csv'));
writematrix(trackPAV_B, fullfile(csvFolder, 'trackPAV_B_PeriodAverageReserveBorrowings.csv'));

% Export tracking variables - Central Bank Cases
writematrix(cCBcases1, fullfile(csvFolder, 'cCBcases1_CBReservePositionBeforeSpending.csv'));
writematrix(cCBcases2, fullfile(csvFolder, 'cCBcases2_CBReservePositionAfterSpending.csv'));

% Export other tracking variables
writematrix(expl, fullfile(csvFolder, 'expl_ExplorerBankTracker.csv'));
writematrix(c_expLmiss, fullfile(csvFolder, 'c_expLmiss_CountNonBanksUnableToPayLoanInterest.csv'));
writematrix(MbeforeIL, fullfile(csvFolder, 'MbeforeIL_MoneyHoldingsBeforeLoanInterest.csv'));
writematrix(ILdue, fullfile(csvFolder, 'ILdue_LoanInterestDue.csv'));

% Export equilibrium values
writematrix(eqi, fullfile(csvFolder, 'eqi_AnalyticalDepositRateEquilibria.csv'));
writematrix(eqms, fullfile(csvFolder, 'eqms_AnalyticalCashCBDCShareEquilibria.csv'));

% Export parameter arrays
writematrix(alphas_, fullfile(csvFolder, 'alphas_BaseUtilityParametersAllWindows.csv'));
writematrix(beta_, fullfile(csvFolder, 'beta_PriceSensitivityParametersAllWindows.csv'));
writematrix(gamma_, fullfile(csvFolder, 'gamma_VelocityOfMoneyAllWindows.csv'));
writematrix(delta_, fullfile(csvFolder, 'delta_DepositLoanTransferProbabilityAllWindows.csv'));
writematrix(lambda_, fullfile(csvFolder, 'lambda_RequiredReserveRatioAllWindows.csv'));
writematrix(rDC_, fullfile(csvFolder, 'rDC_CBDCRemunerationRateAllWindows.csv'));
writematrix(G_, fullfile(csvFolder, 'G_InterestRateGridLengthAllWindows.csv'));
writematrix(nest_, fullfile(csvFolder, 'nest_NestedLogitIndicatorAllWindows.csv'));
writematrix(CFBs, fullfile(csvFolder, 'CFBs_CounterfactualBreakPoints.csv'));

% Export learning matrices
writematrix(mA, fullfile(csvFolder, 'mA_LearningMatrixBetaParameterA.csv'));
writematrix(mB, fullfile(csvFolder, 'mB_LearningMatrixBetaParameterB.csv'));
writematrix(iG, fullfile(csvFolder, 'iG_InterestRateGrid.csv'));

fprintf('Variables exported.\n');

%% Export Figures
fprintf('Exporting figures...\n');

figHandles = findall(0, 'Type', 'figure');

for i = 1:length(figHandles)
    fig = figHandles(i);
    
    if ~isempty(fig.Name)
        filename = fig.Name;
    else
        filename = sprintf('Figure_%02d', fig.Number);
    end
    filename = regexprep(filename, '[\\/:*?"<>|]', '_');
    
    % Export multiple formats
    print(fig, fullfile(figFolder, filename), '-dpng', '-r300');
    saveas(fig, fullfile(figFolder, [filename '.pdf']));
    savefig(fig, fullfile(figFolder, [filename '.fig']));
    
    fprintf('  Exported: %s\n', filename);
end

fprintf('\n=== EXPORT COMPLETE ===\n');
fprintf('Results saved to: %s\n', exportFolder);
fprintf('- CSV data: %s\n', csvFolder);
fprintf('- Figures: %s\n', figFolder);

% Save workspace as well
save(fullfile(exportFolder, 'workspace.mat'));
fprintf('- Workspace: %s\n', fullfile(exportFolder, 'workspace.mat'));

%% Create README file with variable descriptions
readmeFile = fullfile(csvFolder, 'README_VariableDescriptions.txt');
fid = fopen(readmeFile, 'w');
fprintf(fid, '============================================\n');
fprintf(fid, 'MONETARY ABM SIMULATION RESULTS\n');
fprintf(fid, 'Export Date: %s\n', datestr(now));
fprintf(fid, '============================================\n\n');

fprintf(fid, 'BALANCE SHEET VARIABLES (BS):\n');
fprintf(fid, '--------------------------------------------\n');
fprintf(fid, 'Non-Banks (NB):\n');
fprintf(fid, '  BS_NB_M = Money holdings (deposits + cash + CBDC)\n');
fprintf(fid, '  BS_NB_L = Loans (liabilities)\n\n');

fprintf(fid, 'Banks (BA):\n');
fprintf(fid, '  BS_BA_R = Reserve holdings (assets)\n');
fprintf(fid, '  BS_BA_L = Loans granted to non-banks (assets)\n');
fprintf(fid, '  BS_BA_D = Non-bank deposits (liabilities)\n');
fprintf(fid, '  BS_BA_B = Reserve borrowing from CB (liabilities)\n\n');

fprintf(fid, 'Central Bank (CB):\n');
fprintf(fid, '  BS_CB_B = Reserve claims vis-a-vis banks (assets)\n');
fprintf(fid, '  BS_CB_R = Bank reserve deposits (liabilities)\n');
fprintf(fid, '  BS_CB_C = Cash in circulation (liabilities)\n');
fprintf(fid, '  BS_CB_DC = CBDC in circulation (liabilities)\n\n');

fprintf(fid, 'FLOW VARIABLES (FL):\n');
fprintf(fid, '--------------------------------------------\n');
fprintf(fid, 'Non-Banks (NB):\n');
fprintf(fid, '  FL_NB_incD = Deposit interest income\n');
fprintf(fid, '  FL_NB_incDC = CBDC interest income\n');
fprintf(fid, '  FL_NB_incS = Seigniorage income from CB\n');
fprintf(fid, '  FL_NB_incC = Income from other non-banks spending\n');
fprintf(fid, '  FL_NB_expC = Consumption spending expense\n');
fprintf(fid, '  FL_NB_expL = Loan interest expense\n');
fprintf(fid, '  FL_NB_incDIV = Dividend income from banks\n\n');

fprintf(fid, 'Banks (BA):\n');
fprintf(fid, '  FL_BA_incR = Reserve interest income\n');
fprintf(fid, '  FL_BA_incL = Loan interest income\n');
fprintf(fid, '  FL_BA_expR = Reserve borrowing expense\n');
fprintf(fid, '  FL_BA_expD = Deposit interest expense\n');
fprintf(fid, '  FL_BA_ni = Net income before dividends\n');
fprintf(fid, '  FL_BA_div = Dividend payouts\n\n');

fprintf(fid, 'Central Bank (CB):\n');
fprintf(fid, '  FL_CB_incR = Interest income from reserve lending\n');
fprintf(fid, '  FL_CB_expR = Interest expense for reserve remuneration\n');
fprintf(fid, '  FL_CB_expDC = Interest expense for CBDC\n');
fprintf(fid, '  FL_CB_seign = Seigniorage distribution\n\n');

fprintf(fid, 'RATES AND PRICES:\n');
fprintf(fid, '--------------------------------------------\n');
fprintf(fid, '  rates = Deposit rates set by banks (includes cash and CBDC in last columns)\n');
fprintf(fid, '  ratesL = Loan interest rates by bank\n');
fprintf(fid, '  ratesL_S = System-wide weighted aggregate loan rate\n');
fprintf(fid, '  avrate = Volume-weighted average deposit rate\n');
fprintf(fid, '  efficbdc = Effective CBDC interest rate\n\n');

fprintf(fid, 'VOLUMES AND VELOCITY:\n');
fprintf(fid, '--------------------------------------------\n');
fprintf(fid, '  vol1 = Deposit/cash/CBDC volumes before spending\n');
fprintf(fid, '  vol2 = Deposit/cash/CBDC volumes after spending\n');
fprintf(fid, '  effgamma = Effective velocity of money by agent\n');
fprintf(fid, '  effgamma_S = System aggregate effective velocity\n\n');

fprintf(fid, 'AGENT ASSIGNMENTS:\n');
fprintf(fid, '--------------------------------------------\n');
fprintf(fid, '  NatB_D = Non-bank deposit bank assignments\n');
fprintf(fid, '  NatB_L = Non-bank loan bank assignments\n');
fprintf(fid, '  NperB_D = Number of non-banks per bank for deposits\n');
fprintf(fid, '  NperB_L = Number of non-banks per bank for loans\n\n');

fprintf(fid, 'TRACKING VARIABLES:\n');
fprintf(fid, '--------------------------------------------\n');
fprintf(fid, '  trackRin = Reserve inflows (deposit moves and spending)\n');
fprintf(fid, '  trackRout = Reserve outflows (deposit moves and spending)\n');
fprintf(fid, '  trackPAV_R = Period average reserve holdings\n');
fprintf(fid, '  trackPAV_B = Period average reserve borrowings\n');
fprintf(fid, '  cCBcases1/2 = CB reserve position cases (before/after spending)\n');
fprintf(fid, '  expl = Explorer bank tracker for learning\n\n');

fprintf(fid, 'EQUILIBRIUM AND PARAMETERS:\n');
fprintf(fid, '--------------------------------------------\n');
fprintf(fid, '  eqi = Analytical deposit rate equilibria\n');
fprintf(fid, '  eqms = Analytical cash and CBDC share equilibria\n');
fprintf(fid, '  CFBs = Counterfactual break points\n');
fprintf(fid, '  alphas_ = Base utility parameters for all windows\n');
fprintf(fid, '  beta_ = Price sensitivity parameters\n');
fprintf(fid, '  gamma_ = Velocity of money parameters\n');
fprintf(fid, '  delta_ = Deposit-loan transfer probability\n');
fprintf(fid, '  lambda_ = Required reserve ratios\n');
fprintf(fid, '  rDC_ = CBDC remuneration rates\n\n');

fprintf(fid, '============================================\n');
fprintf(fid, 'For more details, see the main MATLAB code.\n');
fprintf(fid, '============================================\n');
fclose(fid);

fprintf('README file created: %s\n', readmeFile);