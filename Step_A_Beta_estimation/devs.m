function out = devs(p)
global yy
out = 1000*sum((yy-fit(p)).^2);
end