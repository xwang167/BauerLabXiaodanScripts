close all;clearvars -except hz;clc
import mice.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
isZTransform = true;
set(0,'defaultaxesfontsize',12);

info.nVx = 128;
info.nVy = 128;
%
excelRows =  [195 202 204 230 234 240] ;%[ 181 183 185  228 232 236 ];[181 183 185  228 232 236];%
numMice = length(excelRows);
xform_isbrain_mice = 1;
sessionInfo.miceType = 'jrgeco1a';
saveDir_cat = 'L:\RGECO\cat';

R_total_Delta_mice  = zeros(info.nVy,info.nVx,16,numMice);
R_total_ISA_mice  = zeros(info.nVy,info.nVx,16,numMice);
Rs_total_Delta_mice = zeros(16,16,numMice);
Rs_total_ISA_mice = zeros(16,16,numMice);

 powerdata_average_oxy_mice = [];
            powerdata_oxy_mice = [];
            
            
            powerdata_average_deoxy_mice = [];
            powerdata_deoxy_mice = [];
            
            powerdata_average_total_mice = [];
            powerdata_total_mice = [];
            
                        powerdata_average_jrgeco1aCorr_mice =[];
            powerdata_jrgeco1aCorr_mice = [];
                        powerdata_average_FADCorr_mice = [];
            powerdata_FADCorr_mice = [];
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
    
    
    processedName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');
    
    if strcmp(sessionType,'fc')
        if strcmp(char(sessionInfo.miceType),'jrgeco1a')
            
            
            
            load(fullfile(saveDir, processedName),'R_total_Delta_mouse','R_total_ISA_mouse','R_jrgeco1aCorr_Delta_mouse','R_jrgeco1aCorr_ISA_mouse','R_FADCorr_Delta_mouse','R_FADCorr_ISA_mouse',...
                'Rs_total_Delta_mouse','Rs_total_ISA_mouse','Rs_jrgeco1aCorr_Delta_mouse','Rs_jrgeco1aCorr_ISA_mouse', 'Rs_FADCorr_Delta_mouse','Rs_FADCorr_ISA_mouse',...
                'powerdata_average_oxy_mouse','powerdata_average_deoxy_mouse','powerdata_average_total_mouse','powerdata_average_jrgeco1aCorr_mouse','powerdata_average_FADCorr_mouse',...
                'powerdata_oxy_mouse','powerdata_deoxy_mouse','powerdata_jrgeco1aCorr_mouse','powerdata_total_mouse','powerdata_FADCorr_mouse',...
                'total_Delta_powerMap_mouse','total_ISA_powerMap_mouse','jrgeco1aCorr_Delta_powerMap_mouse','jrgeco1aCorr_ISA_powerMap_mouse', 'FADCorr_Delta_powerMap_mouse','FADCorr_ISA_powerMap_mouse',...
                'hz','hz2')
            
            R_total_Delta_mice(:,:,:,ll) = atanh(R_total_Delta_mouse);
            R_total_ISA_mice(:,:,:,ll) = atanh(R_total_ISA_mouse);
            Rs_total_Delta_mice(:,:,ll) = atanh(Rs_total_Delta_mouse);
            Rs_total_ISA_mice(:,:,ll) = atanh(Rs_total_ISA_mouse);
            total_Delta_powerMap_mice(:,:,ll) = total_Delta_powerMap_mouse;
            total_ISA_powerMap_mice(:,:,ll) = total_ISA_powerMap_mouse;
%             
            if goodRuns ~=0
                
               
               miceName_powerdata =  char(strcat(miceName_powerdata, '-', mouseName));
            powerdata_average_oxy_mice = cat(1,powerdata_average_oxy_mice,squeeze(powerdata_average_oxy_mouse));
            powerdata_oxy_mice = cat(1,powerdata_oxy_mice,squeeze(powerdata_oxy_mouse));
            
            
            powerdata_average_deoxy_mice = cat(1,powerdata_average_deoxy_mice,squeeze(powerdata_average_deoxy_mouse));
            powerdata_deoxy_mice = cat(1,powerdata_deoxy_mice,squeeze(powerdata_deoxy_mouse));
            
            powerdata_average_total_mice = cat(1,powerdata_average_total_mice,squeeze(powerdata_average_total_mouse));
            powerdata_total_mice = cat(1,powerdata_total_mice,squeeze(powerdata_total_mouse));
            
                        powerdata_average_jrgeco1aCorr_mice = cat(1,powerdata_average_jrgeco1aCorr_mice,squeeze(powerdata_average_jrgeco1aCorr_mouse));
            powerdata_jrgeco1aCorr_mice = cat(1,powerdata_jrgeco1aCorr_mice,squeeze(powerdata_jrgeco1aCorr_mouse));
                        powerdata_average_FADCorr_mice = cat(1,powerdata_average_FADCorr_mice,squeeze(powerdata_average_FADCorr_mouse));
            powerdata_FADCorr_mice = cat(1,powerdata_FADCorr_mice,squeeze(powerdata_FADCorr_mouse));
