clear ;close all;clc
excelFile = "X:\RGECO\DataBase_Xiaodan_3.xlsx";
freq_new     = 250;
t_kernel = 30;
t = (-3*freq_new:(t_kernel-3)*freq_new-1)/freq_new ;
load("C:\Users\Xiaodan Wang\Documents\GitHub\BauerLabXiaodanScripts\noVasculatureMask.mat",'mask_new')
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
             eval(strcat('T_',  h{1},'_',region{1},'_mice_',condition{1},'=[];'))
             eval(strcat('W_',  h{1},'_',region{1},'_mice_',condition{1},'=[];'))
             eval(strcat('A_',  h{1},'_',region{1},'_mice_',condition{1},'=[];'))
             eval(strcat('r2_', h{1},'_',region{1},'_mice_',condition{1},'=[];'))
             eval(strcat('obj_',h{1},'_',region{1},'_mice_',condition{1},'=[];'))

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
                    for var = {'T','W','A','r','r2','obj'}
                        % Load
                        eval(strcat('load(fullfile(saveDir,','Gamma_',h{1},'_Regions',',', recDate,'-',mouseName,'-',sessionType,num2str(n),'Gamma_',h{1},'_Regions.mat',...
                            char(39),var{1},'_',h{1},'_',region{1},char(39),')'))
                        % concatenate
                        eval(strcat(var{1},'_',h{1},'_',region{1},'_mice_',condition{1},'= cat(2,',...
                            var{1},'_',h{1},'_',region{1},'_mice_',condition{1},',',var{1},'_',h{1},'_',region{1},');'))
                    end
                end
            end
        end
    end
end

% Median
for condition = {'awake','anes'}
    for h = {'NVC','NMC'}
        for region = {'M2_L','M1_L','SS_L','P_L','V1_L','V2_L','M2_R','M1_R','SS_R','P_R','V1_R','V2_R'}
            for var = {'T','W','A','r','r2','obj'}
                eval(strcat(var{1},'_',h{1},'_',region{1},'_mice_',condition{1},'_median = median(',...
                    var{1},'_',h{1},'_',region{1},'_mice_',condition{1},');'))
            end
        end
    end
end

%% Calculate Gamma for the whole brain
% total number of pixels in all interested regions
pixTotal = 0;
for region = {'M2_L','M1_L','SS_L','P_L','V1_L','V2_L','M2_R','M1_R','SS_R','P_R','V1_R','V2_R'}
    eval('pixNum_',region{1},'sum(mask_',region,',',char(39),'all',char(39),');');
    eval(strcat('pixTotal = pixTotal+pixNum_',region{1},';'))
