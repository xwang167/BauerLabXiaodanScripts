function makeSeeds()%qc)

% qc=struct('Date',{'160919','160919','160919'},...
%         'MouseDay', {'2','4','5'},...
%         'ms',{'Ms2','Ms4','Ms5'},...
%         'MouseNum', {'awake','awake','awake'},...
%         'Runs', {(1:12),(1:12),(1:12)});
%     qc=struct('Date',{'170607','170611','170612','170825','170825','170825','170825','170825'},...
%           'MouseDay', {'a','a','a','a','a','a','1','1'},...
%           'MouseNum', {'SSRIc040617_3_5','SSRIc040617_1_4','SSRIc040617_2_6','SSRIc040617_1_1','SSRIc040617_3_1','SSRIc040617_4_2','SSRIc040617_4_4','SSRIc040617_7_1'},...
%           'Runs', {[1:6]});  
    qc=struct('Date',{'180102','180102'},...
          'MouseDay', {'a','a'},...
          'MouseNum', {'180102-Mouse1','180102-Mouse3'},...
          'Runs', {[1:6]});    
%'SSRIc040617_1_5','SSRIc040617_3_4' 170531
%     qc=struct('Date',{'170602','170602','170603','170603','170603','170603','170603'},...
%           'MouseDay', {'a','a','a','a','a','a','a'},...
%           'MouseNum', {'SSRIc040617_2_1','SSRIc040617_4_1','SSRIc040617_1_2','SSRIc040617_2_2','SSRIc040617_2_4','SSRIc040617_3_1','SSRIc040617_4_2'},...
%           'Runs', {[1:6]});  

