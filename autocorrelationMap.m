test=xform_jrgeco1aCorr_GSR;
for i=1:128
for ii=1:128
if xform_isbrain(i,ii)==1
[autocor,lags]=xcorr(squeeze(test(i,ii,:)),25*4,'coeff');
autocorr(i,ii,:,:)=autocor;
lag(i,ii,:,:)=lags';
semilogy(lags/25,autocor);
[B,I(i,ii,1:numel(autocorr(i,ii,:)))]=sort(autocorr(i,ii,:));
end
end
end

for ii = 1:128;for jj = 1:128; if xform_isbrain(ii,jj);imageLag(ii,jj) = lag(ii,jj,I(ii,jj,2)); end;end; end
figure
imagesc(abs(imageLag))
caxis([0 30])
imagesc(abs(imageLag))
caxis([0 30])