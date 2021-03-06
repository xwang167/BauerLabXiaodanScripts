close all;clear all;clc
import mouse.*
excelRows = [120,133,139,123,122];%[124,126,127];
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
numMice = length(excelRows);
miceName = [];
catDir = 'L:\GCaMP\cat' ;
runs = 1:3;
for excelRow = excelRows
    systemInfo.gbox = 5;
    systemInfo.gsigma = 1.2;

    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':U',num2str(excelRow)]);

    rawdataloc = excelRaw{3};
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);

    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    info.nVx = 128;
    info.nVy = 128;
    sessionInfo.miceType = excelRaw{17};
    systemType =excelRaw{5};
    info.freqout=1;
    miceName = strcat(miceName,'-',mouseName);
    maskDir = saveDir;
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');

    load(fullfile(maskDir,maskName),'xform_isbrain');
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed_mouse','.mat');

    for n =  runs
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        disp('loading processed data')
        load(fullfile(saveDir,processedName),'xform_datahb','xform_gcamp','E_in', 'E_out', 'op_in', 'op_out')
        dpIn = op_in.dpf/2;
        dpOut = op_out.dpf/2;

        xform_gcampCorr_1_0p55 = correctHb_differentBeta(xform_gcamp,xform_datahb,...
            [E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut,0.7,0.8);
        xform_gcampCorr_1_0p55 = process.smoothImage(xform_gcampCorr_1_0p55,systemInfo.gbox,systemInfo.gsigma);

        save(fullfile(saveDir,processedName),'xform_gcampCorr_1_0p55','-append')

    end

end


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
    %maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    load(fullfile(maskDir,maskName), 'xform_isbrain')
    %save(fullfile(maskDir_new,maskName_new),'xform_isbrain')
    %load(fullfile(rawdataloc,recDate,maskName_new), 'xform_isbrain')
    xform_isbrain = double(xform_isbrain);
    for n = runs
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_datahb','xform_gcampCorr','xform_gcampCorr_1_0p55')
        sessionInfo.bandtype_ISA = {"ISA",0.009,0.08};
        sessionInfo.bandtype_Delta = {"Delta",0.4,4};
        
        disp('calculate fc')
        refseeds=GetReferenceSeeds_xw;
        %refseeds = refseeds(1:14,:);
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),' apha = 1, beta = 1');
        
        [R_gcampCorr_ISA,Rs_gcampCorr_ISA] = QCcheck_CalcRRs(refseeds,double(xform_gcampCorr)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}],true);
        
        [R_gcampCorr_Delta,Rs_gcampCorr_Delta] = QCcheck_CalcRRs(refseeds,double(xform_gcampCorr)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],true);
        
        
        QCcheck_fcVis(refseeds,R_gcampCorr_ISA, Rs_gcampCorr_ISA,'gcampCorr','g','ISA',saveDir,visName,false,xform_isbrain)
        QCcheck_fcVis(refseeds,R_gcampCorr_Delta, Rs_gcampCorr_Delta,'gcampCorr','g','Delta',saveDir,visName,false,xform_isbrain)
        
        
        visName_1_0p55 = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),' apha = 1, beta = 0.55');
        
        [R_gcampCorr_ISA_1_0p55,Rs_gcampCorr_ISA_1_0p55] = QCcheck_CalcRRs(refseeds,double(xform_gcampCorr_1_0p55)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}],true);
        
        [R_gcampCorr_Delta_1_0p55,Rs_gcampCorr_Delta_1_0p55] = QCcheck_CalcRRs(refseeds,double(xform_gcampCorr_1_0p55)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],true);
        
        nameString = fullfile(saveDir,visName);
        
        QCcheck_fcVis(refseeds,R_gcampCorr_ISA_1_0p55, Rs_gcampCorr_ISA_1_0p55,'gcampCorr','g','ISA',saveDir,visName_1_0p55,false,xform_isbrain)
        QCcheck_fcVis(refseeds,R_gcampCorr_Delta_1_0p55, Rs_gcampCorr_Delta_1_0p55,'gcampCorr','g','Delta',saveDir,visName_1_0p55,false,xform_isbrain)
        
        
        save(fullfile(saveDir,processedName),'R_gcampCorr_ISA_1_0p55','Rs_gcampCorr_ISA_1_0p55',...
            'R_gcampCorr_Delta_1_0p55','Rs_gcampCorr_Delta_1_0p55',...
            'R_gcampCorr_ISA','Rs_gcampCorr_ISA',...
            'R_gcampCorr_Delta','Rs_gcampCorr_Delta','-append')
    end
