
load('GCaMP_awake-seedFC-rows196~199-0p009-0p08.mat', 'seedFCMapCat')
FCMap_oxy_isa_proc1 = seedFCMapCat{1,1};
FCMap_total_isa_proc1 = seedFCMapCat{1,3};
FCMap_fluor_isa_proc1 = seedFCMapCat{1,4};
load('GCaMP_awake-seedFC-rows196~199-0p4-4.mat', 'seedFCMapCat')
FCMap_oxy_delta_proc1 = seedFCMapCat{1,1};
FCMap_total_delta_proc1 = seedFCMapCat{1,3};
FCMap_fluor_delta_proc1 = seedFCMapCat{1,4};
load('GCaMP_awake-seedFC-rows206~209-0p009-0p08.mat', 'seedFCMapCat')
FCMap_oxy_isa_proc2 = seedFCMapCat{1,1};
FCMap_total_isa_proc2 = seedFCMapCat{1,3};
FCMap_fluor_isa_proc2 = seedFCMapCat{1,4};
load('GCaMP_awake-seedFC-rows206~209-0p4-4.mat', 'seedFCMapCat')
FCMap_oxy_delta_proc2 = seedFCMapCat{1,1};
FCMap_total_delta_proc2 = seedFCMapCat{1,3};
FCMap_fluor_delta_proc2 = seedFCMapCat{1,4};
load('GCaMP_awake-seedFC-rows210~213-0p009-0p08.mat', 'seedFCMapCat')

FCMap_oxy_isa_proc3 = seedFCMapCat{1,1};
FCMap_total_isa_proc3 = seedFCMapCat{1,3};
FCMap_fluor_isa_proc3 = seedFCMapCat{1,4};

load('GCaMP_awake-seedFC-rows210~213-0p4-4.mat', 'seedFCMapCat')
FCMap_oxy_delta_proc3 = seedFCMapCat{1,1};
FCMap_total_delta_proc3 = seedFCMapCat{1,3};
FCMap_fluor_delta_proc3 = seedFCMapCat{1,4};

load('GCaMP_awake-seedFC-rows214~217-0p009-0p08.mat', 'seedFCMapCat')
FCMap_oxy_isa_proc4 = seedFCMapCat{1,1};
FCMap_total_isa_proc4 = seedFCMapCat{1,3};
FCMap_fluor_isa_proc4 = seedFCMapCat{1,4};
load('GCaMP_awake-seedFC-rows214~217-0p4-4.mat', 'seedFCMapCat')
FCMap_oxy_delta_proc4 = seedFCMapCat{1,1};
FCMap_total_delta_proc4 = seedFCMapCat{1,3};
FCMap_fluor_delta_proc4 = seedFCMapCat{1,4};

load('Zack_xform_isbrain.mat', 'xform_isbrain_total')
xform_isbrain_all = xform_isbrain_total.*xform_isbrain_total_Aubrey;
figure
imagesc(xform_isbrain_all)




FCMap_oxy_isa_baseline = seedFCMapCat_isa_baseline{1,1};
FCMap_total_isa_baseline = seedFCMapCat_isa_baseline{1,3};
FCMap_fluor_isa_baseline = seedFCMapCat_isa_baseline{1,4};

FCMap_oxy_delta_baseline = seedFCMapCat_delta_baseline{1,1};
FCMap_total_delta_baseline = seedFCMapCat_delta_baseline{1,3};
FCMap_fluor_delta_baseline = seedFCMapCat_delta_baseline{1,4};


species = {'oxy','total','fluor'};
band = {'isa','delta'};
for ii = 1:3
    for jj = 1:2
        for kk = 1:4
            for ll = [3 4 5 7 11 12 13 15]
                aubrey = genvarname(['FCMap_' species{ii} '_' band{jj} '_proc' num2str(kk)]);
                eval([ 'A=' aubrey '(:,:,ll).*xform_isbrain_all;' ])
                
                baseline = genvarname(['FCMap_' species{ii} '_' band{jj} '_baseline']);
                
                eval([ 'B=' baseline '(:,:,ll).*xform_isbrain_all;' ])
                A = reshape(A,1,[]);
                B = reshape(B,[],1);
                
                similarity = genvarname(['sim_' species{ii} '_' band{jj} '_' num2str(kk) '_' num2str(ll)]);
                eval([similarity '= corr(transpose(A),B);'])
            end
        end
    end
