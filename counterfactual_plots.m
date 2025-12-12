%% Settings
f = 1;
if qu==1, f = 4; end
cut = 200;

%% IMF color map
IMFmap = [0 76 151 % dark blue
    242 169 0 % gold
    120 190 32 % light green
    0 156 222 % light blue
    112 115 114 % grey
    101 141 27 % dark green
    255 130 0 % orange
    218 41 28 % red
    128 49 167 % purple
    145 0 72 % magenta
    0 176 185 % teal
    64 126 201 % azure
    0 30 96 % indigo
    110 98 89 % warm grey
    177 179 179 % cool grey
    ]./255;

%% Figure 1: Bank balance sheets
figure('units','normalized','outerposition',[0 0 1 1])
sgtitle({'Bank Balance Sheets',['(in ' unit ', e.o.p.)']}) 
subplot(2,5,1)
plott_cf(BS.BA.L,'A: Loans',[],CFBs,cut,'eq')
subplot(2,5,2)
plott_cf(BS.BA.R,'A: Res. Holdings',[],CFBs,cut,'')
subplot(2,5,3)
plott_cf(BS.BA.D,'L: Deposits',[],CFBs,cut,'')
subplot(2,5,4)
plott_cf(BS.BA.B,'L: Res. Borrowings',[],CFBs,cut,'')
subplot(2,5,5)
plott_cf(BS.BA.L+BS.BA.R-BS.BA.D-BS.BA.B,'Net Worth',[],CFBs,cut,'none')
ylim([-1 1])
subplot(2,5,6)
plott_cf(sum(BS.BA.L,2),'A: Loans (S)',[],CFBs,cut,'none'); 
x = get(gca,'ylim'); ylim([0 1.2*x(2)])
subplot(2,5,7)
plott_cf(sum(BS.BA.R,2),'A: Res. Holdings (S)',[],CFBs,cut,'')
subplot(2,5,8)
plott_cf(sum(BS.BA.D,2),'L: Deposits (S)',[],CFBs,cut,'')
subplot(2,5,9)
plott_cf(sum(BS.BA.B,2),'L: Res. Borrowings (S)',[],CFBs,cut,'')
subplot(2,5,10)
plott_cf(sum(BS.BA.L+BS.BA.R-BS.BA.D-BS.BA.B,2),'Net Worth (S)',[],CFBs,cut,'none')
ylim([-1 1])
if savefigs==1
    saveas(gcf,[prefix 'Fig 1 - Bank BS.png'])
    close
end

%% Figure 2: Banks' P&L
figure('units','normalized','outerposition',[0 0 1 1])
sgtitle({'Banks'' P&L Flows',['(in ' unit ', p.a.)']})
subplot(2,6,1)
plott_cf(f*FL.BA.incL,'II from Loans',[],CFBs,cut,'eq')
subplot(2,6,2)
plott_cf(f*FL.BA.incR,'II from R. Holdings',[],CFBs,cut,'')
subplot(2,6,3)
plott_cf(f*FL.BA.expD,'IE for Deposits',[],CFBs,cut,'')
subplot(2,6,4)
plott_cf(f*FL.BA.expR,'IE for R. Borrowing',[],CFBs,cut,'')
subplot(2,6,5)
plott_cf(f*FL.BA.ni,'Net Income',[],CFBs,cut,'')
subplot(2,6,6)
plott_cf(f*FL.BA.div,'Dividend Payout',[],CFBs,cut,'')
subplot(2,6,7)
plott_cf(f*sum(FL.BA.incL,2),'II from Loans (S)',[],CFBs,cut,'none')
x = get(gca,'ylim'); ylim([0 1.2*x(2)])
subplot(2,6,8)
plott_cf(f*sum(FL.BA.incR,2),'II from R. Holdings (S)',[],CFBs,cut,'')
subplot(2,6,9)
plott_cf(f*sum(FL.BA.expD,2),'IE for Deposits (S)',[],CFBs,cut,'')
subplot(2,6,10)
plott_cf(f*sum(FL.BA.expR,2),'IE for R. Borrowing (S)',[],CFBs,cut,'')
subplot(2,6,11)
plott_cf(f*sum(FL.BA.ni,2),'Net Income (S)',[],CFBs,cut,'')
subplot(2,6,12)
plott_cf(f*sum(FL.BA.div,2),'Dividend Payout (S)',[],CFBs,cut,'')
if savefigs==1
    saveas(gcf,[prefix 'Fig 2 - Bank PandL.png'])
    close