end
% pixel number in each region
for condition = {'awake','anes'}
   for h = {'NVC','NMC'} 
       for var = {'T','W','A'}
           % initialization
           eval(strcat(var{1},'_',h{1}),condition{1},'=0;')
           for region = {'M2_L','M1_L','SS_L','P_L','V1_L','V2_L','M2_R','M1_R','SS_R','P_R','V1_R','V2_R'}
               eval(strcat(var{1},'_',h{1}),condition{1},
           end
       end
   end
end

for condition = {'awake','anes'}
   for h = {'HRF','MRF'} 
       temp = strcat(h,'_',condition,'= [];');
       eval(temp{1})
       for region = {'M2_L','M1_L','SS_L','P_L','V1_L','V2_L','M2_R','M1_R','SS_R','P_R','V1_R','V2_R'}
           temp = strcat('pixNum = sum(mask_',region,',',char(39),'all',char(39),');');
           eval(temp{1})
           for ii = 1: pixNum
               temp = strcat(h,'_',condition,'= cat(1,',h,'_',condition,',',h,'_',region,'_mice_',condition,'_median);');
               eval(temp{1})
           end
       end
%        temp = strcat(h,'_',condition,'= median(',h,'_',condition,');');
%        eval(temp{1})
   end
end
HRF_awake_median = median(HRF_awake);
HRF_anes_median  = median(HRF_anes);

MRF_awake_median = median(MRF_awake);
MRF_anes_median  = median(MRF_anes);
save("D:\XiaodanPaperData\cat\deconvolution.mat",'HRF_awake','HRF_anes','MRF_awake','MRF_anes',...
    'HRF_awake_median','HRF_anes_median','MRF_awake_median','MRF_anes_median')

[A_HRF_awake,T_HRF_awake,W_HRF_awake] = findpeaks(HRF_awake_median,t,'MinPeakProminence',0.06);
[A_HRF_anes, T_HRF_anes, W_HRF_anes]  = findpeaks(HRF_anes_median ,t,'MinPeakProminence',0.015);
[A_MRF_awake,T_MRF_awake,W_MRF_awake] = findpeaks(MRF_awake_median,t,'MinPeakProminence',0.015);
[A_MRF_anes, T_MRF_anes, W_MRF_anes]  = findpeaks(MRF_anes_median ,t,'MinPeakProminence',0.01);

  eval(strcat('[A_HRF_',region{1},'_mice_anes,T_HRF_',region{1},'_mice_anes,W_HRF_',region{1},'_mice_anes] = ',...
        'findpeaks(HRF_',region{1},'_mice_anes_median,t,',char(39),'MinPeakProminence',char(39),',',num2str(0.01),');'))


%% Visualization
load("C:\Users\Xiaodan Wang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL.mat")
mask = 0;
for region = {'M2_L','M1_L','SS_L','P_L','V1_L','V2_L','M2_R','M1_R','SS_R','P_R','V1_R','V2_R'}
    temp = strcat('mask = mask + mask_',region,';');
    eval(temp{1})
end
for condition = {'awake','anes'}
    for h = {'HRF','MRF'}
        figure('units','normalized','outerposition',[0 0 1 1])
        subplot(2,3,4)
        temp = strcat('imagesc(r_',h{1},'_mice_',condition{1},',',char(39),'AlphaData',char(39),',mask)');
        eval(temp)
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        cb=colorbar;
        caxis([-1 1])
        axis image off
        colormap jet
        title('r')
        set(gca,'FontSize',14,'FontWeight','Bold')

        subplot(2,3,5)
        temp = strcat('plot_distribution_prctile(t,',h,'_',condition,',',char(39),'Color',char(39),',[0 0 0])');
        eval(temp{1})
        title(h)
        xlabel('Time(s)')
        xlim([-3 10])
        set(gca,'FontSize',14,'FontWeight','Bold')

        subplot(2,3,1)
        temp = strcat('imagesc(T_',h{1},'_mice_',condition{1},',',char(39),'AlphaData',char(39),',mask)');
        eval(temp)
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        cb=colorbar;
        
        if strcmp(h,'HRF')
            caxis([0 2])
        else
            caxis([0 0.1])
        end
        axis image off
        cmocean('ice')
        title('T(s)')
        set(gca,'FontSize',14,'FontWeight','Bold')

        subplot(2,3,2)
        temp = strcat('imagesc(W_',h{1},'_mice_',condition{1},',',char(39),'AlphaData',char(39),',mask)');
        eval(temp)
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        cb=colorbar;
        if strcmp(h,'HRF')
            caxis([0 3])
        else
            caxis([0 0.6])
        end
        axis image off
        cmocean('ice')
        title('W(s)')
        set(gca,'FontSize',14,'FontWeight','Bold')

        subplot(2,3,3)
        temp = strcat('imagesc(A_',h{1},'_mice_',condition{1},',',char(39),'AlphaData',char(39),',mask)');
        eval(temp) 
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        cb=colorbar;
        if strcmp(h,'HRF')
            caxis([0 0.1])
        else
            caxis([0 0.05])
        end
        axis image off
        cmocean('ice')
        title('A')
        set(gca,'FontSize',14,'FontWeight','Bold')
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumFAD_GammaFit_1min_smooth_Rolling_interp.png')));
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumFAD_GammaFit_1min_smooth_Rolling_interp.fig')));

        sgtitle(strcat(h,' for RGECO mice under',{' '},condition,' condition'))

    end
end

       