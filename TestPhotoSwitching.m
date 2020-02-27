close all;clear all;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";

excelRows = 277:279;

runs = 1:6;
nVy = 128;
nVx = 128;
interestedChannel = [1,2];
raw_mice = zeros(length(interestedChannel),1204,length(excelRows));
mouseInd = 1;

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
    %maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
    saveDir_new = fullfile("K:\RGECO\Raw",recDate);
    if ~exist(saveDir_new)
        mkdir(saveDir_new)
    end
    sessionInfo.framerate = excelRaw{7};
    sessionInfo.blockLength = excelRaw{11};
    sessionInfo.stimbaseline = excelRaw{12};
    maskName_new = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
    %maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    %load(fullfile(maskDir,maskName), 'xform_isbrain')
    %save(fullfile(maskDir_new,maskName_new),'xform_isbrain')
    %    load(fullfile(maskDir_new,maskName_new), 'isbrain')
    %   isbrain = double(isbrain);
    isbrain = ones(128,128);
    
    if strcmp(systemType,'EastOIS2')
        rawName1 = strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'.mat');
        load(fullfile(saveDir,rawName1),'rawdata')
        rawdata1 = rawdata;
    end
    clear rawdata
    raw_mouse = zeros(size(rawdata1,1),size(rawdata1,2),length(interestedChannel),sessionInfo.blockLength,length(runs));
    clear rawdata1
    disp(mouseName)
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        if strcmp(systemType,'EastOIS2')
            if strcmp(sessionInfo.mouseType,'jrgeco1a')
                rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
                load(fullfile(saveDir,rawName))
                load(fullfile(saveDir,maskName_new),'affineMarkers')
                numChan = size(rawdata,3);
                xform_raw = process.affineTransform(rawdata(:,:,:, sessionInfo.darkFrameNum/numChan+1:end),affineMarkers);
            elseif strcmp(sessionInfo.mouseType,'Gopto3')||strcmp(sessionInfo.mouseType,'Wopto3')||strcmp(sessionInfo.mouseType,'PV')
                rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
                load(fullfile(saveDir,rawName))
            else
                rawName_cam1 = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-cam1.mat');
                load(fullfile(rawdataloc,recDate,rawName_cam1))
                rawdata = raw_unregistered;
                rawName_cam2 = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-cam2.mat');
                load(fullfile(rawdataloc,recDate,rawName_cam2))
                rawdata(:,:,2,:) = raw_unregistered(:,:,2,:);
            end
            
            
        else
            rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.tif');
            rawdata = double(readtiff(fullfile(rawdataloc ,recDate,rawName)));
        end
        detrendInterestedRaw = temporalDetrendAdam(rawdata(:,:,interestedChannel,:));
        detrendInterestedRaw  = reshape(detrendInterestedRaw,128,128,size(detrendInterestedRaw,3),[],5);
        baseline = squeeze(mean(detrendInterestedRaw(:,:,:,1:sessionInfo.stimbaseline,:),4));
        dRR = zeros(size(detrendInterestedRaw));
        
        for ii = 1:size(detrendInterestedRaw,4)
            dRR(:,:,:,ii,:) = (squeeze(detrendInterestedRaw(:,:,:,ii,:))-baseline)./baseline*100;
        end
        
        clear detrendInterestedRaw baseline
        save(fullfile(saveDir,rawName),'dRR','-append')
        dRR_blocks = squeeze(mean(dRR,5));
        clear dRR
        raw_mouse(:,:,:,:,n) = dRR_blocks;
        disp(['run #' num2str(n)])
    end
    
    
    raw_mouse = squeeze(mean(raw_mouse,5));
    raw_mouse = reshape(raw_mouse,128*128,size(raw_mouse,3),size(raw_mouse,4));
    
    if strcmp(sessionInfo.mouseType,'jrgeco1a-opto4')
        rawdata = reshape(rawdata,128,128,5,[]);
        peakMap_ROI = rawdata(:,:,5,sessionInfo.stimbaseline+2);
    elseif strcmp(sessionInfo.mouseType,'jrgeco1a-opto2')
        rawdata = reshape(rawdata,128,128,3,[]);
        peakMap_ROI = rawdata(:,:,3,sessionInfo.stimbaseline+2);
    elseif strcmp(sessionInfo.mouseType,'PV')
         peakMap_ROI = rawdata(:,:,3,sessionInfo.stimbaseline+2);
    elseif strcmp(sessionInfo.mouseType,'Gopto3')||strcmp(sessionInfo.mouseType,'Wopto3')
        peakMap_ROI = rawdata(:,:,1,sessionInfo.stimbaseline+2);
    end
    clear rawdata
    %
    if strcmp(sessionInfo.mouseType,'jrgeco1a')
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile('K:\RGECO\Raw\awake_ROI.mat'),'ROI_NoGSR')
        ROI = ROI_NoGSR;
    else
        imagesc(peakMap_ROI)
        axis image off
        colormap jet
        [x1,y1] = ginput(1);
        [X,Y] = meshgrid(1:128,1:128);
        radius = 5;
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        max_ROI = prctile(peakMap_ROI(ROI),70);
        temp = double(peakMap_ROI).*double(ROI);
        ROI = temp>=max_ROI;
        hold on
        ROI_contour = bwperim(ROI);
        contour( ROI_contour,'k');
        pause;
        nonROI = roipoly();
        ROI(nonROI) = 0;
        figure;
        imagesc(peakMap_ROI)
        axis image off
        colormap jet
        hold on
        ROI_contour = bwperim(ROI);
        contour( ROI_contour,'k');
    end
    
    iROI = reshape(ROI,1,[]);
    raw_mouse_active = squeeze(mean(raw_mouse(iROI,:,:),1));
    raw_mice(:,:,mouseInd)= raw_mouse_active;
    mouseInd = mouseInd+1;
    
    %save(fullfile(saveDir_new,'ROI.mat'),'ROI')
    
    %             load('D:\OIS_Process\noVasculatureMask.mat')
    %             xform_isbrain= xform_isbrain.*(double(leftMask)+double(rightMask));
    
    
    %
    %
    %         load(fullfile(saveDir_new,'ROI.mat'))
    %load(fullfile(saveDir,strcat(visName,'_processed.mat')),'ROI_NoGSR')
    %        ROI = ROI_NoGSR;
    
    
    %
    %     texttitle= strcat(mouseName,'-stim'," ",'raw in ROI');
    %     output = fullfile(saveDir_new,strcat(recDate,'-',mouseName,'-stim','for Raw'));
    %     disp(mouseName)
    %     if strcmp(sessionInfo.mouseType,'Gopto3')||strcmp(sessionInfo.mouseType,'Wopto3')
    %         dFF = quanti_bleedover(squeeze(raw_mouse),sessionInfo.stimbaseline,sessionInfo.stimduration*sessionInfo.framerate,size(raw_mouse,4)/sessionInfo.stimblocksize,sessionInfo.framerate,ROI,texttitle,output);
    %         save(strcat(output,'.mat'),'dFF')
    %         raw_mice(n,:) = dFF;
    %     elseif strcmp(sessionInfo.mouseType,'jrgeco1a')
    %         QC_stim_raw(squeeze(xform_raw(:,:,3,:)), squeeze(xform_raw(:,:,4,:)),squeeze(xform_raw(:,:,2,:)),sessionInfo.stimbaseline,sessionInfo.stimduration*sessionInfo.framerate,size(xform_raw,4)/sessionInfo.stimblocksize,sessionInfo.framerate,ROI,texttitle,output,systemType)
    %
    %     elseif strcmp(sessionInfo.mouseType,'jrgeco1a-opto4')
    %         QC_stim_raw(squeeze(rawdata(:,:,1,:)), squeeze(rawdata(:,:,2,:)),squeeze(rawdata(:,:,5,:)),sessionInfo.stimbaseline,sessionInfo.stimduration*sessionInfo.framerate,size(rawdata,4)/sessionInfo.stimblocksize,sessionInfo.framerate,ROI,texttitle,output,systemType)
    %
    %
    %     elseif    strcmp(sessionInfo.mouseType,'jrgeco1a-opto2')
    %         QC_stim_raw(squeeze(rawdata(:,:,1,:)), squeeze(rawdata(:,:,2,:)),squeeze(rawdata(:,:,3,:)),sessionInfo.stimbaseline,sessionInfo.stimduration*sessionInfo.framerate,size(rawdata,4)/sessionInfo.stimblocksize,sessionInfo.framerate,ROI,texttitle,output,systemType)
    %
    %     end
    %     close all
    
    
    
