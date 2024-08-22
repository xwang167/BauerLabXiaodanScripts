close all;clear all;clc
import mouse.*
excelFile = "L:\RGECO\RGECO.xlsx";
excelRows = 2:13;%:450;
runs = 1:3;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    maskDir_new = saveDir;
    rawdataloc = excelRaw{3};
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    maskName_new = strcat(recDate,'-N8M864-opto3-LandmarksAndMask','.mat');
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-','LandmarksAndMask.mat')),'affineMarkers')
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'affineMarkers','xform_isbrain','isbrain')
    end
    
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        if exist(fullfile(saveDir,processedName),'file')
            disp('loading processed data')
            load(fullfile(saveDir,processedName),'xform_datahb','xform_FADCorr','xform_jrgeco1aCorr')
            sessionInfo.bandtype_inter = {"inter",0.08,0.4};
            total = squeeze(xform_datahb(:,:,1,:)) + squeeze(xform_datahb(:,:,2,:));
            clear xform_datahb
            
            xform_jrgeco1aCorr = real(double(xform_jrgeco1aCorr));
            xform_FADCorr = real(double(xform_FADCorr));
            total = real(double(total));
            
            disp('calculate power map')
            jrgeco1aCorr_inter_powerMap = QCcheck_CalcPowerMap(double(xform_jrgeco1aCorr)/0.01,sessionInfo.framerate,[sessionInfo.bandtype_inter{2},sessionInfo.bandtype_inter{3}]);
            FADCorr_inter_powerMap = QCcheck_CalcPowerMap(double(xform_FADCorr)/0.01,sessionInfo.framerate,[sessionInfo.bandtype_inter{2},sessionInfo.bandtype_inter{3}]);
            total_inter_powerMap = QCcheck_CalcPowerMap(double(total)*10^6,sessionInfo.framerate,[sessionInfo.bandtype_inter{2},sessionInfo.bandtype_inter{3}]);
%             
            disp('calculate fc')
            refseeds=GetReferenceSeeds;
            
            [R_jrgeco1aCorr_inter,Rs_jrgeco1aCorr_inter] = QCcheck_CalcRRs(refseeds,double(xform_jrgeco1aCorr)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_inter{2},sessionInfo.bandtype_inter{3}],true);
            [R_FADCorr_inter,Rs_FADCorr_inter] = QCcheck_CalcRRs(refseeds,double(xform_FADCorr)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_inter{2},sessionInfo.bandtype_inter{3}],true);
            [R_total_inter,Rs_total_inter] = QCcheck_CalcRRs(refseeds,double(total)*10^6,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_inter{2},sessionInfo.bandtype_inter{3}],true);
            
            clear xform_FADCorr xform_jrgeco1aCorr xform_jrgeco1a total
            

            save(fullfile(saveDir, processedName),'R_jrgeco1aCorr_inter','Rs_jrgeco1aCorr_inter',...
                'R_FADCorr_inter','Rs_FADCorr_inter','R_total_inter','Rs_total_inter',...
                'jrgeco1aCorr_inter_powerMap','FADCorr_inter_powerMap','total_inter_powerMap','xform_isbrain','-append')
%             
%             QCcheck_powerMapVis(jrgeco1aCorr_inter_powerMap,xform_isbrain,'(\DeltaF/F%)',saveDir,strcat(visName, '_RGECOinter'))
%             QCcheck_powerMapVis(FADCorr_inter_powerMap,xform_isbrain,'(\DeltaF/F%)',saveDir,strcat(visName, '_FADinter'))
%             QCcheck_powerMapVis(total_inter_powerMap,xform_isbrain,'\muM',saveDir,strcat(visName, "_Totalinter"))
            QCcheck_fcVis(refseeds,R_jrgeco1aCorr_inter, Rs_jrgeco1aCorr_inter,'jrgeco1aCorr','m','inter',saveDir,visName,false,xform_isbrain)
            QCcheck_fcVis(refseeds,R_FADCorr_inter, Rs_FADCorr_inter,'FADCorr','g','inter',saveDir,visName,false,xform_isbrain)
            QCcheck_fcVis(refseeds,R_total_inter, Rs_total_inter,'total','k','inter',saveDir,visName,false,xform_isbrain)
            close all
            
        end
    end
end
% 

