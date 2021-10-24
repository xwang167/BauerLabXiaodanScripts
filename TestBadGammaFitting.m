
% load('L:\RGECO\190627\190627-R5M2285-fc1_processed.mat', 'xform_jrgeco1aCorr',...
%     'xform_FADCorr','T_CalciumFAD','W_CalciumFAD','A_CalciumFAD','r_CalciumFAD')
%
% figure
% imagesc(A_CalciumFAD)
% title('A')
% figure
% imagesc(T_CalciumFAD)
% title('T')
% figure
% imagesc(W_CalciumFAD)
% title('W')
% figure
% imagesc(r_CalciumFAD)
% title('r')
%
% t = [0:0.001:2];
% alpha = (T_CalciumFAD(95,22)/W_CalciumFAD(95,22))^2*8*log(2);
% beta = W_CalciumFAD(95,22)^2/(T_CalciumFAD(95,22)*8*log(2));
% y = A_CalciumFAD(95,22)*(t/T_CalciumFAD(95,22)).^alpha.*exp((t-T_CalciumFAD(95,22))/(-beta));
%
% figure
% plot(t,y)
%
% figure
% plot((1:750)/25,normCol(squeeze(xform_jrgeco1aCorr(95,22,1:750))),'m')
% hold on
% plot((1:750)/25,normCol(squeeze(xform_FADCorr(95,22,1:750))),'g')
%
%
% figure
% plot((1:14999)/25,normCol(squeeze(xform_jrgeco1aCorr(95,22,:))),'m')
% hold on
% plot((1:14999)/25,normCol(squeeze(xform_FADCorr(95,22,:))),'g')
%
% figure
% plot(t,y)
%
% figure
%
% plot((6875:7624)/25,normCol(squeeze(xform_jrgeco1aCorr(95,22,6875:7624))),'m')
% hold on
% plot((6875:7624)/25,normCol(squeeze(xform_FADCorr(95,22,6875:7624))),'g')
%
% figure
% plot((1:280*25)/25,normCol(squeeze(xform_jrgeco1aCorr(95,22,1:280*25))),'m')
% hold on
% plot((1:280*25)/25,normCol(squeeze(xform_FADCorr(95,22,1:280*25))),'g')
%
%
% pixNeural = normCol(squeeze(xform_jrgeco1aCorr(95,22,1:280*25)));
% pixFAD = normCol(squeeze(xform_FADCorr(95,22,1:280*25)));
% figure
% plot((1:280*25)/25,pixNeural,'m')
% hold on
% plot((1:280*25)/25,pixFAD,'g')
% xlim([0,280])
% xlabel('Time(s)')
% ylabel('Normalized')
xform_FADCorr(isinf(xform_FADCorr)) = 0;
xform_FADCorr(isnan(xform_FADCorr)) = 0;
xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;
FAD_filter = mouse.freq.filterData(double(xform_FADCorr),0.02,2,25);
Calcium_filter = mouse.freq.filterData(double(squeeze(xform_jrgeco1aCorr)),0.02,2,25);
Calcium_filter = reshape(Calcium_filter,128*128,[]);
FAD_filter = reshape(FAD_filter,128*128,[]);
Calcium_filter = normRow(Calcium_filter);
FAD_filter = normRow(FAD_filter);
Calcium_filter = reshape(Calcium_filter,128,128,[]);
FAD_filter = reshape(FAD_filter,128,128,[]);
pixNeural = squeeze(Calcium_filter(95,22,:));
pixFAD = squeeze(FAD_filter(95,22,:));
t = 0:0.001:1;
[T_CalciumFAD,W_CalciumFAD,A_CalciumFAD,r_CalciumFAD,r2_CalciumFAD,FADPred_CalciumFAD] = interSpeciesGammaFit_CalciumFAD(Calcium_filter,FAD_filter,t);


options = optimset('Display','iter');
he = mouse.math.HemodynamicsError(t,pixNeural',pixFAD');
worstErr = sum(pixFAD.^2);
options.TolFun = worstErr*0.01;
fcn = @(param)he.fcn(param);
%[~,pixHrfParam] = evalc('fminsearchbnd(fcn,[0.2,0.4,1],[0.01,0.01,0],[0.6,1.2,100000],options)');
[~,pixmrfParam] = evalc('fminsearchbnd(fcn,[0.2,0.4,1],[0.001,0.001,0],[0.6,1.2,inf],options)');
pixelMrf = mouse.math.hrfGamma(t,pixmrfParam(1),pixmrfParam(2),pixmrfParam(3));