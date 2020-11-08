import mouse.*
load('J:\PVRGECO\200915\200915-N4M326-M-opto3-stim1_processed.mat',...
    'xform_jrgeco1aCorr','xform_jrgeco1a','xform_red','xform_datahb','ROI_NoGSR')

nVx =128'
nVy =128;

% numBlock = size(xform_datahb,4)/600;
% 
% numDesample = size(xform_datahb,4)/20*20;
% factor = round(numDesample/numBlock);
% numDesample = factor*numBlock;
% %
% texttitle_NoGSR = strcat('N4M326-anes-1mW-M-opto3','-stim1'," ",'without GSR nor filtering');
% output_NoGSR= fullfile('J:\PVRGECO\200915','200915-N4M326-anes-1mW-M-opto3-stim1-NoGSR');
% disp('QC on non GSR stim')
% [goodBlocks_NoGSR,ROI_NoGSR] = QC_stim(squeeze(xform_datahb(:,:,1,:))*10^6,squeeze(xform_datahb(:,:,2,:))*10^6,...
%     [],[],[],xform_jrgeco1a*100,xform_jrgeco1aCorr*100,xform_red*100,...
%     xform_isbrain,numBlock,numDesample,5,3,20,20,600,100,texttitle_NoGSR,output_NoGSR,ROI_NoGSR);


xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128,128,600,10);
xform_jrgeco1aCorr_average = mean(xform_jrgeco1aCorr,4);
    peakMap_ROI = mean(xform_jrgeco1aCorr_average(:,:,101:160),3);   

ibi_center = find(ROI_NoGSR == 1);
framerate = 20;

 figure
   colormap jet
    imagesc(peakMap_ROI,[-0.02 0.02])
    axis image off
    colorbar
    [X,Y] = meshgrid(1:128,1:128);
        
        [x1,y1] = ginput(1);
        [x2,y2] = ginput(1);
        
        radius = sqrt((x1-x2)^2+(y1-y2)^2);
   
    ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
    min_ROI = prctile(peakMap_ROI(ROI),1);
    temp = double(peakMap_ROI).*double(ROI);
    ROI = temp<min_ROI*0.75;
    ROI = ROI-ROI_NoGSR;
    ROI(ROI<0) = 0;
    ibi_ring = find(ROI == 1);


data = xform_jrgeco1aCorr;
data(isnan(data)) = 0;
data(isinf(data)) = 0;
data = transpose(reshape(data,nVx*nVy,[]));
[Pxx,hz] = pwelch(data,[],[],[],framerate);
Pxx = Pxx';
powerdata_calcium_center = mean(Pxx(ibi_center,:),1);
powerdata_calcium_ring = mean(Pxx(ibi_ring,:),1);




data = xform_datahb(:,:,1,:);
data(isnan(data)) = 0;
data(isinf(data)) = 0;
data = transpose(reshape(data,nVx*nVy,[]));
[Pxx,hz] = pwelch(data,[],[],[],framerate);
Pxx = Pxx';
powerdata_oxy_center = mean(Pxx(ibi_center,:),1);
powerdata_oxy_ring = mean(Pxx(ibi_ring,:),1);

data = xform_datahb(:,:,2,:);
data(isnan(data)) = 0;
data(isinf(data)) = 0;
data = transpose(reshape(data,nVx*nVy,[]));
[Pxx,hz] = pwelch(data,[],[],[],framerate);
Pxx = Pxx';
powerdata_deoxy_center = mean(Pxx(ibi_center,:),1);
powerdata_deoxy_ring = mean(Pxx(ibi_ring,:),1);


  

figure
subplot(1,3,1);loglog(hz,powerdata_calcium_center,'m');hold on;loglog(hz,powerdata_calcium_ring,'k:');title('jrgeco1aCorr');legend('Center','Ring','location','southwest')
subplot(1,3,2);loglog(hz,powerdata_oxy_center,'r');hold on;loglog(hz,powerdata_oxy_ring,'k:');title('Oxy');legend('Center','Ring','location','southwest')
subplot(1,3,3);loglog(hz,powerdata_deoxy_center,'b');hold on;hold on;loglog(hz,powerdata_deoxy_ring,'k:');title('DeOxy');legend('Center','Ring','location','southwest')



[sourceSpectra, lambda2] = bauerParams.getSpectra(lightSourceFiles)
