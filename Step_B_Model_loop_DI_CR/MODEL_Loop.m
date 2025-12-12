%% Monetary ABM -- Loop Version

% Set a grid for the number of banks (BB) and the base utility of cash
% (alpha_cash) below, and then export tables tab1 and tab3 to run the
% subsequent estimation and solver functions on.

clear
close all
clc

namerun = 'Run3_nest_1_mu_100';
storefolder = 'C:\Users\HP\Desktop\CBDC_2\IMF wp\wp239\Estimation_Steps_A_and_C\Step_B_Model_loop_DI_CR'; 
store_once_done = 1;

%% Model parameters
N = 1000;       % number of non-bank agents
T = 3000;       % periods to simulate
S = 750;        % periods at the end on which to compute average deposit rate and cash ratio
nest = 1;       % nested (1) or non-nested (0) conditional logit model for non-banks' choice of money
alpha_cash = [-10 -5 0 1 2 3 4 5 7.5 10]; % base utility for cash
BB = [1 2 3 4 5 7 10 13 15 20 25 30]; % number of banks
alpha_cbdc = -100; % base utility for CBDC
beta = 75;     % non-banks' price sensitivity
gamma = 1.221;   % annual velocity of money
delta = 0.75;    % probability from [0,1] for deposit account move to imply loan transfer
lambda = 0.03;  % required reserves in % of deposits, from [0,1] interval
rB = 0.056;       % banks' reserve borrowing rate (p.a.)
rH = [0.0 0.0335]; % remuneration rates for banks' required and excess reserve holdings (p.a.)
rDC = 0.0;      % rate on CBDC (p.a.)
capcon = 1;     % cap consumption to maximize chances that non-banks will service loan interest (1=YES, 0=NO)
dynG = 1;       % find G dynamically (=1), or fix it (=0)
G = 30;         % when dynG==0, set grid length directly; irrelevant otherwise
qu = 1;         % scale model to quarterly (1=YES, 0=NO)
M = 290000;      % total money, in currency million/billion/trillion/whatever (no impact on model dynamics)

%% Prepare simulation
tab1  = NaN(length(BB),length(alpha_cash)); % Nash deposit rate
tab2  = NaN(length(BB),length(alpha_cash)); % ...analytical
tab3  = NaN(length(BB),length(alpha_cash)); % Cash/M
tab4  = NaN(length(BB),length(alpha_cash)); % ...analytical
tab5  = NaN(length(BB),length(alpha_cash)); % CBDC/M
tab6  = NaN(length(BB),length(alpha_cash)); % ...analytical
tab7  = NaN(length(BB),length(alpha_cash)); % end-of-period reserve holdings
tab8  = NaN(length(BB),length(alpha_cash)); % effective system lending rate
tab9  = NaN(length(BB),length(alpha_cash)); % number of non-banks paying less than full loan interest
tab10 = NaN(length(BB),length(alpha_cash)); % G*
tab11 = NaN(length(BB),length(alpha_cash)); % convergence to G* achieved (1) or not (0)
tab12 = NaN(length(BB),length(alpha_cash)); % number of periods in G* position at the end (if G* met, otherwise NA)
if sum(beta==0)>0, error('Price sensitivity must not be zero'), end
e = NaN(N,N-1); % N non-bank agents' N-1 potential consumption partners
for n=1:N
    e(n,:) = setdiff(1:N,n);
end
f = 1;
if qu==1 % convert rates and velocity of money from annual to quarterly
    rB = rB/4; % banks' reserve borrowing rate
    rH = rH/4; % remuneration rates for banks' required and excess reserve holdings
    rDC = rDC/4; % rate on CBDC
    gamma = gamma/4; % velocity of money
    f = 4;
end
alphas = [NaN alpha_cbdc];
mu = 1;
if nest==1, mu = 100; end  % scaling parameter for nested logit
count = 1;

