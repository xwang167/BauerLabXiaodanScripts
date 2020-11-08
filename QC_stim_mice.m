
close all;clearvars;clc

import mouse.*

excelRows =  [380,382,384];%,229,233,237%,
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
numMice = length(excelRows);

miceName = [];
catDir = 'J:\PVRGECO\cat' ;






stimStartTime = 5;

nVx = 128;
nVy = 128;

xform_datahb_mice_GSR = [];
xform_datahb_mice_NoGSR = [];

xform_jrgeco1a_mice_GSR = [];
xform_jrgeco1a_mice_NoGSR = [];

xform_jrgeco1aCorr_mice_GSR = [];
xform_jrgeco1aCorr_mice_NoGSR = [];

xform_red_mice_GSR = [];
xform_red_mice_NoGSR = [];

%  xform_FAD_mice_GSR = [];
%  xform_FAD_mice_NoGSR = [];
%
% xform_FADCorr_mice_GSR = [];
% xform_FADCorr_mice_NoGSR = [];
%
%
% xform_gcamp_mice_GSR = [];
% xform_gcamp_mice_NoGSR = [];
%
% xform_gcampCorr_mice_GSR = [];
% xform_gcampCorr_mice_NoGSR = [];
%
% xform_green_mice_GSR = [];
%  xform_green_mice_NoGSR = [];


xform_isbrain_mice = ones(nVx ,nVy);
isbrain_mice = ones(nVx ,nVy);
for excelRow = excelRows
    
    
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
    sessionInfo.stimblocksize = excelRaw{11};
    sessionInfo.stimbaseline=excelRaw{12};
    sessionInfo.stimduration = excelRaw{13};
    sessionInfo.stimFrequency = excelRaw{16};
    sessionInfo.framerate = excelRaw{7};
    info.freqout=1;
    miceName = strcat(miceName,'-',mouseName);
    
    %maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
    %load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataHb','.mat')),'xform_isbrain');
    
    %     maskDir = saveDir;
    %     maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    
    mouseName = char(mouseName);
    maskDir = rawdataloc;
    maskName = strcat(recDate,'-',mouseName(1:16),mouseName((end-4):end),'-LandmarksAndMask','.mat');
    
    load(fullfile(maskDir,recDate,maskName),'xform_isbrain');
