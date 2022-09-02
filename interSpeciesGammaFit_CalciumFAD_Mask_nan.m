function [T,W,A,r,r2,FADPred] = interSpeciesGammaFit_CalciumFAD_Mask_nan(neural,FAD,t,mask)
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
options=optimset('Display','iter','MaxFunEvals',1200,'MaxIter',300,'Tolx',1e-8,'TolF',1e-8);%before 220319
mrfParam = nan(128,128,3);
FADPred = nan(128,128,size(neural,3));
r = nan(128);
r2 = nan(128);

for xInd = 1:size(neural,2)
    for yInd = 1:size(neural,1)
        if mask(yInd,xInd)
            pixFAD = squeeze(FAD(yInd,xInd,:))';
            
            pixNeural = squeeze(neural(yInd,xInd,:))';
            
            he = HemodynamicsError(t,pixNeural,pixFAD);
            worstErr = sum(pixFAD.^2);
            options.TolFun = worstErr*0.01;
            fcn = @(param)he.fcn(param);
            %[~,pixmrfParam] = evalc('fminsearchbnd(fcn,[0.1,0.035,1],[0.006,0,0],[0.6,1,10],options)');
              %[~,pixmrfParam] = evalc('fminsearchbnd(fcn,[0.1,0.035,1],[0.06,0.02,0.01],[0.6,1,1],options)');
              [~,pixmrfParam] = evalc('fminsearchbnd(fcn,[0.1,0.035,1],[0.06,0.01,0.01],[0.6,0.5,1],options)');%xw 220731 change A upper bound to 2
            pixelMrf = hrfGamma(t,pixmrfParam(1),pixmrfParam(2),pixmrfParam(3));
            if pixmrfParam(1) >0.06001 %before 220319
                pixFADPred = conv(pixNeural,pixelMrf);
                pixFADPred = pixFADPred(1:numel(pixNeural));
                
                mrfParam(yInd,xInd,:) = pixmrfParam;
                FADPred(yInd,xInd,:) = pixFADPred;
                
                r(yInd,xInd) = corr(pixFADPred',pixFAD');%real(atanh(corr(pixHemoPred',pixHemo')));
                r2(yInd,xInd) = 1-sumsqr(pixFAD-pixFADPred)/sumsqr(pixFAD-mean(pixFAD));
                %1 - var(pixHemoPred - pixHemo)/var(pixHemo);
            end
        end
    end
end


T = mrfParam(:,:,1);
W = mrfParam(:,:,2);
A = mrfParam(:,:,3);

end