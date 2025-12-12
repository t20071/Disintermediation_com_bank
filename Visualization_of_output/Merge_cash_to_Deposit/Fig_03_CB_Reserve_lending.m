% CBDC Aggregate Deposit Rate Analysis
% This script automatically adjusts y-axis based on data range
% Optimized for maximum visibility

% Clear workspace
clear; clc; close all;

% Import the Excel file
% Replace 'your_file.xlsx' with your actual file name
filename = 'Com_BS_CB_B_BalanceSheet_CentralBank_ReserveClaims.xlsx';
data = readtable(filename);

% Extract columns
steps = data.Step;
cash = data.Cash / 1000;  % Convert to Trillion
deposit = data.Deposit / 1000;  % Convert to Trillion

% Define the groups based on step ranges
baseline_cash = cash(1:1000);
baseline_deposit = deposit(1:1000);

group0_cash = cash(1001:2000);
group0_deposit = deposit(1001:2000);

group025_cash = cash(2001:3000);
group025_deposit = deposit(2001:3000);

group050_cash = cash(3001:4000);
group050_deposit = deposit(3001:4000);

group075_cash = cash(4001:5000);
group075_deposit = deposit(4001:5000);

group1_cash = cash(5001:6000);
group1_deposit = deposit(5001:6000);

% Store data in cell array for easy access
data_groups = {baseline_cash, baseline_deposit, ...
               group0_cash, group0_deposit, ...
               group025_cash, group025_deposit, ...
               group050_cash, group050_deposit, ...
               group075_cash, group075_deposit, ...
               group1_cash, group1_deposit};

% AUTOMATIC Y-AXIS CALCULATION
% Find the overall min and max across all groups
all_data_combined = [cash; deposit];
data_min = min(all_data_combined);
data_max = max(all_data_combined);
data_range = data_max - data_min;

% Add 10% padding on top and bottom for better visualization
y_lower = data_min - 0.10 * data_range;
y_upper = data_max + 0.10 * data_range;

% Ensure y_lower is not negative if your data is all positive
if data_min > 0 && y_lower < 0
    y_lower = max(0, data_min - 0.15 * data_range);
end

% Create larger figure with white background
figure('Position', [50, 50, 1400, 800]);
set(gcf, 'Color', 'w');

% Define positions for boxplots - more spacing
positions = [1, 1.5, 3, 3.5, 5, 5.5, 7, 7.5, 9, 9.5, 11, 11.5];

% Define colors - more vibrant
colors_cash = [0.75 0.75 0.75;  % Gray for baseline
               0.98 0.78 0.15;   % Brighter gold for others
               0.98 0.78 0.15;
               0.98 0.78 0.15;
               0.98 0.78 0.15;
               0.98 0.78 0.15];
               
colors_deposit = [0.75 0.75 0.75;  % Gray for baseline
                  0.4 0.65 0.92;    % Brighter blue for others
                  0.4 0.65 0.92;
                  0.4 0.65 0.92;
                  0.4 0.65 0.92;
                  0.4 0.65 0.92];

% Create custom boxplot with enhanced visibility
ax = gca;
hold on;

for i = 1:12
    % Determine if this is cash or deposit
    is_deposit = mod(i, 2) == 0;
    group_idx = ceil(i/2);
    
    if is_deposit
        color = colors_deposit(group_idx, :);
    else
        color = colors_cash(group_idx, :);
    end
    
    % Calculate boxplot statistics manually for better control
    data_current = data_groups{i};
    q1 = prctile(data_current, 25);
    q2 = median(data_current);
    q3 = prctile(data_current, 75);
    iqr = q3 - q1;
    
    % Whiskers (1.5 * IQR rule)
    lower_whisker = max(min(data_current), q1 - 1.5*iqr);
    upper_whisker = min(max(data_current), q3 + 1.5*iqr);
    
    pos = positions(i);
    box_width = 0.45;
    
    % Draw filled box
    rectangle('Position', [pos-box_width/2, q1, box_width, iqr], ...
              'FaceColor', color, 'EdgeColor', 'k', 'LineWidth', 2);
    
    % Draw median line (thicker and darker)
    plot([pos-box_width/2, pos+box_width/2], [q2, q2], ...
         'k-', 'LineWidth', 2.5);
    
    % Draw whiskers
    plot([pos, pos], [q3, upper_whisker], 'k-', 'LineWidth', 1.8);
    plot([pos, pos], [q1, lower_whisker], 'k-', 'LineWidth', 1.8);
    
    % Draw whisker caps
    plot([pos-box_width/4, pos+box_width/4], [upper_whisker, upper_whisker], ...
         'k-', 'LineWidth', 1.8);
    plot([pos-box_width/4, pos+box_width/4], [lower_whisker, lower_whisker], ...
         'k-', 'LineWidth', 1.8);
