function str = pn(pno)

if pno<1, error('.'), end

str = 'p(1)';
c = 2;
for i=1:pno
    str = [str ' + p(' num2str(c) ')*x1.^' num2str(c-1)]; %#ok<*AGROW>
    c = c+1;
end
d = 2;
for i=1:pno
    str = [str ' + p(' num2str(c) ')*x2.^' num2str(d-1)];
    c = c+1;
    d = d+1;
end
for i=1:pno
    for j=1:pno
        str = [str ' + p(' num2str(c) ')*(x1.^(' num2str(i) ')).*(x2.^(' num2str(j) '))'];
        c = c+1;
    end
end