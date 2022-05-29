function [T,W,A,r,r2,hemoPred] = interSpeciesGammaFit_CalciumHbT_Mask_jpc(neural,hemo,t,mask,lag)
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

 options=optimset('Display','iter','MaxFunEvals',1200,'MaxIter',300,'Tolx',1e-8,'TolF',1e-8);%before 220319
% options.MaxIter = 100;
%options=optimset('Display','iter','MaxFunEvals',500,'MaxIter',ii,'TolX',1e-6,'TolF',1e-6);

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
            he = HemodynamicsError(t,pixNeural,pixHemo);
            fcn = @(param)he.fcn_zscore(param);
            %             [~,pixHrfParam] = evalc('fminsearchbnd(fcn,[1,3,0.0001],[0,0.5,0],[4,10,inf],options)');
            %             [~,pixHrfParam] = evalc('fminsearch(fcn,[2,3,0.0001],options)');
            %[~,pixHrfParam] = evalc('fminsearchbnd(fcn,[2,3,1],[0,0,0],[4,6,inf],options)');
            %[x,pixHrfParam,objective_val,exitflag,outputs] = evalc('fminsearchbnd(fcn,[1,1.5,0.25],[0.01,0.3,0.05],[2,3,1],options)');
            [~,pixHrfParam] = evalc('fminsearchbnd(fcn,[lag(yInd,xInd),1.8,0.12],[0.2,0.3,0.05],[2,3,1],options)');%before 220319
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
            
            pixelHrf = hrfGamma(t,pixHrfParam(1),pixHrfParam(2),pixHrfParam(3));
                if pixHrfParam(1) >0.2001 %before 220319
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