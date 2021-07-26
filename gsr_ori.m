function [Oxy_gsr, DeOxy_gsr]=gsr(datahb,isbrain)

[nVx, nVy, hb, T]=size(datahb);

datahb=reshape(datahb,nVx*nVy,hb,T);
gs=squeeze(mean(datahb(isbrain==1,:,:),1));
[datahb2, Rgs]=regcorr(datahb,gs);
Oxy_gsr=squeeze(datahb2(:,1,:));
DeOxy_gsr=squeeze(datahb2(:,2,:));

Oxy_gsr=reshape(Oxy_gsr, nVy, nVx,[]);
DeOxy_gsr=reshape(DeOxy_gsr, nVy, nVx,[]);

end