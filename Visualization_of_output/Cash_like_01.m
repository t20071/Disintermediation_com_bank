% plot_cbdc_shares_bar_india.m
% Create stacked-bar figure for India CBDC simulation
% Fixed version to match the paper's Figure 4 style

clear; close all; clc;

% === USER: Point to your saved MAT-file from the simulation ===
matFile = 'Cash_workspace.mat';

if ~isfile(matFile)
    error('Could not find %s. Please set matFile to your simulation .mat file.', matFile)
end

% Load results
data = load(matFile);

% === EXTRACT VARIABLES (checking multiple possible names) ===
% Try to find vol2 (main results array)
if isfield(data,'vol2')
    vol2 = data.vol2;
elseif isfield(data,'vol2_all')
    vol2 = data.vol2_all;
elseif isfield(data,'vol2_')
    vol2 = data.vol2_;
else
    error('Cannot find vol2 variable. Available variables: %s', strjoin(fieldnames(data), ', '))
end

fprintf('Loaded vol2 with size: %d x %d\n', size(vol2,1), size(vol2,2));

% Get simulation parameters
[Tsim, cols] = size(vol2);
B = cols - 2;  % Number of banks (last 2 cols are cash and CBDC)

if B < 1
    error('vol2 dimension suggests no bank columns. Expected format: [B deposit cols | cash | CBDC]');
end
fprintf('Number of banks (B): %d\n', B);

% === EXTRACT COUNTERFACTUAL BREAK POINTS ===
if isfield(data,'CFBs')
    CFBs = data.CFBs;
elseif isfield(data,'CFBs_')
    CFBs = data.CFBs_;
elseif isfield(data,'breakpoints')
    CFBs = data.breakpoints;
else
    % Default: 5 counterfactual windows + baseline
    warning('CFBs not found. Creating default windows.');
    CFBs = round(linspace(1, Tsim, 6));
end
fprintf('Counterfactual break points: %s\n', mat2str(CFBs));

% === EXTRACT WINDOW LENGTH FOR AVERAGING ===
if isfield(data,'S')
    S = data.S;
elseif isfield(data,'window_length')
    S = data.window_length;
else
    S = 750;  % Paper default
    warning('S not found. Using default S = 750');
end
fprintf('Window length for averaging (S): %d\n', S);

% === EXTRACT CBDC RATES (for x-axis labels) ===
if isfield(data,'rDC_')
    rDC_list = data.rDC_;
    if isfield(data,'rB') || isfield(data,'policy_rate')
        policy_rate = data.rB;
        cbdc_percent = rDC_list ./ policy_rate;
    else
        cbdc_percent = [0, 0.25, 0.5, 0.75, 1.0];
    end
else
    % Default CBDC rates used in paper
    cbdc_percent = [0, 0.25, 0.5, 0.75, 1.0];
end

% === DEFINE WINDOWS ===
win_starts = CFBs;
win_ends = [CFBs(2:end)-1, Tsim];
nWindows = length(win_starts);

fprintf('\nProcessing %d windows:\n', nWindows);

% === COMPUTE SHARES FOR EACH WINDOW ===
deposits_share = nan(nWindows, 1);
cash_share = nan(nWindows, 1);
cbdc_share = nan(nWindows, 1);

