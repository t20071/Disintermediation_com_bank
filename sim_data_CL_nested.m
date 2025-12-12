function [y,p,p0,p1,p2] = sim_data_CL_nested(N,x1,x2,theta,mu_c)

% Generate random data from a conditional logit model, which is either nested or not.

% See Section 3.2 and Annex II in the paper as a primary reference for this function.

%% Inputs
%  N      Scalar, number of agents 
%  x1     J1xK matrix, predictor variables' values for J1 options in first nest for K predictors 
%  x2     J2xK matrix, predictor variables' values for J2 options in second nest for K predictors 
%  theta  Kx1 matrix, coefficients on K predictors
%  mu_c   1x2 or 2x1 vector

%% Outputs
%  y      1xN matrix, each agent's choice from among options j=1...J at the lowest level
%  p      1x(J1+J2) vector, choice probabilities at the lowest level
%  p0     1x2 vector, choice probabilities at upper level
%  p1     1xJ1 vector, choice probabilities within nest 1 (lower level)
%  p2     1xJ2 vector, choice probabilities within next 2 (lower level)

[J1,~] = size(x1);
[J2,~] = size(x2);

theta1 = [theta(1);theta(2:end)/mu_c(1)];
theta2 = [theta(1);theta(2:end)/mu_c(2)];

% Exp of scaled utilities
v1 = exp(mu_c(1).*x1*theta1)'; % 1xJ1, exp of utilities
v2 = exp(mu_c(2).*x2*theta2)'; % 1xJ2, exp of utilities
if sum(isinf(v1))>0 || sum(isinf(v2))>0, error('Reduce mu'), end

% Level 1: Choice at the upper level (eqs. 16 and 17 in the paper)
V_c = [1/mu_c(1)*log(sum(v1)) , 1/mu_c(2)*log(sum(v2))]; % 1x2, log sum terms for the two nests (eq. 5 in the paper), scaled by 1/mu
[~,y0] = max(repmat(V_c,N,1) + gevinv(rand(N,2)),[],2); % Nx1, probabilistic choice
N1 = sum(y0==1); % number of agents choosing first option
N2 = N - N1;

% Level 2: Choice at the lower level (eqs. 18/19 in the paper)
[~,y1] = max(repmat((x1*theta1)',N1,1) + gevinv(rand(N1,J1),0,1/mu_c(1)),[],2); % N1x1, probabilistic choice
[~,y2] = max(repmat((x2*theta2)',N2,1) + gevinv(rand(N2,J2),0,1/mu_c(2)),[],2); % N2x1, probabilistic choice

% Final choices (probabilistic)
y = NaN(1,N);
y(y0==1) = y1';
y(y0==2) = y2' + J1;

% Choice probabilities (analytical)
p0 = exp(V_c)./sum(exp(V_c)); % 1x2, nest probablilities
p1 = v1./sum(v1); % within nest 1xJ1, choice probabilities within nest 1
p2 = v2./sum(v2); % within nest 1xJ2, choice probabilities within nest 2
p = [p1.*p0(1), p2.*p0(2)]; % 1x(J1+J2), choice probabilities at lowest level