function [data2]=logmean(data)

% This program takes the log-ratio of raw intensity data. So, if y_{in} is
% a source-detector time trace, then the output is y_{out} = -log(y_{in} /
% <y_{in}>). This conversion is so that input raw intensity data can be
% converted to ratiometric data for inversion (consistent with the Rytov
% approximation).
% 
% The syntax is:
% 
% [data2]=logmean(data)
% 
% Thus, logmean() takes one input variable data and outputs one variable
% data2. The input variable can be any array with the last dimension being
% the time dimension. logmean() will then loop over all non-time
% dimensions. The returned variable has the same array size as the input
% variable.
% 
% The dimensions of data can be off any size or order. For example, your
% array could be sized "source by detectors by color" or "optode pair by
% color" and the program will still work. 
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

if isstruct(data)
    N=fieldnames(data);
    
    for f=1:size(N,1)
        fname=N{f};
        data2.(fname)=logmean(data.(fname));
    end
else
    
    [data, Sin, Sout]=datacondition(data,1);

    data2=zeros(Sout,'double');
    
    
    for n=1:Sout(1)
        switch class(data)
            case 'double'
                tmp=squeeze(data(n,:));
            otherwise
                tmp=double(squeeze(data(n,:)));
        end
        tmp2=-log(tmp./mean(tmp));
        data2(n,:)=tmp2;
        clear tmp tmp2;
    end
    
    data2=reshape(data2,Sin);
    
end

end