%% Simulation
for i=1:length(BB)
    
    B = BB(i);
    
    for j=1:length(alpha_cash)
        
        alphas(1) = alpha_cash(j);
        
        clc
        disp(['Run ' num2str(count) ' of ' num2str(length(BB)*length(alpha_cash))])
        count = count+1;
        
        %% Prepare
        rates = NaN(T,B+2);        % deposit rates set by banks
        rates(:,end-1) = 0;        % rate on cash
        rates(:,end) = rDC;        % rate on CBDC
        ratesL = NaN(T,B);         % loan interest rates for banks
        ratesL_S = NaN(T,1);       % loan interest rate, weighted aggregate for the system
        NatB_L = NaN(T,N);         % non-banks' banks for borrowing
        NatB_D = NaN(T,N);         % non-banks' banks for depositing (and holding cash/CBDC, for which it'll contain B+1/B+2)
        NperB_L = NaN(T,B);        % number of non-banks at each bank for borrowing
        NperB_D = NaN(T,B+2);      % number of non-banks at each bank for depositing or holding cash/CBDC
        vol1 = NaN(T,B+2);         % deposit volume at each bank, last two columns for cash and CBDC // before consumption
        vol2 = NaN(T,B+2);         % deposit volume at each bank, last two columns for cash and CBDC // after consumption
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
        iqrconv = NaN(T,2);        % IQR convergence
        iqr = +Inf;                % initial IQR reference value
        countX = 0;                % count of periods per G
        modi = 0;                  % to signal that G is to be increased during the sim.
        stick = 0;                 % indicator that will turn 1 once the final G is deemed to be found and stuck to
        if dynG==1, G = 5; end     % initial G for dynamic gridding mode
        
        %% Flows
        FL.NB.incD = zeros(T,N);   % non-banks' deposit interest income
        FL.NB.incDC = zeros(T,N);  % non-banks' CBDC interest income
        FL.NB.incS = zeros(T,N);   % non-banks' income from CB seigniorage distribution
        FL.NB.incC = zeros(T,N);   % non-banks' income from other non-banks consuming from them
        FL.NB.expC = zeros(T,N);   % non-banks' consumption expense
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
        trackRin = NaN(T,B+1,2);   % reserve inflows, due to deposit account moves and consumption (the latter two in 3rd dim)
        trackRout = NaN(T,B+1,2);  % reserve outflows, due to deposit account moves and consumption (the latter two in 3rd dim)
        
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
        BS.BA.R(1,:) = lambda*BS.BA.D(1,:);
        BS.BA.B(1,:) = lambda*BS.BA.D(1,:);
        BS.CB.R(1)   = sum(BS.BA.R(1,:));
        BS.CB.C(1)   = 0;
        BS.CB.DC(1)  = 0;
        BS.CB.B(1)   = sum(BS.BA.B(1,:));
        
        %% Simulation
        for t=1:T
            
            % Step 0: Carry over balance sheets
            carryover
            
            % Step 1: Banks set deposit rates
            if t==1 || modi==1
                iG = linspace(0,rB,G)'; % interest rate grid
                mA = ones(2,G);         % learning matrix, beta distribution first parameter
                mB = ones(2,G);         % learning matrix, beta distribution second parameter
                mA(1,end) = NaN; mA(2,1) = NaN; mB(1,end) = NaN; mB(2,1) = NaN;
                if t==1
                    rates(t,1:end-2) = iG(floor(G/2)); % could be taken from a random position in the grid as well
                end
                if modi==1
                    [~,g] = min(abs(iG-mean(rates(t-1,1:B))));
                    rates(t,1:B) = iG(g);
                end
                ts = 0;
                modi = 0;
            elseif t==2
                rates(t,:) = rates(t-1,:); % TS is on by design of TS Part 2 further down in the code
                ts = 0; % but is set to zero one more time
            elseif t==3
                rates(t,:) = rates(t-1,:);
                ts = 1;
            else
                if ts==0 % previous period was ts=1 and a success for explorer
                    rates(t,1:end-2) = rates(t-1,bb);
                else % previous period was ts=1 and a failure for explorer, or it was a neutral period after which a new TS will now take place
                    rates(t,:) = rs; % rates vector from the last "no TS" period
                end
            end
            if ts==1 % TS Learning Part I
                bb = randi([1 B]);
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
            vol1(t,:) = [BS.BA.D(t+1,:) sum(BS.NB.M(t+1,NatB_D(t,:)==(B+1))) sum(BS.NB.M(t+1,NatB_D(t,:)==(B+2)))]; % 1x(B+1), deposits/cash/CBDC holdings before consumption
            
            % Step 4: Net CB reserve position -- after deposit account moves and before consumption
            net_CBD
            cCBcases1(t,:) = countsC;
            u0 = BS.BA.R(t+1,:); % banks' reserve holdings before non-banks' consumption
            u1 = BS.BA.B(t+1,:); % banks' CB debt before non-banks' consumption
            u2 = BS.BA.D(t+1,:); % banks' deposit pools before non-banks' consumption
            
            % Step 5: Non-bank agents' consumption
            cmax = +inf;
            if capcon==1
                cmax = max(0,( rB*BS.NB.L(t+1,:) - BS.NB.M(t+1,:).*(1+rates(t,NatB_D(t,:))) ) ./ (-0.5*rates(t,NatB_D(t,:))-1));
            end
            FL.NB.expC(t,:) = min(cmax,gamma*BS.NB.M(t+1,:)); % portion of non-banks' money holdings (deposits+cash) that will be spent
            effgamma(t,:) = FL.NB.expC(t,:)./BS.NB.M(t+1,:); % effective gamma
            effgamma_S(t) = sum(FL.NB.expC(t,:))/sum(BS.NB.M(t+1,:)); % effective gamma system aggregate
            Ntar = e(sub2ind(size(e),1:N,randi(N-1,N,1)')); % 1xN; non-banks don't consume with themselves
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
            vol2(t,:) = [BS.BA.D(t+1,:) sum(BS.NB.M(t+1,NatB_D(t,:)==(B+1))) sum(BS.NB.M(t+1,NatB_D(t,:)==(B+2)))]; % 1x(B+1), deposits/cash/CBDC holdings after consumption
            
            % Step 6: Net CB reserve position -- after consumption
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
            
            % Step 9: Gridding
            iqrconv(t,:) = assess_IQR(avrate(t-countX(end):t),0.5);
            countX(end) = countX(end)+1;
            if countX(end)>300 && dynG==1 && stick==0
                if abs(1-(iqrconv(t,2)/iqrconv(t,1)))<0.05 || iqrconv(t,1)==0
                    if (iqrconv(t,2)*100)<iqr(end)
                        iqr = [iqr;iqrconv(t,2)*100]; %#ok<*AGROW>
                        G = G+1;
                        modi = 1;
                        countX = [countX;0];
                    end
                end
            end
            if countX(end)>1500 && stick==0 && dynG==1 % enter this if at all only once and not again
                if ~isnan(iqrconv(t,2))
                    iqr = [iqr;iqrconv(t,2)*100]; % the G*+1st's IQR for the record
                elseif ~isnan(iqrconv(t-1,2))
                    iqr = [iqr;iqrconv(t-1,2)*100];
                elseif ~isnan(iqrconv(t-2,2))
                    iqr = [iqr;iqrconv(t-2,2)*100];
                end
                G = G-1; % back to the optimal G*
                modi = 1; % adjust the grid a final time to G*
                stick = 1; % stop dynamically modifying G after that
                countX = [countX;0]; % but keep counting for the record
            end
            
        end % end loop over time
        
        % Analytical rates and market shares
        if B>1
            [ii,ms] = nash_analytical_heterog_partialexog_nested(f*rB,[zeros(1,B) alphas],beta,[B+1 B+2],[0 f*rDC],mu);
        else
            ii = NaN; ms = NaN(B+2,1);
        end
        
        % Convert rates and gamma back to annual
        if qu==1
            rates = 4*rates;
            avrate = 4*avrate;
            ratesL = 4*ratesL;
            ratesL_S = 4*ratesL_S;
            efficbdc = 4*efficbdc;
            effgamma = 4*effgamma;
            effgamma_S = 4*effgamma_S;
        end
        
        %% Stats
        cr = median(vol2(end-S+1:end,end-1)./sum(vol2(end-S+1:end,:),2));
        cbdcr = median(vol2(end-S+1:end,end)./sum(vol2(end-S+1:end,:),2));
        tab1(i,j) = median(avrate(end-S+1:end)); % Nash deposit rate
        tab2(i,j) = ii(1); % ...analytical
        tab3(i,j) = cr; % Cash/M
        tab4(i,j) = ms(B+1); % ...analytical
        tab5(i,j) = cbdcr; % CBDC/M
        tab5(i,j) = ms(B+2); % ...analytical
        tab6(i,j) = mean(mean(BS.BA.R(end-S+1:end,:),2)); % end-of-period reserve holdings
        tab7(i,j) = median(ratesL_S(end-S+1:end)); % effective system lending rate
        tab9(i,j) = median(c_expLmiss(end-S+1:end)); % number of non-banks paying less than full loan interest
        tab10(i,j) = G; % G*
        tab11(i,j) = stick;
        if stick==1
            tab12(i,j) = countX(end);
        end
        clear cr cbdcr
        
    end
end

if store_once_done==1
    save([storefolder '\' namerun '.mat'])
end