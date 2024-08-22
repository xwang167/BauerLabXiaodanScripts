for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    maskDir_new = saveDir;
    %maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
    
    
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    maskName_new = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
    %maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    %load(fullfile(maskDir,maskName), 'xform_isbrain')
    %save(fullfile(maskDir_new,maskName_new),'xform_isbrain')
    load(fullfile(maskDir_new,maskName_new), 'xform_isbrain')
    xform_isbrain = double(xform_isbrain);
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        
        
        
        if strcmp(sessionType,'fc')
            C = who('-file',fullfile(saveDir,processedName));
            isQCGot = false;
            for  k=1:length(C)
                if strcmp(C(k),'powerdata_oxy')
                    isQCGot = true;
                end
            end
            if ~isQCGot
                disp('loading processed data')
                load(fullfile(saveDir,processedName),'xform_datahb')
                for ii = 1:size(xform_datahb,4)
                    xform_isbrain(isinf(xform_datahb(:,:,1,ii))) = 0;
                    xform_isbrain(isnan(xform_datahb(:,:,1,ii))) = 0;
                    
                end
                disp(strcat('fc QC check on ', processedName))
                
             
                    
               if strcmp(sessionInfo.mouseType,'gcamp6f')
                    load(fullfile(saveDir, processedName),'xform_gcampCorr','xform_gcamp')
                    sessionInfo.bandtype_ISA = {"ISA",0.009,0.08};
                    sessionInfo.bandtype_Delta = {"Delta",0.4,4};
                    total = squeeze(xform_datahb(:,:,1,:)) + squeeze(xform_datahb(:,:,2,:));
                    disp('calculate pds')
                    
                    [hz,powerdata_gcampCorr] = QCcheck_CalcPDS(real(double(xform_gcampCorr))/0.01,sessionInfo.framerate,xform_isbrain);
                    [~,powerdata_gcamp] = QCcheck_CalcPDS(double(xform_gcamp)/0.01,sessionInfo.framerate,xform_isbrain);
        
                    [~,powerdata_total] = QCcheck_CalcPDS(real(double(total)*10^6),sessionInfo.framerate,xform_isbrain);
                    [~,powerdata_oxy] = QCcheck_CalcPDS(real(double(xform_datahb(:,:,1,:)))*10^6,sessionInfo.framerate,xform_isbrain);
                    [~,powerdata_deoxy] = QCcheck_CalcPDS(real(double(xform_datahb(:,:,2,:)))*10^6,sessionInfo.framerate,xform_isbrain);
                    
                    [hz,powerdata_average_gcampCorr] = QCcheck_CalcPDSAverage(double(xform_gcampCorr)/0.01,sessionInfo.framerate,xform_isbrain);
                    [~,powerdata_average_gcamp] = QCcheck_CalcPDSAverage(double(xform_gcamp)/0.01,sessionInfo.framerate,xform_isbrain);
                    [~,powerdata_average_total] = QCcheck_CalcPDSAverage(double(total)*10^6,sessionInfo.framerate,xform_isbrain);
                    [~,powerdata_average_oxy] = QCcheck_CalcPDSAverage(double(xform_datahb(:,:,1,:))*10^6,sessionInfo.framerate,xform_isbrain);
                    [~,powerdata_average_deoxy] = QCcheck_CalcPDSAverage(double(xform_datahb(:,:,2,:))*10^6,sessionInfo.framerate,xform_isbrain);
                    
                    
                    clear xform_datahb
                    
                    disp('calculate power map')
                    gcampCorr_ISA_powerMap = QCcheck_CalcPowerMap(double(xform_gcampCorr)/0.01,sessionInfo.framerate,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}]);
                     total_ISA_powerMap = QCcheck_CalcPowerMap(double(total)*10^6,sessionInfo.framerate,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}]);
                    
                    gcampCorr_Delta_powerMap = QCcheck_CalcPowerMap(double(xform_gcampCorr)/0.01,sessionInfo.framerate,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}]);
                    total_Delta_powerMap = QCcheck_CalcPowerMap(double(total)*10^6,sessionInfo.framerate,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}]);
                    
                    disp('calculate fc')
                    refseeds=GetReferenceSeeds;
                    %refseeds = refseeds(1:14,:);
                    refseeds(3,1) = 42;
                    refseeds(3,2) = 88;
                    refseeds(4,1) = 87;
                    refseeds(4,2) = 88;
                    refseeds(9,1) = 18;
                    refseeds(9,2) = 66;
                    refseeds(10,1) = 111;
                    refseeds(10,2) = 66;
                    
                    
                    [R_gcampCorr_ISA,Rs_gcampCorr_ISA] = QCcheck_CalcRRs(refseeds,double(xform_gcampCorr)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}],true);
                   [R_total_ISA,Rs_total_ISA] = QCcheck_CalcRRs(refseeds,double(total)*10^6,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}],true);
                    
                    [R_gcampCorr_Delta,Rs_gcampCorr_Delta] = QCcheck_CalcRRs(refseeds,double(xform_gcampCorr)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],true);
                     [R_total_Delta,Rs_total_Delta] = QCcheck_CalcRRs(refseeds,double(total)*10^6,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],true);
                    
                    clear xform_FADCorr xform_gcampCorr xform_gcamp total
                    
                    save(fullfile(saveDir, processedName),'powerdata_gcampCorr','powerdata_gcamp','powerdata_FADCorr','powerdata_total','powerdata_oxy','powerdata_deoxy',...
                        'powerdata_average_gcampCorr','powerdata_average_gcamp','powerdata_average_FADCorr','powerdata_average_total','powerdata_average_oxy','powerdata_average_deoxy','hz',...
                        'gcampCorr_ISA_powerMap','FADCorr_ISA_powerMap','total_ISA_powerMap','gcampCorr_Delta_powerMap','FADCorr_Delta_powerMap','total_Delta_powerMap',...
                        'R_gcampCorr_ISA','Rs_gcampCorr_ISA','R_FADCorr_ISA','Rs_FADCorr_ISA','R_total_ISA','Rs_total_ISA',...
                        'R_gcampCorr_Delta','Rs_gcampCorr_Delta','R_FADCorr_Delta','Rs_FADCorr_Delta','R_total_Delta','Rs_total_Delta','xform_isbrain','-append','-v7.3')
                    
                    
                    nameString = fullfile(saveDir,visName);
                    figure
                    normFactor = (powerdata_average_gcampCorr(3)-powerdata_average_gcampCorr(2))*(0.01-hz(2))/(hz(3)-hz(2))+powerdata_average_gcampCorr(2);