end

% Enhanced formatting
ylabel('INR Trillion', 'FontSize', 14,'FontWeight', 'bold', 'Color', 'k');
xlabel('CBDC rate as percent of policy rate', 'FontSize', 14,'FontWeight', 'bold','Color', 'k');
title('Central bank reserve lending', 'FontSize', 22, 'FontWeight', 'bold', 'Color', 'k');

% Set x-axis labels with better positioning and black bold text
xticks([1.25, 3.25, 5.25, 7.25, 9.25, 11.25]);
xticklabels({'Baseline', '0', '0.25', '0.5', '0.75', '1'});

% This line makes tick labels bold and black
set(gca, 'FontSize', 10, ....
         'XColor', 'k', 'YColor', 'k');   % 'k' = black

% Optional: extra safety if you're on a dark figure theme
ax = gca;
ax.TickLabelInterpreter = 'tex';   % if you ever use LaTeX

grid on;
set(gca, 'Color', 'white', ...          % axes background = white
         'GridAlpha', 0.3, ...
         'GridLineStyle', '-', ...
         'Layer', 'top');

set(gcf, 'Color', 'white');             % figure background = white (outside the plot)
% AUTOMATIC Y-AXIS LIMITS with better spacing
xlim([0.3, 12.2]);
ylim([y_lower, y_upper]);

% Thicker axes
box on;
set(gca, 'LineWidth', 1.5);

% Enhanced legend with correct colors
% Create patch objects for legend with proper colors
h_leg_deposit = patch([NaN NaN NaN NaN], [NaN NaN NaN NaN], colors_deposit(2,:), ...
                      'EdgeColor', 'k', 'LineWidth', 2);
h_leg_cash = patch([NaN NaN NaN NaN], [NaN NaN NaN NaN], colors_cash(2,:), ...
                   'EdgeColor', 'k', 'LineWidth', 2);

% Add legend
legend_deposit = fill([NaN NaN], [NaN NaN], colors_deposit(2,:), ...
                      'EdgeColor', 'k', 'LineWidth', 1.2);
legend_cash = fill([NaN NaN], [NaN NaN], colors_cash(2,:), ...
                   'EdgeColor', 'k', 'LineWidth', 1.2);
legend_baseline = fill([NaN NaN], [NaN NaN], [0.75 0.75 0.75], ...
                       'EdgeColor', 'k', 'LineWidth', 1.1);
legend([legend_baseline,legend_cash,legend_deposit], {'Baseline','CBDC cash-like', 'CBDC deposit-like'}, ...
       'Location', 'best', 'FontSize', 11, 'Box', 'on');

hold off;


% Delete the invisible patch objects (they're only for legend)
delete(h_leg_deposit);
delete(h_leg_cash);

hold off;

% Display summary statistics and Y-axis range
fprintf('\n========================================\n');
fprintf('AUTOMATIC Y-AXIS ADJUSTMENT\n');
fprintf('========================================\n');
fprintf('Data Range: %.4f to %.4f\n', min(all_data_combined), max(all_data_combined));
fprintf('Y-axis Range: %.4f to %.4f\n', y_lower, y_upper);
fprintf('========================================\n\n');

fprintf('Summary Statistics:\n');
fprintf('=====================================\n');
groups_names = {'Baseline', '0', '0.25', '0.50', '0.75', '1'};
for i = 1:6
    fprintf('\nGroup: %s\n', groups_names{i});
    fprintf('  Cash    - Mean: %.4f, Median: %.4f, Range: [%.4f, %.4f]\n', ...
            mean(data_groups{2*i-1}), median(data_groups{2*i-1}), ...
            min(data_groups{2*i-1}), max(data_groups{2*i-1}));
    fprintf('  Deposit - Mean: %.4f, Median: %.4f, Range: [%.4f, %.4f]\n', ...
            mean(data_groups{2*i}), median(data_groups{2*i}), ...
            min(data_groups{2*i}), max(data_groups{2*i}));
end
fprintf('\n========================================\n');