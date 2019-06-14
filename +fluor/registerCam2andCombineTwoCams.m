function raw_combined  = registerCam2andCombineTwoCams(rawdata_cam1,rawdata_cam2,mytform,mouseType)

registered_cam2 = zeros(size(rawdata_cam2)); 

if strcmp(char(mouseType),'WT')
    channels_cam1 = [3];
    channels_cam2 = [4];
elseif strcmp(char(mouseType),'gcamp6f')
    channels_cam1 = [1 3];
    channels_cam2 = [4];
elseif strcmp(char(mouseType),'jrgeco1a')
    channels_cam1 = [3];
    channels_cam2 = [2 4];
end

for ii = 1: length(channels_cam2)
    for jj = 1:size(rawdata_cam2,4)
        registered_cam2(:,:,channels_cam2(ii),jj) = imwarp(rawdata_cam2(:,:,channels_cam2(ii),jj), mytform,'OutputView',imref2d(size(rawdata_cam2)));
    end
end


raw = zeros(size(rawdata_cam1));
raw(:,:,channels_cam1,:) = rawdata_cam1(:,:,channels_cam1,:);
raw(:,:,channels_cam2,:) = registered_cam2(:,:,channels_cam2,:);

channels_combined = sort([channels_cam1 channels_cam2]);

raw_combined =  raw(:,:,channels_combined,:);