%     xform_isbrain = ones(128,128);
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed_mouse','.mat');
    
    %xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
    
    %    isbrain_mice = isbrain_mice.*isbrain;
    
    
    
    
    
    if strcmp(char(sessionInfo.miceType),'gcamp6f')
        sessionInfo.stimblocksize = excelRaw{11};
        
        
        
        disp('loading processed data')
        load(fullfile(saveDir, processedName_mouse),'xform_datahb_mouse_GSR','xform_gcamp_mouse_GSR','xform_gcampCorr_mouse_GSR','xform_green_mouse_GSR')
        numBlocks = size(xform_datahb_mouse_GSR,4)/sessionInfo.stimblocksize;
        
        
        xform_datahb_mice_GSR = cat(5,xform_datahb_mice_GSR,xform_datahb_mouse_GSR);
        xform_gcamp_mice_GSR = cat(4,xform_gcamp_mice_GSR,xform_gcamp_mouse_GSR);
        xform_gcampCorr_mice_GSR = cat(4,xform_gcampCorr_mice_GSR,xform_gcampCorr_mouse_GSR);
        xform_green_mice_GSR = cat(4,xform_green_mice_GSR,xform_green_mouse_GSR);
        
        disp('loading processed data')
        load(fullfile(saveDir, processedName_mouse),'xform_datahb_mouse_NoGSR','xform_gcamp_mouse_NoGSR','xform_gcampCorr_mouse_NoGSR','xform_green_mouse_NoGSR')
        
        
        
        xform_datahb_mice_NoGSR = cat(5,xform_datahb_mice_NoGSR,xform_datahb_mouse_NoGSR);
        xform_gcamp_mice_NoGSR = cat(4,xform_gcamp_mice_NoGSR,xform_gcamp_mouse_NoGSR);
        xform_gcampCorr_mice_NoGSR = cat(4,xform_gcampCorr_mice_NoGSR,xform_gcampCorr_mouse_NoGSR);
        xform_green_mice_NoGSR = cat(4,xform_green_mice_NoGSR,xform_green_mouse_NoGSR);
    elseif strcmp(char(sessionInfo.miceType),'jrgeco1a')
        disp('loading  GRS data')
        sessionInfo.stimblocksize = excelRaw{11};
        load(fullfile(saveDir,processedName_mouse),...
            'xform_datahb_mouse_GSR','xform_jrgeco1a_mouse_GSR','xform_jrgeco1aCorr_mouse_GSR','xform_red_mouse_GSR','xform_FAD_mouse_GSR','xform_FADCorr_mouse_GSR','xform_green_mouse_GSR')
        if size(xform_datahb_mouse_GSR,1)>1
            xform_datahb_mice_GSR = cat(5,xform_datahb_mice_GSR,xform_datahb_mouse_GSR);
        end
        clear xform_datahb_mouse_GSR
        xform_jrgeco1a_mice_GSR = cat(4,xform_jrgeco1a_mice_GSR,xform_jrgeco1a_mouse_GSR);
        clear xform_jrgeco1a_mouse_GSR
        xform_jrgeco1aCorr_mice_GSR = cat(4,xform_jrgeco1aCorr_mice_GSR,xform_jrgeco1aCorr_mouse_GSR);
        clear xform_jrgeco1aCorr_mouse_GSR
        %        xform_red_mice_GSR = cat(4,xform_red_mice_GSR,xform_red_mouse_GSR);
        %         clear xform_red_mouse_GSR
        %
        xform_FAD_mice_GSR = cat(4,xform_FAD_mice_GSR,xform_FAD_mouse_GSR);
        clear xform_FAD_mouse_GSR
        xform_FADCorr_mice_GSR = cat(4,xform_FADCorr_mice_GSR,xform_FADCorr_mouse_GSR);
        clear xform_FADCorr_mouse_GSR
        %         xform_green_mice_GSR = cat(4,xform_green_mice_GSR,xform_green_mouse_GSR);
        %                 clear xform_green_mouse_GSR
        %
        
        
        %         disp('loading  Non GRS data')
        %
        %        load(fullfile(saveDir,processedName_mouse),...
        %              'xform_datahb_mouse_NoGSR','xform_jrgeco1a_mouse_NoGSR','xform_jrgeco1aCorr_mouse_NoGSR','xform_red_mouse_NoGSR','xform_FAD_mouse_NoGSR','xform_FADCorr_mouse_NoGSR','xform_green_mouse_NoGSR')
        % %
        %         xform_datahb_mice_NoGSR = cat(5,xform_datahb_mice_NoGSR,xform_datahb_mouse_NoGSR);
        %         clear xform_datahb_mouse_NoGSR
        %    xform_jrgeco1a_mice_NoGSR = cat(4,xform_jrgeco1a_mice_NoGSR,xform_jrgeco1a_mouse_NoGSR);
        %          clear xform_jrgeco1a_mouse_NoGSR
        %        xform_jrgeco1aCorr_mice_NoGSR = cat(4,xform_jrgeco1aCorr_mice_NoGSR,xform_jrgeco1aCorr_mouse_NoGSR);
        %         clear xform_jrgeco1aCorr_mouse_NoGSR
        %      xform_red_mice_NoGSR = cat(4,xform_red_mice_NoGSR,xform_red_mouse_NoGSR);
        %         clear xform_red_mouse_NoGSR
        % %
        %     xform_FAD_mice_NoGSR = cat(4,xform_FAD_mice_NoGSR,xform_FAD_mouse_NoGSR);
        %         clear xform_FAD_mouse_NoGSR
        %        xform_FADCorr_mice_NoGSR = cat(4,xform_FADCorr_mice_NoGSR,xform_FADCorr_mouse_NoGSR);
        %         clear xform_FADCorr_mouse_NoGSR
        %       xform_green_mice_NoGSR = cat(4,xform_green_mice_NoGSR,xform_green_mouse_NoGSR);
        % clear xform_green_mouse_NoGSR
        % %
        % %
        %
    elseif strcmp(char(sessionInfo.miceType),'jrgeco1a-opto3')
        
        disp('loading  GRS data')
        sessionInfo.stimblocksize = excelRaw{11};
        load(fullfile(saveDir,processedName_mouse),...
            'xform_datahb_mouse_GSR','xform_jrgeco1a_mouse_GSR','xform_jrgeco1aCorr_mouse_GSR','xform_red_mouse_GSR','ROI_NoGSR')
        if size(xform_datahb_mouse_GSR,1)>1
            xform_datahb_mice_GSR = cat(5,xform_datahb_mice_GSR,xform_datahb_mouse_GSR);
        end
        clear xform_datahb_mouse_GSR
        xform_jrgeco1a_mice_GSR = cat(4,xform_jrgeco1a_mice_GSR,xform_jrgeco1a_mouse_GSR);
        clear xform_jrgeco1a_mouse_GSR
        xform_jrgeco1aCorr_mice_GSR = cat(4,xform_jrgeco1aCorr_mice_GSR,xform_jrgeco1aCorr_mouse_GSR);
        clear xform_jrgeco1aCorr_mouse_GSR
        xform_red_mice_GSR = cat(4,xform_red_mice_GSR,xform_red_mouse_GSR);
        clear xform_red_mouse_GSR
        disp('loading  Non GRS data')
        
        load(fullfile(saveDir,processedName_mouse),...
            'xform_datahb_mouse_NoGSR','xform_jrgeco1a_mouse_NoGSR','xform_jrgeco1aCorr_mouse_NoGSR','xform_red_mouse_NoGSR')
        xform_datahb_mice_NoGSR = cat(5,xform_datahb_mice_NoGSR,xform_datahb_mouse_NoGSR);
        clear xform_datahb_mouse_NoGSR
        xform_jrgeco1a_mice_NoGSR = cat(4,xform_jrgeco1a_mice_NoGSR,xform_jrgeco1a_mouse_NoGSR);
        clear xform_jrgeco1a_mouse_NoGSR
        xform_jrgeco1aCorr_mice_NoGSR = cat(4,xform_jrgeco1aCorr_mice_NoGSR,xform_jrgeco1aCorr_mouse_NoGSR);
        clear xform_jrgeco1aCorr_mouse_NoGSR
        xform_red_mice_NoGSR = cat(4,xform_red_mice_NoGSR,xform_red_mouse_NoGSR);
        clear xform_red_mouse_NoGSR
        
    elseif strcmp(char(sessionInfo.miceType),'WT')
        load(fullfile(saveDir, processedName),'xform_datahb_GSR','goodBlocks_GSR')
        if ~isempty(goodBlocks_GSR)
            temp = reshape(xform_datahb_GSR,nVy,nVx,2,sessionInfo.stimblocksize,[]);
            temp_goodBlocks_GSR = temp(:,:,:,:,goodBlocks_GSR);
            xform_datahb_mice_GSR = cat(5,xform_datahb_mice_GSR,temp_goodBlocks_GSR);
            load(fullfile(saveDir, processedName),'xform_datahb_NoGSR','goodBlocks_NoGSR')
            if ~isempty(goodBlocks_NoGSR)
                temp = reshape(xform_datahb_NoGSR,nVy,nVx,2,sessionInfo.stimblocksize,[]);
                temp_goodBlocks = temp(:,:,:,:,goodBlocks_NoGSR);
                xform_datahb_mice_NoGSR = cat(5,xform_datahb_mice_NoGSR,temp_goodBLocks);
            end
            
        end
    elseif strcmp(char(sessionInfo.miceType),'jrgeco1a-opto2')
        sessionInfo.stimblocksize = excelRaw{11};
        load(fullfile(saveDir,processedName_mouse),'xform_datahb_mouse_NoGSR')
        
        xform_datahb_mice_NoGSR = cat(5,xform_datahb_mice_NoGSR,xform_datahb_mouse_NoGSR);
        clear xform_datahb_mouse_NoGSR
    end
