% Figure 1:  Banks' balance sheets
% Figure 2:  Banks' P&L
% Figure 3:  Central bank balance sheet
% Figure 4:  Central bank P&L
% Figure 5:  Non-banks' balance sheets
% Figure 6:  Non-banks' P&L
% Figure 7:  Interest rates: deposits, lending, CBDC
% Figure 8:  TS Learning
% Figure 9:  Reserve flows due to deposit and loan account moves
% Figure 10: Reserve flows due to non-bank agents' spending
% Figure 11: Effective reserve ratios
% Figure 12: Cash and CBDC ratios
% Figure 13: Banks' and CB net reserve position
% Figure 14: Effective gamma (velocity of money)
% Figure 15: Global income/expense, stacked bars by sector
% Figure 16: Residuals/Cross-consistency: Balance sheets
% Figure 17: Residuals/Cross-consistency: Flows
% Figure 18: Residuals/Global consistency: Stocks and flows

f = 1; if qu==1, f = 4; end

%% Figure 1: Bank balance sheets
figure('units','normalized','outerposition',[0 0 1 1])
sgtitle('Banks'' Balance Sheets')
subplot(2,5,1)
plott(BS.BA.L,'A: Loans',[])
subplot(2,5,2)
plott(BS.BA.R,'A: R. Holdings',[])
subplot(2,5,3)
plott(BS.BA.D,'L: Deposits',[])
subplot(2,5,4)
plott(BS.BA.B,'L: R. Borrowings',[])
subplot(2,5,5)
plott(BS.BA.L+BS.BA.R-BS.BA.D-BS.BA.B,'Banks'' Net Worth',[])
subplot(2,5,6)
plott(sum(BS.BA.L,2),'A: Loans (S)',[])
subplot(2,5,7)
plott(sum(BS.BA.R,2),'A: R. Holdings (S)',[])
subplot(2,5,8)
plott(sum(BS.BA.D,2),'L: Deposits (S)',[])
subplot(2,5,9)
plott(sum(BS.BA.B,2),'L: R. Borrowings (S)',[])
subplot(2,5,10)
plott(sum(BS.BA.L+BS.BA.R-BS.BA.D-BS.BA.B,2),'Banks'' Net Worth (S)',[])

%% Figure 2: Banks' P&L
figure('units','normalized','outerposition',[0 0 1 1])
sgtitle('Banks'' P&L Flows (p.a.)')
subplot(2,6,1)
plott(f*FL.BA.incL,'II from L.',[])
subplot(2,6,2)
plott(f*FL.BA.incR,'II from R. Holdings',[])
subplot(2,6,3)
plott(f*FL.BA.expD,'IE for D.',[])
subplot(2,6,4)
plott(f*FL.BA.expR,'IE for R. Borrowing',[])
subplot(2,6,5)
plott(f*FL.BA.ni,'Net Income',[])
subplot(2,6,6)
plott(f*FL.BA.div,'DIV Payout',[])
subplot(2,6,7)
plott(f*sum(FL.BA.incL,2),'II from L. (S)',[])
subplot(2,6,8)
plott(f*sum(FL.BA.incR,2),'II from R. Holdings (S)',[])
subplot(2,6,9)
plott(f*sum(FL.BA.expD,2),'IE for D. (S)',[])
subplot(2,6,10)
plott(f*sum(FL.BA.expR,2),'IE for R. Borrowing (S)',[])
subplot(2,6,11)
plott(f*sum(FL.BA.ni,2),'Net Income (S)',[])
subplot(2,6,12)
plott(f*sum(FL.BA.div,2),'DIV Payout (S)',[])

%% Figure 3: Central bank balance sheet
figure('units','normalized','outerposition',[0 0 1 1])
sgtitle('Central Bank Balance Sheet')
subplot(2,3,1)
plott(BS.CB.B,'A: R. Lending to Banks',[])
subplot(2,3,2)
plott(BS.CB.R,'L: R. Holdings of Banks',[])
subplot(2,3,3)
plott(BS.CB.C,'L: Cash Outstanding',[])
subplot(2,3,4)
plott(BS.CB.DC,'L: CBDC Outstanding',[])
subplot(2,3,5)
plott(BS.CB.B-BS.CB.R-BS.CB.C,'Net Worth',[])

