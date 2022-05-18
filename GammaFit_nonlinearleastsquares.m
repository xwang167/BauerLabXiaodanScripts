hrfParam2 = nan(128,128,3);
T2 = nan(128,128);
W2 = nan(128,128);
A2 = nan(128,128);
objValues2 = nan(128,128);
r2 = nan(128,128);
r22 = nan(128,128);
mask = reshape(mask,128,128);

options=optimset('Display','iter','MaxFunEvals',60000,'MaxIter',3000,'Tolx',1e-8,'TolF',1e-8);
options.Algorithm = 'levenberg-marquardt';
t = linspace(0,time_epoch,time_epoch*sessionInfo.framerate *(5/sessionInfo.framerate));
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
        [a,pixHrfParam,c,d,e,f,g] = evalc('lsqnonlin(fcn,[0.62,1.8,0.12],[],[],options)');
      
            
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


%%
hrfParam = nan(128,128,3,3000);
T = nan(128,128,3000);
W = nan(128,128,3000);
A = nan(128,128,300);
objValues = nan(128,128,3000);
r = nan(128,128,3000);
r2 = nan(128,128,3000);
mask = reshape(mask,128,128);
t = linspace(0,time_epoch,time_epoch*sessionInfo.framerate *(5/sessionInfo.framerate));
for ii = 1:3000
    options=optimset('Display','iter','MaxFunEvals',15000,'MaxIter',ii,'Tolx',1e-8,'TolF',1e-8);
    options.Algorithm = 'levenberg-marquardt';
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
                
        [a,pixHrfParam,c,d,e,f,g] = evalc('lsqnonlin(fcn,[0.62,1.8,0.12],[],[],options)');

                
                
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
                
                hrfParam(yInd,xInd,:,ii) = pixHrfParam;
                objValues(yInd,xInd,ii) = obj_val;
                
                r(yInd,xInd,ii) = corr(pixHemoPred',pixHemo');%real(atanh(corr(pixHemoPred',pixHemo')));
                r2(yInd,xInd,ii) = 1-sumsqr(pixHemo-pixHemoPred)/sumsqr(pixHemo-mean(pixHemo));
                
                %1 - var(pixHemoPred - pixHemo)/var(pixHemo);
            end
        end
    end
    T(:,:,ii) = hrfParam(:,:,1,ii);
    W(:,:,ii) = hrfParam(:,:,2,ii);
    A(:,:,ii) = hrfParam(:,:,3,ii);
end

mask = mask(:);
tempT = reshape(T(:,:,1:383),128*128,[]);
tempT = tempT(mask,:);

tempW = reshape(W(:,:,1:383),128*128,[]);
tempW = tempW(mask,:);

tempA = reshape(A(:,:,1:383),128*128,[]);
tempA = tempA(mask,:);

tempObj = reshape(objValues(:,:,1:383),128*128,[]);
tempObj = tempObj(mask,:);

tempr = reshape(r(:,:,1:383),128*128,[]);
tempr = tempr(mask,:);

tempr2 = reshape(r2(:,:,1:383),128*128,[]);
tempr2 = tempr2(mask,:);


figure
plot_distribution_prctile(1:383,tempT,'Color',[255 0 0]./255)
plot_distribution_prctile(1:383,tempW,'Color',[0 255 0]./255)
plot_distribution_prctile(1:383,tempA,'Color',[0 0 255]./255)
plot_distribution_prctile(1:383,tempr,'Color',[0 255 255]./255)
plot_distribution_prctile(1:383,tempr2,'Color',[0 0 0]./255)
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')

figure
plot_distribution_prctile(1:383,tempObj,'Color',[255 0 255]./255)
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
title('Objective value')
xlim([0 3000])
T1 = nan(128*128,1);
W1 = nan(128*128,1);
A1 = nan(128*128,1);
r1 = nan(128*128,1);
r21 = nan(128*128,1);
Obj1 = nan(128*128,1);

T1(mask) = tempT(:,3000);
W1(mask) = tempW(:,3000);
A1(mask) = tempA(:,3000);
r1(mask) = tempr(:,3000);
r21(mask) = tempr2(:,3000);
Obj1(mask) = tempObj(:,3000);

T1 = reshape(T1,128,128);
W1 = reshape(W1,128,128);
A1 = reshape(A1,128,128);
r1 = reshape(r1,128,128);
r21 = reshape(r21,128,128);
Obj1 = reshape(Obj1,128,128);


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
imagesc(Obj1)
axis image off
colormap jet
title('Objective Value')
colorbar


%% 300

T3 = nan(128*128,1);
W3 = nan(128*128,1);
A3 = nan(128*128,1);
r3 = nan(128*128,1);
r23 = nan(128*128,1);
Obj3 = nan(128*128,1);

T3(mask) = tempT(:,300);
W3(mask) = tempW(:,300);
A3(mask) = tempA(:,300);
r3(mask) = tempr(:,300);
r23(mask) = tempr2(:,300);
Obj3(mask) = tempObj(:,300);

T3 = reshape(T3,128,128);
W3 = reshape(W3,128,128);
A3 = reshape(A3,128,128);
r3 = reshape(r3,128,128);
r23 = reshape(r23,128,128);
Obj3 = reshape(Obj3,128,128);


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
imagesc(Obj3)
axis image off
colormap jet
title('Objective Value')
colorbar