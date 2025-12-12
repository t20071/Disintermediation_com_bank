function [] = progressline(i,I,itxt)

% Purpose: Display a progress counter in one line.

%% Required input:
%  i        scalar, counter in a loop up to I
%  I        scalar, loop total

%% Optional input:
%  itxt     string, text to start with

%% Suggested use:
% I = 10;
% for i=1:I
%     ...
%     progressline(i,I,'Progress:')
% end

if i>I, error('i shall be <= I'), end
if exist('itxt','var'), if ~isempty(itxt), if strcmp(itxt(end),' ')==1, itxt(end) = []; end, end, else itxt = ''; end
if isempty(itxt), ini = []; else ini = [itxt ' ']; end %#ok<*SEPEX>
if i==1, r = ''; else r = repmat(sprintf('\b'),1,length(sprintf([ini '%d/%d'],i-1,I))); end
m = sprintf([ini '%d/%d'],i,I); fprintf([r,m]);
if i==I, fprintf('\n'), end % new line when i==I