%% Export all workspace variables to CSV files with descriptive names

% Create export folder
exportFolder = 'exported_workspace_csv';
if ~exist(exportFolder, 'dir')
    mkdir(exportFolder);
end

fprintf('Starting export of workspace variables...\n');

%% Export simple numeric/cell arrays
simpleVars = {'alphas', 'alphas_', 'avrate', 'b', 'bb', 'beta', 'beta_', 'B', ...
              'capcon', 'cCBcases1', 'cCBcases2', 'countsC', 'cut', 'CFBs', ...
              'd', 'delta', 'delta_', 'e', 'effgamma', 'effgamma_S', 'efficbdc', ...
              'eqi', 'eqms', 'expl', 'f', 'g', 'G', 'G_', 'gamma', 'gamma_', ...
              'iG', 'ILdue', 'lambda', 'lambda_', 'M', 'mA', 'mB', 'MbeforeIL', ...
              'mu', 'N', 'NatB_D', 'NatB_D_Last', 'NatB_L', 'nest', 'nest_', ...
              'NperB_D', 'NperB_L', 'Ntar', 'pB', 'prefix', 'ps', 'qu', ...
              'q', 'rates', 'ratesL', 'ratesL_S', 'rB', 'rDC', 'rDC_', ...
              'rH', 'rs', 'savefigs', 'T', 'trackPAV_B', 'trackPAV_R', ...
              'trackRin', 'trackRout', 'ts', 'u', 'u0', 'u1', 'u2', ...
              'unit', 'vol1', 'vol2', 'w', 'c_expLmiss'};