end

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
    %goodRuns = str2num(excelRaw{18});
    
    if strcmp(char(sessionInfo.mouseType),'WT')
        systemInfo.numLEDs = 2;
    elseif strcmp(char(sessionInfo.mouseType),'gcamp6f')
        systemInfo.numLEDs = 3;
    end
    maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
    load(fullfile(saveDir,maskName), 'xform_isbrain')
    %         maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
    %         load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataHb','.mat')),'xform_isbrain');
    
    xform_isbrain(xform_isbrain ==2)=1;
    xform_isbrain = double(xform_isbrain);
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
    visName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed');
    length_runs = length(runs);
    R_gcampCorr_Delta_1_0p55_mouse = zeros(info.nVy,info.nVx,16,length_runs);
    R_gcampCorr_ISA_1_0p55_mouse  = zeros(info.nVy,info.nVx,16,length_runs);
    Rs_gcampCorr_Delta_1_0p55_mouse = zeros(16,16,length_runs);
    Rs_gcampCorr_ISA_1_0p55_mouse = zeros(16,16,length_runs);
    
    R_gcampCorr_Delta_mouse = zeros(info.nVy,info.nVx,16,length_runs);
    R_gcampCorr_ISA_mouse  = zeros(info.nVy,info.nVx,16,length_runs);
    Rs_gcampCorr_Delta_mouse = zeros(16,16,length_runs);
    Rs_gcampCorr_ISA_mouse = zeros(16,16,length_runs);
     refseeds=GetReferenceSeeds_xw;
    for n = runs
        
        
        disp('loading processed data')
        
        %             if isDetrend
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        %             else
        %                 processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_NoDetrend','.mat');
        %             end
        if strcmp(sessionType,'fc')
            if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                load(fullfile(saveDir, processedName),'R_gcampCorr_Delta','R_gcampCorr_ISA','Rs_gcampCorr_Delta','Rs_gcampCorr_ISA')
                R_gcampCorr_Delta_mouse(:,:,:,n) = R_gcampCorr_Delta;
                R_gcampCorr_ISA_mouse(:,:,:,n) = R_gcampCorr_ISA;
                
                Rs_gcampCorr_Delta_mouse(:,:,n) = Rs_gcampCorr_Delta;
                Rs_gcampCorr_ISA_mouse(:,:,n) = Rs_gcampCorr_ISA;
                
                load(fullfile(saveDir, processedName),'R_gcampCorr_Delta_1_0p55','R_gcampCorr_ISA_1_0p55','Rs_gcampCorr_Delta_1_0p55','Rs_gcampCorr_ISA_1_0p55')
                R_gcampCorr_Delta_1_0p55_mouse(:,:,:,n) = R_gcampCorr_Delta_1_0p55;
                R_gcampCorr_ISA_1_0p55_mouse(:,:,:,n) = R_gcampCorr_ISA_1_0p55;
                
                Rs_gcampCorr_Delta_1_0p55_mouse(:,:,n) = Rs_gcampCorr_Delta_1_0p55;
                Rs_gcampCorr_ISA_1_0p55_mouse(:,:,n) = Rs_gcampCorr_ISA_1_0p55;
                
                
                
            end
        end
    end
    
    
    R_gcampCorr_Delta_mouse = mean(R_gcampCorr_Delta_mouse,4);
    R_gcampCorr_ISA_mouse  = mean(R_gcampCorr_ISA_mouse,4);
    Rs_gcampCorr_Delta_mouse = mean(Rs_gcampCorr_Delta_mouse,3);
    Rs_gcampCorr_ISA_mouse = mean(Rs_gcampCorr_ISA_mouse,3);
    
    R_gcampCorr_Delta_1_0p55_mouse = mean(R_gcampCorr_Delta_1_0p55_mouse,4);
    R_gcampCorr_ISA_1_0p55_mouse  = mean(R_gcampCorr_ISA_1_0p55_mouse,4);
    Rs_gcampCorr_Delta_1_0p55_mouse = mean(Rs_gcampCorr_Delta_1_0p55_mouse,3);
    Rs_gcampCorr_ISA_1_0p55_mouse = mean(Rs_gcampCorr_ISA_1_0p55_mouse,3);
    
    visName = strcat(recDate,'-',mouseName,'-',sessionType,' apha = 1, beta = 1');
    QCcheck_fcVis(refseeds,R_gcampCorr_ISA_mouse, Rs_gcampCorr_ISA_mouse,'gcampCorr','g','ISA',saveDir,visName,false,xform_isbrain)
    QCcheck_fcVis(refseeds,R_gcampCorr_Delta_mouse, Rs_gcampCorr_Delta_mouse,'gcampCorr','g','Delta',saveDir,visName,false,xform_isbrain)
    
    visName_1_0p55 = strcat(recDate,'-',mouseName,'-',sessionType,' apha = 1, beta = 0.55');
    QCcheck_fcVis(refseeds,R_gcampCorr_ISA_1_0p55_mouse, Rs_gcampCorr_ISA_1_0p55_mouse,'gcampCorr','g','ISA',saveDir,visName_1_0p55,false,xform_isbrain)
    QCcheck_fcVis(refseeds,R_gcampCorr_Delta_1_0p55_mouse, Rs_gcampCorr_Delta_1_0p55_mouse,'gcampCorr','g','Delta',saveDir,visName_1_0p55,false,xform_isbrain)
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
    
    save(fullfile(saveDir, processedName_mouse),'R_gcampCorr_Delta_mouse','Rs_gcampCorr_Delta_mouse',...
        'R_gcampCorr_ISA_mouse','Rs_gcampCorr_ISA_mouse',...
        'R_gcampCorr_Delta_1_0p55_mouse','Rs_gcampCorr_Delta_1_0p55_mouse',...
        'R_gcampCorr_ISA_1_0p55_mouse','Rs_gcampCorr_ISA_1_0p55_mouse','-append')
