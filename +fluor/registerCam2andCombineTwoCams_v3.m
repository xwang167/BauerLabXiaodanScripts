function raw  = registerCam2andCombineTwoCams_v3(rawdata_cam1,rawdata_cam2,mytform,mouseType)

registered_cam2 = zeros(size(rawdata_cam2)); 


channels_cam2 = size(rawdata_cam2,3);
for ii = 1: length(channels_cam2)
    for jj = 1:size(rawdata_cam2,4)
        registered_cam2(:,:,channels_cam2(ii),jj) = imwarp(rawdata_cam2(:,:,channels_cam2(ii),jj), mytform,'OutputView',imref2d(size(rawdata_cam2)));
    end
end


    
    if strcmp(mouseType,'PV')
        channels = 3;
        cam1Chan = [1,3];
        cam2Chan = 2;
    else
        channels = 4;
        cam1Chan = [1 3];
        cam2Chan = [2 4];
    end
    raw = zeros(size(rawdata_cam1,1),size(rawdata_cam1,2),channels,size(rawdata_cam1,4));
    raw(:,:,cam1Chan,:) = rawdata_cam1;
    raw(:,:,cam2Chan,:) = rawdata_cam2;

