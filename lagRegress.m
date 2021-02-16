load('L:\RGECO\190710\190710-R5M2285-anes-fc1_processed.mat', 'xform_jrgeco1aCorr')
load('L:\RGECO\Kenny\190710\190710-R5M2285-anes-fc1-datafluor.mat', 'xform_isbrain')
saveDir = 'L:\RGECO\190710\';
load('D:\OIS_Process\atlas.mat','AtlasSeeds')
left = AtlasSeeds==12 ;
right = AtlasSeeds == 32;
isRS = left+right;
isRS = isRS(:);
isRS = logical(isRS);
origSize = size(xform_jrgeco1aCorr);
xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr, numel(isRS),origSize(end));
sRS= squeeze(nanmean(xform_jrgeco1aCorr(isRS(:), :), 1));

plot((1:14999)/25,sRS)
title('Average Signal of RS')
sRS_matrix = nan(128,128,length(sRS));
for ii = 1:128
    for jj = 1:128
        sRS_matrix(ii,jj,:) = sRS;
    end
end
xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,origSize(1),origSize(2),origSize(end));
fs = 25;
tZone = 4;
corrThr = 0;
validRange = - round(tZone*fs): round(tZone*fs);
edgeLen = 1;
[lagTime_sRS,lagAmp_sRS,~] = mouse.conn.dotLag(...
    xform_jrgeco1aCorr,sRS_matrix,edgeLen,validRange,corrThr,true,true);


lagSRS_matrix = nan(128,128,length(sRS));

for ii = 1:128
    for jj = 1:128
        if ~isnan(lagTime_sRS(ii,jj))
            lagSRS_matrix(ii,jj,:) = fraccircshift(sRS,lagTime_sRS(ii,jj));
        end
    end
end

xform_jrgeco1aCorr_RSR = nan(128,128,length(sRS));


xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;
xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
lagSRS_matrix(isnan(lagSRS_matrix)) = 0;
for ii = 1:128
    for jj = 1:128
        [xform_jrgeco1aCorr_RSR(ii,jj,:)] = mouse.process.regcorr(transpose(squeeze(xform_jrgeco1aCorr(ii,jj,:))), transpose(squeeze(lagSRS_matrix(ii,jj,:))));
    end
end

figure

for ii = 1:length(sRS)
    imagesc(xform_jrgeco1aCorr_RSR(:,:,ii),[-0.05 0.05]); %subplot(1,3,1);
    %     subplot(1,3,2);imagesc(xform_jrgeco1aCorr(:,:,ii),[-0.05 0.05]);
    %     subplot(1,3,3);imagesc(xform_jrgeco1aCorr(:,:,ii)-xform_jrgeco1aCorr_RSR(:,:,ii),[-0.05 0.05]);pause;
    
    pause(0.1);
end
load('D:\OIS_Process\noVasculatureMask.mat')
mask = leftMask+rightMask;
[hz,powerdata_jrgeco1aCorr_RSR] = QCcheck_CalcPDS(real(double(xform_jrgeco1aCorr_RSR))/0.01,25,mask);
[hz,powerdata_jrgeco1aCorr] = QCcheck_CalcPDS(real(double(xform_jrgeco1aCorr))/0.01,25,mask);


refseeds=GetReferenceSeeds_xw;
saveDir = 'L:\RGECO\190710\';

visName = '190710-R5M2285-anes-fc1-RSR-DeltaFC';
[R_jrgeco1aCorr_Delta_RSR,Rs_jrgeco1aCorr_Delta_RSR] = QCcheck_CalcRRs(refseeds,double(xform_jrgeco1aCorr_RSR)/0.01,25,xform_isbrain,[0.7,3],false);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_RSR, Rs_jrgeco1aCorr_Delta_RSR,'jrgeco1aCorr','m','Delta',saveDir,visName,false,xform_isbrain)

