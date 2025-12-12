%% Complete export: Variables AND Figures

% Set export parameters
exportMainFolder = 'New_simulation_results';
timestamp = datestr(now, 'yyyymmdd_HHMMSS');
exportFolder = fullfile(exportMainFolder, ['Run_5_cash_like_nest1_alphacash3_alphaCBDC3_B15' timestamp]);

% Create folders
if ~exist(exportFolder, 'dir')
    mkdir(exportFolder);
end
excelFolder = fullfile(exportFolder, 'excel_data');
figFolder = fullfile(exportFolder, 'figures');
mkdir(excelFolder);
mkdir(figFolder);

%% Export Variables
fprintf('Exporting variables to Excel...\n');

% Export BS (Balance Sheet) structure - Non-Banks
writematrix(BS.NB.M, fullfile(excelFolder, 'BS_NB_M_BalanceSheet_NonBank_MoneyHoldings.xlsx'));
writematrix(BS.NB.L, fullfile(excelFolder, 'BS_NB_L_BalanceSheet_NonBank_Loans.xlsx'));

% Export BS (Balance Sheet) structure - Banks
writematrix(BS.BA.R, fullfile(excelFolder, 'BS_BA_R_BalanceSheet_Bank_Reserves.xlsx'));
writematrix(BS.BA.L, fullfile(excelFolder, 'BS_BA_L_BalanceSheet_Bank_LoansGranted.xlsx'));
writematrix(BS.BA.D, fullfile(excelFolder, 'BS_BA_D_BalanceSheet_Bank_Deposits.xlsx'));
writematrix(BS.BA.B, fullfile(excelFolder, 'BS_BA_B_BalanceSheet_Bank_ReserveBorrowing.xlsx'));

% Export BS (Balance Sheet) structure - Central Bank
writematrix(BS.CB.B, fullfile(excelFolder, 'BS_CB_B_BalanceSheet_CentralBank_ReserveClaims.xlsx'));
writematrix(BS.CB.R, fullfile(excelFolder, 'BS_CB_R_BalanceSheet_CentralBank_ReserveDeposits.xlsx'));
writematrix(BS.CB.C, fullfile(excelFolder, 'BS_CB_C_BalanceSheet_CentralBank_Cash.xlsx'));
writematrix(BS.CB.DC, fullfile(excelFolder, 'BS_CB_DC_BalanceSheet_CentralBank_CBDC.xlsx'));

% Export FL (Flows) structure - Non-Banks
writematrix(FL.NB.incD, fullfile(excelFolder, 'FL_NB_incD_Flows_NonBank_DepositInterestIncome.xlsx'));
writematrix(FL.NB.incDC, fullfile(excelFolder, 'FL_NB_incDC_Flows_NonBank_CBDCInterestIncome.xlsx'));
writematrix(FL.NB.incS, fullfile(excelFolder, 'FL_NB_incS_Flows_NonBank_SeigniorageIncome.xlsx'));
writematrix(FL.NB.incC, fullfile(excelFolder, 'FL_NB_incC_Flows_NonBank_ConsumptionIncome.xlsx'));
writematrix(FL.NB.expC, fullfile(excelFolder, 'FL_NB_expC_Flows_NonBank_ConsumptionExpense.xlsx'));
writematrix(FL.NB.expL, fullfile(excelFolder, 'FL_NB_expL_Flows_NonBank_LoanInterestExpense.xlsx'));
writematrix(FL.NB.incDIV, fullfile(excelFolder, 'FL_NB_incDIV_Flows_NonBank_DividendIncome.xlsx'));

% Export FL (Flows) structure - Banks
writematrix(FL.BA.incR, fullfile(excelFolder, 'FL_BA_incR_Flows_Bank_ReserveInterestIncome.xlsx'));
writematrix(FL.BA.incL, fullfile(excelFolder, 'FL_BA_incL_Flows_Bank_LoanInterestIncome.xlsx'));
writematrix(FL.BA.expR, fullfile(excelFolder, 'FL_BA_expR_Flows_Bank_ReserveBorrowingExpense.xlsx'));
writematrix(FL.BA.expD, fullfile(excelFolder, 'FL_BA_expD_Flows_Bank_DepositInterestExpense.xlsx'));
writematrix(FL.BA.ni, fullfile(excelFolder, 'FL_BA_ni_Flows_Bank_NetIncome.xlsx'));
writematrix(FL.BA.div, fullfile(excelFolder, 'FL_BA_div_Flows_Bank_DividendPayouts.xlsx'));

% Export FL (Flows) structure - Central Bank
writematrix(FL.CB.incR, fullfile(excelFolder, 'FL_CB_incR_Flows_CentralBank_ReserveInterestIncome.xlsx'));
writematrix(FL.CB.expR, fullfile(excelFolder, 'FL_CB_expR_Flows_CentralBank_ReserveInterestExpense.xlsx'));
writematrix(FL.CB.expDC, fullfile(excelFolder, 'FL_CB_expDC_Flows_CentralBank_CBDCInterestExpense.xlsx'));
writematrix(FL.CB.seign, fullfile(excelFolder, 'FL_CB_seign_Flows_CentralBank_SeigniorageDistribution.xlsx'));

% Export key variables - Rates
writematrix(rates, fullfile(excelFolder, 'rates_DepositRatesAllBanks.xlsx'));
writematrix(ratesL, fullfile(excelFolder, 'ratesL_LoanInterestRatesByBank.xlsx'));
writematrix(ratesL_S, fullfile(excelFolder, 'ratesL_S_LoanInterestRateSystemAggregate.xlsx'));
writematrix(avrate, fullfile(excelFolder, 'avrate_AverageDepositRate.xlsx'));

