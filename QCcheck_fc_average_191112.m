close all;clearvars -except hz;clc
import mouse.*
excelFile = "L:\RGECO\RGECO.xlsx";
excelRows = 8:13;% [228 230 232 234 236 240];
runs =1:3;
nVx = 128;
nVy = 128;

length_runs = length(runs);

for ii = 1
    isDetrend = logical(ii);
    for excelRow = excelRows
        [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
        recDate = excelRaw{1}; recDate = string(recDate);
        mouseName = excelRaw{2}; mouseName = string(mouseName);
        saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
        sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
        
        
        
        sessionInfo.darkFrameNum = excelRaw{15};
        rawdataloc = excelRaw{3};
        info.nVx = 128;
        info.nVy = 128;
        sessionInfo.mouseType = excelRaw{17};
        systemType =excelRaw{5};
        sessionInfo.framerate = excelRaw{7};
        goodRuns = str2num(excelRaw{18});
        
       maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
        if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor','.mat')))
            
            load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor','.mat')),'xform_isbrain');
            
        else
            maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
            load(fullfile(saveDir,maskName), 'xform_isbrain')
        end
            processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
            visName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed');


        powerdata_average_oxy_mouse = [];
        powerdata_oxy_mouse = [];
        
        powerdata_average_deoxy_mouse = [];
        powerdata_deoxy_mouse = [];
        
        powerdata_average_total_mouse = [];
        powerdata_total_mouse = [];
        
        
   if strcmp(char(sessionInfo.mouseType),'jrgeco1a')
  
            powerdata_average_jrgeco1aCorr_mouse = [];
            powerdata_jrgeco1aCorr_mouse = [];
            powerdata_average_FADCorr_mouse = [];
            powerdata_FADCorr_mouse = [];
            
        end
        for n = runs
            
            
            disp('loading processed data')
            
            %             if isDetrend
            processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
            %             else
            %                 processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_NoDetrend','.mat');
            %             end
            if strcmp(sessionType,'fc')
                if strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                     
                    if ismember(n,goodRuns)
                        load(fullfile(saveDir, processedName),'powerdata_oxy','powerdata_deoxy','powerdata_jrgeco1aCorr','powerdata_total','powerdata_FADCorr',...
                            'powerdata_average_oxy','powerdata_average_deoxy','powerdata_average_jrgeco1aCorr','powerdata_average_total','powerdata_average_FADCorr')
                        powerdata_jrgeco1aCorr_mouse = cat(1,powerdata_jrgeco1aCorr_mouse,squeeze(powerdata_jrgeco1aCorr));
                        powerdata_FADCorr_mouse = cat(1,powerdata_FADCorr_mouse,squeeze(powerdata_FADCorr));
                        powerdata_oxy_mouse = cat(1,powerdata_oxy_mouse,squeeze(powerdata_oxy));
                        powerdata_deoxy_mouse = cat(1,powerdata_deoxy_mouse,squeeze(powerdata_deoxy));
                        powerdata_total_mouse = cat(1,powerdata_total_mouse,squeeze(powerdata_total));
                        
                        powerdata_average_jrgeco1aCorr_mouse = cat(1,powerdata_average_jrgeco1aCorr_mouse,squeeze(powerdata_average_jrgeco1aCorr'));
                        powerdata_average_FADCorr_mouse = cat(1,powerdata_average_FADCorr_mouse,squeeze(powerdata_average_FADCorr'));
                        powerdata_average_oxy_mouse = cat(1,powerdata_average_oxy_mouse,squeeze(powerdata_average_oxy'));
                        powerdata_average_deoxy_mouse = cat(1,powerdata_average_deoxy_mouse,squeeze(powerdata_average_deoxy'));
                        powerdata_average_total_mouse = cat(1,powerdata_average_total_mouse,squeeze(powerdata_average_total'));
                        
                    end
                    

                end
            end
        end
        
        if goodRuns~=0
            
            powerdata_average_oxy_mouse = mean(powerdata_average_oxy_mouse,1);
            powerdata_oxy_mouse = mean(powerdata_oxy_mouse,1);
            powerdata_average_deoxy_mouse = mean(powerdata_average_deoxy_mouse,1);
            powerdata_deoxy_mouse = mean(powerdata_deoxy_mouse,1);
            powerdata_average_total_mouse = mean(powerdata_average_total_mouse,1);
            powerdata_total_mouse = mean(powerdata_total_mouse,1);
        end
            
        
        
        disp(char(['QC check on ', processedName_mouse]))
       if strcmp(char(sessionInfo.mouseType),'jrgeco1a')
            
            visName = strcat(recDate,'-',mouseName,'-',sessionType);
            %
            if goodRuns ~=0
                
                powerdata_average_jrgeco1aCorr_mouse = mean(powerdata_average_jrgeco1aCorr_mouse,1);
                powerdata_jrgeco1aCorr_mouse = mean(powerdata_jrgeco1aCorr_mouse,1);
                powerdata_average_FADCorr_mouse = mean(powerdata_average_FADCorr_mouse,1);
                powerdata_FADCorr_mouse = mean(powerdata_FADCorr_mouse,1);
                
                save(fullfile(saveDir, processedName_mouse), 'powerdata_average_oxy_mouse','powerdata_average_deoxy_mouse','powerdata_average_total_mouse','powerdata_average_jrgeco1aCorr_mouse','powerdata_average_FADCorr_mouse',...
                    'powerdata_oxy_mouse','powerdata_deoxy_mouse','powerdata_total_mouse','powerdata_jrgeco1aCorr_mouse','powerdata_FADCorr_mouse','-append')
                leftData = cell(2,1);
                leftData{1} = powerdata_jrgeco1aCorr_mouse;
                leftData{2} = powerdata_FADCorr_mouse;
                
                rightData = cell(3,1);
                rightData{1} = powerdata_oxy_mouse;
                rightData{2} = powerdata_deoxy_mouse;
                rightData{3} = powerdata_total_mouse;
                
                leftLabel = 'Fluor(\DeltaF/F%)^2/Hz)';
                rightLabel = 'Hb(\muM^2/Hz)';
                leftLineStyle = {'m-','g-'};
                rightLineStyle= {'r-','b-','k-'};
                legendName = ["Corrected jRGECO1a","jRGECO1a","Corrected FAD","HbO","HbR","HbT"];
                               
                QCcheck_fftVis_191112(hz, leftData,rightData,leftLabel,rightLabel,leftLineStyle,rightLineStyle,legendName,saveDir,strcat(visName, '_powerCurve'))
                
                
                
                leftData = cell(2,1);
                leftData{1} = powerdata_average_jrgeco1aCorr_mouse;
                
                leftData{2} = powerdata_average_FADCorr_mouse;
                
                rightData = cell(3,1);
                rightData{1} = powerdata_average_oxy_mouse;
                rightData{2} = powerdata_average_deoxy_mouse;
                rightData{3} = powerdata_average_total_mouse;
                
                leftLabel = 'Fluor(\DeltaF/F%)^2/Hz)';
                rightLabel = 'Hb(\muM^2/Hz)';
                leftLineStyle = {'m-','g-'};
                rightLineStyle= {'r-','b-','k-'};
                legendName = ["Corrected jRGECO1a","jRGECO1a","Corrected FAD","HbO","HbR","HbT"];
                               QCcheck_fftVis_191112(hz, leftData,rightData,leftLabel,rightLabel,leftLineStyle,rightLineStyle,legendName,saveDir,strcat(visName, '_powerCurve_average'))
                

                             
            end
            

            
            
            
        end
        close all
    end
end