for w = 1:nWindows
    t0 = win_starts(w);
    t1 = win_ends(w);
    
    % Take last S periods of the window (or whole window if shorter)
    if (t1 - t0 + 1) >= S
        idx = (t1 - S + 1) : t1;
    else
        idx = t0:t1;
    end
    
    fprintf('  Window %d: t=%d to t=%d (using last %d periods)\n', w, t0, t1, length(idx));
    
    % Compute share for each period, then take median
    share_per_period = nan(length(idx), 3);
    
    for tt = 1:length(idx)
        row = vol2(idx(tt), :);
        total = sum(row);
        
        if total > 0
            share_per_period(tt, 1) = sum(row(1:B)) / total;   % Deposits
            share_per_period(tt, 2) = row(B+1) / total;         % Cash
            share_per_period(tt, 3) = row(B+2) / total;         % CBDC
        else
            share_per_period(tt, :) = [0, 0, 0];
        end
    end
    
    % Take median across periods (robust to outliers)
    deposits_share(w) = median(share_per_period(:, 1));
    cash_share(w) = median(share_per_period(:, 2));
    cbdc_share(w) = median(share_per_period(:, 3));
    
    fprintf('    Shares: Deposits=%.1f%%, Cash=%.1f%%, CBDC=%.1f%%\n', ...
        100*deposits_share(w), 100*cash_share(w), 100*cbdc_share(w));
end

% === CREATE STACKED BAR CHART ===
% Stack order: Deposits (bottom), CBDC (middle), Cash (top) - matching the image
stackData = [deposits_share, cbdc_share, cash_share];

% Colors matching the paper/image: Blue (deposits), Yellow (CBDC), Green (cash)
stackCols = [0.0 0.45 0.74;   % Blue for deposits
             0.93 0.69 0.13;   % Yellow/orange for CBDC
             0.47 0.67 0.19];  % Green for cash

% Create figure
figure('Color', 'w', 'Position', [200, 200, 700, 500]);
hb = bar(1:nWindows, stackData, 'stacked', 'BarWidth', 0.8);

% Apply colors
for k = 1:3
    hb(k).FaceColor = stackCols(k, :);
    hb(k).EdgeColor = 'none';
end

% Formatting
ylim([0 1])
xlim([0.5 nWindows + 0.5])
ylabel('Percent of total money', 'FontSize', 10, 'FontWeight', 'bold','Color', 'k')
title('CBDC Cash-Like', 'FontSize', 16, 'FontWeight', 'bold', 'Color', 'k')

% X-axis labels - matching the image exactly
xlabels = cell(nWindows, 1);
xlabels{1} = 'Baseline';

% For counterfactual windows, use the standard rates
standard_rates = [0, 0.25, 0.5, 0.75, 1];
for w = 2:nWindows
    rate_idx = w - 1;
    if rate_idx <= length(standard_rates)
        xlabels{w} = num2str(standard_rates(rate_idx));
    elseif length(cbdc_percent) >= rate_idx
        xlabels{w} = num2str(cbdc_percent(rate_idx));
    else
        xlabels{w} = num2str(rate_idx);
    end
end

set(gca, 'XTick', 1:nWindows, 'XTickLabel', xlabels, 'FontSize', 10)
set(gca, 'TickDir', 'out')
set(gca, 'XColor', 'k', 'YColor', 'k')  % Ensure axis lines and tick labels are black
xlabel('CBDC rate as percent of policy rate', 'FontSize', 10, 'Color', 'k')

% Add legend in bottom right corner
legend({'Deposits', 'CBDC', 'Cash'}, 'Location', 'southeast', 'FontSize', 10)

% Clean up axes
box off
grid off

% Optional: Add percentage labels on bars (uncomment if desired)
% for i = 1:nWindows
%     ypos = 0;
%     for k = 1:3
%         if stackData(i,k) > 0.05  % Only label if segment is large enough
%             ypos = ypos + stackData(i,k)/2;
%             text(i, ypos, sprintf('%.1f%%', 100*stackData(i,k)), ...
%                 'HorizontalAlignment', 'center', 'FontSize', 8, 'Color', 'white', 'FontWeight', 'bold');
%             ypos = ypos + stackData(i,k)/2;
%         else
%             ypos = ypos + stackData(i,k);
%         end
%     end
% end

% Save figure
saveas(gcf, 'india_cbdc_shares_bar.png');
saveas(gcf, 'india_cbdc_shares_bar.fig');

fprintf('\nPlot saved as: india_cbdc_shares_bar.png\n');
fprintf('Done!\n');