end



saveDir_cat = 'L:\GCaMP\cat' ;
info.nVx = 128;
info.nVy = 128;

numMice = length(excelRows);
  xform_isbrain_mice = 1;  
    R_gcampCorr_Delta_mice  = zeros(info.nVy,info.nVx,16,numMice);
    R_gcampCorr_ISA_mice  = zeros(info.nVy,info.nVx,16,numMice);
    Rs_gcampCorr_Delta_mice = zeros(16,16,numMice);
    Rs_gcampCorr_ISA_mice = zeros(16,16,numMice);

    R_gcampCorr_Delta_1_0p55_mice  = zeros(info.nVy,info.nVx,16,numMice);
    R_gcampCorr_ISA_1_0p55_mice  = zeros(info.nVy,info.nVx,16,numMice);
    Rs_gcampCorr_Delta_1_0p55_mice = zeros(16,16,numMice);
    Rs_gcampCorr_ISA_1_0p55_mice = zeros(16,16,numMice);


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
            
            
            
            load(fullfile(saveDir, processedName),'R_gcampCorr_Delta_mouse','R_gcampCorr_ISA_mouse',...
                 'Rs_gcampCorr_Delta_mouse','Rs_gcampCorr_ISA_mouse',...
                 'R_gcampCorr_Delta_1_0p55_mouse','R_gcampCorr_ISA_1_0p55_mouse',...
                 'Rs_gcampCorr_Delta_1_0p55_mouse','Rs_gcampCorr_ISA_1_0p55_mouse')
        
           
            
            R_gcampCorr_Delta_mice(:,:,:,ll) = atanh(R_gcampCorr_Delta_mouse);
            R_gcampCorr_ISA_mice(:,:,:,ll) = atanh(R_gcampCorr_ISA_mouse);
            Rs_gcampCorr_Delta_mice(:,:,ll) = atanh(Rs_gcampCorr_Delta_mouse);
            Rs_gcampCorr_ISA_mice(:,:,ll) = atanh(Rs_gcampCorr_ISA_mouse);

             R_gcampCorr_Delta_1_0p55_mice(:,:,:,ll) = atanh(R_gcampCorr_Delta_1_0p55_mouse);
            R_gcampCorr_ISA_1_0p55_mice(:,:,:,ll) = atanh(R_gcampCorr_ISA_1_0p55_mouse);
            Rs_gcampCorr_Delta_1_0p55_mice(:,:,ll) = atanh(Rs_gcampCorr_Delta_1_0p55_mouse);
            Rs_gcampCorr_ISA_1_0p55_mice(:,:,ll) = atanh(Rs_gcampCorr_ISA_1_0p55_mouse);

        
        ll = ll+1;
    end
end
processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'_processed.mat');



R_gcampCorr_Delta_mice = mean(R_gcampCorr_Delta_mice,4);
R_gcampCorr_ISA_mice  = mean(R_gcampCorr_ISA_mice,4);
Rs_gcampCorr_Delta_mice = mean(Rs_gcampCorr_Delta_mice,3);
Rs_gcampCorr_ISA_mice = mean(Rs_gcampCorr_ISA_mice,3);


