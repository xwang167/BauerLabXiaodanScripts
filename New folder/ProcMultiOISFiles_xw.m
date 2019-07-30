function ProcMultiOISFiles(Date, Mouse, suffix, directory, rawdataloc, info, system)

% (c) 2009 Washington University in St. Louis
% All Rights Reserved

% Process multiple OIS files with the following naming convention:

% filedate: YYMMDD
% subjname: any alphanumberic convention is ok, e.g. "Mouse1"
% suffix: filename run number, e.g. "fc1"
% In Andor Solis, files are saved as "YYMMDD-MouseName-suffixN.tif"

% "directory" is where processed data will be stored. If the
% folder does not exist, it is created, and if directory is not
% specified, data will be saved in the current folder:

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

%% Process Resting State Data
rawdatatype='.tif';
filename = strcat(Date,'-',Mouse,'-',suffix);

n=1; %code assumes the first run is labeled as "1"
while 1 %this loop will execute as long as a run is found

    loopfile=strcat(rawdataloc,"\", filename,num2str(n),rawdatatype);

    if ~exist(loopfile,'file'); % increments run number
        n=n+1;
        loopfile=[rawdataloc, filename,num2str(n),rawdatatype];

        if ~exist(loopfile,'file'); % if 2 runs were skipped
            n=n+1;
            loopfile=[rawdataloc, filename,num2str(n),rawdatatype];

            if ~exist(loopfile,'file'); %stops executing loop if more than one fc run was skipped.
                disp([' **** No more data found for ', filename, ' ****'])
                break
            end
        end
    end

    if exist(strcat(directory,"\", filename, num2str(n),'-datahb.mat'),'file') %checks to see if the raw data were already processed
        disp([filename,num2str(n),' Already processed'])
        n=n+1;
    else
        disp(['Processing ', filename,num2str(n), ' on ', system])
        [datahb, WL, op, E, info]=procOISData_xw(loopfile, info, system);
        disp('Saving Data')
        save([directory, filename,num2str(n),'-datahb'],'datahb','WL', 'info')
        imwrite(WL,[directory, filename,num2str(n),'-WL.tif'],'tiff');
        n=n+1;
    end
end