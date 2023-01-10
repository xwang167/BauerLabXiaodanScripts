function [h,p] = compareFCMatrixwithBonferoniCorrection(fcMatrix1,fcMatrix2,alpha)
nVy = size(fcMatrix1,1);
nVx = size(fcMatrix1,2);

h = nan(nVy,nVx);
p = nan(nVy,nVx);

for y = 2:nVy
    for x = 1:nVx-1
        [h(y,x),p(ii,jj)] = ttest2(fcMatrix1(y,x,:), fcMatrix2(y,x,:), alpha, 'both', 'unequal'); 
    end
end