for i = 1:length(simpleVars)
    varName = simpleVars{i};
    if evalin('base', ['exist(''', varName, ''', ''var'')'])
        try
            varData = evalin('base', varName);
            if isnumeric(varData)
                writematrix(varData, fullfile(exportFolder, [varName '.csv']));
                fprintf('Exported: %s\n', varName);
            elseif iscell(varData)
                writecell(varData, fullfile(exportFolder, [varName '.csv']));
                fprintf('Exported: %s\n', varName);
            elseif ischar(varData) || isstring(varData)
                writematrix(varData, fullfile(exportFolder, [varName '.csv']));
                fprintf('Exported: %s\n', varName);
            end
        catch
            warning('Could not export: %s', varName);
        end
    end
end

%% Export BS (Balance Sheet) structure with descriptive names
if exist('BS', 'var')
    % BS.NB (Non-bank balance sheets)
    if isfield(BS, 'NB')
        writematrix(BS.NB.M, fullfile(exportFolder, 'BS_NB_M_BalanceSheet_NonBank_MoneyHoldings.csv'));
        writematrix(BS.NB.L, fullfile(exportFolder, 'BS_NB_L_BalanceSheet_NonBank_Loans.csv'));
        fprintf('Exported: BS.NB (M and L) with descriptive names\n');
    end
    
    % BS.BA (Bank balance sheets)
    if isfield(BS, 'BA')
        writematrix(BS.BA.R, fullfile(exportFolder, 'BS_BA_R_BalanceSheet_Bank_Reserves.csv'));
        writematrix(BS.BA.L, fullfile(exportFolder, 'BS_BA_L_BalanceSheet_Bank_LoansGranted.csv'));
        writematrix(BS.BA.D, fullfile(exportFolder, 'BS_BA_D_BalanceSheet_Bank_Deposits.csv'));
        writematrix(BS.BA.B, fullfile(exportFolder, 'BS_BA_B_BalanceSheet_Bank_ReserveBorrowing.csv'));
        fprintf('Exported: BS.BA (R, L, D, B) with descriptive names\n');
    end
    
    % BS.CB (Central Bank balance sheets)
    if isfield(BS, 'CB')
        writematrix(BS.CB.B, fullfile(exportFolder, 'BS_CB_B_BalanceSheet_CentralBank_ReserveClaims.csv'));
        writematrix(BS.CB.R, fullfile(exportFolder, 'BS_CB_R_BalanceSheet_CentralBank_ReserveDeposits.csv'));
        writematrix(BS.CB.C, fullfile(exportFolder, 'BS_CB_C_BalanceSheet_CentralBank_Cash.csv'));
        writematrix(BS.CB.DC, fullfile(exportFolder, 'BS_CB_DC_BalanceSheet_CentralBank_CBDC.csv'));
        fprintf('Exported: BS.CB (B, R, C, DC) with descriptive names\n');
    end
end

%% Export FL (Flows) structure with descriptive names
if exist('FL', 'var')
    % FL.NB (Non-bank flows)
    if isfield(FL, 'NB')
        writematrix(FL.NB.incD, fullfile(exportFolder, 'FL_NB_incD_Flow_NonBank_DepositInterestIncome.csv'));
        writematrix(FL.NB.incDC, fullfile(exportFolder, 'FL_NB_incDC_Flow_NonBank_CBDCInterestIncome.csv'));
        writematrix(FL.NB.incS, fullfile(exportFolder, 'FL_NB_incS_Flow_NonBank_SeigniorageIncome.csv'));
        writematrix(FL.NB.incC, fullfile(exportFolder, 'FL_NB_incC_Flow_NonBank_SpendingIncome.csv'));
        writematrix(FL.NB.expC, fullfile(exportFolder, 'FL_NB_expC_Flow_NonBank_SpendingExpense.csv'));
        writematrix(FL.NB.expL, fullfile(exportFolder, 'FL_NB_expL_Flow_NonBank_LoanInterestExpense.csv'));
        writematrix(FL.NB.incDIV, fullfile(exportFolder, 'FL_NB_incDIV_Flow_NonBank_DividendIncome.csv'));
        fprintf('Exported: FL.NB (all flows) with descriptive names\n');
    end
    
    % FL.BA (Bank flows)
    if isfield(FL, 'BA')
        writematrix(FL.BA.incR, fullfile(exportFolder, 'FL_BA_incR_Flow_Bank_ReserveInterestIncome.csv'));
        writematrix(FL.BA.incL, fullfile(exportFolder, 'FL_BA_incL_Flow_Bank_LoanInterestIncome.csv'));
        writematrix(FL.BA.expR, fullfile(exportFolder, 'FL_BA_expR_Flow_Bank_ReserveBorrowingExpense.csv'));
        writematrix(FL.BA.expD, fullfile(exportFolder, 'FL_BA_expD_Flow_Bank_DepositInterestExpense.csv'));
        writematrix(FL.BA.ni, fullfile(exportFolder, 'FL_BA_ni_Flow_Bank_NetIncome.csv'));
        writematrix(FL.BA.div, fullfile(exportFolder, 'FL_BA_div_Flow_Bank_DividendPayouts.csv'));
        fprintf('Exported: FL.BA (all flows) with descriptive names\n');
    end
    
    % FL.CB (Central Bank flows)
    if isfield(FL, 'CB')
        writematrix(FL.CB.incR, fullfile(exportFolder, 'FL_CB_incR_Flow_CentralBank_ReserveLendingIncome.csv'));
        writematrix(FL.CB.expR, fullfile(exportFolder, 'FL_CB_expR_Flow_CentralBank_ReserveRemunerationExpense.csv'));
        writematrix(FL.CB.expDC, fullfile(exportFolder, 'FL_CB_expDC_Flow_CentralBank_CBDCExpense.csv'));
        writematrix(FL.CB.seign, fullfile(exportFolder, 'FL_CB_seign_Flow_CentralBank_SeigniorageDistribution.csv'));
        fprintf('Exported: FL.CB (all flows) with descriptive names\n');
    end
end

%% Export axes object (skip - cannot export to CSV)
fprintf('Skipped: ax (graphics object, cannot export to CSV)\n');

%% Create summary file with variable info
summaryFile = fullfile(exportFolder, '_SUMMARY_variables_descriptive.txt');
fid = fopen(summaryFile, 'w');
fprintf(fid, 'Workspace Variables Export Summary (Descriptive Names)\n');
fprintf(fid, 'Export Date: %s\n\n', datestr(now));
fprintf(fid, 'File Naming Convention: CODE_Description.csv\n\n');

fprintf(fid, 'Balance Sheet Variables (BS):\n');
fprintf(fid, '================================\n');
fprintf(fid, 'Non-Bank (NB):\n');
fprintf(fid, '  - BS_NB_M_BalanceSheet_NonBank_MoneyHoldings.csv\n');
fprintf(fid, '  - BS_NB_L_BalanceSheet_NonBank_Loans.csv\n\n');

fprintf(fid, 'Bank (BA):\n');
fprintf(fid, '  - BS_BA_R_BalanceSheet_Bank_Reserves.csv\n');
fprintf(fid, '  - BS_BA_L_BalanceSheet_Bank_LoansGranted.csv\n');
fprintf(fid, '  - BS_BA_D_BalanceSheet_Bank_Deposits.csv\n');
fprintf(fid, '  - BS_BA_B_BalanceSheet_Bank_ReserveBorrowing.csv\n\n');

fprintf(fid, 'Central Bank (CB):\n');
fprintf(fid, '  - BS_CB_B_BalanceSheet_CentralBank_ReserveClaims.csv\n');
fprintf(fid, '  - BS_CB_R_BalanceSheet_CentralBank_ReserveDeposits.csv\n');
fprintf(fid, '  - BS_CB_C_BalanceSheet_CentralBank_Cash.csv\n');
fprintf(fid, '  - BS_CB_DC_BalanceSheet_CentralBank_CBDC.csv\n\n');

fprintf(fid, 'Flow Variables (FL):\n');
fprintf(fid, '================================\n');
fprintf(fid, 'Non-Bank (NB):\n');
fprintf(fid, '  - FL_NB_incD_Flow_NonBank_DepositInterestIncome.csv\n');
fprintf(fid, '  - FL_NB_incDC_Flow_NonBank_CBDCInterestIncome.csv\n');
fprintf(fid, '  - FL_NB_incS_Flow_NonBank_SeigniorageIncome.csv\n');
fprintf(fid, '  - FL_NB_incC_Flow_NonBank_SpendingIncome.csv\n');
fprintf(fid, '  - FL_NB_expC_Flow_NonBank_SpendingExpense.csv\n');
fprintf(fid, '  - FL_NB_expL_Flow_NonBank_LoanInterestExpense.csv\n');
fprintf(fid, '  - FL_NB_incDIV_Flow_NonBank_DividendIncome.csv\n\n');

fprintf(fid, 'Bank (BA):\n');
fprintf(fid, '  - FL_BA_incR_Flow_Bank_ReserveInterestIncome.csv\n');
fprintf(fid, '  - FL_BA_incL_Flow_Bank_LoanInterestIncome.csv\n');
fprintf(fid, '  - FL_BA_expR_Flow_Bank_ReserveBorrowingExpense.csv\n');
fprintf(fid, '  - FL_BA_expD_Flow_Bank_DepositInterestExpense.csv\n');
fprintf(fid, '  - FL_BA_ni_Flow_Bank_NetIncome.csv\n');
fprintf(fid, '  - FL_BA_div_Flow_Bank_DividendPayouts.csv\n\n');

fprintf(fid, 'Central Bank (CB):\n');
fprintf(fid, '  - FL_CB_incR_Flow_CentralBank_ReserveLendingIncome.csv\n');
fprintf(fid, '  - FL_CB_expR_Flow_CentralBank_ReserveRemunerationExpense.csv\n');
fprintf(fid, '  - FL_CB_expDC_Flow_CentralBank_CBDCExpense.csv\n');
fprintf(fid, '  - FL_CB_seign_Flow_CentralBank_SeigniorageDistribution.csv\n\n');

fprintf(fid, 'Export folder: %s\n', exportFolder);
fclose(fid);

fprintf('\n=== Export Complete ===\n');
fprintf('All variables exported to folder: %s\n', exportFolder);
fprintf('Files now have descriptive names following the pattern:\n');
fprintf('  CODE_Category_Entity_Description.csv\n');
fprintf('Summary file created: %s\n', summaryFile);