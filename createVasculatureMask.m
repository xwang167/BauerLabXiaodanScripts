function vasculatureMask = createVasculatureMask(xform_datahb,framerate,xform_isbrain,seed, seedName)
if isempty(seed)
    [~, I] = GetReferenceSeeds;
    seed = I.OF;
end
figure
total = squeeze(xform_datahb(:,:,1,:))+squeeze(xform_datahb(:,:,2,:));
[R,~] = QCcheck_CalcRRs(seed,total,framerate,xform_isbrain,[0.009,0.08],false);
imagesc(R,[0.5 1]);
 title(strcat('total fc without GSR for ISA band ', " ",seedName))
colorbar
 axis image off
 hold on
scatter(seed,'r')

 figure
[R,~] = QCcheck_CalcRRs(seed,squeeze(xform_datahb(:,:,1,:)),framerate,xform_isbrain,[0.009,0.08],false);
imagesc(R,[0.95 1]);
hold on
scatter(seed,'r')
 title(strcat('oxy fc without GSR for ISA band ', " ",seedName))
 colorbar
  axis image off
 
 figure
[R,~] = QCcheck_CalcRRs(seed,squeeze(xform_datahb(:,:,2,:)),framerate,xform_isbrain,[0.009,0.08],false);
imagesc(R,[0.95 1]);
 title(strcat('deoxy fc without GSR for ISA band '," ",seedName))
 colorbar
 axis image off
 hold on
scatter(seed,'r')
