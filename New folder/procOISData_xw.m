function [datahb, WL, op, E, info] = procOISData(filename, info, system)

% (c) 2009 Washington University in St. Louis
% All Rights Reserved

% output variable explanation:
% datahb: processed rawdata reduced to hemoglobin
% WL: White Light Image (used the Red, Yellow, and Blue raw data channels
% op: Optical Properties specified for tissue
% E: Spectroscopy matrix (The extinction coefficient of each hemoglobin species for each wavelength
% info: Information about the parameters used to process the raw data,
% e.g., framerate, filters, number of LEDs used, resampling frequency, etc.

% (c) 2009 Washington University in St. Louis
% All Right Reserved
%
% Licensed under the Apache License, Version 2.0 (the "License");
% You may not use this file except in compliance with the License.
% A copy of the License is available is with the distribution and can also
% be found at:
%
% http://www.apache.org/licenses/LICENSE-2.0
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
% IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
% PURPOSE, OR THAT THE USE OF THE SOFTWARD WILL NOT INFRINGE ANY PATENT
% COPYRIGHT, TRADEMARK, OR OTHER PROPRIETARY RIGHTS ARE DISCLAIMED. IN NO
% EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
% OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
% HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
% STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
% ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.

%% Get Optical Properties
disp('Getting Optical Properties')
info.system=system;
[op, E, numled, led, Hb]=getop_system(system);
info.numled=numled;
info.hb=size(Hb,2);

%% Load in raw data collected from camera and process
% Note: data are saved as .tif files
disp('Loading Data')

[rawdata]=readtiff(filename);


rawdata=single(rawdata);

[nVy, nVx, L]=size(rawdata); % Andor saves data as pixels by time (y direction by X direction by time)
info.nVx=nVx;
info.nVy=nVy;

R=mod(L,info.numled);
if R~=0
    rawdata=rawdata(:,:,1:(L-R));
    disp(['** ',num2str(info.numled-R),' frames were dropped **'])
end

rawdata=reshape(rawdata,info.nVx,info.nVy,info.numled,[]);
rawdata=rawdata(:,:,:,2:end); % cut off bad first set of frames
info.T1=size(rawdata,4);

testpixel=resampledata(double(squeeze(rawdata(1,1,:,:))),info.framerate,info.freqout,10^-5);
info.T2=size(testpixel,2); clear testpixel  % calculate image series length (in time) after resampling

frameone=double(rawdata(:,:,:,1));
if strcmp(system, 'fcOIS1')
    WL(:,:,1)=frameone(:,:,1)/max(max(frameone(:,:,1))); % red
    WL(:,:,2)=frameone(:,:,3)/max(max(frameone(:,:,3))); % yellow
    WL(:,:,3)=frameone(:,:,4)/max(max(frameone(:,:,4))); % blue
elseif strcmp(system, 'fcOIS2')||strcmp(system, 'EastOIS1')
    WL(:,:,1)=frameone(:,:,4)/max(max(frameone(:,:,4))); % red
    WL(:,:,2)=frameone(:,:,2)/max(max(frameone(:,:,2))); % yellow/green
    WL(:,:,3)=frameone(:,:,1)/max(max(frameone(:,:,1))); % blue
    
elseif strcmp(system, 'fcOIS2_Fluor')
    WL(:,:,1)=frameone(:,:,4)/max(max(frameone(:,:,4))); % red
    WL(:,:,2)=frameone(:,:,2)/max(max(frameone(:,:,2))); % yellow
    WL(:,:,3)=frameone(:,:,1)/max(max(frameone(:,:,1))); % green
elseif strcmp(system, 'EastOIS1_Fluor')
    WL(:,:,1)=frameone(:,:,3)/max(max(frameone(:,:,3))); % red
    WL(:,:,2)=frameone(:,:,2)/max(max(frameone(:,:,2))); % yellow
    WL(:,:,3)=frameone(:,:,1)/max(max(frameone(:,:,1))); % green
end

disp('Processing Pixels')
for x=1:info.nVx;
    parfor y=1:info.nVy;
        datahb(y,x,:,:)=procPixel(squeeze(rawdata(y,x,2:4,:)),op,E,info);
    end
end

datahb=smoothimage(datahb,5,1.2); % spatially smooth data

end

%% readtiff()
function [data]=readtiff(filename)

info = imfinfo(filename);
numI = numel(info);
data=zeros(info(1).Height,info(1).Width,numI,'uint16');
fid=fopen(filename);
fseek(fid,info(1).Offset,'bof');

for k = 1:numI
    fseek(fid,[info(1,1).StripOffsets(1)-info(1).Offset],'cof');
    tempdata=fread(fid,info(1).Height*info(1).Width,'uint16');
    data(:,:,k) = rot90((reshape(tempdata,info(1).Height,info(1).Width)),-1);
end

fclose(fid);

end

%% getop() Get the optical pathlengths, extinction coefficients, and LED spectra
function [op, E, numled, led, Hb]=getop_system(system)

[lambda1, Hb]=getHb; % Get hemoglobin extinction coefficients

if strcmp(system, 'fcOIS1')
    [led, lambda2]=getfcOIS1LEDs; % Get LED spectra
elseif strcmp(system, 'fcOIS2')
    [led, lambda2]=getfcOIS2LEDs; % Get LED spectra
elseif strcmp(system, 'EastOIS1')
    [led, lambda2]=getEastOIS1LEDs; % Get LED spectra
elseif strcmp(system, 'fcOIS2_Fluor')
    [led, lambda2]=getfcOIS2_FluorLEDs; % Get LED spectra
elseif strcmp(system, 'EastOIS1_Fluor')
    [led, lambda2]=getEastOIS1_FluorLEDs;    

end

op.HbT=76*10^-3; % uM concentration
op.sO2=0.71; % Oxygen saturation (%/100)
op.BV=0.1; % blood volume (%/100)

% Hb02=Hb(:,1)*(op.HbT*op.sO2);
% HbR=Hb(:,2)*(op.HbT*(1-op.sO2));

op.nin=1.4; % Internal Index of Refraction
op.nout=1; % External Index of Refraction
op.c=3e10/op.nin; % Speed of Light in the Medium
op.musp=10; % Reduced Scattering Coefficient

numled=size(led,2);

for n=1:numled
    
    % Interpollate from Spectrometer Wavelengths to Reference Wavelengths
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
    
    % Differential Pathlength Factors
    op.dpf(n)=(op.c/op.musp)*(1/(2*op.gamma(n)*sqrt(op.mua(n)*op.c)))*(1+(3/op.c)*op.mua(n)*op.gamma(n)^2);
end

end

%% getHb()
function [lambda, Hb]=getHb

data=dlmread('prahl_extinct_coef.txt');

lambda=data(:,1);
c=log(10)/10^3; % convert: (1) base-10 to base-e and (2) M^-1 to mM^-1
Hb=c*squeeze(data(:,2:3));

end

%% getLED()
function [led lambda]=getfcOIS1LEDs
led{1}.name='OSCR5111A-WY'; % red
led{2}.name='B5B-435-30S';  % orange
led{3}.name='OSCY5111A-WY'; % yellow
led{4}.name='RLS-5B475-S';  % blue

numled=size(led,2);

for n=1:numled
    fid=fopen([led{n}.name,'.Master.Sample']);
    temp=textscan(fid,'%f %f','headerlines',19);
    fclose(fid);
    lambda=temp{1};
    led{n}.spectrum=temp{2};
end

end

function [led, lambda]=getfcOIS2LEDs
led{1}.name='150917_TL_470nm_Pol';      %Blue
led{2}.name='150917_Mtex_530nm_Pol';    %Green
led{3}.name='150917_TL_590nm_Pol';      %Yellow
led{4}.name='150917_TL_628nm_Pol';      %Red

numled=size(led,2);

for n=1:numled
    fid=fopen([led{n}.name, '.txt']);
    temp=textscan(fid,'%f %f','headerlines',0);
    fclose(fid);
    lambda=temp{1};
    led{n}.spectrum=temp{2};
end

end

function [led, lambda]=getEastOIS1LEDs
led{1}.name='East3410OIS1_TL_470_Pol';      %Blue
led{2}.name='East3410OIS1_TL_590_Pol';      %Yellow
led{3}.name='East3410OIS1_TL_617_Pol';      %Orange
led{4}.name='East3410OIS1_TL_625_Pol';      %Red

numled=size(led,2);

for n=1:numled
    fid=fopen([led{n}.name, '.txt']);
    temp=textscan(fid,'%f %f','headerlines',0);
    fclose(fid);
    lambda=temp{1};
    led{n}.spectrum=temp{2};
end

end

function [led, lambda]=getfcOIS2_FluorLEDs
led{2}.name='150917_Mtex_530nm_Pol';    %Green
led{3}.name='150917_TL_590nm_Pol';      %Yellow
led{4}.name='150917_TL_628nm_Pol';      %Red

numled=size(led,2);

for n=1:numled
    fid=fopen([led{n}.name, '.txt']);
    temp=textscan(fid,'%f %f','headerlines',0);
    fclose(fid);
    lambda=temp{1};
    led{n}.spectrum=temp{2};
end

end






function [led, lambda]=getEastOIS1_FluorLEDs;  
led{1}.name='TL530nm_pol';    %Green
led{2}.name='East3410OIS1_TL_617_Pol';      %Orange
led{3}.name='East3410OIS1_TL_625_Pol';      %Red

numled=3;

for n=1:numled
    fid=fopen([led{n}.name, '.txt']);
    temp=textscan(fid,'%f %f','headerlines',0);
    fclose(fid);
    lambda=temp{1};
    led{n}.spectrum=temp{2};
end

end

%% smoothimage()
function [data2]=smoothimage(data,gbox,gsigma)

[nVx nVy cnum T]=size(data);

% Gaussian box filter center
x0=ceil(gbox/2);
y0=ceil(gbox/2);

% Make Gaussian filter
G=zeros(gbox);
for x=1:gbox
    for y=1:gbox
        G(x,y)=exp((-(x-x0)^2-(y-y0)^2)/(2*gsigma^2));
    end
end

% normalize Gaussian to 1
G=G/sum(sum(G));

% Initialize
data2=zeros(nVx,nVy,cnum,T);

% convolve data with filter
for c=1:cnum
    for t=1:T
        data2(:,:,c,t)=conv2(squeeze(data(:,:,c,t)),G,'same');
    end
end

end

%% procPixel()
function [data2]=procPixel(data,op,E,info)

%Detrend
warning('off')
for c=1:info.numled
    data(c,:)=data(c,:)-polyval(polyfit(1:info.T1, data(c,:), 5), 1:info.T1)+mean(data(c,:));
end
warning('on')

%Logmean
data=logmean(data);

%Account for differential pathlength
for c=1:size(data,1)
    data(c,:)=squeeze(data(c,:))/op.dpf(c);
end

%Filter
[data]=highpass(data,info.highpass,info.framerate);
[data]=lowpass(data,info.lowpass,info.framerate);

%Spectroscopy
[data2]=dotspect(data,E);

%Resample
data2=resampledata(data2,info.framerate,info.freqout,10^-5);
end