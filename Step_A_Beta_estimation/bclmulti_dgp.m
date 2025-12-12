function [y,p] = bclmulti_dgp(X,Z,a,b,c)

% The function generates random/pseudo data from a parameterized
% conditional/multinomial logit model of the form:

% u_ijt = a_j  +  b x X_jt  +  c_j1 x Z1_t  + ... +  c_jK x ZK_t  +  eps_ijt

%% Inputs
%  X    Tx2 vector
%  Z    TxK vector, can be empty
%  a    scalar, base utility for j=2
%  b    scalar, common slope coef on X
%  c    1xK vector, slope coefs on variables in Z for j=2; to be empty if Z is empty

%% Outputs
%  y    Tx2 vector, shares of j=1 and j=2, random
%  p    Tx2 vector, shares of j=1 and j=2, deterministic fit

T = size(X,1);
if ~isempty(Z)
    K = size(Z,2);
else
    K = 0;
end
N = 1000;
y = NaN(T,2);
p = NaN(T,2);
if isempty(Z)
    f = [0 a] + b*X; % Tx2
else
    f = [0 a] + b*X + Z*[zeros(1,K);c]'; % Tx2
end
for t=1:T
    [~,e] = max(repmat(f(t,:),N,1) + gevinv(rand(N,2)),[],2);
    y(t,:) = [sum(e==1) sum(e==2)]/N;
    p(t,:) = exp(f(t,:))/sum(exp(f(t,:)));
end

end