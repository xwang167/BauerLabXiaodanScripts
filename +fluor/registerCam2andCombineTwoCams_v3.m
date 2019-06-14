function raw_combined  = registerCam2andCombineTwoCams_v3(rawdata_cam1,rawdata_cam2,mytform)

registered_cam2 = zeros(size(rawdata_cam2)); 


channels_cam2 = size(rawdata_cam2,3);
for ii = 1: length(channels_cam2)
    for jj = 1:size(rawdata_cam2,4)
        registered_cam2(:,:,channels_cam2(ii),jj) = imwarp(rawdata_cam2(:,:,channels_cam2(ii),jj), mytform,'OutputView',imref2d(size(rawdata_cam2)));
    end
end


    raw = zeros(size(rawdata_cam1,1),size(rawdata_cam1,2),5,size(rawdata_cam1,4));
    raw(:,:,[1 4],:) = rawdata_cam1;
    raw(:,:,[2 3 5],:) = rawdata_cam2;

raw_combined =  raw;