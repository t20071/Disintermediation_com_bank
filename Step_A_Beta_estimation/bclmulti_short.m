function [a,b,c] = bclmulti_short(Y,X,Z,F)

% The function estimates the coefficients of a binomial, multivariate
% conditional logit model of the following specific form:

% u_ijt = a_j  +  b x X_jt  +  c_j1 x Z1_t  + ... +  c_jK x ZK_t  +  eps_ijt

% where i are agents, j are choices, t is time, and k=1...K are K predictors in Z.

%% Inputs
%  Y      Tx1 vector, LHS data, share of category j=2
%  X      Tx2 matrix, RHS data, variable 1, pertaining to two categories j=1 and j=2 in the two cols
%  Z      TxK matrix, data for K additional variables, common across choice categories. Z can be empty.
%  F      string, either 'level' or 'diff'

%% Outputs
%  a      scalar, base utility for j=2
%  b      scalar, common coef pertaining to X
%  c      1xK vector, slopes on Z for j-=2; c is empty if Z is empty

%% Prepare
if strcmp(F,'level')==1
    levdiff = 1;
elseif strcmp(F,'diff')==1
    levdiff = 2;
else
    error('.')
end
if sum(Y<0)>0 || sum(Y>1)>0 || size(Y,2)~=1, error('.'), end
if size(X,1)~=size(Y,1) || size(X,2)~=2, error('.'), end
if sum(isnan(Y))>0 || sum(sum(isnan(X)))>0, error('.'), end
if ~isempty(Z)
    K = size(Z,2);
    if size(Z,1)~=length(Y) || sum(sum(isnan(Z)))>0
        error('.')
    end
else
    K = 0;
end
global yy xx zz
yy = Y; xx = X; zz = Z;

%% Estimation
x0 = [2 50];
if K>0, x0 = [x0 ones(1,K)/5]; end
%opts = optimset('maxiter',5000,'maxfunevals',5000,'display','iter','PlotFcns',@optimplotfval);
if levdiff==1
    %back = fminsearch(@devs,x0,opts);
    %[back,~,~,~,~,~,hessian] = fmincon(@devs,x0);
    [back,~,~,~,~,hessian] = fminunc(@devs,x0); %#ok<*ASGLU>
elseif levdiff==2
    %back = fminsearch(@devsd,x0,opts);
    %[back,~,~,~,~,~,hessian] = fmincon(@devsd,x0);
    [back,~,~,~,~,hessian] = fminunc(@devsd,x0);
end
a = back(1);
b = back(2);
c = [];
if K>0
    c = back(3:3+K-1);
end

clear yy xx zz

end
