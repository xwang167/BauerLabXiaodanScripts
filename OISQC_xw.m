
excelFile = "X:\XW\CodeModification\CodeModification.xlsx";
excelRows = [6];
runsInfo = parseRuns(excelFile,excelRows);
runNum = numel(runsInfo);
for runInd = 1:runNum
    clearvars -except runsInfo runNum runInd fRange_ISA fRange_delta
    runInfo=runsInfo(runInd);
%     load(runInfo.saveHbFile,'xform_datahb')
load(runInfo.saveHbFile,'datahb')
    load(runInfo.saveMaskFile,'isbrain','I')
    load(fullfile('V:\ARB-Old',runInfo.recDate,strcat(runInfo.recDate,'-',runInfo.mouseName,'-LandmarksandMask.mat')),'seedcenter','WL')
%     I_new.bregma = I.bregma*128;
%     I_new.tent = I.tent*128;
%     I_new.OF = I.OF*128;
%     datahb = InvAffine(I_new,xform_datahb,'new');
%     datahb = highpass(datahb,0.009,29.76);
%     datahb = lowpass(datahb,0.08,29.76);
%     datahb=resampledata_ori(datahb,29.76,1,10^-5);
    datahb=real(datahb);
    [Oxy]=gsr(squeeze(datahb(:,:,1,:)),isbrain);
    [DeOxy]=gsr(squeeze(datahb(:,:,2,:)),isbrain);
    Oxy=reshape(Oxy, 128, 128, []); % -added MDR 1/22
    DeOxy=reshape(DeOxy, 128, 128, []); % -added MDR 1/22
    
    %% Check Evoked Responses
    
    if strcmp(runInfo.session, 'stim')
        
        R=mod(size(Oxy,3),runInfo.blockLen);
        if R~=0
            pad=runInfo.blockLen-R;
            disp(['** Non integer number of blocks presented. Padded ' ' with ', num2str(pad), ' zeros **'])
            Oxy(:,:,end:end+pad)=0;
            DeOxy(:,:,end:end+pad)=0;
            info.appendedzeros=pad;
        end
        Oxy=reshape(Oxy,128,128,runInfo.blockLen,[]);
        
        for b=1:size(Oxy,4)
            MeanFrame=squeeze(mean(Oxy(:,:,1:runInfo.stimStartTime,b),3));
            for t=1:size(Oxy, 3);
                Oxy(:,:,t,b)=squeeze(Oxy(:,:,t,b))-MeanFrame;
            end
        end
        
        DeOxy=reshape(DeOxy,128,128,runInfo.blockLen,[]);
        for b=1:size(DeOxy,4)
            MeanFrame=squeeze(mean(DeOxy(:,:,1:runInfo.stimStartTime,b),3));
            for t=1:size(DeOxy, 3);
                DeOxy(:,:,t,b)=squeeze(DeOxy(:,:,t,b))-MeanFrame;
            end
        end
        
        AvgOxy=mean(Oxy,4);
        AvgDeOxy=mean(DeOxy,4);
        AvgTotal=mean(Oxy+DeOxy,4);
        
        MeanFrame=squeeze(mean(AvgOxy(:,:,1:runInfo.stimStartTime),3));
        for t=1:size(AvgOxy, 3);
            AvgOxy(:,:,t)=squeeze(AvgOxy(:,:,t))-MeanFrame;
        end
        
        MeanFrame=squeeze(mean(AvgDeOxy(:,:,1:runInfo.stimStartTime),3));
        for t=1:size(AvgDeOxy, 3);
            AvgDeOxy(:,:,t)=squeeze(AvgDeOxy(:,:,t))-MeanFrame;
        end
        
        MeanFrame=squeeze(mean(AvgTotal(:,:,1:runInfo.stimStartTime),3));
        for t=1:size(AvgTotal, 3);
            AvgTotal(:,:,t)=squeeze(AvgTotal(:,:,t))-MeanFrame;
        end
        
        %% Make Plots
        
        for b=1:size(Oxy,4);
            subplot('position', [0.03+(b-1)*0.095 0.5 0.095 0.095]);
            temp=Oxy(:,:,runInfo.stimEndTime,b);
            imagesc(temp, [-max(max(temp)) max(max(temp))]);
            axis image;
            set(gca, 'XTick', []);
            set(gca, 'YTick', []);
            if b==1
                ylabel('Oxy')
            end
            title(['Pres ', num2str(b)]);
        end
        
        for b=1:size(DeOxy,4);
            subplot('position', [0.03+(b-1)*0.095 0.35 0.095 0.095]);
            temp=DeOxy(:,:,runInfo.stimEndTime,b);
            imagesc(temp, [min(min(temp)) -1*min(min(temp))]);
            axis image;
            set(gca, 'XTick', []);
            set(gca, 'YTick', []);
            if b==1
                ylabel('DeOxy')
            end
            title(['Pres ', num2str(b)]);
        end
        
        for b=1:size(Oxy,4);
            subplot('position', [0.03+(b-1)*0.095 0.2 0.095 0.095]);
            temp=Oxy(:,:,runInfo.stimEndTime,b)+DeOxy(:,:,runInfo.stimEndTime,b);
            imagesc(temp, [-max(max(temp)) max(max(temp))]);
            axis image;
            set(gca, 'XTick', []);
            set(gca, 'YTick', []);
            if b==1
                ylabel('Total')
            end
            title(['Pres ', num2str(b)]);
        end
        
        subplot('position', [0.05 0.05 0.095 0.095]);
        temp=mean(AvgOxy(:,:,runInfo.stimEndTime-2:runInfo.stimEndTime),3);
        imagesc(temp, [-max(max(temp)) max(max(temp))]);
        axis image off
        title('Avg Oxy')
        
        subplot('position', [0.20 0.05 0.095 0.095]);
        temp=mean(AvgDeOxy(:,:,runInfo.stimEndTime-2:runInfo.stimEndTime),3);
        imagesc(temp, [min(min(temp)) -1*min(min(temp))]);
        axis image off
        title('Avg DeOxy')
        
        subplot('position', [0.35 0.05 0.095 0.095]);
        temp=mean(AvgTotal(:,:,runInfo.stimEndTime-2:runInfo.stimEndTime),3);
        imagesc(temp, [-max(max(temp)) max(max(temp))]);
        axis image off
        title('Avg Total')
        
        save(runInfo.saveHbFile, 'AvgOxy', 'AvgDeOxy', 'AvgTotal', 'Oxy', 'DeOxy', '-append');
        annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',[runInfo.recDate,'-',runInfo.mouseName,'-',runInfo.session,runInfo.run,' Data Visualization'],'FontWeight','bold','Color',[1 0 0]);
        
        output=[runInfo.saveFilePrefix,'_DataVis.jpg'];
        orient portrait
        print ('-djpeg', '-r300', output);
        
        figure('visible', 'on');
        close all
    elseif strcmp(runInfo.session, 'fc')
        Oxy=reshape(Oxy,128*128,[]);
        seednames={'Olf','Fr','Cg','M','SS','RS','V'};
        seedcenter=seedcenter(1:14,:);
        sides={'L','R'};
        
        mm=10;
        mpp=mm/128;
        seedradmm=0.25;
        seedradpix=seedradmm/mpp;
        
        numseeds=numel(seednames);
        numsides=numel(sides);
        
        P=burnseeds(seedcenter,seedradpix,isbrain);
        strace=P2strace(P,Oxy, seedcenter); %% strace is each seeds trace resulting from averaging the pixels within a seed region
        R=strace2R(strace,Oxy, 128, 128); %% normalize  rows in time, dot product of those rows with strce
        
        R(find(isnan(R)==1))=0; % added MDR 1/25
        
        Rs=normRow(strace)*normRow(strace)';
        figure('units','normalized','outerposition',[0 0 0.6 0.75])
        for s=1:numseeds
            
            OE=0;
            if mod(s,2)==0
                OE=0.25;
            else
                OE=0.05;
            end
            
            subplot('position', [OE (0.47-((round(s/2)-1)*0.15)) 0.1 0.1]);
            Im2=overlaymouse(R(:,:,(2*(s-1)+1)),WL, isbrain,'jet',-1,1);
            image(Im2); %changed 3/1/11
            hold on;
            plot(seedcenter(2*(s-1)+1,1),seedcenter(2*(s-1)+1,2),'ko');
            axis image off
            title([seednames{s},'L'])
            
            subplot('position', [OE+0.10 (0.47-((round(s/2)-1)*0.15)) 0.1 0.1]);
            Im2=overlaymouse(R(:,:,(2*(s-1)+2)),WL, isbrain,'jet',-1,1);
            image(Im2); %changed 3/1/11
            hold on;
            plot(seedcenter(2*(s-1)+2,1),seedcenter(2*(s-1)+2,2),'ko');
            axis image off
            title([seednames{s},'R'])
            hold off;
        end
        save(runInfo.saveHbFile,'R', 'Rs', '-append');
        
        
        annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',[runInfo.recDate,'-',runInfo.mouseName,'-',runInfo.session,runInfo.run,' Data Visualization'],'FontWeight','bold','Color',[1 0 0]);
        
        output=[runInfo.saveFilePrefix,'_DataVis.jpg'];
        orient portrait
        print ('-djpeg', '-r300', output);
        
        figure('visible', 'on');
        close all
        
    end
end




