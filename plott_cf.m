function [] = plott_cf(y,str,yl,CFBs,cut,special)

%% Inputs
%  y        TxN data
%  str      string, title
%  yl       string, label for y axis, can be left empty
%  CFBs     1xW vector, starting pts of the counterfactual windows
%  cut      scalar>=0, number of periods to exclude at the beginning of each window for calculating median per window
%  special  string: '0' or 'eq' or 'none'

lbs = {'','A','B','C','D','E','F'}; % labels

[~, N] = size(y);

W = length(CFBs);
if W<2, error(' '), end
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

%% Plot
p = plot(y);
xlim([1 size(y,1)])
hold on
title(str, 'FontSize',14,'FontName', 'Arial')
ax = gca;

ax.FontSize = 12;
if ~isempty(yl) 
    if ~strcmp(yl, 'SKIP')
        ylabel(yl) 
        ax.ColorOrder = IMFmap;
    else
        ax.ColorOrder = IMFmap([1,3,2,4:end],:);
    end
else
    ax.ColorOrder = IMFmap;
end
  

if N>1
    for i=1:length(p) % make plot with many line semi-tranparent
        p(i).Color = [p(i).Color 0.5];  % alpha=0.5
    end
end
%% Medians
if strcmp(special,'none')~=1
    L = NaN(size(y,1),1);
    d = [];
    L(cut+1:CFBs(2)) = nanmedian(nanmedian(y(cut+1:CFBs(2),:),2));
    d = [d;y(cut+1:CFBs(2),:)];
    for w=2:W
        if w<W
            L(CFBs(w)+cut-1:CFBs(w+1)) = nanmedian(nanmedian(y(CFBs(w)+cut-1:CFBs(w+1),:),2));
            d = [d;y(CFBs(w)+cut-1:CFBs(w+1),:)]; %#ok<*AGROW>
        else
            L(CFBs(w)+cut-1:end) = nanmedian(nanmedian(y(CFBs(w)+cut-1:end,:),2));
            d = [d;y(CFBs(w)+cut-1:end,:)];
        end
    end
    if strcmp(special,'0')==1
        L(~isnan(L)) = 0;
    end
    if strcmp(special,'eq')==1
        L(~isnan(L)) = nanmedian(nanmedian(d,2));
    end
    plot(L,'-k','linewidth',0.8)
end

%% Vertical lines
xl = xline(1,'-k',lbs(1));
xl.LabelOrientation = 'horizontal';
for w=2:W
    xl = xline(CFBs(w),'-k',lbs(w),'linewidth',1.2);
    xl.LabelOrientation = 'horizontal';
end