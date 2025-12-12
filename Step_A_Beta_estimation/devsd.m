function out = devsd(p)
global yy
out = 1000*sum((diff(yy)-diff(fit(p))).^2);
end