end



x = [1 2 3 4];
for ii = 1:3
    for jj = 1:2
    figure;
    for ll = [3 4 5 7 11 12 13 15]
    y1 = genvarname(['sim_' species{ii} '_' band{jj} '_' num2str(1) '_' num2str(ll)]);
    y2 = genvarname(['sim_' species{ii} '_' band{jj} '_' num2str(2) '_' num2str(ll)]);
    y3 = genvarname(['sim_' species{ii} '_' band{jj} '_' num2str(3) '_' num2str(ll)]);
    y4 = genvarname(['sim_' species{ii} '_' band{jj} '_' num2str(4) '_' num2str(ll)]);
    eval(['plot(x,[' y1 ',' y2 ',' y3 ',' y4 ']);']);
    hold on
    end
    title([species{1,ii} '-' band{1,jj}])
    legend({'M-L','S-L','RS-L','V-L','M-R','S-R','RS-R','V-R'},'location','southwest')
    xticks(x)
    xticklabels({'190708','1907010','190712','190719'})
    end
end
c = {'r','g','b','y','m','c','k',[0.6 0 0],[0 0.6 0], [0 0 0.6],[0.6 0.6 0], [0 0.6 0.6]};

figure;
for ii = 1:12
    scatter([1+0.1*(rand-0.5), 2+0.1*(rand-0.5),3+0.1*(rand-0.5)],squeeze(stimArray_ISA(1,ii,1,1,1:3)),200,c{ii},'filled');
    hold on
end
xticks([1 2 3]);xticklabels({'Protocol 1','Protocol 2','Protocol 3'})
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',18)
title('Oxy ISA ML')

figure;
for ii = 1:12
    scatter([1+0.1*(rand-0.5), 2+0.1*(rand-0.5),3+0.1*(rand-0.5)],squeeze(stimArray_ISA(2,ii,1,1,1:3)),200,c{ii},'filled');
    hold on
end
xticks([1 2 3]);xticklabels({'Protocol 1','Protocol 2','Protocol 3'})
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',18)
title('Oxy ISA SSL')

figure;
for ii = 1:12
    scatter([1+0.1*(rand-0.5), 2+0.1*(rand-0.5),3+0.1*(rand-0.5)],squeeze(stimArray_ISA(2,ii,1,1,1:3)),200,c{ii},'filled');
    hold on
end
xticks([1 2 3]);xticklabels({'Protocol 1','Protocol 2','Protocol 3'})
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',18)
title('Oxy ISA SSL')


figure;
for ii = 1:12
    scatter([1+0.1*(rand-0.5), 2+0.1*(rand-0.5),3+0.1*(rand-0.5)],squeeze(stimArray_ISA(3,ii,1,1,1:3)),200,c{ii},'filled');
    hold on
end
xticks([1 2 3]);xticklabels({'Protocol 1','Protocol 2','Protocol 3'})
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',18)
title('Oxy ISA RSL')

figure;
for ii = 1:12
    scatter([1+0.1*(rand-0.5), 2+0.1*(rand-0.5),3+0.1*(rand-0.5)],squeeze(stimArray_ISA(4,ii,1,1,1:3)),200,c{ii},'filled');
    hold on
end
xticks([1 2 3]);xticklabels({'Protocol 1','Protocol 2','Protocol 3'})
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',18)
title('Oxy ISA VL')

figure;
for ii = 1:12
    scatter([1+0.1*(rand-0.5), 2+0.1*(rand-0.5),3+0.1*(rand-0.5)],squeeze(stimArray_ISA(1,ii,2,1,1:3)),200,c{ii},'filled');
    hold on
end
xticks([1 2 3]);xticklabels({'Protocol1','Protocol2','Protocol3'})
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',18)
ylim([0 1])
ylabel('Similarity')
xlim([0.5 3.5])
title('Total ISA ML')

figure;
for ii = 1:12
    scatter([1+0.1*(rand-0.5), 2+0.1*(rand-0.5),3+0.1*(rand-0.5)],squeeze(stimArray_ISA(2,ii,2,1,1:3)),200,c{ii},'filled');
    hold on
