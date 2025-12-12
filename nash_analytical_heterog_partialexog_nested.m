function [iN,ms] = nash_analytical_heterog_partialexog_nested(i,alpha,beta,exog,iexog,mu_exo)

% Compute the Nash deposit rate equilibrium and market shares analytically. 
% Banks and CB (cash/CBDC) can all have heterogeneous "base utilities."

% A subset of the rates can be kept exogenous.

% See Section 3.2 and Annex I in the paper as a primary reference for this function.

%% Inputs
%  i       scalar, policy rate
%  alpha   1xB or Bx1 vector, base utility for B units
%  beta    scalar, price sensitivity
%  exog    Kx1 or 1xK vector with indexes of unites whose rates are to be exogenous; can be left empty
%  iexog   Kx1 or 1xK vector with rates for those units that are to be kept exogenous
%  mu_exo  scalar, scaling parameter for the nest of exogenous units

%% Outputs
%  iN      1xB vector, Nash deposit rates
%  ms      1xB vector, equilibrium market shares

B = length(alpha);
[r,~] = size(alpha);
if r==B
    alpha = alpha';
end
if ~isempty(exog)
    if length(exog)~=length(iexog)
        error('.')
    end
    if length(exog)>B || length(iexog)>B || max(exog)>B || length(unique(exog))<length(exog) || min(exog)<1
        error('.')
    end
end
decP = 4; % decimal places up to which precision is to be achieved for the rates
iG = linspace(0,i,100);
rates_in = iG(randi([1 100],B,1));
rates_out = NaN(1,B);
if ~isempty(exog)
    rates_in(exog) = iexog;
    rates_out(exog) = iexog;
end
stop = 0;
count = 0;
ms = NaN(1,B);
num_CB = NaN(1,B);

v_ex = exp(mu_exo.*alpha+rates_in*beta); % assume that all exog are in the same nest

denf_CB = exp(1/mu_exo*log(sum(v_ex(exog))));
num_CB(exog) = v_ex(exog)./sum(v_ex(exog)).*denf_CB;

while stop==0
    count = count + 1;
    for b=1:B        
        v_end = exp(alpha+rates_in*beta);        
        v_end(exog) = 0;
        v_end_s = v_end;
        v_end_s(b) = 0;        
        den_tot = sum(v_end_s) + denf_CB;
        denf_tot = sum(v_end) + denf_CB;        
        if sum(ismember(exog,b))==0
            rates_out(b) = i-(1+lambertw(exp(alpha(b)+beta*i-1)/den_tot))/beta; % eq. 13 in the paper
            ms(b) = v_end(b)/denf_tot;
        else
            ms(b) = num_CB(b)/denf_tot;
        end
    end
    if sum(round(rates_in,decP)-round(rates_out,decP))==0        
        iN = rates_out; % like this, equilibrium rates may turn negative; that would be fine
        %iN = max(0,rates_out'); % floor rates at zero
        stop = 1;
    else
        rates_in = rates_out;
    end
end
%disp(['While loops required until convergence: ' num2str(count)])