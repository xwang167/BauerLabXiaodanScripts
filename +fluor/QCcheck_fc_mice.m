close all;clearvars;clc
import mice.*
excelFile = "D:\gcamp\gcamp_awake.xlsx";
isZTransform = true;
set(0,'defaulttextfontsize',28);
set(0,'defaultaxesfontsize',12);

info.nVx = 128;
info.nVy = 128;
%
excelRows = [181 183 185];

numMice = length(excelRows);
suffix = {'_cat','NoDetrend_cat','_processed','_NoDetrend'};
ll = 1:2;
xform_isbrain_mice = 1;
sessionInfo.miceType = 'jrgeco1a';
saveDir_cat = 'J:\RGECO\cat';


R_oxy_Delta_mice  = zeros(info.nVy,info.nVx,14,numMice);
R_oxy_ISA_mice  = zeros(info.nVy,info.nVx,14,numMice);
Rs_oxy_Delta_mice = zeros(14,14,numMice);
Rs_oxy_ISA_mice = zeros(14,14,numMice);
oxy_Delta_powerMap_mice = zeros(info.nVy,info.nVx,numMice);
oxy_ISA_powerMap_mice = zeros(info.nVy,info.nVx,numMice);
fdata_oxy_mice = [];
powerdata_oxy_mice = [];

fdata_deoxy_mice = [];
powerdata_deoxy_mice = [];

fdata_total_mice = [];
powerdata_total_mice = [];

if strcmp(char(sessionInfo.miceType),'jrgeco1a')
    R_jrgeco1aCorr_Delta_mice = zeros(info.nVy,info.nVx,14,numMice);
    R_jrgeco1aCorr_ISA_mice  = zeros(info.nVy,info.nVx,14,numMice);
    Rs_jrgeco1aCorr_Delta_mice = zeros(14,14,numMice);
    Rs_jrgeco1aCorr_ISA_mice = zeros(14,14,numMice);
    jrgeco1aCorr_Delta_powerMap_mice = zeros(info.nVy,info.nVx,numMice);
    jrgeco1aCorr_ISA_powerMap_mice = zeros(info.nVy,info.nVx,numMice);
    fdata_jrgeco1aCorr_mice = [];
    powerdata_jrgeco1aCorr_mice = [];
    
    R_FADCorr_Delta_mice  = zeros(info.nVy,info.nVx,14,numMice);
    R_FADCorr_ISA_mice  = zeros(info.nVy,info.nVx,14,numMice);
    Rs_FADCorr_Delta_mice = zeros(14,14,numMice);
    Rs_FADCorr_ISA_mice = zeros(14,14,numMice);
    FADCorr_Delta_powerMap_mice = zeros(info.nVy,info.nVx,numMice);
    FADCorr_ISA_powerMap_mice = zeros(info.nVy,info.nVx,numMice);
    fdata_FADCorr_mice = [];
    powerdata_FADCorr_mice = [];
    
end

