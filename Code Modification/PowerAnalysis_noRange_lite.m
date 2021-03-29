function [powerMap,glob_power,region_power,Seed_names]= PowerAnalysis_noRange_lite(data,framerate)
load('AtlasandIsbrain')
nVy = size(data,1);
nVx = size(data,2);
data(isnan(data)) = 0;
data1 = transpose(reshape(data,nVx*nVy,[]));
[Pxx,hz] = pwelch(data1,[],[],[],framerate); %returns 128*128
Pxx = Pxx';
Pxx = reshape(Pxx,[],size(Pxx,3));
Pxx = reshape(Pxx,nVy,nVx,[]);

freqRange= {[0.009,0.08],[0.4,4],[0,10]};


 [~,start_freq.isa]=min(abs(hz-freqRange{1}(1))); %This is finding closest value to the cutoff frequencies
 [~,end_freq.isa]=min(abs(hz-freqRange{1}(2)));
 
 [~,start_freq.delta]=min(abs(hz-freqRange{2}(1))); %This is finding closest value to the cutoff frequencies
 [~,end_freq.delta]=min(abs(hz-freqRange{2}(2)));
 
 [~,start_freq.full]=min(abs(hz-freqRange{3}(1))); %This is finding closest value to the cutoff frequencies
 [~,end_freq.full]=min(abs(hz-freqRange{3}(2)));
 
 powerMap = zeros(nVy,nVx,3);


for kk = 1:nVy
    for ll=1:nVx
        powerMap(kk,ll,2) = (hz(2)-hz(1))*sum(Pxx(kk,ll,start_freq.isa: end_freq.isa))/(end_freq.isa-start_freq.isa);
        powerMap(kk,ll,3) = (hz(2)-hz(1))*sum(Pxx(kk,ll,start_freq.delta: end_freq.delta))/(end_freq.delta-start_freq.delta);
        powerMap(kk,ll,1) = (hz(2)-hz(1))*sum(Pxx(kk,ll,start_freq.full: end_freq.full))/(end_freq.full-start_freq.full);
    end
end


%Global Power
glob_sig=mean(reshape(data,[size(data,1)*size(data,2),size(data,3)]),1,'omitnan');
[global_for,hz]=pwelch(glob_sig,[],[],[],framerate);
glob_power=nan(1,3);
glob_power(:,2)=trapz(hz(start_freq.isa:end_freq.isa),global_for(start_freq.isa:end_freq.isa));
glob_power(:,3)=trapz(hz(start_freq.delta:end_freq.delta),global_for(start_freq.delta:end_freq.delta));
glob_power(:,1)=trapz(hz(start_freq.full:end_freq.full),global_for(start_freq.full:end_freq.full));


Seed_names={'olf','fr','cing','m','ss','rs','p','vis','aud','ass'};
region_power=zeros(length(Seed_names),3);
;

%Regional Power
for i=1:size(Seed_names,2)
reg_data= data.*(AtlasSeeds_Big==i);
reg_sig=mean(reshape(reg_data,[size(reg_data,1)*size(reg_data,2),size(reg_data,3)]),1,'omitnan');
[reg_for,hz]=pwelch(reg_sig,[],[],[],framerate);

region_power(i,2)=trapz(hz(start_freq.isa:end_freq.isa),reg_for(start_freq.isa:end_freq.isa));
region_power(i,3)=trapz(hz(start_freq.delta:end_freq.delta),reg_for(start_freq.delta:end_freq.delta));
region_power(i,1)=trapz(hz(start_freq.full:end_freq.full),reg_for(start_freq.full:end_freq.full));


end


end