R_gcampCorr_Delta_1_0p55_mice = mean(R_gcampCorr_Delta_1_0p55_mice,4);
R_gcampCorr_ISA_1_0p55_mice  = mean(R_gcampCorr_ISA_1_0p55_mice,4);
Rs_gcampCorr_Delta_1_0p55_mice = mean(Rs_gcampCorr_Delta_1_0p55_mice,3);
Rs_gcampCorr_ISA_1_0p55_mice = mean(Rs_gcampCorr_ISA_1_0p55_mice,3);



save(fullfile(saveDir_cat, processedName_mice),'R_gcampCorr_ISA_mice','Rs_gcampCorr_ISA_mice',...
    'R_gcampCorr_Delta_1_0p55_mice', 'Rs_gcampCorr_Delta_1_0p55_mice',...
    'R_gcampCorr_ISA_1_0p55_mice','Rs_gcampCorr_ISA_1_0p55_mice',...
    'R_gcampCorr_Delta_1_0p55_mice', 'Rs_gcampCorr_Delta_1_0p55_mice',...
   '-append')



disp(char(['QC check on ', processedName_mice]))

   
    refseeds=GetReferenceSeeds_xw;
    xform_isbrain_mice =ones(128,128);
     
    visName = strcat(recDate,'-',miceName,'-',sessionType,' apha = 1, beta = 1');
   QCcheck_fcVis(refseeds,R_gcampCorr_ISA_mice, Rs_gcampCorr_ISA_mice,'gcampCorr','g','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
    QCcheck_fcVis(refseeds,R_gcampCorr_Delta_mice, Rs_gcampCorr_Delta_mice,'gcampCorr','g','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
  
   visName_1_0p55 = strcat(recDate,'-',miceName,'-',sessionType,' apha = 1, beta = 0.55');
     QCcheck_fcVis(refseeds,R_gcampCorr_ISA_1_0p55_mice, Rs_gcampCorr_ISA_1_0p55_mice,'gcampCorr','g','ISA',saveDir_cat,visName_1_0p55,true,xform_isbrain_mice)
  QCcheck_fcVis(refseeds,R_gcampCorr_Delta_1_0p55_mice, Rs_gcampCorr_Delta_1_0p55_mice,'gcampCorr','g','Delta',saveDir_cat,visName_1_0p55,true,xform_isbrain_mice)
 

  
  load('L:\GCaMP\cat\190506--G6M2-G9M7-G11M1-G7M7-G7M6-fc_processed.mat',...
    'xform_isbrain_mice','R_gcampCorr_ISA_0p7_0p8_mice','Rs_gcampCorr_ISA_0p7_0p8_mice',...
    'R_gcampCorr_Delta_0p7_0p8_mice','Rs_gcampCorr_Delta_0p7_0p8_mice',...
    'R_gcampCorr_ISA_1_0p55_mice','Rs_gcampCorr_ISA_1_0p55_mice',...
    'R_gcampCorr_Delta_1_0p55_mice','Rs_gcampCorr_Delta_1_0p55_mice')
   visName_0p7_0p8 = strcat(recDate,'-','-G6M2-G9M7-G11M1-G7M7-G7M6','-',sessionType,' apha = 0.7, beta = 0.8');
     QCcheck_fcVis(refseeds,R_gcampCorr_ISA_0p7_0p8_mice, Rs_gcampCorr_ISA_0p7_0p8_mice,'gcampCorr','g','ISA',saveDir_cat,visName_0p7_0p8,true,xform_isbrain_mice)
  QCcheck_fcVis(refseeds,R_gcampCorr_Delta_0p7_0p8_mice, Rs_gcampCorr_Delta_0p7_0p8_mice,'gcampCorr','g','Delta',saveDir_cat,visName_0p7_0p8,true,xform_isbrain_mice)
 
  visName_difference = strcat(recDate,'-','-G6M2-G9M7-G11M1-G7M7-G7M6','-',sessionType,' (apha = 1, beta = 0.55) - (apha = 0.7, beta = 0.8)');
     QCcheck_fcVis(refseeds,R_gcampCorr_ISA_1_0p55_mice-R_gcampCorr_ISA_0p7_0p8_mice, Rs_gcampCorr_ISA_1_0p55_mice-Rs_gcampCorr_ISA_0p7_0p8_mice,'gcampCorr','g','ISA',saveDir_cat,visName_difference,true,xform_isbrain_mice)
  QCcheck_fcVis(refseeds,R_gcampCorr_Delta_1_0p55_mice-R_gcampCorr_Delta_0p7_0p8_mice,Rs_gcampCorr_Delta_1_0p55_mice-Rs_gcampCorr_Delta_0p7_0p8_mice,'gcampCorr','g','Delta',saveDir_cat,visName_difference,true,xform_isbrain_mice)
