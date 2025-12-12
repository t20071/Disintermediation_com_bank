function [a,b,c,f,r2,dwa] = bclmulti(Y,X,Z,F,D)

% mgross@imf.org

% The function estimates the coefficients of a binomial, multivariate
% conditional logit model of the following specific form:

% u_ijt = a_j  +  b x X_jt  +  c_j1 x Z1_t  + ... +  c_jK x ZK_t  +  eps_ijt

% where i are agents, j are choices, t is time, and k=1...K are K predictors in Z.

%% Inputs
%  Y      Tx1 vector, LHS data, share of category j=2
%  X      Tx2 matrix, RHS data, variable 1, pertaining to two categories j=1 and j=2 in the two cols
%  Z      TxK matrix, data for K additional variables, common across choice categories. Z can be empty.
%  F      string, either 'level' or 'diff'
%  D      scalar, number of bootstrap replicates to obtain distribution of all parameters; can be left empty to not do that

%% Outputs
%  a      scalar, base utility for j=2
%  b      scalar, common coef pertaining to X
%  c      1xK vector, slopes on Z for j-=2; c is empty if Z is empty
%  f      Tx1 vector, LHS fit
%  r2     R-square, scalar when F=='level', 1x2 when F=='diff', latter case: for levels and diff
%  dwa    DW, scalar when F=='level', 1x2 when F=='diff', latter case: for levels and diff

% If D>1, then a and b are of size (1+D)x1 and c of size (1+D)xK, where the
% first cells contain the coef point estimates and the remaining D are
% bootstrap-based estimates.

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
x0 = [1.5 75];
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

%% Stats
f = fit(back);
if levdiff==1 % level
    r2 = rsquare(yy,f,2+K);
    if length(f)>1
        dwa = dw(yy-f);
    else
        dwa = NaN;
    end
else % diff
    df = diff(f);
    f = [yy(1);yy(1:end-1)+df];
    r2 = [rsquare(yy,f,2+K) rsquare(diff(yy),df,2+K)];
    if length(df)>1
        dwa = [dw(yy-f) dw(diff(yy)-df)];
    else
        dwa = NaN;
    end
end

%% Bootstrap coef distributions
if ~isempty(D) && D>1
    a = [a;NaN(D,1)];
    b = [b;NaN(D,1)];
    if K>0
        c = [c;NaN(D,K)];
    end
    for d=1:D
        if K==0
            [ay,~] = bclmulti_dgp(X,[],a(1),b(1),[]);
            [a(1+d),b(1+d),~] = bclmulti_short(ay(:,2),X,[],F);
        else
            [ay,~] = bclmulti_dgp(X,Z,a(1),b(1),c(1,:));
            [a(1+d),b(1+d),c(1+d,:)] = bclmulti_short(ay(:,2),X,Z,F); %#ok<AGROW>
        end
        
    end
end

clear yy xx zz

end