% Export key variables - Volumes
writematrix(vol1, fullfile(excelFolder, 'vol1_VolumeBeforeSpending.xlsx'));
writematrix(vol2, fullfile(excelFolder, 'vol2_VolumeAfterSpending.xlsx'));

% Export key variables - Gamma (Velocity)
writematrix(effgamma, fullfile(excelFolder, 'effgamma_EffectiveVelocityByAgent.xlsx'));
writematrix(effgamma_S, fullfile(excelFolder, 'effgamma_S_EffectiveVelocitySystemAggregate.xlsx'));
writematrix(efficbdc, fullfile(excelFolder, 'efficbdc_EffectiveCBDCInterestRate.xlsx'));

% Export key variables - Agent Assignments
writematrix(NatB_D, fullfile(excelFolder, 'NatB_D_NonBankDepositBankAssignment.xlsx'));
writematrix(NatB_L, fullfile(excelFolder, 'NatB_L_NonBankLoanBankAssignment.xlsx'));
writematrix(NperB_D, fullfile(excelFolder, 'NperB_D_NumberOfNonBanksPerBankForDeposits.xlsx'));
writematrix(NperB_L, fullfile(excelFolder, 'NperB_L_NumberOfNonBanksPerBankForLoans.xlsx'));

% Export tracking variables - Reserve Flows
writematrix(trackRin(:,:,1), fullfile(excelFolder, 'trackRin_1_ReserveInflowsDepositMoves.xlsx'));
writematrix(trackRin(:,:,2), fullfile(excelFolder, 'trackRin_2_ReserveInflowsSpending.xlsx'));
writematrix(trackRout(:,:,1), fullfile(excelFolder, 'trackRout_1_ReserveOutflowsDepositMoves.xlsx'));
writematrix(trackRout(:,:,2), fullfile(excelFolder, 'trackRout_2_ReserveOutflowsSpending.xlsx'));

% Export tracking variables - Period Averages
writematrix(trackPAV_R, fullfile(excelFolder, 'trackPAV_R_PeriodAverageReserveHoldings.xlsx'));
writematrix(trackPAV_B, fullfile(excelFolder, 'trackPAV_B_PeriodAverageReserveBorrowings.xlsx'));

% Export tracking variables - Central Bank Cases
writematrix(cCBcases1, fullfile(excelFolder, 'cCBcases1_CBReservePositionBeforeSpending.xlsx'));
writematrix(cCBcases2, fullfile(excelFolder, 'cCBcases2_CBReservePositionAfterSpending.xlsx'));

% Export other tracking variables
writematrix(expl, fullfile(excelFolder, 'expl_ExplorerBankTracker.xlsx'));
writematrix(c_expLmiss, fullfile(excelFolder, 'c_expLmiss_CountNonBanksUnableToPayLoanInterest.xlsx'));
writematrix(MbeforeIL, fullfile(excelFolder, 'MbeforeIL_MoneyHoldingsBeforeLoanInterest.xlsx'));
writematrix(ILdue, fullfile(excelFolder, 'ILdue_LoanInterestDue.xlsx'));

% Export equilibrium values
writematrix(eqi, fullfile(excelFolder, 'eqi_AnalyticalDepositRateEquilibria.xlsx'));
writematrix(eqms, fullfile(excelFolder, 'eqms_AnalyticalCashCBDCShareEquilibria.xlsx'));

% Export parameter arrays
writematrix(alphas_, fullfile(excelFolder, 'alphas_BaseUtilityParametersAllWindows.xlsx'));
writematrix(beta_, fullfile(excelFolder, 'beta_PriceSensitivityParametersAllWindows.xlsx'));
writematrix(gamma_, fullfile(excelFolder, 'gamma_VelocityOfMoneyAllWindows.xlsx'));
writematrix(delta_, fullfile(excelFolder, 'delta_DepositLoanTransferProbabilityAllWindows.xlsx'));
writematrix(lambda_, fullfile(excelFolder, 'lambda_RequiredReserveRatioAllWindows.xlsx'));
writematrix(rDC_, fullfile(excelFolder, 'rDC_CBDCRemunerationRateAllWindows.xlsx'));
writematrix(G_, fullfile(excelFolder, 'G_InterestRateGridLengthAllWindows.xlsx'));
writematrix(nest_, fullfile(excelFolder, 'nest_NestedLogitIndicatorAllWindows.xlsx'));
writematrix(CFBs, fullfile(excelFolder, 'CFBs_CounterfactualBreakPoints.xlsx'));

% Export learning matrices
writematrix(mA, fullfile(excelFolder, 'mA_LearningMatrixBetaParameterA.xlsx'));
writematrix(mB, fullfile(excelFolder, 'mB_LearningMatrixBetaParameterB.xlsx'));
writematrix(iG, fullfile(excelFolder, 'iG_InterestRateGrid.xlsx'));

fprintf('Variables exported to Excel format.\n');

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
fprintf('- Excel data: %s\n', excelFolder);
fprintf('- Figures: %s\n', figFolder);

% Save workspace as well
save(fullfile(exportFolder, 'workspace.mat'));
fprintf('- Workspace: %s\n', fullfile(exportFolder, 'workspace.mat'));

%% Create README file with variable descriptions
readmeFile = fullfile(excelFolder, 'README_VariableDescriptions.txt');
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
fprintf(fid, 'NOTE: All data files are in Excel (.xlsx) format\n');
fprintf(fid, 'For more details, see the main MATLAB code.\n');
fprintf(fid, '============================================\n');
fclose(fid);

fprintf('README file created: %s\n', readmeFile);