%             
             end
            
            
            R_jrgeco1aCorr_Delta_mice(:,:,:,ll) = atanh(R_jrgeco1aCorr_Delta_mouse);
            R_jrgeco1aCorr_ISA_mice(:,:,:,ll) = atanh(R_jrgeco1aCorr_ISA_mouse);
            Rs_jrgeco1aCorr_Delta_mice(:,:,ll) = atanh(Rs_jrgeco1aCorr_Delta_mouse);
            Rs_jrgeco1aCorr_ISA_mice(:,:,ll) = atanh(Rs_jrgeco1aCorr_ISA_mouse);
            jrgeco1aCorr_Delta_powerMap_mice(:,:,ll) = jrgeco1aCorr_Delta_powerMap_mouse;
            jrgeco1aCorr_ISA_powerMap_mice(:,:,ll) = jrgeco1aCorr_ISA_powerMap_mouse;

            
            R_FADCorr_Delta_mice(:,:,:,ll) = atanh(R_FADCorr_Delta_mouse);
            R_FADCorr_ISA_mice(:,:,:,ll) = atanh(R_FADCorr_ISA_mouse);
            Rs_FADCorr_Delta_mice(:,:,ll) = atanh(Rs_FADCorr_Delta_mouse);
            Rs_FADCorr_ISA_mice(:,:,ll) = atanh(Rs_FADCorr_ISA_mouse);
            FADCorr_Delta_powerMap_mice(:,:,ll) = FADCorr_Delta_powerMap_mouse;
            FADCorr_ISA_powerMap_mice(:,:,ll) = FADCorr_ISA_powerMap_mouse;

            
        end
        ll = ll+1;
    end
end
processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'.mat');
R_total_Delta_mice  = mean(R_total_Delta_mice,4);
R_total_ISA_mice  = mean(R_total_ISA_mice,4);
Rs_total_Delta_mice = mean(Rs_total_Delta_mice,3);
Rs_total_ISA_mice = mean(Rs_total_ISA_mice,3);



if goodRuns ~=0
powerdata_average_oxy_mice = mean(powerdata_average_oxy_mice,1);
powerdata_oxy_mice = mean(powerdata_oxy_mice,1);


powerdata_average_deoxy_mice = mean(powerdata_average_deoxy_mice,1);
powerdata_deoxy_mice = mean(powerdata_deoxy_mice,1);

powerdata_average_total_mice = mean(powerdata_average_total_mice,1);
powerdata_total_mice = mean(powerdata_total_mice,1);

total_Delta_powerMap_mice = mean(total_Delta_powerMap_mice,3);
total_ISA_powerMap_mice = mean(total_ISA_powerMap_mice,3);
powerdata_average_jrgeco1aCorr_mice = mean(powerdata_average_jrgeco1aCorr_mice,1);
powerdata_jrgeco1aCorr_mice = mean(powerdata_jrgeco1aCorr_mice,1);

powerdata_average_FADCorr_mice = mean(powerdata_average_FADCorr_mice,1);
powerdata_FADCorr_mice = mean(powerdata_FADCorr_mice,1);
end




R_jrgeco1aCorr_Delta_mice = mean(R_jrgeco1aCorr_Delta_mice,4);
R_jrgeco1aCorr_ISA_mice  = mean(R_jrgeco1aCorr_ISA_mice,4);
Rs_jrgeco1aCorr_Delta_mice = mean(Rs_jrgeco1aCorr_Delta_mice,3);
Rs_jrgeco1aCorr_ISA_mice = mean(Rs_jrgeco1aCorr_ISA_mice,3);

jrgeco1aCorr_Delta_powerMap_mice = mean(jrgeco1aCorr_Delta_powerMap_mice,3);
jrgeco1aCorr_ISA_powerMap_mice = mean(jrgeco1aCorr_ISA_powerMap_mice,3);

