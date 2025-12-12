function [p,r2,fit] = polyfitcon3d(x,y,z,pno,ori,cmm,pib)

% mgross@imf.org

% The function estimates a polynomial regression of z on x and y subject to
% linear inequality constraints on the polynomial's derivatives on a
% self-defined support and for a self-defined number of points on an
% equally-spaced grid in between the support. The support can but does not
% have to correspond to the min-max range of x and y. The function can be
% run without the derivative constraints by leaving the ori input empty.

% Form of the fct: z = d + a_1*x + a_2*x.^2 + ... + a_n*x.^n + b_1*y +
% b_2*y.^2 + ... + b_n*y.^n + c_1*x.*y + c_2*x.y.^2 + ......

%% Inputs
%  x        1xG vector, RHS variable 1
%  y        1xG vector, RHS variable 2
%  z        1xG vector, LHS data
%  pno      scalar, polynomial order, must be larger 0, i.e., at least linear
%  ori      1x2 vector, orientation w.r.t. x and y; 1 = monotonically increasing, -1 = monotonically decreasing
%  cmm      2x2 matrix, lower and upper bounds at which derivative constraints are to apply; 1st row for x, 2nd row for y
%  pib      scalar, number of points in between cmm(:,1) and cmm(:,2) at which derivative constraints are to apply in addition to the bounds (can be zero, otherwise larger 0)

%% Outputs
%  p        1x(1+2*pno+pno^2) vector, polynomial coefficient estimates
%  r2       scalar, R-square
%  fit      Gx1 vector, fit

%% Check and process inputs
G = length(x);
if length(y)~=G || length(z)~=G || ~isscalar(pno) || pno<1, error('.'), end
if ~isempty(ori)
    if cmm(1,1)>=cmm(1,2) || cmm(2,1)>=cmm(2,2) || ~isscalar(pib), error('.'), end
end
global zm pnorder
pnorder = pno;
zm = [x' y' z']; zm(sum(isnan(zm),2)>0,:) = [];
if isempty(zm), p = []; r2 = []; fit = []; return, end

%% Set up derivative constraints
if ~isempty(ori)
    [C,c] = gendc(pno,ori,cmm,pib);
end

%% Estimation
f = ones(size(zm,1),1); % intercept
for o=1:pno, f = [f zm(:,1).^o]; end %#ok<*AGROW> % x
for o=1:pno, f = [f zm(:,2).^o]; end % y
for o1=1:pno
    for o2=1:pno
        f = [f (zm(:,1).^o1).*(zm(:,2).^o2)]; % interaction terms
    end
end
p = f\zm(:,3); % unconstrained, of size (1+2*pno+pno^2)x1
if ~isempty(ori) % derivative-constrained
    M = 100; % multistart
    r = NaN(M,1); % R2s
    coefs = NaN(1+2*pno+pno^2,M);
    for m=1:M
        x0 = p+randn(1+2*pno+pno^2,1);
        coefs(:,m) = fmincon(@objf3dfull,x0,C,c,[],[],[],[],[],optimoptions('fmincon','display','off'));
        r(m) = rsquare(zm(:,3),f*coefs(:,m),2*pno+pno^2);        
    end
    [~,w] = max(r);
    p = coefs(:,w);
end
fit = f*p;
r2 = rsquare(zm(:,3),fit,2*pno+pno^2);
p = p';

clear zm pnorder

end

function ssr = objf3dfull(b)
global zm pnorder
f = ones(size(zm,1),1);
for o=1:pnorder, f = [f zm(:,1).^o]; end
for o=1:pnorder, f = [f zm(:,2).^o]; end
for o1=1:pnorder
    for o2=1:pnorder
        f = [f (zm(:,1).^o1).*(zm(:,2).^o2)];
    end
end
ssr = 100*sum((zm(:,3)-f*b).^2);
end
