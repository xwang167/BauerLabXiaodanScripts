function TransformDatahb(Date, Mouse, suffix)

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

load([Date, '-', Mouse,'-LandmarksandMask.mat'], 'I');

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
    
    if ismember('xform_datahb', {vars.name})
        disp([loopfile,' Already transformed'])
        n=n+1;
    else        
        load(loopfile, 'datahb');
        disp(['Transforming ', loopfile])
        [nVy, nVx, hem, T]=size(datahb);        
        for h=1:hem;
            for m=1:T;
                xform_datahb(:,:,h,m)=Affine(I, datahb(:,:,h,m));
            end
        end
        xform_datahb=real(xform_datahb);
        save(loopfile,'xform_datahb','-append');        
        n=n+1;        
    end    
end

end
