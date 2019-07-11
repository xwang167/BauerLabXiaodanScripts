function GetLandMarksandMask_fluor(Date, Mouse, directory, rawdataloc, systemType,systemInfo,sessionInfo)

if exist(fullfile(directory,strcat(Date,'-', Mouse,'-mask.mat')))
    disp(strcat('Landmarks and mask file already exists for ', Date,'-', Mouse))
else
    
    if ~exist(directory);
        mkdir(directory);
    end
    
    filename=fullfile(rawdataloc,strcat(Date,'-', Mouse,'-fc1.tif'));
    if ~exist(filename);
        filename=fullfile(rawdataloc,strcat(Date,'-', Mouse,'-stim1.tif'));
        if ~exist(filename);
            disp(['Data for ', rawdataloc,Date,'-', Mouse, ' not found'])
        end
    end
    
    WL=zeros(128,128,3);
    i=0;
    
    if strcmp(systemType, 'EastOIS1_Fluor')
        for k = systemInfo.rgb + sessionInfo.darkFrameNum*4
            i = i+1;
            WL(:,:,i) = fliplr(imread(filename,k));
        end
    
    elseif    strcmp(systemType, 'fcOIS1')
       for k = [5,7,8];    %make WL image (r, y, b channels)
        %for k = [7,9,10];    %make WL image (r, y, b channels)            
            i=i+1;
            WL(:,:,i) = fliplr(imread(filename,k));
        end
    elseif strcmp(systemType, 'fcOIS2')||strcmp(systemType, 'EastOIS1')||strcmp(systemType, 'EastOIS1_Fluor')
        for k = [8,6,5];    %make WL image (r, g, b channels)
            i=i+1;
            WL(:,:,i) = fliplr(imread(filename,k));
        end
    
    end
    
    WL(:,:,1)=WL(:,:,1)/max(max(WL(:,:,1)));
    WL(:,:,2)=WL(:,:,2)/max(max(WL(:,:,2)));
    WL(:,:,3)=WL(:,:,3)/max(max(WL(:,:,3)));
    
    disp(strcat('get landmarks and mask for',Date,'-', Mouse))
    
    [I, seedcenter]=MakeSeedsMouseSpace(WL);
    
    disp('Create mask')
    mask=roipoly(WL);
    
    if ~any(any(mask))
        load('D:\MatlabCode\NeuroDOT\OIS\Paxinos\AtlasandIsbrain.mat', 'parcelisbrainPS');
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
        
        isbrain=single(uint8(mask));
        [xform_isbrain]=Affine(I, isbrain, 'New');
        xform_isbrain=single(uint8(xform_isbrain));
        
        [xform_WL]=Affine(I, WL, 'New');
        
        for j=1:3;
            xform_WLcrop(:,:,j)=xform_WL(:,:,j).*xform_isbrain; %make affine transform WL image
        end
        
        WLcrop=WL;
        for j=1:3;
            WLcrop(:,:,j)=WLcrop(:,:,j).*isbrain; %make WLcrop image
        end
    end
    
    imwrite(WL,fullfile(directory,strcat(Date,'-',Mouse,'-WL.tif')));
    save(fullfile(directory, strcat(Date,'-', Mouse,'-mask.mat')), 'WLcrop', 'xform_WLcrop', 'xform_isbrain', 'isbrain', 'WL', 'xform_WL', 'I', 'seedcenter');
    close all
end
