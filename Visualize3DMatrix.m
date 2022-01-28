function Visualize3DMatrix(data,isbrain,fs)
%make sure that data is 128X128xtime

%Loading Atlas
load(which('AtlasandIsbrain.mat'))
Seed_names={'olf','fr','cing','m','ss','rs','p','vis','aud','ass'};%
%Rotating and Unraveling
isbrain_rot=flipdim(imrotate(isbrain,-90),2);
brainMapMovie_rotate11=flipdim(imrotate(data,-90),2);
tmp=squeeze(brainMapMovie_rotate11);
brainMapMovie_rotate=reshape(tmp,[size(data,1)*size(data,2)],size(tmp,3));


%Creating a Keeper Index
    keep_rot=[];
    indx=cell(numel(Seed_names),1);
    indx_rot=cell(numel(Seed_names),1);
    sort_ind_rot=[];    
    a_rot=0;      
    
    for i=1:numel(Seed_names)
        indx_rot{i}=find((flipdim(imrotate(AtlasSeeds_Big.*isbrain,-90),2))==i);  
        indx_rot{i+numel(Seed_names)}=find((flipdim(imrotate(AtlasSeeds_Big.*isbrain,-90),2))==i+numel(Seed_names));  %associated right side
        
        keep_rot=[keep_rot;indx_rot{i}]; 
        keep_rot=[keep_rot;indx_rot{i+numel(Seed_names)}]; 
        
        a_rot=a_rot+length(indx_rot{i});
        a_rot=a_rot+length(indx_rot{i+numel(Seed_names)});
        
        sort_ind_rot=[sort_ind_rot; a_rot]; 
    end

%Plotting    
figure
imagesc(brainMapMovie_rotate(keep_rot,:))
colormap default
h=colorbar;
hold on
for i=1:length(sort_ind_rot)
line([1 6000], [sort_ind_rot(i),sort_ind_rot(i)], 'Color', 'r');
end
ylim([sort_ind_rot(1)+-10, sort_ind_rot(10)])
yticks(sort_ind_rot(1:end))
yticklabels(Seed_names(1:end))
ytickangle(35)
title('3D Matrix Unwrapped to 2D')
xlabel('Time (Seconds)')
xticks([0:size(brainMapMovie_rotate,2)/fs:size(brainMapMovie_rotate,2)])
xtickz=xticks;
xticklabels([xtickz./fs]')
              



end