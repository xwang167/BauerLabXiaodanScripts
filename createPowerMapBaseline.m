clear all;close all;clc
info.nVy =128;
info.nVx =128;
baselineName = 'K:\Glucose\cat\200313--R9M3-R9M2911-R9M2912-R8M2-R8M2498-R9M2-R8M3-fc-baseline.mat';
sessionInfo.miceType = 'jrgeco1a';
%
%
numRuns = 3;
jrgeco1aCorr_Delta_powerMap_mice_baseline = [];
jrgeco1aCorr_ISA_powerMap_mice_baseline = [];

FADCorr_Delta_powerMap_mice_baseline = [];
FADCorr_ISA_powerMap_mice_baseline = [];

total_Delta_powerMap_mice_baseline = [];
total_ISA_powerMap_mice_baseline = [];

R_jrgeco1aCorr_Delta_mice_baseline = zeros(info.nVy,info.nVx,16,numRuns);
R_jrgeco1aCorr_ISA_mice_baseline  = zeros(info.nVy,info.nVx,16,numRuns);
Rs_jrgeco1aCorr_Delta_mice_baseline = zeros(16,16,numRuns);
Rs_jrgeco1aCorr_ISA_mice_baseline = zeros(16,16,numRuns);
jrgeco1aCorr_Delta_powerMap_mice_baseline = zeros(info.nVy,info.nVx,numRuns);
jrgeco1aCorr_ISA_powerMap_mice_baseline = zeros(info.nVy,info.nVx,numRuns);
powerdata_average_jrgeco1aCorr_mice_baseline = [];
powerdata_jrgeco1aCorr_mice_baseline = [];

R_FADCorr_Delta_mice_baseline  = zeros(info.nVy,info.nVx,16,numRuns);
R_FADCorr_ISA_mice_baseline  = zeros(info.nVy,info.nVx,16,numRuns);
Rs_FADCorr_Delta_mice_baseline = zeros(16,16,numRuns);
Rs_FADCorr_ISA_mice_baseline = zeros(16,16,numRuns);
FADCorr_Delta_powerMap_mice_baseline = zeros(info.nVy,info.nVx,numRuns);
FADCorr_ISA_powerMap_mice_baseline = zeros(info.nVy,info.nVx,numRuns);
powerdata_average_FADCorr_mice_baseline = [];
powerdata_FADCorr_mice_baseline = [];

R_total_Delta_mice_baseline  = zeros(info.nVy,info.nVx,16,numRuns);
R_total_ISA_mice_baseline  = zeros(info.nVy,info.nVx,16,numRuns);
Rs_total_Delta_mice_baseline = zeros(16,16,numRuns);
Rs_total_ISA_mice_baseline = zeros(16,16,numRuns);
powerdata_average_oxy_mice_baseline = [];
powerdata_oxy_mice_baseline = [];

powerdata_average_deoxy_mice_baseline = [];
powerdata_deoxy_mice_baseline = [];

powerdata_average_total_mice_baseline = [];
powerdata_total_mice_baseline = [];
powerdata_FADCorr_mice = [];


load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
mask = leftMask+ rightMask;

    
    lagParaStrs = ["lagTime","lagAmp"];
    traceStrs = ["total","Calcium","FAD"];
    bandStrs = ["ISA","Delta"];
    avgWayStrs = ["mean","median"];
    lagSpeciesStrs = ["HbTCalcium","FADCalcium"];
    
    tLim = [0 1.5];
    rLim = [-1 1];
    tLim_ISA = [-1.5 1.5];
    tLim_Delta = [-0.001 0.001];
%

for ii = 1:2
    for jj = 1:2
        
        eval(strcat(lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),'_mice_baseline','=  zeros(128,128,numRuns);'));
        
    end
end

for ii = 1:2
    for jj = 1:3
        for kk = 1:2
            eval(strcat(lagParaStrs(ii),'_GS_',traceStrs(jj),'_',bandStrs(kk),'_mice_baseline','=  zeros(128,128,numRuns);'));
        end
    end
end

