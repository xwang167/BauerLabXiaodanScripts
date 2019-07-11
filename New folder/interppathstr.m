function [filepath,filename,filetype]=interppathstr(fileall)

% interppathstr takes in a path string corresponding to a file and breaks
% it up into the directory (path) component, the name of the file, and the
% file extension.
% 
% [filepath,filename,filetype]=interppathstr(fileall)
% 
% For example interppathstr('D:/temp/data.mat') would return
% filepath='D:/temp/', filename='data', and filetype='mat'. 
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

p=isstrprop(fileall,'punct'); % file all punctuation in fileall
pindex=find(p==1); % indices of punctuation

for n=numel(pindex):-1:1 % check all punctuation from back to front
    d=fileall(pindex(n));
    switch d
        case '.' % if extension divider
            filetype=fileall((pindex(n)+1):end); % pull out extension
            extindex=pindex(n);
            continue % keep checking for path divider
        case {'/','\'} % if path divider
            if d==numel(fileall) % check to make sure not at end of fileall
                error('** The file name you tried to load includes only a directory path **')
            end
            filepath=fileall(1:pindex(n)); % divide into path and name
            if ~exist('filetype','var')
                filename=fileall((pindex(n)+1):end);
            else
                filename=fileall((pindex(n)+1):(extindex-1));
            end
            break % then we're done
        otherwise % if other symbol (e.g., '-' or '_')
            continue % then keep looking
    end
end

if ~exist('filename','var'); % if we haven't reached a path/name divider
    if ~exist('filetype','var') % if no extension
        filename=fileall; % then entire string was name
    else
        filename=fileall(1:(end-numel(filetype)-1)); % otherwise, non-extension part was string.
    end
end

if ~exist('filepath','var'); filepath=[pwd,'\']; end % if no directory, use current directory
if ~exist(filepath,'dir'); error('** The requested directory does not exist **'); end % if no directory, use current directory

if exist('filetype','var'); % if no extension, we'll need to check both .mag and .mat
    return
elseif exist([fileall,'.mag'],'file') % try .mag first (new decoding)
        filetype='mag';
        return
elseif exist([fileall,'.mat'],'file') % check for .mat (old decoding)
        filetype='mat';
        return
else
    disp('** The requested file was not found in the directory **')
    filetype=[];
    return
end

end