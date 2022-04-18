import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRow = [181];
runs = 1;%
[~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
recDate = excelRaw{1}; recDate = string(recDate);
mouseName = excelRaw{2}; mouseName = string(mouseName);
rawdataloc = excelRaw{3};
saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
if ~exist(saveDir)
    mkdir(saveDir)
end
sessionInfo.mouseType = excelRaw{17};
sessionInfo.darkFrameNum = excelRaw{15};
systemType = excelRaw{5};
sessionInfo.framerate = excelRaw{7};
if strcmp(char(sessionInfo.mouseType),'jrgeco1a-opto3')
    maskDir = fullfile(rawdataloc,recDate);
else
    maskDir = saveDir;
end

saveDir_new = strcat('L:\RGECO\Kenny\', recDate, '\');
maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datafluor','.mat');

if ~exist(fullfile(saveDir_new,maskName),'file')
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    load(fullfile(saveDir,maskName),'xform_isbrain')
else
    load(fullfile(saveDir_new,maskName),'xform_isbrain')
end

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
mask = logical(mask_new.*xform_isbrain);

visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(1));
processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'_processed','.mat');

load(fullfile(saveDir,processedName),'xform_datahb','xform_jrgeco1aCorr')
xform_datahb(isinf(xform_datahb)) = 0;
xform_datahb(isnan(xform_datahb)) = 0;
xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;

Hb_filter =  filterData(double(xform_datahb),0.02,2,sessionInfo.framerate);

Calcium_filter = filterData(double(xform_jrgeco1aCorr),0.02,2,sessionInfo.framerate);

HbT_filter = Hb_filter(:,:,1,:) + Hb_filter(:,:,2,:);
clear Hb_filter
HbT_filter = squeeze(HbT_filter);