%% Figure 4: Central bank P&L
figure('units','normalized','outerposition',[0 0 1 1])
sgtitle('Central Bank P&L Flows (p.a.)')
subplot(2,3,1)
plott(f*FL.CB.incR,'II from R. Lending',[])
subplot(2,3,2)
plott(f*FL.CB.expR,'IE for Banks'' R. Holding',[])
subplot(2,3,3)
plott(f*FL.CB.expDC,'IE for CBDC',[])
subplot(2,3,4)
plott(f*(FL.CB.incR-FL.CB.expR-FL.CB.expDC),'Net Income',[])
subplot(2,3,5)
plott(f*FL.CB.seign,'Seigniorage Payout',[])

%% Figure 5: Non-banks' balance sheets
figure('units','normalized','outerposition',[0 0 1 1])
sgtitle('Non-Banks'' Balance Sheets')
subplot(2,3,1)
plott(BS.NB.M,'A: Money Holdings',[])
subplot(2,3,2)
plott(BS.NB.L,'L: Loans',[])
subplot(2,3,3)
plott(BS.NB.M-BS.NB.L,'Net Worth',[])
subplot(2,3,4)
plott(sum(BS.NB.M,2),'A: Money Holdings (S)',[])
subplot(2,3,5)
plott(sum(BS.NB.L,2),'L: Loans (S)',[])
subplot(2,3,6)
plott(sum(BS.NB.M-BS.NB.L,2),'Net Worth (S)',[])

%% Figure 6: Non-banks' P&L
figure('units','normalized','outerposition',[0 0 1 1])
sgtitle('Non-Banks'' P&L Flows (p.a.)')
subplot(2,9,1)
plott(f*FL.NB.incC,'Spending Income',[])
subplot(2,9,2)
plott(f*FL.NB.expC,'Spending Expense',[])
subplot(2,9,3)
plott(f*(FL.NB.incC-FL.NB.expC),'Net Spending Income',[])
subplot(2,9,4)
plott(f*FL.NB.incD,'II from Deposits',[])
subplot(2,9,5)
plott(f*FL.NB.expL,'IE for Loans',[])
subplot(2,9,6)
plott(f*FL.NB.incDIV,'Bank Dividend Income',[])
subplot(2,9,7)
plott(f*FL.NB.incDC,'II from CBDC',[])
subplot(2,9,8)
plott(f*FL.NB.incS,'Seigniorage Income',[])
subplot(2,9,9)
plott(f*(FL.NB.incC-FL.NB.expC+FL.NB.incD-FL.NB.expL+FL.NB.incDIV+FL.NB.incS+FL.NB.incDC),'Net Income',[])
subplot(2,9,10)
plott(f*sum(FL.NB.incC,2),'Spending Income (S)',[])
subplot(2,9,11)
plott(f*sum(FL.NB.expC,2),'Spending Expense (S)',[])
subplot(2,9,12)
plott(f*sum(FL.NB.incC-FL.NB.expC,2),'Net Spending Income (S)',[])
subplot(2,9,13)
plott(f*sum(FL.NB.incD,2),'II from Deposits (S)',[])
subplot(2,9,14)
plott(f*sum(FL.NB.expL,2),'IE for Loans (S)',[])
subplot(2,9,15)
plott(f*sum(FL.NB.incDIV,2),'Bank Dividend Income (S)',[])
subplot(2,9,16)
plott(f*sum(FL.NB.incDC,2),'II from CBDC (S)',[])
subplot(2,9,17)
plott(f*sum(FL.NB.incS,2),'Seigniorage Income (S)',[])
subplot(2,9,18)
plott(f*sum(FL.NB.incC-FL.NB.expC+FL.NB.incD-FL.NB.expL+FL.NB.incDIV+FL.NB.incS+FL.NB.incDC,2),'Net Income (S)',[])

