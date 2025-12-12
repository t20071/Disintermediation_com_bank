function out = fit(q)
global xx zz
if length(q)>2
    num = exp(q(1) + q(2)*xx(:,2) + zz*q(3:end)'); % j=2
    denom = num + exp(q(2)*xx(:,1)); % j=1
else
    num = exp(q(1) + q(2)*xx(:,2)); % j=2
    denom = num + exp(q(2)*xx(:,1)); % j=1
end
out = num./denom;
end