function [powerMap,glob_power,region_power,Seed_names]= PowerAnalysis(data,framerate,freqRange)
load('AtlasandIsbrain')
nVy = size(data,1);
nVx = size(data,2);
data(isnan(data)) = 0;
data1 = transpose(reshape(data,nVx*nVy,[]));
[Pxx,hz] = pwelch(data1,[],[],[],framerate); %returns 128*128
Pxx = Pxx';
Pxx = reshape(Pxx,[],size(Pxx,3));
Pxx = reshape(Pxx,nVy,nVx,[]);
 [~,start_freq]=min(abs(hz-freqRange(1))); %This is finding closest value to the cutoff frequencies
 [~,end_freq]=min(abs(hz-freqRange(2)));
 powerMap = zeros(nVy,nVx);
for kk = 1:nVy
    for ll=1:nVx
        powerMap(kk,ll) = (hz(2)-hz(1))*sum(Pxx(kk,ll,start_freq: end_freq))/(end_freq-start_freq);
    end
end

%Global Power
glob_sig=mean(reshape(data,[size(data,1)*size(data,2),size(data,3)]),1,'omitnan');
[global_for,hz]=pwelch(glob_sig,[],[],[],framerate);
glob_power=trapz(hz(start_freq:end_freq),global_for(start_freq:end_freq));


Seed_names={'olf','fr','cing','m','ss','rs','p','vis','aud','ass'};
region_power=zeros(size(Seed_names));

%Regional Power
for i=1:size(Seed_names,2)
reg_data= data.*(AtlasSeeds_Big==i);
reg_sig=mean(reshape(reg_data,[size(reg_data,1)*size(reg_data,2),size(reg_data,3)]),1,'omitnan');
[reg_for,hz]=pwelch(reg_sig,[],[],[],framerate);
region_power(1,i)=trapz(hz(start_freq:end_freq),reg_for(start_freq:end_freq));

end


end