end
xform_datahb_mice_GSR = mean(xform_datahb_mice_GSR,5);
xform_datahb_mice_NoGSR = mean(xform_datahb_mice_NoGSR,5);
processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'_processed_mice','.mat');

save(fullfile(catDir,processedName_mice),'xform_datahb_mice_GSR','xform_datahb_mice_NoGSR','-v7.3');
%save(fullfile(catDir,processedName_mice),'xform_datahb_mice_GSR','xform_isbrain_mice','-append')
if strcmp(char(sessionInfo.miceType),'gcamp6f')
    xform_gcamp_mice_NoGSR = mean(xform_gcamp_mice_GSR,4);
    xform_gcampCorr_mice_NoGSR = mean(xform_gcampCorr_mice_NoGSR,4);
    xform_green_mice_NoGSR = mean(xform_green_mice_NoGSR,4);
    save(fullfile(catDir,processedName_mice),'xform_gcamp_mice_NoGSR','xform_gcampCorr_mice_NoGSR','xform_green_mice_NoGSR','-append');
    texttitle_NoGSR = strcat(miceName,'-stim'," ",'without GSR nor filtering');
    output_NoGSR= fullfile(catDir,strcat(recDate,'-',miceName,'-stim','_NoGSR'));
    numDesample = size(xform_green_mice_NoGSR,3)/sessionInfo.framerate*info.freqout;
    factor = round(numDesample/1);
    numDesample = factor*1;
    load(fullfile('J:\GCaMP\Hillman_dpf\cat',processedName_mice),'ROI_NoGSR')
    % %
    %     disp('QC on non GSR stim')
    QC_stim(squeeze(xform_datahb_mice_NoGSR(:,:,1,:)),squeeze(xform_datahb_mice_NoGSR(:,:,2,:)),...
        xform_gcamp_mice_NoGSR,xform_gcampCorr_mice_NoGSR,xform_green_mice_NoGSR,[],[],[],...
        xform_isbrain_mice,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,ROI_NoGSR);
