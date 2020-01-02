function John_GetLandMarksandMask_xw(Date, Mouse, directory, rawdataloc, system)

if exist([directory, Date,'-', Mouse,'-LandmarksandMask.mat'])
    disp(['Landmarks and mask file already exists for ', Date,'-', Mouse])
else
    
    if ~exist(directory);
        mkdir(directory);
    end
    
    filename=[rawdataloc,Date,'-', Mouse,'-fc1.tif'];
    if ~exist(filename);
        filename=[rawdataloc,Date,'-', Mouse,'-WL.tif'];
        if ~exist(filename);
            disp(['Data for ', rawdataloc,Date,'-', Mouse, ' not found'])
        end
    end
    
    WL=zeros(128,128,3);
    i=0;
    
    if strcmp(system, 'fcOIS1')
       for k = [5,7,8];    %make WL image (r, y, b channels)
        %for k = [7,9,10];    %make WL image (r, y, b channels)            
            i=i+1;
            WL(:,:,i) = fliplr(imread(filename,k));
        end
    elseif strcmp(system, 'fcOIS2')||strcmp(system, 'EastOIS1')
        if exist(filename)
        for k = [8,6,5];    %make WL image (r, g, b channels)
            i=i+1;
            WL(:,:,i) = fliplr(imread(filename,k));
        end
        else
            WL = ones(128,128,3);
        end
    end
    
    WL(:,:,1)=WL(:,:,1)/max(max(WL(:,:,1)));
    WL(:,:,2)=WL(:,:,2)/max(max(WL(:,:,2)));
    WL(:,:,3)=WL(:,:,3)/max(max(WL(:,:,3)));
    
    disp([Date,'-', Mouse])
    
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
    
    imwrite(WL,[directory,Date,'-',Mouse,'-WL.tif'],'tiff');
    save([directory, Date,'-', Mouse,'-LandmarksandMask.mat'], 'WLcrop', 'xform_WLcrop', 'xform_isbrain', 'isbrain', 'WL', 'xform_WL', 'I', 'seedcenter');
    close all
end