Calcium_filter = reshape(Calcium_filter,128*128,[]);
HbT_filter = reshape(HbT_filter,128*128,[]);
%downsample
Calcium_filter=resample(Calcium_filter',5,sessionInfo.framerate)';
HbT_filter=resample(HbT_filter',5,sessionInfo.framerate)';

% reshape

Calcium_filter = reshape(Calcium_filter,128,128,[]);
HbT_filter = reshape(HbT_filter,128,128,[]);
time_epoch=15;
t = linspace(0,time_epoch,time_epoch*sessionInfo.framerate *(5/sessionInfo.framerate));%% force it to be 5 hz

%% iter 300
hrfParam2 = nan(128,128,3);
T2 = nan(128,128);
W2 = nan(128,128);
A2 = nan(128,128);
objValues2 = nan(128,128);
r2 = nan(128,128);
r22 = nan(128,128);
mask = reshape(mask,128,128);

options=optimset('Display','iter','MaxFunEvals',12000,'MaxIter',300,'Tolx',1e-8,'TolF',1e-8);

for xInd = 1:size(HbT_filter,2)
    for yInd = 1:size(HbT_filter,1)
        if mask(yInd,xInd)
            pixHemo = squeeze(HbT_filter(yInd,xInd,:))'*10^6;
            pixNeural = squeeze(Calcium_filter(yInd,xInd,:))'*100;
            %t = (0:25)./25;
            %t = (0:750)./25;
            %he = mouse.math.HemodynamicsError(t,pixNeural,pixHemo);
            he = HemodynamicsError(t,pixNeural,pixHemo);
            %             worstErr = sum(pixHemo.^2);
            %             options.TolFun = worstErr*0.01;
            %fcn = @(param)he.fcn(param);
            fcn = @(param)he.fcn(param);
            [~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[1,1.5,0.25],[0.01,0.3,0.05],[2,3,1],options)');
            
            
            %             tMin = 0.0625; tMax = 4; tNum = 64;
            %             wMin = 0.125; wMax = 6; wNum = 48;
            %             aMin = 0.25E-4; aMax = 2E-4; aNum = 8;
            %             [X1, X2, X3] = ndgrid( linspace(tMin, tMax, tNum), linspace(wMin, wMax, wNum), linspace(aMin, aMax, aNum));
            %             y = zeros(size(X1));
            %             for i = 1:numel(X1)
            %                 y(i) = fcn([X1(i),X2(i),X3(i)]);
            %             end
            %             [~,I] = min(y(:));
            %             pixHrfParam2 = [X1(I) X2(I) X3(I)];
            
            pixelHrf = hrfGamma(t,pixHrfParam(1),pixHrfParam(2),pixHrfParam(3));
            
            pixHemoPred = conv(pixNeural,pixelHrf);
            pixHemoPred = pixHemoPred(1:numel(pixNeural));
            
            hrfParam2(yInd,xInd,:) = pixHrfParam;
            objValues2(yInd,xInd) = obj_val;
            
            r2(yInd,xInd) = corr(pixHemoPred',pixHemo');%real(atanh(corr(pixHemoPred',pixHemo')));
            r22(yInd,xInd) = 1-sumsqr(pixHemo-pixHemoPred)/sumsqr(pixHemo-mean(pixHemo));
            
            %1 - var(pixHemoPred - pixHemo)/var(pixHemo);
        end
    end
end
T2(:,:) = hrfParam2(:,:,1);
W2(:,:) = hrfParam2(:,:,2);
A2(:,:) = hrfParam2(:,:,3);


figure
subplot(2,3,1)
imagesc(T2,[0 2])
axis image off
colorbar
colormap jet
title('T(s)')

subplot(2,3,2)
imagesc(W2,[0 3])
axis image off
colormap jet
title('W(s)')
colorbar


subplot(2,3,3)
imagesc(A2,[0 0.3])
axis image off
colormap jet
title('A((\Delta\muM)/(\DeltaF/F%))')
colorbar


subplot(2,3,4)
imagesc(r2,[-1 1])
axis image off
colormap jet
title('r')
colorbar

subplot(2,3,5)
imagesc(r22,[0 1])
axis image off
colormap jet
title('R^2')
colorbar

subplot(2,3,6)
imagesc(objValues2,[0 3500])
axis image off
colormap jet
title('Objective Value')
colorbar


%% iter 3000
hrfParam3 = nan(128,128,3);
T3 = nan(128,128);
W3 = nan(128,128);
A3 = nan(128,128);
objValues3 = nan(128,128);
r3 = nan(128,128);
r23 = nan(128,128);
mask = reshape(mask,128,128);

options=optimset('Display','iter','MaxFunEvals',12000,'MaxIter',3000,'Tolx',1e-8,'TolF',1e-8);

for xInd = 1:size(HbT_filter,2)
    for yInd = 1:size(HbT_filter,1)
        if mask(yInd,xInd)
            pixHemo = squeeze(HbT_filter(yInd,xInd,:))'*10^6;
            pixNeural = squeeze(Calcium_filter(yInd,xInd,:))'*100;
            %t = (0:25)./25;
            %t = (0:750)./25;
            %he = mouse.math.HemodynamicsError(t,pixNeural,pixHemo);
            he = HemodynamicsError(t,pixNeural,pixHemo);
            %             worstErr = sum(pixHemo.^2);
            %             options.TolFun = worstErr*0.01;
            %fcn = @(param)he.fcn(param);
            fcn = @(param)he.fcn(param);
            [~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[1,1.5,0.25],[0.01,0.3,0.05],[2,3,1],options)');
            
            
            %             tMin = 0.0625; tMax = 4; tNum = 64;
            %             wMin = 0.125; wMax = 6; wNum = 48;
            %             aMin = 0.25E-4; aMax = 2E-4; aNum = 8;
            %             [X1, X2, X3] = ndgrid( linspace(tMin, tMax, tNum), linspace(wMin, wMax, wNum), linspace(aMin, aMax, aNum));
            %             y = zeros(size(X1));
            %             for i = 1:numel(X1)
            %                 y(i) = fcn([X1(i),X2(i),X3(i)]);
            %             end
            %             [~,I] = min(y(:));
            %             pixHrfParam2 = [X1(I) X2(I) X3(I)];
            
            pixelHrf = hrfGamma(t,pixHrfParam(1),pixHrfParam(2),pixHrfParam(3));
            
            pixHemoPred = conv(pixNeural,pixelHrf);
            pixHemoPred = pixHemoPred(1:numel(pixNeural));
            
            hrfParam3(yInd,xInd,:) = pixHrfParam;
            objValues3(yInd,xInd) = obj_val;
            
            r3(yInd,xInd) = corr(pixHemoPred',pixHemo');%real(atanh(corr(pixHemoPred',pixHemo')));
            r23(yInd,xInd) = 1-sumsqr(pixHemo-pixHemoPred)/sumsqr(pixHemo-mean(pixHemo));
            
            %1 - var(pixHemoPred - pixHemo)/var(pixHemo);
        end
    end
end
T3(:,:) = hrfParam3(:,:,1);
W3(:,:) = hrfParam3(:,:,2);
A3(:,:) = hrfParam3(:,:,3);


figure
subplot(2,3,1)
imagesc(T3,[0 2])
axis image off
colorbar
colormap jet
title('T(s)')

subplot(2,3,2)
imagesc(W3,[0 3])
axis image off
colormap jet
title('W(s)')
colorbar


subplot(2,3,3)
imagesc(A3,[0 0.3])
axis image off
colormap jet
title('A((\Delta\muM)/(\DeltaF/F%))')
colorbar


subplot(2,3,4)
imagesc(r3,[-1 1])
axis image off
colormap jet
title('r')
colorbar

subplot(2,3,5)
imagesc(r23,[0 1])
axis image off
colormap jet
title('R^2')
colorbar

subplot(2,3,6)
imagesc(objValues3,[0 3500])
axis image off
colormap jet
title('Objective Value')
colorbar

%% mean+- std as bound
hrfParam = nan(128,128,3);
T = nan(128,128);
W = nan(128,128);
A = nan(128,128);
objValues = nan(128,128);
r = nan(128,128);
r2 = nan(128,128);
mask = reshape(mask,128,128);

options=optimset('Display','iter','MaxFunEvals',1200,'MaxIter',300,'Tolx',1e-8,'TolF',1e-8);

for xInd = 1:size(HbT_filter,2)
    for yInd = 1:size(HbT_filter,1)
        if mask(yInd,xInd)
            pixHemo = squeeze(HbT_filter(yInd,xInd,:))'*10^6;
            pixNeural = squeeze(Calcium_filter(yInd,xInd,:))'*100;
            %t = (0:25)./25;
            %t = (0:750)./25;
            %he = mouse.math.HemodynamicsError(t,pixNeural,pixHemo);
            he = HemodynamicsError(t,pixNeural,pixHemo);
            %             worstErr = sum(pixHemo.^2);
            %             options.TolFun = worstErr*0.01;
            %fcn = @(param)he.fcn(param);
            fcn = @(param)he.fcn(param);
            [~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[0.61,1.5,0.14],[0.18,0.78,0.03],[1.0,2.2,0.25],options)');
            
            
            %             tMin = 0.0625; tMax = 4; tNum = 64;
            %             wMin = 0.125; wMax = 6; wNum = 48;
            %             aMin = 0.25E-4; aMax = 2E-4; aNum = 8;
            %             [X1, X2, X3] = ndgrid( linspace(tMin, tMax, tNum), linspace(wMin, wMax, wNum), linspace(aMin, aMax, aNum));
            %             y = zeros(size(X1));
            %             for i = 1:numel(X1)
            %                 y(i) = fcn([X1(i),X2(i),X3(i)]);
            %             end
            %             [~,I] = min(y(:));
            %             pixHrfParam2 = [X1(I) X2(I) X3(I)];
            
            pixelHrf = hrfGamma(t,pixHrfParam(1),pixHrfParam(2),pixHrfParam(3));
            
            pixHemoPred = conv(pixNeural,pixelHrf);
            pixHemoPred = pixHemoPred(1:numel(pixNeural));
            
            hrfParam(yInd,xInd,:) = pixHrfParam;
            objValues(yInd,xInd) = obj_val;
            
            r(yInd,xInd) = corr(pixHemoPred',pixHemo');%real(atanh(corr(pixHemoPred',pixHemo')));
            r2(yInd,xInd) = 1-sumsqr(pixHemo-pixHemoPred)/sumsqr(pixHemo-mean(pixHemo));
            
            %1 - var(pixHemoPred - pixHemo)/var(pixHemo);
        end
    end
end
T(:,:) = hrfParam(:,:,1);
W(:,:) = hrfParam(:,:,2);
A(:,:) = hrfParam(:,:,3);


figure
subplot(2,3,1)
imagesc(T,[0 2])
axis image off
colorbar
colormap jet
title('T(s)')

subplot(2,3,2)
imagesc(W,[0 3])
axis image off
colormap jet
title('W(s)')
colorbar


subplot(2,3,3)
imagesc(A,[0 0.3])
axis image off
colormap jet
title('A((\Delta\muM)/(\DeltaF/F%))')
colorbar


subplot(2,3,4)
imagesc(r,[-1 1])
axis image off
colormap jet
title('r')
colorbar

subplot(2,3,5)
imagesc(r2,[0 1])
axis image off
colormap jet
title('R^2')
colorbar

subplot(2,3,6)
imagesc(objValues,[0 3500])
axis image off
colormap jet
title('Objective Value')
colorbar
%% jonah range
hrfParam1 = nan(128,128,3);
T1 = nan(128,128);
W1 = nan(128,128);
A1 = nan(128,128);
objValues1 = nan(128,128);
r1 = nan(128,128);
r21 = nan(128,128);
mask = reshape(mask,128,128);

options=optimset('Display','iter','MaxFunEvals',1200,'MaxIter',300,'Tolx',1e-8,'TolF',1e-8);

for xInd = 1:size(HbT_filter,2)
    for yInd = 1:size(HbT_filter,1)
        if mask(yInd,xInd)
            pixHemo = squeeze(HbT_filter(yInd,xInd,:))'*10^6;
            pixNeural = squeeze(Calcium_filter(yInd,xInd,:))'*100;
            %t = (0:25)./25;
            %t = (0:750)./25;
            %he = mouse.math.HemodynamicsError(t,pixNeural,pixHemo);
            he = HemodynamicsError(t,pixNeural,pixHemo);
            %             worstErr = sum(pixHemo.^2);
            %             options.TolFun = worstErr*0.01;
            %fcn = @(param)he.fcn(param);
            fcn = @(param)he.fcn(param);
            [~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[1,1.5,0.25],[0.01,0.3,0.05],[2,3,1],options)');
            
            
            %             tMin = 0.0625; tMax = 4; tNum = 64;
            %             wMin = 0.125; wMax = 6; wNum = 48;
            %             aMin = 0.25E-4; aMax = 2E-4; aNum = 8;
            %             [X1, X2, X3] = ndgrid( linspace(tMin, tMax, tNum), linspace(wMin, wMax, wNum), linspace(aMin, aMax, aNum));
            %             y = zeros(size(X1));
            %             for i = 1:numel(X1)
            %                 y(i) = fcn([X1(i),X2(i),X3(i)]);
            %             end
            %             [~,I] = min(y(:));
            %             pixHrfParam2 = [X1(I) X2(I) X3(I)];
            
            pixelHrf = hrfGamma(t,pixHrfParam(1),pixHrfParam(2),pixHrfParam(3));
            
            pixHemoPred = conv(pixNeural,pixelHrf);
            pixHemoPred = pixHemoPred(1:numel(pixNeural));
            
            hrfParam1(yInd,xInd,:) = pixHrfParam;
            objValues1(yInd,xInd) = obj_val;
            
            r1(yInd,xInd) = corr(pixHemoPred',pixHemo');%real(atanh(corr(pixHemoPred',pixHemo')));
            r21(yInd,xInd) = 1-sumsqr(pixHemo-pixHemoPred)/sumsqr(pixHemo-mean(pixHemo));
            
            %1 - var(pixHemoPred - pixHemo)/var(pixHemo);
        end
    end
end
T1(:,:) = hrfParam1(:,:,1);
W1(:,:) = hrfParam1(:,:,2);
A1(:,:) = hrfParam1(:,:,3);


figure
subplot(2,3,1)
imagesc(T1,[0 2])
axis image off
colorbar
colormap jet
title('T(s)')

subplot(2,3,2)
imagesc(W1,[0 3])
axis image off
colormap jet
title('W(s)')
colorbar


subplot(2,3,3)
imagesc(A1,[0 0.3])
axis image off
colormap jet
title('A((\Delta\muM)/(\DeltaF/F%))')
colorbar


subplot(2,3,4)
imagesc(r1,[-1 1])
axis image off
colormap jet
title('r')
colorbar

subplot(2,3,5)
imagesc(r21,[0 1])
axis image off
colormap jet
title('R^2')
colorbar

subplot(2,3,6)
imagesc(objValues1,[0 3500])
axis image off
colormap jet
title('Objective Value')
colorbar

%% difference between mean+-std and jonah range
figure
subplot(2,3,1)
imagesc(T-T1,[-0.5 0.5])
title('T(s)')
colormap jet
colorbar
axis image off
subplot(2,3,2)
imagesc(W-W1,[-1 1])
title('W(s)')
colormap jet
colorbar
axis image off
subplot(2,3,3)
imagesc(A-A1,[-0.06 0.06])
title('A((\Delta\muM)/(\DeltaF/F%))')
colormap jet
colorbar
axis image off
subplot(2,3,4)
imagesc(r-r1,[-0.05 0.05])
colorbar
title('r')
colormap jet
axis image off
subplot(2,3,5)
imagesc(r2-r21,[-0.02 0.02])
title('R^2')
colormap jet
axis image off
colorbar
subplot(2,3,6)
imagesc(objValues-objValues1,[-30 30])
title('Objective')
colormap jet
colorbar
axis image off
%% Different mouse
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRow = [183];
runs = 1;%
[~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
recDate = excelRaw{1}; recDate = string(recDate);
mouseName = excelRaw{2}; mouseName = string(mouseName);
rawdataloc = excelRaw{3};
saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
if ~exist(saveDir)
    mkdir(saveDir)
end
sessionInfo.mouseType = excelRaw{17};
sessionInfo.darkFrameNum = excelRaw{15};
systemType = excelRaw{5};
sessionInfo.framerate = excelRaw{7};
if strcmp(char(sessionInfo.mouseType),'jrgeco1a-opto3')
    maskDir = fullfile(rawdataloc,recDate);
else
    maskDir = saveDir;
end

saveDir_new = strcat('L:\RGECO\Kenny\', recDate, '\');
maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datafluor','.mat');

if ~exist(fullfile(saveDir_new,maskName),'file')
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    load(fullfile(saveDir,maskName),'xform_isbrain')
else
    load(fullfile(saveDir_new,maskName),'xform_isbrain')
end

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
mask = logical(mask_new.*xform_isbrain);

visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(1));
processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'_processed','.mat');

load(fullfile(saveDir,processedName),'xform_datahb','xform_jrgeco1aCorr')
xform_datahb(isinf(xform_datahb)) = 0;
xform_datahb(isnan(xform_datahb)) = 0;
xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;

Hb_filter =  filterData(double(xform_datahb),0.02,2,sessionInfo.framerate);

Calcium_filter = filterData(double(xform_jrgeco1aCorr),0.02,2,sessionInfo.framerate);

HbT_filter = Hb_filter(:,:,1,:) + Hb_filter(:,:,2,:);
clear Hb_filter
HbT_filter = squeeze(HbT_filter);

Calcium_filter = reshape(Calcium_filter,128*128,[]);
HbT_filter = reshape(HbT_filter,128*128,[]);
%downsample
Calcium_filter=resample(Calcium_filter',5,sessionInfo.framerate)';
HbT_filter=resample(HbT_filter',5,sessionInfo.framerate)';

% reshape

Calcium_filter = reshape(Calcium_filter,128,128,[]);
HbT_filter = reshape(HbT_filter,128,128,[]);
time_epoch=15;
t = linspace(0,time_epoch,time_epoch*sessionInfo.framerate *(5/sessionInfo.framerate));%% force it to be 5 hz
hrfParam = nan(128,128,3);
T = nan(128,128);
W = nan(128,128);
A = nan(128,128);
objValues = nan(128,128);
r = nan(128,128);
r2 = nan(128,128);
mask = reshape(mask,128,128);

options=optimset('Display','iter','MaxFunEvals',1200,'MaxIter',300,'Tolx',1e-8,'TolF',1e-8);

for xInd = 1:size(HbT_filter,2)
    for yInd = 1:size(HbT_filter,1)
        if mask(yInd,xInd)
            pixHemo = squeeze(HbT_filter(yInd,xInd,:))'*10^6;
            pixNeural = squeeze(Calcium_filter(yInd,xInd,:))'*100;
            %t = (0:25)./25;
            %t = (0:750)./25;
            %he = mouse.math.HemodynamicsError(t,pixNeural,pixHemo);
            he = HemodynamicsError(t,pixNeural,pixHemo);
            %             worstErr = sum(pixHemo.^2);
            %             options.TolFun = worstErr*0.01;
            %fcn = @(param)he.fcn(param);
            fcn = @(param)he.fcn(param);
            [~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[0.61,1.5,0.14],[0.18,0.78,0.03],[1.0,2.2,0.25],options)');
            
            
            %             tMin = 0.0625; tMax = 4; tNum = 64;
            %             wMin = 0.125; wMax = 6; wNum = 48;
            %             aMin = 0.25E-4; aMax = 2E-4; aNum = 8;
            %             [X1, X2, X3] = ndgrid( linspace(tMin, tMax, tNum), linspace(wMin, wMax, wNum), linspace(aMin, aMax, aNum));
            %             y = zeros(size(X1));
            %             for i = 1:numel(X1)
            %                 y(i) = fcn([X1(i),X2(i),X3(i)]);
            %             end
            %             [~,I] = min(y(:));
            %             pixHrfParam2 = [X1(I) X2(I) X3(I)];
            
            pixelHrf = hrfGamma(t,pixHrfParam(1),pixHrfParam(2),pixHrfParam(3));
            
            pixHemoPred = conv(pixNeural,pixelHrf);
            pixHemoPred = pixHemoPred(1:numel(pixNeural));
            
            hrfParam(yInd,xInd,:) = pixHrfParam;
            objValues(yInd,xInd) = obj_val;
            
            r(yInd,xInd) = corr(pixHemoPred',pixHemo');%real(atanh(corr(pixHemoPred',pixHemo')));
            r2(yInd,xInd) = 1-sumsqr(pixHemo-pixHemoPred)/sumsqr(pixHemo-mean(pixHemo));
            
            %1 - var(pixHemoPred - pixHemo)/var(pixHemo);
        end
    end
end
T(:,:) = hrfParam(:,:,1);
W(:,:) = hrfParam(:,:,2);
A(:,:) = hrfParam(:,:,3);


figure
subplot(2,3,1)
imagesc(T,[0 2])
axis image off
colorbar
colormap jet
title('T(s)')

subplot(2,3,2)
imagesc(W,[0 3])
axis image off
colormap jet
title('W(s)')
colorbar


subplot(2,3,3)
imagesc(A,[0 0.3])
axis image off
colormap jet
title('A((\Delta\muM)/(\DeltaF/F%))')
colorbar


subplot(2,3,4)
imagesc(r,[-1 1])
axis image off
colormap jet
title('r')
colorbar

subplot(2,3,5)
imagesc(r2,[0 1])
axis image off
colormap jet
title('R^2')
colorbar

subplot(2,3,6)
imagesc(objValues,[0 3500])
axis image off
colormap jet
title('Objective Value')
colorbar



figure
subplot(2,3,1)
imagesc(T-T1,[-1 1])
title('T(s)')
colormap jet
axis image off
subplot(2,3,2)
imagesc(W-W1,[-1 1])
title('W(s)')
colormap jet
axis image off
subplot(2,3,3)
imagesc(A-A1,[-0.06 0.06])
title('A((\Delta\muM)/(\DeltaF/F%))')
colormap jet
axis image off
subplot(2,3,4)
imagesc(r-r1,[-0.05 0.05])
title('r')
colormap jet
axis image off
subplot(2,3,5)
imagesc(r2-r21,[-0.02 0.02])
title('R^2')
colormap jet
axis image off
subplot(2,3,6)
imagesc(objValues-Obj1,[-30 30])
title('Objective')
colormap jet
axis image off


%% test anes with a wider range
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRow = [195];
runs = 1;%
[~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
recDate = excelRaw{1}; recDate = string(recDate);
mouseName = excelRaw{2}; mouseName = string(mouseName);
rawdataloc = excelRaw{3};
saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
if ~exist(saveDir)
    mkdir(saveDir)
end
sessionInfo.mouseType = excelRaw{17};
sessionInfo.darkFrameNum = excelRaw{15};
systemType = excelRaw{5};
sessionInfo.framerate = excelRaw{7};
if strcmp(char(sessionInfo.mouseType),'jrgeco1a-opto3')
    maskDir = fullfile(rawdataloc,recDate);
else
    maskDir = saveDir;
end

saveDir_new = strcat('L:\RGECO\Kenny\', recDate, '\');
maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datafluor','.mat');

if ~exist(fullfile(saveDir_new,maskName),'file')
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    load(fullfile(saveDir,maskName),'xform_isbrain')
else
    load(fullfile(saveDir_new,maskName),'xform_isbrain')
end

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
mask = logical(mask_new.*xform_isbrain);

visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(1));
processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'_processed','.mat');

load(fullfile(saveDir,processedName),'xform_datahb','xform_jrgeco1aCorr')
xform_datahb(isinf(xform_datahb)) = 0;
xform_datahb(isnan(xform_datahb)) = 0;
xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;

Hb_filter =  filterData(double(xform_datahb),0.02,2,sessionInfo.framerate);

Calcium_filter = filterData(double(xform_jrgeco1aCorr),0.02,2,sessionInfo.framerate);

HbT_filter = Hb_filter(:,:,1,:) + Hb_filter(:,:,2,:);
clear Hb_filter
HbT_filter = squeeze(HbT_filter);

Calcium_filter = reshape(Calcium_filter,128*128,[]);
HbT_filter = reshape(HbT_filter,128*128,[]);
%downsample
Calcium_filter=resample(Calcium_filter',5,sessionInfo.framerate)';
HbT_filter=resample(HbT_filter',5,sessionInfo.framerate)';

% reshape

Calcium_filter = reshape(Calcium_filter,128,128,[]);
HbT_filter = reshape(HbT_filter,128,128,[]);
time_epoch=15;
t = linspace(0,time_epoch,time_epoch*sessionInfo.framerate *(5/sessionInfo.framerate));%% force it to be 5 hz


hrfParam = nan(128,128,3);
T = nan(128,128);
W = nan(128,128);
A = nan(128,128);
objValues = nan(128,128);
r = nan(128,128);
r2 = nan(128,128);
mask = reshape(mask,128,128);

options=optimset('Display','iter','MaxFunEvals',1200,'MaxIter',300,'Tolx',1e-8,'TolF',1e-8);

for xInd = 1:size(HbT_filter,2)
    for yInd = 1:size(HbT_filter,1)
        if mask(yInd,xInd)
            pixHemo = squeeze(HbT_filter(yInd,xInd,:))'*10^6;
            pixNeural = squeeze(Calcium_filter(yInd,xInd,:))'*100;
            %t = (0:25)./25;
            %t = (0:750)./25;
            %he = mouse.math.HemodynamicsError(t,pixNeural,pixHemo);
            he = HemodynamicsError(t,pixNeural,pixHemo);
            %             worstErr = sum(pixHemo.^2);
            %             options.TolFun = worstErr*0.01;
            %fcn = @(param)he.fcn(param);
            fcn = @(param)he.fcn(param);
            [~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[1,1.5,0.25],[0.01,0.3,0.05],[2,3,1],options)');
            
            
            %             tMin = 0.0625; tMax = 4; tNum = 64;
            %             wMin = 0.125; wMax = 6; wNum = 48;
            %             aMin = 0.25E-4; aMax = 2E-4; aNum = 8;
            %             [X1, X2, X3] = ndgrid( linspace(tMin, tMax, tNum), linspace(wMin, wMax, wNum), linspace(aMin, aMax, aNum));
            %             y = zeros(size(X1));
            %             for i = 1:numel(X1)
            %                 y(i) = fcn([X1(i),X2(i),X3(i)]);
            %             end
            %             [~,I] = min(y(:));
            %             pixHrfParam2 = [X1(I) X2(I) X3(I)];
            
            pixelHrf = hrfGamma(t,pixHrfParam(1),pixHrfParam(2),pixHrfParam(3));
            
            pixHemoPred = conv(pixNeural,pixelHrf);
            pixHemoPred = pixHemoPred(1:numel(pixNeural));
            
            hrfParam(yInd,xInd,:) = pixHrfParam;
            objValues(yInd,xInd) = obj_val;
            
            r(yInd,xInd) = corr(pixHemoPred',pixHemo');%real(atanh(corr(pixHemoPred',pixHemo')));
            r2(yInd,xInd) = 1-sumsqr(pixHemo-pixHemoPred)/sumsqr(pixHemo-mean(pixHemo));
            
            %1 - var(pixHemoPred - pixHemo)/var(pixHemo);
        end
    end
end
T(:,:) = hrfParam(:,:,1);
W(:,:) = hrfParam(:,:,2);
A(:,:) = hrfParam(:,:,3);


figure
subplot(2,3,1)
imagesc(T,[0 2])
axis image off
colorbar
colormap jet
title('T(s)')

subplot(2,3,2)
imagesc(W,[0 3])
axis image off
colormap jet
title('W(s)')
colorbar


subplot(2,3,3)
imagesc(A,[0 0.3])
axis image off
colormap jet
title('A((\Delta\muM)/(\DeltaF/F%))')
colorbar


subplot(2,3,4)
imagesc(r,[-1 1])
axis image off
colormap jet
title('r')
colorbar

subplot(2,3,5)
imagesc(r2,[0 1])
axis image off
colormap jet
title('R^2')
colorbar

subplot(2,3,6)
imagesc(objValues,[0 3500])
axis image off
colormap jet
title('Objective Value')
colorbar