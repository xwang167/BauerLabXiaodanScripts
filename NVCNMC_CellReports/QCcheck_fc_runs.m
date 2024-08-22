close all;clearvars -except hz;clc

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
mask = leftMask+ rightMask;

import mice.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
isZTransform = true;
set(0,'defaultaxesfontsize',12);
miceCat = 'Glucose';

info.nVx = 128;
info.nVy = 128;


lagParaStrs = ["lagTime","lagAmp"];
traceStrs = ["total","Calcium","FAD"];
bandStrs = ["ISA","Delta"];
avgWayStrs = ["mean","median"];
lagSpeciesStrs = ["HbTCalcium","FADCalcium"];

tLim = [-2 1.5];
rLim = [-1 1];
tLim_ISA = [-1.5 1.5];
tLim_Delta = [-0.001 0.001];
%
for run = 1:9;
    excelRows =321:327;
    
    numMice = length(excelRows);
    xform_isbrain_mice = 1;
    sessionInfo.miceType = 'jrgeco1a';
    saveDir_cat = 'K:\Glucose\cat';
    
%     R_total_Delta_mice  = zeros(info.nVy,info.nVx,16,numMice);
%     R_total_ISA_mice  = zeros(info.nVy,info.nVx,16,numMice);
%     Rs_total_Delta_mice = zeros(16,16,numMice);
%     Rs_total_ISA_mice = zeros(16,16,numMice);
    total_Delta_powerMap_mice = zeros(info.nVy,info.nVx,numMice);
    total_ISA_powerMap_mice = zeros(info.nVy,info.nVx,numMice);
%     powerdata_average_oxy_mice = [];
%     powerdata_oxy_mice = [];
%     
%     powerdata_average_deoxy_mice = [];
%     powerdata_deoxy_mice = [];
%     
%     powerdata_average_total_mice = [];
%     powerdata_total_mice = [];
%     % %
%     
%     for ii = 1:2
%         for jj = 1:2
%             
%             eval(strcat(lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),'_mice','=  zeros(128,128,numMice);'));
%             
%         end
%     end
%     
%     for ii = 1:2
%         for jj = 1:3
%             for kk = 1:2
%                 eval(strcat(lagParaStrs(ii),'_GS_',traceStrs(jj),'_',bandStrs(kk),'_mice','=  zeros(128,128,numMice);'));
%             end
%         end
%     end
    
    if strcmp(char(sessionInfo.miceType),'jrgeco1a')
%         R_jrgeco1aCorr_Delta_mice = zeros(info.nVy,info.nVx,16,numMice);
%         R_jrgeco1aCorr_ISA_mice  = zeros(info.nVy,info.nVx,16,numMice);
%         Rs_jrgeco1aCorr_Delta_mice = zeros(16,16,numMice);
%         Rs_jrgeco1aCorr_ISA_mice = zeros(16,16,numMice);
        jrgeco1aCorr_Delta_powerMap_mice = zeros(info.nVy,info.nVx,numMice);
        jrgeco1aCorr_ISA_powerMap_mice = zeros(info.nVy,info.nVx,numMice);
%         powerdata_average_jrgeco1aCorr_mice = [];
%         powerdata_jrgeco1aCorr_mice = [];
        
%         R_FADCorr_Delta_mice  = zeros(info.nVy,info.nVx,16,numMice);
%         R_FADCorr_ISA_mice  = zeros(info.nVy,info.nVx,16,numMice);
%         Rs_FADCorr_Delta_mice = zeros(16,16,numMice);
%         Rs_FADCorr_ISA_mice = zeros(16,16,numMice);
        FADCorr_Delta_powerMap_mice = zeros(info.nVy,info.nVx,numMice);
        FADCorr_ISA_powerMap_mice = zeros(info.nVy,info.nVx,numMice);
