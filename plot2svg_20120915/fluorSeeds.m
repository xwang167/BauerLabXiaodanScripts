refseeds=GetReferenceSeeds;
            refseeds = refseeds(1:14,:);
figure
subplot(1,4,1)
imagesc(R_jrgeco1aCorr_ISA_mice(:,:,7),[-1 1])
hold on
plot(refseeds(7,1),ref(7,2));
hold on
imagesc(WL,'AlphaData',1-xform_isbrain_mice)
subplot(1,4,2)
imagesc(R_jrgeco1aCorr_ISA_mice(:,:,9),[-1 1])
plot(refseeds(9,1),ref(9,2));
subplot(1,4,3)
imagesc(R_jrgeco1aCorr_ISA_mice(:,:,11),[-1 1])
subplot(1,4,4)
imagesc(R_jrgeco1aCorr_ISA_mice(:,:,13),[-1 1])