%     clear xform_datahb_mice_NoGSR xform_gcamp_mice_NoGSR xform_gcampCorr_mice_NoGSR xform_green_mice_NoGSR
    
    
    
    xform_gcamp_mice_GSR = mean(xform_gcamp_mice_GSR,4);
    xform_gcampCorr_mice_GSR = mean(xform_gcampCorr_mice_GSR,4);
    xform_green_mice_GSR = mean(xform_green_mice_GSR,4);
    save(fullfile(catDir,processedName_mice),'xform_gcamp_mice_GSR','xform_gcampCorr_mice_GSR','xform_green_mice_GSR','ROI_NoGSR','-append');
    
    
    texttitle_GSR = strcat(miceName,'-stim'," ",'with GSR without filtering');
    output_GSR= fullfile(catDir,strcat(recDate,'-',miceName,'-stim','_GSR'));
    
    
    disp('QC on GSR stim')
    QC_stim(squeeze(xform_datahb_mice_GSR(:,:,1,:)),squeeze(xform_datahb_mice_GSR(:,:,2,:)),...
        xform_gcamp_mice_GSR,xform_gcampCorr_mice_GSR,xform_green_mice_GSR,[],[],[],...
        xform_isbrain_mice,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_GSR,output_GSR,ROI_NoGSR);
    