R_FADCorr_Delta_mice = mean(R_FADCorr_Delta_mice,4);
R_FADCorr_ISA_mice  = mean(R_FADCorr_ISA_mice,4);
Rs_FADCorr_Delta_mice = mean(Rs_FADCorr_Delta_mice,3);
Rs_FADCorr_ISA_mice = mean(Rs_FADCorr_ISA_mice,3);

FADCorr_Delta_powerMap_mice = mean(FADCorr_Delta_powerMap_mice,3);
FADCorr_ISA_powerMap_mice = mean(FADCorr_ISA_powerMap_mice,3);



processedName_mice = '191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc.mat';
miceName = 'R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes';
% 
% processedName_mice = '191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc.mat';
% miceName = 'R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake';
load(fullfile(saveDir_cat, processedName_mice),'R_total_ISA_mice','R_jrgeco1aCorr_ISA_mice','R_FADCorr_ISA_mice',...
    'R_total_Delta_mice','R_jrgeco1aCorr_Delta_mice','R_FADCorr_Delta_mice',...
    'Rs_total_ISA_mice','Rs_jrgeco1aCorr_ISA_mice','Rs_FADCorr_ISA_mice',...
    'Rs_total_Delta_mice','Rs_jrgeco1aCorr_Delta_mice','Rs_FADCorr_Delta_mice',...
    'powerdata_average_oxy_mice','powerdata_average_deoxy_mice','powerdata_average_total_mice','powerdata_average_jrgeco1aCorr_mice','powerdata_average_FADCorr_mice',...
    'powerdata_oxy_mice','powerdata_deoxy_mice','powerdata_total_mice','powerdata_jrgeco1aCorr_mice','powerdata_FADCorr_mice',...
    'total_ISA_powerMap_mice','jrgeco1aCorr_ISA_powerMap_mice','FADCorr_ISA_powerMap_mice',...
    'total_Delta_powerMap_mice','jrgeco1aCorr_Delta_powerMap_mice','FADCorr_Delta_powerMap_mice',...
    'hz')

% save(fullfile(saveDir_cat, processedName_mice),'R_total_ISA_mice','R_jrgeco1aCorr_ISA_mice','R_FADCorr_ISA_mice',...
%     'R_total_Delta_mice','R_jrgeco1aCorr_Delta_mice','R_FADCorr_Delta_mice',...
%     'Rs_total_ISA_mice','Rs_jrgeco1aCorr_ISA_mice','Rs_FADCorr_ISA_mice',...
%     'Rs_total_Delta_mice','Rs_jrgeco1aCorr_Delta_mice','Rs_FADCorr_Delta_mice')


save(fullfile(saveDir_cat, processedName_mice),'R_total_ISA_mice','R_jrgeco1aCorr_ISA_mice','R_FADCorr_ISA_mice',...
    'R_total_Delta_mice','R_jrgeco1aCorr_Delta_mice','R_FADCorr_Delta_mice',...
    'Rs_total_ISA_mice','Rs_jrgeco1aCorr_ISA_mice','Rs_FADCorr_ISA_mice',...
    'Rs_total_Delta_mice','Rs_jrgeco1aCorr_Delta_mice','Rs_FADCorr_Delta_mice',...
    'powerdata_average_oxy_mice','powerdata_average_deoxy_mice','powerdata_average_total_mice','powerdata_average_jrgeco1aCorr_mice','powerdata_average_FADCorr_mice',...
    'powerdata_oxy_mice','powerdata_deoxy_mice','powerdata_total_mice','powerdata_jrgeco1aCorr_mice','powerdata_FADCorr_mice',...
    'total_ISA_powerMap_mice','jrgeco1aCorr_ISA_powerMap_mice','FADCorr_ISA_powerMap_mice',...
    'total_Delta_powerMap_mice','jrgeco1aCorr_Delta_powerMap_mice','FADCorr_Delta_powerMap_mice',...
    'hz','-append')