length_runs = length(runs);
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    rawdataloc = excelRaw{3};
    info.nVx = 128;
    info.nVy = 128;
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    sessionInfo.framerate = excelRaw{7};
    goodRuns = str2num(excelRaw{18});
    
    if strcmp(char(sessionInfo.mouseType),'WT')
        systemInfo.numLEDs = 2;
    elseif strcmp(char(sessionInfo.mouseType),'gcamp6f')
        systemInfo.numLEDs = 3;
    end
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor','.mat')))
        
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor','.mat')),'xform_isbrain');
        
    else
        maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
        load(fullfile(saveDir,maskName), 'xform_isbrain')
    end
    xform_isbrain(xform_isbrain ==2)=1;
    xform_isbrain = double(xform_isbrain);
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
    visName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed');
    
    R_total_inter_mouse  = zeros(info.nVy,info.nVx,16,length_runs);
    Rs_total_inter_mouse = zeros(16,16,length_runs);
    total_inter_powerMap_mouse = zeros(info.nVy,info.nVx,length_runs);
    
    R_jrgeco1aCorr_inter_mouse  = zeros(info.nVy,info.nVx,16,length_runs);
    Rs_jrgeco1aCorr_inter_mouse = zeros(16,16,length_runs);
    jrgeco1aCorr_inter_powerMap_mouse = zeros(info.nVy,info.nVx,length_runs);
    
    R_FADCorr_inter_mouse  = zeros(info.nVy,info.nVx,16,length_runs);
    Rs_FADCorr_inter_mouse = zeros(16,16,length_runs);
    FADCorr_inter_powerMap_mouse = zeros(info.nVy,info.nVx,length_runs);
    
    for n = runs
        
        disp('loading processed data')
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        if strcmp(sessionType,'fc')
            
            
            load(fullfile(saveDir, processedName),'R_total_inter','R_jrgeco1aCorr_inter','R_FADCorr_inter',...
                'Rs_total_inter','Rs_jrgeco1aCorr_inter','Rs_FADCorr_inter',...
                'total_inter_powerMap','jrgeco1aCorr_inter_powerMap','FADCorr_inter_powerMap')
            
            R_total_inter_mouse(:,:,:,n) = R_total_inter;
            Rs_total_inter_mouse(:,:,n) = Rs_total_inter;
            total_inter_powerMap_mouse(:,:,n) = total_inter_powerMap;
            
            R_jrgeco1aCorr_inter_mouse(:,:,:,n) = R_jrgeco1aCorr_inter;
            Rs_jrgeco1aCorr_inter_mouse(:,:,n) = Rs_jrgeco1aCorr_inter;
            jrgeco1aCorr_inter_powerMap_mouse(:,:,n) = jrgeco1aCorr_inter_powerMap;
            
            R_FADCorr_inter_mouse(:,:,:,n) = R_FADCorr_inter;
            Rs_FADCorr_inter_mouse(:,:,n) = Rs_FADCorr_inter;
            FADCorr_inter_powerMap_mouse(:,:,n) = FADCorr_inter_powerMap;
            
        end
    end
    
    disp(char(['QC check on ', processedName_mouse]))
    
    
    
    R_total_inter_mouse  = mean(R_total_inter_mouse,4);
    Rs_total_inter_mouse = mean(Rs_total_inter_mouse,3);
    total_inter_powerMap_mouse = mean(total_inter_powerMap_mouse,3);
    
    
    
    R_jrgeco1aCorr_inter_mouse  = mean(R_jrgeco1aCorr_inter_mouse,4);
    Rs_jrgeco1aCorr_inter_mouse = mean(Rs_jrgeco1aCorr_inter_mouse,3);
    jrgeco1aCorr_inter_powerMap_mouse = mean(jrgeco1aCorr_inter_powerMap_mouse,3);
    
    R_FADCorr_inter_mouse  = mean(R_FADCorr_inter_mouse,4);
    Rs_FADCorr_inter_mouse = mean(Rs_FADCorr_inter_mouse,3);
    FADCorr_inter_powerMap_mouse = mean(FADCorr_inter_powerMap_mouse,3);
    
    save(fullfile(saveDir, processedName_mouse),'R_total_inter_mouse','R_jrgeco1aCorr_inter_mouse','R_FADCorr_inter_mouse',...
        'Rs_total_inter_mouse','Rs_jrgeco1aCorr_inter_mouse','Rs_FADCorr_inter_mouse',...
        'total_inter_powerMap_mouse','jrgeco1aCorr_inter_powerMap_mouse','FADCorr_inter_powerMap_mouse','-append')
    visName = strcat(recDate,'-',mouseName,'-',sessionType);
    
    
    refseeds=GetReferenceSeeds;
    
    QCcheck_powerMapVis(jrgeco1aCorr_inter_powerMap_mouse,xform_isbrain,'(\DeltaF/F%)',saveDir,strcat(visName, '_RGECOinter'))
    QCcheck_powerMapVis(FADCorr_inter_powerMap_mouse,xform_isbrain,'(\DeltaF/F%)',saveDir,strcat(visName, '_FADinter'))
    QCcheck_powerMapVis(total_inter_powerMap_mouse,xform_isbrain,'\muM',saveDir,strcat(visName, "_Totalinter"))
    
    QCcheck_fcVis(refseeds,R_jrgeco1aCorr_inter_mouse, Rs_jrgeco1aCorr_inter_mouse,'jrgeco1aCorr','m','inter',saveDir,visName,false,xform_isbrain)
    QCcheck_fcVis(refseeds,R_FADCorr_inter_mouse, Rs_FADCorr_inter_mouse,'FADCorr','g','inter',saveDir,visName,false,xform_isbrain)
    QCcheck_fcVis(refseeds,R_total_inter_mouse, Rs_total_inter_mouse,'total','k','inter',saveDir,visName,false,xform_isbrain)
    
    close all
