%% Deposit interest income for non-banks (expense for banks)
FL.NB.incD(t,:) = rates(t,NatB_D(t,:)).*(0.5*(BS.NB.M(t,:) + BS.NB.M(t+1,:)));
FL.NB.incD(t,NatB_D(t,:)==(B+2)) = 0; % don't process interest on CBDC here
FL.NB.incD(t,isnan(FL.NB.incD(t,:))) = 0;
for b=1:B
    x = find(NatB_D(t,:)==b);
    if ~isempty(x)
        FL.BA.expD(t,b) = sum(FL.NB.incD(t,x)); %#ok<*SAGROW>
    end
end
clear x
BS.NB.M(t+1,:) = BS.NB.M(t+1,:) + FL.NB.incD(t,:);
BS.BA.D(t+1,:) = BS.BA.D(t+1,:) + FL.BA.expD(t,:);
avrate(t) = sum(FL.BA.expD(t,:))/sum(0.5*(BS.NB.M(t,NatB_D(t,:)~=(B+1) & NatB_D(t,:)~=(B+2))+BS.NB.M(t+1,NatB_D(t,:)~=(B+1) & NatB_D(t,:)~=(B+2)))); % deposit rate (weighted av. system)

%% Loan interest income for banks (expense for non-banks)
MbeforeIL(t) = sum(BS.NB.M(t+1,:));
ILdue(t) = sum(rB*BS.NB.L(t+1,:));
FL.NB.expL(t,:) = min(rB*BS.NB.L(t+1,:),BS.NB.M(t+1,:));
c_expLmiss(t) = sum(FL.NB.expL(t,:)<rB*BS.NB.L(t+1,:));
BS.NB.M(t+1,:) = BS.NB.M(t+1,:) - FL.NB.expL(t,:);
for b=1:B
    % Non-banks with loans from b and deposit account at b
    x1 = find(NatB_L(t,:)==b & NatB_D(t,:)==b);
    if ~isempty(x1)
        y = sum(FL.NB.expL(t,x1));
        FL.BA.incL(t,b) = FL.BA.incL(t,b) + y;
        BS.BA.D(t+1,b) = BS.BA.D(t+1,b) - y;
        clear y
    end
    % Non-banks with loans from b but deposit account at another bank
    x2 = find(NatB_L(t,:)==b & NatB_D(t,:)~=b & NatB_D(t,:)<(B+1));
    if ~isempty(x2)
        y = sum(FL.NB.expL(t,x2));
        FL.BA.incL(t,b) = FL.BA.incL(t,b) + y;
        BS.BA.R(t+1,b) = BS.BA.R(t+1,b) + y; %#ok<*FNDSB>
        clear y
    end
    % Non-banks with loans not from b but deposit account at b
    % Mind: no addition to the loan interest flow tracker here!
    x3 = find(NatB_L(t,:)~=b & NatB_D(t,:)==b);
    if ~isempty(x3)
        y = sum(FL.NB.expL(t,x3));
        BS.BA.D(t+1,b) = BS.BA.D(t+1,b) - y;
        BS.BA.R(t+1,b) = BS.BA.R(t+1,b) - y;
        clear y
    end
    % Cash holders with loans from b
    x4 = find(NatB_L(t,:)==b & NatB_D(t,:)==(B+1));
    if ~isempty(x4)
        y = sum(FL.NB.expL(t,x4));
        FL.BA.incL(t,b) = FL.BA.incL(t,b) + y;
        BS.BA.R(t+1,b) = BS.BA.R(t+1,b) + y;
        BS.CB.R(t+1) = BS.CB.R(t+1) + y;
        BS.CB.C(t+1) = BS.CB.C(t+1) - y;
        clear y
    end
    % CBDC holders with loans from b
    x5 = find(NatB_L(t,:)==b & NatB_D(t,:)==(B+2));
    if ~isempty(x5)
        y = sum(FL.NB.expL(t,x5));
        FL.BA.incL(t,b) = FL.BA.incL(t,b) + y;
        BS.BA.R(t+1,b) = BS.BA.R(t+1,b) + y;
        BS.CB.R(t+1) = BS.CB.R(t+1) + y;
        BS.CB.DC(t+1) = BS.CB.DC(t+1) - y;
        clear y
    end
    % Banks' effective loan interest rates
    ratesL(t,b) = FL.BA.incL(t,b) / BS.BA.L(t+1,b);
end
ratesL_S(t) = sum(FL.BA.incL(t,:)) / sum(BS.BA.L(t+1,:));
clear x1 x2 x3 x4 x5
net_CBD

%% Reserve income for banks (expense for CB)
trackPAV_R(t,:) = 0.5*(u0 + BS.BA.R(t+1,:)); % period av. total reserves
if sum(rH>0)>0
    rR = lambda*0.5*(u2 + BS.BA.D(t+1,:)); % required reserves
    eR = max(0,trackPAV_R(t,:) - rR); % excess reserves; max(0,.) to circumvent floating pt. prec. residual
    FL.BA.incR(t,:) = rH(1)*rR + rH(2)*eR;
    FL.CB.expR(t) = sum(FL.BA.incR(t,:));
    BS.BA.R(t+1,:) = BS.BA.R(t+1,:) + FL.BA.incR(t,:);
    BS.CB.R(t+1) = BS.CB.R(t+1) + FL.CB.expR(t);
    clear rR eR
end

