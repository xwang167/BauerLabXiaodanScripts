close all;clearvars -except hz;clc
import mice.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [181 183 185  228 232 236];
runs = 1:3;
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
%     %maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
%     
%     
%     sessionInfo.framerate = excelRaw{7};
%     systemInfo.numLEDs = 4;
%     maskName_new = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
%     %maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
%     %load(fullfile(maskDir,maskName), 'xform_isbrain')
%     %save(fullfile(maskDir_new,maskName_new),'xform_isbrain')
%     load(fullfile(maskDir_new,maskName_new), 'xform_isbrain')
%     xform_isbrain = double(xform_isbrain);
%     if ~isempty(find(isnan(xform_isbrain), 1))
%         xform_isbrain(isnan(xform_isbrain))=0;
%     end
%     for n = runs
%         visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
%         
%         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
%         
%         
%         
%         if strcmp(sessionType,'fc')
% 
%                 disp('loading processed data')
%                 load(fullfile(saveDir,processedName),'xform_datahb')
%                 for ii = 1:size(xform_datahb,4)
%                     xform_isbrain(isinf(xform_datahb(:,:,1,ii))) = 0;
%                     xform_isbrain(isnan(xform_datahb(:,:,1,ii))) = 0;
%                     
%                 end
%                 disp(strcat('fc QC check on ', processedName))
%                 
%                 if strcmp(sessionInfo.mouseType,'gcamp6f')
%                     
%                     load(fullfile(saveDir,processedName),'xform_gcampCorr')
%                     
%                     QCcheck_fc_twoFluor(double(squeeze(xform_datahb(:,:,1,:))),double(squeeze(xform_gcampCorr)),'oxy','gcampCorr','r-','g-',xform_isbrain, sessionInfo.framerate,saveDir,strcat(visName,'_processed'),false,'(\DeltaM)','(\DeltaF/F)');
%                     close all
%                     clear xform_gcampCorr xform_datahb
%                     
%                 elseif strcmp(sessionInfo.mouseType,'jrgeco1a')
%                     load(fullfile(saveDir, processedName),'xform_FADCorr','xform_jrgeco1aCorr')
%                     sessionInfo.bandtype_ISA = {"ISA",0.009,0.08};
%                     sessionInfo.bandtype_Delta = {"Delta",0.4,4};
%                     total = squeeze(xform_datahb(:,:,1,:)) + squeeze(xform_datahb(:,:,2,:));
%                     
%                     
%                     clear xform_datahb
%                     
%                     disp('calculate power map')
%                     jrgeco1aCorr_ISA_powerMap_GSR = QCcheck_CalcPowerMap_GSR(double(xform_jrgeco1aCorr)/0.01,sessionInfo.framerate,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}]);
%                     FADCorr_ISA_powerMap_GSR = QCcheck_CalcPowerMap_GSR(double(xform_FADCorr)/0.01,sessionInfo.framerate,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}]);
%                     total_ISA_powerMap_GSR = QCcheck_CalcPowerMap_GSR(double(total)*10^6,sessionInfo.framerate,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}]);
%                     
%                     jrgeco1aCorr_Delta_powerMap_GSR = QCcheck_CalcPowerMap_GSR(double(xform_jrgeco1aCorr)/0.01,sessionInfo.framerate,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}]);
%                     FADCorr_Delta_powerMap_GSR = QCcheck_CalcPowerMap_GSR(double(xform_FADCorr)/0.01,sessionInfo.framerate,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}]);
%                     total_Delta_powerMap_GSR = QCcheck_CalcPowerMap_GSR(double(total)*10^6,sessionInfo.framerate,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}]);
%                     
%                     clear xform_FADCorr xform_jrgeco1aCorr xform_jrgeco1a total
%                     
%                     save(fullfile(saveDir, processedName),'jrgeco1aCorr_ISA_powerMap_GSR','FADCorr_ISA_powerMap_GSR','total_ISA_powerMap_GSR','jrgeco1aCorr_Delta_powerMap_GSR','FADCorr_Delta_powerMap_GSR','total_Delta_powerMap_GSR',...
%                         '-append','-v7.3')
%                     
%                     
%                     QCcheck_powerMapVis(jrgeco1aCorr_ISA_powerMap_GSR,xform_isbrain,'(\DeltaF/F%)',saveDir,strcat(visName, '_RGECOISA_GSR'))
%                     QCcheck_powerMapVis(FADCorr_ISA_powerMap_GSR,xform_isbrain,'(\DeltaF/F%)',saveDir,strcat(visName, '_FADISA_GSR'))
%                     QCcheck_powerMapVis(total_ISA_powerMap_GSR,xform_isbrain,'\muM',saveDir,strcat(visName, "_TotalISA_GSR"))
%                     
%                     QCcheck_powerMapVis(jrgeco1aCorr_Delta_powerMap_GSR,xform_isbrain,'(\DeltaF/F%)',saveDir,strcat(visName, "_RGECODelta_GSR"))
%                     QCcheck_powerMapVis(FADCorr_Delta_powerMap_GSR,xform_isbrain,'(\DeltaF/F%)',saveDir,strcat(visName,"_FADDelta_GSR"))
%                     QCcheck_powerMapVis(total_Delta_powerMap_GSR,xform_isbrain,'\muM',saveDir,strcat(visName,"_TotalDelta_GSR"))
%                     
%                     
%                     
%                     
%                
%             end
%             close all
%             
%             
%         end
%         
%     end
% end
% 
% 
% runs = 1:3;
% length_runs = length(runs);
% 
% for ii = 1
%     isDetrend = logical(ii);
%     for excelRow = excelRows
%         [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
%         recDate = excelRaw{1}; recDate = string(recDate);
%         mouseName = excelRaw{2}; mouseName = string(mouseName);
%         saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%         sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%         
%         
%         
%         sessionInfo.darkFrameNum = excelRaw{15};
%         rawdataloc = excelRaw{3};
%         info.nVx = 128;
%         info.nVy = 128;
%         sessionInfo.mouseType = excelRaw{17};
%         systemType =excelRaw{5};
%         sessionInfo.framerate = excelRaw{7};
%         goodRuns = str2num(excelRaw{18});
%         
%         if strcmp(char(sessionInfo.mouseType),'WT')
%             systemInfo.numLEDs = 2;
%         elseif strcmp(char(sessionInfo.mouseType),'gcamp6f')
%             systemInfo.numLEDs = 3;
%         end
%         maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
%         load(fullfile(saveDir,maskName), 'xform_isbrain')
%         %         maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
%         %         load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataHb','.mat')),'xform_isbrain');
%         
%         xform_isbrain(xform_isbrain ==2)=1;
%         xform_isbrain = double(xform_isbrain);
%         if ~isempty(find(isnan(xform_isbrain), 1))
%             xform_isbrain(isnan(xform_isbrain))=0;
%         end
%         
%         processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
%         visName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed');
%         
%         
%         
%         total_Delta_powerMap_GSR_mouse = zeros(info.nVy,info.nVx,length_runs);
%         total_ISA_powerMap_GSR_mouse = zeros(info.nVy,info.nVx,length_runs);
%         
%         
%         
%         if strcmp(char(sessionInfo.mouseType),'jrgeco1a')
%             
%             jrgeco1aCorr_Delta_powerMap_GSR_mouse = zeros(info.nVy,info.nVx,length_runs);
%             jrgeco1aCorr_ISA_powerMap_GSR_mouse = zeros(info.nVy,info.nVx,length_runs);
%             
%             FADCorr_Delta_powerMap_GSR_mouse = zeros(info.nVy,info.nVx,length_runs);
%             FADCorr_ISA_powerMap_GSR_mouse = zeros(info.nVy,info.nVx,length_runs);
%             
%             
%         end
%         for n = runs
%             
%             
%             disp('loading processed data')
%             
%             %             if isDetrend
%             processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
%             %             else
%             %                 processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_NoDetrend','.mat');
%             %             end
%             if strcmp(sessionType,'fc')
%                 if strcmp(char(sessionInfo.mouseType),'jrgeco1a')
%                     load(fullfile(saveDir, processedName),'total_Delta_powerMap_GSR','total_ISA_powerMap_GSR','jrgeco1aCorr_Delta_powerMap_GSR','jrgeco1aCorr_ISA_powerMap_GSR', 'FADCorr_Delta_powerMap_GSR','FADCorr_ISA_powerMap_GSR')
%                     
%                     
%                     
%                     total_Delta_powerMap_GSR_mouse(:,:,n) = total_Delta_powerMap_GSR;
%                     total_ISA_powerMap_GSR_mouse(:,:,n) = total_ISA_powerMap_GSR;
%                     
%                     
%                     jrgeco1aCorr_Delta_powerMap_GSR_mouse(:,:,n) = jrgeco1aCorr_Delta_powerMap_GSR;
%                     jrgeco1aCorr_ISA_powerMap_GSR_mouse(:,:,n) = jrgeco1aCorr_ISA_powerMap_GSR;
%                     FADCorr_Delta_powerMap_GSR_mouse(:,:,n) = FADCorr_Delta_powerMap_GSR;
%                     FADCorr_ISA_powerMap_GSR_mouse(:,:,n) = FADCorr_ISA_powerMap_GSR;
%                 end
%             end
%         end
%         
%         
%         total_Delta_powerMap_GSR_mouse = mean(total_Delta_powerMap_GSR_mouse,3);
%         total_ISA_powerMap_GSR_mouse = mean(total_ISA_powerMap_GSR_mouse,3);
%         
%         
%         disp(char(['QC check on ', processedName_mouse]))
%         if strcmp(char(sessionInfo.mouseType),'jrgeco1a')
%             
%             
%             jrgeco1aCorr_Delta_powerMap_GSR_mouse = mean(jrgeco1aCorr_Delta_powerMap_GSR_mouse,3);
%             jrgeco1aCorr_ISA_powerMap_GSR_mouse = mean(jrgeco1aCorr_ISA_powerMap_GSR_mouse,3);
%             
%             
%             
%             FADCorr_Delta_powerMap_GSR_mouse = mean(FADCorr_Delta_powerMap_GSR_mouse,3);
%             FADCorr_ISA_powerMap_GSR_mouse = mean(FADCorr_ISA_powerMap_GSR_mouse,3);
%             
%             save(fullfile(saveDir, processedName_mouse),'total_ISA_powerMap_GSR_mouse','jrgeco1aCorr_ISA_powerMap_GSR_mouse','FADCorr_ISA_powerMap_GSR_mouse',...
%                 'total_Delta_powerMap_GSR_mouse','jrgeco1aCorr_Delta_powerMap_GSR_mouse','FADCorr_Delta_powerMap_GSR_mouse','-append')
%             visName = strcat(recDate,'-',mouseName,'-',sessionType);
%             
%             
%          
%             
%             
%             QCcheck_powerMapVis(jrgeco1aCorr_ISA_powerMap_GSR_mouse,xform_isbrain,'(\DeltaF/F%)',saveDir,strcat(visName, '_RGECOISA_GSR'))
%             QCcheck_powerMapVis(FADCorr_ISA_powerMap_GSR_mouse,xform_isbrain,'(\DeltaF/F%)',saveDir,strcat(visName, '_FADISA_GSR'))
%             QCcheck_powerMapVis(total_ISA_powerMap_GSR_mouse,xform_isbrain,'\muM',saveDir,strcat(visName, "_TotalISA_GSR"))
%             
%             QCcheck_powerMapVis(jrgeco1aCorr_Delta_powerMap_GSR_mouse,xform_isbrain,'(\DeltaF/F%)',saveDir,strcat(visName, "_RGECODelta_GSR"))
%             QCcheck_powerMapVis(FADCorr_Delta_powerMap_GSR_mouse,xform_isbrain,'(\DeltaF/F%)',saveDir,strcat(visName,"_FADDelta_GSR"))
%             QCcheck_powerMapVis(total_Delta_powerMap_GSR_mouse,xform_isbrain,'\muM',saveDir,strcat(visName,"_TotalDelta_GSR"))
%             
%         end
%         close all
%     end
% end
% 
% 
% 











info.nVx = 128;
info.nVy = 128;
numMice = length(excelRows);
xform_isbrain_mice = 1;
sessionInfo.miceType = 'jrgeco1a';
saveDir_cat = 'D:\RGECO\cat';

total_Delta_powerMap_GSR_mice = zeros(info.nVy,info.nVx,numMice);
total_ISA_powerMap_mice = zeros(info.nVy,info.nVx,numMice);


if strcmp(char(sessionInfo.miceType),'jrgeco1a')

    jrgeco1aCorr_Delta_powerMap_GSR_mice = zeros(info.nVy,info.nVx,numMice);
    jrgeco1aCorr_ISA_powerMap_GSR_mice = zeros(info.nVy,info.nVx,numMice);

    FADCorr_Delta_powerMap_GSR_mice = zeros(info.nVy,info.nVx,numMice);
    FADCorr_ISA_powerMap_GSR_mice = zeros(info.nVy,info.nVx,numMice);

end



miceName = [];

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
    %maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
    
    maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
    load(fullfile(saveDir,maskName), 'xform_isbrain')
    
    %load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataHb','.mat')),'xform_isbrain');
    xform_isbrain(xform_isbrain ==2)=1;
    xform_isbrain = double(xform_isbrain);
    
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    xform_isbrain(isinf(xform_isbrain)) = 0;
    xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
    
    
    processedName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');
    
    if strcmp(sessionType,'fc')
        if strcmp(char(sessionInfo.miceType),'jrgeco1a')
            
            
            
            load(fullfile(saveDir, processedName),'total_Delta_powerMap_GSR_mouse','total_ISA_powerMap_GSR_mouse','jrgeco1aCorr_Delta_powerMap_GSR_mouse','jrgeco1aCorr_ISA_powerMap_GSR_mouse', 'FADCorr_Delta_powerMap_GSR_mouse','FADCorr_ISA_powerMap_GSR_mouse')
            
            total_Delta_powerMap_GSR_mice(:,:,ll) = total_Delta_powerMap_GSR_mouse;
            total_ISA_powerMap_GSR_mice(:,:,ll) = total_ISA_powerMap_GSR_mouse;
            

            
            

            jrgeco1aCorr_Delta_powerMap_GSR_mice(:,:,ll) = jrgeco1aCorr_Delta_powerMap_GSR_mouse;
            jrgeco1aCorr_ISA_powerMap_GSR_mice(:,:,ll) = jrgeco1aCorr_ISA_powerMap_GSR_mouse;

            

            FADCorr_Delta_powerMap_GSR_mice(:,:,ll) = FADCorr_Delta_powerMap_GSR_mouse;
            FADCorr_ISA_powerMap_GSR_mice(:,:,ll) = FADCorr_ISA_powerMap_GSR_mouse;

            
        end
        ll = ll+1;
    end
end

total_Delta_powerMap_GSR_mice = mean(total_Delta_powerMap_GSR_mice,3);
total_ISA_powerMap_GSR_mice = mean(total_ISA_powerMap_GSR_mice,3);


jrgeco1aCorr_Delta_powerMap_GSR_mice = mean(jrgeco1aCorr_Delta_powerMap_GSR_mice,3);
jrgeco1aCorr_ISA_powerMap_GSR_mice = mean(jrgeco1aCorr_ISA_powerMap_GSR_mice,3);


FADCorr_Delta_powerMap_GSR_mice = mean(FADCorr_Delta_powerMap_GSR_mice,3);
FADCorr_ISA_powerMap_GSR_mice = mean(FADCorr_ISA_powerMap_GSR_mice,3);

processedName_mice = '191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc.mat';
miceName = 'R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake';

% processedName_mice = '191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc.mat';
% miceName = 'R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes';
% 



save(fullfile(saveDir_cat, processedName_mice), 'total_ISA_powerMap_GSR_mice','jrgeco1aCorr_ISA_powerMap_GSR_mice','FADCorr_ISA_powerMap_GSR_mice',...
    'total_Delta_powerMap_GSR_mice','jrgeco1aCorr_Delta_powerMap_GSR_mice','FADCorr_Delta_powerMap_GSR_mice',...
    '-append')

disp(char(['QC check on ', processedName_mice]))
if strcmp(char(sessionInfo.miceType),'jrgeco1a')
    visName = miceName;

    
    xform_isbrain_mice =ones(128,128);
  
    QCcheck_powerMapVis(jrgeco1aCorr_ISA_powerMap_GSR_mice,xform_isbrain_mice,'(\DeltaF/F%)',saveDir_cat,strcat(visName, '_RGECOISA_GSR'))
    QCcheck_powerMapVis(FADCorr_ISA_powerMap_GSR_mice,xform_isbrain_mice,'(\DeltaF/F%)',saveDir_cat,strcat(visName, '_FADISA_GSR'))
    QCcheck_powerMapVis(total_ISA_powerMap_GSR_mice,xform_isbrain_mice,'\muM',saveDir_cat,strcat(visName, "_TotalISA_GSR"))
    
    QCcheck_powerMapVis(jrgeco1aCorr_Delta_powerMap_GSR_mice,xform_isbrain_mice,'(\DeltaF/F%)',saveDir_cat,strcat(visName, "_RGECODelta_GSR"))
    QCcheck_powerMapVis(FADCorr_Delta_powerMap_GSR_mice,xform_isbrain_mice,'(\DeltaF/F%)',saveDir_cat,strcat(visName,"_FADDelta_GSR"))
    QCcheck_powerMapVis(total_Delta_powerMap_GSR_mice,xform_isbrain_mice,'\muM',saveDir_cat,strcat(visName,"_TotalDelta_GSR"))
end
close all

