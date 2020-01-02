function TransformLaserFrame(Date, Mouse, suffix)

% Affine transforms all runs of a mouse.
% file is a string of the following format 'YYMMDD-MouseName'
% type is an optional string denoting orientation of data.  Use 'New' unless
% image data are vertically flipped
% tag is an optional string label

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

filename=[Date, '-', Mouse, '-', suffix];

if ~exist([Date, '-', Mouse,'-LandmarksandMask.mat'], 'file')
    disp(['LandMarksandMask file does not exist for ', Date, '-', Mouse])
    return
else
    load([Date, '-', Mouse,'-LandmarksandMask.mat'], 'I','isbrain');
    n=1; %code assumes the first run is labeled as "1"
    while 1
        
        loopfile=[filename, num2str(n),'-datahb.mat'];
        if ~exist(loopfile,'file');
            n=n+1;
            loopfile=[filename,num2str(n),'-datahb.mat'];
            if ~exist(loopfile,'file');
                break
            end
        end
        
        vars = whos('-file',loopfile);
        if ismember('xform_LaserFrame', {vars.name})
            disp(['Laser frames already transformed'])
            n=n+1;
        else
            load(loopfile,'LaserFrame');
            disp(['Transforming Laser Frame for ', loopfile])
            
            %% Added by John on 12/13/18 to find laser frame indices before affine transformation
            % Find indices of max values of Laser frame. Of note, it is important
            % to perform affine transform after finding max values as this reduces
            % error from affine transforming then finding max values
            LaserFrameIndices = zeros(size(LaserFrame,3),2);
            LaserFrame1 = LaserFrame.*isbrain;
            for i = 1:size(LaserFrame1,3);
                maxval = max(max(LaserFrame1(:,:,i)));
                if maxval ~= 0
                    [y,x] = find(LaserFrame1(:,:,i) == maxval);
                    if length(x)>1;
                        x = mean(x);
                        y = mean(y);
                    end
                    LaserFrameIndices(i,:) = [x,y];
                end
            end
                       
            
            [nVy, nVx, T]=size(LaserFrame);
            xform_LaserFrame=zeros(size(LaserFrame));
            
            for m=1:T;
                xform_LaserFrame(:,:,m)=Affine(I, LaserFrame(:,:,m));
            end
            xform_LaserFrame=real(xform_LaserFrame);    
            
            
            [xform_LaserFrameIndices,~] = Affine(I,LaserFrameIndices(:,:));
            xform_LaserFrameIndices = xform_LaserFrameIndices(:,1:2);
            save(loopfile,'xform_LaserFrame','xform_LaserFrameIndices', '-append');
            n=n+1;
        end        
    end
    
end

end