for ii = 1:3
    name = strcat('K:\Glucose\cat\200313--R9M3-R9M2911-R9M2912-R8M2-R8M2498-R9M2-R8M3-fc',num2str(ii),'.mat');
    load(name, 'hz','R_total_ISA_mice','R_jrgeco1aCorr_ISA_mice','R_FADCorr_ISA_mice',...
            'R_total_Delta_mice','R_jrgeco1aCorr_Delta_mice','R_FADCorr_Delta_mice',...
            'Rs_total_ISA_mice','Rs_jrgeco1aCorr_ISA_mice','Rs_FADCorr_ISA_mice',...
            'Rs_total_Delta_mice','Rs_jrgeco1aCorr_Delta_mice','Rs_FADCorr_Delta_mice',...
            'powerdata_average_oxy_mice','powerdata_average_deoxy_mice','powerdata_average_total_mice','powerdata_average_jrgeco1aCorr_mice','powerdata_average_FADCorr_mice',...
            'powerdata_oxy_mice','powerdata_deoxy_mice','powerdata_total_mice','powerdata_jrgeco1aCorr_mice','powerdata_FADCorr_mice',...
            'total_ISA_powerMap_mice','jrgeco1aCorr_ISA_powerMap_mice','FADCorr_ISA_powerMap_mice',...
            'total_Delta_powerMap_mice','jrgeco1aCorr_Delta_powerMap_mice','FADCorr_Delta_powerMap_mice')
    jrgeco1aCorr_ISA_powerMap_mice_baseline = cat(3,jrgeco1aCorr_ISA_powerMap_mice_baseline,jrgeco1aCorr_ISA_powerMap_mice);
    jrgeco1aCorr_Delta_powerMap_mice_baseline = cat(3,jrgeco1aCorr_Delta_powerMap_mice_baseline,jrgeco1aCorr_Delta_powerMap_mice);
    
    FADCorr_ISA_powerMap_mice_baseline = cat(3,FADCorr_ISA_powerMap_mice_baseline,FADCorr_ISA_powerMap_mice);
    FADCorr_Delta_powerMap_mice_baseline = cat(3,FADCorr_Delta_powerMap_mice_baseline,FADCorr_Delta_powerMap_mice);
    
    total_ISA_powerMap_mice_baseline = cat(3,total_ISA_powerMap_mice_baseline,total_ISA_powerMap_mice);
    total_Delta_powerMap_mice_baseline = cat(3,total_Delta_powerMap_mice_baseline,total_Delta_powerMap_mice);
    
    R_total_Delta_mice_baseline(:,:,:,ii) = R_total_Delta_mice;
    R_total_ISA_mice_baseline(:,:,:,ii) = R_total_ISA_mice;
    Rs_total_Delta_mice_baseline(:,:,ii) = Rs_total_Delta_mice;
    Rs_total_ISA_mice_baseline(:,:,ii) = Rs_total_ISA_mice;
    total_Delta_powerMap_mice_baseline(:,:,ii) = total_Delta_powerMap_mice;
    total_ISA_powerMap_mice_baseline(:,:,ii) = total_ISA_powerMap_mice;
    %
    %                                 %     if goodRuns ~=0
    %
    %

    powerdata_oxy_mice_baseline = cat(1,powerdata_oxy_mice_baseline,squeeze(powerdata_oxy_mice));
    
    
    powerdata_deoxy_mice_baseline = cat(1,powerdata_deoxy_mice_baseline,squeeze(powerdata_deoxy_mice));

    powerdata_total_mice_baseline = cat(1,powerdata_total_mice_baseline,squeeze(powerdata_total_mice));
    
    powerdata_jrgeco1aCorr_mice_baseline = cat(1,powerdata_jrgeco1aCorr_mice_baseline,squeeze(powerdata_jrgeco1aCorr_mice));
    powerdata_FADCorr_mice_baseline = cat(1,powerdata_FADCorr_mice_baseline,squeeze(powerdata_FADCorr_mice));
    %
    %                                 % end
    %
    %
    R_jrgeco1aCorr_Delta_mice_baseline(:,:,:,ii) = R_jrgeco1aCorr_Delta_mice;
    R_jrgeco1aCorr_ISA_mice_baseline(:,:,:,ii) = R_jrgeco1aCorr_ISA_mice;
    Rs_jrgeco1aCorr_Delta_mice_baseline(:,:,ii) = Rs_jrgeco1aCorr_Delta_mice;
    Rs_jrgeco1aCorr_ISA_mice_baseline(:,:,ii) = Rs_jrgeco1aCorr_ISA_mice;
    jrgeco1aCorr_Delta_powerMap_mice_baseline(:,:,ii) = jrgeco1aCorr_Delta_powerMap_mice;
    jrgeco1aCorr_ISA_powerMap_mice_baseline(:,:,ii) = jrgeco1aCorr_ISA_powerMap_mice;
    
    
    R_FADCorr_Delta_mice_baseline(:,:,:,ii) = R_FADCorr_Delta_mice;
    R_FADCorr_ISA_mice_baseline(:,:,:,ii) = R_FADCorr_ISA_mice;
    Rs_FADCorr_Delta_mice_baseline(:,:,ii) = Rs_FADCorr_Delta_mice;
    Rs_FADCorr_ISA_mice_baseline(:,:,ii) = Rs_FADCorr_ISA_mice;
    FADCorr_Delta_powerMap_mice_baseline(:,:,ii) = FADCorr_Delta_powerMap_mice;
    FADCorr_ISA_powerMap_mice_baseline(:,:,ii) = FADCorr_ISA_powerMap_mice;
    
    for ll = 1:2
        for jj = 1:2
            eval(strcat('load(name, ',char(39),lagParaStrs(ll),'Trial_',lagSpeciesStrs(jj),'_mice_mean',char(39),')'));
            eval(strcat(lagParaStrs(ll),'Trial_',lagSpeciesStrs(jj),'_mice_baseline(:,:,ii)','= ',lagParaStrs(ll),'Trial_',lagSpeciesStrs(jj),'_mice_mean',';'));
            
        end
    end
    
    for ll = 1:2
        for jj = 1:3
            for kk = 1:2
                eval(strcat('load(name, ',char(39),lagParaStrs(ll),'_GS_',traceStrs(jj),'_',bandStrs(kk),'_mice_mean',char(39),')'));
                eval(strcat(lagParaStrs(ll),'_GS_',traceStrs(jj),'_',bandStrs(kk),'_mice_baseline(:,:,ii)','= ',lagParaStrs(ll),'_GS_',traceStrs(jj),'_',bandStrs(kk),'_mice_mean',';'));
            end
        end
    end
    
    