disp(char(['QC check on ', processedName_mice]))
if strcmp(char(sessionInfo.miceType),'jrgeco1a')
    visName = miceName;
    %if goodRuns ~=0
    
    
    leftData = cell(2,1);
    leftData{1} = powerdata_jrgeco1aCorr_mice;
    leftData{2} = powerdata_FADCorr_mice;
    
    rightData = cell(3,1);
    rightData{1} = powerdata_oxy_mice;
    rightData{2} = powerdata_deoxy_mice;
    rightData{3} = powerdata_total_mice;
    
    leftLabel = 'Fluor(\DeltaF/F%)^2/Hz)';
    rightLabel = 'Hb(\muM^2/Hz)';
    leftLineStyle = {'m-','g-'};
    rightLineStyle= {'r-','b-','k-'};
    legendName = ["Corrected jRGECO1a","Corrected FAD","HbO","HbR","HbT"];
    
    QCcheck_fftVis_substract(hz, leftData,rightData,leftLabel,rightLabel,leftLineStyle,rightLineStyle,legendName,saveDir_cat,strcat(miceName_powerdata, '_powerCurve'))
    
    
    
    leftData = cell(2,1);
    leftData{1} = powerdata_average_jrgeco1aCorr_mice;
    
    leftData{2} = powerdata_average_FADCorr_mice;
    
    rightData = cell(3,1);
    rightData{1} = powerdata_average_oxy_mice;
    rightData{2} = powerdata_average_deoxy_mice;
    rightData{3} = powerdata_average_total_mice;
    
    leftLabel = 'Fluor(\DeltaF/F%)^2/Hz)';
    rightLabel = 'Hb(\muM^2/Hz)';
    leftLineStyle = {'m-','g-'};
    rightLineStyle= {'r-','b-','k-'};
    legendName = ["Corrected jRGECO1a","Corrected FAD","HbO","HbR","HbT"];
    QCcheck_fftVis_substract(hz, leftData,rightData,leftLabel,rightLabel,leftLineStyle,rightLineStyle,legendName,saveDir_cat,strcat(visName, '_powerCurve_average'))
    
    %end
        saveDir_cat = 'L:\RGECO\cat';
        processedName_mice = '191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc.mat';

    
    load(fullfile(saveDir_cat, processedName_mice),'R_total_ISA_mice','R_jrgeco1aCorr_ISA_mice','R_FADCorr_ISA_mice',...
    'R_total_Delta_mice','R_jrgeco1aCorr_Delta_mice','R_FADCorr_Delta_mice',...
    'Rs_total_ISA_mice','Rs_jrgeco1aCorr_ISA_mice','Rs_FADCorr_ISA_mice',...
    'Rs_total_Delta_mice','Rs_jrgeco1aCorr_Delta_mice','Rs_FADCorr_Delta_mice')
    
    
    refseeds=GetReferenceSeeds_xw;

   
    xform_isbrain_mice =ones(128,128);
    xform_isbrain_mice(isnan(R_total_Delta_mice(:,:,1))) = 0;
    QCcheck_powerMapVis(jrgeco1aCorr_ISA_powerMap_mice,xform_isbrain_mice,'(\DeltaF/F%)',saveDir_cat,strcat(visName, '_RGECOISA'))
    QCcheck_powerMapVis(FADCorr_ISA_powerMap_mice,xform_isbrain_mice,'(\DeltaF/F%)',saveDir_cat,strcat(visName, '_FADISA'))
    QCcheck_powerMapVis(total_ISA_powerMap_mice,xform_isbrain_mice,'\muM',saveDir_cat,strcat(visName, "_TotalISA"))
    
    QCcheck_powerMapVis(jrgeco1aCorr_Delta_powerMap_mice,xform_isbrain_mice,'(\DeltaF/F%)',saveDir_cat,strcat(visName, "_RGECODelta"))
    QCcheck_powerMapVis(FADCorr_Delta_powerMap_mice,xform_isbrain_mice,'(\DeltaF/F%)',saveDir_cat,strcat(visName,"_FADDelta"))
    QCcheck_powerMapVis(total_Delta_powerMap_mice,xform_isbrain_mice,'\muM',saveDir_cat,strcat(visName,"_TotalDelta"))
    

   
visName = 'Anes RGECO';
    QCcheck_fcVis(refseeds,R_jrgeco1aCorr_ISA_mice, Rs_jrgeco1aCorr_ISA_mice,'jrgeco1aCorr','m','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
    QCcheck_fcVis(refseeds,R_FADCorr_ISA_mice, Rs_FADCorr_ISA_mice,'FADCorr','g','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
    QCcheck_fcVis(refseeds,R_total_ISA_mice, Rs_total_ISA_mice,'total','k','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
    
    QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_mice, Rs_jrgeco1aCorr_Delta_mice,'jrgeco1aCorr','m','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
    QCcheck_fcVis(refseeds,R_FADCorr_Delta_mice, Rs_FADCorr_Delta_mice,'FADCorr','g','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
    QCcheck_fcVis(refseeds,R_total_Delta_mice, Rs_total_Delta_mice,'total','k','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
end
close all



