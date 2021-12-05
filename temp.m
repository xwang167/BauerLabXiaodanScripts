 kk = 1;
for ii = 1:3
for jj = 1:5
subplot(3,5,kk)
imagesc(powerMap(:,:,ii,jj))
axis image off
colorbar
kk = kk+1;
end
end