semilogx(hz,10*log10(powerdata_average_gcampCorr/normFactor),'g-')

ylim([-50,5])
ylabel('dB(\DeltaF/F%)^2/Hz)')

yyaxis right
hold on
normFactor = (powerdata_average_oxy(3)-powerdata_average_oxy(2))*(0.01-hz(2))/(hz(3)-hz(2))+powerdata_average_oxy(2);
semilogx(hz,10*log10(powerdata_average_oxy/normFactor),'r-')

hold on
normFactor = (powerdata_average_deoxy(3)-powerdata_average_deoxy(2))*(0.01-hz(2))/(hz(3)-hz(2))+powerdata_average_deoxy(2);
semilogx(hz,10*log10(powerdata_average_deoxy/normFactor),'b-')

hold on
normFactor = (powerdata_average_total(3)-powerdata_average_total(2))*(0.01-hz(2))/(hz(3)-hz(2))+powerdata_average_total(2);
semilogx(hz,10*log10(powerdata_average_total/normFactor),'k-')
ylabel('dB(\muM^2/Hz)')
ylim([-50,5])

xticks([10^-2  10^-1 10^0 10])

xlabel('Frequency (Hz)')

xlim([10^-2 10])
set(findall(gca, 'Type', 'Line'),'LineWidth',2);
set(gca,'FontSize',20,'FontWeight','Bold')
 grid on
 legendName = {'Corrected gcamp','HbO','HbR','HbT'};
