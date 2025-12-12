function n_per_firm = distrib(N,F)

% Distribute N workers to F firms. N must be larger/equal F.

%% Inputs
%  N  scalar, number of workers
%  F  scalar, number of firms

%% Output
%  n_per_firm  1xF vector

n_per_firm = floor(N/F)*ones(1,F); 
n_per_firm(end) = n_per_firm(end) + N-sum(n_per_firm);
if sum(n_per_firm==0)>1
    error('Some firms don''t have workers. Make sure that N>=F.')
end