end

%% Figure 3: Central bank balance sheet
figure('units','normalized','outerposition',[0 0 1 1])
sgtitle({'Central Bank Balance Sheet',['(in ' unit ', e.o.p.)']},'FontSize',18,'FontName', 'Arial')
subplot(2,3,1)
plott_cf(BS.CB.B,'A: Reserve Lending to Banks',[],CFBs,cut,'')
subplot(2,3,2)
plott_cf(BS.CB.R,'L: Reserve Holdings of Banks',[],CFBs,cut,'')
subplot(2,3,3)
plott_cf(BS.CB.C,'L: Cash Outstanding',[],CFBs,cut,'')
subplot(2,3,4)
plott_cf(BS.CB.DC,'L: CBDC Outstanding',[],CFBs,cut,'')
subplot(2,3,5)
plott_cf(BS.CB.B-BS.CB.R-BS.CB.C-BS.CB.DC,'Net Worth',[],CFBs,cut,'none')
ylim([-1 1])
if savefigs==1
    saveas(gcf,[prefix 'Fig 3 - CB BS.png'])
    close
end

%% Figure 4: Central bank P&L
figure('units','normalized','outerposition',[0 0 1 1])
sgtitle({'Central Bank P&L Flows',['(in ' unit ', p.a.)']},'FontSize',18,'FontName', 'Arial')
subplot(2,2,1)
plott_cf(f*FL.CB.incR,'II from Reserve Lending',[],CFBs,cut,'')
subplot(2,2,2)
plott_cf(f*FL.CB.expR,'IE for Banks'' Reserve Holding',[],CFBs,cut,'')
subplot(2,2,3)
plott_cf(f*FL.CB.expDC,'IE for CBDC',[],CFBs,cut,'')
subplot(2,2,4)
plott_cf(f*(FL.CB.incR-FL.CB.expR-FL.CB.expDC),{'Net Income = Seigniorage Payout'},[],CFBs,cut,'')
if savefigs==1
    saveas(gcf,[prefix 'Fig 4 - CB PandL.png'])
    close
end

%% Figure 5: Non-banks' P&L
figure('units','normalized','outerposition',[0 0 1 1])
sgtitle({'Non-Banks'' P&L Flows',['(in ' unit ', p.a.)']},'FontSize',18,'FontName', 'Arial')
subplot(2,4,1)
plott_cf(f*sum(FL.NB.incC-FL.NB.expC,2),'Net Spending Income (S)',[],CFBs,cut,'none')
ylim([-1 1])
subplot(2,4,2)
plott_cf(f*sum(FL.NB.incD,2),'II from Deposits (S)',[],CFBs,cut,'')
subplot(2,4,3)
plott_cf(f*sum(FL.NB.expL,2),'IE for Loans (S)',[],CFBs,cut,'eq')
subplot(2,4,4)
plott_cf(f*sum(FL.NB.incDIV,2),'Bank Dividend Income (S)',[],CFBs,cut,'')
subplot(2,4,5)
plott_cf(f*sum(FL.NB.incDC,2),'II from CBDC (S)',[],CFBs,cut,'')
subplot(2,4,6)
plott_cf(f*sum(FL.NB.incS,2),'Seigniorage Income (S)',[],CFBs,cut,'')
subplot(2,4,7)
plott_cf(f*sum(FL.NB.incC-FL.NB.expC+FL.NB.incD-FL.NB.expL+FL.NB.incDIV+FL.NB.incS+FL.NB.incDC,2),'Net Income (S)',[],CFBs,cut,'none')
ylim([-1 1])
if savefigs==1
    saveas(gcf,[prefix 'Fig 7 - Nonbank PandL.png'])
    close
end

