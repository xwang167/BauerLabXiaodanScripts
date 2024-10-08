% close all;clear all;clc
% import mouse.*
% excelFile = "L:\RGECO\RGECO.xlsx";
% excelRows = 2:13;%:450;
% runs = 1:3;
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     sessionInfo.darkFrameNum = excelRaw{15};
%     sessionInfo.mouseType = excelRaw{17};
%     systemType =excelRaw{5};
%     maskDir_new = saveDir;
%     rawdataloc = excelRaw{3};
%     sessionInfo.framerate = excelRaw{7};
%     systemInfo.numLEDs = 4;
%     maskName_new = strcat(recDate,'-N8M864-opto3-LandmarksAndMask','.mat');
%     maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
%     maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
%     if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
%         load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
%         load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-','LandmarksAndMask.mat')),'affineMarkers')
%     else
%         maskDir = saveDir;
%         maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
%         load(fullfile(maskDir,maskName),'affineMarkers','xform_isbrain','isbrain')
%     end
% 
%     for n = runs
%         visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
% 
%         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
%         if exist(fullfile(saveDir,processedName),'file')
%             sessionInfo.bandtype_ISA = {"ISA",0.009,0.08};
%             sessionInfo.bandtype_Delta = {"Delta",0.4,4};
%             refseeds=GetReferenceSeeds;
%       
%             load(fullfile(saveDir, processedName),...
%                 'R_jrgeco1aCorr_ISA','Rs_jrgeco1aCorr_ISA','R_FADCorr_ISA','Rs_FADCorr_ISA','R_total_ISA','Rs_total_ISA',...
%                 'R_jrgeco1aCorr_Delta','Rs_jrgeco1aCorr_Delta','R_FADCorr_Delta','Rs_FADCorr_Delta','R_total_Delta','Rs_total_Delta')
% 
%             load(fullfile(saveDir, processedName),'R_jrgeco1aCorr_inter','Rs_jrgeco1aCorr_inter',...
%                 'R_FADCorr_inter','Rs_FADCorr_inter','R_total_inter','Rs_total_inter')
% 
%             QCcheck_fcVis(refseeds,R_jrgeco1aCorr_inter, Rs_jrgeco1aCorr_inter,'jrgeco1aCorr','m','inter',saveDir,visName,false,xform_isbrain)
%             QCcheck_fcVis(refseeds,R_FADCorr_inter, Rs_FADCorr_inter,'FADCorr','g','inter',saveDir,visName,false,xform_isbrain)
%             QCcheck_fcVis(refseeds,R_total_inter, Rs_total_inter,'total','k','inter',saveDir,visName,false,xform_isbrain)
%             close all
% 
%             QCcheck_fcVis(refseeds,R_jrgeco1aCorr_ISA, Rs_jrgeco1aCorr_ISA,'jrgeco1aCorr','m','ISA',saveDir,visName,false,xform_isbrain)
%             QCcheck_fcVis(refseeds,R_FADCorr_ISA, Rs_FADCorr_ISA,'FADCorr','g','ISA',saveDir,visName,false,xform_isbrain)
%             QCcheck_fcVis(refseeds,R_total_ISA, Rs_total_ISA,'total','k','ISA',saveDir,visName,false,xform_isbrain)
%             close all
% 
%             QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta, Rs_jrgeco1aCorr_Delta,'jrgeco1aCorr','m','Delta',saveDir,visName,false,xform_isbrain)
%             QCcheck_fcVis(refseeds,R_FADCorr_Delta, Rs_FADCorr_Delta,'FADCorr','g','Delta',saveDir,visName,false,xform_isbrain)
%             QCcheck_fcVis(refseeds,R_total_Delta, Rs_total_Delta,'total','k','Delta',saveDir,visName,false,xform_isbrain)
%             close all
% 
%         end
%     end
% end
% 
% 
% length_runs = length(runs);
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     sessionInfo.darkFrameNum = excelRaw{15};
%     rawdataloc = excelRaw{3};
%     info.nVx = 128;
%     info.nVy = 128;
%     sessionInfo.mouseType = excelRaw{17};
%     systemType =excelRaw{5};
%     sessionInfo.framerate = excelRaw{7};
%     goodRuns = str2num(excelRaw{18});
%     
%     if strcmp(char(sessionInfo.mouseType),'WT')
%         systemInfo.numLEDs = 2;
%     elseif strcmp(char(sessionInfo.mouseType),'gcamp6f')
%         systemInfo.numLEDs = 3;
%     end
%     maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
%     if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor','.mat')))
%         
%         load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor','.mat')),'xform_isbrain');
%         
%     else
%         maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
%         load(fullfile(saveDir,maskName), 'xform_isbrain')
%     end
%     xform_isbrain(xform_isbrain ==2)=1;
%     xform_isbrain = double(xform_isbrain);
%     if ~isempty(find(isnan(xform_isbrain), 1))
%         xform_isbrain(isnan(xform_isbrain))=0;
%     end
%     processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
%     visName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed');
%     
%     
%     load(fullfile(saveDir, processedName_mouse),'R_total_ISA_mouse','R_jrgeco1aCorr_ISA_mouse','R_FADCorr_ISA_mouse',...
%         'R_total_Delta_mouse','R_jrgeco1aCorr_Delta_mouse','R_FADCorr_Delta_mouse',...
%         'Rs_total_ISA_mouse','Rs_jrgeco1aCorr_ISA_mouse','Rs_FADCorr_ISA_mouse',...
%         'Rs_total_Delta_mouse','Rs_jrgeco1aCorr_Delta_mouse','Rs_FADCorr_Delta_mouse')
%     
%     
%     load(fullfile(saveDir, processedName_mouse),'R_total_inter_mouse','R_jrgeco1aCorr_inter_mouse','R_FADCorr_inter_mouse',...
%         'Rs_total_inter_mouse','Rs_jrgeco1aCorr_inter_mouse','Rs_FADCorr_inter_mouse')
%     visName = strcat(recDate,'-',mouseName,'-',sessionType);
%     
%     
%     refseeds=GetReferenceSeeds;
%     QCcheck_fcVis(refseeds,R_jrgeco1aCorr_ISA_mouse, Rs_jrgeco1aCorr_ISA_mouse,'jrgeco1aCorr','m','ISA',saveDir,visName,false,xform_isbrain)
%     QCcheck_fcVis(refseeds,R_FADCorr_ISA_mouse, Rs_FADCorr_ISA_mouse,'FADCorr','g','ISA',saveDir,visName,false,xform_isbrain)
%     QCcheck_fcVis(refseeds,R_total_ISA_mouse, Rs_total_ISA_mouse,'total','k','ISA',saveDir,visName,false,xform_isbrain)
%     
%     QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_mouse, Rs_jrgeco1aCorr_Delta_mouse,'jrgeco1aCorr','m','Delta',saveDir,visName,false,xform_isbrain)
%     QCcheck_fcVis(refseeds,R_FADCorr_Delta_mouse, Rs_FADCorr_Delta_mouse,'FADCorr','g','Delta',saveDir,visName,false,xform_isbrain)
%     QCcheck_fcVis(refseeds,R_total_Delta_mouse, Rs_total_Delta_mouse,'total','k','Delta',saveDir,visName,false,xform_isbrain)
%     
%     
%     QCcheck_fcVis(refseeds,R_jrgeco1aCorr_inter_mouse, Rs_jrgeco1aCorr_inter_mouse,'jrgeco1aCorr','m','inter',saveDir,visName,false,xform_isbrain)
%     QCcheck_fcVis(refseeds,R_FADCorr_inter_mouse, Rs_FADCorr_inter_mouse,'FADCorr','g','inter',saveDir,visName,false,xform_isbrain)
%     QCcheck_fcVis(refseeds,R_total_inter_mouse, Rs_total_inter_mouse,'total','k','inter',saveDir,visName,false,xform_isbrain)
%     
%     close all
% end
% 
excelRows = 2:7;
numMice = length(excelRows);
xform_isbrain_mice = 1;
sessionInfo.miceType = 'jrgeco1a';
saveDir_cat = 'L:\RGECO\cat';
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
    
    
    processedName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');
    
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
    
    ll = ll+1;