end

raw_mice = squeeze(mean(raw_mice,3));

sessionInfo.stimblocksize = excelRaw{11};
sessionInfo.stimbaseline=excelRaw{12};
sessionInfo.stimduration = excelRaw{13};
sessionInfo.stimFrequency = excelRaw{16};
stimStartTime = 5;

stimBaselineFrames = sessionInfo.stimbaseline;
stimDurationFrames = sessionInfo.stimduration*sessionInfo.framerate;



% lineColor = {'k-','g-','r-'};
% labelText = {'F/F','R/R','R/R'};
% before_ROI = zeros(1,3);
% on_ROI = zeros(1,3);
% after_ROI = zeros(1,3);
% figure
% for ii = 1:3
%     before_ROI(1,ii) = mean(squeeze(raw_mice(ii,1:stimBaselineFrames)));
%     on_ROI(1,ii) = mean(squeeze(raw_mice(ii,stimBaselineFrames+1:stimBaselineFrames+stimDurationFrames)));
%     after_ROI(1,ii) = mean(squeeze(raw_mice(ii,stimBaselineFrames+stimDurationFrames+1:end)));
%     
%     
%     subplot(1,2,1);
%     dFF = squeeze(raw_mice(ii,:));
%     x = (1:length( dFF))/sessionInfo.framerate;
%     if ii == 1
%         yyaxis left
%         ylabel('\DeltaF/F%')
%         
%     else
%         yyaxis right
%         ylabel('\DeltaR/R%')
%         
%     end
%     hold on
%     plot(x,dFF,lineColor{1,ii});
%      ylim([-0.9 0.9])
%     hold on;
%     
%     xlabel('Time(s)','FontSize',20,'fontweight','bold')
% %     a = get(gca,'XTickLabel');
% %     set(a,'XTickLabel',a,'FontName','Times','fontsize',16)
% %     
%     
% 
%     
% end
%     title('Averaged Across 3 WT mice')
%     legend('Fluor','Green LED','Red LED');
% 
%     line([5 5],[-0.9 0.9])
%     line([10 10],[-0.9 0.9])
%     ylim([-0.9 0.9])
%         annotation('textbox',...
%         [0.6 0.15 0.3 0.8],...
%         'String',...
%         {['Fluor\_before = ' num2str(before_ROI(1)) '%; '],...
%         ['Fluor\_on = ' num2str(on_ROI(1)) '%;' ],...
%         ['Fluor\_after = ' num2str(after_ROI(1)) '%;'],...
%              [],...
%         [],...
%         ['Green\_before = ' num2str(before_ROI(2)) '%; '],...
%         ['Green\_on = ' num2str(on_ROI(2)) '%;' ],...
%         ['Green\_after = ' num2str(after_ROI(2)) '%;'],...
%         [],...
%         [],...
%         ['Red\_before = ' num2str(before_ROI(3)) '%; '],...
%         ['Red\_on = ' num2str(on_ROI(3)) '%;' ],...
%         ['Red\_after = ' num2str(after_ROI(3)) '%;']},...
%          'FontSize',16,...
%         'FontName','Arial',...
%         'LineStyle','--',...
%         'EdgeColor',[1 1 0],...
%         'LineWidth',2,...
%         'BackgroundColor',[0.9  0.9 0.9],...
%         'Color',[0 0 0]);