visName = '190710-R5M2285-anes-fc1-RSR-GSR-DeltaFC';
[R_jrgeco1aCorr_Delta_RSR,Rs_jrgeco1aCorr_Delta_RSR] = QCcheck_CalcRRs(refseeds,double(xform_jrgeco1aCorr_RSR)/0.01,25,xform_isbrain,[0.7,3],true);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_RSR, Rs_jrgeco1aCorr_Delta_RSR,'jrgeco1aCorr','m','Delta',saveDir,visName,false,xform_isbrain)




figure
lagAmp_sRS(logical(1-xform_isbrain)) = nan;
imagesc(lagAmp_sRS,[0.5 1])
colormap jet
axis image off
[x1,y1] = ginput(1);
[x2,y2] = ginput(1);

radius = sqrt((x1-x2)^2+(y1-y2)^2);

[X,Y] = meshgrid(1:128,1:128);
ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
temp = double(lagAmp_sRS).*double(ROI);
ROI_left = temp<0.67;
ROI_left(temp<0.4) = 0;
hold on
ROI_contour = bwperim(ROI_left);
[~,c] = contour( ROI_contour,'r');
c.LineWidth = 0.001;

[x1,y1] = ginput(1);
[x2,y2] = ginput(1);

radius = sqrt((x1-x2)^2+(y1-y2)^2);

[X,Y] = meshgrid(1:128,1:128);
ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
temp = double(lagAmp_sRS).*double(ROI);
ROI_right = temp<0.67;
ROI_right(temp<0.4) = 0;
hold on
ROI_contour = bwperim(ROI_right);
[~,c] = contour( ROI_contour,'r');
c.LineWidth = 0.001;
isMSS = ROI_left+ROI_right;

%% Simple test
test1 = zeros(1,10);
test1(3:6) = 1;
test2 = zeros(1,10);
test2(5:8) = 1;
test1_matrix = zeros(128,128,10);
test2_matrix = zeros(128,128,10);

for ii = 1:128
    for jj = 1:128
        test1_matrix(ii,jj,:) = test1;
        test2_matrix(ii,jj,:) = test2;
    end
end
[lagTime,lagAmp,~] = mouse.conn.dotLag(...
    test1_matrix,test2_matrix,edgeLen,validRange,corrThr,true,true);
lag_matrix = nan(128,128,length(test2));

for ii = 1:128
    for jj = 1:128
        lag_matrix(ii,jj,:) = circshift(test2,lagTime(ii,jj));
    end
end

regressedData = nan(128,128,length(test2));
for ii = 1:128
    for jj = 1:128
        [regressedData(ii,jj,:)] = mouse.process.regcorr(transpose(squeeze(test1_matrix(ii,jj,:))), transpose(squeeze(lag_matrix(ii,jj,:))));
    end
end

figure;
subplot(4,1,1);plot(test1);title('Signal 1');
subplot(4,1,2);plot(test2);title('Signal 2');
subplot(4,1,3);plot(squeeze(lag_matrix(1,1,:)));title('CircShift of Signal 2')
subplot(4,1,4);plot(squeeze(regressedData(ii,jj,:)));ylim([0,0.5]);title('Regressed Data')


%% M-SS regression
figure
lagAmp_sRS(logical(1-xform_isbrain)) = nan;
imagesc(lagAmp_sRS,[0.5 1])
colormap jet
axis image off
[x1,y1] = ginput(1);
[x2,y2] = ginput(1);

radius = sqrt((x1-x2)^2+(y1-y2)^2);

[X,Y] = meshgrid(1:128,1:128);
ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
temp = double(lagAmp_sRS).*double(ROI);
ROI_left = temp<0.67;
ROI_left(temp<0.4) = 0;
hold on
ROI_contour = bwperim(ROI_left);
[~,c] = contour( ROI_contour,'r');
c.LineWidth = 0.001;

[x1,y1] = ginput(1);
[x2,y2] = ginput(1);

radius = sqrt((x1-x2)^2+(y1-y2)^2);

[X,Y] = meshgrid(1:128,1:128);
ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
temp = double(lagAmp_sRS).*double(ROI);
ROI_right = temp<0.67;
ROI_right(temp<0.4) = 0;
hold on
ROI_contour = bwperim(ROI_right);
[~,c] = contour( ROI_contour,'r');
c.LineWidth = 0.001;
isMSS = ROI_left+ROI_right;

