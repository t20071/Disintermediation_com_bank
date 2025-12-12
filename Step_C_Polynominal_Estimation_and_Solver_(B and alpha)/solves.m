function [opt,opts,fvals] = solves(f,lb,ws,M)

% mgross@imf.org

% The function solves a 2D polynomial equation system using fgoalattain.

options = optimoptions('fgoalattain','Display','off');
opts = NaN(M,2);
fvals = NaN(M,2);
for m=1:M
    [opts(m,:),fvals(m,:),~,~,~,~] = fgoalattain(f,[randi([2 6]) 6],[0 0],ws,[],[],[],[],lb,[],[],options);  
end
[~,w] = min(fvals*ws');
opt = opts(w,:);

end