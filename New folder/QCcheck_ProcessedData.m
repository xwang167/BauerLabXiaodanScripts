clearvars;close all;clc
excelFile = "D:\GCaMP\GCaMP_awake.xlsx";%Xiaodan
isGsr = true;
if isGsr == true
    isGsrname = '-GSR';
else
    isGsrname = '';
end

for excelRow = [13 15]  %6:15
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':N',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    tiffFileDir = excelRaw{3}; tiffFileDir = strcat(tiffFileDir,recDate);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    for run = 1:3
        processedDataName = strcat(recDate,"-",mouseName,"-",sessionType,num2str(run),isGsrname,"-Detrend");
        if  strcmp(char(sessionType),'fc')
            
            
            
            %rawdata = readtiff(strcat('\\10.39.168.176\RawData_East3410\181031\181031-GCampM2-stim',num2str(run),'.tif'));
            %         [~, ~, L]=size(rawdata);
            
            load(strcat(fullfile(saveDir,processedDataName),".mat"),'xform_hb_ISA','xform_gcampCorr_ISA','xform_hb_Delta','xform_gcampCorr_Delta','xform_isbrain','sessionInfo')
            [info.nVy,info.nVx,~,~] = size(xform_hb_ISA);
            oxy_ISA = squeeze(xform_hb_ISA (:,:,1,:));
            gcampCorr_ISA  = squeeze(xform_gcampCorr_ISA (:,:,1,:));
            oxy_Delta = squeeze(xform_hb_Delta(:,:,1,:));
            gcampCorr_Delta = squeeze(xform_gcampCorr_Delta(:,:,1,:));
            
            
            oxy_ISA = oxy_ISA.*xform_isbrain;
            gcampCorr_ISA = gcampCorr_ISA.*xform_isbrain;
            oxy_Delta = oxy_Delta.*xform_isbrain;
            gcampCorr_Delta = gcampCorr_Delta.*xform_isbrain;
            
            oxy_ISA(isnan(oxy_ISA)) = 0;
            gcampCorr_ISA(isnan(gcampCorr_ISA)) = 0;
            oxy_Delta(isnan(oxy_Delta)) = 0;
            gcampCorr_Delta(isnan(gcampCorr_Delta)) = 0;            
            
            fhraw=figure('Units','inches','Position',[7 3 10 7], 'PaperPositionMode','auto','PaperOrientation','Landscape');
            set(fhraw,'Units','normalized','visible','off');
            
            plotedit on
            system = 'EastOIS1_Fluor';
            oxy_ISA=reshape(oxy_ISA,info.nVy*info.nVx,[]);
            gcampCorr_ISA = reshape(gcampCorr_ISA,info.nVy*info.nVx,[]);
            
            oxy_Delta = reshape(oxy_Delta,info.nVy*info.nVx,[]);
            gcampCorr_Delta = reshape(gcampCorr_Delta,info.nVy*info.nVx,[]);
            
            seednames={'Olf','Fr','Cg','M','SS','RS','V'};
            refseeds=GetReferenceSeeds;
            refseeds = refseeds(1:14,:);
            sides={'L','R'};
            
            mm=10;
            mpp=mm/info.nVx;
            seedradmm=0.25;
            seedradpix=seedradmm/mpp;
            
            numseeds=numel(seednames);
            numsides=numel(sides); 
            P=burnseeds(refseeds,seedradpix,xform_isbrain);
            
            strace_oxy_ISA = P2strace(P,oxy_ISA, refseeds); %% strace is each seeds trace resultinmg from averaging the pixels within a seed region
            strace_gcampCorr_ISA = P2strace(P,gcampCorr_ISA, refseeds);
            strace_oxy_Delta = P2strace(P,oxy_Delta, refseeds); %% strace is each seeds trace resultinmg from averaging the pixels within a seed region
            strace_gcampCorr_Delta=P2strace(P,gcampCorr_Delta, refseeds);
            
            
            R_oxy_ISA=strace2R(strace_oxy_ISA,oxy_ISA, info.nVx, info.nVy); %% normalize  rows in time, dot product of those rows with strce
            R_gcampCorr_ISA = strace2R(strace_gcampCorr_ISA,gcampCorr_ISA, info.nVx, info.nVy);
            R_oxy_Delta = strace2R(strace_oxy_Delta,oxy_Delta, info.nVx, info.nVy); %% normalize  rows in time, dot product of those rows with strce
            R_gcampCorr_Delta = strace2R(strace_gcampCorr_Delta,gcampCorr_Delta, info.nVx, info.nVy);
            
            
            R_oxy_ISA(isnan(R_oxy_ISA)) = 0;
            Rs_oxy_ISA=normRow(strace_oxy_ISA)*normRow(strace_oxy_ISA)';
            R_gcampCorr_ISA(isnan(R_gcampCorr_ISA)) = 0;
            Rs_gcampCorr_ISA = normRow(strace_gcampCorr_ISA)*normRow(strace_gcampCorr_ISA)';
            
            R_oxy_Delta(isnan(R_oxy_Delta)) = 0;
            Rs_oxy_Delta = normRow(strace_oxy_Delta)*normRow(strace_oxy_Delta)';
            R_gcampCorr_Delta(isnan(R_gcampCorr_Delta)) = 0;
            Rs_gcampCorr_Delta =normRow(strace_gcampCorr_Delta)*normRow(strace_gcampCorr_Delta)';
            
            WL_atlas =  zeros(128,128);
            figure;
            for s=1:numseeds
                
                OE=0;
                if mod(s,2)==0
                    OE=0.26;
                else
                    OE=0.1;
                end
                
                subplot('position', [OE (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
                %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+1)),double(WL_atlas), xform_isbrain,'jet',-1,1);
                imagesc(R_oxy_ISA(:,:,(2*(s-1)+1)),[-1 1]); %changed 3/1/11
                hold on;
                plot(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),'ko');
                axis image off
                title([seednames{s},'R'],'FontSize',6)
                
                p1 = subplot('position', [OE+0.08 (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
                %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(WL_atlas), xform_isbrain,'jet',-1,1);
                imagesc(R_oxy_ISA(:,:,(2*(s-1)+2)),[-1 1]); %changed 3/1/11
                hold on;
                plot(refseeds(2*(s-1)+2,1),refseeds(2*(s-1)+2,2),'ko');
                axis image off
                title([seednames{s},'L'],'FontSize',6)
                hold off;
                
            end
            colorbar
            set(p1,'Position',[OE+0.10 (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
            
            for s=1:numseeds
                
                if mod(s,2)==0
                    OE=0.26;
                else
                    OE=0.1;
                end
                
                subplot('position', [OE+0.5 (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
                %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+1)),double(WL_atlas), xform_isbrain,'jet',-1,1);
                imagesc(R_gcampCorr_ISA(:,:,(2*(s-1)+1)),[-1 1]); %changed 3/1/11
                hold on;
                plot(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),'ko');
                axis image off
                title([seednames{s},'R'],'FontSize',6)
                
                p2 = subplot('position', [OE+0.08+0.5 (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
                %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(WL_atlas), xform_isbrain,'jet',-1,1);
                imagesc(R_gcampCorr_ISA(:,:,(2*(s-1)+2)),[-1 1]); %changed 3/1/11
                hold on;
                plot(refseeds(2*(s-1)+2,1),refseeds(2*(s-1)+2,2),'ko');
                axis image off
                title([seednames{s},'L'],'FontSize',6)
                hold off;
                
            end
            
            colorbar
            set(p2,'Position',[OE+0.08+0.5 (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
            

            
            
            
             for s=1:numseeds
                
                OE=0;
                if mod(s,2)==0
                    OE=0.26;
                else
                    OE=0.1;
                end
                
                subplot('position', [OE (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
                %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+1)),double(WL_atlas), xform_isbrain,'jet',-1,1);
                imagesc(R_oxy_Delta(:,:,(2*(s-1)+1)),[-1 1]); %changed 3/1/11
                hold on;
                plot(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),'ko');
                axis image off
                title([seednames{s},'R'],'FontSize',6)
                
                p3 = subplot('position', [OE+0.08 (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
                %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(WL_atlas), xform_isbrain,'jet',-1,1);
                imagesc(R_oxy_Delta(:,:,(2*(s-1)+2)),[-1 1]); %changed 3/1/11
                hold on;
                plot(refseeds(2*(s-1)+2,1),refseeds(2*(s-1)+2,2),'ko');
                axis image off
                title([seednames{s},'L'],'FontSize',6)
                hold off;
                
            end
            colorbar
            set(p3,'Position',[OE+0.08 (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
            
            for s=1:numseeds
                
                OE=0;
                if mod(s,2)==0
                    OE=0.26;
                else
                    OE=0.1;
                end
                
                subplot('position', [OE+0.5 (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
                %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+1)),double(WL_atlas), xform_isbrain,'jet',-1,1);
                imagesc(R_gcampCorr_Delta(:,:,(2*(s-1)+1)),[-1 1]); %changed 3/1/11
                hold on;
                plot(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),'ko');
                axis image off
                title([seednames{s},'R'],'FontSize',6)
                
                p4 = subplot('position', [OE+0.08+0.5 (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
                %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(WL_atlas), xform_isbrain,'jet',-1,1);
                imagesc(R_gcampCorr_Delta(:,:,(2*(s-1)+2)),[-1 1]); %changed 3/1/11
                hold on;
                plot(refseeds(2*(s-1)+2,1),refseeds(2*(s-1)+2,2),'ko');
                axis image off
                title([seednames{s},'L'],'FontSize',6)
                hold off;
                
            end
            
            colorbar
            set(p4,'Position',[OE+0.08+0.5 (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
            
            
            
            
            
            
            
            annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',strcat(processedDataName,' Processed Data Visualization'),'FontWeight','bold');
            annotation('textbox',[0.15 0.93 0.2 0.04],'HorizontalAlignment','center','LineStyle','none','String',"Oxy",'FontWeight','bold','Color',[1 0 0]);
            annotation('textbox',[0.65 0.93 0.2 0.04],'HorizontalAlignment','center','LineStyle','none','String',"gcampCorr",'FontWeight','bold','Color',[0 1 0]);
            
            annotation('textbox',[0.01 0.6 0.04 0.2],'VerticalAlignment','middle','LineStyle','none','String',"ISA",'FontWeight','bold','Color',[1 0 0]);
            annotation('textbox',[0.01 0.1 0.04 0.2],'VerticalAlignment','middle','LineStyle','none','String',"Delta",'FontWeight','bold','Color',[0 1 0]);
            
            output= strcat(fullfile(saveDir,processedDataName),'_FCMap.jpg');
            orient portrait
            print ('-djpeg', '-r300', output);
            
            figure('visible', 'on');
            close all
            
            save(strcat(fullfile(saveDir,processedDataName),".mat"),'R_oxy_ISA', 'Rs_oxy_ISA','R_gcampCorr_ISA', 'Rs_gcampCorr_ISA','R_oxy_Delta', 'Rs_oxy_Delta','R_gcampCorr_Delta', 'Rs_gcampCorr_Delta', '-append');
            
        else
            %rawdata = readtiff(strcat('\\10.39.168.176\RawData_East3410\181031\181031-GCampM2-stim',num2str(run),'.tif'));
            %         [~, ~, L]=size(rawdata);
            
            load(strcat(fullfile(saveDir,processedDataName),".mat"),'xform_hb','xform_gcampCorr','xform_isbrain','xform_gcamp','xform_total','sessionInfo','info')
            %[oxy, deoxy]=gsr(xform_hb,xform_isbrain);
            oxy = squeeze(xform_hb(:,:,1,:));
            deoxy = squeeze(xform_hb(:,:,2,:));
            total = squeeze(xform_total(:,:,1,:));
            gcamp = squeeze(xform_gcamp(:,:,1,:));
            gcampCorr = squeeze(xform_gcampCorr(:,:,1,:));
            
            oxy = oxy.*xform_isbrain;
            deoxy = deoxy.*xform_isbrain;
            total = total .*xform_isbrain;
            gcamp = gcamp.*xform_isbrain;
            gcampCorr = gcampCorr.*xform_isbrain;
            
            oxy(isnan(oxy)) = 0;
            deoxy(isnan(deoxy)) = 0;
            total(isnan(total)) = 0;
            gcamp(isnan(gcamp)) = 0;
            gcampCorr(isnan(gcampCorr)) = 0;
            
            fhraw=figure('Units','inches','Position',[7 3 10 7], 'PaperPositionMode','auto','PaperOrientation','Landscape');
            set(fhraw,'Units','normalized','visible','off');
            
            plotedit on
            R=mod(size(oxy,3),sessionInfo.stimblocksize);
            if R~=0
                
                disp(['** Non integer number of blocks presented. Padded ' filename, num2str(run), ' with ', num2str(pad), ' zeros **'])
                
            end
            
            oxy=reshape(oxy,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
            
            for b=1:size(oxy,4)
                MeanFrame=squeeze(mean(oxy(:,:,1:sessionInfo.stimbaseline,b),3));
                for t=1:size(oxy, 3);
                    oxy(:,:,t,b)=squeeze(oxy(:,:,t,b))-MeanFrame;
                end
            end
            
            deoxy=reshape(deoxy,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
            for b=1:size(deoxy,4)
                MeanFrame=squeeze(mean(deoxy(:,:,1:sessionInfo.stimbaseline,b),3));
                for t=1:size(deoxy, 3);
                    deoxy(:,:,t,b)=squeeze(deoxy(:,:,t,b))-MeanFrame;
                end
            end
            
            total=reshape(total,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
            for b=1:size(total,4)
                MeanFrame=squeeze(mean(total(:,:,1:sessionInfo.stimbaseline,b),3));
                for t=1:size(total, 3);
                    deoxy(:,:,t,b)=squeeze(deoxy(:,:,t,b))-MeanFrame;
                end
            end
            
            
            gcamp =reshape(gcamp,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
            for b=1:size(gcamp,4)
                MeanFrame=squeeze(mean(gcamp(:,:,1:sessionInfo.stimbaseline,b),3));
                for t=1:size(gcamp, 3);
                    gcamp(:,:,t,b)=squeeze(gcamp(:,:,t,b))-MeanFrame;
                end
            end
            
            gcampCorr =reshape(gcampCorr,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
            for b=1:size(gcampCorr,4)
                MeanFrame=squeeze(mean(gcampCorr(:,:,1:sessionInfo.stimbaseline,b),3));
                for t=1:size(gcampCorr, 3);
                    gcampCorr(:,:,t,b)=squeeze(gcampCorr(:,:,t,b))-MeanFrame;
                end
            end
            
            AvgOxy= mean(oxy,4);
            AvgDeOxy= mean(deoxy,4);
            AvgTotal=mean(total,4);
            Avggcamp = mean(gcamp,4);
            AvggcampCorr = mean(gcampCorr,4);
            
            MeanFrame=squeeze(mean(AvgOxy(:,:,1:sessionInfo.stimbaseline),3));
            for t=1:size(AvgOxy, 3);
                AvgOxy(:,:,t)=squeeze(AvgOxy(:,:,t))-MeanFrame;
            end
            
            MeanFrame=squeeze(mean(AvgDeOxy(:,:,1:sessionInfo.stimbaseline),3));
            for t=1:size(AvgDeOxy, 3);
                AvgDeOxy(:,:,t)=squeeze(AvgDeOxy(:,:,t))-MeanFrame;
            end
            
            MeanFrame=squeeze(mean(AvgTotal(:,:,1:sessionInfo.stimbaseline),3));
            for t=1:size(AvgTotal, 3);
                AvgTotal(:,:,t)=squeeze(AvgTotal(:,:,t))-MeanFrame;
            end
            
            MeanFrame=squeeze(mean(Avggcamp(:,:,1:sessionInfo.stimbaseline),3));
            for t=1:size(Avggcamp, 3);
                Avggcamp(:,:,t)=squeeze(Avggcamp(:,:,t))-MeanFrame;
            end
            
            MeanFrame=squeeze(mean(AvggcampCorr(:,:,1:sessionInfo.stimbaseline),3));
            for t=1:size(AvggcampCorr, 3);
                AvggcampCorr(:,:,t)=squeeze(AvggcampCorr(:,:,t))-MeanFrame;
            end
            
            %% Make Plots
            
            for b=1:size(gcamp,4);
                p = subplot('position', [0.015+(b-1)*0.095 0.8 0.095 0.095]);
                temp=gcamp(:,:,sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate),b);
                imagesc(temp, [-0.008 0.008]);
                
                if b == size(gcamp,4)
                    colorbar
                    set(p,'Position',[0.015+(b-1)*0.095 0.8 0.095 0.095]);
                end
                axis image;
                set(gca, 'XTick', []);
                set(gca, 'YTick', []);
                if b==1
                    ylabel('GcampRaw')
                end
                title(['Pres ', num2str(b)]);
                
            end
            
            for b=1:size(gcampCorr,4);
                p = subplot('position', [0.015+(b-1)*0.095 0.65 0.095 0.095]);
                temp=gcampCorr(:,:,sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate),b);
                imagesc(temp, [-0.015 0.015]);
                if b == size(gcampCorr,4)
                    colorbar
                    set(p,'Position',[0.015+(b-1)*0.095 0.65 0.095 0.095]);
                end
                axis image;
                set(gca, 'XTick', []);
                set(gca, 'YTick', []);
                if b==1
                    ylabel('GcampCorr')
                end
                title(['Pres ', num2str(b)]);
                
            end
            
            for b=1:size(oxy,4);
                p = subplot('position', [0.015+(b-1)*0.095 0.5 0.095 0.095]);
                temp=oxy(:,:,sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate),b);
                imagesc(temp, [-0.8e-5 0.8e-5]);
                if b == size(oxy,4)
                    colorbar
                    set(p,'Position',[0.015+(b-1)*0.095 0.5 0.095 0.095]);
                end
                axis image;
                set(gca, 'XTick', []);
                set(gca, 'YTick', []);
                if b == 1
                    ylabel('Oxy')
                end
                title(['Pres ', num2str(b)]);
            end
            
            for b=1:size(deoxy,4);
                p = subplot('position', [0.015+(b-1)*0.095 0.35 0.095 0.095]);
                temp=deoxy(:,:,sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate),b);
                imagesc(temp, [-0.6e-5 0.6e-5]);
                if b == size(deoxy,4)
                    colorbar
                    set(p,'Position',[0.015+(b-1)*0.095 0.35 0.095 0.095]);
                end
                axis image;
                set(gca, 'XTick', []);
                set(gca, 'YTick', []);
                if b==1
                    ylabel('DeOxy')
                end
                title(['Pres ', num2str(b)]);
            end
            
            for b=1:size(total,4);
                p = subplot('position', [0.015+(b-1)*0.095 0.2 0.095 0.095]);
                temp=total(:,:,sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate),b);
                imagesc(temp, [-0.3e-5 0.3e-5]);
                if b == 10
                    colorbar
                    set(p,'Position',[0.015+(b-1)*0.095 0.2 0.095 0.095]);
                end
                axis image;
                set(gca, 'XTick', []);
                set(gca, 'YTick', []);
                if b==1
                    ylabel('Total')
                end
                title(['Pres ', num2str(b)]);
            end
            
            p = subplot('position', [0.015 0.05 0.095 0.095]);
            temp=mean(Avggcamp(:,:,sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate)-2:sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate)),3);
            imagesc(temp, [-0.008 0.008]);
            colorbar
            set(p,'Position',[0.015 0.05 0.095 0.095]);
            axis image off
            title('Avg Gcamp')
            
            
            
            p = subplot('position', [0.165 0.05 0.095 0.095]);
            temp=mean(AvggcampCorr(:,:,sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate)-2:sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate)),3);
            imagesc(temp, [-0.015 0.015]);
            colorbar
            set(p,'Position',[0.165 0.05 0.095 0.095]);
            axis image off
            title('Avg GcampCorr')
            
            p = subplot('position', [0.315 0.05 0.095 0.095]);
            temp=mean(AvgOxy(:,:,sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate)-2:sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate)),3);
            imagesc(temp, [-0.8e-5 0.8e-5]);
            colorbar
            set(p,'Position',[0.315 0.05 0.095 0.095]);
            axis image off
            title('Avg Oxy')
            
            p = subplot('position', [0.465 0.05 0.095 0.095]);
            temp=mean(AvgDeOxy(:,:,sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate)-2:sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate)),3);
            imagesc(temp, [-0.6e-5 0.6e-5]);
            colorbar
            set(p,'Position',[0.465 0.05 0.095 0.095]);
            axis image off
            title('Avg DeOxy')
            
            p = subplot('position', [0.615 0.05 0.095 0.095]);
            temp=mean(AvgTotal(:,:,sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate)-2:sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate)),3);
            imagesc(temp, [-0.3e-5 0.3e-5]);
            colorbar
            set(p,'Position',[0.615 0.05 0.095 0.095]);
            axis image off
            title('Avg Total')
            
            save(strcat(fullfile(saveDir,processedDataName),".mat") , 'info','AvgOxy', 'AvgDeOxy', 'AvgTotal','Avggcamp','AvggcampCorr', '-append');
            
            annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',strcat(processedDataName,'Processed Data Visualization'),'FontWeight','bold','Color',[1 0 0]);
            
            output= strcat(fullfile(saveDir,processedDataName),'_StimMap.jpg');
            orient portrait
            print ('-djpeg', '-r300', output);
            
            figure('visible', 'on');
            close all
            
            %Check functional connectivty
        end
    end
    
end