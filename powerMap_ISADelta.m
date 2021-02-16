% % for ii = 1:9
% %     
% %     saveDir_cat = 'K:\Glucose\cat\';
% %     load(strcat('K:\Glucose\cat\200313--R9M3-R9M2911-R9M2912-R8M2-R8M2498-R9M2-R8M3-fc',num2str(ii),'.mat'),'R_total_ISA_mice','R_jrgeco1aCorr_ISA_mice','R_FADCorr_ISA_mice',...
% %         'R_total_Delta_mice','R_jrgeco1aCorr_Delta_mice','R_FADCorr_Delta_mice',...
% %         'Rs_total_ISA_mice','Rs_jrgeco1aCorr_ISA_mice','Rs_FADCorr_ISA_mice',...
% %         'Rs_total_Delta_mice','Rs_jrgeco1aCorr_Delta_mice','Rs_FADCorr_Delta_mice','xform_isbrain_mice')
% %    visName = strcat('Glucose_SeedFC-fc',num2str(ii));
% %   refseeds=GetReferenceSeeds;
% %                 refseeds = refseeds(1:14,:);
% %                 refseeds(3,1) = 42;
% %                 refseeds(3,2) = 88;
% %                 refseeds(4,1) = 87;
% %                 refseeds(4,2) = 88;
% %                 refseeds(9,1) = 18;
% %                 refseeds(9,2) = 66;
% %                 refseeds(10,1) = 111;
% %                 refseeds(10,2) = 66;
% %         
% %       QCcheck_fcVis(refseeds,R_jrgeco1aCorr_ISA_mice, Rs_jrgeco1aCorr_ISA_mice(1:14,1:14),'jrgeco1aCorr','m','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
% %         QCcheck_fcVis(refseeds,R_FADCorr_ISA_mice, Rs_FADCorr_ISA_mice(1:14,1:14),'FADCorr','g','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
% %         QCcheck_fcVis(refseeds,R_total_ISA_mice, Rs_total_ISA_mice(1:14,1:14),'total','k','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
% %         
% %         QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_mice, Rs_jrgeco1aCorr_Delta_mice(1:14,1:14),'jrgeco1aCorr','m','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
% %         QCcheck_fcVis(refseeds,R_FADCorr_Delta_mice, Rs_FADCorr_Delta_mice(1:14,1:14),'FADCorr','g','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
% %         QCcheck_fcVis(refseeds,R_total_Delta_mice, Rs_total_Delta_mice(1:14,1:14),'total','k','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
% % 
% % end
% 
% 
% 
% 
% % for ii = 1:9
% %     load(strcat('K:\Glucose\cat\200313--R9M3-R9M2911-R9M2912-R8M2-R8M2498-R9M2-R8M3-fc',num2str(ii),'.mat'),'total_Delta_powerMap_mice','total_ISA_powerMap_mice',...
% %         'FADCorr_Delta_powerMap_mice','FADCorr_ISA_powerMap_mice', 'jrgeco1aCorr_Delta_powerMap_mice','jrgeco1aCorr_ISA_powerMap_mice','xform_isbrain_mice')
% %    
% %   figure('units','normalized','outerposition',[0 0 0.5 0.7]);
% %     subplot(2,3,1)
% %     powerMapVis(jrgeco1aCorr_ISA_powerMap_mice,'(\DeltaF/F%)',-20,0)
% %     title('Corr jRGECO1a')
% %     
% %     subplot(2,3,2)
% %     
% %     
% %     powerMapVis(FADCorr_ISA_powerMap_mice,'(\DeltaF/F%)',-20,0)
% %      title('Corr FAD')
% %     
% %     subplot(2,3,3)
% %     
% %     powerMapVis(total_ISA_powerMap_mice,'(\muM)',-20,0)
% %     
% %     title('Total')
% %     
% %     subplot(2,3,4)
% %      powerMapVis(jrgeco1aCorr_Delta_powerMap_mice,'(\DeltaF/F%)',-20,0)
% %     
% %     
% %     subplot(2,3,5)
% %     
% %     powerMapVis(FADCorr_Delta_powerMap_mice,'(\DeltaF/F%)',-20,0)
% %     
% %     
% %     subplot(2,3,6)
% %      powerMapVis(total_Delta_powerMap_mice,'(\muM)',-20,0)
% %      
% %      suptitle(strcat('Glucose Power Map',num2str(ii)))
% %      
% %      saveas(gcf,strcat('K:\Glucose\cat\Glucose_PowerMap-fc',num2str(ii),'.png'));
% %      saveas(gcf,strcat('K:\Glucose\cat\Glucose_PowerMap-fc',num2str(ii),'fig'));
% % end
% % 
% % % 
% set(0,'DefaultFigureRenderer','painters')
% % processedName_mice = '191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc.mat';
% % miceName = 'R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake';
% 
processedName_mice = '191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc.mat';
miceName = 'R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes';
saveDir_cat = 'L:\RGECO\cat';

% saveDir_cat = 'D:\RGECO\cat';
% load(fullfile(saveDir_cat, processedName_mice),'total_Delta_powerMap_GSR_mice','total_ISA_powerMap_GSR_mice',...
%         'FADCorr_Delta_powerMap_GSR_mice','FADCorr_ISA_powerMap_GSR_mice', 'jrgeco1aCorr_Delta_powerMap_GSR_mice','jrgeco1aCorr_ISA_powerMap_GSR_mice','xform_isbrain_mice')
%    
% %   figure('units','normalized','outerposition',[0 0 0.5 0.7]);
% %     subplot(2,3,1)
%     powerMapVis(jrgeco1aCorr_ISA_powerMap_GSR_mice,'(\DeltaF/F%)',-10,0)
%     title('Corr jRGECO1a ISA')
%     
%     %subplot(2,3,2)
%     
%     
%     powerMapVis(FADCorr_ISA_powerMap_GSR_mice,'(\DeltaF/F%)',-10,0)
%      title('Corr FAD ISA')
%     
%    % subplot(2,3,3)
%     
%     powerMapVis(total_ISA_powerMap_GSR_mice,'(\muM)',-10,0)
%     
%     title('Total ISA')
%     
%    % subplot(2,3,4)
%      powerMapVis(jrgeco1aCorr_Delta_powerMap_GSR_mice,'(\DeltaF/F%)',-10,0)
%     title('Corr jRGECO1a Delta')
%     
%    % subplot(2,3,5)
%     
%     powerMapVis(FADCorr_Delta_powerMap_GSR_mice,'(\DeltaF/F%)',-10,0)
%      title('Corr FAD Delta')
%     
%     %subplot(2,3,6)
%      powerMapVis(total_Delta_powerMap_GSR_mice,'(\muM)',-10,0)
% 
% 



load(fullfile(saveDir_cat, processedName_mice),'total_Delta_powerMap_mice','total_ISA_powerMap_mice',...
        'FADCorr_Delta_powerMap_mice','FADCorr_ISA_powerMap_mice', 'jrgeco1aCorr_Delta_powerMap_mice','jrgeco1aCorr_ISA_powerMap_mice','xform_isbrain_mice')
   
%   figure('units','normalized','outerposition',[0 0 0.5 0.7]);
%     subplot(2,3,1)
    powerMapVis(jrgeco1aCorr_ISA_powerMap_mice,'(\DeltaF/F%)',-10,0)
    title('Corr jRGECO1a ISA')
    
    %subplot(2,3,2)
    
    
    powerMapVis(FADCorr_ISA_powerMap_mice,'(\DeltaF/F%)',-10,0)
     title('Corr FAD ISA')
    
   % subplot(2,3,3)
    
    powerMapVis(total_ISA_powerMap_mice,'(\muM)',-10,0)
    
    title('Total ISA')
    
   % subplot(2,3,4)
     powerMapVis(jrgeco1aCorr_Delta_powerMap_mice,'(\DeltaF/F%)',-10,0)
    title('Corr jRGECO1a Delta')
    
   % subplot(2,3,5)
    
    powerMapVis(FADCorr_Delta_powerMap_mice,'(\DeltaF/F%)',-10,0)
     title('Corr FAD Delta')
    
    %subplot(2,3,6)
     powerMapVis(total_Delta_powerMap_mice,'(\muM)',-10,0)
     
     suptitle('Awake Power Map')
     title('Total  Delta')
     

processedName_mice = '191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc.mat';
miceName = 'R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake';
saveDir_cat = 'L:\RGECO\cat';
load(fullfile(saveDir_cat, processedName_mice),'total_Delta_powerMap_mice','total_ISA_powerMap_mice',...
        'FADCorr_Delta_powerMap_mice','FADCorr_ISA_powerMap_mice', 'jrgeco1aCorr_Delta_powerMap_mice','jrgeco1aCorr_ISA_powerMap_mice','xform_isbrain_mice')
load('D:\OIS_Process\noVasculaturemask.mat')
mask_new = logical(mask_new);


total_ISA_powerMap_mice_mean_awake = mean(total_ISA_powerMap_mice(mask_new),'all');
FADCorr_ISA_powerMap_mice_mean_awake = mean(FADCorr_ISA_powerMap_mice(mask_new),'all');
jrgeco1aCorr_ISA_powerMap_mice_mean_awake = mean(jrgeco1aCorr_ISA_powerMap_mice(mask_new),'all');

mask_new = logical(mask_new);
total_Delta_powerMap_mice_mean_awake = mean(total_Delta_powerMap_mice(mask_new),'all');
FADCorr_Delta_powerMap_mice_mean_awake = mean(FADCorr_Delta_powerMap_mice(mask_new),'all');
jrgeco1aCorr_Delta_powerMap_mice_mean_awake = mean(jrgeco1aCorr_Delta_powerMap_mice(mask_new),'all');


processedName_mice = '191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc.mat';
miceName = 'R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes';
saveDir_cat = 'L:\RGECO\cat';
load(fullfile(saveDir_cat, processedName_mice),'total_Delta_powerMap_mice','total_ISA_powerMap_mice',...
        'FADCorr_Delta_powerMap_mice','FADCorr_ISA_powerMap_mice', 'jrgeco1aCorr_Delta_powerMap_mice','jrgeco1aCorr_ISA_powerMap_mice','xform_isbrain_mice')
load('D:\OIS_Process\noVasculaturemask.mat')
mask_new = logical(mask_new);


total_ISA_powerMap_mice_mean_anes = mean(total_ISA_powerMap_mice(mask_new),'all');
FADCorr_ISA_powerMap_mice_mean_anes = mean(FADCorr_ISA_powerMap_mice(mask_new),'all');
jrgeco1aCorr_ISA_powerMap_mice_mean_anes = mean(jrgeco1aCorr_ISA_powerMap_mice(mask_new),'all');

mask_new = logical(mask_new);
total_Delta_powerMap_mice_mean_anes = mean(total_Delta_powerMap_mice(mask_new),'all');
FADCorr_Delta_powerMap_mice_mean_anes = mean(FADCorr_Delta_powerMap_mice(mask_new),'all');
jrgeco1aCorr_Delta_powerMap_mice_mean_anes = mean(jrgeco1aCorr_Delta_powerMap_mice(mask_new),'all');



total_ISA_powerMap_mice_ratio = total_ISA_powerMap_mice_mean_anes./total_ISA_powerMap_mice_mean_awake;
FADCorr_ISA_powerMap_mice_mean_ratio  = FADCorr_ISA_powerMap_mice_mean_anes./FADCorr_ISA_powerMap_mice_mean_awake;
jrgeco1aCorr_ISA_powerMap_mice_mean_ratio  = jrgeco1aCorr_ISA_powerMap_mice_mean_anes./jrgeco1aCorr_ISA_powerMap_mice_mean_awake;


total_Delta_powerMap_mice_mean_ratio = total_Delta_powerMap_mice_mean_anes./total_Delta_powerMap_mice_mean_awake;
FADCorr_Delta_powerMap_mice_mean_ratio  = FADCorr_Delta_powerMap_mice_mean_anes./FADCorr_Delta_powerMap_mice_mean_awake;
jrgeco1aCorr_Delta_powerMap_mice_mean_ratio  = jrgeco1aCorr_Delta_powerMap_mice_mean_anes./jrgeco1aCorr_Delta_powerMap_mice_mean_awake;
figure('position',[ 1182 340 260 214])
b_ISA = bar(1:3,[jrgeco1aCorr_ISA_powerMap_mice_mean_ratio, FADCorr_ISA_powerMap_mice_mean_ratio, total_ISA_powerMap_mice_ratio],0.5,'LineWidth',2);
b_ISA.FaceColor = 'flat';
b_ISA.CData(1,:) = [1 0 1];
b_ISA.CData(2,:) = [0 1 0];
b_ISA.CData(3,:) = [0 0 0];
%xticklabels({'Corrected jRGECO1a','Corrected FAD','HbT'})
xlim([0.5,3.5])
yticks([0 0.2 0.4 0.6])
set(findall(gca, 'Type', 'Line'),'LineWidth',2);
set(gca,'FontSize',14,'FontWeight','Bold')
%xlabel('Contrasts')
%ylabel('Awake/Anesthetized Power Ratio')
title('ISA')
set(gca,'LineWidth',2)

figure('position',[ 1182 358 260 214])
b_Delta = bar(1:3,[jrgeco1aCorr_Delta_powerMap_mice_mean_ratio, FADCorr_Delta_powerMap_mice_mean_ratio, total_Delta_powerMap_mice_mean_ratio],0.5,'LineWidth',2);
b_Delta.FaceColor = 'flat';
b_Delta.CData(1,:) = [1 0 1];
b_Delta.CData(2,:) = [0 1 0];
b_Delta.CData(3,:) = [0 0 0];
%xticklabels({'Corrected jRGECO1a','Corrected FAD','HbT'})
xtickangle(0)
set(gca,'LineWidth',2)
set(gca,'FontSize',14,'FontWeight','Bold')
%xlabel('Contrasts')
%ylabel('Awake/Anesthetized Power Ratio')
xlim([0.5,3.5])
ylim([0 32])
yticks([1 5 25 30])

title('Delta')
xlimVal = get(gca,'xlim');
hold on
plot(xlimVal,[1 1],'b--','LineWidth',2)
 breakyaxis([6 24])






load(fullfile(saveDir_cat, processedName_mice), 'powerdata_average_FADCorr_mice', 'powerdata_average_deoxy_mice', 'powerdata_average_jrgeco1aCorr_mice', 'powerdata_average_oxy_mice', 'powerdata_average_total_mice')
f = figure('position',[ 1182         358         515        430])
yyaxis left
normFactor = (powerdata_average_jrgeco1aCorr_mice(3)-powerdata_average_jrgeco1aCorr_mice(2))*(0.01-hz(2))/(hz(3)-hz(2))+powerdata_average_jrgeco1aCorr_mice(2);
semilogx(hz,10*log10(powerdata_average_jrgeco1aCorr_mice/normFactor),'m-')
hold on
normFactor = (powerdata_average_FADCorr_mice(3)-powerdata_average_FADCorr_mice(2))*(0.01-hz(2))/(hz(3)-hz(2))+powerdata_average_FADCorr_mice(2);
semilogx(hz,10*log10(powerdata_average_FADCorr_mice/normFactor),'g-')
ylim([-50,5])
ylabel('dB(\DeltaF/F%)^2/Hz)')

yyaxis right
hold on
normFactor = (powerdata_average_oxy_mice(3)-powerdata_average_oxy_mice(2))*(0.01-hz(2))/(hz(3)-hz(2))+powerdata_average_oxy_mice(2);
semilogx(hz,10*log10(powerdata_average_oxy_mice/normFactor),'r-')

hold on
normFactor = (powerdata_average_deoxy_mice(3)-powerdata_average_deoxy_mice(2))*(0.01-hz(2))/(hz(3)-hz(2))+powerdata_average_deoxy_mice(2);
semilogx(hz,10*log10(powerdata_average_deoxy_mice/normFactor),'b-')

hold on
normFactor = (powerdata_average_total_mice(3)-powerdata_average_total_mice(2))*(0.01-hz(2))/(hz(3)-hz(2))+powerdata_average_total_mice(2);
semilogx(hz,10*log10(powerdata_average_total_mice/normFactor),'k-')
ylabel('dB(\muM^2/Hz)')
ylim([-50,5])

xticks([10^-2  10^-1 10^0 10])

xlabel('Frequency (Hz)')

xlim([10^-2 10])
set(findall(gca, 'Type', 'Line'),'LineWidth',2);
set(gca,'FontSize',20,'FontWeight','Bold')
 grid on
 legendName = {'Corrected jRGECO1a','Corrected FAD','HbO','HbR','HbT'};
leg = legend(legendName,'location','southwest','FontSize',12)


title(Name,'fontsize',14,'Interpreter', 'none');
ytickformat('%.1f');

saveas(gcf,fullfile(saveDir,strcat(Name,'.png')));
saveas(gcf,fullfile(saveDir,strcat(Name,'.fig')));





figure
cb = colorbar( 'EastOutside','AxisLocation','out',...
    'FontSize',15,'fontweight','bold');
cb.Ruler.MinorTick = 'on';
set(cb,'YTick',[-10 -5 0]);
colormap(mycolormap);
function powerMapVis(powerMap,unit,minVal,maxVal)

load('D:\OIS_Process\noVasculaturemask.mat')
%xform_isbrain(isnan(xform_isbrain)) = 0;
% maxVal = max(max(powerMap(logical(xform_isbrain.*(double(leftmask_new)+double(rightmask_new))))));
% minVal = min(min(powerMap(logical(xform_isbrain.*(double(leftmask_new)+double(rightmask_new))))));
% maxVal = max(max(log10(powerMap(logical(xform_isbrain.*(double(leftmask_new)+double(rightmask_new)))))));
% minVal = min(min(log10(powerMap(logical(xform_isbrain.*(double(leftmask_new)+double(rightmask_new)))))));
figure('Position', [50 50 200 300])
% imagesc(powerMap,[0.5 1.5]);
% colorbar

% imagesc(powerMap,[minVal maxVal]);
% cb = colorbar();
% cb.Ruler.MinorTick = 'on';
% ylabel(cb,[unit,'^2'],'FontSize',12)
mask = leftMask+rightMask;
powerMap = powerMap.*mask;
mask_new = logical(mask_new)
imagesc(10*log10(powerMap/max(powerMap(mask_new),[],'all')),[minVal maxVal]);
cb = colorbar( 'SouthOutside','AxisLocation','out',...
    'FontSize',15,'fontweight','bold');
cb.Ruler.MinorTick = 'on';
%set(cb,'YTick',[-0.25 0 0.25]);
ylabel(cb,['dB',unit,'^2'],'FontSize',12,'fontweight','bold')
hold on
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL');

imagesc(xform_WL,'AlphaData',1-mask);
%imagesc(xform_WL,'AlphaData',1-xform_isbrain.*cerebralmask_new);
mycolormap = customcolormap(linspace(0,1,11), {'#a60126','#d7302a','#f36e43','#faac5d','#fedf8d','#fcffbf','#d7f08b','#a5d96b','#68bd60','#1a984e','#006936'});
colormap(mycolormap);
axis image off
%title(titleName,'fontsize',14,'Interpreter', 'none')
end



        