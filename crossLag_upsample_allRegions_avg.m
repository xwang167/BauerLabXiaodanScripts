clear ;close all;clc
excelFile = "X:\RGECO\DataBase_Xiaodan_1.xlsx";
freq_new = 250;
t_kernel = 30;
t = (0:t_kernel*freq_new-1)/freq_new ;

load("AtlasandIsbrain_Allen.mat",'parcelnames','AtlasSeeds')

% Overlapped brain mask
xform_isbrain_mice = 1;
for excelRow = [181 183 185 228 232 236 202 195 204 230 234 240]
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    disp(strcat(mouseName,', run #1'))
    maskDir = strcat('E:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'xform_isbrain')
    end   
    xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
end
% Region inside of mouse brain

mask = AtlasSeeds.*xform_isbrain_mice;
mask(isnan(mask)) = 0;
% total number of pixels in all interested regions
pixelNum = zeros(1,50);
for region = 1:50
    mask_region = zeros(128,128);
    mask_region(mask == region) = 1;
    pixelNum(region) = sum(mask_region,'all');
end
pixelNumTotal = sum(pixelNum);

% total number of pixels in all interested regions
pixelNum = zeros(1,50);
for region = 1:50
    mask_region = zeros(128,128);
    mask_region(mask == region) = 1;
    pixelNum(region) = sum(mask_region,'all');
end

% Average Gamma Parameters for each region
% Initialization
for condition = {'awake','anes'}
    for h = {'NVC','NMC'}
      
             eval(strcat('lagAmp_' ,  h{1},'_mice_',condition{1},'=[];'))
             eval(strcat('lagTime_',  h{1},'_mice_',condition{1},'=[];'))
             eval(strcat('lagWid_' ,  h{1},'_mice_',condition{1},'=[];'))
             eval(strcat('crossLagY_',h{1},'_mice_',condition{1},'=[];'))
        
    end
end

excelRows_awake = [181 183 185 228 232 236];
excelRows_anes  = [202 195 204 230 234 240];
for condition = {'awake','anes'}
    for excelRow = eval(strcat('excelRows_',condition{1}))
        [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
        recDate = excelRaw{1}; recDate = string(recDate);
        mouseName = excelRaw{2}; mouseName = string(mouseName);
        saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
        sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
        for n = 1:3
            disp(strcat(mouseName,', run#',num2str(n)))            
            for h = {'NVC','NMC'} 
                for var = {'lagAmp','lagTime','lagWid'}
                % Load
                eval(strcat('load(fullfile(saveDir,',char(39),'CrossLag_',h{1},char(39),',',char(39), recDate,'-',mouseName,'-',sessionType,num2str(n),'_CrossLag_',h{1},'.mat',char(39),'),',...
                    char(39),var{1},'_',h{1},char(39),')'))
                % concatenate
                eval(strcat(var{1},'_',h{1},'_mice_',condition{1},'= cat(1,',...
                    var{1},'_',h{1},'_mice_',condition{1},',',var{1},'_',h{1},');'))
                end
            end
        end
    end
end

%% Maps with regional values
saveName = "E:\RGECO\cat\crossLag_allRegions.mat";
for condition = {'awake','anes'}
    for h = {'NVC','NMC'}         
       for var = {'lagAmp','lagTime','lagWid'}
           eval(strcat(var{1},'_',h{1},'_',condition{1},'_map =  zeros(1,128*128);')) 
           for region = 1:50
               mask_region = zeros(128,128);
               mask_region(mask == region) = 1;
               mask_region = logical(mask_region);
               eval(strcat(var{1},'_',h{1},'_',condition{1},'_map(mask_region(:))=nanmedian(',var{1},'_',h{1},'_mice_',condition{1},'(:,region));'))
           end
               eval(strcat(var{1},'_',h{1},'_',condition{1},'_map = reshape(',var{1},'_',h{1},'_',condition{1},'_map,128,128);'))
           
           if exist(saveName,'file')
               eval(strcat('save(',char(39),saveName,char(39),',',...
                   char(39),var{1},'_' ,h{1},'_',condition{1},'_map',char(39),',',...
                   char(39),'-append',char(39),')'))
           else
               eval(strcat('save(',char(39),saveName,char(39),',',...
                   char(39),var{1},'_' ,h{1},'_',condition{1},'_map',char(39),')'))
           end
        end
    end
end

%% Calculate Gamma for the whole brain
%% Concatinate the matrix
for condition = {'awake','anes'}
    mouseInd =1;
    for excelRow = eval(strcat('excelRows_',condition{1}))
        [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
        recDate = excelRaw{1}; recDate = string(recDate);
        mouseName = excelRaw{2}; mouseName = string(mouseName);
        saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
        sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
        for h = {'NVC','NMC'}
             eval(strcat('crossLagY_',h{1},'_mouse_',condition{1},'_allRegions = [];'))
        end
        for n = 1:3
            disp(strcat(mouseName,', run #',num2str(n)))
            load(fullfile(saveDir,'CrossLag_NVC', strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CrossLag_NVC.mat')),'crossLagY_NVC')
            load(fullfile(saveDir,'CrossLag_NMC', strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CrossLag_NMC.mat')),'crossLagY_NMC')
            % cat r,MRF, HRF
            for h = {'NVC','NMC'}
                eval(strcat( 'crossLagY_',h{1},'_mouse_',condition{1},'_allRegions = cat(1,crossLagY_',h{1},'_mouse_',condition{1},'_allRegions,crossLagY_',h{1},');'))
            end    
        end

        for h = {'NVC','NMC'}
            eval(strcat('crossLagY_',h{1},'_mouse_',condition{1},'_allRegions = nanmedian(crossLagY_',h{1},'_mouse_',condition{1},'_allRegions);'))       
            eval(strcat('crossLagY_',h{1},'_mice_',condition{1},'_allRegions(mouseInd,:,:) = crossLagY_',h{1},'_mouse_',condition{1},'_allRegions;'))
        end        
        mouseInd = mouseInd+1;
    end
end

%% Averaged cross lag for each mouse, then averaged across mice
for h = {'NVC','NMC'}
    for condition = {'awake','anes'}
        eval(strcat('crossLagY_',h{1},'_mice_',condition{1},'= zeros(6,1251);'))
        mouseInd =1;
        for excelRow = eval(strcat('excelRows_',condition{1}))
             [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
            recDate = excelRaw{1}; recDate = string(recDate);
            mouseName = excelRaw{2}; mouseName = string(mouseName);
            saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
            sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
            % initialization
            disp([condition,h])        
            for region = 1:50
                %Weight crossLagY based on the number of pixels inside of
                % reigonal mask.
                eval(strcat('temp = squeeze(crossLagY_',h{1},'_mice_',condition{1},'_allRegions(mouseInd,:,region))*pixelNum(region)/pixelNumTotal;'))
                eval(strcat('crossLagY_',h{1},'_mice_',condition{1},'(mouseInd,:)= crossLagY_',h{1},'_mice_',condition{1},'(mouseInd,:)+temp;'))
                clear temp
            end
            mouseInd = mouseInd+1;
        end
    end
end
load(fullfile(saveDir,'CrossLag_NVC',strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CrossLag_NVC.mat')),'crossLagX_NVC')
save('E:\RGECO\cat\crossLag_allRegions.mat','crossLagX_NVC','crossLagY_NVC_mice_awake','crossLagY_NVC_mice_anes','crossLagY_NMC_mice_awake','crossLagY_NMC_mice_anes')
%% Visualization
load("GoodWL.mat")
mask(isnan(mask)) = 0;
for condition = {'awake','anes'}
    for h = {'NVC','NMC'}
         figure('units','normalized','outerposition',[0 0 1 1])
        subplot(2,2,3)
        temp = strcat('imagesc(lagAmp_',h{1},'_',condition{1},'_map,',char(39),'AlphaData',char(39),',mask)');
        eval(temp)
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        cb=colorbar;
        caxis([0 1])
        axis image off
        colormap jet
        title('r')
        set(gca,'FontSize',14,'FontWeight','Bold')

        subplot(2,2,4)
        eval(strcat('plot_distribution_prctile(crossLagX_NVC(1,:,1),crossLagY_',h{1},'_mice_',condition{1},',',char(39),'Color',char(39),',[0 0 0])'))   
        title(h)
        xlabel('Time(s)')
        xlim([-1 4])
        set(gca,'FontSize',14,'FontWeight','Bold')
       if strcmp(h,'NVC')
            ylim([-0.2 0.5])
        else
            ylim([-0.8 0.9])
        end
        subplot(2,2,1)
        eval(strcat('imagesc(lagTime_',h{1},'_',condition{1},'_map,',char(39),'AlphaData',char(39),',mask)'));
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        cb=colorbar;
        
        if strcmp(h,'NVC')
            caxis([0 2])
        else
            caxis([0 0.2])
        end
        axis image off
        cmocean('ice')
        title('T(s)')
        set(gca,'FontSize',14,'FontWeight','Bold')

        subplot(2,2,2)
        temp = strcat('imagesc(lagWid_',h{1},'_',condition{1},'_map/freq_new,',char(39),'AlphaData',char(39),',mask)');
        eval(temp)
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        cb=colorbar;
        if strcmp(h,'NVC')
            caxis([0 2])
        else
            caxis([0 1.5])
        end
        axis image off
        cmocean('ice')
        title('W(s)')
        set(gca,'FontSize',14,'FontWeight','Bold')

        sgtitle(strcat('Cross lag',{' '},h,' for RGECO mice under',{' '},condition,' condition'))
        saveas(gcf,strcat('X:\Paper1\Figure_2023\CrossLag_',h{1},'_',condition{1}))
    end
end

%% lag and correlation values for each mouse

% Rows for both conditions
excelRows_awake = [181 183 185 228 232 236];
excelRows_anes  = [202 195 204 230 234 240];

% Initialize
for condition = {'awake','anes'}
    for h = {'NVC','NMC'}
        for var = {'lagAmp','lagTime'}
            eval(strcat(var{1},'_',h{1},'_',condition{1},'= zeros(6,1);'))
        end
    end
end

% Calculate lag and correlation for each mouse
for condition = {'awake','anes'}
    mouseInd = 1;
    for excelRow = eval(strcat('excelRows_',condition{1}))
        [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
        recDate = excelRaw{1}; recDate = string(recDate);
        mouseName = excelRaw{2}; mouseName = string(mouseName);
        saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
        sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
        for var = {'lagAmp','lagTime'}
            % Initialize
            for h = {'NVC','NMC'} 
                eval(strcat(var{1},'_mouse = zeros(3,1);'))
                for n = 1:3
                    disp(strcat(mouseName,', run#',num2str(n)))
                    % Load
                    eval(strcat('load(fullfile(saveDir,',char(39),'CrossLag_',h{1},char(39),',',char(39), recDate,'-',mouseName,'-',sessionType,num2str(n),'_CrossLag_',h{1},'.mat',char(39),'),',...
                        char(39),var{1},'_',h{1},char(39),')'))
                    % Average across time windows
                    eval(strcat('temp = squeeze(nanmean(',var{1},'_',h{1},'));'))
                    % Average across regions
                    eval(strcat(var{1},'_avg = 0;'))
                    for region = 1:50
                        % weighted by area
                        eval(strcat(var{1},'_avg = ',var{1},'_avg + temp(region)*pixelNum(region)/pixelNumTotal;'))
                    end
                    eval(strcat(var{1},'_mouse(n) = ',var{1},'_avg;'))               
                end
                eval(strcat(var{1},'_',h{1},'_',condition{1},'(mouseInd)= mean(',var{1},'_mouse);'))
                
            end           
        end
        mouseInd = mouseInd+1;
    end
end

% mean and std
for condition = {'awake','anes'}
    for h = {'NVC','NMC'}
        for var = {'lagAmp','lagTime'}
            for operation = {'mean','std'}
                eval(strcat(operation{1},'_',var{1},'_',h{1},'_',condition{1},'=',...
                    operation{1},'(',var{1},'_',h{1},'_',condition{1},');'))
            end
        end
    end
end

[~, p_crossLag_NVC_lagTime]=ttest(lagTime_NVC_anes, lagTime_NVC_awake, 'Tail','both');
[~, p_crossLag_NMC_lagTime]=ttest(lagTime_NMC_anes, lagTime_NMC_awake,'Tail','both');
[~, p_crossLag_NMC_lagAmp]=ttest(lagAmp_NMC_anes, lagAmp_NMC_awake, 'Tail','both');