end

jrgeco1aCorr_ISA_powerMap_mice_baseline = mean(jrgeco1aCorr_ISA_powerMap_mice_baseline,3);
jrgeco1aCorr_Delta_powerMap_mice_baseline = mean(jrgeco1aCorr_Delta_powerMap_mice_baseline,3);

FADCorr_ISA_powerMap_mice_baseline = mean(FADCorr_ISA_powerMap_mice_baseline,3);
FADCorr_Delta_powerMap_mice_baseline = mean(FADCorr_Delta_powerMap_mice_baseline,3);

total_ISA_powerMap_mice_baseline = mean(total_ISA_powerMap_mice_baseline,3);
total_Delta_powerMap_mice_baseline = mean(total_Delta_powerMap_mice_baseline,3);


R_total_Delta_mice_baseline  = mean(R_total_Delta_mice_baseline,4);
R_total_ISA_mice_baseline  = mean(R_total_ISA_mice_baseline,4);
Rs_total_Delta_mice_baseline = mean(Rs_total_Delta_mice_baseline,3);
Rs_total_ISA_mice_baseline = mean(Rs_total_ISA_mice_baseline,3);




    powerdata_average_oxy_mice_baseline = mean(powerdata_average_oxy_mice_baseline,2);
    powerdata_oxy_mice_baseline = mean(powerdata_oxy_mice_baseline,1);
    
    
    powerdata_average_deoxy_mice_baseline = mean(powerdata_average_deoxy_mice_baseline,2);
    powerdata_deoxy_mice_baseline = mean(powerdata_deoxy_mice_baseline,1);
    
    powerdata_average_total_mice_baseline = mean(powerdata_average_total_mice_baseline,2);
    powerdata_total_mice_baseline = mean(powerdata_total_mice_baseline,1);
    
    
    powerdata_average_jrgeco1aCorr_mice_baseline = mean(powerdata_average_jrgeco1aCorr_mice_baseline,2);
    powerdata_jrgeco1aCorr_mice_baseline = mean(powerdata_jrgeco1aCorr_mice_baseline,1);
    
    powerdata_average_FADCorr_mice_baseline = mean(powerdata_average_FADCorr_mice_baseline,2);
    powerdata_FADCorr_mice_baseline = mean(powerdata_FADCorr_mice_baseline,1);





