function [powerMap,glob_power,region_power,Seed_names]= PowerAnalysis_noRange(data,framerate)
load('AtlasandIsbrain')
nVy = size(data,1);
nVx = size(data,2);
data(isnan(data)) = 0;
data1 = transpose(reshape(data,nVx*nVy,[]));
[Pxx,hz] = pwelch(data1,[],[],[],framerate); %returns 128*128
Pxx = Pxx';
Pxx = reshape(Pxx,[],size(Pxx,3));
Pxx = reshape(Pxx,nVy,nVx,[]);

freqRange= {[0.009,0.08],[0.4,4],[0,20]};


 [~,start_freq.isa]=min(abs(hz-freqRange{1}(1))); %This is finding closest value to the cutoff frequencies
 [~,end_freq.isa]=min(abs(hz-freqRange{1}(2)));
 
 [~,start_freq.delta]=min(abs(hz-freqRange{2}(1))); %This is finding closest value to the cutoff frequencies
 [~,end_freq.delta]=min(abs(hz-freqRange{2}(2)));
 
 [~,start_freq.full]=min(abs(hz-freqRange{3}(1))); %This is finding closest value to the cutoff frequencies
 [~,end_freq.full]=min(abs(hz-freqRange{3}(2)));
 
 powerMap.isa = zeros(nVy,nVx);
 powerMap.delta = zeros(nVy,nVx);
 powerMap.full = zeros(nVy,nVx);

for kk = 1:nVy
    for ll=1:nVx
        powerMap.isa(kk,ll) = (hz(2)-hz(1))*sum(Pxx(kk,ll,start_freq.isa: end_freq.isa))/(end_freq.isa-start_freq.isa);
        powerMap.delta(kk,ll) = (hz(2)-hz(1))*sum(Pxx(kk,ll,start_freq.delta: end_freq.delta))/(end_freq.delta-start_freq.delta);
        powerMap.full(kk,ll) = (hz(2)-hz(1))*sum(Pxx(kk,ll,start_freq.full: end_freq.full))/(end_freq.full-start_freq.full);
    end
end


%Global Power
glob_sig=mean(reshape(data,[size(data,1)*size(data,2),size(data,3)]),1,'omitnan');
[global_for,hz]=pwelch(glob_sig,[],[],[],framerate);

glob_power.isa=trapz(hz(start_freq.isa:end_freq.isa),global_for(start_freq.isa:end_freq.isa));
glob_power.delta=trapz(hz(start_freq.delta:end_freq.delta),global_for(start_freq.delta:end_freq.delta));
glob_power.full=trapz(hz(start_freq.full:end_freq.full),global_for(start_freq.full:end_freq.full));


Seed_names={'olf','fr','cing','m','ss','rs','p','vis','aud','ass'};
region_power.isa=zeros(size(Seed_names));
region_power.delta=zeros(size(Seed_names));
region_power.full=zeros(size(Seed_names));

%Regional Power
for i=1:size(Seed_names,2)
reg_data= data.*(AtlasSeeds_Big==i);
reg_sig=mean(reshape(reg_data,[size(reg_data,1)*size(reg_data,2),size(reg_data,3)]),1,'omitnan');
[reg_for,hz]=pwelch(reg_sig,[],[],[],framerate);

region_power.isa(i)=trapz(hz(start_freq.isa:end_freq.isa),reg_for(start_freq.isa:end_freq.isa));
region_power.delta(i)=trapz(hz(start_freq.delta:end_freq.delta),reg_for(start_freq.delta:end_freq.delta));
region_power.full(i)=trapz(hz(start_freq.full:end_freq.full),reg_for(start_freq.full:end_freq.full));


end


end