for ii = 3
    
    miceName = [];
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
        if strcmp(char(sessionInfo.miceType),'WT')
            systemInfo.numLEDs = 2;
        elseif strcmp(char(sessionInfo.miceType),'jrgeco1a')
            systemInfo.numLEDs = 3;
        end
        maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
        
        
        
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataHb','.mat')),'xform_isbrain');
        xform_isbrain(xform_isbrain ==2)=1;
        xform_isbrain = double(xform_isbrain);
        
        if ~isempty(find(isnan(xform_isbrain), 1))
            xform_isbrain(isnan(xform_isbrain))=0;
        end
        xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
        
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,suffix(ii),'.mat');
        
        if strcmp(sessionType,'fc')
            if strcmp(char(sessionInfo.miceType),'jrgeco1a')
                if ii<3
                    disp('loading processed data')
                    load(fullfile(saveDir, processedName),'R_jrgeco1aCorr_Delta','R_jrgeco1aCorr_ISA','R_oxy_Delta','R_oxy_ISA','Rs_jrgeco1aCorr_Delta','Rs_jrgeco1aCorr_ISA','Rs_oxy_Delta','Rs_oxy_ISA','fdata_deoxy','fdata_oxy','fdata_jrgeco1aCorr','fdata_total','powerdata_deoxy','powerdata_oxy','powerdata_jrgeco1aCorr','powerdata_total','jrgeco1aCorr_Delta_powerMap','jrgeco1aCorr_ISA_powerMap','oxy_Delta_powerMap','oxy_ISA_powerMap')
                    R_jrgeco1aCorr_Delta_mice(:,:,:,ll) = atanh(R_jrgeco1aCorr_Delta);
                    R_jrgeco1aCorr_ISA_mice(:,:,:,ll) = atanh(R_jrgeco1aCorr_ISA);
                    R_oxy_Delta_mice(:,:,:,ll) = atanh(R_oxy_Delta);
                    R_oxy_ISA_mice(:,:,:,ll) = atanh(R_oxy_ISA);
                    
                    Rs_jrgeco1aCorr_Delta_mice(:,:,ll) = atanh(Rs_jrgeco1aCorr_Delta);
                    Rs_jrgeco1aCorr_ISA_mice(:,:,ll) = atanh(Rs_jrgeco1aCorr_ISA);
                    Rs_oxy_Delta_mice(:,:,ll) = atanh(Rs_oxy_Delta);
                    Rs_oxy_ISA_mice(:,:,ll) = atanh(Rs_oxy_ISA);
                    
                    fdata_jrgeco1aCorr_mice = cat(1,fdata_jrgeco1aCorr_mice,squeeze(fdata_jrgeco1aCorr));
                    fdata_oxy_mice = cat(1,fdata_oxy_mice,squeeze(fdata_oxy));
                    fdata_deoxy_mice = cat(1,fdata_deoxy_mice,squeeze(fdata_deoxy));
                    fdata_total_mice = cat(1,fdata_total_mice,squeeze(fdata_total));
                    
                    jrgeco1aCorr_Delta_powerMap_mice(:,:,ll) = jrgeco1aCorr_Delta_powerMap;
                    jrgeco1aCorr_ISA_powerMap_mice(:,:,ll) = jrgeco1aCorr_ISA_powerMap;
                    oxy_Delta_powerMap_mice(:,:,ll) = oxy_Delta_powerMap;
                    oxy_ISA_powerMap_mice(:,:,ll) = oxy_ISA_powerMap;
                else
                    
                    load(fullfile(saveDir, processedName),'R_oxy_Delta_mouse','R_oxy_ISA_mouse','R_jrgeco1aCorr_Delta_mouse','R_jrgeco1aCorr_ISA_mouse','R_FADCorr_Delta_mouse','R_FADCorr_ISA_mouse',...
                        'Rs_oxy_Delta_mouse','Rs_oxy_ISA_mouse','Rs_jrgeco1aCorr_Delta_mouse','Rs_jrgeco1aCorr_ISA_mouse', 'Rs_FADCorr_Delta_mouse','Rs_FADCorr_ISA_mouse',...
                        'fdata_oxy_mouse','fdata_deoxy_mouse','fdata_total_mouse','fdata_jrgeco1aCorr_mouse','fdata_FADCorr_mouse',...
                        'powerdata_oxy_mouse','powerdata_deoxy_mouse','powerdata_jrgeco1aCorr_mouse','powerdata_total_mouse','powerdata_FADCorr_mouse',...
                        'oxy_Delta_powerMap_mouse','oxy_ISA_powerMap_mouse','jrgeco1aCorr_Delta_powerMap_mouse','jrgeco1aCorr_ISA_powerMap_mouse', 'FADCorr_Delta_powerMap_mouse','FADCorr_ISA_powerMap_mouse',...
                        'hz','hz2')
                    
                    R_oxy_Delta_mice(:,:,:,ll) = atanh(R_oxy_Delta_mouse);
                    R_oxy_ISA_mice(:,:,:,ll) = atanh(R_oxy_ISA_mouse);
                    Rs_oxy_Delta_mice(:,:,ll) = atanh(Rs_oxy_Delta_mouse);
                    Rs_oxy_ISA_mice(:,:,ll) = atanh(Rs_oxy_ISA_mouse);
                    oxy_Delta_powerMap_mice(:,:,ll) = oxy_Delta_powerMap_mouse;
                    oxy_ISA_powerMap_mice(:,:,ll) = oxy_ISA_powerMap_mouse;
                    fdata_oxy_mice = cat(1,fdata_oxy_mice,squeeze(fdata_oxy_mouse));
                    powerdata_oxy_mice = cat(1,powerdata_oxy_mice,squeeze(powerdata_oxy_mouse));
                    
                    
                    fdata_deoxy_mice = cat(1,fdata_deoxy_mice,squeeze(fdata_deoxy_mouse));
                    powerdata_deoxy_mice = cat(1,powerdata_deoxy_mice,squeeze(powerdata_deoxy_mouse));
                    
                    fdata_total_mice = cat(1,fdata_total_mice,squeeze(fdata_total_mouse));
                    powerdata_total_mice = cat(1,powerdata_total_mice,squeeze(powerdata_total_mouse));
                    
                    
                    R_jrgeco1aCorr_Delta_mice(:,:,:,ll) = atanh(R_jrgeco1aCorr_Delta_mouse);
                    R_jrgeco1aCorr_ISA_mice(:,:,:,ll) = atanh(R_jrgeco1aCorr_ISA_mouse);
                    Rs_jrgeco1aCorr_Delta_mice(:,:,ll) = atanh(Rs_jrgeco1aCorr_Delta_mouse);
                    Rs_jrgeco1aCorr_ISA_mice(:,:,ll) = atanh(Rs_jrgeco1aCorr_ISA_mouse);
                    jrgeco1aCorr_Delta_powerMap_mice(:,:,ll) = jrgeco1aCorr_Delta_powerMap_mouse;
                    jrgeco1aCorr_ISA_powerMap_mice(:,:,ll) = jrgeco1aCorr_ISA_powerMap_mouse;
                    fdata_jrgeco1aCorr_mice = cat(1,fdata_jrgeco1aCorr_mice,squeeze(fdata_jrgeco1aCorr_mouse));
                    powerdata_jrgeco1aCorr_mice = cat(1,powerdata_jrgeco1aCorr_mice,squeeze(powerdata_jrgeco1aCorr_mouse));
                    
                      R_FADCorr_Delta_mice(:,:,:,ll) = atanh(R_FADCorr_Delta_mouse);
                    R_FADCorr_ISA_mice(:,:,:,ll) = atanh(R_FADCorr_ISA_mouse);
                    Rs_FADCorr_Delta_mice(:,:,ll) = atanh(Rs_FADCorr_Delta_mouse);
                    Rs_FADCorr_ISA_mice(:,:,ll) = atanh(Rs_FADCorr_ISA_mouse);
                    FADCorr_Delta_powerMap_mice(:,:,ll) = FADCorr_Delta_powerMap_mouse;
                    FADCorr_ISA_powerMap_mice(:,:,ll) = FADCorr_ISA_powerMap_mouse;
                    fdata_FADCorr_mice = cat(1,fdata_FADCorr_mice,squeeze(fdata_FADCorr_mouse));
                    powerdata_FADCorr_mice = cat(1,powerdata_FADCorr_mice,squeeze(powerdata_FADCorr_mouse));
               
                end
            end
            ll = ll+1;
        end
    end
    processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,suffix(ii),'.mat');
    titleName = strcat(recDate,miceName);
    visName = 'Averaged Across Mice';
    R_oxy_Delta_mice  = tanh(mean(R_oxy_Delta_mice,4));
    R_oxy_ISA_mice  = tanh(mean(R_oxy_ISA_mice,4));
    Rs_oxy_Delta_mice = tanh(mean(Rs_oxy_Delta_mice,3));
    Rs_oxy_ISA_mice = tanh(mean(Rs_oxy_ISA_mice,3));
    fdata_oxy_mice = mean(fdata_oxy_mice,1);
    powerdata_oxy_mice = mean(powerdata_oxy_mice,1);
    
    fdata_deoxy_mice = mean(fdata_deoxy_mice,1);
    powerdata_deoxy_mice = mean(powerdata_deoxy_mice,1);
    
    fdata_total_mice = mean(fdata_total_mice,1);
    powerdata_total_mice = mean(powerdata_total_mice,1);
    
    oxy_Delta_powerMap_mice = mean(oxy_Delta_powerMap_mice,3);
    oxy_ISA_powerMap_mice = mean(oxy_ISA_powerMap_mice,3);
    
    
    
    R_jrgeco1aCorr_Delta_mice = mean(R_jrgeco1aCorr_Delta_mice,4);
    R_jrgeco1aCorr_ISA_mice  = mean(R_jrgeco1aCorr_ISA_mice,4);
    Rs_jrgeco1aCorr_Delta_mice = mean(Rs_jrgeco1aCorr_Delta_mice,3);
    Rs_jrgeco1aCorr_ISA_mice = mean(Rs_jrgeco1aCorr_ISA_mice,3);
    fdata_jrgeco1aCorr_mice = mean(fdata_jrgeco1aCorr_mice,1);
    powerdata_jrgeco1aCorr_mice = mean(powerdata_jrgeco1aCorr_mice,1);
    jrgeco1aCorr_Delta_powerMap_mice = mean(jrgeco1aCorr_Delta_powerMap_mice,3);
    jrgeco1aCorr_ISA_powerMap_mice = mean(jrgeco1aCorr_ISA_powerMap_mice,3);
    
    R_FADCorr_Delta_mice = mean(R_FADCorr_Delta_mice,4);
    R_FADCorr_ISA_mice  = mean(R_FADCorr_ISA_mice,4);
    Rs_FADCorr_Delta_mice = mean(Rs_FADCorr_Delta_mice,3);
    Rs_FADCorr_ISA_mice = mean(Rs_FADCorr_ISA_mice,3);
    fdata_FADCorr_mice = mean(fdata_FADCorr_mice,1);
    powerdata_FADCorr_mice = mean(powerdata_FADCorr_mice,1);
    FADCorr_Delta_powerMap_mice = mean(FADCorr_Delta_powerMap_mice,3);
    FADCorr_ISA_powerMap_mice = mean(FADCorr_ISA_powerMap_mice,3);
    save(fullfile(saveDir_cat, processedName_mice),'R_oxy_ISA_mice','R_jrgeco1aCorr_ISA_mice','R_FADCorr_ISA_mice',...
        'R_oxy_Delta_mice','R_jrgeco1aCorr_Delta_mice','R_FADCorr_Delta_mice',...
        'Rs_oxy_ISA_mice','Rs_jrgeco1aCorr_ISA_mice','Rs_FADCorr_ISA_mice',...
        'Rs_oxy_Delta_mice','Rs_jrgeco1aCorr_Delta_mice','Rs_FADCorr_Delta_mice',...
        'fdata_oxy_mice','fdata_deoxy_mice','fdata_total_mice','fdata_jrgeco1aCorr_mice','fdata_FADCorr_mice',...
        'powerdata_oxy_mice','powerdata_deoxy_mice','powerdata_total_mice','powerdata_jrgeco1aCorr_mice','powerdata_FADCorr_mice',...
        'oxy_ISA_powerMap_mice','jrgeco1aCorr_ISA_powerMap_mice','FADCorr_ISA_powerMap_mice',...
        'oxy_Delta_powerMap_mice','jrgeco1aCorr_Delta_powerMap_mice','FADCorr_Delta_powerMap_mice',...
        'hz','hz2')
    
    
    
    disp(char(['QC check on ', processedName_mice]))
    if strcmp(char(sessionInfo.miceType),'jrgeco1a')
        refseeds=GetReferenceSeeds;
        refseeds = refseeds(1:14,:);
        
        
        
        
        bandTypes ={'ISA','Delta'};
        for ii = 1:length(bandTypes)
            fcMatrix1 = genvarname(['Rs_oxy_',bandTypes{ii},'_mice']);
            fcMatrix2 = genvarname(['Rs_jrgeco1aCorr_',bandTypes{ii},'_mice']);
            fcMatrix3 = genvarname(['Rs_FADCorr_',bandTypes{ii},'_mice']);
            
            fcMap1 = genvarname(['R_oxy_',bandTypes{ii},'_mice']);
            fcMap2 =  genvarname(['R_jrgeco1aCorr_',bandTypes{ii},'_mice']);
            fcMap3 = genvarname(['R_FADCorr_',bandTypes{ii},'_mice']);
               
            eval( ['QCcheck_fcVis_twoFluor(refseeds,' fcMap1 ',' fcMatrix1 ',' fcMap2 ',' fcMatrix2 ', ' char(39) 'Oxy' char(39)...
                ',' char(39) 'jrgeco1aCorr' char(39) ',' char(39) 'r' char(39) ',' char(39)...
                ' m' char(39) ',bandTypes{ii},saveDir_cat,miceName,true,xform_isbrain_mice)']);
            eval( ['QCcheck_fcVis_twoFluor(refseeds,' fcMap3 ',' fcMatrix3 ',' fcMap2 ',' fcMatrix2 ', ' char(39) 'FADCorr' char(39)...
                ',' char(39) 'jrgeco1aCorr' char(39) ',' char(39) 'g' char(39) ',' char(39)...
                'm' char(39) ',bandTypes{ii},saveDir_cat,miceName,true,xform_isbrain_mice)']);
            
        end
        close all
        traceSpecies = {'oxy','deoxy','total','jrgeco1aCorr','FADCorr'};
        traceColor = {'r-', 'b-','k-','m-','g-'};
        
        for ii = 1:5
            
            fftCurve = genvarname(['fdata_' traceSpecies{ii} '_mice']);
            powerCurve = genvarname(['powerdata_' traceSpecies{ii} '_mice']);
            
            figure(1)
            subplot('position',[0.12 0.13 0.6 0.8])
            if ii>3
                yyaxis right
                set(gca, 'YScale', 'log')
                ylabel('(Fluor(\DeltaF/F)^2/Hz)')
           
            else
                yyaxis left
                ylabel('Hb(M^2/Hz)')
            end
            eval(['p' num2str(ii) '= loglog(hz,' powerCurve ',traceColor{ii});']);
            hold on
            
            
            
            figure(2)
            subplot('position',[0.12 0.12 0.6 0.7])
            if ii>3
                yyaxis right
                set(gca, 'YScale', 'log')
                ylabel('Fluor(\DeltaF/F/Hz)')
         
            else
                yyaxis left
                ylabel('Hb(M/Hz)')
            end
            eval(['p' num2str(ii) '= loglog(hz2(1:ceil(end/2)),' fftCurve '(1:ceil(end/2)),traceColor{ii});']);
            hold on
            
        end
        figure(1)
        legend('oxy','deoxy','total','jrgeco1aCorr','FADCorr','location','southwest')
        xlabel('Frequency (Hz)')
        title(strcat(visName,' PSD'),'fontsize',14,'Interpreter', 'none');
        ytickformat('%.1f');
        xlim([10^-2 10])
        saveas(gcf,(fullfile(saveDir_cat,strcat(miceName,'_FCpowerCurve.png'))));
        saveas(gcf,(fullfile(saveDir_cat,strcat(miceName,'_FCpowerCurve.fig'))));
        
        figure(2)
        legend('oxy','deoxy','total','jrgeco1aCorr','FADCorr')
        xlabel('Frequency (Hz)')
        title(strcat(visName,'  Normalized fft '),'fontsize',14,'Interpreter', 'none');
        ytickformat('%.1f');
        saveas(gcf,(fullfile(saveDir_cat,strcat(miceName,'_FCfftCurve.png'))));
        saveas(gcf,(fullfile(saveDir_cat,strcat(miceName,'_FCfftCurve.fig'))));
        
        
        
        
        close all
        
        bandTypes = {'ISA','Delta'};
        figure('units','normalized','outerposition',[0 0 1 1]);
        load('D:\OIS_Process\noVasculatureMask.mat')
        subplot_Index = 1;
        for ii= [4,5,3]
            for jj = 1:2
                
                powerMap = genvarname([traceSpecies{ii} '_' bandTypes{jj} '_powerMap_mice']);
                subplot(3,2,subplot_Index)
                midVas = zeros(128,128);
                midVas(23:107,51:78) = 1;
                mask = xform_isbrain_mice.*(double(leftMask)+double(rightMask));
                %mask(mask==2) = 1;
                mask(mask==0)=NaN;
%                 eval([powerMap '=' powerMap '.*mask;']);
                colormap jet
                eval(['imagesc(log10(' powerMap '.*xform_isbrain_mice),[min(min(log10(' powerMap ').*mask)) max(max(log10(' powerMap ').*mask))])'])
                   hold on
                   load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','WL')
                   mask(isnan(mask)) = 0;
    imagesc(WL,'AlphaData',1-xform_isbrain_mice)
    
                cb = colorbar();
                cb.Ruler.MinorTick = 'on';
                if ii == 1
                    ylabel(cb,'log(M^2)','FontSize',12)
                else
                    ylabel(cb,'log((\DeltaF/F)^2)','FontSize',12)
                end
                axis image off
                title([ traceSpecies{ii} bandTypes{jj} ])
                subplot_Index = subplot_Index+1;
            end
        end
        saveas(gcf,(fullfile(saveDir_cat,strcat(miceName,'_FCpowerMap.png'))));
        saveas(gcf,(fullfile(saveDir_cat,strcat(miceName,'_FCpowerMap.fig'))));
        
    end
    close all
end


