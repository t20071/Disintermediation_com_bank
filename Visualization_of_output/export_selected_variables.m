%% Export Selected Variables Only to Excel

% Set export parameters
exportMainFolder = 'Combined_2';
timestamp = datestr(now, 'yyyymmdd_HHMMSS');
exportFolder = fullfile(exportMainFolder, ['Cash_' timestamp]);

% Create single folder (no subfolders)
if ~exist(exportFolder, 'dir')
    mkdir(exportFolder);
end

%% Export Selected Variables Only to Excel
fprintf('Exporting selected variables to Excel...\n');

% Export selected variables
writematrix(avrate, fullfile(exportFolder, 'avrate_AverageDepositRate_deposit.xlsx'));
fprintf('  Exported: avrate_AverageDepositRate_deposit.xlsx\n');

writematrix(BS.BA.D, fullfile(exportFolder, 'BS_BA_D_BalanceSheet_Bank_Deposits.xlsx'));
fprintf('  Exported: BS_BA_D_BalanceSheet_Bank_Deposits.xlsx\n');

writematrix(BS.BA.R, fullfile(exportFolder, 'BS_BA_R_BalanceSheet_Bank_Reserves.xlsx'));
fprintf('  Exported: BS_BA_R_BalanceSheet_Bank_Reserves.xlsx\n');

writematrix(BS.CB.B, fullfile(exportFolder, 'BS_CB_B_BalanceSheet_CentralBank_ReserveClaims.xlsx'));
fprintf('  Exported: BS_CB_B_BalanceSheet_CentralBank_ReserveClaims.xlsx\n');

writematrix(BS.CB.DC, fullfile(exportFolder, 'BS_CB_DC_BalanceSheet_CentralBank_CBDC.xlsx'));
fprintf('  Exported: BS_CB_DC_BalanceSheet_CentralBank_CBDC.xlsx\n');

writematrix(BS.CB.C, fullfile(exportFolder, 'BS_CB_C_BalanceSheet_CentralBank_Cash.xlsx'));
fprintf('  Exported: BS_CB_C_BalanceSheet_CentralBank_Cash.xlsx\n');

writematrix(FL.BA.expD, fullfile(exportFolder, 'FL_BA_expD_Flows_Bank_DepositInterestExpense.xlsx'));
fprintf('  Exported: FL_BA_expD_Flows_Bank_DepositInterestExpense.xlsx\n');

writematrix(FL.BA.expR, fullfile(exportFolder, 'FL_BA_expR_Flows_Bank_ReserveBorrowingExpense.xlsx'));
fprintf('  Exported: FL_BA_expR_Flows_Bank_ReserveBorrowingExpense.xlsx\n');

writematrix(FL.BA.ni, fullfile(exportFolder, 'FL_BA_ni_Flows_Bank_NetIncome.xlsx'));
fprintf('  Exported: FL_BA_ni_Flows_Bank_NetIncome.xlsx\n');

writematrix(FL.CB.expDC, fullfile(exportFolder, 'FL_CB_expDC_Flows_CentralBank_CBDCInterestExpense.xlsx'));
fprintf('  Exported: FL_CB_expDC_Flows_CentralBank_CBDCInterestExpense.xlsx\n');

writematrix(FL.CB.incR, fullfile(exportFolder, 'FL_CB_incR_Flows_CentralBank_ReserveInterestIncome.xlsx'));
fprintf('  Exported: FL_CB_incR_Flows_CentralBank_ReserveInterestIncome.xlsx\n');

writematrix(FL.CB.seign, fullfile(exportFolder, 'FL_CB_seign_Flows_CentralBank_SeigniorageDistribution.xlsx'));
fprintf('  Exported: FL_CB_seign_Flows_CentralBank_SeigniorageDistribution.xlsx\n');

fprintf('\n=== EXPORT COMPLETE ===\n');
fprintf('Results saved to: %s\n', exportFolder);
fprintf('Total files exported: 12\n');



%% Create README file with variable descriptions
readmeFile = fullfile(exportFolder, 'README_VariableDescriptions.txt');
fid = fopen(readmeFile, 'w');
fprintf(fid, '============================================\n');
fprintf(fid, 'MONETARY ABM SIMULATION RESULTS\n');
fprintf(fid, 'Export Date: %s\n', datestr(now));
fprintf(fid, '============================================\n\n');

fprintf(fid, 'EXPORTED VARIABLES:\n');
fprintf(fid, '--------------------------------------------\n\n');

fprintf(fid, '1. avrate_AverageDepositRate_deposit.xlsx\n');
fprintf(fid, '   Volume-weighted average deposit rate across all banks\n\n');

fprintf(fid, '2. BS_BA_D_BalanceSheet_Bank_Deposits.xlsx\n');
fprintf(fid, '   Bank balance sheet: Non-bank deposits (liabilities)\n\n');

fprintf(fid, '3. BS_BA_R_BalanceSheet_Bank_Reserves.xlsx\n');
fprintf(fid, '   Bank balance sheet: Reserve holdings (assets)\n\n');

fprintf(fid, '4. BS_CB_B_BalanceSheet_CentralBank_ReserveClaims.xlsx\n');
fprintf(fid, '   Central Bank balance sheet: Reserve claims vis-a-vis banks (assets)\n\n');

fprintf(fid, '5. BS_CB_DC_BalanceSheet_CentralBank_CBDC.xlsx\n');
fprintf(fid, '   Central Bank balance sheet: CBDC in circulation (liabilities)\n\n');

fprintf(fid, '6. BS_CB_C_BalanceSheet_CentralBank_Cash.xlsx\n');
fprintf(fid, '   Central Bank balance sheet: Cash in circulation (liabilities)\n\n');

fprintf(fid, '7. FL_BA_expD_Flows_Bank_DepositInterestExpense.xlsx\n');
fprintf(fid, '   Bank flows: Deposit interest expense paid to non-banks\n\n');

fprintf(fid, '8. FL_BA_expR_Flows_Bank_ReserveBorrowingExpense.xlsx\n');
fprintf(fid, '   Bank flows: Reserve borrowing expense paid to Central Bank\n\n');

fprintf(fid, '9. FL_BA_ni_Flows_Bank_NetIncome.xlsx\n');
fprintf(fid, '   Bank flows: Net income before dividends\n\n');

fprintf(fid, '10. FL_CB_expDC_Flows_CentralBank_CBDCInterestExpense.xlsx\n');
fprintf(fid, '    Central Bank flows: Interest expense for CBDC remuneration\n\n');

fprintf(fid, '11. FL_CB_incR_Flows_CentralBank_ReserveInterestIncome.xlsx\n');
fprintf(fid, '    Central Bank flows: Interest income from reserve lending to banks\n\n');

fprintf(fid, '12. FL_CB_seign_Flows_CentralBank_SeigniorageDistribution.xlsx\n');
fprintf(fid, '    Central Bank flows: Seigniorage distribution to non-banks\n\n');

fprintf(fid, '============================================\n');
fprintf(fid, 'NOTE: All data files are in Excel (.xlsx) format\n');
fprintf(fid, 'For more details, see the main MATLAB code.\n');
fprintf(fid, '============================================\n');
fclose(fid);

fprintf('README file created: %s\n', readmeFile);