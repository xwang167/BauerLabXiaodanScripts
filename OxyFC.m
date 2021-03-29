% create FC Oxy
%excelRows = [181 183 185  228 232 236 195 202 204 230 234 240];
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
xform_isbrain_mice = 1;
runs = 1:3;
refseeds=GetReferenceSeeds_xw;
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
%
%     sessionInfo.framerate = excelRaw{7};
%     systemInfo.numLEDs = 4;
%     %maskName_new = strcat(recDate,'-N8M864-opto3-LandmarksAndMask','.mat');
%     maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-dataFluor','.mat');
%     maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
%     %load(fullfile(maskDir,maskName), 'xform_isbrain')
%     %save(fullfile(maskDir_new,maskName_new),'xform_isbrain')
%     %maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
%     if exist(fullfile(maskDir,maskName),'file')
%         load(fullfile(maskDir,maskName), 'xform_isbrain')
%     else
%         maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
%         load(fullfile(saveDir,maskName), 'xform_isbrain')
%     end
%
%     xform_isbrain = double(xform_isbrain);
%     if ~isempty(find(isnan(xform_isbrain), 1))
%         xform_isbrain(isnan(xform_isbrain))=0;
%     end
%     xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
%     for n = runs
%
%         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
%
%         load(fullfile(saveDir,processedName),'xform_datahb')
%         sessionInfo.bandtype_ISA = {"ISA",0.009,0.08};
%         sessionInfo.bandtype_Delta = {"Delta",0.4,4};
%         oxy = squeeze(xform_datahb(:,:,1,:));
%         clear xform_dathb
%         [R_oxy_ISA,Rs_oxy_ISA] = QCcheck_CalcRRs(refseeds,double(oxy)*10^6,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}],true);
%         [R_oxy_Delta,Rs_oxy_Delta] = QCcheck_CalcRRs(refseeds,double(oxy)*10^6,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],true);
%
%         visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
%         QCcheck_fcVis(refseeds,R_oxy_ISA, Rs_oxy_ISA,'oxy','r','ISA',saveDir,visName,false,xform_isbrain)
%         QCcheck_fcVis(refseeds,R_oxy_Delta, Rs_oxy_Delta,'oxy','r','Delta',saveDir,visName,false,xform_isbrain)
%
%         save(fullfile(saveDir, processedName),'R_oxy_ISA','Rs_oxy_ISA',...
%             'R_oxy_Delta','Rs_oxy_Delta','xform_isbrain','-append')
%         close all
%     end
%
% end
% close all;clearvars -except hz;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";


nVx = 128;
nVy = 128;
%
runs = 1:3;
length_runs = length(runs);

% 
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     
%     
%     
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
%     maskName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-datafluor','.mat');
%     if ~exist(fullfile(maskDir,maskName))
%         maskDir = saveDir;
%         maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
%         
%     end
%     load(fullfile(maskDir,maskName), 'xform_isbrain')
%     xform_isbrain = double(xform_isbrain);
%     if ~isempty(find(isnan(xform_isbrain), 1))
%         xform_isbrain(isnan(xform_isbrain))=0;
%     end
%     
%     
%     processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
%     visName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed');
%     
%     
%     R_oxy_Delta_mouse  = zeros(info.nVy,info.nVx,16,length_runs);
%     R_oxy_ISA_mouse  = zeros(info.nVy,info.nVx,16,length_runs);
%     Rs_oxy_Delta_mouse = zeros(16,16,length_runs);
%     Rs_oxy_ISA_mouse = zeros(16,16,length_runs);
%     
%    
%     for n = runs
%         
%         
%         disp('loading processed data')
%         
%         %             if isDetrend
%         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
%         %             else
%         %                 processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_NoDetrend','.mat');
%         %             end
%         load(fullfile(saveDir, processedName),'R_oxy_Delta','R_oxy_ISA','Rs_oxy_Delta','Rs_oxy_ISA')
%         
%         
%         R_oxy_Delta_mouse(:,:,:,n) = R_oxy_Delta;
%         R_oxy_ISA_mouse(:,:,:,n) = R_oxy_ISA;
%         
%         Rs_oxy_Delta_mouse(:,:,n) = Rs_oxy_Delta;
%         Rs_oxy_ISA_mouse(:,:,n) = Rs_oxy_ISA;
%     end
%     
%     R_oxy_Delta_mouse  = mean(R_oxy_Delta_mouse,4);
%     R_oxy_ISA_mouse  = mean(R_oxy_ISA_mouse,4);
%     Rs_oxy_Delta_mouse = mean(Rs_oxy_Delta_mouse,3);
%     Rs_oxy_ISA_mouse = mean(Rs_oxy_ISA_mouse,3);
%     
%     save(fullfile(saveDir, processedName_mouse),'R_oxy_ISA_mouse',...
%         'R_oxy_Delta_mouse','Rs_oxy_ISA_mouse','Rs_oxy_Delta_mouse','-append')
%     
%     visName = strcat(recDate,'-',mouseName,'-',sessionType);
%     
%     refseeds=GetReferenceSeeds_xw;
%     
%     QCcheck_fcVis(refseeds,R_oxy_ISA_mouse, Rs_oxy_ISA_mouse,'oxy','r','ISA',saveDir,visName,false,xform_isbrain)
%     
%     QCcheck_fcVis(refseeds,R_oxy_Delta_mouse, Rs_oxy_Delta_mouse,'oxy','r','Delta',saveDir,visName,false,xform_isbrain)
%     close all
%     
% end

