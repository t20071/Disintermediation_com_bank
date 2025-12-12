function out = cr(p)

% The function computes the cash ratio conditional on the parameters of 
% a conditional logit model.

%% Inputs
%  p       1x3 vector, two alphas (intercepts for cash and deposits) and one beta (price sensitivity).

%% Global input
%  hdr     Tx1 vector, historical deposit rates

%% Output
%  out     Tx1 vector, fitted cash ratio

if size(p,1)~=1 || size(p,2)~=3, error('.'), end
global hdr
out = exp(p(1))./( exp(p(1))+exp(p(2)+p(3)*hdr));

end