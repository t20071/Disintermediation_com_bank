%% Estimate polynomials for Nash deposit rate and Nash cash ratio surfaces and solve them for self-defined targets

% The script estimates two polynomials (in this application for Nash deposit rates and Nash cash ratios, both as a function
% of the number of banks and the base utility of cash). Upon estimation of the two polynomial functions, the script then
% solves them for the number of banks and cash's base utility so that the functions match self-defined targets for Nash deposit 
% rates and Nash cash ratios. Three different methods can be chosen for the solver step (fsolve, genetic algorithm, or fgoalattain). 
% All three methods generally result in quantitatively equivalent outcomes.

% Note that it is advisable to exclude the bank B=1 rows from the matrices, because the solution will likely not be near B=1 and the
% nonlinearity of the two functions near the B=1 region are particularly strong. Giving the polynomial the chance to fit the remaining
% (still nonlinear) surface well is therefore beneficial.

clear all %#ok<CLALL>
close all
warning off
clc

%% Inputs: Simulated matrices from the ABM
filename = 'India_Calibration_Matrices_Run_1_nest_1.xlsx';
sheetname = 'Combined';
rangeD = 'B3:L14'; % deposit rate matrix 
rangeC = 'B19:L30'; % cash ratio matrix

%% Set target deposit rates and cash ratios
global tar_D
global tar_C
tar_D = 0.059895; % target equilibrium deposit rate; policy rate in the example input file was at 10%
tar_C = 0.140057451873371 ;  % target equilibrium cash ratio
solver_method = 3; % set to 1, 2, or 3. 1 = fsolve. 2 = Genetic Algorithm. 3 = fgoalattain.

%% Other settings
pno = 3; % polynomial order
dc = 1; % derivative constraint on (=1) or off (=0)
pib = 5; % points in between min and max RHS for derivative constraints
tr_d = 'log'; % transformation for deposit rate ('' or 'log')
tr_c = 'logit'; % transformation for cash ratio ('' or 'logit')