%% Figure 6: Bespoke - NB P&L (stacking shares)
Y = [(sum(FL.NB.incD,2)./sum(FL.NB.expL,2))';
    (sum(FL.NB.incDIV,2)./sum(FL.NB.expL,2))';
    (sum(FL.NB.incDC,2)./sum(FL.NB.expL,2))';
    (sum(FL.NB.incS,2)./sum(FL.NB.expL,2))'];
figure('units','normalized','outerposition',[0 0 1 1])
sgtitle({'Non-Banks'' P&L Flows',['(in ' unit ', p.a.)']},'FontSize',18,'FontName', 'Arial')
subplot(2,3,1)
plott_cf(f*sum(FL.NB.expL,2),'IE for Loans (S)',[],CFBs,cut,'eq')
gg = mean(f*sum(FL.NB.expL,2));
ylim([gg*0.95 gg*1.05])
subplot(2,3,4)
plott_cf(f*sum(FL.NB.incC-FL.NB.expC+FL.NB.incD-FL.NB.expL+FL.NB.incDIV+FL.NB.incS+FL.NB.incDC,2),'Net Income (S)',[],CFBs,cut,'none')
ylim([-1 1])
subplot(2,3,[2 3 5 6])
area(Y','edgecolor','none')
xlim([1 T+1])
ylim([0,1])
lbs = {'','A','B','C','D','E','F'}; % labels
xline(1,'-k')
for w=2:length(CFBs)
    xl = xline(CFBs(w),'-k',lbs(w),'linewidth',1);
    xl.LabelOrientation = 'horizontal';
end
legend('Deposits interest income','Bank Dividends income','CBDC interest income', 'Seigniorage income',...
'location','south','NumColumns',2)
ax = gca();
ax.ColorOrder = IMFmap;
ax.FontSize = 14;
title('Interest Income Flows (in percent)','FontName', 'Arial')
if savefigs==1
    saveas(gcf,[prefix 'Fig 7 - Nonbank PandL - Specific 1.png'])
    close
end

%% Figure 7: Bespoke - NB P&L (stacking absolute flows)
Y = [sum(FL.NB.incD,2) sum(FL.NB.incDIV,2) sum(FL.NB.incDC,2) sum(FL.NB.incS,2)];
figure('units','normalized','outerposition',[0 0 1 1])
sgtitle({'Non-Banks'' P&L Flows',['(in ' unit ', p.a.)']},'FontSize',18,'FontName', 'Arial')
subplot(2,3,1)
plott_cf(f*sum(FL.NB.expL,2),'IE for Loans (S)',[],CFBs,cut,'eq')
gg = mean(f*sum(FL.NB.expL,2));
ylim([gg*0.95 gg*1.05])
subplot(2,3,4)
plott_cf(f*sum(FL.NB.incC-FL.NB.expC+FL.NB.incD-FL.NB.expL+FL.NB.incDIV+FL.NB.incS+FL.NB.incDC,2),'Net Income (S)',[],CFBs,cut,'none')
ylim([-1 1])
subplot(2,3,[2 3 5 6])
area(Y,'edgecolor','none')
xlim([1 T+1])
ylim([0 sum(Y(end,:))])
lbs = {'','A','B','C','D','E','F'}; % labels
xline(1,'-k')
for w=2:length(CFBs)
    xl = xline(CFBs(w),'-k',lbs(w),'linewidth',1);
    xl.LabelOrientation = 'horizontal';
end
legend('Deposits interest income','Bank Dividends income','CBDC interest income', 'Seigniorage income',...
'location','south','NumColumns',2)
ax = gca();
ax.ColorOrder = IMFmap;
ax.FontSize = 14;
title('Interest Income Flows','FontName', 'Arial')
if savefigs==1
    saveas(gcf,[prefix 'Fig 7 - Nonbank PandL - Specific 2.png'])
    close
end

%% Figure 8: Interest rates
figure('units','normalized','outerposition',[0 0 1 1])
sgtitle('Interest Rates (p.a.)','FontSize',18,'FontName', 'Arial')
subplot(2,2,1)
plott_cf(rates(:,1:end-2),'Banks'' Deposit Rates',[],CFBs,cut,'')
subplot(2,2,2)
plott_cf(avrate,'Banks'' Deposit Rates (S)',[],CFBs,cut,'')
subplot(2,2,3)
plott_cf(efficbdc,'Rate on CBDC)',[],CFBs,cut,'none')
subplot(2,2,4)
plott_cf([f*ones(T,1)*rB f*ones(T,1)*rH(1) f*ones(T,1)*rH(2)],'Central Bank Rates',[],CFBs,cut,'none')
legend('R. Borrowing','Required R. Holding','Excess R. Holding','location','best')
if savefigs==1
    saveas(gcf,[prefix 'Fig 8 - Interest Rates.png'])
    close
end

%% Figure 9: Reserve flows due to deposit and loan account moves
figure('units','normalized','outerposition',[0 0 1 1])
sgtitle({'Reserve Flows Due to Deposit and Loan Account Moves',['(in ' unit ', p.a.)']},'FontSize',18,'FontName', 'Arial')
subplot(2,6,1)
plott_cf(f*trackRin(:,1:B,1),'Flows To Banks',[],CFBs,cut,'')
subplot(2,6,2)
plott_cf(f*trackRout(:,1:B,1),'Flows Out of Banks',[],CFBs,cut,'')
subplot(2,6,3)
plott_cf(f*trackRin(:,B+1,1),'Flows To Cash',[],CFBs,cut,'')
subplot(2,6,4)
plott_cf(f*trackRout(:,B+1,1),'Flows Out of Cash',[],CFBs,cut,'')
subplot(2,6,5)
plott_cf(f*trackRin(:,B+2,1),'Flows To CBDC',[],CFBs,cut,'')
subplot(2,6,6)
plott_cf(f*trackRout(:,B+2,1),'Flows Out of CBDC',[],CFBs,cut,'')
subplot(2,6,7)
plott_cf(f*sum(trackRin(:,1:B,1),2),'Flows To Banks (S)',[],CFBs,cut,'')
subplot(2,6,8)
plott_cf(f*sum(trackRout(:,1:B,1),2),'Flows Out of Banks (S)',[],CFBs,cut,'')
subplot(2,6,9)
plott_cf(f*sum(trackRin(:,B+1:B+2,1),2),'Flows To Cash and CBDC',[],CFBs,cut,'')
subplot(2,6,10)
plott_cf(f*sum(trackRout(:,B+1:B+2,1),2),'Flows Out of Cash and CBDC',[],CFBs,cut,'')
subplot(2,6,11)
plott_cf(f*sum(trackRin(:,B+1:B+2,1),2)-f*sum(trackRout(:,B+1:B+2,1),2),'Net Flows To C+CBDC (In-Out)',[],CFBs,cut,'0')
subplot(2,6,12)
plott_cf(f*sum(trackRin(:,:,1)-trackRout(:,:,1),2),'Total Net Flows (In-Out)',[],CFBs,cut,'none')
ylim([-1 1])
if savefigs==1
    saveas(gcf,[prefix 'Fig 9 - Reserve Flows 1.png'])
    close
end

%% Figure 10: Reserve flows due to non-bank agents spending
figure('units','normalized','outerposition',[0 0 1 1])
sgtitle({'Reserve Flows due to Non-Banks'' Spending',['(in ' unit ', p.a.)']},'FontSize',18,'FontName', 'Arial')
subplot(2,6,1)
plott_cf(f*trackRin(:,1:B,2),'Flows To Banks',[],CFBs,cut,'')
subplot(2,6,2)
plott_cf(f*trackRout(:,1:B,2),'Flows Out of Banks',[],CFBs,cut,'')
subplot(2,6,3)
plott_cf(f*trackRin(:,B+1,2),'Flows To Cash',[],CFBs,cut,'')
subplot(2,6,4)
plott_cf(f*trackRout(:,B+1,2),'Flows Out of Cash',[],CFBs,cut,'')
subplot(2,6,5)
plott_cf(f*trackRin(:,B+2,2),'Flows To CBDC',[],CFBs,cut,'')
subplot(2,6,6)
plott_cf(f*trackRout(:,B+2,2),'Flows Out of CBDC',[],CFBs,cut,'')
subplot(2,6,7)
plott_cf(f*sum(trackRin(:,1:B,2),2),'Flows To Banks (S)',[],CFBs,cut,'')
subplot(2,6,8)
plott_cf(f*sum(trackRout(:,1:B,2),2),'Flows Out of Banks (S)',[],CFBs,cut,'')
subplot(2,6,9)
plott_cf(f*sum(trackRin(:,B+1:B+2,2),2),'Flows To Cash and CBDC',[],CFBs,cut,'')
subplot(2,6,10)
plott_cf(f*sum(trackRout(:,B+1:B+2,2),2),'Flows Out of Cash and CBDC',[],CFBs,cut,'')
subplot(2,6,11)
plott_cf(f*sum(trackRin(:,B+1:B+2,2),2)-f*sum(trackRout(:,B+1:B+2,2),2),'Net Flows To Cash+CBDC (In-Out)',[],CFBs,cut,'0')
subplot(2,6,12)
plott_cf(f*sum(trackRin(:,:,2)-trackRout(:,:,2),2),'Total Net Flows (In-Out)',[],CFBs,cut,'none')
ylim([-1 1])
if savefigs==1
    saveas(gcf,[prefix 'Fig 10 - Reserve Flows 2.png'])
    close
end

%% Figure 11: Reserve ratios
figure('units','normalized','outerposition',[0 0 1 1])
sgtitle('Reserve Ratios (e.o.p.)','FontSize',18,'FontName', 'Arial')
subplot(1,2,1)
plott_cf(0.5*(BS.BA.R(1:T-1,:)+BS.BA.R(2:T,:))./(0.5*(BS.BA.D(1:T-1,:)+BS.BA.D(2:T,:))),'Reserves/Deposits (p.av.) - Banks',[],CFBs,cut,'')
x1 = get(gca,'ylim');
subplot(1,2,2)
plott_cf(0.5*(sum(BS.BA.R(1:T-1,:),2)+sum(BS.BA.R(2:T,:),2))./(0.5*(sum(BS.BA.D(1:T-1,:),2)+sum(BS.BA.D(2:T,:),2))),'Reserves/Deposits (p.av.) - Banking System',[],CFBs,cut,'')
x2 = get(gca,'ylim');
subplot(1,2,1)
ylim([0 max([x1(2) x2(2)])])
subplot(1,2,2)
ylim([0 max([x1(2) x2(2)])])
if savefigs==1
    saveas(gcf,[prefix 'Fig 11 - Reserve Ratios.png'])
    close
end

%% Figure 12: Cash and CBDC ratios
figure('units','normalized','outerposition',[0 0 1 1])
ax = axes;
sgtitle('Shares of Deposits, Cash, and CBDC in Total Money (e.o.p.)','FontSize',20,'FontName', 'Arial')
area([sum(BS.BA.D,2)./sum(BS.NB.M,2) BS.CB.C./sum(BS.NB.M,2) BS.CB.DC./sum(BS.NB.M,2)],'edgecolor','none')
xlim([1 T+1])
ylim([0 1])
lbs = {'','A','B','C','D','E','F'}; % labels
xline(1,'-k')
for w=2:length(CFBs)
    xl = xline(CFBs(w),'-k',lbs(w),'linewidth',1);
    xl.LabelOrientation = 'horizontal';
end
legend('Deposits','Cash','CBDC','location','best')
ax.ColorOrder = IMFmap;
ax.FontSize = 14;
if savefigs==1
    saveas(gcf,[prefix 'Fig 12 - Money Shares.png'])
    close
end

%% Figure 13: Banks' and CB net reserve position
figure('units','normalized','outerposition',[0 0 1 1])
sgtitle({'Banks'' and CB Net Reserve Position',['(in ' unit ', e.o.p.)']},'FontSize',18,'FontName', 'Arial')
subplot(2,2,1)
plott_cf(BS.BA.R-BS.BA.B,'Banks'' Reserve Holding (A) - Borrowing (L)',[],CFBs,cut,'')
subplot(2,2,2)
plott_cf(BS.CB.B-BS.CB.R,'Central Bank BS: Reserve Lending (A) - Holding (L)',[],CFBs,cut,'')
subplot(2,2,4)
area([BS.CB.R BS.CB.C BS.CB.DC],'edgecolor','none')
xl = xline(1,'-k');
for w=2:length(CFBs)
    xl = xline(CFBs(w),'-k',lbs(w),'linewidth',1);
    xl.LabelOrientation = 'horizontal';
end
ax = gca;
ax.ColorOrder = IMFmap;
xlim([1 T+1])
legend('Banks'' R. Holdings','Cash','CBDC','location','best')
title('Central Bank Liabilities')
subplot(2,2,3)
plott_cf(sum(BS.BA.R-BS.BA.B,2),'Banks'' Reserve Holding (A) - Borrowing (L) (S)',[],CFBs,cut,'')
if savefigs==1
    saveas(gcf,[prefix 'Fig 13 - Reserve Position.png'])
    close
end

clear f