function [r2,r2adj] = rsquare(y,fit,k)

% Note: k - counting the number of parameters excluding the intercept

[a,b] = size(y); [c,d] = size(fit);
if min([a b])~=1 || min([c d])~=1; error('error'); end
if size(y,2)>1; y = y'; end
if size(fit,2)>1; fit = fit'; end
xx = [y fit];
xx(sum(isnan(xx),2)~=0,:) = [];
r2 = 1-sum((xx(:,2)-xx(:,1)).^2)/sum((xx(:,1)-mean(xx(:,1))).^2);
r2adj = 1-(1-r2)*(length(xx(:,1))-1)/(length(xx(:,1))-1-k);

end