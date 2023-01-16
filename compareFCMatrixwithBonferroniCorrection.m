function [h,p] = compareFCMatrixwithBonferroniCorrection(alpha,fcMatrix1,varargin)
% fcMatrix is in # of seeds * # of Seeds * Contrasts * mice
% if varargin empty, fcMatrix1 needs to be the difference between 2 matrix

if numel(varargin) > 0
    fcMatrix2 = varargin;
end
nPy = size(fcMatrix1,1);
nPx = size(fcMatrix1,2);


h = nan(nPy,nPx,size(fcMatrix1,3));
p = nan(nPy,nPx,size(fcMatrix1,3));

% Bonferroni Correction
alpha = alpha/((1-nPy)^2/2);
for contrast = 1:size(fcMatrix1,3)
    for y = 2:nPy
        for x = 1:nPx-1
            if numel(varargin) > 0
                [h(y,x,contrast),p(ii,jj,contrast)] = ttest2(fcMatrix1(y,x,contrast,:), fcMatrix2(y,x,contrst,:), alpha, 'both', 'unequal');
            else
                [h(y,x,contrast),p(ii,jj,contrast)] = ttest(fcMatrix1(y,x,contrast,:), alpha, 'both', 'unequal');
            end
        end
    end
end