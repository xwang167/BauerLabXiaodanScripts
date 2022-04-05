function  varargout = resample(varargin)
%RESAMPLE  Resample uniform or nonuniform data to a new fixed rate.
%   Y = RESAMPLE(X,P,Q) resamples the values, X, of a uniformly sampled
%   signal at P/Q times the original sample rate using a polyphase
%   antialiasing filter. If X is a matrix, then RESAMPLE treats each
%   column as an independent channel.
%
%   In its filtering process, RESAMPLE assumes the samples at times before
%   and after the given samples in X are equal to zero. Thus large
%   deviations from zero at the end points of the sequence X can cause
%   inaccuracies in Y at its end points.
%
%   [Y,Ty] = RESAMPLE(X,Tx) resamples the values, X, of a signal sampled at
%   the instants specified in vector Tx. RESAMPLE interpolates X linearly
%   onto a vector of uniformly spaced instants, Ty, with the same endpoints
%   and number of samples as Tx.  Tx may either be a numeric vector
%   expressed in seconds or a datetime object.  NaNs and NaTs (for datetime
%   objects) are treated as missing data and are ignored.
%
%   [Y,Ty] = RESAMPLE(X,Tx,Fs) uses interpolation and an anti-aliasing
%   filter to resample the signal at a uniform sample rate, Fs, expressed
%   in hertz (Hz).
%
%   [Y,Ty] = RESAMPLE(X,Tx,Fs,P,Q) interpolates X to an intermediate
%   uniform grid with sample rate equal Q*Fs/P and filters the result
%   using UPFIRDN to upsample by P and downsample by Q.  Specify P and Q
%   so that Q*Fs/P is least twice as large as the highest frequency in the
%   input signal.
%
%   [Y,Ty] = RESAMPLE(X,Tx,...,METHOD) specifies the interpolation method.
%   The default is linear interpolation.  Available methods are:
%     'linear' - linear interpolation
%     'pchip'  - shape-preserving piecewise cubic interpolation
%     'spline' - piecewise cubic spline interpolation
%
%   Y = RESAMPLE(...,P,Q,N) uses a weighted sum of 2*N*max(1,Q/P) samples
%   of X to compute each sample of Y.  The length of the FIR filter
%   RESAMPLE applies is proportional to N; by increasing N you will get
%   better accuracy at the expense of a longer computation time.
%   RESAMPLE uses N = 10 by default. If N = 0, RESAMPLE performs
%   nearest neighbor interpolation: the output Y(n) is
%   X(round((n-1)*Q/P)+1), with Y(n) = 0 for round((n-1)*Q/P)+1 > length(X)).
%
%   Y = RESAMPLE(...,P,Q,N,BTA) uses BTA as the BETA design parameter for
%   the Kaiser window used to design the filter.  RESAMPLE uses BTA = 5 if
%   you don't specify a value.
%
%   Y = RESAMPLE(...,P,Q,B) uses B to filter X (after upsampling) if B is a
%   vector of filter coefficients.  RESAMPLE assumes B has odd length and
%   linear phase when compensating for the filter's delay; for even length
%   filters, the delay is overcompensated by 1/2 sample.  For non-linear
%   phase filters consider using UPFIRDN.
%
%   [Y,B] = RESAMPLE(X,P,Q,...) returns in B the coefficients of the filter
%   applied to X during the resampling process (after upsampling).
%
%   [Y,Ty,B] = RESAMPLE(X,Tx,...) returns in B the coefficients of the
%   filter applied to X during the resampling process (after upsampling).
%
%   Y = resample(...,'Dimension',DIM) specifies the dimension, DIM,
%   along which to resample an N-D input array. If DIM is not specified,
%   resample operates along the first array dimension with size greater
%   than 1.
%
%   [Y,B] = RESAMPLE(TT,...) resamples the data in timetable TT and returns
%   a timetable Y. TT must contain double-precision data and must have at
%   least two rows. Each variable in TT is treated as an independent
%   signal. If TT has an N-D array as a variable, then RESAMPLE operates
%   along the first dimension. In other words, it treats columns as
%   channels. The RowTimes in TT may either be a duration vector or a
%   datetime object with unique and finite values. If RowTimes in TT are
%   not sorted, then RESAMPLE sorts them in an ascending order. Non-finite
%   time values (NaNs and NaTs) are treated as missing data and are
%   ignored. You can replace X,Tx with a nonuniformly sampled timetable TT
%   in the above syntaxes that use X and Tx as inputs. You can replace X
%   with a uniformly sampled timetable TT in all the other syntaxes. Use
%   isregular to check if TT is uniformly sampled or not.
%
%   % EXAMPLE 1:
%   %   Resample a sinusoid at 3/2 the original rate.
%
%   tx = 0:3:300-3;         % Time vector for original signal
%   x = sin(2*pi*tx/300);   % Define a sinusoid
%   ty = 0:2:300-2;         % Time vector for resampled signal
%   y = resample(x,3,2);    % Change sampling rate
%   plot(tx,x,'+-',ty,y,'o:')
%   legend('Original','Resampled');
%   xlabel('Time')
%
%   % EXAMPLE 2:
%   %   Resample a non-uniformly sampled sinusoid to a uniform 50 Hz rate.
%
%   Fs = 50;
%   tx = linspace(0,1,21) + .012*rand(1,21);
%   x = sin(2*pi*tx);
%   [y, ty] = resample(x, tx, Fs);
%   plot(tx,x,'+-',ty,y,'o:')
%   legend('Original','Resampled');
%   xlabel('Time')
%
%   % EXAMPLE 3:
%   %   Resample a multichannel sinusoid by 3/2 along its second dimension.
%
%   p = 3;
%   q = 2;
%   tx = 0:3:300-3;
%   x = cos(2*pi*tx./(1:5)'/100);
%   y = resample(x,p,q,'Dimension',2);
%   ty = 0:2:300-2;
%   plot(tx,x,'+-',ty,y,'o:')
%   legend('Original','Resampled');
%   xlabel('Time')
%
%   % EXAMPLE 4:
%   %   Resample a 3D random signal along its second dimension at twice the
%   %  original rate.
%
%   tx = 0:2:38;
%   x = rand(100,20,5);
%   ty = 0:39;
%   y = resample(x,2,1,'Dimension',2);
%   plot(tx,x(1,:,1),'+-',ty,y(1,:,1),'o:')
%   legend('Original','Resampled');
%   xlabel('Time')
%
%   % EXAMPLE 5:
%   %   Resample an input timetable to 3/2 times the original rate.
%
%   tx = 0:3:300-3;
%   x = sin(2*pi*tx/300);
%   xTT = timetable(seconds(tx)',x');
%   yTT = resample(xTT,3,2);
%   y = table2array(yTT);
%   ty = seconds(yTT.Properties.RowTimes);
%   plot(tx,x,'+-',ty,y,'o:')
%   legend('Original','Resampled');
%   xlabel('Time')
%
%   See also UPFIRDN, INTERP, INTERP1, DECIMATE, FIRLS, KAISER, INTFILT.

%   NOTE: digital antialiasing filter is designed using windowing

%   Copyright 1988-2021 The MathWorks, Inc.
%#codegen

if isempty(varargin) || ~istimetable(varargin{1})
    narginchk(2,10);
    isTT = false;
else
    % Input data is timetable
    isTT = true;
    % Timetables are not supported for codegeneration
    isMATLAB = coder.target('MATLAB');
    coder.internal.errorIf(~isMATLAB, ...
        'signal:codegeneration:TimeTableNotSupported');
    % Input & Output parameters
    narginchk(1,9);
    nargoutchk(0,2);
end

% Initial parse of inputs.
[Dim,m,isDimValSet,method,numNumericArgs] = signal.internal.resample.sharedParser(varargin{:});

% For codegen support, must extract numeric args here.
idx = 0;
numericArgs = cell(1,numNumericArgs);

coder.unroll();
for kk = 1:length(varargin)
    if isnumeric(varargin{kk}) || isdatetime(varargin{kk}) ...
            || istimetable(varargin{kk})
        idx = idx+1;
        numericArgs{idx} = varargin{kk};
    end
end

if ~isTT
    % permutes the input dimensions such that it's first non-singleton
    % dimension is DIM
    [xIn, dimIn] = signal.internal.resample.orientToNdim (varargin{1}, Dim);
    % Parse the inputs and set the appropriate arguments
    
    % uniform or nonuniform sampling is decided at compile-time. if
    % varargin{2} is a scalar at compile-time, uniform sampling is
    % inferred.
    isP = coder.internal.isConstTrue(isscalar(varargin{2}));
    
    if isP && (m <= 5)
        % [...] = RESAMPLE(X,P,Q,...)
        % error check for uniform resampling
        coder.internal.assert(~(m < 3 && isP),'signal:resample:MissingQ');
        
        % interpolation is not performed when using uniformly sampled data
        coder.internal.assert(~(~strcmp(method,'')),...
            'signal:resample:UnexpectedInterpolation',method);
        
        [varargout{1:max(1,nargout)}] = ...
            signal.internal.resample.uniformResample(xIn, isDimValSet, Dim, dimIn, numericArgs{:});
    else
        % [...] = RESAMPLE(X,Tx,...)
        
        % varargin{2} represents the time vector and cannot become a scalar
        % at runtime
        coder.internal.errorIf(isscalar(varargin{2}),'signal:resample:TimeCannotBecomeScalar');
        
        if isempty(method)
            % use linear method by default
            method1 = 'linear';
        else
            method1 = method;
        end
        
        [varargout{1:max(1,nargout)}] = ...
            nonUniformResample(isDimValSet,Dim, m, method1, dimIn, xIn, ...
            numericArgs{:});
    end
    
else
    % If Dimension is specified, the dimension must be 1, because the input
    % is a timetable.
    coder.internal.errorIf((isDimValSet) && (Dim ~= 1), ...
        'signal:resample:DimensionAndTimetableInput');
    Dim = 1;
    
    % Tx vector cannot be specified when input is timetable
    coder.internal.errorIf((numel(varargin) > 1) && ...
        (~isscalar(varargin{2})) && (~ischar(varargin{2})), ...
        'signal:resample:TimeVectorAndTimetableInput');
    isP = true;
    
    xIn = varargin{1};
    
    % Validate timetable input.
    [xTT, varsInTT, tDouble, tIn, varNamesTT, isMissingRowTimes] = ...
        validateTT(xIn);
    if (isMissingRowTimes) || (isnan(xTT.Properties.SampleRate))
        % Input data is non-uniformly sampled
        if isempty(method)
            % use linear method by default
            method1 = 'linear';
        else
            method1 = method;
        end
        
        [varargout{1:max(1,nargout)}] = ...
            nonUniformResampleForTT(varsInTT, tDouble, tIn, varNamesTT, ...
            isDimValSet, Dim, m, method1, numericArgs{:});
    else
        % Input data is uniformly sampled
        % error check for uniform resampling
        coder.internal.assert(~(m < 3 && isP),'signal:resample:MissingQ');
        % interpolation is not performed when using uniformly sampled data
        coder.internal.assert(~(~strcmp(method,'')),...
            'signal:resample:InterpolationAndTimetableInput',method);
        
        [varargout{1:max(1,nargout)}] = ...
            uniformResampleForTT(xTT, varsInTT, tIn, varNamesTT, ...
            isDimValSet, Dim, numericArgs{2:end});
    end
    
end
end

%-------------------------------------------------------------------------
function [y,tyOut,h] = ...
    nonUniformResample(isDimValSet,Dim,m,method,dimIn,xIn,varargin)

[x, tx, tGrid, fs, p, q] = signal.internal.resample.nonUniformParser(isDimValSet,Dim,m,xIn,varargin{:});

if isreal(x)
    xGrid = signal.internal.resample.nDInterp1(tx,x,tGrid,method);
else
    % compute real and imaginary channels independently
    realGrid = signal.internal.resample.nDInterp1(tx,real(x),tGrid,method);
    imagGrid = signal.internal.resample.nDInterp1(tx,imag(x),tGrid,method);
    xGrid = complex(realGrid,imagGrid);
end

% recover the desired sampling rate by resampling the grid at the
% specified ratio
[y, h] = signal.internal.resample.uniformResample(xGrid, isDimValSet, Dim, dimIn, varargin{1}, ...
    p, q, varargin{6:end});

% create output time vector
if isvector(y)
    ny = length(y);
else
    ny = size(y,Dim);
end

ty = coder.nullcopy(zeros(1,ny));

if isdatetime(tx)
    ty = tx(1) + seconds((0:ny-1)/fs);
elseif ~isdatetime(tx) && length(tx)>1
    ty = (tx(1)*ones(1,ny)) + (0:ny-1)/fs(1);
end

% match dimensionality of output time vector to input
if iscolumn(tx)
    tyOut = ty(:);
else
    tyOut = ty;
end
end

%-------------------------------------------------------------------------
function [xTT,varsInTT,tDouble,tIn,varNamesTT,isMissingRowTimes] = ...
    validateTT(xIn)
% Remove missing time & return as a sorted timetable
[xTT, tDouble, tIn, varNamesTT, isMissingRowTimes] = ...
    signal.internal.utilities.parseTimetable(xIn, 'removeMissingTime', ...
    'returnSortedData', 'returnVarDataAsTT');
% Separate out signal data from timetable
varsInTT = separateSignalDataFromTT(xTT, varNamesTT);
% Error out if input timetable has only 1 row or repeating time instants in
% RowTimes
signal.internal.utilities.validateattributesTimetable(xTT,{'singlerow', ...
    'duplicateRowTimes'},'resample','TT');
end

%-------------------------------------------------------------------------
function [yTT,b] = ...
    nonUniformResampleForTT(varsInTT,tDouble,tIn,varNamesTT,isDimValSet,...
    Dim,m,method,varargin)
% Resample the time information
fmt = tIn.Format; % Preserve the format
if isduration(tIn)
    % Pass time as a double array
    tx = tDouble;
else
    % Pass time as datetime directly
    tx = tIn;
end
% Resample the data
for idx = 1:numel(varNamesTT)
    [x, dimIn] = signal.internal.resample.orientToNdim (varsInTT{idx}, Dim);
    % Add Tx as an input argument
    newArgs = {x, tx, varargin{2:end}};
    % Non-uniform resampling of input data
    [y, tyOut, b] = ...
        nonUniformResample(isDimValSet, Dim, m+1, method, dimIn, x, ...
        newArgs{:});
    if (idx == 1)
        if isduration(tIn)
            % Convert from double array into duration vector in the same
            % format as input
            ty = duration(seconds(tyOut), 'Format', fmt);
        else
            % Output time is a datetime object
            ty = tyOut;
        end
        % Create output timetable
        yTT = timetable(ty(:));
    end
    % Add resampled data as a variable into output timetable
    yTT = addvars(yTT, y, 'NewVariableNames', varNamesTT{idx});
end
end

%-------------------------------------------------------------------------
function [yTT,b] = ...
    uniformResampleForTT(xTT,varsInTT,tx,varNamesTT,isDimValSet,Dim,p,q,...
    varargin)
% Resample the time information
fIn = xTT.Properties.SampleRate;
fOut = (p/q) * fIn;
t1 = tx(1);
numTimeInstantsAtOutput = ceil(numel(tx) * (p/q));
% Output timetable RowTimes
ty = t1 + seconds((0:numTimeInstantsAtOutput - 1)/fOut);
% Create the output timetable
yTT = timetable(ty(:));
% Resample the data
for idx = 1:numel(varNamesTT)
    [x, dimIn] = signal.internal.resample.orientToNdim (varsInTT{idx}, Dim);
    % Uniform resampling of input data
    [y, b] = ...
        signal.internal.resample.uniformResample(x, isDimValSet, Dim, dimIn, x, p, q, varargin{:});
    % Add resampled data as a variable into output timetable
    yTT = addvars(yTT, y, 'NewVariableNames', varNamesTT{idx});
end
end

%-------------------------------------------------------------------------
function varsInTT = separateSignalDataFromTT(xTT,varNames)
% Return individual variables' data as a cell array
len = numel(varNames);
varsInTT = cell(1, len);
for idx=1:len
    varsInTT{idx} = xTT.(varNames{idx});
end
end
% LocalWords:  resamples Ns Fs BTA upsampling ty resampled Krauss LPF Lx
% xin sy Tmp Dimenion
% LocalWords:  extrap