isMSS = isMSS(:);
isMSS = logical(isMSS);
xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr, numel(isMSS),origSize(end));
sMSS= squeeze(nanmean(xform_jrgeco1aCorr(isMSS(:), :), 1));
figure
plot((1:14999)/25,sMSS)
title('Average Signal of MSS')
sMSS_matrix = nan(128,128,length(sMSS));
for ii = 1:128
    for jj = 1:128
        sMSS_matrix(ii,jj,:) = sMSS;
    end
end
xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,origSize(1),origSize(2),origSize(end));
fs = 25;
tZone = 4;
corrThr = 0;
validRange = - round(tZone*fs): round(tZone*fs);
edgeLen = 1;
[lagTime_sMSS,lagAmp_sMSS,~] = mouse.conn.dotLag(...
    xform_jrgeco1aCorr,sMSS_matrix,edgeLen,validRange,corrThr,true,true);


lagSMSS_matrix = nan(128,128,length(sMSS));

for ii = 1:128
    for jj = 1:128
        if ~isnan(lagTime_sMSS(ii,jj))
            lagSMSS_matrix(ii,jj,:) = fraccircshift(sMSS,lagTime_sMSS(ii,jj));
        end
    end
end

xform_jrgeco1aCorr_RSR_MSSR = nan(128,128,length(sMSS));

lagSMSS_matrix(isnan(lagSMSS_matrix)) = 0;
for ii = 1:128
    for jj = 1:128
        [xform_jrgeco1aCorr_RSR_MSSR(ii,jj,:)] = mouse.process.regcorr(transpose(squeeze(xform_jrgeco1aCorr_RSR(ii,jj,:))), transpose(squeeze(lagSMSS_matrix(ii,jj,:))));
    end
end


[hz,powerdata_jrgeco1aCorr] = QCcheck_CalcPDS(real(double(xform_jrgeco1aCorr))/0.01,25,mask);
[hz,powerdata_jrgeco1aCorr_RSR] = QCcheck_CalcPDS(real(double(xform_jrgeco1aCorr_RSR))/0.01,25,mask);
[hz,powerdata_jrgeco1aCorr_RSR_MSSR] = QCcheck_CalcPDS(real(double(xform_jrgeco1aCorr_RSR_MSSR))/0.01,25,mask);
figure
loglog(hz,powerdata_jrgeco1aCorr);
hold on
loglog(hz,powerdata_jrgeco1aCorr_RSR);
hold on
loglog(hz,powerdata_jrgeco1aCorr_RSR_MSSR);
legend('Original','RS regression','RS regression then M-SS regression','location','southwest')


visName = '190710-R5M2285-anes-fc1-RSR-MSSR-DeltaFC';
[R_jrgeco1aCorr_Delta_RSR,Rs_jrgeco1aCorr_Delta_RSR] = QCcheck_CalcRRs(refseeds,double(xform_jrgeco1aCorr_RSR_MSSR)/0.01,25,xform_isbrain,[0.7,3],false);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_RSR, Rs_jrgeco1aCorr_Delta_RSR,'jrgeco1aCorr','m','Delta',saveDir,visName,false,xform_isbrain)

visName = '190710-R5M2285-anes-fc1-RSR-MSSR-GSR-DeltaFC';
[R_jrgeco1aCorr_Delta_RSR,Rs_jrgeco1aCorr_Delta_RSR] = QCcheck_CalcRRs(refseeds,double(xform_jrgeco1aCorr_RSR_MSSR)/0.01,25,xform_isbrain,[0.7,3],true);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_RSR, Rs_jrgeco1aCorr_Delta_RSR,'jrgeco1aCorr','m','Delta',saveDir,visName,false,xform_isbrain)




figure
for ii = 1:14999;imagesc(xform_jrgeco1aCorr_RSR_MSSR(:,:,ii),[-0.05 0.05]);
axis image off;pause(0.1);end

figure
for ii = 1:14999;imagesc(xform_jrgeco1aCorr(:,:,ii),[-0.05 0.05]);
axis image off;pause(0.1);end