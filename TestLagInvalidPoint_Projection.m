% load('L:\RGECO\191028\191028-R6M1-awake-fc1_processed.mat', 'xform_jrgeco1aCorr');
% load('D:\OIS_Process\noVasculatureMask.mat')
% 
% %% resize to half
% data = imresize(xform_jrgeco1aCorr,0.5);
% clear xform_jrgeco1aCorr
% leftMask = imresize(leftMask,0.5);
% rightMask = imresize(rightMask,0.5);
% mask = leftMask+rightMask;
% for ii = 1:length(data)
%     data(:,:,ii) = data(:,:,ii).*double(mask);
% end
% data(isinf(data)) = 0;
% data(isnan(data)) = 0;
% data = mouse.freq.filterData(double(data),0.4,4,25);
% outFreq = 10;
% data = resampledata(data,25,outFreq,10^-5);
% mask = logical(mask);
% nVx= size(mask,2);
% nVy = size(mask,1);
% mask = reshape(mask,[],1);
% data = reshape(data,[],size(data,3));
% tZone = 4;
% validRange = -round(tZone*outFreq): round(tZone*outFreq);
% edgeLen = 1;
% corrThr = 0;
% ind = sub2ind([64,64],28,52);
lagTimeProjVec = nan(1,size(data,1));
lagAmpProjVec = nan(1,size(data,1));
for jj = 1:size(data,1)
    if mask(jj)==1
        [lagTimeProjVec(jj),lagAmpProjVec(jj)] = mouse.conn.findLag(...
            data(ind,:),data(jj,:),true,true,validRange,edgeLen,corrThr);
    end
end


figure
lagTimeProjVec = reshape(lagTimeProjVec,64,64);
imagesc(lagTimeProjVec/10)
colormap jet
colorbar
axis image off
 title('LagTime')
  hold on;scatter(11,40,'filled','y')
 figure
 lagAmpProjVec = reshape(lagAmpProjVec,64,64);
 imagesc(lagAmpProjVec)
 colormap jet
 colorbar
 axis image off 
title('Correlation')

ind2 = sub2ind([64,64],44,43);
[lagTime,lagAmp,covResult,sign,lags,covResult_all,lags_all] = mouse.conn.findLag(...
            data(ind,:),data(ind2,:),true,true,validRange,edgeLen,corrThr);
        '
ind2 = sub2ind([64,64],40,11);
[lagTime,lagAmp,covResult,sign,lags,covResult_all,lags_all] = mouse.conn.findLag(...
            data(ind,3:end),data(ind2,3:end),true,true,validRange,edgeLen,corrThr);