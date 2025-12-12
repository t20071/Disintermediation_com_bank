% --- MATLAB CODE TO EXPORT MATRICES ---

% Define the filename for the solver to read
outputFilename = 'India_Calibration_Matrices_Run_2.xlsx';

disp('Exporting Simulated Deposit Rates (tab1)...');
% Write the Deposit Rate matrix (tab1) starting at cell A1
writetable(array2table(tab1), outputFilename, 'Sheet', 'Deposit_Rate_Matrix', 'WriteMode', 'overwrite');

disp('Exporting Simulated Cash Ratios (tab3)...');
% Write the Cash Ratio matrix (tab3) starting at cell A1
writetable(array2table(tab3), outputFilename, 'Sheet', 'Cash_Ratio_Matrix', 'WriteMode', 'append');

disp(['SUCCESS: Matrices saved to ' outputFilename]);