end

excelRows = 2:7;
numMice = length(excelRows);
xform_isbrain_mice = 1;
sessionInfo.miceType = 'jrgeco1a';
saveDir_cat = 'L:\RGECO\\cat';

R_total_inter_mice  = zeros(128,128,16,numMice);
Rs_total_inter_mice = zeros(16,16,numMice);

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
    
    load(fullfile(saveDir, processedName),'R_total_inter_mouse','R_jrgeco1aCorr_inter_mouse','R_FADCorr_inter_mouse',...
        'Rs_total_inter_mouse','Rs_jrgeco1aCorr_inter_mouse', 'Rs_FADCorr_inter_mouse',...
        'total_inter_powerMap_mouse','jrgeco1aCorr_inter_powerMap_mouse','FADCorr_inter_powerMap_mouse')
    
    R_total_inter_mice(:,:,:,ll) = atanh(R_total_inter_mouse);
    Rs_total_inter_mice(:,:,ll) = atanh(Rs_total_inter_mouse);
    total_inter_powerMap_mice(:,:,ll) = total_inter_powerMap_mouse;
    
    R_jrgeco1aCorr_inter_mice(:,:,:,ll) = atanh(R_jrgeco1aCorr_inter_mouse);
    Rs_jrgeco1aCorr_inter_mice(:,:,ll) = atanh(Rs_jrgeco1aCorr_inter_mouse);
    jrgeco1aCorr_inter_powerMap_mice(:,:,ll) = jrgeco1aCorr_inter_powerMap_mouse;
    
    
    R_FADCorr_inter_mice(:,:,:,ll) = atanh(R_FADCorr_inter_mouse);
    Rs_FADCorr_inter_mice(:,:,ll) = atanh(Rs_FADCorr_inter_mouse);
    FADCorr_inter_powerMap_mice(:,:,ll) = FADCorr_inter_powerMap_mouse;
    ll = ll+1;
end
processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'.mat');
R_total_inter_mice  = mean(R_total_inter_mice,4);
Rs_total_inter_mice = mean(Rs_total_inter_mice,3);
total_inter_powerMap_mice = mean(total_inter_powerMap_mice,3);

R_jrgeco1aCorr_inter_mice  = mean(R_jrgeco1aCorr_inter_mice,4);
Rs_jrgeco1aCorr_inter_mice = mean(Rs_jrgeco1aCorr_inter_mice,3);
jrgeco1aCorr_inter_powerMap_mice = mean(jrgeco1aCorr_inter_powerMap_mice,3);

R_FADCorr_inter_mice  = mean(R_FADCorr_inter_mice,4);
Rs_FADCorr_inter_mice = mean(Rs_FADCorr_inter_mice,3);
FADCorr_inter_powerMap_mice = mean(FADCorr_inter_powerMap_mice,3);


save(fullfile(saveDir_cat, processedName_mice),'R_total_inter_mice','R_jrgeco1aCorr_inter_mice','R_FADCorr_inter_mice',...
    'Rs_total_inter_mice','Rs_jrgeco1aCorr_inter_mice','Rs_FADCorr_inter_mice',...
    'total_inter_powerMap_mice','jrgeco1aCorr_inter_powerMap_mice','FADCorr_inter_powerMap_mice','xform_isbrain_mice','-append')

disp(char(['QC check on ', processedName_mice]))


visName = 'Awake RGECO';
QCcheck_powerMapVis(jrgeco1aCorr_inter_powerMap_mice,xform_isbrain_mice,'(\DeltaF/F%)',saveDir_cat,strcat(visName, '_RGECOinter'))
QCcheck_powerMapVis(FADCorr_inter_powerMap_mice,xform_isbrain_mice,'(\DeltaF/F%)',saveDir_cat,strcat(visName, '_FADinter'))
QCcheck_powerMapVis(total_inter_powerMap_mice,xform_isbrain_mice,'\muM',saveDir_cat,strcat(visName, "_Totalinter"))



refseeds=GetReferenceSeeds;
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_inter_mice, Rs_jrgeco1aCorr_inter_mice,'jrgeco1aCorr','m','inter',saveDir_cat,visName,true,xform_isbrain_mice)
QCcheck_fcVis(refseeds,R_FADCorr_inter_mice, Rs_FADCorr_inter_mice,'FADCorr','g','inter',saveDir_cat,visName,true,xform_isbrain_mice)
QCcheck_fcVis(refseeds,R_total_inter_mice, Rs_total_inter_mice,'total','k','inter',saveDir_cat,visName,true,xform_isbrain_mice)

