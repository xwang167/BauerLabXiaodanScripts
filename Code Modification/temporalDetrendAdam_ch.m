function result = temporalDetrend(inputData,varargin)
%temporalDetrend Temporally detrends by fiting to a polynomial.
% input:
%   inputData = nD matrix. Last dim is time.
%   usePoly (optional) = Boolean determining whether to use polyfit option.
%   Default is false.

% result = inputData;

if numel(varargin) > 0
    usePoly = varargin{1};
else
    usePoly = false;
end

dataSize = size(inputData);
data = reshape(inputData,[],dataSize(end));

for c=1:size(data,1) %each pixel
    data(c,:)=data(c,:)-polyval(polyfit(1:dataSize(end), data(c,:), 5), 1:dataSize(end))+mean(data(c,:));
    warning('off')
end

result = reshape(data,dataSize);

end