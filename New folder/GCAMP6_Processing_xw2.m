function GCAMP6_Processing()

%remember to uncomment the filtering if you want to filter
%This script runs assuming you already created a mask and seeds

    clear functions mex; clf; cla; close all;
    
    %Qc is a structure containing info to read in raw data.
    %MouseDay relates to the order that a mouse was imaged that day. MouseNum
    %is whatever naming convention/label you use to identify a mouse. Runs are
    %specific 5min imaging session .tifs you want to look at
% qc=struct('Date',{'171107','171107','171107'},...
%           'MouseDay', {'a','a','a'},...
%           'MouseNum', {'140404_1f','140404_2f_P15','140404_2m_P15'},...
%           'Runs', {[1:6],[1:4],[1:4]}); 
qc=struct('Date',{'181031'},...
          'MouseDay', {'a'},...
          'MouseNum', {'GcampM2'},...
          'Runs', {[1:3]});     
%     
% qc=struct('Date',{'170531','170531','170602','170602','170603','170603','170603','170603','170603','170604','170605','170605','170605','170606','170606','170606','170606','170607','170611','170612','170825','170825','170825','170825','170825'},...
%           'MouseDay', {'a','a','a','a','a','a','a','a','1','1','a','a','a','a','a','a','a','a','a','a','a','a','a','a','1'},...
%           'MouseNum', {'SSRIc040617_1_5','SSRIc040617_3_4','SSRIc040617_2_1','SSRIc040617_4_1','SSRIc040617_1_2','SSRIc040617_2_2','SSRIc040617_2_4','SSRIc040617_3_1','SSRIc040617_4_2','SSRIc040617_1_4','SSRIc040617_2_5','SSRIc040617_2_6','SSRIc040617_3_2','SSRIc040617_1_3','SSRIc040617_2_3','SSRIc040617_3_3','SSRIc040617_4_3','SSRIc040617_3_5','SSRIc040617_1_4','SSRIc040617_2_6','SSRIc040617_1_1','SSRIc040617_3_1','SSRIc040617_4_2','SSRIc040617_4_4','SSRIc040617_7_1'},...
%           'Runs', {[1:6],[1:6],[1:6],[1:6],[1:6],[1:6],[1:6],[1:6],[1:6],[1:6],[1:6],[1:6],[1:6],[1:6],[1:6],[1:6],[1:6],[1:6],[1:6],[1:6],[1:6],[1:6],[1:6],[1:6],[1:6]});  
% %     qc=struct('Date',{'170604','170605','170605','170605','170606','170606','170606','170606'},...
%           'MouseDay', {'a','a','a','a','a','a','a','1'},...
%           'MouseNum', {'SSRIc040617_1_4','SSRIc040617_2_5','SSRIc040617_2_6','SSRIc040617_3_2','SSRIc040617_1_3','SSRIc040617_2_3','SSRIc040617_3_3','SSRIc040617_4_3'},...
%           'Runs', {[1:6]});   