%     clear xform_datahb_mice_GSR   xform_gcamp_mice_GSR xform_gcampCorr_mice_GSR xform_green_mice_GSR
    
    
elseif strcmp(char(sessionInfo.miceType),'jrgeco1a')
    %   xform_jrgeco1a_mice_NoGSR = mean(xform_jrgeco1a_mice_NoGSR,4);
    %      xform_jrgeco1aCorr_mice_NoGSR = mean(xform_jrgeco1aCorr_mice_NoGSR,4);
    %   xform_red_mice_NoGSR = mean(xform_red_mice_NoGSR,4);
    %
    %   xform_FAD_mice_NoGSR = mean(xform_FAD_mice_NoGSR,4);
    %     xform_FADCorr_mice_NoGSR = mean(xform_FADCorr_mice_NoGSR,4);
    %    xform_green_mice_NoGSR = mean(xform_green_mice_NoGSR,4);
    %             xform_jrgeco1aCorr_mice_NoGSR(isinf(xform_jrgeco1aCorr_mice_NoGSR)) = 0;
    %         xform_jrgeco1aCorr_mice_NoGSR(isnan(xform_jrgeco1aCorr_mice_NoGSR)) = 0;
    %     %     xform_jrgeco1aCorr_mice_NoGSR = mouse.freq.highpass(xform_jrgeco1aCorr_mice_NoGSR,1,25);
    %     %
    %         xform_jrgeco1a_mice_NoGSR(isinf(xform_jrgeco1a_mice_NoGSR)) = 0;
    %         xform_jrgeco1a_mice_NoGSR(isnan(xform_jrgeco1a_mice_NoGSR)) = 0;
    %     %     xform_jrgeco1a_mice_NoGSR = mouse.freq.highpass(xform_jrgeco1a_mice_NoGSR,1,25);
    %
    %  save(fullfile(catDir,processedName_mice),'xform_jrgeco1a_mice_NoGSR','xform_jrgeco1aCorr_mice_NoGSR','xform_red_mice_NoGSR','xform_FAD_mice_NoGSR','xform_FADCorr_mice_NoGSR','xform_green_mice_NoGSR','-append')
    %     texttitle_NoGSR = strcat(miceName,'-stim'," ",'without GSR nor filtering');
    %     output_NoGSR= fullfile(catDir,strcat(recDate,'-',miceName,'-stim','_NoGSR'));
    numDesample = size(xform_green_mice_NoGSR,3)/sessionInfo.framerate*info.freqout;
    factor = round(numDesample/1);
    numDesample = factor*1;
    %     % %
    %
    %
    %     if strcmp(char(sessionInfo.miceType),'jrgeco1a')
    %         disp('QC on non GSR stim')
    %         [~,ROI_NoGSR] =  QC_stim(squeeze(xform_datahb_mice_NoGSR(:,:,1,:))*10^6,squeeze(xform_datahb_mice_NoGSR(:,:,2,:))*10^6,...
    %             xform_FAD_mice_NoGSR*100,xform_FADCorr_mice_NoGSR*100,xform_green_mice_NoGSR*100,xform_jrgeco1a_mice_NoGSR*100,xform_jrgeco1aCorr_mice_NoGSR*100,xform_red_mice_NoGSR*100,...
    %             xform_isbrain_mice,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,[],[],[]);
    %
    
    
    
    
    %         clear xform_datahb_mice_NoGSR xform_jrgeco1a_mice_NoGSR xform_jrgeco1aCorr_mice_NoGSR xform_red_mice_NoGSR  xform_FAD_mice_NoGSR xform_FADCorr_mice_NoGSR xform_green_mice_NoGSR
    %     else
    %         load(fullfile(saveDir,'ROI.mat'))
    %         [~,ROI_NoGSR] =  QC_stim(squeeze(xform_datahb_mice_NoGSR(:,:,1,:))*10^6,squeeze(xform_datahb_mice_NoGSR(:,:,2,:))*10^6,...
    %             xform_FAD_mice_NoGSR/3,xform_FADCorr_mice_NoGSR/3,xform_green_mice_NoGSR/3,xform_jrgeco1a_mice_NoGSR*100,xform_jrgeco1aCorr_mice_NoGSR*100,xform_red_mice_NoGSR*100,...
    %            isbrain_mice,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,ROI);
    %         clear xform_datahb_mice_NoGSR xform_jrgeco1a_mice_NoGSR xform_jrgeco1aCorr_mice_NoGSR xform_red_mice_NoGSR  xform_FAD_mice_NoGSR xform_FADCorr_mice_NoGSR xform_green_mice_NoGSR
    %     end
    %
    %
    xform_jrgeco1a_mice_GSR = mean(xform_jrgeco1a_mice_GSR,4);
    xform_jrgeco1aCorr_mice_GSR = mean(xform_jrgeco1aCorr_mice_GSR,4);
    %     xform_red_mice_GSR = mean(xform_red_mice_GSR,4);
    %
    xform_FAD_mice_GSR = mean(xform_FAD_mice_GSR,4);
    xform_FADCorr_mice_GSR = mean(xform_FADCorr_mice_GSR,4);
    %     xform_green_mice_GSR = mean(xform_green_mice_GSR,4);
    %
    
    
    
    %save(fullfile(catDir,processedName_mice),'xform_jrgeco1aCorr_mice_NoGSR','xform_FADCorr_mice_NoGSR','-append')
    %save(fullfile(catDir,processedName_mice),'xform_jrgeco1a_mice_GSR','xform_jrgeco1aCorr_mice_GSR','xform_red_mice_GSR','xform_FAD_mice_GSR','xform_FADCorr_mice_GSR','xform_green_mice_GSR','-append')
    save(fullfile(catDir,processedName_mice),'xform_jrgeco1a_mice_GSR','xform_jrgeco1aCorr_mice_GSR','xform_FAD_mice_GSR','xform_FADCorr_mice_GSR','-append')
    
    %
    texttitle_GSR = strcat(miceName,'-stim'," ",'with GSR without filtering');
    output_GSR= fullfile(catDir,strcat(recDate,'-',miceName,'-stim','_GSR'));
    
    %
    %     disp('QC on GSR stim')
    %         QC_stim(squeeze(xform_datahb_mice_GSR(:,:,1,:)),squeeze(xform_datahb_mice_GSR(:,:,2,:)),...
    %           xform_FAD_mice_GSR,xform_FADCorr_mice_GSR,xform_green_mice_GSR,xform_jrgeco1a_mice_GSR,xform_jrgeco1aCorr_mice_GSR,xform_red_mice_GSR,...
    %             xform_isbrain_mice,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_GSR,output_GSR,ROI_NoGSR);
    %
    %     clear xofrm_datahb_mice_GSR xform_jrgeco1a_mice_GSR xform_jrgeco1aCorr_mice_GSR xform_red_mice_GSR  xform_FAD_mice_GSR xform_FADCorr_mice_GSR xform_green_mice_GSR
