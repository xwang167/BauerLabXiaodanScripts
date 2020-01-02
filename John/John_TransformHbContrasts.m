function John_TransformHbContrasts(Date, Mouse, saveloc, sessiontype, info, gsrornot)
% This function performs gsr on affine transformed datahb and saves the
% different contrasts

m = 1;
filename = [saveloc,Date,'\',Date,'-',Mouse];
while 1
    loopfile1 = [filename,'-',sessiontype{1},num2str(m),'-datahb.mat'];
    loopfile2 = [filename,'-LandmarksandMask.mat'];
    if ~exist(loopfile1,'file');
        m=m+1;
        loopfile1=[filename,num2str(m),'-datahb.mat'];
        if ~exist(loopfile1,'file');
            break
        end
    end
    
    vars = whos('-file',loopfile1);
    if ismember('Oxy', {vars.name})
        disp([Date,'-',Mouse,'-',sessiontype{1},num2str(m),' Hb contrasts already transformed'])
        m=m+1;
    else
        disp([Date,'-',Mouse,'-',sessiontype{1},num2str(m),' Transforming Hb contrasts'])
        load(loopfile1,'xform_datahb');
        load(loopfile2, 'xform_isbrain');
        [nVy,nVx,~,~] = size(xform_datahb);

        framenum = info.freqout*info.stimblocksize*5; %4 blocks
        extraframes = framenum - size(xform_datahb,4);
        disp(['Extra frames removed: ',num2str(extraframes)])
        xform_datahb = xform_datahb(:,:,:,1:framenum);
        xform_datahb=real(xform_datahb);
        
        % Global signal regression of transformed datahb
        if gsrornot == 1
            disp('Performing gsr')
            [Oxy, DeOxy]=gsr(xform_datahb,xform_isbrain);
        elseif gsrornot == 0
            disp('gsr not performed')
            Oxy = squeeze(xform_datahb(:,:,1,:));
            DeOxy = squeeze(xform_datahb(:,:,2,:)); 
        else
            disp('Invalid gsr input')
        end
        Total = Oxy + DeOxy;
            
        % Baseline subtraction for different hb contrasts
        Oxy=reshape(Oxy,nVy,nVx,info.stimblocksize,[]);
        for b=1:size(Oxy,4)
            MeanFrame=squeeze(mean(Oxy(:,:,1:info.stimbaseline,b),3));
            for t=1:size(Oxy, 3);
                Oxy(:,:,t,b)=squeeze(Oxy(:,:,t,b))-MeanFrame;
            end
        end
        
        DeOxy=reshape(DeOxy,nVy,nVx,info.stimblocksize,[]);
        for b=1:size(DeOxy,4)
            MeanFrame=squeeze(mean(DeOxy(:,:,1:info.stimbaseline,b),3));
            for t=1:size(DeOxy, 3);
                DeOxy(:,:,t,b)=squeeze(DeOxy(:,:,t,b))-MeanFrame;
            end
        end
        
        Total=reshape(Total,nVy,nVx,info.stimblocksize,[]);
        for b=1:size(Total,4)
            MeanFrame=squeeze(mean(Total(:,:,1:info.stimbaseline,b),3));
            for t=1:size(Total, 3);
                Total(:,:,t,b)=squeeze(Total(:,:,t,b))-MeanFrame;
            end
        end
        
        % Average across blocks
        AvgOxy=mean(Oxy,4);
        AvgDeOxy=mean(DeOxy,4);
        AvgTotal=mean(Total,4);
        
        save([filename,'-',sessiontype{1},num2str(m),'-datahb'], 'AvgOxy','AvgDeOxy', 'AvgTotal', 'Oxy', 'DeOxy', 'Total', '-append');
        m = m+1;
    end
end
end