%     qc=struct('Date',{'170602','170602','170603','170603','170603','170603','170603'},...
%           'MouseDay', {'a','a','a','a','a','a','a'},...
%           'MouseNum', {'SSRIc040617_2_1','SSRIc040617_4_1','SSRIc040617_1_2','SSRIc040617_2_2','SSRIc040617_2_4','SSRIc040617_3_1','SSRIc040617_4_2'},...
%           'Runs', {[1:6]}); 

      %everything processed 11/13
      % qc=struct('Date',{'170622','170622','170628','170628','170628','170628','170701','170705','170705','170708','170708','170714','170714','170714','170714','170821','170821','170821','170821','170822'},...
%           'MouseDay', {'etc','a','a','a','a','a','a','a','a','1','a','a','a','a','a','a','a','a','a','a'},...
%           'MouseNum', {'9309-1_P22','9309-2_P22','9365-2_P35','9365-4_P35','9309-1_P28','9309-2_P28','9511-10_P15','9309-1_P35','9309-2_P35','9511-2_P22','9511-5_P22','9510-1_P22','9510-2_P22','9510-5_P22','9510-7_P22','9510-1_P60','9510-2_P60','9510-3_P60','9510-5_P60','9511-2_P67'},...
%           'Runs', {[1:3],[1:6],[1:6],[1:6],[1:6],[1:5],[5:6],[1:4],[1:6],[1:4],[1:3],[1:6],[1:4],[1:4],[1:4],[1:6],[1:6],[1:6],[1:6],[1:6]});  

      
%      qc=struct('Date',{'151215'},...%,'151215','151216','151216','151217','151217','151217'},...
%           'MouseDay', {'Ms1'},...%,'Ms2','Ms1','Ms2','Ms1','Ms2','Ms3'},...
%           'pms', {'Ms1'},...%,'Ms2','Ms3','Ms4','Ms5','Ms6','Ms7'},...
%           'Runs', {[1:3]});%,[1:3], [1:3],[1:3],[1:3],[1:3],[1:3]});   
      
%     qc=struct('Date',{'150630','150630'},...
%         'MouseDay', {'Ms1','Ms3'},...
%         'MouseNum', {'Ms1','Ms3'},...
%         'Runs', {([4 6]), ([4 6])});
    
 for i=1:length(qc)      
      
