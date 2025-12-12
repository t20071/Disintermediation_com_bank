function F = eqns(x)

global fct_C
global fct_D
global tar_C
global tar_D

F(1) = 1000*abs((fct_C(x(1),x(2)) - tar_C)/tar_C);
F(2) = 1000*abs((fct_D(x(1),x(2)) - tar_D)/tar_D);