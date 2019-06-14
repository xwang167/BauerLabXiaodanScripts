function [fcMap,fcMatrix,fftMap,refseeds]= calculateRRsfftMap(species,speciesName,xform_isbrain,framerate,bandRange,nVx,nVy)


species(isnan(species)) = 0;
disp('Calculating fft map');
if isempty(bandRange)
    dataBandpass= species;
else
disp(['filtering ', speciesName, ' with ', num2str(bandRange)])


dataBandpass = zeros(size(species));
for kk = 1:nVy
    for ll=1:nVx
        dataBandpass(kk,ll,:) =highpass(double(species(kk,ll,:)),bandRange(1),framerate);
        dataBandpass(kk,ll,:)=lowpass(double(dataBandpass(kk,ll,:)),bandRange(2),framerate);
    end
end
end
fftMap = zeros(nVy,nVx);
        species = reshape(species,nVy*nVy,[]);
            species = species';
            [Pxx,hz] = pwelch(species,[],[],[],framerate);

            Pxx = Pxx';
            Pxx = reshape(Pxx,nVy,nVx,[]);
           
            if ~isempty(bandRange)
            [~,startLoc]=min(abs(hz-bandRange(1)));

  [~,endLoc]=min(abs(hz-bandRange(2)));
            end
            
            
            for kk = 1:nVy
                for ll=1:nVx
                    if isempty(bandRange)
                         fftMap(kk,ll)= sum(Pxx(kk,ll,:));
                    else
                    fftMap(kk,ll)= sum(Pxx(kk,ll,(startLoc: endLoc)));
                    end
                end
            end
        


clear species

dataBandpass(isnan(dataBandpass)) = 0;
disp('gsr');
dataBandpass = single(dataBandpass);
dataBandpass = mouse.preprocess.gsr(dataBandpass,xform_isbrain);
dataBandpass = dataBandpass.*xform_isbrain;

dataBandpass =reshape(dataBandpass,nVy*nVx,[]);
dataBandpass(isnan(dataBandpass))= 0;
disp('Calculating R Rs')
refseeds=GetReferenceSeeds;
refseeds = refseeds(1:14,:);

for n=1:2:size(refseeds,1)-1;
    if xform_isbrain(refseeds(n,2),refseeds(n,1))==1 && xform_isbrain(refseeds(n+1,2),refseeds(n+1,1))==1;  %%remove 129- on y coordinate for newer data sets
        SeedsUsed(n,:)=refseeds(n,:);
        SeedsUsed(n+1,:)=refseeds(n+1,:);
    else
        SeedsUsed(n,:)=[NaN, NaN];
        SeedsUsed(n+1,:)=[NaN, NaN];
    end
end
mm=10;
mpp=mm/nVx;
seedradmm=0.25;
seedradpix=seedradmm/mpp;

P=burnseeds(SeedsUsed,seedradpix,xform_isbrain);          % make a mask of seed locations

strace=P2strace(P,dataBandpass,SeedsUsed);              % strace is each seeds trace resulting from averaging the pixels within a seed region

fcMap = strace2R(strace,dataBandpass,nVx, nVy);               % R is the functional connectivity maps: normalize rows in time, dot product of those rows with strce
R_AP = makeRs( dataBandpass ,strace);                    % R_AP is a matrix of the seed-to-seed fc values
clear dataBandpass


length_seeds=size(SeedsUsed,1);                           %reorder so bilateral connectivity values are on the off-diagonal
map=[(1:2:length_seeds-1) (2:2:length_seeds)];

idx=find(isnan(SeedsUsed(:,1)));
fcMap(:,:,idx)=0;
R_AP(idx, idx)=0;
fcMatrix = R_AP(map, map);