close all




excelRows = 8:13;
numMice = length(excelRows);
xform_isbrain_mice = 1;
sessionInfo.miceType = 'jrgeco1a';
saveDir_cat = 'L:\RGECO\\cat';

R_total_inter_mice  = zeros(128,128,16,numMice);
Rs_total_inter_mice = zeros(16,16,numMice);

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
    
    load(fullfile(saveDir, processedName),'R_total_inter_mouse','R_jrgeco1aCorr_inter_mouse','R_FADCorr_inter_mouse',...
        'Rs_total_inter_mouse','Rs_jrgeco1aCorr_inter_mouse', 'Rs_FADCorr_inter_mouse',...
        'total_inter_powerMap_mouse','jrgeco1aCorr_inter_powerMap_mouse','FADCorr_inter_powerMap_mouse')
    
    R_total_inter_mice(:,:,:,ll) = atanh(R_total_inter_mouse);
    Rs_total_inter_mice(:,:,ll) = atanh(Rs_total_inter_mouse);
    total_inter_powerMap_mice(:,:,ll) = total_inter_powerMap_mouse;
    
    R_jrgeco1aCorr_inter_mice(:,:,:,ll) = atanh(R_jrgeco1aCorr_inter_mouse);
    Rs_jrgeco1aCorr_inter_mice(:,:,ll) = atanh(Rs_jrgeco1aCorr_inter_mouse);
    jrgeco1aCorr_inter_powerMap_mice(:,:,ll) = jrgeco1aCorr_inter_powerMap_mouse;
    
    
    R_FADCorr_inter_mice(:,:,:,ll) = atanh(R_FADCorr_inter_mouse);
    Rs_FADCorr_inter_mice(:,:,ll) = atanh(Rs_FADCorr_inter_mouse);
    FADCorr_inter_powerMap_mice(:,:,ll) = FADCorr_inter_powerMap_mouse;
    ll = ll+1;
end
processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'.mat');
R_total_inter_mice  = mean(R_total_inter_mice,4);
Rs_total_inter_mice = mean(Rs_total_inter_mice,3);
total_inter_powerMap_mice = mean(total_inter_powerMap_mice,3);

R_jrgeco1aCorr_inter_mice  = mean(R_jrgeco1aCorr_inter_mice,4);
Rs_jrgeco1aCorr_inter_mice = mean(Rs_jrgeco1aCorr_inter_mice,3);
jrgeco1aCorr_inter_powerMap_mice = mean(jrgeco1aCorr_inter_powerMap_mice,3);

R_FADCorr_inter_mice  = mean(R_FADCorr_inter_mice,4);
Rs_FADCorr_inter_mice = mean(Rs_FADCorr_inter_mice,3);
FADCorr_inter_powerMap_mice = mean(FADCorr_inter_powerMap_mice,3);


save(fullfile(saveDir_cat, processedName_mice),'R_total_inter_mice','R_jrgeco1aCorr_inter_mice','R_FADCorr_inter_mice',...
    'Rs_total_inter_mice','Rs_jrgeco1aCorr_inter_mice','Rs_FADCorr_inter_mice',...
    'total_inter_powerMap_mice','jrgeco1aCorr_inter_powerMap_mice','FADCorr_inter_powerMap_mice','xform_isbrain_mice','-append')

disp(char(['QC check on ', processedName_mice]))


visName = 'Anes RGECO';
QCcheck_powerMapVis_dB(jrgeco1aCorr_inter_powerMap_mice,xform_isbrain_mice,saveDir_cat,strcat(visName, '_RGECOinter'))
QCcheck_powerMapVis_dB(FADCorr_inter_powerMap_mice,xform_isbrain_mice,saveDir_cat,strcat(visName, '_FADinter'))
QCcheck_powerMapVis_dB(total_inter_powerMap_mice,xform_isbrain_mice,saveDir_cat,strcat(visName, "_Totalinter"))



refseeds=GetReferenceSeeds;
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_inter_mice, Rs_jrgeco1aCorr_inter_mice,'jrgeco1aCorr','m','inter',saveDir_cat,visName,true,xform_isbrain_mice)
QCcheck_fcVis(refseeds,R_FADCorr_inter_mice, Rs_FADCorr_inter_mice,'FADCorr','g','inter',saveDir_cat,visName,true,xform_isbrain_mice)
QCcheck_fcVis(refseeds,R_total_inter_mice, Rs_total_inter_mice,'total','k','inter',saveDir_cat,visName,true,xform_isbrain_mice)

close all



