atlasandisbrain_loc="A:\JPC\AtlasandIsbrain.mat";
load(atlasandisbrain_loc,'AtlasSeeds_Big')
Seed_names={'olf','fr','cing','m','ss','rs','p','vis','aud','ass'};
AtlasSeeds_Big(AtlasSeeds_Big==0)=nan;
isbrain_rot=flipdim(imrotate(xform_isbrain,-90),2);
movie_rotate(:,:,:)=flipdim(imrotate(movie,-90),2);
movie_rotate=reshape(movie_rotate,128*128,size(movie,3)); %unwrap the movie!
%where the sorting and the magic happens!
    keep_rot=[];
    indx=cell(size(Seed_names,2),1);
    indx_rot=cell(size(Seed_names,2),1);
    sort_ind_rot=[];
    a_rot=0;
    %only consider things that are on the brain map
    for i=1:size(Seed_names,2)
        indx_rot{i}=find((flipdim(imrotate(AtlasSeeds_Big.*isbrain_rot,-90),2)==i)==1);
        [x{i},y{i}]=ind2sub([160,160],indx_rot{i});
        keep_rot=[keep_rot;indx_rot{i}]; %if we want all L and then all right
        a_rot=a_rot+length(indx_rot{i});
        sort_ind_rot=[sort_ind_rot; a_rot];
    end
%% continue plotting
subplot(2,3,dir)
imagesc(movie_rotate(keep_rot,:))
colormap default
h=colorbar;
set(get(h,'title'),'string','cm');