%% Load real data from Excel (India)
data = readtable('India_Beta_Data _decimal.xlsx');

% Define variables
CR = data.Cash_Ratio;          % cash-to-M3 ratio (dependent variable)
i_d = data.Deposit_Rate;       % deposit rate (independent variable)
GDPG = data.GDP_Growth;        % example control variable
INF = data.Inflation;          % example control variable

% Combine control variables (Z)
Z =  INF ;  % can include one or more controls
X = [i_d zeros(length(i_d),1)];  % deposit rate and rate on cash (=0)

% Set constants (you can adjust if needed)
a = 1;       % base utility for cash (initial guess, not used for estimation)
b = NaN;     % unknown true beta (to be estimated)
c = zeros(1, size(Z,2));  % slopes on Z (initialized)

% Compute dependent variable y (probability of choosing cash)
y = [i_d CR];   % column 1 = deposits, column 2 = cash

%% Estimation
D = 42; % number of repetitions to obtain full distribution of beta
[u1,u2,u3,ff,r2,dwa] = bclmulti(y(:,2),X,Z,'diff',D);

%% Plot: Fit vs. data
figure(1)
plot([y(:,2) ff])
ylabel('Cash ratio')
xlim([1 length(y)])
legend('Actual data','Fitted')
title(['R2 = ' num2str(r2) ' / DW = ' num2str(dwa(1))])
disp(' ')
disp(['Estimated price sensitivity (beta) = ' num2str(u2(1))])

%% Plot: Distribution of beta
figure(2)
ksdensity(u2)
title('Estimated Beta Distribution')
xlabel('Beta values')
ylabel('Density')
