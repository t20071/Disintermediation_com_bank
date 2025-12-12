function R = assess_IQR(Y,a)

%% Inputs
%  Y   Tx1 vector
%  a   scalar, percentile

%% Outputs
%  R  1x2 vector, ICR over last two-thirds and last one-third of the sample

T = length(Y);
if mod(T,3)~=0
    R = NaN;
    return
end
S = T/3;
q1 = quantile(Y(S:end),1-a/2);
q2 = quantile(Y(S:end),a/2);
w1 = quantile(Y(2*S:end),1-a/2);
w2 = quantile(Y(2*S:end),a/2);
R = [q1-q2 w1-w2];