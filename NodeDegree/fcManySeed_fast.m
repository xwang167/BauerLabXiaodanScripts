function [R_seed]=fcManySeed_fast(datahb,isbrain1, meth, isbrain2)

if ~exist('isbrain2','var'); isbrain2=[]; end

nVy=size(datahb,1);
ibi=isbrain1==1;

datahb2=gsr_multi(datahb,isbrain1, meth, isbrain2);
datahb2=reshape(datahb2,nVy*nVy,[]);
datahb3=datahb2(ibi,:);

R_seed=normr(datahb3)*normr(datahb3)';

end