end
xticks([1 2 3]);xticklabels({'Protocol 1','Protocol 2','Protocol 3'})
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',18)
ylim([0 1])
ylabel('Similarity')
xlim([0 4])
title('Total ISA SSL')

figure;
for ii = 1:12
    scatter([1+0.1*(rand-0.5), 2+0.1*(rand-0.5),3+0.1*(rand-0.5)],squeeze(stimArray_ISA(3,ii,2,1,1:3)),200,c{ii},'filled');
    hold on
end
xticks([1 2 3]);xticklabels({'Protocol 1','Protocol 2','Protocol 3'})
ylim([0 1])
xlim([0.5 3.5])
ylabel('Similarity')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',18)
title('Total ISA RSL')

figure
for ii = 1:12
    scatter([1+0.1*(rand-0.5), 2+0.1*(rand-0.5),3+0.1*(rand-0.5)],squeeze(stimArray_ISA(4,ii,2,1,1:3)),200,c{ii},'filled');
    hold on
end
xticks([1 2 3]);xticklabels({'Protocol1','Protocol2','Protocol3'})
ylim([0 1])
xlim([0 4])
ylabel('Similarity')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',18)
title('Total ISA VL')





figure;
for ii = 1:12
    scatter([1+0.1*(rand-0.5), 2+0.1*(rand-0.5),3+0.1*(rand-0.5)],squeeze(stimArray_ISA(1,ii,3,1,1:3)),200,c{ii},'filled','filled');
    hold on
end
xticks([1 2 3]);xticklabels({'Protocol 1','Protocol 2','Protocol 3'})
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',18)
ylim([0 1])
ylabel('Similarity')
title('GCaMP ISA ML')

figure;
for ii = 1:12
    scatter([1+0.1*(rand-0.5), 2+0.1*(rand-0.5),3+0.1*(rand-0.5)],squeeze(stimArray_ISA(2,ii,3,1,1:3)),200,c{ii},'filled','filled');
    hold on
end
xticks([1 2 3]);xticklabels({'Protocol 1','Protocol 2','Protocol 3'})
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',18)
ylim([0 1])
ylabel('Similarity')
title('GCaMP ISA SSL')

figure;
for ii = 1:12
    scatter([1+0.1*(rand-0.5), 2+0.1*(rand-0.5),3+0.1*(rand-0.5)],squeeze(stimArray_ISA(3,ii,3,1,1:3)),200,c{ii},'filled','filled');
    hold on
end
xticks([1 2 3]);xticklabels({'Protocol 1','Protocol 2','Protocol 3'})
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',18)
ylim([0 1])
ylabel('Similarity')
title('GCaMP ISA RSL')

figure;
for ii = 1:12
    scatter([1+0.1*(rand-0.5), 2+0.1*(rand-0.5),3+0.1*(rand-0.5)],squeeze(stimArray_ISA(4,ii,3,1,1:3)),200,c{ii},'filled','filled');
    hold on
end
xticks([1 2 3]);xticklabels({'Protocol 1','Protocol 2','Protocol 3'})
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',18)
ylim([0 1])
ylabel('Similarity')
title('GCaMP ISA VL')
figure;
for ii = 1:12
    scatter([1+0.1*(rand-0.5), 2+0.1*(rand-0.5),3+0.1*(rand-0.5)],squeeze(stimArray_Delta(1,ii,1,2,1:3)),200,c{ii},'filled');
    hold on
end
xticks([1 2 3]);xticklabels({'Protocol 1','Protocol 2','Protocol 3'})
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',18)
title('Oxy Delta ML')

figure;
for ii = 1:12
    scatter([1+0.1*(rand-0.5), 2+0.1*(rand-0.5),3+0.1*(rand-0.5)],squeeze(stimArray_Delta(2,ii,1,2,1:3)),200,c{ii},'filled');
    hold on
end
xticks([1 2 3]);xticklabels({'Protocol 1','Protocol 2','Protocol 3'})
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',18)
title('Oxy Delta SSL')



figure;
for ii = 1:12
    scatter([1+0.1*(rand-0.5), 2+0.1*(rand-0.5),3+0.1*(rand-0.5)],squeeze(stimArray_Delta(3,ii,1,2,1:3)),200,c{ii},'filled');
    hold on