lineColor = {'g-','r-'};

before_ROI = zeros(1,2);
on_ROI = zeros(1,2);
after_ROI = zeros(1,2);
figure
for ii = 1:2
    before_ROI(1,ii) = mean(squeeze(raw_mice(ii,1:stimBaselineFrames)));
    on_ROI(1,ii) = mean(squeeze(raw_mice(ii,stimBaselineFrames+1:stimBaselineFrames+stimDurationFrames)));
    after_ROI(1,ii) = mean(squeeze(raw_mice(ii,stimBaselineFrames+stimDurationFrames+1:end)));
    
    
    subplot(1,2,1);
    dRR = squeeze(raw_mice(ii,:));
    x = (1:length( dRR))/sessionInfo.framerate;

   ylabel('\DeltaR/R%')
        
    
    hold on
    plot(x,dRR,lineColor{1,ii});
     ylim([-0.9 0.9])
    hold on;
    
    xlabel('Time(s)','FontSize',20,'fontweight','bold')
%     a = get(gca,'XTickLabel');
%     set(a,'XTickLabel',a,'FontName','Times','fontsize',16)
%     
    

    
end
    title('Averaged Across 3 WT mice')
    legend('Green LED','Red LED');

    line([5 5],[-0.9 0.9])
    line([10 10],[-0.9 0.9])
    ylim([-0.9 0.9])
        annotation('textbox',...
        [0.6 0.15 0.3 0.8],...
        'String',...
        {['Green\_before = ' num2str(before_ROI(1)) '%; '],...
        ['Green\_on = ' num2str(on_ROI(1)) '%;' ],...
        ['Green\_after = ' num2str(after_ROI(1)) '%;'],...
        [],...
        [],...
        ['Red\_before = ' num2str(before_ROI(2)) '%; '],...
        ['Red\_on = ' num2str(on_ROI(2)) '%;' ],...
        ['Red\_after = ' num2str(after_ROI(2)) '%;']},...
         'FontSize',16,...
        'FontName','Arial',...
        'LineStyle','--',...
        'EdgeColor',[1 1 0],...
        'LineWidth',2,...
        'BackgroundColor',[0.9  0.9 0.9],...
        'Color',[0 0 0]);
xlim([0 60])