leg = legend(legendName,'location','southwest','FontSize',12);


title(visName,'fontsize',14,'Interpreter', 'none');
ytickformat('%.1f');


                    
                                    
                    %                 leftLabel = 'Fluor(\DeltaF/F%)^2/Hz)';
                    %                 rightLabel = 'Hb(\muM^2/Hz)';
                    %                 leftLineStyle = {'m-','y-','g-'};
                    %                 rightLineStyle= {'r-','b-','k-'};
                    %                 legendName = ["Corrected gcamp","gcamp","Corrected FAD","HbO","HbR","HbT"];
                    %
                    %                 leftLegend = ["Corrected gcamp","gcamp","Corrected FAD"];
                    %                 rightLegend = ["HbO","HbR","HbT"];
                    
                    
                    
                    QCcheck_fftVis(hz, leftData,rightData,leftLabel,rightLabel,leftLineStyle,rightLineStyle,legendName,saveDir,strcat(visName, '_powerCurve_average'))
                    %
                    %
                    QCcheck_powerMapVis(gcampCorr_ISA_powerMap,xform_isbrain,'(\DeltaF/F%)',saveDir,strcat(visName, '_RGECOISA'))
                     QCcheck_powerMapVis(total_ISA_powerMap,xform_isbrain,'\muM',saveDir,strcat(visName, "_TotalISA"))
                    
                    QCcheck_powerMapVis(gcampCorr_Delta_powerMap,xform_isbrain,'(\DeltaF/F%)',saveDir,strcat(visName, "_RGECODelta"))
                      QCcheck_powerMapVis(total_Delta_powerMap,xform_isbrain,'\muM',saveDir,strcat(visName,"_TotalDelta"))
                    
                    
                    
                    
                    QCcheck_fcVis(refseeds,R_gcampCorr_ISA, Rs_gcampCorr_ISA,'gcampCorr','g','ISA',saveDir,visName,false,xform_isbrain)
                     QCcheck_fcVis(refseeds,R_total_ISA, Rs_total_ISA,'total','k','ISA',saveDir,visName,false,xform_isbrain)
                    
                    QCcheck_fcVis(refseeds,R_gcampCorr_Delta, Rs_gcampCorr_Delta,'gcampCorr','g','Delta',saveDir,visName,false,xform_isbrain)
                    QCcheck_fcVis(refseeds,R_total_Delta, Rs_total_Delta,'total','k','Delta',saveDir,visName,false,xform_isbrain)
                end
                
            end
            close all
        elseif strcmp(sessionType,'stim')
            disp('loading processed data')
            load(fullfile(saveDir,processedName),'xform_datahb')
            for ii = 1:size(xform_datahb,4)
                xform_isbrain(isinf(xform_datahb(:,:,1,ii))) = 0;
                xform_isbrain(isnan(xform_datahb(:,:,1,ii))) = 0;
                
            end
            xform_datahb(isinf(xform_datahb)) = 0;
            xform_datahb(isnan(xform_datahb)) = 0;
            %             load('D:\OIS_Process\noVasculatureMask.mat')
            %
            %             xform_isbrain= xform_isbrain.*(double(leftMask)+double(rightMask));
            sessionInfo.stimblocksize = excelRaw{11};
            sessionInfo.stimbaseline=excelRaw{12};
            sessionInfo.stimduration = excelRaw{13};
            sessionInfo.stimFrequency = excelRaw{16};
            stimStartTime = 5;
            info.freqout=1;
            disp('loading Non GRS data')
            if strcmp(sessionInfo.mouseType,'gcamp6f')||strcmp(sessionInfo.mouseType,'Gopto3')
                load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
                    'xform_gcamp','xform_gcampCorr','xform_green','xform_datahb')
            elseif strcmp(sessionInfo.mouseType,'Gopto3')
                load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
                    'xform_gcamp','xform_gcampCorr','xform_green','xform_datahb')
            elseif strcmp(sessionInfo.mouseType,'gcamp')||strcmp(sessionInfo.mouseType,'gcamp-opto3')
                load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
                    'xform_gcamp','xform_gcampCorr','xform_red','xform_FAD','xform_FADCorr','xform_green','xform_datahb')
            end
            
            
            
            if strcmp(sessionInfo.mouseType,'PV')||strcmp(sessionInfo.mouseType,'gcamp-opto2')||strcmp(sessionInfo.mouseType,'gcamp-opto3')||strcmp(sessionInfo.mouseType,'Gopto3')||strcmp(sessionInfo.mouseType,'Wopto3')
                
                load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'.mat')))
                if strcmp(sessionInfo.mouseType,'PV')
                    load(fullfile(maskDir_new,maskName_new), 'affineMarkers')
                    peakMap_ROI= process.affineTransform(rawdata(:,:,3,sessionInfo.stimbaseline+1),affineMarkers) ;
                elseif strcmp(sessionInfo.mouseType,'gcamp-opto2')
                    peakMap_ROI = rawdata(:,:,3,sessionInfo.stimbaseline+1);
                else
                    peakMap_ROI = rawdata(:,:,1,sessionInfo.darkFrameNum/4+sessionInfo.stimbaseline+1);
                end
                clear rawdata
                imagesc(peakMap_ROI)
                axis image off
                colormap jet
                
                if strcmp(sessionInfo.mouseType,'PV')
                    hold on
                    load('D:\OIS_Process\atlas.mat','AtlasSeeds')
                    barrel = AtlasSeeds == 9;
                    ROI_barrel =  bwperim(barrel);
                    
                    
                    contour(ROI_barrel,'k')
                end
                
                [x1,y1] = ginput(1);
                [x2,y2] = ginput(1);
                [X,Y] = meshgrid(1:128,1:128);
                radius = sqrt((x1-x2)^2+(y1-y2)^2);
                ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
                max_ROI = prctile(peakMap_ROI(ROI),99);
                temp = double(peakMap_ROI).*double(ROI);
                ROI = temp>max_ROI*0.30;
                hold on
                ROI_contour = bwperim(ROI);
                contour( ROI_contour,'k');
                
                saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'ROI.fig')))
                saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'ROI.png')))
            end
            
            numBlock = size(xform_datahb,4)/sessionInfo.stimblocksize;
            
            
            numDesample = size(xform_datahb,4)/sessionInfo.framerate*info.freqout;
            factor = round(numDesample/numBlock);
            numDesample = factor*numBlock;