end
xticks([1 2 3]);xticklabels({'Protocol 1','Protocol 2','Protocol 3'})
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',18)
title('Oxy Delta RSL')

figure;
for ii = 1:12
    scatter([1+0.1*(rand-0.5), 2+0.1*(rand-0.5),3+0.1*(rand-0.5)],squeeze(stimArray_Delta(4,ii,1,2,1:3)),200,c{ii},'filled');
    hold on
end
xticks([1 2 3]);xticklabels({'Protocol 1','Protocol 2','Protocol 3'})
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',18)
title('Oxy Delta VL')

figure;
for ii = 1:12
    scatter([1+0.1*(rand-0.5), 2+0.1*(rand-0.5),3+0.1*(rand-0.5)],squeeze(stimArray_Delta(1,ii,2,2,1:3)),200,c{ii},'filled');
    hold on
end
xticks([1 2 3]);xticklabels({'Protocol 1','Protocol 2','Protocol 3'})
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',18)
title('Total Delta ML')

figure;
for ii = 1:12
    scatter([1+0.1*(rand-0.5), 2+0.1*(rand-0.5),3+0.1*(rand-0.5)],squeeze(stimArray_Delta(2,ii,2,2,1:3)),200,c{ii},'filled');
    hold on
end
xticks([1 2 3]);xticklabels({'Protocol 1','Protocol 2','Protocol 3'})
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',18)
title('Total Delta SSL')

figure;
for ii = 1:12
    scatter([1+0.1*(rand-0.5), 2+0.1*(rand-0.5),3+0.1*(rand-0.5)],squeeze(stimArray_Delta(3,ii,2,2,1:3)),200,c{ii},'filled');
    hold on
end
xticks([1 2 3]);xticklabels({'Protocol 1','Protocol 2','Protocol 3'})
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',18)
title('Total Delta RSL')

figure;
for ii = 1:12
    scatter([1+0.1*(rand-0.5), 2+0.1*(rand-0.5),3+0.1*(rand-0.5)],squeeze(stimArray_Delta(4,ii,2,2,1:3)),200,c{ii},'filled');
    hold on
end
xticks([1 2 3]);xticklabels({'Protocol 1','Protocol 2','Protocol 3'})
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',18)
title('Total Delta VL')





figure;
for ii = 1:12
    scatter([1+0.1*(rand-0.5), 2+0.1*(rand-0.5),3+0.1*(rand-0.5)],squeeze(stimArray_Delta(1,ii,3,2,1:3)),200,c{ii},'filled');
    hold on
end
xticks([1 2 3]);xticklabels({'Protocol 1','Protocol 2','Protocol 3'})
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',18)
ylim([0 1])
ylabel('Similarity')
title('GCaMP Delta ML')

figure;
for ii = 1:12
    scatter([1+0.1*(rand-0.5), 2+0.1*(rand-0.5),3+0.1*(rand-0.5)],squeeze(stimArray_Delta(2,ii,3,2,1:3)),200,c{ii},'filled');
    hold on
end
xticks([1 2 3]);xticklabels({'Protocol 1','Protocol 2','Protocol 3'})
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',18)
ylim([0 1])
ylabel('Similarity')
title('GCaMP Delta SSL')

figure;
for ii = 1:12
    scatter([1+0.1*(rand-0.5), 2+0.1*(rand-0.5),3+0.1*(rand-0.5)],squeeze(stimArray_Delta(3,ii,3,2,1:3)),200,c{ii},'filled');
    hold on
end
xticks([1 2 3]);xticklabels({'Protocol 1','Protocol 2','Protocol 3'})
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',18)
ylim([0 1])
ylabel('Similarity')
title('GCaMP Delta RSL')

figure;
for ii = 1:12
    scatter([1+0.1*(rand-0.5), 2+0.1*(rand-0.5),3+0.1*(rand-0.5)],squeeze(stimArray_Delta(4,ii,3,2,1:3)),200,c{ii},'filled');
    hold on
end
xticks([1 2 3]);xticklabels({'Protocol 1','Protocol 2','Protocol 3'})
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',18)
ylim([0 1])
ylabel('Similarity')
title('GCaMP Delta VL')


