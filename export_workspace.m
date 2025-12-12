%% Export all workspace variables to CSV files

% Create export folder
exportFolder = 'exported_workspace_csv';
if ~exist(exportFolder, 'dir')
    mkdir(exportFolder);
end

fprintf('Starting export of workspace variables...\n');

%% Export simple numeric/cell arrays
simpleVars = {'alphas', 'alphas_', 'avrate', 'b', 'bb', 'beta', 'beta_', 'B', ...
              'capcon', 'cCBcases1', 'cCBcases2', 'countsC', 'cut', 'CFBs', ...
              'd', 'delta', 'delta_', 'e', 'effgamma', 'effgamma_S', 'efficbdc', ...
              'eqi', 'eqms', 'expl', 'f', 'g', 'G', 'G_', 'gamma', 'gamma_', ...
              'iG', 'ILdue', 'lambda', 'lambda_', 'M', 'mA', 'mB', 'MbeforeIL', ...
              'mu', 'N', 'NatB_D', 'NatB_D_Last', 'NatB_L', 'nest', 'nest_', ...
              'NperB_D', 'NperB_L', 'Ntar', 'pB', 'prefix', 'ps', 'qu', ...
              'q', 'rates', 'ratesL', 'ratesL_S', 'rB', 'rDC', 'rDC_', ...
              'rH', 'rs', 'savefigs', 'T', 'trackPAV_B', 'trackPAV_R', ...
              'trackRin', 'trackRout', 'ts', 'u', 'u0', 'u1', 'u2', ...
              'unit', 'vol1', 'vol2', 'w', 'c_expLmiss'};

for i = 1:length(simpleVars)
    varName = simpleVars{i};
    if evalin('base', ['exist(''', varName, ''', ''var'')'])
        try
            varData = evalin('base', varName);
            if isnumeric(varData)
                writematrix(varData, fullfile(exportFolder, [varName '.csv']));
                fprintf('Exported: %s\n', varName);
            elseif iscell(varData)
                writecell(varData, fullfile(exportFolder, [varName '.csv']));
                fprintf('Exported: %s\n', varName);
            elseif ischar(varData) || isstring(varData)
                writematrix(varData, fullfile(exportFolder, [varName '.csv']));
                fprintf('Exported: %s\n', varName);
            end
        catch
            warning('Could not export: %s', varName);
        end
    end
end

%% Export BS (Balance Sheet) structure
if exist('BS', 'var')
    % BS.NB (Non-bank balance sheets)
    if isfield(BS, 'NB')
        writematrix(BS.NB.M, fullfile(exportFolder, 'BS_NB_M.csv'));
        writematrix(BS.NB.L, fullfile(exportFolder, 'BS_NB_L.csv'));
        fprintf('Exported: BS.NB (M and L)\n');
    end
    
    % BS.BA (Bank balance sheets)
    if isfield(BS, 'BA')
        writematrix(BS.BA.R, fullfile(exportFolder, 'BS_BA_R.csv'));
        writematrix(BS.BA.L, fullfile(exportFolder, 'BS_BA_L.csv'));
        writematrix(BS.BA.D, fullfile(exportFolder, 'BS_BA_D.csv'));
        writematrix(BS.BA.B, fullfile(exportFolder, 'BS_BA_B.csv'));
        fprintf('Exported: BS.BA (R, L, D, B)\n');
    end
    
    % BS.CB (Central Bank balance sheets)
    if isfield(BS, 'CB')
        writematrix(BS.CB.B, fullfile(exportFolder, 'BS_CB_B.csv'));
        writematrix(BS.CB.R, fullfile(exportFolder, 'BS_CB_R.csv'));
        writematrix(BS.CB.C, fullfile(exportFolder, 'BS_CB_C.csv'));
        writematrix(BS.CB.DC, fullfile(exportFolder, 'BS_CB_DC.csv'));
        fprintf('Exported: BS.CB (B, R, C, DC)\n');
    end
end

%% Export FL (Flows) structure
if exist('FL', 'var')
    % FL.NB (Non-bank flows)
    if isfield(FL, 'NB')
        writematrix(FL.NB.incD, fullfile(exportFolder, 'FL_NB_incD.csv'));
        writematrix(FL.NB.incDC, fullfile(exportFolder, 'FL_NB_incDC.csv'));
        writematrix(FL.NB.incS, fullfile(exportFolder, 'FL_NB_incS.csv'));
        writematrix(FL.NB.incC, fullfile(exportFolder, 'FL_NB_incC.csv'));
        writematrix(FL.NB.expC, fullfile(exportFolder, 'FL_NB_expC.csv'));
        writematrix(FL.NB.expL, fullfile(exportFolder, 'FL_NB_expL.csv'));
        writematrix(FL.NB.incDIV, fullfile(exportFolder, 'FL_NB_incDIV.csv'));
        fprintf('Exported: FL.NB (all flows)\n');
    end
    
    % FL.BA (Bank flows)
    if isfield(FL, 'BA')
        writematrix(FL.BA.incR, fullfile(exportFolder, 'FL_BA_incR.csv'));
        writematrix(FL.BA.incL, fullfile(exportFolder, 'FL_BA_incL.csv'));
        writematrix(FL.BA.expR, fullfile(exportFolder, 'FL_BA_expR.csv'));
        writematrix(FL.BA.expD, fullfile(exportFolder, 'FL_BA_expD.csv'));
        writematrix(FL.BA.ni, fullfile(exportFolder, 'FL_BA_ni.csv'));
        writematrix(FL.BA.div, fullfile(exportFolder, 'FL_BA_div.csv'));
        fprintf('Exported: FL.BA (all flows)\n');
    end
    
    % FL.CB (Central Bank flows)
    if isfield(FL, 'CB')
        writematrix(FL.CB.incR, fullfile(exportFolder, 'FL_CB_incR.csv'));
        writematrix(FL.CB.expR, fullfile(exportFolder, 'FL_CB_expR.csv'));
        writematrix(FL.CB.expDC, fullfile(exportFolder, 'FL_CB_expDC.csv'));
        writematrix(FL.CB.seign, fullfile(exportFolder, 'FL_CB_seign.csv'));
        fprintf('Exported: FL.CB (all flows)\n');
    end
end

%% Export axes object (skip - cannot export to CSV)
fprintf('Skipped: ax (graphics object, cannot export to CSV)\n');

%% Create summary file with variable info
summaryFile = fullfile(exportFolder, '_SUMMARY_variables.txt');
fid = fopen(summaryFile, 'w');
fprintf(fid, 'Workspace Variables Export Summary\n');
fprintf(fid, 'Export Date: %s\n\n', datestr(now));
fprintf(fid, 'Total variables exported: Check the folder\n');
fprintf(fid, 'Export folder: %s\n\n', exportFolder);
fprintf(fid, 'Structure variables:\n');
fprintf(fid, '- BS.NB: Non-bank balance sheets (M, L)\n');
fprintf(fid, '- BS.BA: Bank balance sheets (R, L, D, B)\n');
fprintf(fid, '- BS.CB: Central Bank balance sheets (B, R, C, DC)\n');
fprintf(fid, '- FL.NB: Non-bank flows (incD, incDC, incS, incC, expC, expL, incDIV)\n');
fprintf(fid, '- FL.BA: Bank flows (incR, incL, expR, expD, ni, div)\n');
fprintf(fid, '- FL.CB: Central Bank flows (incR, expR, expDC, seign)\n');
fclose(fid);

fprintf('\n=== Export Complete ===\n');
fprintf('All variables exported to folder: %s\n', exportFolder);
fprintf('Summary file created: %s\n', summaryFile);