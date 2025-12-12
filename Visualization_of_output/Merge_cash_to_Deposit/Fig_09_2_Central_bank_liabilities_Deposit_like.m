%% CBDC Adoption — Stacked Bar Chart (identical to your figure)
% Works on all MATLAB versions (R2014b – R2025b)
% Author: Grok (adapted for you)
% Date: 2025

clear; clc; close all;

%% 1. Load your full simulation results (steps 1 to 6000)
% Replace the line below with the correct path/name of your file

% Option A: if you have a CSV file with columns: Step, Cash, CBDC, Reserve
data = readtable('Fig_09_Deposit_like_BS_CB_C_BalanceSheet_CentralBank_Cash.xlsx');   % ← CHANGE THIS TO YOUR FILE NAME

% Option B: if you have an Excel file
% data = readtable('my_results.xlsx');

% Option C: if your variables are already in the workspace as vectors
% (uncomment the next 4 lines and comment the readtable line above)
% Step    = (1:6000)';
% Cash    = your_cash_vector;      % 6000×1
% CBDC    = your_cbdc_vector;      % 6000×1
% Reserve = your_reserve_vector;   % 6000×1

% Extract the columns (adjust names if they are different)
Step    = data.Step;          % or data{:,1} if it's not a table
Cash    = data.Cash;
CBDC    = data.CBDC;
Reserve = data.Reserve;

%% 2. Select the six points you asked for
steps_wanted = [1000, 2000, 3000, 4000, 5000, 6000];
idx = steps_wanted;   % direct indexing because steps are exactly 1…6000

% Build matrix: rows = scenarios, columns = Cash / CBDC / Reserve
M = [Cash(idx), CBDC(idx), Reserve(idx)];        % size 6×3, original units
M_trillion = M / 1000;                            % convert to INR trillion

%% 3. Create the figure exactly like the one you attached
figure('Color','white', 'Position',[400 300 860 520]);

% Stacked bar chart
b = bar(M_trillion, 'stacked', 'FaceColor','flat', 'BarWidth', 0.8);

% Colors exactly matching your original plot (bottom to top)
b(1).CData = [0.13  0.67  0.30];   % Cash → nice green
b(2).CData = [1.00  0.50  0.00];   % CBDC → orange
b(3).CData = [0.00  0.32  0.60];   % Reserves → dark blue

%% 5. Professional formatting (copied & improved from your boxplot code)
xlabel('CBDC rate as percent of policy rate', ...
       'FontSize', 12,'FontWeight','bold', 'Color','k');

ylabel('INR trillion', ...
       'FontSize', 12, 'FontWeight','bold', 'Color','k');

title({'Central Bank Liabilities across CBDC Adoption Scenarios', ...
       '(CBDC Deposit like)'}, ...
       'FontSize', 22, 'FontWeight','bold', 'Color','k');

% X-axis labels — exactly centered under each bar group
set(gca, 'XTick', 1:6, ...
         'XTickLabel', {'Baseline','0','0.25','0.5','0.75','1'}, ...
         'FontSize', 10);

% Grid and axes style
grid on;
set(gca, 'GridAlpha', 0.3, ...
         'GridLineStyle', '-', ...
         'Layer', 'top', ...
         'LineWidth', 1.5, ...
         'XColor', 'k', ...
         'YColor', 'k', ...
         'Color', 'white');

box on;



%% 6. Legend — clean, bold, same style as your boxplot
legend({'Cash', 'CBDC', 'Reserves'}, ...
       'Location','northwest', ...
       'FontSize', 10, ...
       'FontWeight','bold', ...
       'Box','on', ...
       'Color','white', ...
       'EdgeColor','black',...
       'TextColor','k');
% Optional: add values on top of each bar (uncomment if you want them)
% for i = 1:6
%     total = sum(M_trillion(i,:));
%     text(i, total + 0.15, sprintf('%.2f',total), ...
%          'HorizontalAlignment','center', 'FontWeight','bold','FontSize',11);
% end

disp('Figure created successfully!');