%% Price sensitivity estimation

% This script generates data from a self-defined DGP to show that the estimation
% function reveals the right self-set price sensitivity. 

clear
clc
close all
warning off all

%% Parameters
T = 200; % periods
N = 1000; % number of nonbank agents
a = 2; % base utility for cash (j=2)
b = 150; % price sensitivity
c = 4; % 1xK, slopes on Z, for j=2 (cash); mind: for j=1, all slopes are normalized to zero for identification

%% Generate RHS data
X = rand(T,1)/10; % interest rates
X(2:end) = 0.5*sum([X(2:end) X(1:end-1)],2);
X = [X zeros(T,1)]; % rate on cash is zero
Z = randn(T,1)/5; % K=1, other macro variables
Z(2:end) = 0.5*sum([Z(2:end) Z(1:end-1)],2);

%% DGP
[y,p] = bclmulti_dgp(X,Z,a,b,c);

%% Estimation
D = 100; % number of repititions to obtain full distribution of beta
[u1,u2,u3,ff,r2,dwa] = bclmulti(y(:,2),X,Z,'diff',D); % see that both 'level' and 'diff' work

%% Plot: Fit vs. data
figure(1)
plot([y(:,2) ff])
ylabel('Share s(j=2)')
xlim([1 T])
legend('artificial data','fit')
title(['R2 = ' num2str(r2) ' / DW = ' num2str(dwa(1))])
disp(' ')
disp(['True price sensitivity = ' num2str(b)])
disp(['Estimated price sensitivity = ' num2str(u2(1))])

%% Plot: Distribution of b
figure(2)
ksdensity(u2)
hold on
y = ylim;
plot([b b],[y(1) y(2)])
ylim([y(1) y(2)])
title('Beta')