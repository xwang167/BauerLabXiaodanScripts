
function [T,W,A,r,r2,FADPred,obj_vals] = interSpeciesGammaFit_CalciumFAD_Mask_NoNorm_new(neural,FAD,t,mask)
%   neural = 3D
%   hemo = 3D
% Output:
%   T = time to peak
%   W = FWHM
%   A = amplitude of gamma fit
%   r = correlation
%   r2 = goodness of fit
%   hemoPred = predicted hemodynamics
options = optimset('Display','iter');options=optimset('Display','iter','MaxFunEvals',5000,'MaxIter',5000,'TolX',1e-8,'TolF',1e-8);
%UNTITLED2 Summary of this function goes here
% options.MaxIter = 100;

mrfParam = nan(128,128,3);
FADPred = nan(128,128,size(neural,3));
r = nan(128);
r2 = nan(128);
obj_vals = nan(128);
for xInd = 1:size(neural,2)
    for yInd = 1:size(neural,1)
         if mask(yInd,xInd)
            pixFAD = squeeze(FAD(yInd,xInd,:))';
            
            pixNeural = squeeze(neural(yInd,xInd,:))';
            
            he = HemodynamicsError(t,pixNeural,pixFAD);
            worstErr = sum(pixFAD.^2);
            options.TolFun = worstErr*0.01;
            fcn = @(param)he.fcn(param);
            
             [~,pixmrfParam,obj_val] = evalc('fminsearchbnd(fcn, [0.1,0.02,0.06],[0.002,0.001,0],[0.6,1.2,1],options)');
            %[~,pixmrfParam,obj_val] = evalc('fminsearchbnd(fcn,[0.1,0.4,0.03],[0.002 0.01,0.001],[0.6,1.2,0.5],options)');
            %[~,pixmrfParam,obj_val] = evalc('fminsearchbnd(fcn,[0.1,0.02,0.06],[0.002 0.01,0.001],[0.6,1.2,0.5],options)');
           %220725   [~,pixmrfParam] = evalc('fminsearchbnd(fcn,[0.1,0.02,0.06],[0.002,0.001,0.005],[0.6,1.2,0.25],options)');
           %[~,pixHrfParam] = evalc('fminsearchbnd(fcn,[0.2,0.4,1],[0.01,0.01,0],[0.6,1.2,100000],options)');
            % saved before 11/01/21 [~,pixmrfParam] = evalc('fminsearchbnd(fcn,[0.2,0.4,1],[0.001,0.001,0],[0.6,1.2,inf],options)');
            %[~,pixmrfParam] = evalc('fminsearchbnd(fcn,[0.07,0.04,0.8],[0.0007,0.0004,0.008],[0.7,0.4,8],options)');
            pixelMrf = hrfGamma(t,pixmrfParam(1),pixmrfParam(2),pixmrfParam(3));
            
            
            pixFADPred = conv(pixNeural,pixelMrf);
            pixFADPred = pixFADPred(1:numel(pixNeural));

            mrfParam(yInd,xInd,:) = pixmrfParam;
            FADPred(yInd,xInd,:) = pixFADPred;

            r(yInd,xInd) = corr(pixFADPred',pixFAD');%real(atanh(corr(pixHemoPred',pixHemo')));
            r2(yInd,xInd) = 1-sumsqr(pixFAD-pixFADPred)/sumsqr(pixFAD-mean(pixFAD));
            
            obj_vals(yInd,xInd) = obj_val;
            
            %1 - var(pixHemoPred - pixHemo)/var(pixHemo);
         end
    end
end 


T = mrfParam(:,:,1);
W = mrfParam(:,:,2);
A = mrfParam(:,:,3);

end