end

    R_total_Delta_mice = mean(R_total_Delta_mice,4);
    R_total_ISA_mice= mean(R_total_ISA_mice,4);
    Rs_total_Delta_mice= mean(Rs_total_Delta_mice,3);
    Rs_total_ISA_mice = mean(Rs_total_ISA_mice,3);
    
    R_jrgeco1aCorr_Delta_mice = mean(R_jrgeco1aCorr_Delta_mice,4);
    R_jrgeco1aCorr_ISA_mice = mean(R_jrgeco1aCorr_ISA_mice,4);
    Rs_jrgeco1aCorr_Delta_mice = mean(Rs_jrgeco1aCorr_Delta_mice,3);
    Rs_jrgeco1aCorr_ISA_mice = mean(Rs_jrgeco1aCorr_ISA_mice,3);
    
    
    R_FADCorr_Delta_mice = mean(R_FADCorr_Delta_mice,4);
    R_FADCorr_ISA_mice = mean(R_FADCorr_ISA_mice,4);
    Rs_FADCorr_Delta_mice = mean(Rs_FADCorr_Delta_mice,3);
    Rs_FADCorr_ISA_mice = mean(Rs_FADCorr_ISA_mice,3);
processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'.mat');

load(fullfile(saveDir_cat, processedName_mice),'R_total_inter_mice','R_jrgeco1aCorr_inter_mice','R_FADCorr_inter_mice',...
    'Rs_total_inter_mice','Rs_jrgeco1aCorr_inter_mice','Rs_FADCorr_inter_mice')