R_jrgeco1aCorr_Delta_mice_baseline = mean(R_jrgeco1aCorr_Delta_mice_baseline,4);
R_jrgeco1aCorr_ISA_mice_baseline  = mean(R_jrgeco1aCorr_ISA_mice_baseline,4);
Rs_jrgeco1aCorr_Delta_mice_baseline = mean(Rs_jrgeco1aCorr_Delta_mice_baseline,3);
Rs_jrgeco1aCorr_ISA_mice_baseline = mean(Rs_jrgeco1aCorr_ISA_mice_baseline,3);


R_FADCorr_Delta_mice_baseline = mean(R_FADCorr_Delta_mice_baseline,4);
R_FADCorr_ISA_mice_baseline  = mean(R_FADCorr_ISA_mice_baseline,4);
Rs_FADCorr_Delta_mice_baseline = mean(Rs_FADCorr_Delta_mice_baseline,3);
Rs_FADCorr_ISA_mice_baseline = mean(Rs_FADCorr_ISA_mice_baseline,3);


saveDir_cat ='K:\Glucose\cat\';
visName = 'Glucose_SeedFC-fc-baseline';
figure('units','normalized','outerposition',[0 0 0.5 0.7]);
subplot(2,3,1)
powerMapVis(jrgeco1aCorr_ISA_powerMap_mice_baseline,'(\DeltaF/F%)',-2,-1)
title('Corr jRGECO1a')

subplot(2,3,2)


powerMapVis(FADCorr_ISA_powerMap_mice_baseline,'(\DeltaF/F%)',-2,-1)
title('Corr FAD')

subplot(2,3,3)

powerMapVis(total_ISA_powerMap_mice_baseline,'(\muM)',-1.5,-0.5)

title('Total')

subplot(2,3,4)
powerMapVis(jrgeco1aCorr_Delta_powerMap_mice_baseline,'(\DeltaF/F%)',-3.5,-2.5)


subplot(2,3,5)

powerMapVis(FADCorr_Delta_powerMap_mice_baseline,'(\DeltaF/F%)',-3.5,-2.5)


subplot(2,3,6)
powerMapVis(total_Delta_powerMap_mice_baseline,'(\muM)',-3,-2)

suptitle('Glucose Power Map for Baseline')

saveas(gcf,strcat('K:\Glucose\cat\Glucose_PowerMap-fc-baseline.png'));
saveas(gcf,strcat('K:\Glucose\cat\Glucose_PowerMap-fc-baseline.fig'));


save(baselineName,'jrgeco1aCorr_Delta_powerMap_mice_baseline','jrgeco1aCorr_ISA_powerMap_mice_baseline',...
    'FADCorr_Delta_powerMap_mice_baseline','FADCorr_ISA_powerMap_mice_baseline',...
    'total_Delta_powerMap_mice_baseline','total_ISA_powerMap_mice_baseline')




for ii = 1:2
    for jj = 1:2
        for mm = 1:2
            
            eval(strcat(lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),'_mice_baseline_',avgWayStrs(mm),'= nan',avgWayStrs(mm),'(',lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),'_mice_baseline,3);'));
            eval(strcat('save(baselineName, ',char(39),lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),'_mice_baseline_',avgWayStrs(mm),char(39),',',char(39),'-append',char(39),')'));
        end
        
    end
end