%         powerdata_average_FADCorr_mice = [];
%         powerdata_FADCorr_mice = [];
    end
    %
    
    
    miceName = [];
    %     miceName_powerdata = [];
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
        %goodRuns = str2num(excelRaw{18});
        if strcmp(char(sessionInfo.miceType),'WT')
            systemInfo.numLEDs = 2;
        elseif strcmp(char(sessionInfo.miceType),'jrgeco1a')
            systemInfo.numLEDs = 3;
        end
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
        
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(run),'_processed.mat');
        
        if strcmp(sessionType,'fc')
            if strcmp(char(sessionInfo.miceType),'jrgeco1a')
                
                
                %
                load(fullfile(saveDir, processedName),'R_total_Delta','R_total_ISA','R_jrgeco1aCorr_Delta','R_jrgeco1aCorr_ISA','R_FADCorr_Delta','R_FADCorr_ISA',...
                    'Rs_total_Delta','Rs_total_ISA','Rs_jrgeco1aCorr_Delta','Rs_jrgeco1aCorr_ISA', 'Rs_FADCorr_Delta','Rs_FADCorr_ISA',...
                    'powerdata_average_oxy','powerdata_average_deoxy','powerdata_average_total','powerdata_average_jrgeco1aCorr','powerdata_average_FADCorr',...
                    'powerdata_oxy','powerdata_deoxy','powerdata_jrgeco1aCorr','powerdata_total','powerdata_FADCorr',...
                    'total_Delta_powerMap','total_ISA_powerMap','jrgeco1aCorr_Delta_powerMap','jrgeco1aCorr_ISA_powerMap', 'FADCorr_Delta_powerMap','FADCorr_ISA_powerMap',...
                    'hz','hz2')
                %
%                 R_total_Delta_mice(:,:,:,ll) = atanh(R_total_Delta);
%                 R_total_ISA_mice(:,:,:,ll) = atanh(R_total_ISA);
%                 Rs_total_Delta_mice(:,:,ll) = atanh(Rs_total_Delta);
%                 Rs_total_ISA_mice(:,:,ll) = atanh(Rs_total_ISA);
                total_Delta_powerMap_mice(:,:,ll) = total_Delta_powerMap;
                total_ISA_powerMap_mice(:,:,ll) = total_ISA_powerMap;
                %
                %                                 %
%                 %
%                 powerdata_average_oxy_mice = cat(2,powerdata_average_oxy_mice,squeeze(powerdata_average_oxy));
%                 powerdata_oxy_mice = cat(1,powerdata_oxy_mice,squeeze(powerdata_oxy));
%                 
%                 
%                 powerdata_average_deoxy_mice = cat(2,powerdata_average_deoxy_mice,squeeze(powerdata_average_deoxy));
%                 powerdata_deoxy_mice = cat(1,powerdata_deoxy_mice,squeeze(powerdata_deoxy));
%                 
%                 powerdata_average_total_mice = cat(2,powerdata_average_total_mice,squeeze(powerdata_average_total));
%                 powerdata_total_mice = cat(1,powerdata_total_mice,squeeze(powerdata_total));
%                 
%                 powerdata_average_jrgeco1aCorr_mice = cat(2,powerdata_average_jrgeco1aCorr_mice,squeeze(powerdata_average_jrgeco1aCorr));
%                 powerdata_jrgeco1aCorr_mice = cat(1,powerdata_jrgeco1aCorr_mice,squeeze(powerdata_jrgeco1aCorr));
%                 powerdata_average_FADCorr_mice = cat(2,powerdata_average_FADCorr_mice,squeeze(powerdata_average_FADCorr));
%                 powerdata_FADCorr_mice = cat(1,powerdata_FADCorr_mice,squeeze(powerdata_FADCorr));
%                 %
                %                                 % end
                %
%                 %
%                 R_jrgeco1aCorr_Delta_mice(:,:,:,ll) = atanh(R_jrgeco1aCorr_Delta);
%                 R_jrgeco1aCorr_ISA_mice(:,:,:,ll) = atanh(R_jrgeco1aCorr_ISA);
%                 Rs_jrgeco1aCorr_Delta_mice(:,:,ll) = atanh(Rs_jrgeco1aCorr_Delta);
%                 Rs_jrgeco1aCorr_ISA_mice(:,:,ll) = atanh(Rs_jrgeco1aCorr_ISA);
               jrgeco1aCorr_Delta_powerMap_mice(:,:,ll) = jrgeco1aCorr_Delta_powerMap;
                jrgeco1aCorr_ISA_powerMap_mice(:,:,ll) = jrgeco1aCorr_ISA_powerMap;
                
                
%                 R_FADCorr_Delta_mice(:,:,:,ll) = atanh(R_FADCorr_Delta);
%                 R_FADCorr_ISA_mice(:,:,:,ll) = atanh(R_FADCorr_ISA);
%                 Rs_FADCorr_Delta_mice(:,:,ll) = atanh(Rs_FADCorr_Delta);
%                 Rs_FADCorr_ISA_mice(:,:,ll) = atanh(Rs_FADCorr_ISA);
                FADCorr_Delta_powerMap_mice(:,:,ll) = FADCorr_Delta_powerMap;
                FADCorr_ISA_powerMap_mice(:,:,ll) = FADCorr_ISA_powerMap;