elseif strcmp(char(sessionInfo.miceType),'jrgeco1a-opto3')
    xform_jrgeco1a_mice_NoGSR = mean(xform_jrgeco1a_mice_NoGSR,4);
    xform_jrgeco1aCorr_mice_NoGSR = mean(xform_jrgeco1aCorr_mice_NoGSR,4);
    xform_red_mice_NoGSR = mean(xform_red_mice_NoGSR,4);
    
    xform_jrgeco1aCorr_mice_NoGSR(isinf(xform_jrgeco1aCorr_mice_NoGSR)) = 0;
    xform_jrgeco1aCorr_mice_NoGSR(isnan(xform_jrgeco1aCorr_mice_NoGSR)) = 0;
    %     xform_jrgeco1aCorr_mice_NoGSR = mouse.freq.highpass(xform_jrgeco1aCorr_mice_NoGSR,1,25);
    %
    xform_jrgeco1a_mice_NoGSR(isinf(xform_jrgeco1a_mice_NoGSR)) = 0;
    xform_jrgeco1a_mice_NoGSR(isnan(xform_jrgeco1a_mice_NoGSR)) = 0;
    %     xform_jrgeco1a_mice_NoGSR = mouse.freq.highpass(xform_jrgeco1a_mice_NoGSR,1,25);
    %
    save(fullfile(catDir,processedName_mice),'xform_jrgeco1a_mice_NoGSR','xform_jrgeco1aCorr_mice_NoGSR','xform_red_mice_NoGSR','-append')
    texttitle_NoGSR = strcat(miceName,'-stim'," ",'without GSR nor filtering');
    output_NoGSR= fullfile(catDir,strcat(recDate,'-',miceName,'-stim','_NoGSR'));
    numDesample = size(xform_red_mice_NoGSR,3)/sessionInfo.framerate*info.freqout;
    factor = round(numDesample/1);
    numDesample = factor*1;
    
    
    peakMap_ROI = mean(xform_jrgeco1aCorr_mice_NoGSR(:,:,sessionInfo.stimbaseline+1:sessionInfo.stimbaseline+sessionInfo.stimduration*sessionInfo.framerate),3);   
   figure
   colormap jet
    imagesc(peakMap_ROI,[-0.006 0.006])
    axis image off
    
    [X,Y] = meshgrid(1:128,1:128);
        
        [x1,y1] = ginput(1);
        [x2,y2] = ginput(1);
        
        radius = sqrt((x1-x2)^2+(y1-y2)^2);
   
    ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
    min_ROI = prctile(peakMap_ROI(ROI),1);
    temp = double(peakMap_ROI).*double(ROI);
    ROI = temp<min_ROI*0.75;
    hold on
    ROI_contour = bwperim(ROI);
     contour( ROI_contour)   
    
    
    [~,ROI_NoGSR] =  QC_stim(squeeze(xform_datahb_mice_NoGSR(:,:,1,:))*10^6,squeeze(xform_datahb_mice_NoGSR(:,:,2,:))*10^6,...
        [],[],[],xform_jrgeco1a_mice_NoGSR*100,xform_jrgeco1aCorr_mice_NoGSR*100,xform_red_mice_NoGSR*100,...
        xform_isbrain_mice,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,ROI_contour);
    %
