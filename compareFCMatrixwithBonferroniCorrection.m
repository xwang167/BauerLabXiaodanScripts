function [h,p] = compareFCMatrixwithBonferroniCorrection(alpha,vararg)

% fcMatrix is in # of seeds * # of Seeds * Contrasts * mice
nPy = size(fcMatrix1,1);
nPx = size(fcMatrix1,2);


h = nan(nPy,nPx,size(fcMatrix1,3));
p = nan(nPy,nPx,size(fcMatrix1,3));

% Bonferroni Correction
alpha = alpha/((1-nPy)^2/2);
for contrast = 1:size(fcMatrix1,3)
    for y = 2:nPy
        for x = 1:nPx-1
            [h(y,x,contrast),p(ii,jj,contrast)] = ttest2(fcMatrix1(y,x,contrast,:), fcMatrix2(y,x,contrst,:), alpha, 'both', 'unequal'); 
        end
    end
end