%% Figure 7: Interest rates
figure('units','normalized','outerposition',[0 0 1 1])
sgtitle('Interest Rates (p.a.)')
subplot(2,3,1)
plott(rates(:,1:end-2),'Banks'' Deposit Rates',[])
subplot(2,3,2)
plott(ratesL,'Banks'' Lending Rates',[])
subplot(2,3,4)
plott(avrate,'Banks'' Deposit Rates (S)',[])
subplot(2,3,5)
plott(ratesL_S,'Banks'' Lending Rates (S)',[])
subplot(2,3,3)
plott(efficbdc,'Effective CBDC Rate',[])
subplot(2,3,6)
plott([f*ones(T,1)*rB f*ones(T,1)*rH(1) f*ones(T,1)*rH(2)],'CB Reserve-Related Rates',[])
legend('R. Borrowing','Required R. Holding','Excess R. Holding')

%% Figure 8: TS learning
figure('units','normalized','outerposition',[0 0 1 1])
sgtitle('TS-Learning')
subplot(1,2,1)
scatter(iG*f,mA(1,:))
hold on
scatter(iG*f,mA(2,:))
plot([median(avrate(end-S:end)) median(avrate(end-S:end))],ylim,'-b')
plot([ii(1) ii(1)],ylim,'--b')
legend('Upward moves','Downward moves','Nash simulation-based','Nash analytical','location','best')
ylabel('\eta')
xlabel('Deposit Rate (S)')
title('Posterior Beta Distributions'' \eta''s (Success)')
subplot(1,2,2)
scatter(iG*f,mB(1,:))
hold on
scatter(iG*f,mB(2,:))
plot([median(avrate(end-S:end)) median(avrate(end-S:end))],ylim,'-b')
plot([ii(1) ii(1)],ylim,'--b')
legend('Upward moves','Downward moves','Nash simulation-based','Nash analytical','location','best')
ylabel('\kappa')
xlabel('Deposit Rate (S)')
title('Posterior Beta Distributions'' \kappa''s (Failure)')

%% Figure 9: Reserve flows due to deposit and loan account moves
figure('units','normalized','outerposition',[0 0 1 1])
sgtitle('Reserve Flows Due to Deposit and Loan Account Moves (p.a.)')
subplot(2,6,1)
plott(f*trackRin(:,1:B,1),'Flows To Banks',[])
subplot(2,6,2)
plott(f*trackRout(:,1:B,1),'Flows Out of Banks',[])
subplot(2,6,3)
plott(f*trackRin(:,B+1,1),'Flows To Cash',[])
subplot(2,6,4)
plott(f*trackRout(:,B+1,1),'Flows Out of Cash',[])
subplot(2,6,5)
plott(f*trackRin(:,B+2,1),'Flows To CBDC',[])
subplot(2,6,6)
plott(f*trackRout(:,B+2,1),'Flows Out of CBDC',[])
subplot(2,6,7)
plott(f*sum(trackRin(:,1:B,1),2),'Flows To Banks (S)',[])
subplot(2,6,8)
plott(f*sum(trackRout(:,1:B,1),2),'Flows Out of Banks (S)',[])
subplot(2,6,9)
plott(f*sum(trackRin(:,B+1:B+2,1),2),'Flows To Cash and CBDC',[])
subplot(2,6,10)
plott(f*sum(trackRout(:,B+1:B+2,1),2),'Flows Out of Cash and CBDC',[])
subplot(2,6,11)
plott(f*sum(trackRin(:,B+1:B+2,1),2)-f*sum(trackRout(:,B+1:B+2,1),2),'Net Flows To Cash+CBDC (In-Out)',[])
subplot(2,6,12)
plott(f*sum(trackRin(:,:,1)-trackRout(:,:,1),2),'Total Net Flows (In-Out)',[])

