function w = where(CFBs,t)

if CFBs(1)~=1, error(' '), end
if sum(CFBs<1)>0, error(' '), end
if length(unique(CFBs))<length(CFBs), error(' '), end

x = find(CFBs<t+1);
w = x(end);

end

