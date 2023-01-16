clear ;close all;clc
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
freq_new = 250;
t_kernel = 30;
t = (0:t_kernel*freq_new-1)/freq_new ;
load("noVasculatureMask.mat",'mask_new')
load('AtlasandIsbrain.mat','AtlasSeedsFilled')
AtlasSeedsFilled(AtlasSeedsFilled==0) = nan;
AtlasSeedsFilled(:,65:128) = AtlasSeedsFilled(:,65:128)+20;

% Mask for different regions
mask_M2_L = AtlasSeedsFilled==4;
mask_M1_L = AtlasSeedsFilled==5;
mask_SS_L = AtlasSeedsFilled==6 | AtlasSeedsFilled==7 | AtlasSeedsFilled==8 | AtlasSeedsFilled==9 | AtlasSeedsFilled==10 | AtlasSeedsFilled==11;
mask_P_L  = AtlasSeedsFilled==13 | AtlasSeedsFilled==14 | AtlasSeedsFilled==15;
mask_V1_L = AtlasSeedsFilled==17;
mask_V2_L = AtlasSeedsFilled==16|AtlasSeedsFilled==18;

mask_M2_R = AtlasSeedsFilled==24;
mask_M1_R = AtlasSeedsFilled==25;
mask_SS_R = AtlasSeedsFilled==26 | AtlasSeedsFilled==27 | AtlasSeedsFilled==28 | AtlasSeedsFilled==29 | AtlasSeedsFilled==30 | AtlasSeedsFilled==31;
mask_P_R  = AtlasSeedsFilled==33 | AtlasSeedsFilled==34 | AtlasSeedsFilled==35;
mask_V1_R = AtlasSeedsFilled==37;
mask_V2_R = AtlasSeedsFilled==36|AtlasSeedsFilled==38;

% Get shared xform_isbrain
xform_isbrain_mice_awake = 1;
for excelRow = [181 183 185 228 232 236 202 195 204 230 234 240]
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    disp(strcat(mouseName,', run #1'))
    processedName = strcat(recDate,'-',mouseName,'-',sessionType,'1_processed','.mat');
    load(fullfile(saveDir,processedName),'xform_isbrain')
    xform_isbrain_mice_awake = xform_isbrain_mice_awake.*xform_isbrain;
end

% Regional mask needs to be inside of xform_isbrain_mice_awake
mask_M2_L = logical(mask_M2_L.*mask_new.*xform_isbrain_mice_awake);
mask_M1_L = logical(mask_M1_L.*mask_new.*xform_isbrain_mice_awake);
mask_SS_L = logical(mask_SS_L.*mask_new.*xform_isbrain_mice_awake);
mask_P_L  = logical(mask_P_L .*mask_new.*xform_isbrain_mice_awake);
mask_V1_L = logical(mask_V1_L.*mask_new.*xform_isbrain_mice_awake);
mask_V2_L = logical(mask_V2_L.*mask_new.*xform_isbrain_mice_awake);

mask_M2_R = logical(mask_M2_R.*mask_new.*xform_isbrain_mice_awake);
mask_M1_R = logical(mask_M1_R.*mask_new.*xform_isbrain_mice_awake);
mask_SS_R = logical(mask_SS_R.*mask_new.*xform_isbrain_mice_awake);
mask_P_R  = logical(mask_P_R .*mask_new.*xform_isbrain_mice_awake);
mask_V1_R = logical(mask_V1_R.*mask_new.*xform_isbrain_mice_awake);
mask_V2_R = logical(mask_V2_R.*mask_new.*xform_isbrain_mice_awake);