save(fullfile(saveDir_cat, processedName_mice),'R_total_ISA_mice','R_jrgeco1aCorr_ISA_mice','R_FADCorr_ISA_mice',...
    'Rs_total_ISA_mice','Rs_jrgeco1aCorr_ISA_mice','Rs_FADCorr_ISA_mice','-append')
save(fullfile(saveDir_cat, processedName_mice),'R_total_ISA_mice','R_jrgeco1aCorr_ISA_mice','R_FADCorr_ISA_mice',...
    'Rs_total_ISA_mice','Rs_jrgeco1aCorr_ISA_mice','Rs_FADCorr_ISA_mice','-append')
disp(char(['QC check on ', processedName_mice]))

visName = 'Awake RGECO';
refseeds=GetReferenceSeeds;
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_inter_mice, Rs_jrgeco1aCorr_inter_mice,'jrgeco1aCorr','m','inter',saveDir_cat,visName,true,xform_isbrain_mice)
QCcheck_fcVis(refseeds,R_FADCorr_inter_mice, Rs_FADCorr_inter_mice,'FADCorr','g','inter',saveDir_cat,visName,true,xform_isbrain_mice)
QCcheck_fcVis(refseeds,R_total_inter_mice, Rs_total_inter_mice,'total','k','inter',saveDir_cat,visName,true,xform_isbrain_mice)
close all
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_ISA_mice, Rs_jrgeco1aCorr_ISA_mice,'jrgeco1aCorr','m','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
QCcheck_fcVis(refseeds,R_FADCorr_ISA_mice, Rs_FADCorr_ISA_mice,'FADCorr','g','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
QCcheck_fcVis(refseeds,R_total_ISA_mice, Rs_total_ISA_mice,'total','k','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
close all
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_mice, Rs_jrgeco1aCorr_Delta_mice,'jrgeco1aCorr','m','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
QCcheck_fcVis(refseeds,R_FADCorr_Delta_mice, Rs_FADCorr_Delta_mice,'FADCorr','g','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
QCcheck_fcVis(refseeds,R_total_Delta_mice, Rs_total_Delta_mice,'total','k','Delta',saveDir_cat,visName,true,xform_isbrain_mice)

close all




excelRows = 8:13;
numMice = length(excelRows);
xform_isbrain_mice = 1;
sessionInfo.miceType = 'jrgeco1a';
saveDir_cat = 'L:\RGECO\cat';
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
    
    
    processedName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');
    
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
    
    ll = ll+1;
end

    R_total_Delta_mice = mean(R_total_Delta_mice,4);
    R_total_ISA_mice= mean(R_total_ISA_mice,4);
    Rs_total_Delta_mice= mean(Rs_total_Delta_mice,3);
    Rs_total_ISA_mice = mean(Rs_total_ISA_mice,3);
    
    R_jrgeco1aCorr_Delta_mice = mean(R_jrgeco1aCorr_Delta_mice,4);
    R_jrgeco1aCorr_ISA_mice = mean(R_jrgeco1aCorr_ISA_mice,4);
    Rs_jrgeco1aCorr_Delta_mice = mean(Rs_jrgeco1aCorr_Delta_mice,3);
    Rs_jrgeco1aCorr_ISA_mice = mean(Rs_jrgeco1aCorr_ISA_mice,3);
    
    
    R_FADCorr_Delta_mice = mean(R_FADCorr_Delta_mice,4);
    R_FADCorr_ISA_mice = mean(R_FADCorr_ISA_mice,4);
    Rs_FADCorr_Delta_mice = mean(Rs_FADCorr_Delta_mice,3);
    Rs_FADCorr_ISA_mice = mean(Rs_FADCorr_ISA_mice,3);
processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'.mat');

load(fullfile(saveDir_cat, processedName_mice),'R_total_inter_mice','R_jrgeco1aCorr_inter_mice','R_FADCorr_inter_mice',...
    'Rs_total_inter_mice','Rs_jrgeco1aCorr_inter_mice','Rs_FADCorr_inter_mice')
save(fullfile(saveDir_cat, processedName_mice),'R_total_ISA_mice','R_jrgeco1aCorr_ISA_mice','R_FADCorr_ISA_mice',...
    'Rs_total_ISA_mice','Rs_jrgeco1aCorr_ISA_mice','Rs_FADCorr_ISA_mice','-append')
save(fullfile(saveDir_cat, processedName_mice),'R_total_ISA_mice','R_jrgeco1aCorr_ISA_mice','R_FADCorr_ISA_mice',...
    'Rs_total_ISA_mice','Rs_jrgeco1aCorr_ISA_mice','Rs_FADCorr_ISA_mice','-append')
disp(char(['QC check on ', processedName_mice]))


visName = 'Anes RGECO';
refseeds=GetReferenceSeeds;
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_inter_mice, Rs_jrgeco1aCorr_inter_mice,'jrgeco1aCorr','m','inter',saveDir_cat,visName,true,xform_isbrain_mice)
QCcheck_fcVis(refseeds,R_FADCorr_inter_mice, Rs_FADCorr_inter_mice,'FADCorr','g','inter',saveDir_cat,visName,true,xform_isbrain_mice)
QCcheck_fcVis(refseeds,R_total_inter_mice, Rs_total_inter_mice,'total','k','inter',saveDir_cat,visName,true,xform_isbrain_mice)
close all
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_ISA_mice, Rs_jrgeco1aCorr_ISA_mice,'jrgeco1aCorr','m','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
QCcheck_fcVis(refseeds,R_FADCorr_ISA_mice, Rs_FADCorr_ISA_mice,'FADCorr','g','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
QCcheck_fcVis(refseeds,R_total_ISA_mice, Rs_total_ISA_mice,'total','k','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
close all
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_mice, Rs_jrgeco1aCorr_Delta_mice,'jrgeco1aCorr','m','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
QCcheck_fcVis(refseeds,R_FADCorr_Delta_mice, Rs_FADCorr_Delta_mice,'FADCorr','g','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
QCcheck_fcVis(refseeds,R_total_Delta_mice, Rs_total_Delta_mice,'total','k','Delta',saveDir_cat,visName,true,xform_isbrain_mice)

close all