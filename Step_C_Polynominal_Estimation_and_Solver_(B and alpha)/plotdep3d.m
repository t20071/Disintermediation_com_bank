function [p,r2,fxyz] = plotdep3d(x,y,z,head,labx,laby,labz,pno,tr,ori,cmm,pib,pts,ptscol,plt)

% mgross@imf.org

% The function estimates a polynomial regression of z on x and y of the following form:
% z = d + a_1*x + a_2*x.^2 + ... + a_n*x.^n + b_1*y + b_2*y.^2 + ... + b_n*y.^n + c_1*x.*y + c_2*x.y.^2 + ......
% (see the details in polyfitcon3d.m).
% It then produces a three-dimensional surface plot that visualizes the polynomial fit using the function nice3d.m.

%% Inputs 
%  x        1xG1, independent variable 1 (grid)
%  y        1xG2, independent variable 2 (grid)
%  z        DxG, dependent variable (response)
%  head     scalar, fig title
%  labx     string, label x axis
%  laby     string, label y axis
%  labz     string, label z axis
%  pno      scalar, order of polynomial, at least 1, currently max 5 for plotting to work
%  tr       string, either '' or 'logit' or 'log'
%  ori      1x2 vector, orientation of derivative for x and y, 1 = monotonically increasing, -1 = monotonically decreasing
%  cmm      2x2 matrix, lower and upper bounds at which derivative constraints are to apply; 1st row for x, 2nd row for y
%  pib      scalar, number of points in between cmm(1) and cmm(2) at which derivative constraints are to apply in addition to the bounds (can be zero, otherwise larger 0)
%  pts      matrix, can be []; or 3xK for [x,y,z]-coordinates of up to K points to locate in the space
%  ptscol   1xK cell array, color of the lines to locate the pts
%  plt      scalar, 1=generate plot, 0=don't

%% Outputs
%  p        1x(1+2*pno+pno^2), polynomial coefficient estimates
%  r2       scalar, R-square
%  fxyz     function handle

if pno<1, error('.'), end
logit = @(x) log(x./(1-x)); 
sigmoid = @(x) exp(x)./(1+exp(x)); %#ok<NASGU>
if strcmp(tr,'logit')==1
    z = logit(z);
elseif strcmp(tr,'log')==1
    z = log(z);
end

%% Estimation
[p,r2,~] = polyfitcon3d(x,y,z,pno,ori,cmm,pib);

%% Generate function handle
if strcmp(tr,'logit')==1
    fxyz = eval(['@(x1,x2) sigmoid(' pn(pno) ')']);
elseif strcmp(tr,'log')==1
    fxyz = eval(['@(x1,x2) exp(' pn(pno) ')']);
else
    fxyz = eval(['@(x1,x2) ' pn(pno)]);
end

%% Plot
if plt==1
    nice3d(fxyz,[min(x) max(x)],[min(y) max(y)],head,labx,laby,labz,pts,ptscol)
end