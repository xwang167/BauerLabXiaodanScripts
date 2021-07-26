function [R_seed]=fcManySeed_fast_fluor(datafluor,isbrain1)
nVy=size(datafluor,1);
ibi=isbrain1==1;

datahb2=gsr(datafluor,isbrain1);
datahb2=reshape(datahb2,nVy*nVy,[]);
datahb3=datahb2(ibi,:);

R_seed=normr(datahb3)*normr(datahb3)';

end