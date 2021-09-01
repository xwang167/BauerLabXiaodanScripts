close all;clearvars -except hz;clc
import mice.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [ 202 195 204 230 234 240];%[181 183 185  228 232 236];
isZTransform = true;
set(0,'defaultaxesfontsize',12);

info.nVx = 128;
info.nVy = 128;
numMice = length(excelRows);
xform_isbrain_mice = 1;
sessionInfo.miceType = 'jrgeco1a';
saveDir_cat = 'L:\RGECO\cat';

R_total_Delta_mice  = zeros(info.nVy,info.nVx,16,numMice);
R_total_ISA_mice  = zeros(info.nVy,info.nVx,16,numMice);
Rs_total_Delta_mice = zeros(16,16,numMice);
Rs_total_ISA_mice = zeros(16,16,numMice);
%     

miceName = [];
miceName_powerdata = [];
ll = 1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = char(strcat(miceName, '-', mouseName));
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{11};
    rawdataloc = excelRaw{3};
    info.nVx = 128;
    info.nVy = 128;
    systemType =excelRaw{5};
    sessionInfo.darkFrameNum = excelRaw{11};
    sessionInfo.framerate = excelRaw{7};
    goodRuns = str2num(excelRaw{18});
    if strcmp(char(sessionInfo.miceType),'WT')
        systemInfo.numLEDs = 2;
    elseif strcmp(char(sessionInfo.miceType),'jrgeco1a')
        systemInfo.numLEDs = 3;
    end
        maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
        if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
            load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
            load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-','LandmarksAndMask.mat')),'affineMarkers')
        else
            maskDir = saveDir;
            maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
            load(fullfile(maskDir,maskName),'affineMarkers','xform_isbrain','isbrain')
        end
    
%    load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataHb','.mat')),'xform_isbrain');
    xform_isbrain(xform_isbrain ==2)=1;
    xform_isbrain = double(xform_isbrain);
    
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    xform_isbrain(isinf(xform_isbrain)) = 0;
    xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
    
    
    processedName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed_newOrder.mat');
    
    if strcmp(sessionType,'fc')
        if strcmp(char(sessionInfo.miceType),'jrgeco1a')
            
            
            
            load(fullfile(saveDir, processedName),'R_total_Delta_mouse','R_total_ISA_mouse','R_jrgeco1aCorr_Delta_mouse','R_jrgeco1aCorr_ISA_mouse','R_FADCorr_Delta_mouse','R_FADCorr_ISA_mouse',...
                'Rs_total_Delta_mouse','Rs_total_ISA_mouse','Rs_jrgeco1aCorr_Delta_mouse','Rs_jrgeco1aCorr_ISA_mouse', 'Rs_FADCorr_Delta_mouse','Rs_FADCorr_ISA_mouse')
            
            R_total_Delta_mice(:,:,:,ll) = atanh(R_total_Delta_mouse);
            R_total_ISA_mice(:,:,:,ll) = atanh(R_total_ISA_mouse);
            Rs_total_Delta_mice(:,:,ll) = atanh(Rs_total_Delta_mouse);
            Rs_total_ISA_mice(:,:,ll) = atanh(Rs_total_ISA_mouse);
            
            R_jrgeco1aCorr_Delta_mice(:,:,:,ll) = atanh(R_jrgeco1aCorr_Delta_mouse);
            R_jrgeco1aCorr_ISA_mice(:,:,:,ll) = atanh(R_jrgeco1aCorr_ISA_mouse);
            Rs_jrgeco1aCorr_Delta_mice(:,:,ll) = atanh(Rs_jrgeco1aCorr_Delta_mouse);
            Rs_jrgeco1aCorr_ISA_mice(:,:,ll) = atanh(Rs_jrgeco1aCorr_ISA_mouse);

            
            R_FADCorr_Delta_mice(:,:,:,ll) = atanh(R_FADCorr_Delta_mouse);
            R_FADCorr_ISA_mice(:,:,:,ll) = atanh(R_FADCorr_ISA_mouse);
            Rs_FADCorr_Delta_mice(:,:,ll) = atanh(Rs_FADCorr_Delta_mouse);
            Rs_FADCorr_ISA_mice(:,:,ll) = atanh(Rs_FADCorr_ISA_mouse);
            
        end
        ll = ll+1;
    end
end
processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'_newOrder.mat');
R_total_Delta_mice  = mean(R_total_Delta_mice,4);
R_total_ISA_mice  = mean(R_total_ISA_mice,4);
Rs_total_Delta_mice = mean(Rs_total_Delta_mice,3);
Rs_total_ISA_mice = mean(Rs_total_ISA_mice,3);


R_jrgeco1aCorr_Delta_mice = mean(R_jrgeco1aCorr_Delta_mice,4);
R_jrgeco1aCorr_ISA_mice  = mean(R_jrgeco1aCorr_ISA_mice,4);
Rs_jrgeco1aCorr_Delta_mice = mean(Rs_jrgeco1aCorr_Delta_mice,3);
Rs_jrgeco1aCorr_ISA_mice = mean(Rs_jrgeco1aCorr_ISA_mice,3);

R_FADCorr_Delta_mice = mean(R_FADCorr_Delta_mice,4);
R_FADCorr_ISA_mice  = mean(R_FADCorr_ISA_mice,4);
Rs_FADCorr_Delta_mice = mean(Rs_FADCorr_Delta_mice,3);
Rs_FADCorr_ISA_mice = mean(Rs_FADCorr_ISA_mice,3);


save(fullfile(saveDir_cat, processedName_mice),'R_total_ISA_mice','R_jrgeco1aCorr_ISA_mice','R_FADCorr_ISA_mice',...
    'R_total_Delta_mice','R_jrgeco1aCorr_Delta_mice','R_FADCorr_Delta_mice',...
    'Rs_total_ISA_mice','Rs_jrgeco1aCorr_ISA_mice','Rs_FADCorr_ISA_mice',...
    'Rs_total_Delta_mice','Rs_jrgeco1aCorr_Delta_mice','Rs_FADCorr_Delta_mice')



disp(char(['QC check on ', processedName_mice]))
if strcmp(char(sessionInfo.miceType),'jrgeco1a')
    
    refseeds=GetReferenceSeeds;   
    xform_isbrain_mice =ones(128,128);
    xform_isbrain_mice(isnan(R_total_Delta_mice(:,:,1))) = 0;   
    visName = 'Anes RGECO-New Order';
    QCcheck_fcVis(refseeds,R_jrgeco1aCorr_ISA_mice, Rs_jrgeco1aCorr_ISA_mice,'jrgeco1aCorr','m','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
    QCcheck_fcVis(refseeds,R_FADCorr_ISA_mice, Rs_FADCorr_ISA_mice,'FADCorr','g','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
    QCcheck_fcVis(refseeds,R_total_ISA_mice, Rs_total_ISA_mice,'total','k','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
    
    QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_mice, Rs_jrgeco1aCorr_Delta_mice,'jrgeco1aCorr','m','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
    QCcheck_fcVis(refseeds,R_FADCorr_Delta_mice, Rs_FADCorr_Delta_mice,'FADCorr','g','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
    QCcheck_fcVis(refseeds,R_total_Delta_mice, Rs_total_Delta_mice,'total','k','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
end
close all



