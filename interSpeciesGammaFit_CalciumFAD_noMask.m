function [T,W,A,r,r2,FADPred] = interSpeciesGammaFit_CalciumFAD_noMask(neural,FAD,t)
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

mrfParam = nan(128,128,3);
FADPred = nan(128,128,size(neural,3));
r = nan(128);
r2 = nan(128);

for xInd = 1:size(neural,2)
    for yInd = 1:size(neural,1)
        
        pixFAD = squeeze(FAD(yInd,xInd,:))';
        
        pixNeural = squeeze(neural(yInd,xInd,:))';
        
        he = mouse.math.HemodynamicsError(t,pixNeural,pixFAD);
        worstErr = sum(pixFAD.^2);
        options.TolFun = worstErr*0.01;
        fcn = @(param)he.fcn(param);
        %[~,pixHrfParam] = evalc('fminsearchbnd(fcn,[0.2,0.4,1],[0.01,0.01,0],[0.6,1.2,100000],options)');
        % saved before 11/01/21 [~,pixmrfParam] = evalc('fminsearchbnd(fcn,[0.2,0.4,1],[0.001,0.001,0],[0.6,1.2,inf],options)');
        [~,pixmrfParam] = evalc('fminsearchbnd(fcn,[0.07,0.04,0.8],[0.007,0.004,0.08],[0.7,0.4,8],options)');
        pixelMrf = mouse.math.hrfGamma(t,pixmrfParam(1),pixmrfParam(2),pixmrfParam(3));
        [~,max_loc] = max(pixelMrf);
        if max_loc>3
            pixFADPred = conv(pixNeural,pixelMrf);
            pixFADPred = pixFADPred(1:numel(pixNeural)); 
            
            mrfParam(yInd,xInd,:) = pixmrfParam;
            FADPred(yInd,xInd,:) = pixFADPred;
            
            r(yInd,xInd) = corr(pixFADPred',pixFAD');%real(atanh(corr(pixHemoPred',pixHemo')));
            r2(yInd,xInd) = 1-sumsqr(pixFAD-pixFADPred)/sumsqr(pixFAD-mean(pixFAD));
        end%1 - var(pixHemoPred - pixHemo)/var(pixHemo);
    end
end


T = mrfParam(:,:,1);
W = mrfParam(:,:,2);
A = mrfParam(:,:,3);

end