%             
%             texttitle_NoGSR = strcat(mouseName,'-stim',num2str(n)," ",'without GSR nor filtering');
%             output_NoGSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'-NoGSR'));
%             disp('QC on non GSR stim')
%             
%             
%             %   load(fullfile(saveDir,'ROI.mat'))
%             
%             
%             if strcmp(sessionInfo.mouseType,'gcamp6f')
%                 [goodBlocks_NoGSR,ROI_NoGSR] = QC_stim(squeeze(xform_datahb(:,:,1,:)),squeeze(xform_datahb(:,:,2,:)),...
%                     xform_gcamp,xform_gcampCorr,xform_green,[],[],[],...
%                     xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,[]);
%             elseif strcmp(sessionInfo.mouseType,'Gopto3')
%                 [goodBlocks_NoGSR,ROI_NoGSR] = QC_stim(squeeze(xform_datahb(:,:,1,:)),squeeze(xform_datahb(:,:,2,:)),...
%                     xform_gcamp,xform_gcampCorr,xform_green,[],[],[],...
%                     xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,ROI);
%             elseif strcmp(sessionInfo.mouseType,'Wopto3')
%                 [goodBlocks_NoGSR,ROI_NoGSR] = QC_stim(squeeze(xform_datahb(:,:,1,:)),squeeze(xform_datahb(:,:,2,:)),...
%                     xform_FAD,xform_FADCorr,xform_green,[],[],[],...
%                     xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,ROI);
%                 
%                 
%             elseif strcmp(sessionInfo.mouseType,'gcamp')
%                 [goodBlocks_NoGSR,ROI_NoGSR] = QC_stim(squeeze(xform_datahb(:,:,1,:))*10^6,squeeze(xform_datahb(:,:,2,:))*10^6,...
%                     xform_FAD*100,xform_FADCorr*100,xform_green*100,xform_gcamp*100,xform_gcampCorr*100,xform_red*100,...
%                     xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,[]);
%                 
%             elseif strcmp(sessionInfo.mouseType,'gcamp-opto3')
%                 load(fullfile(maskDir_new,maskName_new), 'isbrain')
%                 [goodBlocks_NoGSR,ROI_NoGSR] = QC_stim(squeeze(xform_datahb(:,:,1,:))*10^6,squeeze(xform_datahb(:,:,2,:))*10^6,...
%                     xform_FAD*100,xform_FADCorr*100,xform_green*100,xform_gcamp*100,xform_gcampCorr*100,xform_red*100,...
%                     isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,ROI);
%             elseif strcmp(sessionInfo.mouseType,'PV')
%                 xform_datahb(isnan(xform_datahb)) = 0;
%                 xform_datahb =  mouse.freq.lowpass(xform_datahb,0.5,sessionInfo.framerate);
%                 [goodBlocks_NoGSR,ROI_NoGSR] = QC_stim(squeeze(xform_datahb(:,:,1,:))*10^6,squeeze(xform_datahb(:,:,2,:))*10^6,...
%                     [],[],[],[],[],[],...
%                     xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,ROI);
%             elseif strcmp(sessionInfo.mouseType,'gcamp-opto2')
%                 load(fullfile(maskDir_new,maskName_new), 'isbrain')
%                 [goodBlocks_NoGSR,ROI_NoGSR] = QC_stim(squeeze(xform_datahb(:,:,1,:))*10^6,squeeze(xform_datahb(:,:,2,:))*10^6,...
%                     [],[],[],[],[],[],...
%                     isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,ROI);
%                 
%             end
%             close all
%             save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'goodBlocks_NoGSR','ROI_NoGSR','-append')
            %
                        disp('loading GRS data')
            
                        texttitle_GSR = strcat(mouseName,'-stim',num2str(n)," ",'with GSR without filtering');
                        output_GSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'-GSR'));
            
                        xform_datahb_GSR = mouse.process.gsr(xform_datahb,xform_isbrain);
                        clear xform_datahb
            
                        if strcmp(sessionInfo.mouseType,'gcamp6f')
                            xform_gcamp_GSR = mouse.process.gsr(xform_gcamp,xform_isbrain);
                            clear xform_FAD
                            xform_gcampCorr_GSR = mouse.process.gsr(xform_gcampCorr,xform_isbrain);
                            clear xform_FADCorr
                            xform_green_GSR = mouse.process.gsr(xform_green,xform_isbrain);
                            clear xform_green
                            disp('saving gcamp related data')
            
                            disp('QC on GSR stim')
                            [goodBlocks_GSR] = QC_stim(squeeze(xform_datahb_GSR(:,:,1,:)),squeeze(xform_datahb_GSR(:,:,2,:)),...
                                xform_gcamp_GSR,xform_gcampCorr_GSR,xform_green_GSR,[],[],[],...
                                xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_GSR,output_GSR,ROI_NoGSR);
                            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
                                'xform_datahb_GSR','xform_gcamp_GSR','xform_gcampCorr_GSR','xform_green_GSR','goodBlocks_NoGSR','goodBlocks_GSR','ROI_NoGSR','-append')
            
                             else
                            [goodBlocks_GSR] = QC_stim(squeeze(xform_datahb_GSR(:,:,1,:)),squeeze(xform_datahb_GSR(:,:,2,:)),...
                                [],[],[],[],[],[],...
                                xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_GSR,output_GSR,ROI);
                            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'goodBlocks_GSR','goodBlocks_NoGSR','ROI_NoGSR','ROI','xform_datahb_GSR','-append')
            
            
                        end
            close all
            
        end
        
    end
end
