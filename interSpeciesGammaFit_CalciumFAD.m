
   
function [T,W,A,r,r2,FADPred] = interSpeciesGammaFit_CalciumFAD(neural,FAD,t)
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

mrfParam = zeros(128,128,3);
FADPred = zeros(128,128,size(neural,3));
r = nan(128);
r2 = nan(128);

for xInd = 1:size(neural,2)
    for yInd = 1:size(neural,1)
        
        pixFAD = squeeze(FAD(yInd,xInd,:))';
        
        if sum(pixFAD.^2) > 0
            pixNeural = squeeze(neural(yInd,xInd,:))';

            he = mouse.math.HemodynamicsError(t,pixNeural,pixFAD);
            worstErr = sum(pixFAD.^2);
            options.TolFun = worstErr*0.01;
            fcn = @(param)he.fcn(param);
            %[~,pixHrfParam] = evalc('fminsearchbnd(fcn,[0.2,0.4,1],[0.01,0.01,0],[0.6,1.2,100000],options)');
             % saved before 11/01/21 [~,pixmrfParam] = evalc('fminsearchbnd(fcn,[0.2,0.4,1],[0.001,0.001,0],[0.6,1.2,inf],options)');
            [~,pixmrfParam] = evalc('fminsearchbnd(fcn,[0.1,0.035,1],[0.006,0,0],[0.6,0.1,10],options)');
            pixelMrf = mouse.math.hrfGamma(t,pixmrfParam(1),pixmrfParam(2),pixmrfParam(3));
            pixFADPred = conv(pixNeural,pixelMrf);
            pixFADPred = pixFADPred(1:numel(pixNeural));
        else
            pixmrfParam = [nan nan nan];
            pixFADPred = nan(size(pixFAD));
        end
        mrfParam(yInd,xInd,:) = pixmrfParam;
        FADPred(yInd,xInd,:) = pixFADPred;
        
        r(yInd,xInd) = corr(pixFADPred',pixFAD');%real(atanh(corr(pixHemoPred',pixHemo')));
        r2(yInd,xInd) = 1-sumsqr(pixFAD-pixFADPred)/sumsqr(pixFAD-mean(pixFAD));                           %1 - var(pixHemoPred - pixHemo)/var(pixHemo);
    end
end


T = mrfParam(:,:,1);
W = mrfParam(:,:,2);
A = mrfParam(:,:,3);

end
© 2022 GitHub, Inc.
Terms
Privacy
Security
Status
Docs
Contact GitHub
Pricing
API
Training
Blog
About
Loading complete