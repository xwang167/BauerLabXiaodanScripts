database='G:\OISProjects\CulverLab\Stroke\OptoStroke.xlsx';
excelfiles=[154:182];  % Rows from Excell Database

for n=excelfiles;
    
    [~, ~, raw]=xlsread(database,1, ['A',num2str(n),':K',num2str(n)]);
    Date=num2str(raw{1});
    Mouse=raw{2};
    rawdataloc=raw{3};
    saveloc=raw{4};
    sessiontype=eval(raw{6});
    directory=[saveloc, Date, '\'];
    
    if strcmp(Mouse(1:2),'TH')||strcmp(Mouse(1:2),'Th')
        disp(['Skipping ', Date, '-', Mouse])
        continue
    else
        TempDataHbL=[];
        for LeftPaw=4:6 % Right hemi activation
            file=[directory, Date,'-', Mouse,'-stim', num2str(LeftPaw), '-datahb.mat'];
            if exist(file)
                disp(['Loading ', file])
                load(file, 'xform_datahb', 'info');
                [nVy, nVx, hb, T]=size(xform_datahb);
                
                R=mod(size(xform_datahb,4),info.stimblocksize);
                if R~=0
                    pad=info.stimblocksize-R;
                    disp(['** Non integer number of blocks presented. Padded ', file, ' with ', num2str(pad), ' zeros **'])
                    xform_datahb(:,:,:,end:end+pad)=0;
                end
                
                TempDataHbL=cat(4,TempDataHbL,xform_datahb);
            else
                disp([file, ' does not exist'])
            end
        end
        
        load([directory, Date,'-', Mouse,'-LandmarksandMask.mat'], 'xform_isbrain');
        [Oxy, DeOxy]=gsr(TempDataHbL,xform_isbrain);
        
        Oxy=reshape(Oxy, nVy, nVx, info.stimblocksize, []);
        DeOxy=reshape(DeOxy, nVy, nVx, info.stimblocksize, []);
        Total=Oxy+DeOxy;
        
        for b=1:size(Oxy,4)
            MeanFrame=squeeze(mean(Oxy(:,:,1:info.stimbaseline,b),3));
            for t=1:size(Oxy, 3)
                Oxy(:,:,t,b)=squeeze(Oxy(:,:,t,b))-MeanFrame;
            end
        end
        
        for b=1:size(DeOxy,4)
            MeanFrame=squeeze(mean(DeOxy(:,:,1:info.stimbaseline,b),3));
            for t=1:size(DeOxy, 3)
                DeOxy(:,:,t,b)=squeeze(DeOxy(:,:,t,b))-MeanFrame;
            end
        end
        
        for b=1:size(Total,4)
            MeanFrame=squeeze(mean(Total(:,:,1:info.stimbaseline,b),3));
            for t=1:size(Total, 3)
                Total(:,:,t,b)=squeeze(Total(:,:,t,b))-MeanFrame;
            end
        end
        
        AvgOxy=mean(Oxy,4);
        AvgDeOxy=mean(DeOxy,4);
        AvgTotal=mean(Total,4);
        
        MeanFrame=squeeze(mean(AvgOxy(:,:,1:info.stimbaseline),3));
        for t=1:size(AvgOxy, 3)
            AvgOxy(:,:,t)=squeeze(AvgOxy(:,:,t))-MeanFrame;
        end
        
        MeanFrame=squeeze(mean(AvgDeOxy(:,:,1:info.stimbaseline),3));
        for t=1:size(AvgDeOxy, 3)
            AvgDeOxy(:,:,t)=squeeze(AvgDeOxy(:,:,t))-MeanFrame;
        end
        
        MeanFrame=squeeze(mean(AvgTotal(:,:,1:info.stimbaseline),3));
        for t=1:size(AvgTotal, 3)
            AvgTotal(:,:,t)=squeeze(AvgTotal(:,:,t))-MeanFrame;
        end
        
        MeanOxyMapRegL=mean(AvgOxy(:,:,info.stimbaseline+info.stimduration-2:info.stimbaseline+info.stimduration+2),3);
        MeanDeOxyMapRegL=mean(AvgDeOxy(:,:,info.stimbaseline+info.stimduration-2:info.stimbaseline+info.stimduration+2),3);
        MeanTotalMapRegL=mean(AvgTotal(:,:,info.stimbaseline+info.stimduration-2:info.stimbaseline+info.stimduration+2),3);
        
        if ~exist([directory, Date,'-', Mouse,'-Activations2.mat']);
            disp(['Saving activations for ', Date,'-', Mouse,'-stim'])
            save([directory, Date,'-', Mouse,'-Activations2.mat'],'MeanOxyMapRegL','MeanDeOxyMapRegL', 'MeanTotalMapRegL');
        else
            disp(['Saving activations for ', Date,'-', Mouse,'-stim'])
            save([directory, Date,'-', Mouse,'-Activations2.mat'],'MeanOxyMapRegL','MeanDeOxyMapRegL', 'MeanTotalMapRegL', '-append');
        end
        
        clearvars -except excelfiles database Block On Off Date Mouse rawdataloc saveloc sessiontype directory xform_isbrain
        
        TempDataHbR=[];
        for RightPaw=1:3 % Left hemi activation
            file=[directory, Date,'-', Mouse,'-stim', num2str(RightPaw), '-datahb.mat'];
            if exist(file)
                disp(['Loading ', file])
                
                load(file, 'xform_datahb', 'info');
                [nVy, nVx, hb, T]=size(xform_datahb);
                
                R=mod(size(xform_datahb,4),info.stimblocksize);
                if R~=0
                    pad=info.stimblocksize-R;
                    disp(['** Non integer number of blocks presented. Padded ', file , ' with ', num2str(pad), ' zeros **'])
                    xform_datahb(:,:,:,end:end+pad)=0;
                end    
                TempDataHbR=cat(4,TempDataHbR,xform_datahb);
            else
                disp([file, ' does not exist'])
            end
        end
        
        load([directory, Date,'-', Mouse,'-LandmarksandMask.mat'], 'xform_isbrain');
        [Oxy, DeOxy]=gsr(TempDataHbR,xform_isbrain);
        
        Oxy=reshape(Oxy, nVy, nVx, info.stimblocksize, []);
        DeOxy=reshape(DeOxy, nVy, nVx, info.stimblocksize, []);
        Total=Oxy+DeOxy;
        
        for b=1:size(Oxy,4)
            MeanFrame=squeeze(mean(Oxy(:,:,1:info.stimbaseline,b),3));
            for t=1:size(Oxy, 3)
                Oxy(:,:,t,b)=squeeze(Oxy(:,:,t,b))-MeanFrame;
            end
        end
        
        for b=1:size(DeOxy,4)
            MeanFrame=squeeze(mean(DeOxy(:,:,1:info.stimbaseline,b),3));
            for t=1:size(DeOxy, 3)
                DeOxy(:,:,t,b)=squeeze(DeOxy(:,:,t,b))-MeanFrame;
            end
        end
        
        for b=1:size(Total,4)
            MeanFrame=squeeze(mean(Total(:,:,1:info.stimbaseline,b),3));
            for t=1:size(Total, 3)
                Total(:,:,t,b)=squeeze(Total(:,:,t,b))-MeanFrame;
            end
        end
        
        AvgOxy=mean(Oxy,4);
        AvgDeOxy=mean(DeOxy,4);
        AvgTotal=mean(Total,4);
        
        MeanFrame=squeeze(mean(AvgOxy(:,:,1:info.stimbaseline),3));
        for t=1:size(AvgOxy, 3)
            AvgOxy(:,:,t)=squeeze(AvgOxy(:,:,t))-MeanFrame;
        end
        
        MeanFrame=squeeze(mean(AvgDeOxy(:,:,1:info.stimbaseline),3));
        for t=1:size(AvgDeOxy, 3)
            AvgDeOxy(:,:,t)=squeeze(AvgDeOxy(:,:,t))-MeanFrame;
        end
        
        MeanFrame=squeeze(mean(AvgTotal(:,:,1:info.stimbaseline),3));
        for t=1:size(AvgTotal, 3)
            AvgTotal(:,:,t)=squeeze(AvgTotal(:,:,t))-MeanFrame;
        end
        
        MeanOxyMapRegR=mean(AvgOxy(:,:,info.stimbaseline+info.stimduration-2:info.stimbaseline+info.stimduration+2),3);
        MeanDeOxyMapRegR=mean(AvgDeOxy(:,:,info.stimbaseline+info.stimduration-2:info.stimbaseline+info.stimduration+2),3);
        MeanTotalMapRegR=mean(AvgTotal(:,:,info.stimbaseline+info.stimduration-2:info.stimbaseline+info.stimduration+2),3);
        
        if ~exist([directory, Date,'-', Mouse,'-Activations2.mat'])
            disp(['Saving activations for ', Date,'-', Mouse,'-stim'])
            save([directory, Date,'-', Mouse,'-Activations2.mat'],'MeanOxyMapRegR','MeanDeOxyMapRegR', 'MeanTotalMapRegR');
        else
            disp(['Saving activations for ', Date,'-', Mouse,'-stim'])
            save([directory, Date,'-', Mouse,'-Activations2.mat'],'MeanOxyMapRegR','MeanDeOxyMapRegR', 'MeanTotalMapRegR', '-append');
        end
        clearvars -except excelfiles database Block On Off
    end
end