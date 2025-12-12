

clear
close all
clc

namerun = 'Run_5_cash_like_nest1_alphacash3_alphaCBDC3_B15';
storefolder = 'C:\Users\HP\Desktop\CBDC_2\IMF wp\wp239'; 
store_once_done = 1;

%% Parameters
N = 1500;        % number of non-bank agents
B = 15;          % number of banks
T = 6000;        % periods to simulate
CFBs = [1 1000 2000 3000 4000 5000]; % points at which counterfactual breaks are to take place (include 1 by default)
nest_ = [1 1 1 1 1 1]; % nested (1) or non-nested (0) conditional logit model for non-banks' choice of money --- for each counterfactual window
alphas_ = [3.0 -100;3.0 3.0;3.0 3.0;3.0 3.0;3.0 3.0;3.0 3.0]; % base utility for cash and CBDC (in columns) --- for each counterfactual window (in rows)
beta_ = [75 75 75 75 75 75]; % non-banks' price sensitivity --- for each counterfactual window
gamma_ = [1.221 1.221 1.221 1.221 1.221 1.221]; % annual velocity of money --- for each counterfactual window
delta_ = .75*ones(length(CFBs)); % probability from [0,1] for deposit account move to imply loan transfer --- for each counterfactual window
lambda_ = [0.03 0.03 0.03 0.03 0.03 0.03]; % required reserves in % of deposits, from [0,1] interval -- for each counterfactual window
rB = 0.056;       % banks' reserve borrowing rate (p.a.)
rH = [0.0 0.0335];  % remuneration rates for banks' required and excess reserve holdings (p.a.)
rDC_ = [0 0 rB/4 rB/2 rB/4*3 rB]; % rate on CBDC (p.a.) --- for each counterfactual window
capcon = 1;      % non-banks cap spending to maximize chances that they will be able to service loan interest (1=YES, 0=NO)
qu = 1;          % scale model to quarterly (1=YES, 0=NO)
G_ = [10 10 10 10 10 10]; % interest rate grid length for TS --- for each counterfactual window
M = 38000;       % total money, in currency million/billion/trillion/whatever (no impact on model dynamics)
unit = 'INR bn'; % currency and unit of M
savefigs = 0;    % save plots (1=YES, 0=NO)
prefix = 'Run 3 - '; % for figure file names, relevant if savefigs==1

% Note 1: All parameters above whose names end with an underscore ("_") are the ones for which values are to be provided for each counterfactual
% window. The number of windows is flexible and determined by the number of windows set with the break points (CFBs) in line 15. 

% Note 2: This version of the script produces only one sequence of counterfactual results (windows) that will then be visualized.
% The version presented in the annex of the paper with two superimposed streams of counterfactual windows is available from the
% authors on request. 

%% Prepare simulation
e = NaN(N,N-1);            % N non-bank agents' N-1 potential spending partners
for n=1:N, e(n,:) = setdiff(1:N,n); end
if qu==1                   % convert rates and velocity of money from annual to quarterly
    rB = rB/4;             % banks' reserve borrowing rate
    rH = rH/4;             % remuneration rates for banks' required and excess reserve holdings
