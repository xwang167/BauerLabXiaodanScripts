

y = y';
 X = ones(length(y),3);
 X(:,2) = calcium_ROI_GSR_anes;
 X(:,3) = FAD_ROI_GSR_anes;
 [B,BINT,R,RINT,STATS] = regress(y,X);
scatter3(X(:,2),X(:,3),y,'filled')
hold on
x1fit = min(X(:,2)):max(X(:,2));
x2fit = min(X(:,3)):max(X(:,3));
[X1FIT,X2FIT] = meshgrid(x1fit,x2fit);
YFIT = B(1) + B(2)*X1FIT + B(3)*X2FIT; 
mesh(X1FIT,X2FIT,YFIT)
view(50,10)
hold off

GSR - anes: x1  = calcium,x2 = FAD, y = hemoglobin
B =
   -0.4919
    0.4660
   -0.0643
STATS =
    0.2742   22.0993    0.0000    0.1894