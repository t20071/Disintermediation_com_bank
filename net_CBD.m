%% Reserve netting

countsC = NaN(1,4);

% Case 0: Both R and CBD at zero *OR* positive R and zero CBD *OR* positive CBD and zero R --> no action
r0 = ( BS.BA.R(t+1,:)>=0 & BS.BA.B(t+1,:)==0 ) | (BS.BA.R(t+1,:)==0 & BS.BA.B(t+1,:)>0);
countsC(1) = sum(r0);

% Case 1: Pay back reserve borrowings in full
r1 = ( BS.BA.R(t+1,:) >= BS.BA.B(t+1,:) ) & BS.BA.B(t+1,:)>0;
countsC(2) = sum(r1);
if sum(r1)>0 && sum(BS.BA.B(t+1,:))>0
    BS.CB.B(t+1) = BS.CB.B(t+1) - sum(BS.BA.B(t+1,r1));  % CB's asset side shrinks
    BS.CB.R(t+1) = BS.CB.R(t+1) - sum(BS.BA.B(t+1,r1));  % CB's liability side shrinks
    BS.BA.R(t+1,r1) = BS.BA.R(t+1,r1) - BS.BA.B(t+1,r1); % bank's asset side shrinks
    BS.BA.B(t+1,r1) = 0; % bank's liability side
end

% Case 2: Pay back partially
r2 = ( BS.BA.R(t+1,:) < BS.BA.B(t+1,:) ) & BS.BA.R(t+1,:)>0;
countsC(3) = sum(r2);
if sum(r2)>0
    BS.CB.B(t+1) = BS.CB.B(t+1) - sum(BS.BA.R(t+1,r2));  % CB's asset side shrinks
    BS.CB.R(t+1) = BS.CB.R(t+1) - sum(BS.BA.R(t+1,r2));  % CB's liability side shrinks
    BS.BA.B(t+1,r2) = BS.BA.B(t+1,r2) - BS.BA.R(t+1,r2); % bank's liability side shrinks
    BS.BA.R(t+1,r2) = 0; % bank's asset side shrinks
end

% Case 3: Borrow more reserves
r3 = BS.BA.R(t+1,:)<0;
countsC(4) = sum(r3);
if sum(r3)>0
    BS.CB.B(t+1) = BS.CB.B(t+1) - sum(BS.BA.R(t+1,r3));  % CB's asset side grows
    BS.CB.R(t+1) = BS.CB.R(t+1) - sum(BS.BA.R(t+1,r3));  % CB's liability side grows
    BS.BA.B(t+1,r3) = BS.BA.B(t+1,r3) - BS.BA.R(t+1,r3); % banks' liability side grows
    BS.BA.R(t+1,r3) = 0; % banks' asset side grows to zero
end

if sum(sum(1*r0+1*r1+1*r2+1*r3,1))~=B
    error('.')
end

% Reserve requirement
raise = max(0,lambda*BS.BA.D(t+1,:)-BS.BA.R(t+1,:));
BS.BA.R(t+1,:) = BS.BA.R(t+1,:) + raise;
BS.BA.B(t+1,:) = BS.BA.B(t+1,:) + raise;
BS.CB.R(t+1) = BS.CB.R(t+1) + sum(raise);
BS.CB.B(t+1) = BS.CB.B(t+1) + sum(raise);

clear r0 r1 r2 r3 raise