function [] = plott_q(y,title_p,yl,CFBs,cut,special)
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
    ]./255 ;
[XX, ~] = size(y);
plot(median(y,2),'Color',IMFmap(1,:))
for x = 1:3
    yCI_low = quantile(y,0.1*x, 2);
    yCI_high = quantile(y, 1 - 0.1*x, 2);
    patch([1:XX, fliplr(1:XX)], [yCI_low', fliplr(yCI_high') ], IMFmap(1,:), 'EdgeColor','none', 'FaceAlpha',0.2)
end
xlim([1 XX])
title(title_p, 'FontSize',14,'FontName', 'Arial')
ax = gca;
ax.FontSize = 12;

%% Vertical lines
lbs = {'','A','B','C','D','E','F'}; % labels
W = length(CFBs);
xl = xline(1,'-k',lbs(1));
xl.LabelOrientation = 'horizontal';
for w=2:W
    xl = xline(CFBs(w),'-k',lbs(w),'linewidth',1);
    xl.LabelOrientation = 'horizontal';
end
end