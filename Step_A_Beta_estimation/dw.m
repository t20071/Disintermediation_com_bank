function dw = dw(R)

% The function computes the DW for a row or column vector of residuals R.

if size(R,2)>1, R = R'; end
r0 = R; r0(sum(isnan(r0),2)~=0,:) = [];
r1 = R(2:end);
r2 = R(1:end-1);
z = [r1 r2];
z(sum(isnan(z),2)~=0,:) = [];
r1 = z(:,1);
r2 = z(:,2);
dw = ((r1-r2)'*(r1-r2))/(r0'*r0);