end
rates = zeros(T,B+2);      % deposit rates set by banks, and cash and CBDC in last two cols
ratesL = NaN(T,B);         % loan interest rates for banks
ratesL_S = NaN(T,1);       % loan interest rate, weighted aggregate for the system
NatB_L = NaN(T,N);         % non-banks' banks for borrowing
NatB_D = NaN(T,N);         % non-banks' banks for depositing (and holding cash/CBDC, for which it'll contain B+1/B+2)
NperB_L = NaN(T,B);        % number of non-banks at each bank for borrowing
NperB_D = NaN(T,B+2);      % number of non-banks at each bank for depositing or holding cash/CBDC
vol1 = NaN(T,B+2);         % deposit volume at each bank, last two columns for cash and CBDC // before spending
vol2 = NaN(T,B+2);         % deposit volume at each bank, last two columns for cash and CBDC // after spending
expl = NaN(T,1);           % track the explorer
avrate = NaN(T,1);         % bank deposit vol. weighted average deposit rate at the time of setting the rates
cCBcases1 = NaN(T,4);      % tracker: 4 cases for banks' situation regarding CB reserve position
cCBcases2 = NaN(T,4);      % tracker: 4 cases for banks' situation regarding CB reserve position
effgamma = zeros(T,N);     % effective gamma
effgamma_S = zeros(T,1);   % effective gamma at system level
efficbdc = NaN(T,1);       % effective CBDC interest rate
c_expLmiss = NaN(T,1);     % count of non-banks not able to pay full loan interest
MbeforeIL = NaN(T,1);      % NB money holdings before loan interest is due
ILdue = NaN(T,1);          % loan interest due
f = 1; if qu==1, f = 4; end % f, for scaling the rates properly
eqi = NaN(length(CFBs),1); % analytical deposit rate equilibria for each counterfactual window
eqms = NaN(length(CFBs),2); % analytical cash and CBDC shares equilibria for each counterfactual window

%% Flows
FL.NB.incD = zeros(T,N);   % non-banks' deposit interest income
FL.NB.incDC = zeros(T,N);  % non-banks' CBDC interest income
FL.NB.incS = zeros(T,N);   % non-banks' income from CB seigniorage distribution
FL.NB.incC = zeros(T,N);   % non-banks' income from other non-banks spending from them
FL.NB.expC = zeros(T,N);   % non-banks' spending expense
FL.NB.expL = zeros(T,N);   % non-banks' loan interest expense
FL.NB.incDIV = zeros(T,N); % non-banks' income from banks paying dividends
FL.BA.incR = zeros(T,B);   % banks' reserve interest income
FL.BA.incL = zeros(T,B);   % banks' loan interest income
FL.BA.expR = zeros(T,B);   % banks' reserve borrowing expense
FL.BA.expD = zeros(T,B);   % banks' deposit interest expense
FL.BA.ni = NaN(T,B);       % banks' net income before dividends
FL.BA.div = zeros(T,B);    % banks' dividend payouts
FL.CB.incR = zeros(T,1);   % CB's interest income from reserve lending
FL.CB.expR = zeros(T,1);   % CB's interest expense for remunerating banks' reserve holdings
FL.CB.expDC = zeros(T,1);  % CB's interest expense for CBDC
FL.CB.seign = zeros(T,1);  % CB's seigniorage distribution
trackRin = NaN(T,B+1,2);   % reserve inflows, due to deposit account moves and spending (the latter two in 3rd dim)
trackRout = NaN(T,B+1,2);  % reserve outflows, due to deposit account moves and spending (the latter two in 3rd dim)

%% Balance sheets
BS.NB.M = zeros(1+T,N);    % non-banks' asset: money holdings (deposits or cash)
BS.NB.L = zeros(1+T,N);    % non-banks' liability: loans from banks
BS.BA.R = zeros(1+T,B);    % banks' asset: reserve holdings
BS.BA.L = zeros(1+T,B);    % banks' asset: loans granted to non-banks, to create their deposits
BS.BA.D = zeros(1+T,B);    % banks' liability: non-banks' deposits at banks
BS.BA.B = zeros(1+T,B);    % banks' liability: reserve borrowing from CB
BS.CB.B = zeros(1+T,1);    % CB's asset: reserve claims vis-a-vis banks
BS.CB.R = zeros(1+T,1);    % CB's liability: banks' reserve deposits at CB
BS.CB.C = zeros(1+T,1);    % CB's liability: non-banks' cash
BS.CB.DC = zeros(1+T,1);   % CB's liability: non-banks' CBDC
trackPAV_R = zeros(T,B);   % banks' period average reserve holdings
trackPAV_B = zeros(T,B);   % banks' period average reserve borrowings

%% Initial non-banks->bank assignment for loans and deposits, for period 1
d = distrib(N,B); % 1xB, assigning N non-banks to B banks
q = [cumsum(d)-d+1;cumsum(d)]; % 2xB
for b=1:B
    NatB_L(1,q(1,b):q(2,b)) = b; % 1xN per t
    NperB_L(1,b) = sum(d(b)); % 1xB