date=qc(i).Date;
msd=qc(i).MouseDay;
%mousenum=qc(i).pms;
mousenum=qc(i).MouseNum;
runs=qc(i).Runs;

    path=['\\10.39.168.176\RawData_East3410\' date '\' date '-' mousenum];
    dark=single(zeros(128,128));;     %Xiaodan                                                    
    %mask=imread(['H:\DATA\' date '\' msd '\Data\' 'Mask' '-' date '-' msd '.tif']);
    GetLandMarksandMask_xw(date, mousenum, 'D:\ProcessedData\181031\', '\\10.39.168.176\RawData_East3410\181031\', 'EastOIS1_Fluor')%Xiaodan
    load(strcat('D:\ProcessedData\181031\', date,'-', mousenum,'-LandmarksandMask.mat'),'isbrain','seeds');%Xiaodan
    %Make binary mask (brain VS non-brain

 
    for n=min(runs):max(runs)
        disp('Mouse');  mousenum 
        disp('Run'); n
        clear functions mex; clf; cla; close all;
        
        %Construct string associated with specific filenames. Update drive path
        %run=[date,'_GCAMP_',msd,'_',mousenum,'_fc',num2str(n)];
        %filename=['H:\DATA\' date '\' msd '\' date '-GCAMP6' mousenum '-AnestStim-fc' num2str(n) '.tif'];
        filename=[path '-stim' num2str(n) '.tif'];
               
        %Framerate and numled are acquiistion parameters. Lowpass/highpass are
        %filtering over a frequency band of interest
        info.framerate=16.81; %19.61;
        info.numled=4;
        info.lowpass=.5; %.08-4 for int %0.4-4.0 for delta %-.08-0.009 for infraslow
        info.highpass=0.009;
         %info.lowpass=6.0;
%         info.highpass=0.01;
%         info.lowpass=3.0; %Use these for Delta
%         info.highpass=0.7;
%remember to uncomment the filtering if you want to filter in ProcPixel(2)
       
        
        
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
        for z=1:L2
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

         
  
        %Detrend varying light levels both spatially (uneven light levels across the
        %image) and temporally (light levels drift up or down over the duration of
        %the run)
        [nVx,nVy,C,T]=size(rawdata); %nVx and nVy are 128 x * 128 y pixels, C is 4 color channels, T is time
        
    % New De-trending test: linear temporal de-trend by pixel, followed by spatial detrend
    
    rawdata_rs = reshape(rawdata,nVy*nVx*C,T); %Reshape to apply matlab detrend function
    %C is the number of pixels, 128*128
    
    warning('Off');
    
    timetrend = single(zeros(size(rawdata_rs))); %initializing
    
    for ii=1:size(rawdata_rs,1)
        timetrend(ii,:)=polyval(polyfit(1:T, rawdata_rs(ii,:), 4), 1:T); %This is doing a 4th order fit (polyfit), then evaluating at each time (polyval)
    end
    
    warning('On');
    timetrend = reshape(timetrend,nVy,nVx,C,T); %Pixel-wise fits
    timedetrend=bsxfun(@rdivide,rawdata,timetrend);
    
    spattrend=bsxfun(@rdivide,mean(timedetrend,4),mean(mean(mean(timedetrend,4))));
    fulldetrend_ini=bsxfun(@rdivide,timedetrend,spattrend);
    
    [fulldetrend, W, WL2, isbrain2]= Affine_gcamp6_xw(date, fulldetrend_ini, WL, isbrain, path, seeds); %Xiaodan 
    
    
              
        %Separate data into different channels. Rawdata is data from the green, yellow, and
        %red LEDs to be used to do oximetry. GCAMP6 is the raw fluorescence
        %emission channel. Green is the green channel on its own (used for the
        %ratiometric fluroescence correction to remove hemodynamic confound)
        rawdata=fulldetrend(:,:,2:4,:);
        gcamp6=double(squeeze(fulldetrend(:,:,1,:)));
        green=double(squeeze(fulldetrend(:,:,2,:)));
        
        
        %Initializing
        data_dot=zeros(128,128,2,length(rawdata));
        gcamp6norm=zeros(128,128,length(gcamp6));
        greennorm=zeros(128,128,length(green));
        
        
        
        
        %Ratiometric correction (mean normalization first, then ratio of gcamp to
        %green)
        for x=1:128
            for y=1:128
                gcamp6norm(x,y,:)=gcamp6(x,y,:)/mean(gcamp6(x,y,:));
                greennorm(x,y,:)=green(x,y,:)/mean(green(x,y,:));              
            end
        end
        

        %gcamp6ratiocorr=gcamp6norm./greennorm;%gcamp6corr is the ratiometric gcamp6
        %fluorescence signal corrected for the hemodynamic confound OLD WAY

        %"Process" the data--procPixel used for filtering and oximetry
        info.T1=size(rawdata,4);
        
        info.numled=3;
       
        disp('Processing Pixels')
        
        xsize=info.nVx;
        ysize=info.nVy;
        
        %Ex-Em hemodynamic correction 
        for x=1:xsize
            for y=1:ysize
                
                [data_dot(y,x,:,:)]=procPixel(squeeze(rawdata(y,x,:,:)),op, E, info);
                bluemua_init(y,x,1,:)=op.blueLEDextcoeff(1)*data_dot(y,x,1,:);
                bluemua_init(y,x,2,:)=op.blueLEDextcoeff(2)*data_dot(y,x,2,:);
                bluemua_f(y,x,:)=bluemua_init(y,x,1,:)+bluemua_init(y,x,2,:);
                greenmua_init(y,x,1,:)=op.greenLEDextcoeff(1)*data_dot(y,x,1,:);
                greenmua_init(y,x,2,:)=op.greenLEDextcoeff(2)*data_dot(y,x,2,:);
                greenmua_f(y,x,:)=greenmua_init(y,x,1,:)+greenmua_init(y,x,2,:);
                
                gcamp6corr(y,x,:)=gcamp6norm(y,x,:)./(exp(-(bluemua_f(y,x,:).*(.056)+greenmua_f(y,x,:).*(.057))));
                %e(y,x,:)=(exp(-(bluemua_f(y,x,:).*(.056)+greenmua_f(y,x,:).*(.057))));
                %%e is correction factor
                
                gcamp6corr(y,x,:)=procPixel2(squeeze(gcamp6corr(y,x,:))',op,E,info);
                %gcamp6ratiocorr(y,x,:)=procPixel2(squeeze(gcamp6ratiocorr(y,x,:))',op,E,info);
                gcamp6(y,x,:)=procPixel2(squeeze(gcamp6norm(y,x,:))',op,E,info);
                green(y,x,:)=procPixel2(squeeze(green(y,x,:))',op,E,info);
            end
        end
        
        data_dot(isnan(data_dot))=0;
        gcamp6corr(isnan(gcamp6corr))=0;
        %gcamp6ratiocorr(isnan(gcamp6ratiocorr))=0;
        gcamp6(isnan(gcamp6))=0;
        green(isnan(green))=0;
        
        data_dot(isinf(data_dot))=0;
        gcamp6corr(isinf(gcamp6corr))=0;
        %gcamp6ratiocorr(isinf(gcamp6ratiocorr))=0;
        gcamp6(isinf(gcamp6))=0;
        green(isinf(green))=0; 
        
        %Spatial smoothing
        data_dot=smoothimage(data_dot,5,1.2);
        gcamp6corr=smoothimage(gcamp6corr,5,1.2);
        %gcamp6ratiocorr=smoothimage(gcamp6ratiocorr,5,1.2);
        gcamp6=smoothimage(gcamp6,5,1.2);
        green=smoothimage(green,5,1.2);
        
        
        
        %Global signal regression (regress the mean time series across the brain from all time
        %series)
        [oxy deoxy]=gsr_stroke3(data_dot, isbrain2);                                             
        
        gcamp6all=permute(cat(4,gcamp6corr, gcamp6), [1 2 4 3]);
        %gcamp6ratioall=permute(cat(4,gcamp6ratiocorr, gcamp6), [1 2 4 3]);
        
        gcamp6all=gsr_stroke2(gcamp6all, isbrain2);
        %gcamp6ratioall=gsr_stroke2(gcamp6ratioall, isbrain2);
        
        green=gsr_strokegreen(green, isbrain2);
        
        
        %Save the data
        %path2='C:\Data\';
      
        
        save(['D:\ProcessedData\' date '\' date '-' mousenum '-stim' num2str(n) '-Affine_GSR_NewDetrend'],'-v7.3','oxy','deoxy','gcamp6all','green','isbrain2', 'WL2','info','gcamp6','isbrain');
        
        
        clear oxy deoxy gcamp6all fulldetrend fulldetrend2 isbrain2 WL WL2 rawdata rawdata2 gcamp6all...
           green gcamp6 data_dot timedetrend timetrend spattrend; clf; cla; close all;
       % q=q+1;
%end
    end
 end
end %end of n loop

%% getoisdata()
function [data]=getoisdata(fileall)

[filepath,filename,filetype]=interppathstr(fileall);
%assignin('base','path',filepath); assignin('base','name',filename); return

if ~isempty(filetype) && ~(strcmp(filetype,'tif') || strcmp(filetype,'sif') )
    error('** procOIS() only supports the loading of .tif and .sif files **')
else
    if exist([filepath,'\',filename,'.tif'])
        data=readtiff([filepath,'\',filename,'.tif']);
    elseif exist([filepath,'\',filename,'.sif'])
        data=readsif([filepath,'\',filename,'.sif']);
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

%% smoothimage()
function [data2]=smoothimage(data,gbox,gsigma)

[nVy, nVx, cnum, T]=size(data);

%Gaussian box filter center
x0=ceil(gbox/2);
y0=ceil(gbox/2);

%Make Gaussian filter
G=zeros(gbox);
for x=1:gbox
    for y=1:gbox
        G(x,y)=exp((-(x-x0)^2-(y-y0)^2)/(2*gsigma^2));
    end
end

%Normalize Gaussian to 1
G=G/sum(sum(G));

%Initialize
data2=zeros(nVx,nVy,cnum,T);

%Convolve data with filter
for c=1:cnum
    for t=1:T
        data2(:,:,c,t)=conv2(squeeze(data(:,:,c,t)),G,'same');
    end
end

end


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
    
    %if n==1 || n==2 || n==3
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
    %end

end
    op.blueLEDextcoeff(1)=Hb(103,1);%*led{n}.ledpower; 454nm
    op.blueLEDextcoeff(2)=Hb(103,2);
    op.greenLEDextcoeff(1)=Hb(132,1);%*led{n}.ledpower; 512nm
    op.greenLEDextcoeff(2)=Hb(132,2);

end


function [lambda Hb]=getHb

data=dlmread('D:\OIS_Process\OIS\Spectroscopy\prahl_extinct_coef.txt');

lambda=data(:,1);
c=log(10)/10^3; % convert: (1) base-10 to base-e and (2) M^-1 to mM^-1
Hb=c*squeeze(data(:,2:3));
%Hb=squeeze(data(:,2:3));

end

%% getLED()
function [led, lambda]=getLED


led{1}.name='D:\OIS_Process\OIS\Spectroscopy\LED Spectra\TL530nm_pol';
led{2}.name='D:\OIS_Process\OIS\Spectroscopy\LED Spectra\East3410OIS1_TL_617_Pol';
led{3}.name='D:\OIS_Process\OIS\Spectroscopy\LED Spectra\East3410OIS1_TL_625_Pol';

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

%% procPixel()

function [data_dot]=procPixel(data,op,E,info)


% disp('Rytov and DPFs')

data=logmean(data);

for c=1:info.numled
    data(c,:)=squeeze(data(c,:))/op.dpf(c);
    %data_dot(c,:)=squeeze(data(c,:))/op.dpf(c);
end
% 
% 
[data]=highpass(data,info.highpass,info.framerate); %UNCOMMENT TO FILTER
% %NEXT LINE TOO
[data]=lowpass(data,info.lowpass,info.framerate);


data_dot=dotspect(data,E(1:3,:));

end


function [data2]=procPixel2(data,op,E,info)


%disp('Rytov and DPFs')
data=logmean_gcamp3(data);

[data]=highpass(data,info.highpass,info.framerate);
[data2]=lowpass(data,info.lowpass,info.framerate); %uNCOMMENT PLUS ^ TO
%FILTER
%data2=data; %LEAVE THIS COMMENTED

end




%% gsr_OIS
function [datahb2]=gsr_stroke2(datahb,bimask)

[nVx nVy hb T]=size(datahb);

datahb=reshape(datahb,nVx*nVy,hb,T);
gs=squeeze(mean(datahb(bimask==1,:,:),1));
[datahb2 Rgs]=regcorr(datahb,gs);
datahb2=reshape(datahb2,nVx, nVy, hb, T);
        
end


%% gsr_OIS
function [datahb2]=gsr_strokegreen(datahb,bimask)

[nVx nVy T]=size(datahb);

datahb=reshape(datahb,nVx*nVy,1,T);
gs=squeeze(mean(datahb(bimask==1,:,:),1));
[datahb2 Rgs]=regcorr(datahb,gs);
datahb2=reshape(datahb2,nVx, nVy, T);
        
end


function [Oxy_gsr DeOxy_gsr]=gsr_stroke3(datahb,bimask)

[nVx nVy hb T]=size(datahb);

datahb=reshape(datahb,nVx*nVy,hb,T);
gs=squeeze(mean(datahb(bimask==1,:,:),1));
[datahb2 Rgs]=regcorr(datahb,gs);
datahb2=reshape(datahb2,nVx, nVy, hb, T);
Oxy_gsr=squeeze(datahb2(:,:,1,:));
DeOxy_gsr=squeeze(datahb2(:,:,2,:));
        
end

%% gsr_OIS
function [datahb2]=gsr_stroke4(datahb,bimask)

[nVx nVy T]=size(datahb);

datahb=reshape(datahb,nVx*nVy,T);
gs=squeeze(mean(datahb(bimask==1,:),1));
[datahb2 Rgs]=regcorr(datahb,gs);
datahb2=reshape(datahb2,nVx, nVy, T);
        
end