%                 %
%                 for ii = 1:2
%                     for jj = 1:2
%                         eval(strcat('load(fullfile(saveDir, processedName), ',char(39),lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),char(39),')'));
%                         eval(strcat(lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),'_mice(:,:,ll)','= ',lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),';'));
%                         
%                     end
%                 end
%                 
%                 for ii = 1:2
%                     for jj = 1:3
%                         for kk = 1:2
%                             eval(strcat('load(fullfile(saveDir, processedName), ',char(39),lagParaStrs(ii),'_GS_',traceStrs(jj),'_',bandStrs(kk),char(39),')'));
%                             eval(strcat(lagParaStrs(ii),'_GS_',traceStrs(jj),'_',bandStrs(kk),'_mice(:,:,ll)','= ',lagParaStrs(ii),'_GS_',traceStrs(jj),'_',bandStrs(kk),';'));
%                         end
%                     end
%                 end
%                 
                
            end
            ll = ll+1;
        end
    end
    processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,num2str(run),'.mat');
%     R_total_Delta_mice  = mean(R_total_Delta_mice,4);
%     R_total_ISA_mice  = mean(R_total_ISA_mice,4);
%     Rs_total_Delta_mice = mean(Rs_total_Delta_mice,3);
%     Rs_total_ISA_mice = mean(Rs_total_ISA_mice,3);
    total_Delta_powerMap_mice = mean(total_Delta_powerMap_mice,3);
    total_ISA_powerMap_mice = mean(total_ISA_powerMap_mice,3);
    
    
    %if goodRuns ~=0
%     powerdata_average_oxy_mice = mean(powerdata_average_oxy_mice,2);
%     powerdata_oxy_mice = mean(powerdata_oxy_mice,1);
%     
%     
%     powerdata_average_deoxy_mice = mean(powerdata_average_deoxy_mice,2);
%     powerdata_deoxy_mice = mean(powerdata_deoxy_mice,1);
%     
%     powerdata_average_total_mice = mean(powerdata_average_total_mice,2);
%     powerdata_total_mice = mean(powerdata_total_mice,1);
%     %
%     
%     powerdata_average_jrgeco1aCorr_mice = mean(powerdata_average_jrgeco1aCorr_mice,2);
%     powerdata_jrgeco1aCorr_mice = mean(powerdata_jrgeco1aCorr_mice,1);
%     
%     powerdata_average_FADCorr_mice = mean(powerdata_average_FADCorr_mice,2);
%     powerdata_FADCorr_mice = mean(powerdata_FADCorr_mice,1);
    %end
    
    
    %
%     
%     R_jrgeco1aCorr_Delta_mice = mean(R_jrgeco1aCorr_Delta_mice,4);
%     R_jrgeco1aCorr_ISA_mice  = mean(R_jrgeco1aCorr_ISA_mice,4);
%     Rs_jrgeco1aCorr_Delta_mice = mean(Rs_jrgeco1aCorr_Delta_mice,3);
%     Rs_jrgeco1aCorr_ISA_mice = mean(Rs_jrgeco1aCorr_ISA_mice,3);
%     
    jrgeco1aCorr_Delta_powerMap_mice = mean(jrgeco1aCorr_Delta_powerMap_mice,3);
    jrgeco1aCorr_ISA_powerMap_mice = mean(jrgeco1aCorr_ISA_powerMap_mice,3);
    
