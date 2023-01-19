function [T,W,A,r,r2,FADPred,obj_val] = GammaFit_CalciumFAD(neural,FAD,t,mask)
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

neural = reshape(neural,128*128,[]);
FAD = reshape(FAD,128*128,[]);
numFrames = size(neural,2);
mask = reshape(mask,1,[]);
neural = neural(mask,:);
FAD = FAD(mask,:);
numPixels = sum(mask);
options=optimset('Display','off','MaxFunEvals',5000,'MaxIter',5000,'TolX',1e-8,'TolF',1e-8);
mrfParam = nan(numPixels,3);
FADPred = nan(numPixels,numFrames);
r = nan(1,numPixels);
r2 = nan(1,numPixels);
obj_val = nan(1,numPixels);
  
parfor pixel = 1:numPixels
    pixFAD = squeeze(FAD(pixel,:))';
    pixNeural = squeeze(neural(pixel,:))';
    he = HemodynamicsError(t,pixNeural,pixFAD);
    fcn = @(param)he.fcn(param);
    [pixmrfParam,obj,~,~]  = fminsearchbnd(fcn,[0.1,0.02,0.1],[0.004,0.004,0.0001],[0.6,1.2,10],options);

    %if pixmrfParam(1)>0.001 && pixmrfParam(2)>0.001
    pixelMrf = hrfGamma(t,pixmrfParam(1),pixmrfParam(2),pixmrfParam(3));
    pixFADPred = conv(pixNeural,pixelMrf);
    pixFADPred = pixFADPred(1:numel(pixNeural));

    mrfParam(pixel,:) = pixmrfParam;
    FADPred(pixel,:) = pixFADPred;

    dimen = size(pixFADPred);
    if dimen(2)>dimen(1)
        pixFADPred = pixFADPred';
    end
    r(pixel) = corr(pixFADPred,pixFAD);%real(atanh(corr(pixHemoPred',pixHemo')));
    if r(pixel)> 0
        r2(pixel) = 1-sumsqr(pixFAD-pixFADPred)/sumsqr(pixFAD-mean(pixFAD));
        obj_val(pixel) = obj;
    else
        r(pixel)=NaN;
        mrfParam(pixel,:) = NaN;
        FADPred(pixel,:) = NaN;
    end
    %end
    %1 - var(pixHemoPred - pixHemo)/var(pixHemo);

end

T = nan(1,128*128);
W = nan(1,128*128);
A = nan(1,128*128);
T(mask) = mrfParam(:,1);
W(mask) = mrfParam(:,2);
A(mask) = mrfParam(:,3);
T = reshape(T,128,128,[]);
W = reshape(W,128,128,[]);
A = reshape(A,128,128,[]);
r_temp = nan(1,128*128);
r2_temp = nan(1,128*128);
obj_temp = nan(1,128*128); 
r_temp(mask) = r;
r2_temp(mask) = r2;
obj_temp(mask) = obj_val;
r = reshape(r_temp,128,128);
r2 = reshape(r2_temp,128,128);
obj_val = reshape(obj_temp,128,128);

FADPred_temp = nan(128*128,numFrames);
FADPred_temp(mask,:) = FADPred;
FADPred = reshape(FADPred_temp,128,128,[]);

%
% options=optimset('Display','iter','MaxFunEvals',5000,'MaxIter',5000,'TolX',1e-8,'TolF',1e-8);
% mrfParam = nan(128,128,3);
% FADPred = nan(128,128,size(neural,3));
% r = nan(128);
% r2 = nan(128);
% obj_val = nan(128);
%
% for xInd = 1:size(neural,2)
%     for yInd = 1:size(neural,1)
%         if mask(yInd,xInd)
%             pixFAD = squeeze(FAD(yInd,xInd,:))';
%             pixNeural = squeeze(neural(yInd,xInd,:))';
%             he = HemodynamicsError(t,pixNeural,pixFAD);
%             fcn = @(param)he.fcn(param);
%             %[~,pixmrfParam] = evalc('fminsearchbnd(fcn,[0.1,0.035,1],[0.006,0,0],[0.6,1,10],options)');
%             %[~,pixmrfParam] = evalc('fminsearchbnd(fcn,[0.1,0.035,1],[0.06,0.02,0.01],[0.6,1,1],options)');
%             %[~,pixmrfParam,obj_val(yInd,xInd)] = evalc('fminsearchbnd(fcn,[0.16,0.03,0.17],[0.0001,0.005,0.001],[0.2,0.1,0.1],options)');%xw 220731 change A upper bound to 2
%             %[~,pixmrfParam,obj_val(yInd,xInd)] = evalc('fminunc(fcn,[0.003,0.003,0.05],options)');
%             %[~,pixmrfParam,obj] = evalc('fminsearchbnd(fcn,[0.1,0.2,0.002],[0.001,0.001,0.00002],[2,3,0.1],options)');
%             [~,pixmrfParam,obj] = evalc('fminsearchbnd(fcn,[0.1,0.02,0.1],[0.001,0.001,0.001],[0.6,1.2,10],options)');
%
%
%             %if pixmrfParam(1)>0.001 && pixmrfParam(2)>0.001
%             pixelMrf = hrfGamma(t,pixmrfParam(1),pixmrfParam(2),pixmrfParam(3));
%             pixFADPred = conv(pixNeural,pixelMrf);
%             pixFADPred = pixFADPred(1:numel(pixNeural));
%
%             mrfParam(yInd,xInd,:) = pixmrfParam;
%             FADPred(yInd,xInd,:) = pixFADPred;
%
%             r(yInd,xInd) = corr(pixFADPred',pixFAD');%real(atanh(corr(pixHemoPred',pixHemo')));
%             if r(yInd,xInd)> 0
%                 r2(yInd,xInd) = 1-sumsqr(pixFAD-pixFADPred)/sumsqr(pixFAD-mean(pixFAD));
%                 obj_val(yInd,xInd) = obj;
%             else
%                 r(yInd,xInd)=NaN;
%                 mrfParam(yInd,xInd,:) = NaN;
%                 FADPred(yInd,xInd,:) = NaN;
%             end
%             %end
%             %1 - var(pixHemoPred - pixHemo)/var(pixHemo);
%         end
%     end
% end
%
%
% T = mrfParam(:,:,1);
% W = mrfParam(:,:,2);
% A = mrfParam(:,:,3);

end