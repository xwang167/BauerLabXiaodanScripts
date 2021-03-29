excelFile = 'D:\Colonna\ColonnaGCAMP.xlsx';
excelRows = 50:53;
runsInfo = parseTiffRuns(excelFile,excelRows);
import mouse.*
runInd = 0;
runNum = numel(runsInfo);
for runInfo = runsInfo;
    % this function gives an example of how excel file is read, the data is
    % loaded, invalid frames are removed, and processed to save hemoglobin and
    % fluorescence dynamics data.
    % The excel file uses the format Annie uses, which has one mouse data per
    % row and minimal amount of information about sampling rate and other
    % parameters. Thus, some of these parameters are assumed and hardcoded
    % here.
    %
    % Inputs:
    %   excelFile = character array of the excel file to be read. Ex:
    %   'example.xlsx'
    %   excelRows = which rows in the excel file should be read and processed?
    %   Ex: 2:4
    
    excelRows(excelRows == 1) = [];
    
    %% read excel file to get information about each mouse run
    % [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    %     recDate = excelRaw{1}; recDate = string(recDate);
    %     mouseName = excelRaw{2}; mouseName = string(mouseName);
    %     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    %     rawdataloc = excelRaw{3};
    %     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    
    
    %for runInd = runs % for each run
    runInd = runInd+1;
    disp(['Trial # ' num2str(runInd) '/' num2str(runNum)]);
    
    load(runInfo.saveHbFile,'xform_datahb');
    load(runInfo.saveFluorFile,'xform_datafluor','fluorTime')
    [xform_datafluorDs, fluorTimeDs] = mouse.freq.resampledata(xform_datafluor,fluorTime,9);
    muspFcn = @(x,y) (40*(x/500).^-1.16)'*y;
    [op_in, E_in] = getHbOpticalProperties_xw(muspFcn,"C:\Users\xiaodanwang\Documents\GitHub\BauerLab\Matlab\parameters\+bauerParams\ledSpectra\M470nm_SPF_pol.txt");%fluorProcInfo.OpticalPropertyIn.LightSourceFiles);
    [op_out, E_out] = getHbOpticalProperties_xw(muspFcn,"C:\Users\xiaodanwang\Documents\GitHub\BauerLab\Matlab\parameters\+bauerParams\probeSpectra\gcamp6f_emission.txt");%fluorProcInfo.OpticalPropertyOut.LightSourceFiles);
    
    dpIn = op_in.dpf/2;
    dpOut = op_out.dpf/2;
    
    xform_datafluorCorr = correctHb_differentBeta(xform_datafluorDs,xform_datahb,[E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut,0.7,0.8);
    systemInfo.gbox = 5;
    systemInfo.gsigma = 1.2;
    xform_datafluorCorr = process.smoothImage(xform_datafluorCorr,systemInfo.gbox,systemInfo.gsigma);
    reCorrect = true;
    save(runInfo.saveFluorFile,'xform_datafluorCorr','reCorrect','-append')
    %end
end


