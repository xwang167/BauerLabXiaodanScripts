close all
% excelRows = [181 183 185 228 232 236];
% excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
% nVy = 128;
% mm=10;
% mpp=mm/nVy;
% seedradmm=0.25;
% seedradpix=seedradmm/mpp;
% refseeds=GetReferenceSeeds_xw;
% contrast = ["jrgeco1aCorr","FADCorr","total"];
% freqBand = {'ISA','Delta'};
% pos = 1.0e+03 * [2.0898,0.1474, 0.9080, 0.4200];
% for ii = 1:3
%     for jj = 1:2
%         eval(strcat('CL_R_',contrast(ii),'_',freqBand(jj),'_mice = nan(1,6);'));
%         eval(strcat('ML_R_',contrast(ii),'_',freqBand(jj),'_mice = nan(1,6);'));
%         eval(strcat('SSL_R_',contrast(ii),'_',freqBand(jj),'_mice = nan(1,6);'));
%         eval(strcat('RSL_R_',contrast(ii),'_',freqBand(jj),'_mice = nan(1,6);'));
%         eval(strcat('PL_R_',contrast(ii),'_',freqBand(jj),'_mice = nan(1,6);'));
%         eval(strcat('VL_R_',contrast(ii),'_',freqBand(jj),'_mice = nan(1,6);'))
%         eval(strcat('SSL_ML_',contrast(ii),'_',freqBand(jj),'_mice = nan(1,6);'));
%     end
% end
% ll = 1;
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     sessionInfo.darkFrameNum = excelRaw{15};
%     sessionInfo.mouseType = excelRaw{17};
%     systemType =excelRaw{5};
%     saveDir_new = strcat('L:\RGECO\Kenny\', recDate, '\');
%     maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datafluor','.mat');
%     
%     if ~exist(fullfile(saveDir_new,maskName),'file')
%         maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
%         load(fullfile(saveDir,maskName),'xform_isbrain')
%     else
%         load(fullfile(saveDir_new,maskName),'xform_isbrain');
%     end
%     P=burnseeds(refseeds,seedradpix,xform_isbrain);
%     processedName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');
%     load(fullfile(saveDir,processedName),'Rs_total_Delta_mouse','Rs_total_ISA_mouse',...
%         'Rs_jrgeco1aCorr_Delta_mouse','Rs_jrgeco1aCorr_ISA_mouse',...
%         'Rs_FADCorr_Delta_mouse','Rs_FADCorr_ISA_mouse')
%     C_R = P==4;
%     M_R = P == 6;
%     SS_R = P == 8;
%     RS_R = P == 10;
%     P_R = P == 12;
%     V_R = P == 13;
%     
%     M_L = P==5;
%     
%     for ii = 1:3
%         for jj = 1:2
%             eval(strcat('CL_R_',contrast(ii),'_',freqBand(jj),'_mouse = Rs_',contrast(ii), '_',freqBand(jj),'_mouse(3,11);'));
%             eval(strcat('CL_R_',contrast(ii),'_',freqBand(jj),'_mice(ll) = atanh(CL_R_',contrast(ii),'_',freqBand(jj),'_mouse);'));
%             
%             eval(strcat('ML_R_',contrast(ii),'_',freqBand(jj),'_mouse = Rs_',contrast(ii), '_',freqBand(jj),'_mouse(2,10);'));
%             eval(strcat('ML_R_',contrast(ii),'_',freqBand(jj),'_mice(ll) = atanh(ML_R_',contrast(ii),'_',freqBand(jj),'_mouse);'));
%             
%             eval(strcat('SSL_R_',contrast(ii),'_',freqBand(jj),'_mouse = Rs_',contrast(ii), '_',freqBand(jj),'_mouse(4,12);'));
%             eval(strcat('SSL_R_',contrast(ii),'_',freqBand(jj),'_mice(ll) = atanh(SSL_R_',contrast(ii),'_',freqBand(jj),'_mouse);'));
%             
%             eval(strcat('RSL_R_',contrast(ii),'_',freqBand(jj),'_mouse = Rs_',contrast(ii), '_',freqBand(jj),'_mouse(6,14);'));
%             eval(strcat('RSL_R_',contrast(ii),'_',freqBand(jj),'_mice(ll) = atanh(RSL_R_',contrast(ii),'_',freqBand(jj),'_mouse);'));
%             
%             eval(strcat('PL_R_',contrast(ii),'_',freqBand(jj),'_mouse = Rs_',contrast(ii), '_',freqBand(jj),'_mouse(5,13);'));
%             eval(strcat('PL_R_',contrast(ii),'_',freqBand(jj),'_mice(ll) = atanh(PL_R_',contrast(ii),'_',freqBand(jj),'_mouse);'));
%             
%             eval(strcat('VL_R_',contrast(ii),'_',freqBand(jj),'_mouse = Rs_',contrast(ii), '_',freqBand(jj),'_mouse(8,16);'));
%             eval(strcat('VL_R_',contrast(ii),'_',freqBand(jj),'_mice(ll) = atanh(VL_R_',contrast(ii),'_',freqBand(jj),'_mouse);'));
%             
%             eval(strcat('SSL_ML_',contrast(ii),'_',freqBand(jj),'_mouse = Rs_',contrast(ii), '_',freqBand(jj),'_mouse(4,2);'));
%             eval(strcat('SSL_ML_',contrast(ii),'_',freqBand(jj),'_mice(ll) = atanh(SSL_ML_',contrast(ii),'_',freqBand(jj),'_mouse);'));
%         end
%     end
%     
%     ll = ll + 1;
% end
% model_series = [mean(CL_R_jrgeco1aCorr_ISA_mice),mean(CL_R_FADCorr_ISA_mice),mean(CL_R_total_ISA_mice);
%     mean(ML_R_jrgeco1aCorr_ISA_mice),mean(ML_R_FADCorr_ISA_mice),mean(ML_R_total_ISA_mice);
%     mean(SSL_R_jrgeco1aCorr_ISA_mice),mean(SSL_R_FADCorr_ISA_mice),mean(SSL_R_total_ISA_mice);
%     mean(RSL_R_jrgeco1aCorr_ISA_mice),mean(RSL_R_FADCorr_ISA_mice),mean(RSL_R_total_ISA_mice);
%     mean(PL_R_jrgeco1aCorr_ISA_mice),mean(PL_R_FADCorr_ISA_mice),mean(PL_R_total_ISA_mice);
%     mean(VL_R_jrgeco1aCorr_ISA_mice),mean(VL_R_FADCorr_ISA_mice),mean(VL_R_total_ISA_mice);
%     mean(SSL_ML_jrgeco1aCorr_ISA_mice),mean(SSL_ML_FADCorr_ISA_mice),mean(SSL_ML_total_ISA_mice)];
% 
% model_error = [std(CL_R_jrgeco1aCorr_ISA_mice),std(CL_R_FADCorr_ISA_mice),std(CL_R_total_ISA_mice);
%     std(ML_R_jrgeco1aCorr_ISA_mice),std(ML_R_FADCorr_ISA_mice),std(ML_R_total_ISA_mice);
%     std(SSL_R_jrgeco1aCorr_ISA_mice),std(SSL_R_FADCorr_ISA_mice),std(SSL_R_total_ISA_mice);
%     std(RSL_R_jrgeco1aCorr_ISA_mice),std(RSL_R_FADCorr_ISA_mice),std(RSL_R_total_ISA_mice);
%     std(PL_R_jrgeco1aCorr_ISA_mice),std(PL_R_FADCorr_ISA_mice),std(PL_R_total_ISA_mice);
%     std(VL_R_jrgeco1aCorr_ISA_mice),std(VL_R_FADCorr_ISA_mice),std(VL_R_total_ISA_mice);
%     std(SSL_ML_jrgeco1aCorr_ISA_mice),std(SSL_ML_FADCorr_ISA_mice),std(SSL_ML_total_ISA_mice)];
% 
% [h_CL_R_ISA_CalciumFAD,p_CL_R_ISA_CalciumFAD] = ttest(CL_R_jrgeco1aCorr_ISA_mice,CL_R_FADCorr_ISA_mice);
% [h_CL_R_ISA_CalciumHbT,p_CL_R_ISA_CalciumHbT] = ttest(CL_R_jrgeco1aCorr_ISA_mice,CL_R_total_ISA_mice);
% [h_CL_R_ISA_FADHbT,p_CL_R_ISA_FADHbT] = ttest(CL_R_FADCorr_ISA_mice,CL_R_total_ISA_mice);
% 
% [h_ML_R_ISA_CalciumFAD,p_ML_R_ISA_CalciumFAD] = ttest(ML_R_jrgeco1aCorr_ISA_mice,ML_R_FADCorr_ISA_mice);
% [h_ML_R_ISA_CalciumHbT,p_ML_R_ISA_CalciumHbT] = ttest(ML_R_jrgeco1aCorr_ISA_mice,ML_R_total_ISA_mice);
% [h_ML_R_ISA_FADHbT,p_ML_R_ISA_FADHbT] = ttest(ML_R_FADCorr_ISA_mice,ML_R_total_ISA_mice);
% 
% [h_SSL_R_ISA_CalciumFAD,p_SSL_R_ISA_CalciumFAD] = ttest(SSL_R_jrgeco1aCorr_ISA_mice,SSL_R_FADCorr_ISA_mice);
% [h_SSL_R_ISA_CalciumHbT,p_SSL_R_ISA_CalciumHbT] = ttest(SSL_R_jrgeco1aCorr_ISA_mice,SSL_R_total_ISA_mice);
% [h_SSL_R_ISA_FADHbT,p_SSL_R_ISA_FADHbT] = ttest(SSL_R_FADCorr_ISA_mice,SSL_R_total_ISA_mice);
% 
% [h_RSL_R_ISA_CalciumFAD,p_RSL_R_ISA_CalciumFAD] = ttest(RSL_R_jrgeco1aCorr_ISA_mice,RSL_R_FADCorr_ISA_mice);
% [h_RSL_R_ISA_CalciumHbT,p_RSL_R_ISA_CalciumHbT] = ttest(RSL_R_jrgeco1aCorr_ISA_mice,RSL_R_total_ISA_mice);
% [h_RSL_R_ISA_FADHbT,p_RSL_R_ISA_FADHbT] = ttest(RSL_R_FADCorr_ISA_mice,RSL_R_total_ISA_mice);
% 
% [h_PL_R_ISA_CalciumFAD,p_PL_R_ISA_CalciumFAD] = ttest(PL_R_jrgeco1aCorr_ISA_mice,PL_R_FADCorr_ISA_mice);
% [h_PL_R_ISA_CalciumHbT,p_PL_R_ISA_CalciumHbT] = ttest(PL_R_jrgeco1aCorr_ISA_mice,PL_R_total_ISA_mice);
% [h_PL_R_ISA_FADHbT,p_PL_R_ISA_FADHbT] = ttest(PL_R_FADCorr_ISA_mice,PL_R_total_ISA_mice);
% 
% [h_VL_R_ISA_CalciumFAD,p_VL_R_ISA_CalciumFAD] = ttest(VL_R_jrgeco1aCorr_ISA_mice,VL_R_FADCorr_ISA_mice);
% [h_VL_R_ISA_CalciumHbT,p_VL_R_ISA_CalciumHbT] = ttest(VL_R_jrgeco1aCorr_ISA_mice,VL_R_total_ISA_mice);
% [h_VL_R_ISA_FADHbT,p_VL_R_ISA_FADHbT] = ttest(VL_R_FADCorr_ISA_mice,VL_R_total_ISA_mice);
% 
% [h_SSL_ML_ISA_CalciumFAD,p_SSL_ML_ISA_CalciumFAD] = ttest(SSL_ML_jrgeco1aCorr_ISA_mice,SSL_ML_FADCorr_ISA_mice);
% [h_SSL_ML_ISA_CalciumHbT,p_SSL_ML_ISA_CalciumHbT] = ttest(SSL_ML_jrgeco1aCorr_ISA_mice,SSL_ML_total_ISA_mice);
% [h_SSL_ML_ISA_FADHbT,p_SSL_ML_ISA_FADHbT] = ttest(SSL_ML_FADCorr_ISA_mice,SSL_ML_total_ISA_mice);
% 
% figure('position',pos)
% b = bar(model_series,'grouped');
% b(1).FaceColor = 'm';
% b(2).FaceColor = 'g';
% b(3).FaceColor = 'k';
% hold on
% [ngroups,nbars] = size(model_series);
% x = nan(nbars, ngroups);
% for i = 1:nbars
%     x(i,:) = b(i).XEndPoints;
% end
% errorbar(x',model_series,zeros(7,3),model_error,'k','linestyle','none');
% hold off
% ylabel('Correlation')
% legend('jRGECO1a','FAD','HbT')
% ylim([0 2.5])
% xticklabels({'C','M','SS','RS','P','V','SSL-ML'})
% %set(gca,'TickLength',[0 .01])
% set(gca,'FontSize',14,'FontWeight','Bold')
% legend('jRGECO1a','FAD','HbT','FontSize',8)
% %breakyaxis([0.1 0.55])
% title('Awake, ISA')
% sigstar({[x(1,2),x(2,2)]},p_ML_R_ISA_CalciumFAD,0,3)
% sigstar({[x(1,5),x(3,5)]},p_PL_R_ISA_CalciumHbT,0,3)
% 
% 
% model_series = [mean(CL_R_jrgeco1aCorr_Delta_mice),mean(CL_R_FADCorr_Delta_mice),mean(CL_R_total_Delta_mice);
%     mean(ML_R_jrgeco1aCorr_Delta_mice),mean(ML_R_FADCorr_Delta_mice),mean(ML_R_total_Delta_mice);
%     mean(SSL_R_jrgeco1aCorr_Delta_mice),mean(SSL_R_FADCorr_Delta_mice),mean(SSL_R_total_Delta_mice);
%     mean(RSL_R_jrgeco1aCorr_Delta_mice),mean(RSL_R_FADCorr_Delta_mice),mean(RSL_R_total_Delta_mice);
%     mean(PL_R_jrgeco1aCorr_Delta_mice),mean(PL_R_FADCorr_Delta_mice),mean(PL_R_total_Delta_mice);
%     mean(VL_R_jrgeco1aCorr_Delta_mice),mean(VL_R_FADCorr_Delta_mice),mean(VL_R_total_Delta_mice);
%     mean(SSL_ML_jrgeco1aCorr_Delta_mice),mean(SSL_ML_FADCorr_Delta_mice),mean(SSL_ML_total_Delta_mice)];
% 
% model_error = [std(CL_R_jrgeco1aCorr_Delta_mice),std(CL_R_FADCorr_Delta_mice),std(CL_R_total_Delta_mice);
%     std(ML_R_jrgeco1aCorr_Delta_mice),std(ML_R_FADCorr_Delta_mice),std(ML_R_total_Delta_mice);
%     std(SSL_R_jrgeco1aCorr_Delta_mice),std(SSL_R_FADCorr_Delta_mice),std(SSL_R_total_Delta_mice);
%     std(RSL_R_jrgeco1aCorr_Delta_mice),std(RSL_R_FADCorr_Delta_mice),std(RSL_R_total_Delta_mice);
%     std(PL_R_jrgeco1aCorr_Delta_mice),std(PL_R_FADCorr_Delta_mice),std(PL_R_total_Delta_mice);
%     std(VL_R_jrgeco1aCorr_Delta_mice),std(VL_R_FADCorr_Delta_mice),std(VL_R_total_Delta_mice);
%     std(SSL_ML_jrgeco1aCorr_Delta_mice),std(SSL_ML_FADCorr_Delta_mice),std(SSL_ML_total_Delta_mice)];
% 
% [h_CL_R_Delta_CalciumFAD,p_CL_R_Delta_CalciumFAD] = ttest(CL_R_jrgeco1aCorr_Delta_mice,CL_R_FADCorr_Delta_mice);
% [h_CL_R_Delta_CalciumHbT,p_CL_R_Delta_CalciumHbT] = ttest(CL_R_jrgeco1aCorr_Delta_mice,CL_R_total_Delta_mice);
% [h_CL_R_Delta_FADHbT,p_CL_R_Delta_FADHbT] = ttest(CL_R_FADCorr_Delta_mice,CL_R_total_Delta_mice);
% 
% [h_ML_R_Delta_CalciumFAD,p_ML_R_Delta_CalciumFAD] = ttest(ML_R_jrgeco1aCorr_Delta_mice,ML_R_FADCorr_Delta_mice);
% [h_ML_R_Delta_CalciumHbT,p_ML_R_Delta_CalciumHbT] = ttest(ML_R_jrgeco1aCorr_Delta_mice,ML_R_total_Delta_mice);
% [h_ML_R_Delta_FADHbT,p_ML_R_Delta_FADHbT] = ttest(ML_R_FADCorr_Delta_mice,ML_R_total_Delta_mice);
% 
% [h_SSL_R_Delta_CalciumFAD,p_SSL_R_Delta_CalciumFAD] = ttest(SSL_R_jrgeco1aCorr_Delta_mice,SSL_R_FADCorr_Delta_mice);
% [h_SSL_R_Delta_CalciumHbT,p_SSL_R_Delta_CalciumHbT] = ttest(SSL_R_jrgeco1aCorr_Delta_mice,SSL_R_total_Delta_mice);
% [h_SSL_R_Delta_FADHbT,p_SSL_R_Delta_FADHbT] = ttest(SSL_R_FADCorr_Delta_mice,SSL_R_total_Delta_mice);
% 
% [h_RSL_R_Delta_CalciumFAD,p_RSL_R_Delta_CalciumFAD] = ttest(RSL_R_jrgeco1aCorr_Delta_mice,RSL_R_FADCorr_Delta_mice);
% [h_RSL_R_Delta_CalciumHbT,p_RSL_R_Delta_CalciumHbT] = ttest(RSL_R_jrgeco1aCorr_Delta_mice,RSL_R_total_Delta_mice);
% [h_RSL_R_Delta_FADHbT,p_RSL_R_Delta_FADHbT] = ttest(RSL_R_FADCorr_Delta_mice,RSL_R_total_Delta_mice);
% 
% [h_PL_R_Delta_CalciumFAD,p_PL_R_Delta_CalciumFAD] = ttest(PL_R_jrgeco1aCorr_Delta_mice,PL_R_FADCorr_Delta_mice);
% [h_PL_R_Delta_CalciumHbT,p_PL_R_Delta_CalciumHbT] = ttest(PL_R_jrgeco1aCorr_Delta_mice,PL_R_total_Delta_mice);
% [h_PL_R_Delta_FADHbT,p_PL_R_Delta_FADHbT] = ttest(PL_R_FADCorr_Delta_mice,PL_R_total_Delta_mice);
% 
% [h_VL_R_Delta_CalciumFAD,p_VL_R_Delta_CalciumFAD] = ttest(VL_R_jrgeco1aCorr_Delta_mice,VL_R_FADCorr_Delta_mice);
% [h_VL_R_Delta_CalciumHbT,p_VL_R_Delta_CalciumHbT] = ttest(VL_R_jrgeco1aCorr_Delta_mice,VL_R_total_Delta_mice);
% [h_VL_R_Delta_FADHbT,p_VL_R_Delta_FADHbT] = ttest(VL_R_FADCorr_Delta_mice,VL_R_total_Delta_mice);
% 
% [h_SSL_ML_Delta_CalciumFAD,p_SSL_ML_Delta_CalciumFAD] = ttest(SSL_ML_jrgeco1aCorr_Delta_mice,SSL_ML_FADCorr_Delta_mice);
% [h_SSL_ML_Delta_CalciumHbT,p_SSL_ML_Delta_CalciumHbT] = ttest(SSL_ML_jrgeco1aCorr_Delta_mice,SSL_ML_total_Delta_mice);
% [h_SSL_ML_Delta_FADHbT,p_SSL_ML_Delta_FADHbT] = ttest(SSL_ML_FADCorr_Delta_mice,SSL_ML_total_Delta_mice);
% 
% 
% figure('position',pos)
% b = bar(model_series,'grouped');
% b(1).FaceColor = 'm';
% b(2).FaceColor = 'g';
% b(3).FaceColor = 'k';
% hold on
% [ngroups,nbars] = size(model_series);
% x = nan(nbars, ngroups);
% for i = 1:nbars
%     x(i,:) = b(i).XEndPoints;
% end
% errorbar(x',model_series,zeros(7,3),model_error,'k','linestyle','none');
% hold off
% ylabel('Correlation')
% ylim([0 2.5])
% xticklabels({'C','M','SS','RS','P','V','SSL-ML'})
% %set(gca,'TickLength',[0 .01])
% set(gca,'FontSize',14,'FontWeight','Bold')
% %breakyaxis([0.1 0.55])
% title('Awake, Delta')
% 
% sigstar({[x(1,1),x(2,1)]},p_CL_R_Delta_CalciumFAD,0,3)
% sigstar({[x(2,1),x(3,1)]},p_CL_R_Delta_FADHbT,0,3)
% 
% sigstar({[x(1,2),x(2,2)]},p_ML_R_Delta_CalciumFAD,0,3)
% sigstar({[x(2,2),x(3,2)]},p_ML_R_Delta_FADHbT,0,3)
% 
% sigstar({[x(2,3),x(3,3)]},p_SSL_R_Delta_FADHbT,0,3)
% 
% sigstar({[x(1,4),x(2,4)]},p_RSL_R_Delta_CalciumFAD,0,3)
% sigstar({[x(1,4),x(3,4)]},p_RSL_R_Delta_CalciumHbT,0,3)
% 
% 
% sigstar({[x(1,5),x(2,5)]},p_PL_R_Delta_CalciumFAD,0,3)
% sigstar({[x(2,5),x(3,5)]},p_PL_R_Delta_FADHbT,0,3)
% 
% sigstar({[x(1,6),x(2,6)]},p_VL_R_Delta_CalciumFAD,0,3)
% 
% sigstar({[x(1,7),x(2,7)]},p_SSL_ML_Delta_CalciumFAD,0,3)
% 
% 
% 


excelRows = [195 202 204 230 234 240];
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
nVy = 128;
mm=10;
mpp=mm/nVy;
seedradmm=0.25;
seedradpix=seedradmm/mpp;
refseeds=GetReferenceSeeds_xw;
contrast = ["jrgeco1aCorr","FADCorr","total"];
freqBand = {'ISA','Delta'};

for ii = 1:3
    for jj = 1:2
        eval(strcat('CL_R_',contrast(ii),'_',freqBand(jj),'_mice = nan(1,6);'));
        eval(strcat('ML_R_',contrast(ii),'_',freqBand(jj),'_mice = nan(1,6);'));
        eval(strcat('SSL_R_',contrast(ii),'_',freqBand(jj),'_mice = nan(1,6);'));
        eval(strcat('RSL_R_',contrast(ii),'_',freqBand(jj),'_mice = nan(1,6);'));
        eval(strcat('PL_R_',contrast(ii),'_',freqBand(jj),'_mice = nan(1,6);'));
        eval(strcat('VL_R_',contrast(ii),'_',freqBand(jj),'_mice = nan(1,6);'))
        eval(strcat('SSL_ML_',contrast(ii),'_',freqBand(jj),'_mice = nan(1,6);'));
    end
end
ll = 1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    saveDir_new = strcat('L:\RGECO\Kenny\', recDate, '\');
    maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datafluor','.mat');
    
    if ~exist(fullfile(saveDir_new,maskName),'file')
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(saveDir,maskName),'xform_isbrain')
    else
        load(fullfile(saveDir_new,maskName),'xform_isbrain');
    end
    P=burnseeds(refseeds,seedradpix,xform_isbrain);
    processedName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');
    load(fullfile(saveDir,processedName),'Rs_total_Delta_mouse','Rs_total_ISA_mouse',...
        'Rs_jrgeco1aCorr_Delta_mouse','Rs_jrgeco1aCorr_ISA_mouse',...
        'Rs_FADCorr_Delta_mouse','Rs_FADCorr_ISA_mouse')
    C_R = P==4;
    M_R = P == 6;
    SS_R = P == 8;
    RS_R = P == 10;
    P_R = P == 12;
    V_R = P == 13;
    M_L = P==5;
    
 
    for ii = 1:3
        for jj = 1:2
            eval(strcat('CL_R_',contrast(ii),'_',freqBand(jj),'_mouse = Rs_',contrast(ii), '_',freqBand(jj),'_mouse(3,11);'));
            eval(strcat('CL_R_',contrast(ii),'_',freqBand(jj),'_mice(ll) = atanh(CL_R_',contrast(ii),'_',freqBand(jj),'_mouse);'));
            
            eval(strcat('ML_R_',contrast(ii),'_',freqBand(jj),'_mouse = Rs_',contrast(ii), '_',freqBand(jj),'_mouse(2,10);'));
            eval(strcat('ML_R_',contrast(ii),'_',freqBand(jj),'_mice(ll) = atanh(ML_R_',contrast(ii),'_',freqBand(jj),'_mouse);'));
            
            eval(strcat('SSL_R_',contrast(ii),'_',freqBand(jj),'_mouse = Rs_',contrast(ii), '_',freqBand(jj),'_mouse(4,12);'));
            eval(strcat('SSL_R_',contrast(ii),'_',freqBand(jj),'_mice(ll) = atanh(SSL_R_',contrast(ii),'_',freqBand(jj),'_mouse);'));
            
            eval(strcat('RSL_R_',contrast(ii),'_',freqBand(jj),'_mouse = Rs_',contrast(ii), '_',freqBand(jj),'_mouse(6,14);'));
            eval(strcat('RSL_R_',contrast(ii),'_',freqBand(jj),'_mice(ll) = atanh(RSL_R_',contrast(ii),'_',freqBand(jj),'_mouse);'));
            
            eval(strcat('PL_R_',contrast(ii),'_',freqBand(jj),'_mouse = Rs_',contrast(ii), '_',freqBand(jj),'_mouse(5,13);'));
            eval(strcat('PL_R_',contrast(ii),'_',freqBand(jj),'_mice(ll) = atanh(PL_R_',contrast(ii),'_',freqBand(jj),'_mouse);'));
            
            eval(strcat('VL_R_',contrast(ii),'_',freqBand(jj),'_mouse = Rs_',contrast(ii), '_',freqBand(jj),'_mouse(8,16);'));
            eval(strcat('VL_R_',contrast(ii),'_',freqBand(jj),'_mice(ll) = atanh(VL_R_',contrast(ii),'_',freqBand(jj),'_mouse);'));
            
            eval(strcat('SSL_ML_',contrast(ii),'_',freqBand(jj),'_mouse = Rs_',contrast(ii), '_',freqBand(jj),'_mouse(4,2);'));
            eval(strcat('SSL_ML_',contrast(ii),'_',freqBand(jj),'_mice(ll) = atanh(SSL_ML_',contrast(ii),'_',freqBand(jj),'_mouse);'));
        end
    end
    
    ll = ll + 1;
end
% model_series = [mean(CL_R_jrgeco1aCorr_ISA_mice),mean(CL_R_FADCorr_ISA_mice),mean(CL_R_total_ISA_mice);
%     mean(ML_R_jrgeco1aCorr_ISA_mice),mean(ML_R_FADCorr_ISA_mice),mean(ML_R_total_ISA_mice);
%     mean(SSL_R_jrgeco1aCorr_ISA_mice),mean(SSL_R_FADCorr_ISA_mice),mean(SSL_R_total_ISA_mice);
%     mean(RSL_R_jrgeco1aCorr_ISA_mice),mean(RSL_R_FADCorr_ISA_mice),mean(RSL_R_total_ISA_mice);
%     mean(PL_R_jrgeco1aCorr_ISA_mice),mean(PL_R_FADCorr_ISA_mice),mean(PL_R_total_ISA_mice);
%     mean(VL_R_jrgeco1aCorr_ISA_mice),mean(VL_R_FADCorr_ISA_mice),mean(VL_R_total_ISA_mice);
%     mean(SSL_ML_jrgeco1aCorr_ISA_mice),mean(SSL_ML_FADCorr_ISA_mice),mean(SSL_ML_total_ISA_mice)];
% 
% model_error = [std(CL_R_jrgeco1aCorr_ISA_mice),std(CL_R_FADCorr_ISA_mice),std(CL_R_total_ISA_mice);
%     std(ML_R_jrgeco1aCorr_ISA_mice),std(ML_R_FADCorr_ISA_mice),std(ML_R_total_ISA_mice);
%     std(SSL_R_jrgeco1aCorr_ISA_mice),std(SSL_R_FADCorr_ISA_mice),std(SSL_R_total_ISA_mice);
%     std(RSL_R_jrgeco1aCorr_ISA_mice),std(RSL_R_FADCorr_ISA_mice),std(RSL_R_total_ISA_mice);
%     std(PL_R_jrgeco1aCorr_ISA_mice),std(PL_R_FADCorr_ISA_mice),std(PL_R_total_ISA_mice);
%     std(VL_R_jrgeco1aCorr_ISA_mice),std(VL_R_FADCorr_ISA_mice),std(VL_R_total_ISA_mice);
%     std(SSL_ML_jrgeco1aCorr_ISA_mice),std(SSL_ML_FADCorr_ISA_mice),std(SSL_ML_total_ISA_mice)];
% 
% [h_CL_R_ISA_CalciumFAD,p_CL_R_ISA_CalciumFAD] = ttest(CL_R_jrgeco1aCorr_ISA_mice,CL_R_FADCorr_ISA_mice);
% [h_CL_R_ISA_CalciumHbT,p_CL_R_ISA_CalciumHbT] = ttest(CL_R_jrgeco1aCorr_ISA_mice,CL_R_total_ISA_mice);
% [h_CL_R_ISA_FADHbT,p_CL_R_ISA_FADHbT] = ttest(CL_R_FADCorr_ISA_mice,CL_R_total_ISA_mice);
% 
% [h_ML_R_ISA_CalciumFAD,p_ML_R_ISA_CalciumFAD] = ttest(ML_R_jrgeco1aCorr_ISA_mice,ML_R_FADCorr_ISA_mice);
% [h_ML_R_ISA_CalciumHbT,p_ML_R_ISA_CalciumHbT] = ttest(ML_R_jrgeco1aCorr_ISA_mice,ML_R_total_ISA_mice);
% [h_ML_R_ISA_FADHbT,p_ML_R_ISA_FADHbT] = ttest(ML_R_FADCorr_ISA_mice,ML_R_total_ISA_mice);
% 
% [h_SSL_R_ISA_CalciumFAD,p_SSL_R_ISA_CalciumFAD] = ttest(SSL_R_jrgeco1aCorr_ISA_mice,SSL_R_FADCorr_ISA_mice);
% [h_SSL_R_ISA_CalciumHbT,p_SSL_R_ISA_CalciumHbT] = ttest(SSL_R_jrgeco1aCorr_ISA_mice,SSL_R_total_ISA_mice);
% [h_SSL_R_ISA_FADHbT,p_SSL_R_ISA_FADHbT] = ttest(SSL_R_FADCorr_ISA_mice,SSL_R_total_ISA_mice);
% 
% [h_RSL_R_ISA_CalciumFAD,p_RSL_R_ISA_CalciumFAD] = ttest(RSL_R_jrgeco1aCorr_ISA_mice,RSL_R_FADCorr_ISA_mice);
% [h_RSL_R_ISA_CalciumHbT,p_RSL_R_ISA_CalciumHbT] = ttest(RSL_R_jrgeco1aCorr_ISA_mice,RSL_R_total_ISA_mice);
% [h_RSL_R_ISA_FADHbT,p_RSL_R_ISA_FADHbT] = ttest(RSL_R_FADCorr_ISA_mice,RSL_R_total_ISA_mice);
% 
% [h_PL_R_ISA_CalciumFAD,p_PL_R_ISA_CalciumFAD] = ttest(PL_R_jrgeco1aCorr_ISA_mice,PL_R_FADCorr_ISA_mice);
% [h_PL_R_ISA_CalciumHbT,p_PL_R_ISA_CalciumHbT] = ttest(PL_R_jrgeco1aCorr_ISA_mice,PL_R_total_ISA_mice);
% [h_PL_R_ISA_FADHbT,p_PL_R_ISA_FADHbT] = ttest(PL_R_FADCorr_ISA_mice,PL_R_total_ISA_mice);
% 
% [h_VL_R_ISA_CalciumFAD,p_VL_R_ISA_CalciumFAD] = ttest(VL_R_jrgeco1aCorr_ISA_mice,VL_R_FADCorr_ISA_mice);
% [h_VL_R_ISA_CalciumHbT,p_VL_R_ISA_CalciumHbT] = ttest(VL_R_jrgeco1aCorr_ISA_mice,VL_R_total_ISA_mice);
% [h_VL_R_ISA_FADHbT,p_VL_R_ISA_FADHbT] = ttest(VL_R_FADCorr_ISA_mice,VL_R_total_ISA_mice);
% 
% [h_SSL_ML_ISA_CalciumFAD,p_SSL_ML_ISA_CalciumFAD] = ttest(SSL_ML_jrgeco1aCorr_ISA_mice,SSL_ML_FADCorr_ISA_mice);
% [h_SSL_ML_ISA_CalciumHbT,p_SSL_ML_ISA_CalciumHbT] = ttest(SSL_ML_jrgeco1aCorr_ISA_mice,SSL_ML_total_ISA_mice);
% [h_SSL_ML_ISA_FADHbT,p_SSL_ML_ISA_FADHbT] = ttest(SSL_ML_FADCorr_ISA_mice,SSL_ML_total_ISA_mice);
% 
% 
% 
% figure('position',pos)
% b = bar(model_series,'grouped');
% b(1).FaceColor = 'm';
% b(2).FaceColor = 'g';
% b(3).FaceColor = 'k';
% hold on
% [ngroups,nbars] = size(model_series);
% x = nan(nbars, ngroups);
% for i = 1:nbars
%     x(i,:) = b(i).XEndPoints;
% end
% errorbar(x',model_series,zeros(7,3),model_error,'k','linestyle','none');
% hold off
% ylabel('Correlation')
% ylim([0 2.5])
% xticklabels({'C','M','SS','RS','P','V','SSL-ML'})
% %set(gca,'TickLength',[0 .01])
% set(gca,'FontSize',14,'FontWeight','Bold')
% %breakyaxis([0.1 0.55])
% title('Anesthetized, ISA')
% 
% sigstar({[x(1,1),x(2,1)]},p_CL_R_ISA_CalciumFAD,0,3)
% sigstar({[x(1,1),x(3,1)]},p_CL_R_ISA_CalciumHbT,0,3)
% sigstar({[x(2,1),x(3,1)]},p_CL_R_ISA_FADHbT,0,3)
% 
% sigstar({[x(1,2),x(3,2)]},p_ML_R_ISA_CalciumHbT,0,3)
% sigstar({[x(2,2),x(3,2)]},p_ML_R_ISA_FADHbT,0,3)
% 
% sigstar({[x(1,3),x(3,3)]},p_SSL_R_ISA_CalciumHbT,0,3)
% sigstar({[x(2,3),x(3,3)]},p_SSL_R_ISA_FADHbT,0,3)
% 
% sigstar({[x(1,4),x(2,4)]},p_RSL_R_ISA_CalciumFAD,0,3)
% sigstar({[x(1,4),x(3,4)]},p_RSL_R_ISA_CalciumHbT,0,3)
% 
% sigstar({[x(2,5),x(3,5)]},p_PL_R_ISA_FADHbT,0,3)
% 
% 
% sigstar({[x(1,6),x(2,6)]},p_VL_R_ISA_CalciumFAD,0,3)
% sigstar({[x(1,6),x(3,6)]},p_VL_R_ISA_CalciumHbT,0,3)
% sigstar({[x(2,6),x(3,6)]},p_VL_R_ISA_FADHbT,0,3)
% 
% sigstar({[x(2,7),x(3,7)]},p_SSL_ML_ISA_FADHbT,0,3)



model_series = [mean(CL_R_jrgeco1aCorr_Delta_mice),mean(CL_R_FADCorr_Delta_mice),mean(CL_R_total_Delta_mice);
    mean(ML_R_jrgeco1aCorr_Delta_mice),mean(ML_R_FADCorr_Delta_mice),mean(ML_R_total_Delta_mice);
    mean(SSL_R_jrgeco1aCorr_Delta_mice),mean(SSL_R_FADCorr_Delta_mice),mean(SSL_R_total_Delta_mice);
    mean(RSL_R_jrgeco1aCorr_Delta_mice),mean(RSL_R_FADCorr_Delta_mice),mean(RSL_R_total_Delta_mice);
    mean(PL_R_jrgeco1aCorr_Delta_mice),mean(PL_R_FADCorr_Delta_mice),mean(PL_R_total_Delta_mice);
    mean(VL_R_jrgeco1aCorr_Delta_mice),mean(VL_R_FADCorr_Delta_mice),mean(VL_R_total_Delta_mice);
    mean(SSL_ML_jrgeco1aCorr_Delta_mice),mean(SSL_ML_FADCorr_Delta_mice),mean(SSL_ML_total_Delta_mice)];

model_error = [std(CL_R_jrgeco1aCorr_Delta_mice),std(CL_R_FADCorr_Delta_mice),std(CL_R_total_Delta_mice);
    std(ML_R_jrgeco1aCorr_Delta_mice),std(ML_R_FADCorr_Delta_mice),std(ML_R_total_Delta_mice);
    std(SSL_R_jrgeco1aCorr_Delta_mice),std(SSL_R_FADCorr_Delta_mice),std(SSL_R_total_Delta_mice);
    std(RSL_R_jrgeco1aCorr_Delta_mice),std(RSL_R_FADCorr_Delta_mice),std(RSL_R_total_Delta_mice);
    std(PL_R_jrgeco1aCorr_Delta_mice),std(PL_R_FADCorr_Delta_mice),std(PL_R_total_Delta_mice);
    std(VL_R_jrgeco1aCorr_Delta_mice),std(VL_R_FADCorr_Delta_mice),std(VL_R_total_Delta_mice);
    std(SSL_ML_jrgeco1aCorr_Delta_mice),std(SSL_ML_FADCorr_Delta_mice),std(SSL_ML_total_Delta_mice)];

[h_CL_R_Delta_CalciumFAD,p_CL_R_Delta_CalciumFAD] = ttest(CL_R_jrgeco1aCorr_Delta_mice,CL_R_FADCorr_Delta_mice);
[h_CL_R_Delta_CalciumHbT,p_CL_R_Delta_CalciumHbT] = ttest(CL_R_jrgeco1aCorr_Delta_mice,CL_R_total_Delta_mice);
[h_CL_R_Delta_FADHbT,p_CL_R_Delta_FADHbT] = ttest(CL_R_FADCorr_Delta_mice,CL_R_total_Delta_mice);

[h_ML_R_Delta_CalciumFAD,p_ML_R_Delta_CalciumFAD] = ttest(ML_R_jrgeco1aCorr_Delta_mice,ML_R_FADCorr_Delta_mice);
[h_ML_R_Delta_CalciumHbT,p_ML_R_Delta_CalciumHbT] = ttest(ML_R_jrgeco1aCorr_Delta_mice,ML_R_total_Delta_mice);
[h_ML_R_Delta_FADHbT,p_ML_R_Delta_FADHbT] = ttest(ML_R_FADCorr_Delta_mice,ML_R_total_Delta_mice);

[h_SSL_R_Delta_CalciumFAD,p_SSL_R_Delta_CalciumFAD] = ttest(SSL_R_jrgeco1aCorr_Delta_mice,SSL_R_FADCorr_Delta_mice);
[h_SSL_R_Delta_CalciumHbT,p_SSL_R_Delta_CalciumHbT] = ttest(SSL_R_jrgeco1aCorr_Delta_mice,SSL_R_total_Delta_mice);
[h_SSL_R_Delta_FADHbT,p_SSL_R_Delta_FADHbT] = ttest(SSL_R_FADCorr_Delta_mice,SSL_R_total_Delta_mice);

[h_RSL_R_Delta_CalciumFAD,p_RSL_R_Delta_CalciumFAD] = ttest(RSL_R_jrgeco1aCorr_Delta_mice,RSL_R_FADCorr_Delta_mice);
[h_RSL_R_Delta_CalciumHbT,p_RSL_R_Delta_CalciumHbT] = ttest(RSL_R_jrgeco1aCorr_Delta_mice,RSL_R_total_Delta_mice);
[h_RSL_R_Delta_FADHbT,p_RSL_R_Delta_FADHbT] = ttest(RSL_R_FADCorr_Delta_mice,RSL_R_total_Delta_mice);

[h_PL_R_Delta_CalciumFAD,p_PL_R_Delta_CalciumFAD] = ttest(PL_R_jrgeco1aCorr_Delta_mice,PL_R_FADCorr_Delta_mice);
[h_PL_R_Delta_CalciumHbT,p_PL_R_Delta_CalciumHbT] = ttest(PL_R_jrgeco1aCorr_Delta_mice,PL_R_total_Delta_mice);
[h_PL_R_Delta_FADHbT,p_PL_R_Delta_FADHbT] = ttest(PL_R_FADCorr_Delta_mice,PL_R_total_Delta_mice);

[h_VL_R_Delta_CalciumFAD,p_VL_R_Delta_CalciumFAD] = ttest(VL_R_jrgeco1aCorr_Delta_mice,VL_R_FADCorr_Delta_mice);
[h_VL_R_Delta_CalciumHbT,p_VL_R_Delta_CalciumHbT] = ttest(VL_R_jrgeco1aCorr_Delta_mice,VL_R_total_Delta_mice);
[h_VL_R_Delta_FADHbT,p_VL_R_Delta_FADHbT] = ttest(VL_R_FADCorr_Delta_mice,VL_R_total_Delta_mice);

[h_SSL_ML_Delta_CalciumFAD,p_SSL_ML_Delta_CalciumFAD] = ttest(SSL_ML_jrgeco1aCorr_Delta_mice,SSL_ML_FADCorr_Delta_mice);
[h_SSL_ML_Delta_CalciumHbT,p_SSL_ML_Delta_CalciumHbT] = ttest(SSL_ML_jrgeco1aCorr_Delta_mice,SSL_ML_total_Delta_mice);
[h_SSL_ML_Delta_FADHbT,p_SSL_ML_Delta_FADHbT] = ttest(SSL_ML_FADCorr_Delta_mice,SSL_ML_total_Delta_mice);



figure('position',pos)
b = bar(model_series,'grouped');
b(1).FaceColor = 'm';
b(2).FaceColor = 'g';
b(3).FaceColor = 'k';
hold on
[ngroups,nbars] = size(model_series);
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
errorbar(x',model_series,zeros(7,3),model_error,'k','linestyle','none');
hold off
ylabel('Correlation')
ylim([0 2.5])
xticklabels({'C','M','SS','RS','P','V','SSL-ML'})
%set(gca,'TickLength',[0 .01])
set(gca,'FontSize',14,'FontWeight','Bold')
%breakyaxis([0.1 0.55])
title('Anesthetized, Delta')


sigstar({[x(1,1),x(2,1)]},p_CL_R_Delta_CalciumFAD,0,3)
sigstar({[x(1,1),x(3,1)]},p_CL_R_Delta_CalciumHbT,0,3)

sigstar({[x(1,2),x(2,2)]},p_ML_R_Delta_CalciumFAD,0,3)
sigstar({[x(1,2),x(3,2)]},p_ML_R_Delta_CalciumHbT,0,3)
sigstar({[x(2,2),x(3,2)]},p_ML_R_Delta_FADHbT,0,3)

sigstar({[x(1,3),x(2,3)]},p_SSL_R_Delta_CalciumFAD,0,3)
sigstar({[x(1,3),x(3,3)]},p_SSL_R_Delta_CalciumHbT,0,3)


sigstar({[x(1,4),x(2,4)]},p_RSL_R_Delta_CalciumFAD,0,3)
sigstar({[x(1,4),x(3,4)]},p_RSL_R_Delta_CalciumHbT,0,3)
sigstar({[x(2,4),x(3,4)]},p_RSL_R_Delta_FADHbT,0,3)

sigstar({[x(1,5),x(3,5)]},p_PL_R_Delta_CalciumHbT,0,3)
sigstar({[x(2,5),x(3,5)]},p_PL_R_Delta_FADHbT,0,3)

sigstar({[x(1,6),x(2,6)]},p_VL_R_Delta_CalciumFAD,0,3)
sigstar({[x(1,6),x(3,6)]},p_VL_R_Delta_CalciumHbT,0,3)
sigstar({[x(2,6),x(3,6)]},p_VL_R_Delta_FADHbT,0,3)

sigstar({[x(1,7),x(2,7)]},p_SSL_ML_Delta_CalciumFAD,0,3)

