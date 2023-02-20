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

% Average Gamma Parameters for each region
% Initialization
for condition = {'awake','anes'}
    for h = {'NVC','NMC'}
             eval(strcat('T_' , h{1},'_mice_',condition{1},'=[];'))
             eval(strcat('W_',  h{1},'_mice_',condition{1},'=[];'))
             eval(strcat('A_' , h{1},'_mice_',condition{1},'=[];'))
             eval(strcat('r_',  h{1},'_mice_',condition{1},'=[];'))
             eval(strcat('r2_', h{1},'_mice_',condition{1},'=[];'))
             eval(strcat('obj_',h{1},'_mice_',condition{1},'=[];'))
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
                for var = {'T','W','A','r','r2','obj'}
                % Load
                eval(strcat('load(fullfile(saveDir,',char(39),'Gamma_',h{1},char(39),',',char(39), recDate,'-',mouseName,'-',sessionType,num2str(n),'_Gamma_',h{1},'.mat',char(39),'),',...
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
saveName = "E:\RGECO\cat\Gamma_allRegions.mat";
for condition = {'awake','anes'}
    for h = {'NVC','NMC'}         
       for var = {'T','W','A','r','r2','obj'}
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

% total number of pixels in all interested regions
pixelNum = zeros(1,50);
for region = 1:50
    mask_region = zeros(128,128);
    mask_region(mask == region) = 1;
    pixelNum(region) = sum(mask_region,'all');
end
pixelNumTotal = sum(pixelNum);

%% Generate gamma function
for h = {'NVC','NMC'}
    for condition = {'awake','anes'}
        eval(strcat('y_',h{1},'_mice_',condition{1},'_allRegions = nan(6,7500,50);'))
        mouseInd = 1;
        for excelRow = eval(strcat('excelRows_',condition{1}))
             [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
            recDate = excelRaw{1}; recDate = string(recDate);
            mouseName = excelRaw{2}; mouseName = string(mouseName);
            saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
            sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
            % initialization
            disp([condition,h])
            eval(strcat('y_',h{1},'_mouse_',condition{1},'_allRegions=[];'))
            % Load
            for n = 1:3
                eval(strcat('load(fullfile(saveDir,',char(39),'Gamma_',h{1},char(39),',',char(39), recDate,'-',mouseName,'-',sessionType,num2str(n),'_Gamma_',h{1},'.mat',char(39),'),',...
                    char(39),'T_',h{1},char(39),',', char(39),'W_',h{1},char(39),',', char(39),'A_',h{1},char(39),')'))
                y = nan(19,7500,50);
                for ii = 1:19
                    for region = 1:50
                        eval(strcat('alpha = (T_',h{1},'(ii,region)/W_',h{1},'(ii,region))^2*8*log(2);'))
                        eval(strcat('beta = W_',h{1},'(ii,region)^2/(T_',h{1},'(ii,region)*8*log(2));'))
                        eval(strcat('temp = A_',h{1},'(ii,region)*(t/T_',h{1},'(ii,region)).^alpha.*exp((t-T_',h{1},'(ii,region))/(-beta));'));
                        temp(isnan(temp)) = 0 ;
                        y(ii,:,region) = temp;
                    end
                    % Concatenate
                end            
                eval(strcat('y_',h{1},'_mouse_',condition{1},'_allRegions = cat(1,','y_',h{1},'_mouse_',condition{1},'_allRegions,y);'))
            end
            eval(strcat('y_',h{1},'_mouse_',condition{1},'_allRegions = mean(y_',h{1},'_mouse_',condition{1},'_allRegions);'))
            eval(strcat('y_',h{1},'_mice_', condition{1},'_allRegions(mouseInd,:,:)= y_',h{1},'_mouse_',condition{1},'_allRegions;'))
            mouseInd = mouseInd+1;
        end
    end
end
%% Average across all regions
for condition = {'awake','anes'}
    for h = {'NVC','NMC'}
         eval(strcat('y_',h{1},'_mice_',condition{1},' = zeros(6,7500);'))
        for mouseInd = 1:6
            for region = 1:50
                eval(strcat('temp = squeeze(y_',h{1},'_mice_',condition{1},'_allRegions(mouseInd,:,region))*pixelNum(region)/pixelNumTotal;'))
                eval(strcat('y_',h{1},'_mice_',condition{1},'(mouseInd,:) = y_',h{1},'_mice_',condition{1},'(mouseInd,:)+temp;'))
                clear temp
            end
        end
        if exist(saveName,'file')
            eval(strcat('save(',char(39),saveName,char(39),',',...
                char(39),'y_',h{1},'_mice_',condition{1},char(39),',',...
                char(39),'-append',char(39),')'))
        else
            eval(strcat('save(',char(39),saveName,char(39),',',...
                char(39),'y_',h{1},'_mice_',condition{1},char(39),')'))
        end
    end
end
%% Visualization
load("GoodWL.mat")
mask(isnan(mask)) = 0;
for condition = {'awake','anes'}
    for h = {'NVC','NMC'}
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
        eval(strcat('plot_distribution_prctile(t,y_',h{1},'_mice_',condition{1},',',char(39),'Color',char(39),',[0 0 0])'))   
        title(h)
        xlabel('Time(s)')
        xlim([-3 10])
        set(gca,'FontSize',14,'FontWeight','Bold')
        if strcmp(h,'NVC')
            ylim([0 0.003])
        else
            clim([0 0.0045])
        end

        subplot(2,3,1)
        eval(strcat('imagesc(T_',h{1},'_',condition{1},'_map,',char(39),'AlphaData',char(39),',mask)'));
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        cb=colorbar;
        
        if strcmp(h,'NVC')
            clim([0 2])
        else
            clim([0 0.01])
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
        if strcmp(h,'NVC')
            clim([0 3])
        else
            clim([0 0.1])
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
      
        clim([0 0.005])

        axis image off
        cmocean('ice')
        title('A')
        set(gca,'FontSize',14,'FontWeight','Bold')
        sgtitle(strcat('Deconvolution',{' '},h,' for RGECO mice under',{' '},condition,' condition'))

    end
end

       