%import mice.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
isZTransform = true;
set(0,'defaultaxesfontsize',12);

info.nVx = 128;
info.nVy = 128;
%
excelRows =  [ 181 183 185  228 232 236 ];%[181 183 185  228 232 236];[195 202 204 230 234 240] ;%
numMice = length(excelRows);
xform_isbrain_mice = 1;
sessionInfo.miceType = 'jrgeco1a';
saveDir_cat = 'L:\RGECO\cat';

R_oxy_Delta_mice  = zeros(info.nVy,info.nVx,16,numMice);
R_oxy_ISA_mice  = zeros(info.nVy,info.nVx,16,numMice);
Rs_oxy_Delta_mice = zeros(16,16,numMice);
Rs_oxy_ISA_mice = zeros(16,16,numMice);
miceName = [];
ll = 1;
xform_datahb_mice = 1;
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
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    maskName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-datafluor','.mat');
    if ~exist(fullfile(maskDir,maskName))
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');       
    end
    load(fullfile(maskDir,maskName), 'xform_isbrain')
    xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
    
    xform_isbrain = double(xform_isbrain);
    
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    xform_isbrain(isinf(xform_isbrain)) = 0;
    xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
    
    
    processedName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');
    
    if strcmp(sessionType,'fc')
        if strcmp(char(sessionInfo.miceType),'jrgeco1a')
            
            
            
            load(fullfile(saveDir, processedName),'R_oxy_Delta_mouse','R_oxy_ISA_mouse',...
                'Rs_oxy_Delta_mouse','Rs_oxy_ISA_mouse')
              
            
            R_oxy_Delta_mice(:,:,:,ll) = atanh(R_oxy_Delta_mouse);
            R_oxy_ISA_mice(:,:,:,ll) = atanh(R_oxy_ISA_mouse);
            Rs_oxy_Delta_mice(:,:,ll) = atanh(Rs_oxy_Delta_mouse);
            Rs_oxy_ISA_mice(:,:,ll) = atanh(Rs_oxy_ISA_mouse);
                    

            
        end
        ll = ll+1;
    end
end
R_oxy_Delta_mice  = mean(R_oxy_Delta_mice,4);
R_oxy_ISA_mice  = mean(R_oxy_ISA_mice,4);
Rs_oxy_Delta_mice = mean(Rs_oxy_Delta_mice,3);
Rs_oxy_ISA_mice = mean(Rs_oxy_ISA_mice,3);



processedName_mice = '191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-stim_processed_mice.mat'; %191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc.mat';
miceName = '191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-stim_processed_mice'%'R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes';
% 
% processedName_mice = '191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc.mat';
% miceName = 'R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake';
% load(fullfile(saveDir_cat, processedName_mice),'R_oxy_ISA_mice','R_jrgeco1aCorr_ISA_mice','R_FADCorr_ISA_mice',...
%     'R_oxy_Delta_mice','R_jrgeco1aCorr_Delta_mice','R_FADCorr_Delta_mice',...
%     'Rs_oxy_ISA_mice','Rs_jrgeco1aCorr_ISA_mice','Rs_FADCorr_ISA_mice',...
%     'Rs_oxy_Delta_mice','Rs_jrgeco1aCorr_Delta_mice','Rs_FADCorr_Delta_mice',...
%     'powerdata_average_oxy_mice','powerdata_average_deoxy_mice','powerdata_average_oxy_mice','powerdata_average_jrgeco1aCorr_mice','powerdata_average_FADCorr_mice',...
%     'powerdata_oxy_mice','powerdata_deoxy_mice','powerdata_oxy_mice','powerdata_jrgeco1aCorr_mice','powerdata_FADCorr_mice',...
%     'oxy_ISA_powerMap_mice','jrgeco1aCorr_ISA_powerMap_mice','FADCorr_ISA_powerMap_mice',...
%     'oxy_Delta_powerMap_mice','jrgeco1aCorr_Delta_powerMap_mice','FADCorr_Delta_powerMap_mice',...
%     'hz')

save(fullfile(saveDir_cat, processedName_mice),'R_oxy_ISA_mice','R_oxy_Delta_mice',...
    'Rs_oxy_ISA_mice','Rs_oxy_Delta_mice','xform_datahb_mice','-append')



disp(char(['QC check on ', processedName_mice]))
    visName = miceName;
    refseeds=GetReferenceSeeds_xw;
    xform_isbrain_mice(isnan(R_oxy_Delta_mice(:,:,1))) = 0;     
    QCcheck_fcVis(refseeds,R_oxy_ISA_mice, Rs_oxy_ISA_mice,'oxy','r','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
    
    QCcheck_fcVis(refseeds,R_oxy_Delta_mice, Rs_oxy_Delta_mice,'oxy','r','Delta',saveDir_cat,visName,true,xform_isbrain_mice)






