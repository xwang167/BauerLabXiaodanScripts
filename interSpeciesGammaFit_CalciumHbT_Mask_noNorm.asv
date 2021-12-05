function [T,W,A,r,r2,hemoPred] = interSpeciesGammaFit_CalciumHbT_Mask_noNorm(neural,hemo,t,mask)
%UNTITLED2 Summary of this function goes here
%   neural = 3D
%   hemo = 3D
% Output:
%   T = time to peak
%   W = FWHM
%   A = amplitude of gamma fit
%   r = correlation
%   r2 = goodness of fit
%   hemoPred = predicted hemodynamics

options = optimset('Display','iter');
% options.MaxIter = 100;

hrfParam = nan(128,128,3);
hemoPred = nan(128,128,size(neural,3));
r = nan(128);
r2 = nan(128);

for xInd = 1:size(neural,2)
    for yInd = 1:size(neural,1)
        if mask(yInd,xInd)
            pixHemo = squeeze(hemo(yInd,xInd,:))';
            pixNeural = squeeze(neural(yInd,xInd,:))';
            %t = (0:25)./25;
            %t = (0:750)./25;
            he = mouse.math.HemodynamicsError(t,pixNeural,pixHemo);
            worstErr = sum(pixHemo.^2);
            options.TolFun = worstErr*0.01;
            fcn = @(param)he.fcn(param);
            %             [~,pixHrfParam] = evalc('fminsearchbnd(fcn,[1,3,0.0001],[0,0.5,0],[4,10,inf],options)');
            %             [~,pixHrfParam] = evalc('fminsearch(fcn,[2,3,0.0001],options)');
            %[~,pixHrfParam] = evalc('fminsearchbnd(fcn,[2,3,1],[0,0,0],[4,6,inf],options)');
            
            [~,pixHrfParam] = evalc('fminsearchbnd(fcn,[1,1,0.05],[0.008,0,0],[4,6,1],options)');
            %             [~,pixHrfParam] = evalc('fminsearchbnd(fcn,[2,3,0.0001],[0,0,0],[inf,inf,inf],options)');
            %             [~,pixHrfParam] = evalc('fminsearchbnd(fcn,[2,3,0.0001],[0,-inf,-inf],[4,-inf,inf],options)');
            
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
            
            pixelHrf = mouse.math.hrfGamma(t,pixHrfParam(1),pixHrfParam(2),pixHrfParam(3));
                if pixHrfParam(1) >=0.008001
                pixHemoPred = conv(pixNeural,pixelHrf);
                pixHemoPred = pixHemoPred(1:numel(pixNeural));
                
                hrfParam(yInd,xInd,:) = pixHrfParam;
                hemoPred(yInd,xInd,:) = pixHemoPred;
                
                r(yInd,xInd) = corr(pixHemoPred',pixHemo');%real(atanh(corr(pixHemoPred',pixHemo')));
                r2(yInd,xInd) = 1-sumsqr(pixHemo-pixHemoPred)/sumsqr(pixHemo-mean(pixHemo));
                end
            %1 - var(pixHemoPred - pixHemo)/var(pixHemo);
        end
    end
end


T = hrfParam(:,:,1);
W = hrfParam(:,:,2);
A = hrfParam(:,:,3);

end