%% Figure 10: Reserve flows due to non-bank agents spending
figure('units','normalized','outerposition',[0 0 1 1])
sgtitle('Reserve Flows due to Non-Banks'' Spending (p.a.)')
subplot(2,6,1)
plott(f*trackRin(:,1:B,2),'Flows To Banks',[])
subplot(2,6,2)
plott(f*trackRout(:,1:B,2),'Flows Out of Banks',[])
subplot(2,6,3)
plott(f*trackRin(:,B+1,2),'Flows To Cash',[])
subplot(2,6,4)
plott(f*trackRout(:,B+1,2),'Flows Out of Cash',[])
subplot(2,6,5)
plott(f*trackRin(:,B+2,2),'Flows To CBDC',[])
subplot(2,6,6)
plott(f*trackRout(:,B+2,2),'Flows Out of CBDC',[])
subplot(2,6,7)
plott(f*sum(trackRin(:,1:B,2),2),'Flows To Banks (S)',[])
subplot(2,6,8)
plott(f*sum(trackRout(:,1:B,2),2),'Flows Out of Banks (S)',[])
subplot(2,6,9)
plott(f*sum(trackRin(:,B+1:B+2,2),2),'Flows To Cash and CBDC',[])
subplot(2,6,10)
plott(f*sum(trackRout(:,B+1:B+2,2),2),'Flows Out of Cash and CBDC',[])
subplot(2,6,11)
plott(f*sum(trackRin(:,B+1:B+2,2),2)-f*sum(trackRout(:,B+1:B+2,2),2),'Net Flows To Cash+CBDC (In-Out)',[])
subplot(2,6,12)
plott(f*sum(trackRin(:,:,2)-trackRout(:,:,2),2),'Total Net Flows (In-Out)',[])

%% Figure 11: Reserve ratios
figure('units','normalized','outerposition',[0 0 1 1])
sgtitle('Reserve Ratios')
subplot(1,2,1)
plott(0.5*(BS.BA.R(1:T-1,:)+BS.BA.R(2:T,:))./(0.5*(BS.BA.D(1:T-1,:)+BS.BA.D(2:T,:))),'R/D (p.av.) - Banks',[])
subplot(1,2,2)
plott(0.5*(sum(BS.BA.R(1:T-1,:),2)+sum(BS.BA.R(2:T,:),2))./(0.5*(sum(BS.BA.D(1:T-1,:),2)+sum(BS.BA.D(2:T,:),2))),'R/D (p.av.) - Banking System',[])

%% Figure 12: Cash and CBDC ratios
figure('units','normalized','outerposition',[0 0 1 1])
sgtitle('Portions of Deposits, Cash, and CBDC in M')
subplot(1,3,1)
area([sum(vol1(:,1:end-2),2)./sum(vol1,2) vol1(:,end-1)./sum(vol1,2) vol1(:,end)./sum(vol1,2)],'edgecolor','none')
xlim([1 T])
ylim([0 1])
legend('Deposits','Cash','CBDC','location','best')
title('D/C/CBDC Ratios - Before Consumption')
subplot(1,3,2)
area([sum(vol2(:,1:end-2),2)./sum(vol2,2) vol2(:,end-1)./sum(vol2,2) vol2(:,end)./sum(vol2,2)],'edgecolor','none')
xlim([1 T])
ylim([0 1])
legend('Deposits','Cash','CBDC','location','best')
title('D/C/CBDC Ratios - After Consumption')
subplot(1,3,3)
area([sum(BS.BA.D,2)./sum(BS.NB.M,2) BS.CB.C./sum(BS.NB.M,2) BS.CB.DC./sum(BS.NB.M,2)],'edgecolor','none')
xlim([1 T+1])
ylim([0 1])
legend('Deposits','Cash','CBDC','location','best')
title('D/C/CBDC Ratios - End-of-Period')

%% Figure 13: Banks' and CB net reserve position
figure('units','normalized','outerposition',[0 0 1 1])
sgtitle('Banks'' and CB Net Reserve Position')
subplot(2,2,1)
plott(BS.BA.R-BS.BA.B,'Banks'' R. Holding - Borrowing',[])
subplot(2,2,2)
plott(sum(BS.BA.R-BS.BA.B,2),'Banks'' R. Holding - Borrowing (S)',[])
subplot(2,2,3)
plott(BS.CB.B-BS.CB.R,'CB BS: R. Lending (A) - Holding (L)',[])
subplot(2,2,4)
area([BS.CB.R BS.CB.C BS.CB.DC],'edgecolor','none')
xlim([1 T+1])
legend('CB R. Holdings (L)','CB Cash (L)','CB CBDC (L)','location','best')
title('CB Liabilities')