%% Process data
disp('Loading data...')
[d,~,~] = xlsread(filename,sheetname,rangeD); % sim deposit rates
[c,~,~] = xlsread(filename,sheetname,rangeC); % sim cash ratios
A = reshape(repmat(c(1,2:end)',1,size(c(2:end,:),1))',[],1); % grid: alpha
B = repmat(c(2:end,1),size(c,2)-1,1); % grid: banks
C = reshape(c(2:end,2:end),[],1); % sim data: cash ratio
D = reshape(d(2:end,2:end),[],1); % sim data: deposit rates
E = [A B C D];
E(sum(isnan(E),2)~=0,:) = [];
A = E(:,1);
B = E(:,2);
C = E(:,3);
D = E(:,4);
clear E
if strcmp(tr_d,'log')==1
    D(D==0) = NaN;
    D(isnan(D)) = min(0.001,min(D));
end
if strcmp(tr_c,'logit')==1
    C(C==0) = NaN;
    C(isnan(C)) = min(0.001,min(C));
    C(C==1) = NaN;
    C(isnan(C)) = max(0.999,max(C));
end
global fct_D
global fct_C

%% Polynomial: Deposit rates
disp('Estimating Nash deposit rate polynomial...')
figure(1)
set(gcf,'Position',[53 353 1450 471])
subplot(1,2,1)
if dc==1
    [~,r2,fct_D] = plotdep3d(B',A',D','Nash Deposit Rate','Number of Banks','Base Utility of Cash','Nash Deposit Rate',pno,tr_d,[+1 +1],[min(B) max(B); min(A) max(A)],pib,[],[],1);
    title(['Deposit Rate: PN=' num2str(pno) ' / TR=' tr_d ' / DC On / R2=' num2str(r2)])
else
    [~,r2,fct_D] = plotdep3d(B',A',D','Nash Deposit Rate','Number of Banks','Base Utility of Cash','Nash Deposit Rate',pno,tr_d,[],[],[],[],[],1);
    title(['Deposit Rate: PN=' num2str(pno) ' / TR=' tr_d ' / DC Off / R2=' num2str(r2)])
end
hold on
scatter3(B,A,D,40,'*g')

%% Polynomial: Cash ratios
disp('Estimating Nash cash rate polynomial...')
subplot(1,2,2)
if dc==1
    [~,r2,fct_C] = plotdep3d(B',A',C','Cash Ratio','Number of Banks','Base Utility of Cash','Cash Ratio',pno,tr_c,[-1 +1],[min(B) max(B); min(A) max(A)],pib,[],[],1);
    title(['Cash Ratio: PN=' num2str(pno) ' / TR=' tr_c ' / DC On / R2=' num2str(r2)])
else
    [~,r2,fct_C] = plotdep3d(B',A',C','Cash Ratio','Number of Banks','Base Utility of Cash','Cash Ratio',pno,tr_c,[],[],[],[],[],1);
    title(['Cash Ratio: PN=' num2str(pno) ' / TR=' tr_c ' / DC Off / R2=' num2str(r2)])
end
hold on
scatter3(B,A,C,40,'*g')

%% Common settings for all methods
M = 50; % multistart
ws = [.5 .5]; % weights
lb = [1 0]; % lower bounds for B and alpha

%% Option 1: Solve with fsolve
if solver_method==1
    disp('Solving with fsolve...')    
    opts = NaN(M,2);
    fvals = NaN(M,2);
    for m=1:M
        [opts(m,:),fvals(m,:)] = fsolve(@eqns,[randi([1 100]) rand*10]);
    end
    fvals(opts(:,1)<1 | opts(:,2)<0,:) = NaN;
    [~,w] = min(fvals*ws');
    opt = opts(w,:);
    disp(['B * = ' num2str(opt(1))])
    disp(['alpha cash * = ' num2str(opt(2))])
end

%% Option 2: Solve with Genetic Algorithm (GA)
if solver_method==2
    disp('Solving with Genetic Algorithm...')    
    options = optimoptions('gamultiobj','MaxGenerations',500,'CrossoverFcn', { @crossoverintermediate [] },'Display','off'); 
    xys = NaN(M,2);
    fvals = NaN(M,2);
    for m=1:M
        [back1,back2,~,~,~,~] = gamultiobj(@eqns,2,[],[],[],[],lb,[],[],options);
        [~,w] = min(back2*ws);
        xys(m,:) = back1(w,:);
        fvals(m,:) = back2(w,:);
    end
    [~,w] = min(fvals*ws);
    opt = xys(w,:);
    disp(['B * = ' num2str(opt(1))])
    disp(['alpha cash * = ' num2str(opt(2))])
end

%% Option 3: Solve with fgoalattain
% Note: rather exclude B=1 for this method to work robustly
if solver_method==3
    disp('Solving with fgoalattain...')
    [opt,~,~] = solves(@eqns,lb,ws,M);
    disp(['B * = ' num2str(opt(1))])
    disp(['alpha cash * = ' num2str(opt(2))])
end

%%  Add coordinates of B* and alpha* to the surface plots
% Deposit rate
subplot(1,2,1)
pts = [opt(1) opt(2) tar_D]';
hold on
scatter3(pts(1),pts(2),pts(3))
plot3([pts(1) pts(1)],[max(A) pts(2)],[pts(3) pts(3)],'-r','linewidth',2.5)
plot3([max(B) pts(1)],[pts(2) pts(2)],[pts(3) pts(3)],'-r','linewidth',2.5)
text(ceil(opt(1))+1,opt(2),tar_D,{['B* = ' num2str(opt(1))];['alpha* = ' num2str(opt(2))]})
% Cash ratio
subplot(1,2,2)
pts = [opt(1) opt(2) tar_C]';
hold on
scatter3(pts(1),pts(2),pts(3))
plot3([pts(1) pts(1)],[max(A) pts(2)],[pts(3) pts(3)],'-r','linewidth',2.5)
plot3([max(B) pts(1)],[pts(2) pts(2)],[pts(3) pts(3)],'-r','linewidth',2.5)
text(ceil(opt(1))+1,opt(2),tar_C,{['B* = ' num2str(opt(1))];['alpha* = ' num2str(opt(2))]})