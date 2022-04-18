%% crosscorrelation lag
fs =25;
edgeLen =1;
tZone = 4;
corrThr = 0;
validRange = 0: round(tZone*fs);
tLim = [0 2];
rLim = [-1 1];
% %
[lagTimeTrial_HbTCalcium, lagAmpTrial_HbTCalcium,covResult_HbTCalcium] = mouse.conn.dotLag(...
    HbT_filter,Calcium_filter,edgeLen,validRange,corrThr, true,true);
lagTimeTrial_HbTCalcium = lagTimeTrial_HbTCalcium./fs;



%% use T from cross correlation
hrfParam = nan(128,128,3);

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
            if lagTimeTrial_HbTCalcium(yInd,xInd)<0
                lagTimeTrial_HbTCalcium(yInd,xInd) = 0;
            end
            [~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[lagTimeTrial_HbTCalcium(yInd,xInd),1.5,0.25],[lagTimeTrial_HbTCalcium(yInd,xInd),0.3,0.05],[lagTimeTrial_HbTCalcium(yInd,xInd),3,1],options)');
            
            
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


%% Only T vary
hrfParam = nan(128,128);
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
            fcn = @(param)he.fcn_T(param);
            if lagTimeTrial_HbTCalcium(yInd,xInd)<0
                lagTimeTrial_HbTCalcium(yInd,xInd) = 0;
            end
            [~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,1,0.01,2,options)');
            
            
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
            
            pixelHrf = hrfGamma(t,pixHrfParam,1.8,0.12);
            
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
T(:,:) = hrfParam(:,:);


figure
subplot(2,3,1)
imagesc(T,[0 2])
axis image off
colorbar
colormap jet
title('T(s)')

subplot(2,3,2)
imagesc(ones(128,128)*0.9,[0 3])
axis image off
colormap jet
title('W(s)')
colorbar


subplot(2,3,3)
imagesc(ones(128,128)*0.12,[0 0.3])
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

%% Only T vary, 1-r
hrfParam = nan(128,128);
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
            fcn = @(param)he.fcn_T_r(param);
            [~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,1,0.01,2,options)');
            
            
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
            
            pixelHrf = hrfGamma(t,pixHrfParam,1.8,0.12);
            
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
T(:,:) = hrfParam(:,:);


figure
subplot(2,3,1)
imagesc(T,[0 2])
axis image off
colorbar
colormap jet
title('T(s)')

subplot(2,3,2)
imagesc(ones(128,128)*0.9,[0 3])
axis image off
colormap jet
title('W(s)')
colorbar


subplot(2,3,3)
imagesc(ones(128,128)*0.12,[0 0.3])
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