%% Figure 14: Effective gamma, etc.
figure('units','normalized','outerposition',[0 0 1 1])
sgtitle('Velocity of Money, Loan Interest, etc.')
subplot(2,3,1)
plott(ratesL,'Effective Loan Interest Rates (p.a.)',[])
subplot(2,3,2)
plott(effgamma,'Effective Vel. of Money p.a. (\gamma)',[])
subplot(2,3,3)
plott(c_expLmiss,'# of non-banks not paying full I^L',[])
subplot(2,3,4)
plott(ratesL_S,'Effective Loan Interest Rate (p.a., S)',[])
subplot(2,3,5)
plott(effgamma_S,'Effective Vel. of Money, \gamma (p.a., S)',[])
subplot(2,3,6)
plott([MbeforeIL ILdue],'M Available vs. Loan Interest Due',[])
legend('M before I^L (S)','I^L due (S)','location','best')

%% Figure 15: Sectoral income/expense distributions
figure('units','normalized','outerposition',[0 0 1 1])
x1 = sum(FL.NB.incD,2);
x2 = sum(FL.NB.incDC,2);
x3 = sum(FL.NB.incS,2);
x4 = sum(FL.NB.incC,2);
x5 = sum(FL.NB.incDIV,2);
x6 = -sum(FL.NB.expC,2);
x7 = -sum(FL.NB.expL,2);
x8 = sum(FL.BA.incR,2);
x9 = sum(FL.BA.incL,2);
x10 = -sum(FL.BA.expR,2);
x11 = -sum(FL.BA.expD,2);
x12 = -sum(FL.BA.div,2);
x13 = FL.CB.incR;
x14 = -FL.CB.expR;
x15 = -FL.CB.expDC;
x16 = -FL.CB.seign;
xx = x1+x2+x3+x4+x5+x6+x7+x8+x9+x10+x11+x12+x13+x14+x15+x16;
y1 = sum(BS.NB.M,2);
y2 = -sum(BS.NB.L,2);
y3 = sum(BS.BA.R,2);
y4 = sum(BS.BA.L,2);
y5 = -sum(BS.BA.D,2);
y6 = -sum(BS.BA.B,2);
y7 = BS.CB.B;
y8 = -BS.CB.R;
y9 = -BS.CB.C;
y10 = -BS.CB.DC;
yy = y1+y2+y3+y4+y5+y6+y7+y8+y9+y10;
sgtitle('Sectoral Income and Expense Distributions (flows p.a.)')
for i=1:16
    eval(['xx' num2str(i) ' = mean(x' num2str(i) '(end-S+1:end));']);
