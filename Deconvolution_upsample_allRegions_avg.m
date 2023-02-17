clear ;close all;clc
excelFile = "X:\RGECO\DataBase_Xiaodan_3.xlsx";
freq_new     = 250;
t_kernel = 30;
t = (-3*freq_new:(t_kernel-3)*freq_new-1)/freq_new ;

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
    processedName = strcat(recDate,'-',mouseName,'-',sessionType,'1_processed','.mat');
    load(fullfile(saveDir,processedName),'xform_isbrain')
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
%% Initialize
for condition = {'awake','anes'}
    for h = {'HRF','MRF'}   
        eval(strcat( h{1},'_mice_',condition{1},'_allRegions = nan(6,7500,50);'))
        eval(strcat('r_',h{1},'_mice_',condition{1},'_allRegions = nan(6,50);'))   
        eval(strcat( h{1},'_mice_',condition{1},' = zeros(6,7500);'))
        eval(strcat('r_',h{1},'_mice_',condition{1},' = zeros(6);'))  
    end
end

excelRows_awake = [181 183 185 228 232 236];
excelRows_anes  = [202 195 204 230 234 240];

%% Concatinate the matrix
for condition = {'awake','anes'}
    mouseInd =1;
    for excelRow = eval(strcat('excelRows_',condition{1}))
        [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
        recDate = excelRaw{1}; recDate = string(recDate);
        mouseName = excelRaw{2}; mouseName = string(mouseName);
        saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
        sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
        for h = {'HRF','MRF'}
             eval(strcat( h{1},'_mouse_',condition{1},'_allRegions = [];'))
             eval(strcat('r_',h{1},'_mouse_',condition{1},'_allRegions = [];'))
        end
        for n = 1:3
            disp(strcat(mouseName,', run #',num2str(n)))
            load(fullfile(saveDir,'HRF_Upsample', strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_HRF_Upsample.mat')))
            load(fullfile(saveDir,'MRF_Upsample', strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_MRF_Upsample.mat')))
            % cat r,MRF, HRF
            for h = {'HRF','MRF'}
                eval(strcat( h{1},'_mouse_',condition{1},'_allRegions = cat(1,',h{1},'_mouse_',condition{1},'_allRegions,',h{1},');'))
                eval(strcat( 'r_',h{1},'_mouse_',condition{1},'_allRegions = cat(1,r_',h{1},'_mouse_',condition{1},'_allRegions,r_',h{1},');'))
            end    
        end

        for h = {'HRF','MRF'}
            eval(strcat( h{1},'_mouse_',condition{1},'_allRegions = mean(',h{1},'_mouse_',condition{1},'_allRegions);'))
            eval(strcat( 'r_',h{1},'_mouse_',condition{1},'_allRegions = mean(r_',h{1},'_mouse_',condition{1},'_allRegions);'))
            eval(strcat( h{1},'_mice_',condition{1},'_allRegions(mouseInd,:,:) =',h{1},'_mouse_',condition{1},'_allRegions;'))
            eval(strcat( 'r_',h{1},'_mice_',condition{1},'_allRegions(mouseInd,:) = r_',h{1},'_mouse_',condition{1},'_allRegions;'))
        end        
        mouseInd = mouseInd+1;
    end
end

%% Average across all regions 
for condition = {'awake','anes'}
    for h = {'HRF','MRF'}
        for mouseInd = 1:6
            for region = 1:50
                eval(strcat('temp = squeeze(',h{1},'_mice_',condition{1},'_allRegions(mouseInd,:,region))*pixelNum(region)/pixelNumTotal;'))
                eval(strcat( h{1},'_mice_',condition{1},'(mouseInd,:)=',h{1},'_mice_',condition{1},'(mouseInd,:)+temp;'))
                clear temp
                eval(strcat('temp = squeeze(nanmean(r_',h{1},'_mice_',condition{1},'_allRegions(mouseInd,region)))*pixelNum(region)/pixelNumTotal;'))
                eval(strcat( 'r_',h{1},'_mice_',condition{1},'(mouseInd)=r_',h{1},'_mice_',condition{1},'(mouseInd)+temp;'))
                clear temp
            end
        end
        saveName = "D:\XiaodanPaperData\cat\deconvolution_allRegions.mat";
        if exist(saveName,'file')
            eval(strcat('save(',char(39),saveName,char(39),',',...
                char(39),h{1},'_mice_',condition{1},char(39),',',...
                char(39),'r_',h{1},'_mice_',condition{1},char(39),',',...
                char(39),'-append',char(39),')'))
        else
            eval(strcat('save(',char(39),saveName,char(39),',',...
                char(39),h{1},'_mice_',condition{1},char(39),',',...
                char(39),'r_',h{1},'_mice_',condition{1},char(39),')'))
        end
    end
end

%% Calculate T, W, A, r for each region
saveName = "D:\XiaodanPaperData\cat\deconvolution_allRegions.mat";
for condition = {'awake','anes'}
    for h = {'HRF','MRF'}  
        for var = {'T','W','A'}
            eval(strcat(var{1},'_',h{1},'_mice_',condition{1},'= nan(1,50);'))
        end
        for region = 1:50 
            eval(strcat(h{1},'_temp = mean(',h{1},'_mice_',condition{1},'_allRegions(:,:,region));'))
            eval(strcat('M = max(',h{1},'_temp);'))
            eval(strcat('[A_',h{1},'_mice_',condition{1},'(region),T_',h{1},'_mice_',condition{1},'(region),W_',h{1},'_mice_',condition{1},'(region)] = ',...
        'findpeaks(',h{1},'_temp,t,',char(39),'MinPeakHeight',char(39),',',num2str(M*0.9999),');'))
        end
        if exist(saveName,'file')
            eval(strcat('save(',char(39),saveName,char(39),',',...
                char(39),'T_',h{1},'_mice_',condition{1},char(39),',',...
                char(39),'W_',h{1},'_mice_',condition{1},char(39),',',...
                char(39),'A_',h{1},'_mice_',condition{1},char(39),',',...
                char(39),'-append',char(39),')'))
        else
            eval(strcat('save(',char(39),saveName,char(39),',',...
                char(39),'T_',h{1},'_mice_',condition{1},char(39),',',...
                char(39),'W_',h{1},'_mice_',condition{1},char(39),',',...
                char(39),'A_',h{1},'_mice_',condition{1},char(39),')'))
        end
    end
end
           
%% Maps with regional values
for condition = {'awake','anes'}
    for h = {'HRF','MRF'}        
       for var = {'T','W','A'}
           eval(strcat(var{1},'_',h{1},'_',condition{1},'_map =  zeros(1,128*128);'))
           for region = 1:50  
                mask_region = zeros(128,128);
                mask_region(mask == region) = 1;
                mask_region = logical(mask_region);
                eval(strcat(var{1},'_',h{1},'_',condition{1},'_map(mask_region(:))=',var{1},'_',h{1},'_mice_',condition{1},'(region);'))
           end
           eval(strcat(var{1},'_',h{1},'_',condition{1},'_map = reshape(',var{1},'_',h{1},'_',condition{1},'_map,128,128);'))           
       end
       if exist(saveName,'file')
            eval(strcat('save(',char(39),saveName,char(39),',',...
                char(39),'T_',h{1},'_',condition{1},'_map',char(39),',',...
                char(39),'W_',h{1},'_',condition{1},'_map',char(39),',',...
                char(39),'A_',h{1},'_',condition{1},'_map',char(39),',',...
                char(39),'-append',char(39),')'))
        else
            eval(strcat('save(',char(39),saveName,char(39),',',...
                char(39),'T_',h{1},'_',condition{1},'_map',char(39),',',...
                char(39),'W_',h{1},'_',condition{1},'_map',char(39),',',...
                char(39),'A_',h{1},'_',condition{1},'_map',char(39),')'))
        end
    end
end

for condition = {'awake','anes'}
    for h = {'HRF','MRF'}        
           eval(strcat('r_',h{1},'_',condition{1},'_map =  zeros(1,128*128);'))
           for region = 1:50  
                mask_region = zeros(128,128);
                mask_region(mask == region) = 1;
                mask_region = logical(mask_region);
                eval(strcat('r_',h{1},'_',condition{1},'_map(mask_region(:))=mean(r_',h{1},'_mice_',condition{1},'_allRegions(:,region));'))
           end
           eval(strcat('r_',h{1},'_',condition{1},'_map = reshape(r_',h{1},'_',condition{1},'_map,128,128);'))
           if exist(saveName,'file')
               eval(strcat('save(',char(39),saveName,char(39),',',...
                   char(39),'r_',h{1},'_',condition{1},'_map',char(39),',',...
                   char(39),'-append',char(39),')'))
           else
               eval(strcat('save(',char(39),saveName,char(39),',',...
                   char(39),'r_',h{1},'_',condition{1},'_map',char(39),')'))
           end
    end
end


%% Visualization
load("C:\Users\Xiaodan Wang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL.mat")
for condition = {'awake','anes'}
    for h = {'HRF','MRF'}
        figure('units','normalized','outerposition',[0 0 1 1])
        subplot(2,3,4)
        temp = strcat('imagesc(r_',h{1},'_',condition{1},'_map,',char(39),'AlphaData',char(39),',mask)');
        eval(temp)
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        cb=colorbar;
        clim([-1 1])
        axis image off
        colormap jet
        title('r')
        set(gca,'FontSize',14,'FontWeight','Bold')

        subplot(2,3,5)
        eval(strcat('plot_distribution_prctile(t,',h{1},'_mice_',condition{1},',',char(39),'Color',char(39),',[0 0 0])'))   
        title(h)
        xlabel('Time(s)')
        xlim([-3 10])
        set(gca,'FontSize',14,'FontWeight','Bold')

        subplot(2,3,1)
        eval(strcat('imagesc(T_',h{1},'_',condition{1},'_map,',char(39),'AlphaData',char(39),',mask)'));
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        cb=colorbar;
        
        if strcmp(h,'HRF')
            clim([0 2])
        else
            clim([0 0.1])
        end
        axis image off
        cmocean('ice')
        title('T(s)')
        set(gca,'FontSize',14,'FontWeight','Bold')

        subplot(2,3,2)
        temp = strcat('imagesc(W_',h{1},'_',condition{1},'_map,',char(39),'AlphaData',char(39),',mask)');
        eval(temp)
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        cb=colorbar;
        if strcmp(h,'HRF')
            clim([0 3])
        else
            clim([0 0.6])
        end
        axis image off
        cmocean('ice')
        title('W(s)')
        set(gca,'FontSize',14,'FontWeight','Bold')

        subplot(2,3,3)
        temp = strcat('imagesc(A_',h{1},'_',condition{1},'_map,',char(39),'AlphaData',char(39),',mask)');
        eval(temp) 
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        cb=colorbar;
        if strcmp(h,'HRF')
            clim([0 0.005])
        else
            clim([0 0.002])
        end
        axis image off
        cmocean('ice')
        title('A')
        set(gca,'FontSize',14,'FontWeight','Bold')
        sgtitle(strcat('Deconvolution',{' '},h,' for RGECO mice under',{' '},condition,' condition'))

    end
end

% %% Visualization
% % Visulize left regional masks
% figure('units','normalized','outerposition',[0 0 1 1])
% subplot(3,6,1)
% imagesc(mask_M2_L)
% axis image off
% title('M2 L')
% 
% subplot(3,6,2)
% imagesc(mask_M1_L)
% axis image off
% title('M1 L')
% 
% subplot(3,6,3)
% imagesc(mask_SS_L)
% axis image off
% title('SS L')
% 
% subplot(3,6,4)
% imagesc(mask_P_L)
% axis image off
% title('P L')
% 
% subplot(3,6,5)
% imagesc(mask_V1_L)
% axis image off
% title('V1 L')
% 
% subplot(3,6,6)
% imagesc(mask_V2_L)
% axis image off
% title('V2 L')
% 
% % HRF for left regions
% subplot(3,6,7)
% plot_distribution_prctile(t,HRF_M2_L_mice_awake,'Color',[1 0 0])
% hold on
% plot_distribution_prctile(t,HRF_M2_L_mice_anes,'Color',[0 0 1])
% title('HRF for M2 L')
% xlim([-3 5])
% ylim([-0.05 0.15])
% xlabel('Time(s)')
% grid on
% 
% subplot(3,6,8)
% plot_distribution_prctile(t,HRF_M1_L_mice_awake,'Color',[1 0 0])
% hold on
% plot_distribution_prctile(t,HRF_M1_L_mice_anes,'Color',[0 0 1])
% title('HRF for M1 L')
% xlim([-3 5])
% ylim([-0.05 0.15])
% xlabel('Time(s)')
% grid on
% 
% subplot(3,6,9)
% plot_distribution_prctile(t,HRF_SS_L_mice_awake,'Color',[1 0 0])
% hold on
% plot_distribution_prctile(t,HRF_SS_L_mice_anes,'Color',[0 0 1])
% title('HRF for SS L')
% xlim([-3 5])
% ylim([-0.05 0.15])
% xlabel('Time(s)')
% grid on
% 
% subplot(3,6,10)
% plot_distribution_prctile(t,HRF_P_L_mice_awake,'Color',[1 0 0])
% hold on
% plot_distribution_prctile(t,HRF_P_L_mice_anes,'Color',[0 0 1])
% title('HRF for P L')
% xlim([-3 5])
% ylim([-0.05 0.15])
% xlabel('Time(s)')
% grid on
% 
% subplot(3,6,11)
% plot_distribution_prctile(t,HRF_V1_L_mice_awake,'Color',[1 0 0])
% hold on
% plot_distribution_prctile(t,HRF_V1_L_mice_anes,'Color',[0 0 1])
% title('HRF for V1 L')
% xlim([-3 5])
% ylim([-0.05 0.15])
% xlabel('Time(s)')
% grid on
% 
% subplot(3,6,12)
% plot_distribution_prctile(t,HRF_V2_L_mice_awake,'Color',[1 0 0])
% hold on
% plot_distribution_prctile(t,HRF_V2_L_mice_anes,'Color',[0 0 1])
% title('HRF for V2 L')
% xlim([-3 5])
% ylim([-0.05 0.15])
% xlabel('Time(s)')
% grid on
% 
% % MRF for left regions
% subplot(3,6,13)
% plot_distribution_prctile(t,MRF_M2_L_mice_awake,'Color',[1 0 0])
% hold on
% plot_distribution_prctile(t,MRF_M2_L_mice_anes,'Color',[0 0 1])
% title('MRF for M2 L')
% xlim([-3 5])
% ylim([-0.03 0.04])
% xlabel('Time(s)')
% grid on
% 
% subplot(3,6,14)
% plot_distribution_prctile(t,MRF_M1_L_mice_awake,'Color',[1 0 0])
% hold on
% plot_distribution_prctile(t,MRF_M1_L_mice_anes,'Color',[0 0 1])
% title('MRF for M1 L')
% xlim([-3 5])
% ylim([-0.03 0.04])
% xlabel('Time(s)')
% grid on
% 
% subplot(3,6,15)
% plot_distribution_prctile(t,MRF_SS_L_mice_awake,'Color',[1 0 0])
% hold on
% plot_distribution_prctile(t,MRF_SS_L_mice_anes,'Color',[0 0 1])
% title('MRF for SS L')
% xlim([-3 5])
% ylim([-0.03 0.04])
% xlabel('Time(s)')
% grid on
% 
% subplot(3,6,16)
% plot_distribution_prctile(t,MRF_P_L_mice_awake,'Color',[1 0 0])
% hold on
% plot_distribution_prctile(t,MRF_P_L_mice_anes,'Color',[0 0 1])
% title('MRF for P L')
% xlim([-3 5])
% ylim([-0.03 0.04])
% xlabel('Time(s)')
% grid on
% 
% subplot(3,6,17)
% plot_distribution_prctile(t,MRF_V1_L_mice_awake,'Color',[1 0 0])
% hold on
% plot_distribution_prctile(t,MRF_V1_L_mice_anes,'Color',[0 0 1])
% title('MRF for V1 L')
% xlim([-3 5])
% ylim([-0.03 0.04])
% xlabel('Time(s)')
% grid on
% 
% subplot(3,6,18)
% plot_distribution_prctile(t,MRF_V2_L_mice_awake,'Color',[1 0 0])
% hold on
% plot_distribution_prctile(t,MRF_V2_L_mice_anes,'Color',[0 0 1])
% title('MRF for V2 L')
% xlim([-3 5])
% ylim([-0.03 0.04])
% xlabel('Time(s)')
% grid on
% sgtitle('Left Side Regional NVC and NMC. Red is Awake and Blue is Anesthetized')
% 
% % Visulize right regional masks
% figure('units','normalized','outerposition',[0 0 1 1])
% subplot(3,6,1)
% imagesc(mask_M2_R)
% axis image off
% title('M2 R')
% 
% subplot(3,6,2)
% imagesc(mask_M1_R)
% axis image off
% title('M1 R')
% 
% subplot(3,6,3)
% imagesc(mask_SS_R)
% axis image off
% title('SS R')
% 
% subplot(3,6,4)
% imagesc(mask_P_R)
% axis image off
% title('P R')
% 
% subplot(3,6,5)
% imagesc(mask_V1_R)
% axis image off
% title('V1 R')
% 
% subplot(3,6,6)
% imagesc(mask_V2_R)
% axis image off
% title('V2 R')
% 
% % HRF for right regions
% subplot(3,6,7)
% plot_distribution_prctile(t,HRF_M2_R_mice_awake,'Color',[1 0 0])
% hold on
% plot_distribution_prctile(t,HRF_M2_R_mice_anes,'Color',[0 0 1])
% title('HRF for M2 R')
% xlim([-3 5])
% ylim([-0.05 0.15])
% xlabel('Time(s)')
% grid on
% 
% subplot(3,6,8)
% plot_distribution_prctile(t,HRF_M1_R_mice_awake,'Color',[1 0 0])
% hold on
% plot_distribution_prctile(t,HRF_M1_R_mice_anes,'Color',[0 0 1])
% title('HRF for M1 R')
% xlim([-3 5])
% ylim([-0.05 0.15])
% xlabel('Time(s)')
% grid on
% 
% subplot(3,6,9)
% plot_distribution_prctile(t,HRF_SS_R_mice_awake,'Color',[1 0 0])
% hold on
% plot_distribution_prctile(t,HRF_SS_R_mice_anes,'Color',[0 0 1])
% title('HRF for SS R')
% xlim([-3 5])
% ylim([-0.05 0.15])
% xlabel('Time(s)')
% grid on
% 
% subplot(3,6,10)
% plot_distribution_prctile(t,HRF_P_R_mice_awake,'Color',[1 0 0])
% hold on
% plot_distribution_prctile(t,HRF_P_R_mice_anes,'Color',[0 0 1])
% title('HRF for P R')
% xlim([-3 5])
% ylim([-0.05 0.15])
% xlabel('Time(s)')
% grid on
% 
% subplot(3,6,11)
% plot_distribution_prctile(t,HRF_V1_R_mice_awake,'Color',[1 0 0])
% hold on
% plot_distribution_prctile(t,HRF_V1_R_mice_anes,'Color',[0 0 1])
% title('HRF for V1 R')
% xlim([-3 5])
% ylim([-0.05 0.15])
% xlabel('Time(s)')
% grid on
% 
% subplot(3,6,12)
% plot_distribution_prctile(t,HRF_V2_R_mice_awake,'Color',[1 0 0])
% hold on
% plot_distribution_prctile(t,HRF_V2_R_mice_anes,'Color',[0 0 1])
% title('HRF for V2 R')
% xlim([-3 5])
% ylim([-0.05 0.15])
% xlabel('Time(s)')
% grid on
% 
% % MRF for right regions
% subplot(3,6,13)
% plot_distribution_prctile(t,MRF_M2_R_mice_awake,'Color',[1 0 0])
% hold on
% plot_distribution_prctile(t,MRF_M2_R_mice_anes,'Color',[0 0 1])
% title('MRF for M2 R')
% xlim([-3 5])
% ylim([-0.03 0.04])
% xlabel('Time(s)')
% grid on
% 
% subplot(3,6,14)
% plot_distribution_prctile(t,MRF_M1_R_mice_awake,'Color',[1 0 0])
% hold on
% plot_distribution_prctile(t,MRF_M1_R_mice_anes,'Color',[0 0 1])
% title('MRF for M1 R')
% xlim([-3 5])
% ylim([-0.03 0.04])
% xlabel('Time(s)')
% grid on
% 
% subplot(3,6,15)
% plot_distribution_prctile(t,MRF_SS_R_mice_awake,'Color',[1 0 0])
% hold on
% plot_distribution_prctile(t,MRF_SS_R_mice_anes,'Color',[0 0 1])
% title('MRF for SS R')
% xlim([-3 5])
% ylim([-0.03 0.04])
% xlabel('Time(s)')
% grid on
% 
% subplot(3,6,16)
% plot_distribution_prctile(t,MRF_P_R_mice_awake,'Color',[1 0 0])
% hold on
% plot_distribution_prctile(t,MRF_P_R_mice_anes,'Color',[0 0 1])
% title('MRF for P R')
% xlim([-3 5])
% ylim([-0.03 0.04])
% xlabel('Time(s)')
% grid on
% 
% subplot(3,6,17)
% plot_distribution_prctile(t,MRF_V1_R_mice_awake,'Color',[1 0 0])
% hold on
% plot_distribution_prctile(t,MRF_V1_R_mice_anes,'Color',[0 0 1])
% title('MRF for V1 R')
% xlim([-3 5])
% ylim([-0.03 0.04])
% xlabel('Time(s)')
% grid on
% 
% subplot(3,6,18)
% plot_distribution_prctile(t,MRF_V2_R_mice_awake,'Color',[1 0 0])
% hold on
% plot_distribution_prctile(t,MRF_V2_R_mice_anes,'Color',[0 0 1])
% title('MRF for V2 R')
% xlim([-3 5])
% ylim([-0.03 0.04])
% xlabel('Time(s)')
% grid on
% sgtitle('Right Side Regional NVC and NMC. Red is Awake and Blue is Anesthetized')
