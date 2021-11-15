clear all;
close all;
%9/26/20 added and then removed '\radiometic' to lines 15, 134 and 135.  Will need to be taken out later 

database = 'L:\RGECO\RGECO.xlsx'; %filepath of Excel database
% database = 'F:\PracticeEEG_EMG_181204.xlsx'; %filepath of Excel database
excelfiles=[2:4]; %Rows from Excel database to actually process 113  115 114 

for line=excelfiles;
    [~, ~, raw]=xlsread(database,1, ['A',num2str(line),':K',num2str(line)]);
    Date=num2str(raw{1});
    Mouse=num2str(raw{2});
    rawdataloc=raw{3};
    saveloc=raw{4};
    directory=[saveloc, Date, '\'];
    
    if exist([directory, Date,'-', Mouse,'-LandmarksandMask_Eric.mat'])
        disp(['Landmarks and mask file already exists for ', Date,'-', Mouse])
        continue
    else
        if ~exist(directory);
            mkdir(directory);
        end
        
        load(['L:\RGECO\', Date,'\',Date,'-', Mouse,'-LandmarksandMask.mat'], 'WL')
        
        disp([Date,'-', Mouse])
        
        [I, seedcenter]=MakeSeedsMouseSpace(WL);
        
        disp('Create mask')
        mask=roipoly(WL);
        
        if ~any(any(mask))
            load('AtlasandIsbrain.mat', 'parcelisbrainPS');
            isbrain=InvAffine(I, parcelisbrainPS, 'New');
            isbrain=single(uint8(isbrain));
            [xform_isbrain]=Affine(I, isbrain, 'New');
            xform_isbrain=single(uint8(xform_isbrain));
            
            [xform_WL]=Affine(I, WL, 'New');
            
            for j=1:3;
                xform_WLcrop(:,:,j)=xform_WL(:,:,j).*parcelisbrainPS; %make affine transform WL image
            end
            
            WLcrop=WL;
            for j=1:3;
                WLcrop(:,:,j)=WLcrop(:,:,j).*isbrain; %make WLcrop image
            end
            
        else
            
            mask=single(uint8(mask));
            [xform_mask]=Affine(I, mask, 'New');
            xform_mask=single(uint8(xform_mask));
            
            [xform_WL]=Affine(I, WL, 'New');
            
            for j=1:3;
                xform_WLcrop(:,:,j)=xform_WL(:,:,j).*xform_mask; %make affine transform WL image
            end
            
            WLcrop=WL;
            for j=1:3;
                WLcrop(:,:,j)=WLcrop(:,:,j).*mask; %make WLcrop image
            end
        end
        
        imagesc(xform_WLcrop);
        
        pause;
        
        save([directory, Date,'-', Mouse,'-LandmarksandMask_Eric.mat'], 'WLcrop', 'xform_WLcrop', 'xform_mask', 'mask', 'WL', 'xform_WL', 'I', 'seedcenter');
        
    end
    close all
end


excelfiles=[5:7]; %Rows from Excel database to actually process 113  115 114 

for line=excelfiles;
    [~, ~, raw]=xlsread(database,1, ['A',num2str(line),':K',num2str(line)]);
    Date=num2str(raw{1});
    Mouse=num2str(raw{2});
    rawdataloc=raw{3};
    saveloc=raw{4};
    directory=[saveloc, Date, '\'];
    
    if exist([directory, Date,'-', Mouse,'-LandmarksandMask_Eric.mat'])
        disp(['Landmarks and mask file already exists for ', Date,'-', Mouse])
        continue
    else
        if ~exist(directory);
            mkdir(directory);
        end    
        disp([Date,'-', Mouse])
       
       load(['L:\RGECO\', Date,'\',Date,'-', Mouse,'-LandmarksandMask.mat'])
        I = affineMarkers;
        xform_mask = xform_isbrain;
        mask = isbrain;
        save([directory, Date,'-', Mouse,'-LandmarksandMask_Eric.mat'], 'WLcrop', 'xform_WLcrop', 'xform_mask', 'mask', 'WL', 'xform_WL', 'I', 'seedcenter');
        
    end
    close all
end