% Average Gamma Parameters for each region
% Initialization
for condition = {'awake','anes'}
    for h = {'NVC','NMC'}
        for region = {'M2_L','M1_L','SS_L','P_L','V1_L','V2_L','M2_R','M1_R','SS_R','P_R','V1_R','V2_R'}
             eval(strcat('lagAmp_' ,  h{1},'_',region{1},'_mice_',condition{1},'=[];'))
             eval(strcat('lagTime_',  h{1},'_',region{1},'_mice_',condition{1},'=[];'))
             eval(strcat('lagWid_' ,  h{1},'_',region{1},'_mice_',condition{1},'=[];'))
             eval(strcat('crossLagY_',h{1},'_',region{1},'_mice_',condition{1},'=[];'))
        end
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
                for region = {'M2_L','M1_L','SS_L','P_L','V1_L','V2_L','M2_R','M1_R','SS_R','P_R','V1_R','V2_R'}
                    for var = {'lagAmp','lagTime','lagWid'}
                        % Load
                        eval(strcat('load(fullfile(saveDir,',char(39),'CrossLag_',h{1},'_Regions_Upsample',char(39),',',char(39), recDate,'-',mouseName,'-',sessionType,num2str(n),'_CrossLag_',h{1},'_Regions_Upsample.mat',char(39),'),',...
                            char(39),var{1},'_',h{1},'_',region{1},char(39),')'))
                        % concatenate
                        eval(strcat(var{1},'_',h{1},'_',region{1},'_mice_',condition{1},'= cat(2,',...
                            var{1},'_',h{1},'_',region{1},'_mice_',condition{1},',',var{1},'_',h{1},'_',region{1},');'))
                    end
                    % Load crossLagY
                    eval(strcat('load(fullfile(saveDir,',char(39),'CrossLag_',h{1},'_Regions_Upsample',char(39),',',char(39), recDate,'-',mouseName,'-',sessionType,num2str(n),'_CrossLag_',h{1},'_Regions_Upsample.mat',char(39),'),',...
                        char(39),'crossLagY_',h{1},'_',region{1},char(39),')'))
                    % Concatenate crossLagY
                    eval(strcat('crossLagY_',h{1},'_',region{1},'_mice_',condition{1},'= cat(1,',...
                        'crossLagY_',h{1},'_',region{1},'_mice_',condition{1},',','crossLagY_',h{1},'_',region{1},');'))
                end
            end
        end
    end
end

% Median
for condition = {'awake','anes'}
    for h = {'NVC','NMC'}
        for region = {'M2_L','M1_L','SS_L','P_L','V1_L','V2_L','M2_R','M1_R','SS_R','P_R','V1_R','V2_R'}
            for var = {'lagAmp','lagTime','lagWid','crossLagY'}
                eval(strcat(var{1},'_',h{1},'_',region{1},'_mice_',condition{1},'_median = nanmedian(',...
                    var{1},'_',h{1},'_',region{1},'_mice_',condition{1},');'))
            end
        end
    end
end

% Maps with regional values
for condition = {'awake','anes'}
    for h = {'NVC','NMC'}        
       for var = {'lagAmp','lagTime','lagWid'}
           eval(strcat(var{1},'_',h{1},'_',condition{1},'_map =  zeros(1,128*128);'))
           for region = {'M2_L','M1_L','SS_L','P_L','V1_L','V2_L','M2_R','M1_R','SS_R','P_R','V1_R','V2_R'}                
                eval(strcat(var{1},'_',h{1},'_',condition{1},'_map(mask_',region{1},'(:))=',var{1},'_',h{1},'_',region{1},'_mice_',condition{1},'_median;'))
           end
           eval(strcat(var{1},'_',h{1},'_',condition{1},'_map = reshape(',var{1},'_',h{1},'_',condition{1},'_map,128,128);'))
        end
    end
end

%% Calculate Gamma for the whole brain

% total number of pixels in all interested regions
for region = {'M2_L','M1_L','SS_L','P_L','V1_L','V2_L','M2_R','M1_R','SS_R','P_R','V1_R','V2_R'}
    eval(strcat('pixNum_',region{1},' = sum(mask_',region{1},',',char(39),'all',char(39),');'));
end