%     clear xform_datahb_mice_NoGSR xform_jrgeco1a_mice_NoGSR xform_jrgeco1aCorr_mice_NoGSR xform_red_mice_NoGSR  xform_FAD_mice_NoGSR xform_FADCorr_mice_NoGSR xform_green_mice_NoGSR
    
    %
    %
    xform_jrgeco1a_mice_GSR = mean(xform_jrgeco1a_mice_GSR,4);
    xform_jrgeco1aCorr_mice_GSR = mean(xform_jrgeco1aCorr_mice_GSR,4);
    xform_red_mice_GSR = mean(xform_red_mice_GSR,4);
    %
    
    %
    
    
    
    
    save(fullfile(catDir,processedName_mice),'xform_jrgeco1a_mice_GSR','xform_jrgeco1aCorr_mice_GSR','xform_red_mice_GSR','-append')
    
    
    %
    texttitle_GSR = strcat(miceName,'-stim'," ",'with GSR without filtering');
    output_GSR= fullfile(catDir,strcat(recDate,'-',miceName,'-stim','_GSR'));
    
    %
    disp('QC on GSR stim')
    QC_stim(squeeze(xform_datahb_mice_GSR(:,:,1,:))*10^6,squeeze(xform_datahb_mice_GSR(:,:,2,:))*10^6,...
        [],[],[],xform_jrgeco1a_mice_GSR*100,xform_jrgeco1aCorr_mice_GSR*100,xform_red_mice_GSR*100,...
        xform_isbrain_mice,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_GSR,output_GSR,ROI_contour);
    
%     clear xofrm_datahb_mice_GSR xform_jrgeco1a_mice_GSR xform_jrgeco1aCorr_mice_GSR xform_red_mice_GSR  xform_FAD_mice_GSR xform_FADCorr_mice_GSR xform_green_mice_GSR
    
elseif strcmp(char(sessionInfo.miceType),'jrgeco1a-opto2')
    texttitle_NoGSR = strcat(miceName,'-stim'," ",'without GSR nor filtering');
    output_NoGSR= fullfile(catDir,strcat(recDate,'-',miceName,'-stim','_NoGSR'));
    numDesample = size(xform_datahb_mice_NoGSR,4)/sessionInfo.framerate*info.freqout;
    factor = round(numDesample/1);
    numDesample = factor*1;
    
    load(fullfile(saveDir,'ROI.mat'))
    [~,ROI_NoGSR] =  QC_stim(squeeze(xform_datahb_mice_NoGSR(:,:,1,:))*10^6,squeeze(xform_datahb_mice_NoGSR(:,:,2,:))*10^6,...
        [],[],[],[],[],[],...
        isbrain_mice,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,ROI);
    clear xform_datahb_mice_NoGSR xform_jrgeco1a_mice_NoGSR xform_jrgeco1aCorr_mice_NoGSR xform_red_mice_NoGSR  xform_FAD_mice_NoGSR xform_FADCorr_mice_NoGSR xform_green_mice_NoGSR
    
end
















%% No GSR




