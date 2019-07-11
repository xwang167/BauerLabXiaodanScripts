function [rawdata2 W WL2 isbrain2]=Affine_gcamp6_xw(date, rawdata, WL, isbrain, path, seeds)%, input)%, meth)

% for i=1:size(cats,1)
% 
%     names=fieldnames(cats{i});
%     date=cats{i}.Date;
%     mouse=cell2mat(names(2));
%     msnum=sscanf(mouse,'%*c%*c%d');
%     catruns=cats{i}.(mouse);
 

%% Reference Space (Paxinos Atlas used for reference)

RMAS(1)=64;         %Reference mouse Mid Anterior Suture x
RMAS(2)=19;         %Reference mouse y
RLam(1)=64;         %Reference mouse Lambda x
RLam(2)=114;        %Reference mouse y
RB(1)=mean([RMAS(1) RLam(1)]); %bisecting x
RB(2)=mean([RMAS(2) RLam(2)]); %bisecting y
R3(1)=RB(1)+RB(2)/2;    %Third point x, center point plus half dist between suture and lambda
R3(2)=RB(2);            %Third point y,  same y coord as biscenting point


% RMAS(1)=32;         %Reference mouse Mid Anterior Suture x
% RMAS(2)=9;         %Reference mouse y
% RLam(1)=32;         %Reference mouse Lambda x
% RLam(2)=57;        %Reference mouse y
% RB(1)=mean([RMAS(1) RLam(1)]); %bisecting x
% RB(2)=mean([RMAS(2) RLam(2)]); %bisecting y
% R3(1)=RB(1)+RB(2)/2;    %Third point x, center point plus half dist between suture and lambda
% R3(2)=RB(2);            %Third point y,  same y coord as biscenting point

%load(['K:\DATA\GROUPAVG\FC\Data-140912-CC-2D2Ms8-fc6-FC_Data_WT_T1-Aff'],'I');
% green=cell2mat(struct2cell(load(['C:\Users\PatrickWW\Documents\DATA\',num2str(date),'\', mouse,'\Data\Data-',num2str(date),'-FADms',msnum,'-fc',num2str(catruns)],'green7')));
% redgreen=cell2mat(struct2cell(load(['C:\Users\PatrickWW\Documents\DATA\',num2str(date),'\',mouse,'\Data\Data-',num2str(date),'-FADms',msnum,'-fc',num2str(catruns)],'redgreen7')));
% blue=cell2mat(struct2cell(load(['C:\Users\PatrickWW\Documents\DATA\',num2str(date),'\',mouse,'\Data\Data-',num2str(date),'-FADms',msnum,'-fc',num2str(catruns)],'blue7')));
% bluec=cell2mat(struct2cell(load(['C:\Users\PatrickWW\Documents\DATA\',num2str(date),'\',mouse,'\Data\Data-',num2str(date),'-FADms',msnum,'-fc',num2str(catruns)],'bluecorrected5')));


%% Input Mouse Coordinates
MLam=seeds.tent;        %original clicked lambda
MMAS=seeds.OF;          %original clicked anterior suture
%MBreg=I.bregma;

% switch meth
%     
%     case'Old'
%         MLam(2)=129-I.tent(2); % correct for image space flip in y for Mice imaged before 110807 by putting "129-" before y value
%         MMAS(2)=129-I.OF(2);
%     case'New'
%         MLam(2)=I.tent(2); % correct for image space flip in y for Mice imaged before 110807 by putting "129-" before y value
%         MMAS(2)=I.OF(2);
% end

%MBreg(2)=I.bregma(2);
MB(1)=mean([MMAS(1) MLam(1)]); %bisecting x
MB(2)=mean([MMAS(2) MLam(2)]); %bisecting y

Mang=atan2(MLam(1)-MB(1),(MLam(2)-MB(2))); %angle of bisector with respect to y axis

M3(1)=MB(1)+MB(2)/2*cos(-Mang);  %coordinates of third point, half the distance between midpoint and lambda (or anterior suture)
M3(2)=MB(2)+MB(2)/2*sin(-Mang);

%% Use coordinates to generate affine transform matrix
Refpoints=[RMAS 1; R3 1; RLam 1];
Mousepoints=[MMAS 1; M3 1; MLam 1];

W=Mousepoints\Refpoints;% transform matrix
W(1,3)=zeros;
W(2,3)=zeros;
W(3,3)=1;

% figure; imagesc(input);
% hold on;
% plot(MMAS(1,1),MMAS(1,2),'ko','MarkerFaceColor','k')
% hold on;
% plot(MLam(1,1),MLam(1,2),'ko','MarkerFaceColor','k')
% hold on;
% plot(MB(1,1),MB(1,2),'ko','MarkerFaceColor','k')
% hold on;
% plot(M3(1,1),M3(1,2),'ko','MarkerFaceColor','k')

%% Generate Affine transform struct and transform
% Xdata and Ydata specify output grid...
% using this centers the output image at the transformed midpoint
% now all output images will share a common anatomical center

T=maketform('affine',W);
%B= imtransform(input,T,'XData',[1 64], 'YData',[1 64], 'Size', [64 64]);

% WL2=imtransform(WL, T, 'XData',[1 64], 'YData', [1 64], 'Size', [64 64]);
% rawdata2= imtransform(rawdata,T,'XData',[1 64], 'YData',[1 64], 'Size', [64 64]);
% isbrain2=imtransform(isbrain, T, 'XData',[1 64], 'YData', [1 64], 'Size', [64 64]);
% 
WL2=imtransform(WL, T, 'XData',[1 128], 'YData', [1 128], 'Size', [128 128]);
rawdata2= imtransform(rawdata,T,'XData',[1 128], 'YData',[1 128], 'Size', [128 128]);
isbrain2=imtransform(isbrain, T, 'XData',[1 128], 'YData', [1 128], 'Size', [128 128]);
%deoxy_xform = imtransform(deoxy,T,'XData',[1 64], 'YData',[1 64], 'Size', [64 64]);



%save(['C:\Users\PatrickWW\Documents\DATA\',num2str(date),'\',mouse,'\Data\xformData-',num2str(date),'-FADms',msnum,'-fc',num2str(catruns)], '-v7.3', 'green_xform', 'bluec_xform','redgreen_xform','blue_xform');
% figure; imagesc(B)
%
% MMAS=[MMAS 1]*W;
% MLam=[MLam 1]*W;
% MB=[MB 1]*W;
% M3=[M3 1]*W;
% hold on;
%
% plot(MMAS(1,1),MMAS(1,2),'ko','MarkerFaceColor','k')
% hold on;
% plot(MLam(1,1),MLam(1,2),'ko','MarkerFaceColor','k')
% hold on;
% plot(MB(1,1),MB(1,2),'ko','MarkerFaceColor','k')
% hold on;
% plot(M3(1,1),M3(1,2),'ko','MarkerFaceColor','k')
end