%% pixel number in each region
for condition = {'awake','anes'}
    for h = {'NVC','NMC'}
        % initialization
        disp([condition,h])
        eval(strcat('crossLagY_',h{1},'_',condition{1},'=[];'))
        for region = {'M2_L','M1_L','SS_L','P_L','V1_L','V2_L','M2_R','M1_R','SS_R','P_R','V1_R','V2_R'}
            disp(region)
            % Repeat crossLagY based on the number of pixels inside of
            % reigonal mask.
            eval(strcat('temp = repmat(crossLagY_',h{1},'_',region{1},'_mice_',condition{1},'_median,','pixNum_',region{1},',1);'))
            % Concatenate
            eval(strcat('crossLagY_',h{1},'_',condition{1},'= cat(1,','crossLagY_',h{1},'_',condition{1},',temp);'))            
        end
        eval(strcat('crossLagY_',h{1},'_',condition{1},'_median = nanmedian(crossLagY_',h{1},'_',condition{1},');'))
        saveName = "L:\RGECO\cat\CrossLag_regions_upsample.mat";
        if exist(saveName,'file')
            eval(strcat('save(',char(39),saveName,char(39),',',...
                char(39),'lagAmp_'   ,h{1},'_',condition{1},'_map',char(39),',',...
                char(39),'lagTime_'  ,h{1},'_',condition{1},'_map',char(39),',',...
                char(39),'lagWid_'   ,h{1},'_',condition{1},'_map',char(39),',',...
                char(39),'crossLagY_',h{1},'_',condition{1},'_median',char(39),',',...
                char(39),'crossLagY_',h{1},'_',condition{1},char(39),',',...
                char(39),'-append',char(39),')'))
        else
            eval(strcat('save(',char(39),saveName,char(39),',',...
                char(39),'lagAmp_'   ,h{1},'_',condition{1},'_map',char(39),',',...
                char(39),'lagTime_'  ,h{1},'_',condition{1},'_map',char(39),',',...
                char(39),'lagWid_'   ,h{1},'_',condition{1},'_map',char(39),',',...
                char(39),'crossLagY_',h{1},'_',condition{1},'_median',char(39),',',...
                char(39),'crossLagY_',h{1},'_',condition{1},char(39),')'))
        end        
    end
end

%% Visualization
load("GoodWL.mat")
mask = 0;
for region = {'M2_L','M1_L','SS_L','P_L','V1_L','V2_L','M2_R','M1_R','SS_R','P_R','V1_R','V2_R'}
    temp = strcat('mask = mask + mask_',region,';');
    eval(temp{1})
end
load(fullfile(saveDir,'CrossLag_NVC_Regions_Upsample',strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CrossLag_NVC_Regions_Upsample.mat')),'crossLagX_NVC_M1_L')
for condition = {'awake','anes'}
    for h = {'NVC','NMC'}
        figure('units','normalized','outerposition',[0 0 1 1])
        subplot(2,2,3)
        temp = strcat('imagesc(lagAmp_',h{1},'_',condition{1},'_map,',char(39),'AlphaData',char(39),',mask)');
        eval(temp)
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        cb=colorbar;
        caxis([-1 1])
        axis image off
        colormap jet
        title('r')
        set(gca,'FontSize',14,'FontWeight','Bold')

        subplot(2,2,4)
        eval(strcat('plot_distribution_prctile(crossLagX_NVC_M1_L(1,:),crossLagY_',h{1},'_',condition{1},',',char(39),'Color',char(39),',[0 0 0])'))   
        title(h)
        xlabel('Time(s)')
        xlim([0 4])
        set(gca,'FontSize',14,'FontWeight','Bold')

        subplot(2,2,1)
        eval(strcat('imagesc(lagTime_',h{1},'_',condition{1},'_map,',char(39),'AlphaData',char(39),',mask)'));
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        cb=colorbar;
        
        if strcmp(h,'NVC')
            caxis([0 2])
        else
            caxis([0 0.1])
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
            caxis([0 3])
        else
            caxis([0 0.6])
        end
        axis image off
        cmocean('ice')
        title('W(s)')
        set(gca,'FontSize',14,'FontWeight','Bold')

        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumFAD_GammaFit_1min_smooth_Rolling_interp.png')));
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumFAD_GammaFit_1min_smooth_Rolling_interp.fig')));

        sgtitle(strcat('Gamma',{' '},h,' for RGECO mice under',{' '},condition,' condition'))

    end
end

       