for ii = 1:2
    for jj = 1:3
        for kk = 1:2
            for mm = 1:2
                eval(strcat(lagParaStrs(ii),'_GS_',traceStrs(jj),'_',bandStrs(kk),'_mice_baseline_',avgWayStrs(mm),'= nan',avgWayStrs(mm),'(',lagParaStrs(ii),'_GS_',traceStrs(jj),'_',bandStrs(kk),'_mice_baseline,3);'));
                eval(strcat('save(baselineName, ',char(39),lagParaStrs(ii),'_GS_',traceStrs(jj),'_',bandStrs(kk),'_mice_baseline_',avgWayStrs(mm),char(39),',',char(39),'-append',char(39),')'));
            end
        end
    end
end

for ii = 1:2
    for jj = 1:2
        figure;colormap jet;
        subplot(2,3,1); eval(strcat('imagesc(lagTime_GS_Calcium_',bandStrs(ii),'_mice_baseline_',avgWayStrs(jj),',tLim_',bandStrs(ii),');'));
        axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,2); eval(strcat('imagesc(lagTime_GS_FAD_',bandStrs(ii),'_mice_baseline_',avgWayStrs(jj),',tLim_',bandStrs(ii),');'));
        axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
        
        
        subplot(2,3,3); eval(strcat('imagesc(lagTime_GS_total_',bandStrs(ii),'_mice_baseline_',avgWayStrs(jj),',tLim_',bandStrs(ii),');'));
        axis image off;h = colorbar;ylabel(h,'t(s)');title('Total');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,4); eval(strcat('imagesc(lagAmp_GS_Calcium_',bandStrs(ii),'_mice_baseline_',avgWayStrs(jj),',rLim);'));
        axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,5); eval(strcat('imagesc(lagAmp_GS_FAD_',bandStrs(ii),'_mice_baseline_',avgWayStrs(jj),',rLim);'));
        axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,6); eval(strcat('imagesc(lagAmp_GS_total_',bandStrs(ii),'_mice_baseline_',avgWayStrs(jj),',rLim);'));
        axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
        
        suptitle(strcat(visName,'Lag with GS, ',bandStrs(ii),',',avgWayStrs(jj) ))
        saveas(gcf,fullfile(saveDir_cat,strcat(visName,'_LagGS_',bandStrs(ii),'_',avgWayStrs(jj),'.png')));
        saveas(gcf,fullfile(saveDir_cat,strcat(visName,'_LagGS_',bandStrs(ii),'_',avgWayStrs(jj),'.fig')));
        
        
    end
end


for ii = 1:2
    figure;
    colormap jet;
    subplot(2,2,1); eval(strcat('imagesc(lagTimeTrial_HbTCalcium_mice_baseline_',avgWayStrs(ii),',tLim);')); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,2,2); eval(strcat('imagesc(lagTimeTrial_FADCalcium_mice_baseline_',avgWayStrs(ii),',[0 0.2]);'));axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,2,3); eval(strcat('imagesc(lagAmpTrial_HbTCalcium_mice_baseline_',avgWayStrs(ii),',rLim);'));axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
    subplot(2,2,4);  eval(strcat('imagesc(lagAmpTrial_FADCalcium_mice_baseline_',avgWayStrs(ii),',rLim);'));axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
    suptitle(strcat(visName,', ',avgWayStrs(ii) ))
    
    
    saveas(gcf,fullfile(saveDir_cat,strcat(visName,'_Lag_',avgWayStrs(ii),'.png')));
    saveas(gcf,fullfile(saveDir_cat,strcat(visName,'_Lag_',avgWayStrs(ii),'.fig')));
end






