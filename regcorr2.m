function [data2, R]=regcorr2(data,hem1, hem2)

% Edited by Adam Bauer 120105 to allow regression of multiple signals
% regcorr2() regresses out multiple signals from data and returns the
% post-regression data as well as the correlation coefficient of the input
% regressor with every channel in the data. If y_{r} is the signal to be
% regressed out and y_{in} is a data time trace (either source-detector or
% imaged), then the output is the least-squares regression: y_{out} =
% y_{in} - y_{r}(<y_{in},y_{r}>/|y_{r}|^2). Additionally, the correlation
% coefficient is given by: R=(<y_{in},y_{r}>/(|y_{in}|*|y_{r}|)).
% 
% To use regcorr() The syntax is:
% 
% [data2 R]=regcorr(data,hem)
% 
% regcorr() takes two input variables data and hem. This first variable is
% your data from which you want the signal regressed. It must be an array
% of two or more dimensions. The last dimension must be time, and the
% second-to-last dimension must be color/contrast. The other dimensions can
% be arranged in any order (e.g., source by detector, optode pair, or
% voxels). regcorr() will then loop over these dimensions as well as the
% color/contrast dimension.
% 
% The second input variable is signal which you want regressed from all the
% measurements. It must be a two dimensional array with the first dimension
% being color/contrast, and the second being time. If there is more than
% one color/contrast (e.g., 750 nm and 850 nm), then the number of
% contrasts in hem must be the same as in data. In this case, the
% regression will be contrast-matched, where each color in data will have
% that specific color's noise regressed out. If hem has only one contrast
% (i.e., one row), then that time trace will be regressed out of every
% contrast in data.
% 
% regcorr() outputs the variable data2, which is the regressed data. This
% returned variable has the same array size as the input variable. The
% second output variable is the correlation coefficients with every
% channel. It has the same size as the input data array (except without the
% time dimension). The second output, R is the correlation coefficient
% between hem and every time trace in data (within a color/contrast).  
%
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

[data Sin Sout]=datacondition(data,2); % reshape to meas x color x time
[hem1 Hin1 Hout1]=datacondition(hem1,2); % reshape to color x time
[hem2 Hin2 Hout2]=datacondition(hem2,2);

% check compatibility
if Hout1(end)~=Sout(end)
    error('** Your data and regressor do not have the same time length: perhaps check your Resampling Tolerance Flag **')
end

% check compatibility
if Hout2(end)~=Sout(end)
    error('** Your data and regressor do not have the same time length: perhaps check your Resampling Tolerance Flag **')
end

if numel(Sout)==3 % normal case
    L=Sout(1);
    C=Sout(2);
    T=Sout(3);
    
    data2=zeros(T,C,L);
    R=zeros(L,C);
    
    for c=1:C
        temp=squeeze(data(:,c,:))'; % get single color/contrast time x voxel
        g1=hem1(c,:)'; % regressor/noise signal in correct orientation time x 1
        g2=hem2(c,:)'; % regressor/noise signal in correct orientation time x 1
        g=[g1 g2]; 
        gp=pinv(g); % pseudoinverse for least-square regression 2x t
        beta=gp*temp; % regression coefficient 1 x voxel
        data2(:,c,:)=temp-g*beta; % linear regression
     %   R(:,c)=normRow(g')*normCol(temp); % correlation coefficient
    end
     data2=permute(data2,[3 2 1]); % switch dimensions back to correct order
 %   R=reshape(R,Sin(1:(end-1))); % reshape to original size (minus time)
end

data2=reshape(data2,Sin); % reshape to original shape

end