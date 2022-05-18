%% Any charateristics of time trace related to low T?
for xInd = 1:size(HbT_filter,2)
    for yInd = 1:size(HbT_filter,1)
        if mask(yInd,xInd)
            pixHemo = squeeze(HbT_filter(yInd,xInd,:))'*10^6;
            pixNeural = squeeze(Calcium_filter(yInd,xInd,:))'*100;
            if T(yInd,xInd)==0.2
                figure(1)
                hold on
                plot((1:3000)/5,pixHemo)
                figure(2)
                hold on
                plot((1:3000)/5,pixNeural)
            end
            
             if T(yInd,xInd) >0.6 && T(yInd,xInd) <1.1
                figure(3)
                hold on
                plot((1:3000)/5,pixHemo)
                figure(4)
                hold on
                plot((1:3000)/5,pixNeural)
            end
                
        end
    end
end
figure(1)
title('HbT, T = 0.2')
figure(2)
title('Calcium, T = 0.2')

figure(3)
title('HbT, 0.6<T<1.1')
figure(4)
title('Calcium, 0.6<T<1.1')

%% iter 300,cross corrlation as T initial guess
hrfParam2 = nan(128,128,3);
T2 = nan(128,128);
W2 = nan(128,128);
A2 = nan(128,128);
objValues2 = nan(128,128);
r2 = nan(128,128);
r22 = nan(128,128);
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
            [~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[0.62,1.8,0.12],[0.2,0.3,0.05],[2,3,1],options)');
            
            
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

%% covariance
hrfParam2 = nan(128,128,3);
T2 = nan(128,128);
W2 = nan(128,128);
A2 = nan(128,128);
objValues2 = nan(128,128);
r2 = nan(128,128);
r22 = nan(128,128);
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
            fcn = @(param)he.fcn_covariance(param);
            [~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[0.62,1.8,0.12],[0.2,0.3,0.05],[2,3,1],options)');
            
            
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
%% 1-r+1-r2
hrfParam2 = nan(128,128,3);
T2 = nan(128,128);
W2 = nan(128,128);
A2 = nan(128,128);
objValues2 = nan(128,128);
r2 = nan(128,128);
r22 = nan(128,128);
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
            fcn = @(param)he.fcn_rr2(param);
            [~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[0.62,1.8,0.12],[0.2,0.3,0.05],[2,3,1],options)');
            
            
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

%% using cross lag as T initial guess
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
            [~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[lagTimeTrial_HbTCalcium(yInd,xInd),1.8,0.12],[0.2,0.3,0.05],[2,3,1],options)');
            
            
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