for i=1:length(qc); %number of mice as defined in the below struct
    
    clear functions mex; clf; cla; close all;
    
    date=qc(i).Date;
    mousenum=qc(i).MouseNum;
    %msd=qc(i).ms;
    
    %Read in mask (made in photoshop; non-brain pixels are erased from image). Update drive path
    mask=imread(['Z:\Rachel\Rachel_fcOIS\OIS3\' date '\' date '-' mousenum '_mask.tif']);
    dark=single(imread('Dark.tif'));
    
    
    
    %Make binary mask (brain VS non-brain
    for x=1:128
        for y=1:128
            
            if mask(x,y)<255
                isbrain(x,y)=0;
            else
                isbrain(x,y)=1;
            end
            
        end
    end
    
    
   % for n=qc(i).Runs;
   %     disp('Mouse');  mouse
   %     disp('Run'); n
   %     clear functions mex; clf; cla; close all;
        
        %Construct string associated with specific filenames. Update drive path
        run=[date,'-',mousenum,'-stim1'];
        filename=['Z:\Rachel\Rachel_fcOIS\OIS3\' date '\mask.tif']; %1/5 temp fix
        
        
        
        %Framerate and numled are acquiistion parameters. Lowpass/highpass are
        %filtering over a frequency band of interest
        info.framerate=16.81; %19.61
        info.numled=4;
        info.lowpass=4;
        info.highpass=0.4;
        %remember to uncomment the filtering if you want to filter
        
        
        
        %Get optical properties (Extinction/absorption coefficients, etc)
        disp('Getting Optical Properties')
        [op, E]=getop;
        
        
        
        %Load raw data (.tif)
        disp('Loading Data')
        [rawdata]=getoisdata(filename);
        
        rawdata=double(rawdata);
        
        [nVy, nVx, L]=size(rawdata);
        L2=L-rem(L,info.numled);
        rawdata=rawdata(:,:,1:L2);
        info.nVx=nVx;
        info.nVy=nVy;
        
        
        
        %Subtract dark/background frame (ie no lights)
        for z=1:L2;
            raw(:,:,z)=abs(rawdata(:,:,z)-dark);
        end
        
        
        
        %Reshape the data, adding a dimension for individiual LED channels
        rawdata=reshape(raw,info.nVy,info.nVx,info.numled,[]);
        
        
        
        % Cut off bad first set of frames
        rawdata=rawdata(:,:,:,2:end);
        
        
        
        %Make white light image ("normal"-looking picture of the skull)
        frameone=double(rawdata(:,:,:,2));
        WL(:,:,1)=frameone(:,:,2)/max(max(frameone(:,:,2)));
        WL(:,:,2)=frameone(:,:,3)/max(max(frameone(:,:,3)));
        WL(:,:,3)=frameone(:,:,4)/max(max(frameone(:,:,4)));
        
        
%        if exist(['/data/culver/data1/Lindsey/data/Anesthesia/',date,'/',msd,'/',date,'_',msd,'_seeds.mat'],'file')
            %seeds file already file exists, do nothing
%        else
            %         WL(:,:,1)=WL(:,:,1)/255;
            %         WL(:,:,2)=WL(:,:,2)/255;
            %         WL(:,:,3)=WL(:,:,3)/255;
            %
            %assignin('base','WL',WL); return
            
            %create seeds once for each mouse
            
            [seeds_init seedcenter]=MakeSeedsMouseSpace_Lindsey(WL);
            save(['Z:\Rachel\Rachel_fcOIS\OIS3\' date '\' date '-' mousenum '_seeds.mat'],'seeds_init', 'seedcenter');
            
            figure
            imagesc(WL); %changed 3/1/1
            axis off
            axis image
            title('White Light Image');

  
for f=1:size(seedcenter,1)
    hold on;
    plot(seedcenter(f,1),seedcenter(f,2),'ko','MarkerFaceColor','k')
end
            
       
        
        
 
end %end of i loop
end %function

%% getop()
function [op, E, numled, led]=getop

[lambda1, Hb]=getHb;
[led,lambda2]=getLED;
   
op.HbT=76*10^-3; % uM concentration
op.sO2=0.71; % Oxygen saturation (%/100)
op.BV=0.1; % blood volume (%/100)

op.nin=1.4; % Internal Index of Refraction
op.nout=1; % External Index of Refraction
op.c=3e10/op.nin; % Speed of Light in the Medium
op.musp=10; % Reduced Scattering Coefficient

numled=size(led,2);


for n=1:numled
    
    % Interpolate from Spectrometer Wavelengths to Reference Wavelengths
    led{n}.ledpower=interp1(lambda2,led{n}.spectrum,lambda1,'pchip');
    
    % Normalize
    led{n}.ledpower=led{n}.ledpower/max(led{n}.ledpower);
    
    % Zero Out Noise
    led{n}.ledpower(led{n}.ledpower<0.01)=0;
    
    % Normalize
    led{n}.ledpower=led{n}.ledpower/sum(led{n}.ledpower);
    
    % Absorption Coeff.
    op.mua(n)=sum((Hb(:,1)*op.HbT*op.sO2+Hb(:,2)*op.HbT*(1-op.sO2)).*led{n}.ledpower);
    
    % Diffusion Coefficient
    op.gamma(n)=sqrt(op.c)/sqrt(3*(op.mua(n)+op.musp));
    op.dc(n)=1/(3*(op.mua(n)+op.musp));
    
    % Spectroscopy Matrix
    E(n,1)=sum(Hb(:,1).*led{n}.ledpower);
    E(n,2)=sum(Hb(:,2).*led{n}.ledpower);
    %assignin('base','E',E); return
    
    % Differential Pathlength Factors
    op.dpf(n)=(op.c/op.musp)*(1/(2*op.gamma(n)*sqrt(op.mua(n)*op.c)))*(1+(3/op.c)*op.mua(n)*op.gamma(n)^2);
end


end

function [lambda Hb]=getHb

data=dlmread('prahl_extinct_coef.txt');

lambda=data(:,1);
c=log(10)/10^3; % convert: (1) base-10 to base-e and (2) M^-1 to mM^-1
Hb=c*squeeze(data(:,2:3));

end

%% getLED()
function [led, lambda]=getLED


led{1}.name='131029_Mightex_530nm_NoBPFilter';
led{2}.name='140801_ThorLabs_590nm_NoPol'; 
led{3}.name='140801_ThorLabs_625nm_NoPol';  

numled=size(led,2);

%Read in LED spectra data from included text files
for n=1:numled
    

        fid=fopen([led{n}.name, '.txt']);
        temp=textscan(fid,'%f %f','headerlines',17);
        fclose(fid);
        lambda=temp{1};
        led{n}.spectrum=temp{2};
  
end

end

%% getoisdata()
function [data]=getoisdata(fileall)

[filepath,filename,filetype]=interppathstr(fileall);

if ~isempty(filetype) && ~(strcmp(filetype,'tif') || strcmp(filetype,'sif') )
    error('** procOIS() only supports the loading of .tif and .sif files **')
else
    if exist([filepath,filename,'.tif'])
        data=readtiff([filepath,'/',filename,'.tif']);
    elseif exist([filepath,'/',filename,'.sif'])
        data=readsif([filepath,'/',filename,'.sif']);
    end
end

end

%% readtiff()
function [data]=readtiff(filename)

info = imfinfo(filename);
numI = numel(info);
data=zeros(info(1).Width,info(1).Height,numI,'uint16');
fid=fopen(filename);

fseek(fid,info(1).Offset,'bof');
for k = 1:numI
    
    fseek(fid,[info(1,1).StripOffsets(1)-info(1).Offset],'cof');    
    tempdata=fread(fid,info(1).Width*info(1).Height,'uint16');
    data(:,:,k) = rot90((reshape(tempdata,info(1).Width,info(1).Height)),-1); %% changed 3/2/11
end

fclose(fid);

end