%% Reserve borrowing expense for banks (income for CB)
trackPAV_B(t,:) = 0.5*(u1 + BS.BA.B(t+1,:));
FL.BA.expR(t,:) = rB*trackPAV_B(t,:);
FL.CB.incR(t) = sum(FL.BA.expR(t,:));
BS.BA.R(t+1,:) = BS.BA.R(t+1,:) - FL.BA.expR(t,:);
BS.CB.R(t+1) = BS.CB.R(t+1) - FL.CB.incR(t);

%% CB pays interest on CBDC (income for non-banks)
v = 0.5*(BS.NB.M(t,:) + BS.NB.M(t+1,:));
v(NatB_D(t,:)~=(B+2)) = 0; % consider only interest on CBDC here
FL.NB.incDC(t,:) = max(rDC,rates(t,B+2))*v;
if sum(FL.NB.incDC(t,:))>0 && (FL.CB.incR(t) - FL.CB.expR(t))>0
    ff = min(1, (FL.CB.incR(t) - FL.CB.expR(t)) / sum(FL.NB.incDC(t,:)));
    FL.NB.incDC(t,:) = ff*FL.NB.incDC(t,:);
elseif (FL.CB.incR(t) - FL.CB.expR(t))<0
    FL.NB.incDC(t,:) = 0;
end
efficbdc(t) = sum(FL.NB.incDC(t,:))/sum(v);
FL.CB.expDC(t) = sum(FL.NB.incDC(t,:));
BS.NB.M(t+1,:) = BS.NB.M(t+1,:) + FL.NB.incDC(t,:);
BS.CB.DC(t+1) = BS.CB.DC(t+1) + FL.CB.expDC(t);
clear ff v

%% CB seigniorage distribution (expense for CB, income for non-banks)
FL.CB.seign(t) = FL.CB.incR(t) - FL.CB.expR(t) - FL.CB.expDC(t);
if FL.CB.seign(t)<0
    %disp(['Warning: CB net income is negative (= ' num2str(FL.CB.seign(t)) ')'])
end
FL.NB.incS(t,:) = FL.CB.seign(t)/N; % distribution in equal shares to all non-bank agents
BS.NB.M(t+1,:) = BS.NB.M(t+1,:) + FL.NB.incS(t,:);
% Non-banks with deposit accounts
for b=1:B
    x1 = find(NatB_D(t,:)==b);
    if ~isempty(x1)
        y = sum(FL.NB.incS(t,x1));
        BS.BA.D(t+1,b) = BS.BA.D(t+1,b) + y;
        BS.BA.R(t+1,b) = BS.BA.R(t+1,b) + y;
        BS.CB.R(t+1) = BS.CB.R(t+1) + y;
        clear y
    end
end
% Non-banks with cash
x2 = find(NatB_D(t,:)==(B+1));
if ~isempty(x2)
    BS.CB.C(t+1) = BS.CB.C(t+1) + sum(FL.NB.incS(t,x2));
end
% Non-banks with CBDC
x3 = find(NatB_D(t,:)==(B+2));
if ~isempty(x3)
    BS.CB.DC(t+1) = BS.CB.DC(t+1) + sum(FL.NB.incS(t,x3));
end
clear x1 x2 x3

%% Banks pay dividends (income for non-banks)
nw = BS.BA.R(t+1,:) + BS.BA.L(t+1,:) - BS.BA.D(t+1,:) - BS.BA.B(t+1,:);
for b=1:B
    if nw(b)>0
        z = nw(b)/N;
        FL.NB.incDIV(t,:) = FL.NB.incDIV(t,:) + z;
        BS.NB.M(t+1,:) = BS.NB.M(t+1,:) + z;
        FL.BA.div(t,b) = nw(b);
        % Depositors at b
        x1 = find(NatB_D(t,:)==b);
        if ~isempty(x1)
            BS.BA.D(t+1,b) = BS.BA.D(t+1,b) + z*length(x1);
        end
        % Depositors at other banks
        x2 = find(NatB_D(t,:)~=b & NatB_D(t,:)<=B);
        if ~isempty(x2)
            BS.BA.R(t+1,b) = BS.BA.R(t+1,b) - z*length(x2);
            for c=setdiff(1:B,b)
                w = find(NatB_D(t,:)==c);
                if ~isempty(w)
                    BS.BA.D(t+1,c) = BS.BA.D(t+1,c) + z*length(w);
                    BS.BA.R(t+1,c) = BS.BA.R(t+1,c) + z*length(w);
                end
            end
            clear c w
        end
        % Cash holders
        x3 = find(NatB_D(t,:)==(B+1));
        if ~isempty(x3)
            BS.BA.R(t+1,b) = BS.BA.R(t+1,b) - z*length(x3);
            BS.CB.R(t+1) = BS.CB.R(t+1) - z*length(x3);
            BS.CB.C(t+1) = BS.CB.C(t+1) + z*length(x3);
        end
        % CBDC holders
        x4 = find(NatB_D(t,:)==(B+2));
        if ~isempty(x4)
            BS.BA.R(t+1,b) = BS.BA.R(t+1,b) - z*length(x4);
            BS.CB.R(t+1) = BS.CB.R(t+1) - z*length(x4);
            BS.CB.DC(t+1) = BS.CB.DC(t+1) + z*length(x4);
        end
        if length(unique([x1 x2 x3 x4]))~=N, error(' '), end
    end
end
clear x1 x2 x3 x4 nw z
net_CBD

%% Net income for banks, before dividends (eq. 6 in the paper)
FL.BA.ni(t,:) = FL.BA.incL(t,:) + FL.BA.incR(t,:) - FL.BA.expD(t,:) - FL.BA.expR(t,:);