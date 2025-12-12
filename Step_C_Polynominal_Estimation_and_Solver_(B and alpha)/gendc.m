function [C,c] = gendc(V,ori,cmm,pib)

% The function generates the matrices that hold the derivative constraints 
% of a bivaraite polynomial of order V.

%% Inputs
%  pno      scalar, polynomial order, must be larger 0, i.e., at least linear
%  ori      1x2 vector, orientation w.r.t. x and y; 1 = monotonically increasing, -1 = monotonically decreasing
%  cmm      2x2 matrix, lower and upper bounds at which derivative constraints are to apply; 1st row for x, 2nd row for y
%  pib      scalar, number of points in between cmm(:,1) and cmm(:,2) at which derivative constraints are to apply in addition to the bounds (can be zero, otherwise larger 0)

%% Outputs
%  C        Hx(1+2*pno+pno^2) matrix
%  c        (1+2*pno+pno^2)x1 vector

rax = linspace(cmm(1,1),cmm(1,2),pib+2); % range for x
ray = linspace(cmm(2,1),cmm(2,2),pib+2); % range for y
c1 = zeros(length(rax)*length(ray),1+2*V+V^2); % derivatives w.r.t x
c2 = c1; % derivatives w.r.t y
count = 1;
for i=1:length(rax)
    for j=1:length(ray)
        % x^(.)
        u = 1;
        for e=2:2+V-1
            c1(count,e) = u*rax(i)^(u-1);
            u = u+1;
        end
        % y^(.)
        u = 1;
        for e=2+V:1+2*V
            c2(count,e) = u*ray(j)^(u-1);
            u = u+1;
        end
        % interaction terms w.r.t. x
        u = 1;
        for q1=1:V
            for q2=1:V
                c1(count,1+2*V+u) = (q1*rax(i)^(q1-1)) * ray(j)^q2;
                u = u+1;
            end
        end
        % interaction terms w.r.t. y
        u = 1;
        for q1=1:V
            for q2=1:V
                c2(count,1+2*V+u) = (rax(i)^q1) * (q2*ray(j)^(q2-1));
                u = u+1;
            end
        end
        count = count+1;
    end
end
% Set requested slope
if ori(1)==1, c1 = -c1; end
if ori(2)==1, c2 = -c2; end
C = unique([c1;c2],'rows');
c = zeros(size(C,1),1);

end