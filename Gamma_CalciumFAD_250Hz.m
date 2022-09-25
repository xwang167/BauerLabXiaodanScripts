
%% test
options = optimset('Display','iter');
% options.MaxIter = 100;

mrfParam = nan(128,128,3);
FADPred = nan(128,128,30000);
r = nan(128);
r2 = nan(128);
sessionInfo.framerate = 25;
sessionInfo.framerate_new = 250;
for xInd = 1:size(Calcium_filter,2)
    for yInd = 1:size(Calcium_filter,1)
        if mask_new(yInd,xInd)
            %if mask(yInd,xInd)
            pixFAD = squeeze(FAD_filter(yInd,xInd,1:120*sessionInfo.framerate))';
            
            pixNeural = squeeze(Calcium_filter(yInd,xInd,1:120*sessionInfo.framerate))';
            
            
            
            calcium_interp = interp1(1:120*sessionInfo.framerate,pixNeural,linspace(1,120*sessionInfo.framerate,120*sessionInfo.framerate_new));
            
            FAD_interp = interp1(1:120*sessionInfo.framerate,pixFAD,linspace(1,120*sessionInfo.framerate,120*sessionInfo.framerate_new));
            clear pixNeural pixFAD
            
            t = (0:0.3*sessionInfo.framerate_new)./sessionInfo.framerate_new;
            
            
            he = mouse.math.HemodynamicsError(t,calcium_interp,FAD_interp);
            worstErr = sum(FAD_interp.^2);
            options.TolFun = worstErr*0.01;
            fcn = @(param)he.fcn(param);
            %[~,pixmrfParam] =
           [a,pixmrfParam,c,d,e] = evalc('fminsearchbnd(fcn,[0.02,0.003,0.05],[0.006,0.0005,0.02],[0.06,0.005,0.4],options)');
            %[a,pixmrfParam,c,d,e] = evalc('fminsearchbnd(fcn,[0.1,0.02,1],[0.002,0.001,0],[0.6,1.2,inf],options)');%paper
            %[~,pixHrfParam] = evalc('fminsearchbnd(fcn,[0.2,0.4,1],[0.01,0.01,0],[0.6,1.2,100000],options)');
            % saved before 11/01/21 [~,pixmrfParam] = evalc('fminsearchbnd(fcn,[0.2,0.4,1],[0.001,0.001,0],[0.6,1.2,inf],options)');
            %[~,pixmrfParam] = evalc('fminsearchbnd(fcn,[0.07,0.04,0.8],[0.0007,0.0004,0.008],[0.7,0.4,8],options)');
            pixelMrf = mouse.math.hrfGamma(t,pixmrfParam(1),pixmrfParam(2),pixmrfParam(3));
            
             %if pixmrfParam(1)> 0.0021
                pixFADPred = conv(calcium_interp,pixelMrf);
                pixFADPred = pixFADPred(1:numel(calcium_interp));
                
                mrfParam(yInd,xInd,:) = pixmrfParam;
                FADPred(yInd,xInd,:) = pixFADPred;
                
                r(yInd,xInd) = corr(pixFADPred',FAD_interp');%real(atanh(corr(pixHemoPred',pixHemo')));
                r2(yInd,xInd) = 1-sumsqr(FAD_interp-pixFADPred)/sumsqr(FAD_interp-mean(FAD_interp));
            %end
            %1 - var(pixHemoPred - pixHemo)/var(pixHemo);
        end
        %end
    end
end


T = mrfParam(:,:,1);
W = mrfParam(:,:,2);
A = mrfParam(:,:,3);