end
subplot(1,4,1)
bar(1,f*[xx1 xx2 xx3 xx4 xx5 xx6 xx7],'stacked')
hold on
scatter(1,sum(f*[xx1 xx2 xx3 xx4 xx5 xx6 xx7]),50,'o','markerfacecolor','b','markeredgecolor','b')
scatter(1,sum(f*[xx1 xx2 xx4 xx6 xx7]),50,'o','markerfacecolor','g','markeredgecolor','g')
legend('II: Deposits','II: CBDC','II: CB Seign.','I: Cons.','I: BA DIV','E: Cons.','IE: Loans','Sum','Sum excl. DIV inc.','location','best','fontsize',5)
title('Non-Banks (incl. cons.)')
xticklabels({})
subplot(1,4,2)
bar(1,f*[xx1 xx2 xx3 xx5 xx7],'stacked')
hold on
scatter(1,f*sum([xx1 xx2 xx3 xx5 xx7]),50,'o','markerfacecolor','b','markeredgecolor','b')
scatter(1,f*sum([xx1 xx2 xx7]),50,'o','markerfacecolor','g','markeredgecolor','g')
legend('II: Deposits','II: CBDC','II: CB Seign.','I: BA DIV','IE: Loans','Sum','Sum excl. DIV inc.','location','best','fontsize',5)
title('Non-Banks (excl. cons.)')
d2 = get(gca,'ylim');
xticklabels({})
subplot(1,4,3)
bar(1,f*[xx8 xx9 xx10 xx11 xx12],'stacked')
hold on
scatter(1,f*sum([xx8 xx9 xx10 xx11 xx12]),50,'o','markerfacecolor','b','markeredgecolor','b')
scatter(1,f*sum([xx8 xx9 xx10 xx11]),50,'o','markerfacecolor','g','markeredgecolor','g')
legend('II: R Holdings','II: Loans','IE: R Borrowing','IE: Deposits','DIV payout','Sum','Sum excl. DIV exp.','location','best','fontsize',5)
title('Banking System')
d3 = get(gca,'ylim');
xticklabels({})
subplot(1,4,4)
bar(1,f*[xx13 xx14 xx15 xx16],'stacked')
hold on
scatter(1,f*sum([xx13 xx14 xx15 xx16]),50,'o','markerfacecolor','b','markeredgecolor','b')
scatter(1,f*sum([xx13 xx14 xx15]),50,'o','markerfacecolor','g','markeredgecolor','g')
legend('II: R Lending','IE: R','IE: CBDC','Seigniorage Payout','Sum','Sum excl. seign. exp.','location','best','fontsize',5)
title('Central Bank')
d4 = get(gca,'ylim');
d = [min([d2(1) d3(1) d4(1)]) max([d2(2) d3(2) d4(2)])];
xticklabels({})
subplot(1,4,2)
ylim([d(1) d(2)])
subplot(1,4,3)
ylim([d(1) d(2)])
subplot(1,4,4)
ylim([d(1) d(2)])

%% Figure 16: Residuals: Balance sheets
% figure('units','normalized','outerposition',[0 0 1 1])
% sgtitle('Residuals: Balance Sheets'' Cross-Consistency')
% subplot(2,2,1)
% plott(sum(BS.NB.M,2)-sum(BS.BA.D,2)-BS.CB.C-BS.CB.DC,'NB Money (A) - Bank Deposits (L) - CB Cash & CBDC (L)',[])
% subplot(2,2,2)
% plott(sum(BS.BA.L,2)-sum(BS.NB.L,2),'Loans: BA (A) - NB (L)',[])
% subplot(2,2,3)
% plott(sum(BS.BA.R,2)-BS.CB.R,'Reserve Holdings: BA (A) - CB (L)',[])
% subplot(2,2,4)
% plott(sum(BS.BA.B,2)-BS.CB.B,'Reserve Borrowing: BA (L) - CB (A)',[])

%% Figure 17: Flow residuals
% figure('units','normalized','outerposition',[0 0 1 1])
% sgtitle('Residuals: Flows')
% subplot(2,4,1)
% plott(sum(FL.NB.incC,2)-sum(FL.NB.expC,2),'Non-Banks'' Spending',[])
% subplot(2,4,2)
% plott(sum(FL.NB.incD,2)-sum(FL.BA.expD,2),'Deposit Interest',[])
% subplot(2,4,3)
% plott(sum(FL.NB.expL,2)-sum(FL.BA.incL,2),'Loan Interest',[])
% subplot(2,4,4)
% plott(sum(FL.NB.incDC,2)-sum(FL.CB.expDC,2),'CBDC Interest',[])
% subplot(2,4,5)
% plott(sum(FL.BA.expR,2)-FL.CB.incR,'Reserve Borrowing Interest',[])
% subplot(2,4,6)
% plott(sum(FL.BA.incR,2)-FL.CB.expR,'Reserve Holding Interest',[])
% subplot(2,4,7)
% plott(sum(FL.BA.div,2)-sum(FL.NB.incDIV,2),'Bank Dividends',[])
% subplot(2,4,8)
% plott(FL.CB.seign-sum(FL.NB.incS,2),'CB Seigniorage',[])

%% Figure 18: Global consistency--Stocks and flows
% figure('units','normalized','outerposition',[0 0 1 1])
% sgtitle('Residuals: Global Stock and Flow Consistency')
% subplot(1,2,1)
% plott(xx,'Global Sum of Flows',[])
% subplot(1,2,2)
% plott(yy,'Global Net Worth',[])
% clear x* y*

clear f