if strcmp(char(sessionInfo.miceType),'jrgeco1a')
    
    %if goodRuns ~=0
    
    
    leftData = cell(2,1);
    leftData{1} = powerdata_jrgeco1aCorr_mice_baseline;
    leftData{2} = powerdata_FADCorr_mice_baseline;
    
    rightData = cell(3,1);
    rightData{1} = powerdata_oxy_mice_baseline;
    rightData{2} = powerdata_deoxy_mice_baseline;
    rightData{3} = powerdata_total_mice_baseline;
    
    leftLabel = 'Fluor(\DeltaF/F%)^2/Hz)';
    rightLabel = 'Hb(\muM^2/Hz)';
    leftLineStyle = {'m-','g-'};
    rightLineStyle= {'r-','b-','k-'};
    legendName = ["Corrected jRGECO1a","Corrected FAD","HbO","HbR","HbT"];
    
    QCcheck_fftVis(hz, leftData,rightData,leftLabel,rightLabel,leftLineStyle,rightLineStyle,legendName,saveDir_cat,strcat(visName, '_powerCurve'))
    
    
    
       
    %end
    %
    %
    refseeds=GetReferenceSeeds;
    refseeds = refseeds(1:14,:);
    refseeds(3,1) = 42;
    refseeds(3,2) = 88;
    refseeds(4,1) = 87;
    refseeds(4,2) = 88;
    refseeds(9,1) = 18;
    refseeds(9,2) = 66;
    refseeds(10,1) = 111;
    refseeds(10,2) = 66;
    
    QCcheck_fcVis(refseeds,R_jrgeco1aCorr_ISA_mice_baseline, Rs_jrgeco1aCorr_ISA_mice_baseline(1:14,1:14),'jrgeco1aCorr','m','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
    QCcheck_fcVis(refseeds,R_FADCorr_ISA_mice_baseline, Rs_FADCorr_ISA_mice_baseline(1:14,1:14),'FADCorr','g','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
    QCcheck_fcVis(refseeds,R_total_ISA_mice_baseline, Rs_total_ISA_mice_baseline(1:14,1:14),'total','k','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
    
    QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_mice_baseline, Rs_jrgeco1aCorr_Delta_mice_baseline(1:14,1:14),'jrgeco1aCorr','m','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
    QCcheck_fcVis(refseeds,R_FADCorr_Delta_mice_baseline, Rs_FADCorr_Delta_mice_baseline(1:14,1:14),'FADCorr','g','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
    QCcheck_fcVis(refseeds,R_total_Delta_mice_baseline, Rs_total_Delta_mice_baseline(1:14,1:14),'total','k','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
    %
    QCcheck_powerMapVis(jrgeco1aCorr_ISA_powerMap_mice_baseline,xform_isbrain_mice,'(\DeltaF/F%)',saveDir_cat,strcat(visName, '_RGECOISA'))
    QCcheck_powerMapVis(FADCorr_ISA_powerMap_mice_baseline,xform_isbrain_mice,'(\DeltaF/F%)',saveDir_cat,strcat(visName, '_FADISA'))
    QCcheck_powerMapVis(total_ISA_powerMap_mice_baseline,xform_isbrain_mice,'\muM',saveDir_cat,strcat(visName, "_TotalISA"))
    
    QCcheck_powerMapVis(jrgeco1aCorr_Delta_powerMap_mice_baseline,xform_isbrain_mice,'(\DeltaF/F%)',saveDir_cat,strcat(visName, "_RGECODelta"))
    QCcheck_powerMapVis(FADCorr_Delta_powerMap_mice_baseline,xform_isbrain_mice,'(\DeltaF/F%)',saveDir_cat,strcat(visName,"_FADDelta"))
    QCcheck_powerMapVis(total_Delta_powerMap_mice_baseline,xform_isbrain_mice,'\muM',saveDir_cat,strcat(visName,"_TotalDelta"))
    
end

function powerMapVis(powerMap,unit,minVal,maxVal)
load('D:\OIS_Process\noVasculatureMask.mat')

imagesc(log10(powerMap),[minVal maxVal]);
cb = colorbar( 'SouthOutside','AxisLocation','out',...
    'FontSize',15,'fontweight','bold');
cb.Ruler.MinorTick = 'on';
set(cb,'YTick',[minVal (minVal+maxVal)/2 maxVal]);
ylabel(cb,['log_1_0(',unit,'^2)'],'FontSize',12,'fontweight','bold')
hold on
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL');
mask = leftMask+rightMask;
imagesc(xform_WL,'AlphaData',1-mask);
%imagesc(xform_WL,'AlphaData',1-xform_isbrain.*cerebralMask);
colormap jet
axis image off
%title(titleName,'fontsize',14,'Interpreter', 'none')
end