end
NatB_D(1,:) = NatB_L(1,:);
NperB_D(1,1:end-2) = NperB_L(1,:);
NperB_D(1,end-1:end) = 0; % non-banks hold zero cash and CBDC yet at the outset
NatB_D_Last = NatB_D(1,:); % last bank that all non-banks were with for depositing; will be updated throughout the simulation

%% T0 balance sheets
BS.NB.L(1,:) = M/N;
BS.NB.M(1,:) = BS.NB.L(1,:);
BS.BA.L(1,:) = sum(repmat(BS.NB.L(1,:),B,1).*(NatB_L(1,:)==(1:B)'),2)';
BS.BA.D(1,:) = BS.BA.L(1,:);
BS.BA.R(1,:) = lambda_(1)*BS.BA.D(1,:);
BS.BA.B(1,:) = lambda_(1)*BS.BA.D(1,:);
BS.CB.R(1)   = sum(BS.BA.R(1,:));
BS.CB.C(1)   = 0;
BS.CB.DC(1)  = 0;
BS.CB.B(1)   = sum(BS.BA.B(1,:));

%% Simulation
for t=1:T
    progressline(t,T)
    
    % Take account of counterfactual breaks
    if sum(CFBs==t)==1 % erase memory at the counterfactual break points
        w = where(CFBs,t);
        G = G_(w); % grid length
        iG = linspace(0,rB,G)'; % interest rate grid
        mA = ones(2,G); % learning matrix, beta distribution first parameter
        mB = ones(2,G); % learning matrix, beta distribution second parameter
        nest = nest_(w);
        if nest==0
            mu = 1;
        else
            mu = 100;
        end
        alphas = alphas_(w,:);
        beta = beta_(w);
        delta = delta_(w);
        lambda = lambda_(w);
        if qu==1
            rDC = rDC_(w)/4;
            gamma = gamma_(w)/4;
        else
            rDC = rDC_(w);
            gamma = gamma_(w);
        end
        [ieq,mseq] = nash_analytical_heterog_partialexog_nested(f*rB,[zeros(1,B) alphas],beta,[B+1 B+2],[0 f*rDC],mu);
        u = find(CFBs==t);
        eqi(u) = ieq(1);
        eqms(u,:) = mseq(end-1:end);
    end
    rates(t,end) = rDC;
    
    % Step 0: Carry over balance sheets
    carryover
    
    % Step 1: Banks set deposit rates
    if t==1        
        [~,g] = min(abs(iG-eqi(1)));
        rates(t,1:B) = iG(g);
        ts = 0;
    elseif t==2
        rates(t,1:B) = rates(t-1,1:B); % TS is on by design of TS Part 2 further down in the code
        ts = 0; % but is set to zero one more time
    elseif t==3
        rates(t,1:B) = rates(t-1,1:B);
    elseif t>1 && sum(CFBs==t)==1
        [~,g] = min(abs(iG-rB/2));
        rates(t,1:B) = iG(g);
        ts = 0;
    else
        if ts==0 % previous period was ts=1 and a success for explorer
            rates(t,1:B) = rates(t-1,bb);
        else % previous period was ts=1 and a failure for explorer, or it was a neutral period after which a new TS will now take place
            rates(t,1:B) = rs(1:B); % rates vector from the last "no TS" period
        end
    end
    if ts==1 % TS Learning Part I
        bb = randi([1 B]); % pick explorer
        expl(t) = bb;
        [~,g] = min(abs(iG-rates(t,bb)));
        if g==1 % lower edge, step up
            pB = 1;
        elseif g==G % upper edge, step down
            pB = 2;
        else % interior, step according to beta draw
            [~,pB] = max([betarnd(mA(1,g),mB(1,g)) betarnd(mA(2,g),mB(2,g))]);
        end
        if pB==1
            rates(t,bb) = iG(g+1);
        else
            rates(t,bb) = iG(g-1);
        end
    end
    
    % Step 2: Non-banks choose where to deposit or hold cash and from which bank to have their loans
    if t>1
        % deposits          
        [NatB_D(t,:),~] = sim_data_CL_nested(N,[ zeros(B,1) f*rates(t,1:end-2)' ] , [ alphas' f*rates(t,end-1:end)' ],[1;beta],[1 mu]);
        NperB_D(t,:) = sum(NatB_D(t,:)==(1:B+2)',2)';
        NatB_D_Last(NatB_D(t,:)<=B) = NatB_D(t,NatB_D(t,:)<=B);        
        % loans
        sig = rand(1,N)<delta;
        NatB_L(t,sig==1) = NatB_D_Last(sig==1);
        NatB_L(t,sig==0) = NatB_L(t-1,sig==0);
        clear sig
        NperB_L(t,:) = sum(NatB_L(t,:)==(1:B)',2)';
    end
    
    % Step 3: Non-banks move their deposits (conversion to/from cash and CBDC is accounted for) and loans
    if t>1
        % deposit account moves
        for b=1:B+2
            trackRin(t,b,1)  = sum(BS.NB.M(t+1,NatB_D(t-1,:)~=b & NatB_D(t,:)==b)); % flows toward b (incl. from cash and CBDC)
            trackRout(t,b,1) = sum(BS.NB.M(t+1,NatB_D(t-1,:)==b & NatB_D(t,:)~=b)); % outflows away from b (incl. to cash and CBDC)
            if b<=B
                BS.BA.D(t+1,b) = BS.BA.D(t+1,b) + trackRin(t,b,1) - trackRout(t,b,1); % bank's deposit pool
            end
        end
        BS.BA.R(t+1,:) = BS.BA.R(t+1,:) + BS.BA.D(t+1,:) - BS.BA.D(t,:); % reserve flows, accounting for conversion from/to cash and CBDC
        BS.CB.R(t+1) = BS.CB.R(t+1) - sum(trackRin(t,B+1:B+2,1)) + sum(trackRout(t,B+1:B+2,1)); % cash and CBDC
        BS.CB.C(t+1) = BS.CB.C(t+1) + trackRin(t,B+1,1) - trackRout(t,B+1,1); % cash
        BS.CB.DC(t+1) = BS.CB.DC(t+1) + trackRin(t,B+2,1) - trackRout(t,B+2,1); % CBDC
        % transfer of loans ("refinancing")
        if sum(NatB_L(t-1,:)~=NatB_L(t,:))>0
            for b=1:B
                Lin = sum(BS.NB.L(t+1,NatB_L(t-1,:)~=b & NatB_L(t,:)==b)); % b buys loans
                Lout = sum(BS.NB.L(t+1,NatB_L(t-1,:)==b & NatB_L(t,:)~=b)); % b sells loans
                BS.BA.L(t+1,b) = BS.BA.L(t+1,b) + Lin - Lout;
                trackRin(t,b,1) = trackRin(t,b,1) + Lout; % bank b receives reserves when selling loans
                trackRout(t,b,1) = trackRout(t,b,1) + Lin; % bank b pays for incoming loans with outflowing reserves
            end
            clear Lin Lout
            BS.BA.R(t+1,:) = BS.BA.R(t+1,:) - BS.BA.L(t+1,:) + BS.BA.L(t,:);
        end
    end
    vol1(t,:) = [BS.BA.D(t+1,:) sum(BS.NB.M(t+1,NatB_D(t,:)==(B+1))) sum(BS.NB.M(t+1,NatB_D(t,:)==(B+2)))]; % 1x(B+1), deposits/cash/CBDC holdings before spending
    
    % Step 4: Net CB reserve position -- after deposit account moves and before spending
    net_CBD
    cCBcases1(t,:) = countsC;
    u0 = BS.BA.R(t+1,:); % banks' reserve holdings before non-banks' spending
    u1 = BS.BA.B(t+1,:); % banks' CB debt before non-banks' spending
    u2 = BS.BA.D(t+1,:); % banks' deposit pools before non-banks' spending
    
    % Step 5: Non-bank agents' spending    
    cmax = +inf;
    if capcon==1
        cmax = max(0,( rB*BS.NB.L(t+1,:) - BS.NB.M(t+1,:).*(1+rates(t,NatB_D(t,:))) ) ./ (-0.5*rates(t,NatB_D(t,:))-1));
    end
    FL.NB.expC(t,:) = min(cmax,gamma*BS.NB.M(t+1,:)); % portion of non-banks' money holdings (deposits+cash) that will be spent
    effgamma(t,:) = FL.NB.expC(t,:)./BS.NB.M(t+1,:); % effective gamma
    effgamma_S(t) = sum(FL.NB.expC(t,:))/sum(BS.NB.M(t+1,:)); % effective gamma system aggregate
    Ntar = e(sub2ind(size(e),1:N,randi(N-1,N,1)')); % 1xN; non-banks' choose spending parters (not spending with themselves)
    BS.NB.M(t+1,:) = BS.NB.M(t+1,:) - FL.NB.expC(t,:); % money outflows
    FL.NB.incC(t,:) = sum(repmat(FL.NB.expC(t,:),N,1).*(Ntar==(1:N)'),2)';
    BS.NB.M(t+1,:) = BS.NB.M(t+1,:) + FL.NB.incC(t,:); % money inflows
    for b=1:B+2
        trackRin(t,b,2) = sum(FL.NB.expC(t,NatB_D(t,:)~=b & NatB_D(t,Ntar)==b)); % generally less than non-banks' flows above, because some spending of some non-banks is with HHs at the same banks
        trackRout(t,b,2) = sum(FL.NB.expC(t,NatB_D(t,:)==b & NatB_D(t,Ntar)~=b));
        if b<=B
            BS.BA.D(t+1,b) = sum(BS.NB.M(t+1,NatB_D(t,:)==b)); % direct assignment of stocks
        end
    end
    BS.BA.R(t+1,:) = BS.BA.R(t+1,:) + BS.BA.D(t+1,:) - u2; % reserve flows, accounting for conversion from/to cash and CBDC
    BS.CB.R(t+1) = BS.CB.R(t+1) - sum(trackRin(t,B+1:B+2,2)) + sum(trackRout(t,B+1:B+2,2));
    BS.CB.C(t+1) = BS.CB.C(t+1) + trackRin(t,B+1,2) - trackRout(t,B+1,2);
    BS.CB.DC(t+1) = BS.CB.DC(t+1) + trackRin(t,B+2,2) - trackRout(t,B+2,2);
    clear cmax
    vol2(t,:) = [BS.BA.D(t+1,:) sum(BS.NB.M(t+1,NatB_D(t,:)==(B+1))) sum(BS.NB.M(t+1,NatB_D(t,:)==(B+2)))]; % 1x(B+1), deposits/cash/CBDC holdings after spending
    
    % Step 6: Net CB reserve position -- after spending
    net_CBD
    cCBcases2(t,:) = countsC;
    clear countsC
    
    % Step 7: Interest flows and dividends
    interest_flows
    
    % Step 8: TS Learning Part II
    if ts==1 % alter the beta distribution
        if FL.BA.ni(t,bb)>ps(bb) % success
            mA(pB,g) = mA(pB,g) + 1;
            ts = 0; % success followed by "no TS" to obtain new profit reference
        else % failure
            mB(pB,g) = mB(pB,g) + 1;
            ts = 1; % failure, TS right next period, but with possibly further lagged profit reference (ps)
        end
    else % no TS / rates for all banks were equal over the now-ending period
        ps = FL.BA.ni(t,:); % track profits
        rs = rates(t,:); % track rates
        ts = 1; % "no TS" followed by TS by default
    end
        
end

%% Convert rates and gamma back to annual
if qu==1
    rates = 4*rates;
    avrate = 4*avrate;
    ratesL = 4*ratesL;
    ratesL_S = 4*ratesL_S;
    efficbdc = 4*efficbdc;
    effgamma = 4*effgamma;
    effgamma_S = 4*effgamma_S;
end

%% Plots
counterfactual_plots

%% Save the file 
if store_once_done==1
    save([storefolder '\' namerun '.mat'])
end