%     R_FADCorr_Delta_mice = mean(R_FADCorr_Delta_mice,4);
%     R_FADCorr_ISA_mice  = mean(R_FADCorr_ISA_mice,4);
%     Rs_FADCorr_Delta_mice = mean(Rs_FADCorr_Delta_mice,3);
%     Rs_FADCorr_ISA_mice = mean(Rs_FADCorr_ISA_mice,3);
    
    FADCorr_Delta_powerMap_mice = mean(FADCorr_Delta_powerMap_mice,3);
    FADCorr_ISA_powerMap_mice = mean(FADCorr_ISA_powerMap_mice,3);
      save(fullfile(saveDir_cat, processedName_mice),'total_ISA_powerMap_mice','jrgeco1aCorr_ISA_powerMap_mice','FADCorr_ISA_powerMap_mice',...
        'total_Delta_powerMap_mice','jrgeco1aCorr_Delta_powerMap_mice','FADCorr_Delta_powerMap_mice','-append')
    %   save(fullfile(saveDir_cat, processedName_mice),'powerdata_average_oxy_mice','powerdata_average_deoxy_mice','powerdata_average_total_mice','powerdata_average_jrgeco1aCorr_mice','powerdata_average_FADCorr_mice',...
    %             'powerdata_oxy_mice','powerdata_deoxy_mice','powerdata_total_mice','powerdata_jrgeco1aCorr_mice','powerdata_FADCorr_mice')
%     save(fullfile(saveDir_cat, processedName_mice),'R_total_ISA_mice','R_jrgeco1aCorr_ISA_mice','R_FADCorr_ISA_mice',...
%         'R_total_Delta_mice','R_jrgeco1aCorr_Delta_mice','R_FADCorr_Delta_mice',...
%         'Rs_total_ISA_mice','Rs_jrgeco1aCorr_ISA_mice','Rs_FADCorr_ISA_mice',...
%         'Rs_total_Delta_mice','Rs_jrgeco1aCorr_Delta_mice','Rs_FADCorr_Delta_mice',...
%         'powerdata_average_oxy_mice','powerdata_average_deoxy_mice','powerdata_average_total_mice','powerdata_average_jrgeco1aCorr_mice','powerdata_average_FADCorr_mice',...
%         'powerdata_oxy_mice','powerdata_deoxy_mice','powerdata_total_mice','powerdata_jrgeco1aCorr_mice','powerdata_FADCorr_mice',...
%         'total_ISA_powerMap_mice','jrgeco1aCorr_ISA_powerMap_mice','FADCorr_ISA_powerMap_mice',...
%         'total_Delta_powerMap_mice','jrgeco1aCorr_Delta_powerMap_mice','FADCorr_Delta_powerMap_mice',...
%         'hz','xform_isbrain_mice','-append')
    
