% creating a 3D representation of a mouse brain to calibrate OIS system

function [plane_final] = John_Make3DMouseBrain(varargin); 
if length(varargin) == 1;
    I = varargin{1};
    load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\John\MouseBrainStandard.mat','FinalMouseBrain');
elseif length(varargin) == 6;
    s = varargin{1};
    theta_x = varargin{2};
    theta_y = varargin{3};
    xform_GalvoSeed = varargin{4};
    xform_LaserFrameIndices = varargin{5};
    GoodSeedsidx_Left = varargin{6};    
end

if length(varargin) ~= 1;    
    xform_GS_totalave= xform_GalvoSeed(GoodSeedsidx_Left == 1,:);
    xform_LFI_totalave = xform_LaserFrameIndices(GoodSeedsidx_Left==1,:);
    
    GS = [xform_GS_totalave;[129-xform_GS_totalave(:,1),xform_GS_totalave(:,2)]];
    LFI = [xform_LFI_totalave;[129-xform_LFI_totalave(:,1),xform_LFI_totalave(:,2)]];
    
    LFI = LFI(GS(:,1)~=0,:); GS = GS(GS(:,1)~=0,:);
    LFI = LFI(GS(:,1)~=129,:); GS = GS(GS(:,1)~=129,:);
    
    % Calculating mouse brain height at different points
    dist = zeros(size(GS));
    for i = 1:size(GS,1);
        dist(i,:) = GS(i,:)-LFI(i,:);
    end
    
    if exist('W')
        affine_input = ones(size(GS,1),size(GS,2)+1);
        affine_input(:,1:2) = GS;
        affine_output = affine_input*inv(W);
        GS  = affine_output(:,1:2);
        
        affine_input1 = ones(size(LFI,1),size(LFI,2)+1);
        affine_input1(:,1:2) = LFI;
        affine_output1 = affine_input1*inv(W);
        LFI  = affine_output1(:,1:2);
    end
    
    height = zeros(size(dist));
    height(:,1) = dist(:,1)./tand(theta_x);
    height(:,2) = dist(:,2)./tand(theta_y);
    
    % Initialize final planes
    plane_x = zeros(128); plane_y = zeros(128);
    
    for x = 1:128;
        for y = 1:128;
            sum_LFI = [0,0];
            num_LFI = 0;
            for g = 1:size(LFI,1);
                if sqrt((LFI(g,1)-x)^2+(LFI(g,2)-y)^2) <=s;
                    sum_LFI = sum_LFI+height(g,:);
                    num_LFI = num_LFI+1;
                end
            end
            if num_LFI ~=0;
                plane_x(y,x) = sum_LFI(1,1)./num_LFI;
                plane_y(y,x) = sum_LFI(1,2)./num_LFI;
            else
                if x <=64.5
                    plane_x(y,x) = min(height(:,1));
%                     plane_y(y,x) = min(height(:,1));
                else
                    plane_x(y,x) = max(height(:,1));
%                     plane_y(y,x) = max(height(:,2));
                end
            end
        end
    end
    
    plane_final = zeros([size(plane_x),2]);
    plane_final(:,:,1) = plane_x;
    plane_final(:,:,2) = plane_y;
else
    FinalMouseBrain = fliplr(FinalMouseBrain);
    [plane_x,~] = InvAffine(I,squeeze(FinalMouseBrain(:,:,1)));
    [plane_y,~] = InvAffine(I,squeeze(FinalMouseBrain(:,:,2)));
    plane_x= permute(plane_x,[2,1]);
    plane_y = permute(plane_y,[2,1]);
    plane_final = cat(3,plane_x,plane_y);
end
figure

surf_x = 1:128;
surf_y = 1:128;
surf_z_x = plane_x;
surf_z_y = plane_y;
subplot(1,2,1)
John_CreateNiceWL(1); hold on
surf(surf_x,surf_y,surf_z_x);
xlim([0,128]);
ylim([0,128]);
daspect([1,1,1]);
subplot(1,2,2)
John_CreateNiceWL(1); hold on
surf(surf_x,surf_y,surf_z_y);

xlim([0,128]);
ylim([0,128]);
daspect([1,1,1]);
end