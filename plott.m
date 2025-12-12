function [] = plott(y,str,yl)

plot(y)
xlim([1 size(y,1)])
title(str)
if ~isempty(yl)
    ylabel(yl)
end
    
end

