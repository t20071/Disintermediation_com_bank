% ==============================================================
% MATLAB code to create the stacked bar chart for CBDC simulation
% ==============================================================

% 1. Load your data (adjust the file name / format as needed)
% Assuming you have a table or matrix with columns: Step, Cash, CBDC, Reserve
data = readtable('Fig_09_cash_like_BS_CB_C_BalanceSheet_CentralBank_Cash.xlsx');   % <-- change to your file
% OR if you have vectors already in workspace:
% Step   = (1:6000)';
% Cash   = ...;
% CBDC   = ...;
% Reserve = ...;

Step    = data.Step;       % column 1
Cash    = data.Cash;       % column 2
CBDC    = data.CBDC;       % column 3
Reserve = data.Reserve;    % column 4

% 2. Pick the rows that correspond to the requested steps
idx = [1000, 2000, 3000, 4000, 5000, 6000];   % steps we want
values = [Cash(idx), CBDC(idx), Reserve(idx)];   % 6 × 3 matrix

% Convert from whatever unit your simulation uses to USD trillion
% (in the example plot everything is in trillions)
values_trillion = values / 1000;

% 3. Prepare the x-axis labels exactly as in your picture
xlabels = {'Baseline','0','0.25','0.5','0.75','1'};

% 4. Create the stacked bar chart
figure('Color','white','Position',[100 100 800 500]);

h = bar(values_trillion, 'stacked', 'FaceColor','flat');

% Colors exactly matching your example (from bottom to top):
% Cash (green), CBDC (orange), Reserve / CBDC Cash-like (dark blue)
h(1).CData = [0.2 0.7 0.2];     % Green  – Cash
h(2).CData = [1.0 0.5 0.0];     % Orange – CBDC
h(3).CData = [0.0 0.3 0.6];     % Dark blue – Reserves / CBDC Cash-like

% 5. Beautify the figure
set(gca, 'XTickLabelInterpreter','tex');
set(gca, 'XTick',1:6, 'XTickLabel',xlabels, 'FontSize',12);
ylabel('USD trillion','FontSize',14);
title('CBDC Adoption Scenario','FontSize',16);

% Add legend in the same order as the stacks (bottom → top)
legend({'Cash','CBDC','CBDC Cash-like / Reserves'}, ...
       'Location','northwest','FontSize',12);

grid on;
box on;

% Optional: make the bars a bit thicker
set(gca,'LineWidth',1.2);

% ==============================================================
% If your data is already in the workspace as vectors named Cash, CBDC, Reserve:
% just comment out the readtable line and run from section 2 onward.
% ==============================================================