%     for ii = 1:2
%         for jj = 1:2
%             for mm = 1:2
%                 
%                 eval(strcat(lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),'_mice_',avgWayStrs(mm),'= nan',avgWayStrs(mm),'(',lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),'_mice,3);'));
%                 eval(strcat('save(fullfile(saveDir_cat,processedName_mice), ',char(39),lagParaStrs(ii),'Trial_',lagSpeciesStrs(jj),'_mice_',avgWayStrs(mm),char(39),',',char(39),'-append',char(39),')'));
%             end
%             
%         end
%     end
%     
%     for ii = 1:2
%         for jj = 1:3
%             for kk = 1:2
%                 for mm = 1:2
%                     eval(strcat(lagParaStrs(ii),'_GS_',traceStrs(jj),'_',bandStrs(kk),'_mice_',avgWayStrs(mm),'= nan',avgWayStrs(mm),'(',lagParaStrs(ii),'_GS_',traceStrs(jj),'_',bandStrs(kk),'_mice,3);'));
%                     eval(strcat('save(fullfile(saveDir_cat,processedName_mice), ',char(39),lagParaStrs(ii),'_GS_',traceStrs(jj),'_',bandStrs(kk),'_mice_',avgWayStrs(mm),char(39),',',char(39),'-append',char(39),')'));
%                 end
%             end
%         end
%     end
%     %
%     
%     
%     
%     
%     for ii = 1:2
%         figure;
%         colormap jet;
%         subplot(2,2,1); eval(strcat('imagesc(lagTimeTrial_HbTCalcium_mice_',avgWayStrs(ii),',tLim);')); axis image off;h = colorbar;ylabel(h,'t(s)');title('HbT Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%         subplot(2,2,2); eval(strcat('imagesc(lagTimeTrial_FADCalcium_mice_',avgWayStrs(ii),',[0 0.2]);'));axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%         subplot(2,2,3); eval(strcat('imagesc(lagAmpTrial_HbTCalcium_mice_',avgWayStrs(ii),',rLim);'));axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%         subplot(2,2,4);  eval(strcat('imagesc(lagAmpTrial_FADCalcium_mice_',avgWayStrs(ii),',rLim);'));axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%         suptitle(strcat(recDate,'-',miceCat,'-',sessionType,num2str(run),', ',avgWayStrs(ii) ))
%         
%         
%         saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,num2str(run),'_Lag_',avgWayStrs(ii),'.png')));
%         saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,num2str(run),'_Lag_',avgWayStrs(ii),'.fig')));
%     end
%     
%     
%     
%     
%     
%     %
%     for ii = 1:2
%         for jj = 1:2
%             figure;colormap jet;
%             subplot(2,3,1); eval(strcat('imagesc(lagTime_GS_Calcium_',bandStrs(ii),'_mice_',avgWayStrs(jj),',tLim_',bandStrs(ii),');'));
%             axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%             
%             subplot(2,3,2); eval(strcat('imagesc(lagTime_GS_FAD_',bandStrs(ii),'_mice_',avgWayStrs(jj),',tLim_',bandStrs(ii),');'));
%             axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%             
%             
%             subplot(2,3,3); eval(strcat('imagesc(lagTime_GS_total_',bandStrs(ii),'_mice_',avgWayStrs(jj),',tLim_',bandStrs(ii),');'));
%             axis image off;h = colorbar;ylabel(h,'t(s)');title('Total');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%             
%             subplot(2,3,4); eval(strcat('imagesc(lagAmp_GS_Calcium_',bandStrs(ii),'_mice_',avgWayStrs(jj),',rLim);'));
%             axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%             
%             subplot(2,3,5); eval(strcat('imagesc(lagAmp_GS_FAD_',bandStrs(ii),'_mice_',avgWayStrs(jj),',rLim);'));
%             axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%             
%             subplot(2,3,6); eval(strcat('imagesc(lagAmp_GS_total_',bandStrs(ii),'_mice_',avgWayStrs(jj),',rLim);'));
%             axis image off;h = colorbar;ylabel(h,'t(s)');hold on;imagesc(xform_WL,'AlphaData',1-mask);set(gca,'FontSize',14,'FontWeight','Bold')
%             
%             suptitle(strcat(recDate,'-',miceCat,'-',sessionType,num2str(run),'Lag with GS, ',bandStrs(ii),',',avgWayStrs(jj) ))
%             saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,num2str(run),'_LagGS_',bandStrs(ii),'_',avgWayStrs(jj),'.png')));
%             saveas(gcf,fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-',sessionType,num2str(run),'_LagGS_',bandStrs(ii),'_',avgWayStrs(jj),'.fig')));
%             
%             
%         end
%     end
%     
%     
%     
%     
%     
%     
%     
%     
%     disp(char(['QC check on ', processedName_mice]))
%     
%     visName = strcat(miceName,"-",sessionType,num2str(run));
%     %if goodRuns ~=0
%     
%     
%     leftData = cell(2,1);
%     leftData{1} = powerdata_jrgeco1aCorr_mice;
%     leftData{2} = powerdata_FADCorr_mice;
%     
%     rightData = cell(3,1);
%     rightData{1} = powerdata_oxy_mice;
%     rightData{2} = powerdata_deoxy_mice;
%     rightData{3} = powerdata_total_mice;
%     
%     leftLabel = 'Fluor(\DeltaF/F%)^2/Hz)';
%     rightLabel = 'Hb(\muM^2/Hz)';
%     leftLineStyle = {'m-','g-'};
%     rightLineStyle= {'r-','b-','k-'};
%     legendName = ["Corrected jRGECO1a","Corrected FAD","HbO","HbR","HbT"];
%     
%     QCcheck_fftVis(hz, leftData,rightData,leftLabel,rightLabel,leftLineStyle,rightLineStyle,legendName,saveDir_cat,strcat(miceName, '_powerCurve'))
%     
%     
%     
%     leftData = cell(2,1);
%     leftData{1} = powerdata_average_jrgeco1aCorr_mice;
%     
%     leftData{2} = powerdata_average_FADCorr_mice;
%     
%     rightData = cell(3,1);
%     rightData{1} = powerdata_average_oxy_mice;
%     rightData{2} = powerdata_average_deoxy_mice;
%     rightData{3} = powerdata_average_total_mice;
%     
%     leftLabel = 'Fluor(\DeltaF/F%)^2/Hz)';
%     rightLabel = 'Hb(\muM^2/Hz)';
%     leftLineStyle = {'m-','g-'};
%     rightLineStyle= {'r-','b-','k-'};
%     legendName = ["Corrected jRGECO1a","Corrected FAD","HbO","HbR","HbT"];
%     QCcheck_fftVis(hz, leftData,rightData,leftLabel,rightLabel,leftLineStyle,rightLineStyle,legendName,saveDir_cat,strcat(visName, '_powerCurve_average'))
%     
%     
%     %
%     %     %
%     refseeds=GetReferenceSeeds;
%     refseeds = refseeds(1:14,:);
%     refseeds(3,1) = 42;
%     refseeds(3,2) = 88;
%     refseeds(4,1) = 87;
%     refseeds(4,2) = 88;
%     refseeds(9,1) = 18;
%     refseeds(9,2) = 66;
%     refseeds(10,1) = 111;
%     refseeds(10,2) = 66;
%     
%     QCcheck_fcVis(refseeds,R_jrgeco1aCorr_ISA_mice, Rs_jrgeco1aCorr_ISA_mice(1:14,1:14),'jrgeco1aCorr','m','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
%     QCcheck_fcVis(refseeds,R_FADCorr_ISA_mice, Rs_FADCorr_ISA_mice(1:14,1:14),'FADCorr','g','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
%     QCcheck_fcVis(refseeds,R_total_ISA_mice, Rs_total_ISA_mice(1:14,1:14),'total','k','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
%     
%     QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_mice, Rs_jrgeco1aCorr_Delta_mice(1:14,1:14),'jrgeco1aCorr','m','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
%     QCcheck_fcVis(refseeds,R_FADCorr_Delta_mice, Rs_FADCorr_Delta_mice(1:14,1:14),'FADCorr','g','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
%     QCcheck_fcVis(refseeds,R_total_Delta_mice, Rs_total_Delta_mice(1:14,1:14),'total','k','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
%     %
%     QCcheck_powerMapVis(jrgeco1aCorr_ISA_powerMap_mice,xform_isbrain_mice,'(\DeltaF/F%)',saveDir_cat,strcat(visName, '_RGECOISA'))
%     QCcheck_powerMapVis(FADCorr_ISA_powerMap_mice,xform_isbrain_mice,'(\DeltaF/F%)',saveDir_cat,strcat(visName, '_FADISA'))
%     QCcheck_powerMapVis(total_ISA_powerMap_mice,xform_isbrain_mice,'\muM',saveDir_cat,strcat(visName, "_TotalISA"))
%     
%     QCcheck_powerMapVis(jrgeco1aCorr_Delta_powerMap_mice,xform_isbrain_mice,'(\DeltaF/F%)',saveDir_cat,strcat(visName, "_RGECODelta"))
%     QCcheck_powerMapVis(FADCorr_Delta_powerMap_mice,xform_isbrain_mice,'(\DeltaF/F%)',saveDir_cat,strcat(visName,"_FADDelta"))
%     QCcheck_powerMapVis(total_Delta_powerMap_mice,xform_isbrain_mice,'\muM',saveDir_cat,strcat(visName,"_TotalDelta"))
%     %
%     
%     close all
    saveDir_cat ='K:\Glucose\cat\';
visName = 'Glucose_SeedFC-fc-baseline';
figure('units','normalized','outerposition',[0 0 0.5 0.7]);
subplot(2,3,1)
powerMapVis(jrgeco1aCorr_ISA_powerMap_mice,'(\DeltaF/F%)',-2,-1)
title('Corr jRGECO1a')

subplot(2,3,2)


powerMapVis(FADCorr_ISA_powerMap_mice,'(\DeltaF/F%)',-3.1,-2.1)
title('Corr FAD')

subplot(2,3,3)

powerMapVis(total_ISA_powerMap_mice,'(\muM)',-1.7,-0.7)

title('Total')

subplot(2,3,4)
powerMapVis(jrgeco1aCorr_Delta_powerMap_mice,'(\DeltaF/F%)',-3.5,-2.5)


subplot(2,3,5)

powerMapVis(FADCorr_Delta_powerMap_mice,'(\DeltaF/F%)',-4.7,-3.7)


subplot(2,3,6)
powerMapVis(total_Delta_powerMap_mice,'(\muM)',-4,-3)

suptitle(strcat('Glucose Power Map for fc',num2str(run)))

saveas(gcf,strcat('K:\Glucose\cat\Glucose_PowerMap-fc',num2str(run),'.png'));
saveas(gcf,strcat('K:\Glucose\cat\Glucose_PowerMap-fc',num2str(run),'.fig'));

    
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




