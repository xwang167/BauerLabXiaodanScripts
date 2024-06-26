function [op, E] = getHbOpticalProperties_newOp(lightSourceFiles, varargin)
% getHbOpticalProperties Obtains hemoglobin optical properties
%   Inputs:
%       lightSourceFiles
%       extCoeffFile
%   Outputs:
%       op = optical properties
%       absCoeff = absorption coefficient
muspFcn = @(x,y) (40*(x/500).^-1.16)'*y;
if numel(varargin) > 0
    extCoeffFile = varargin{1};
else
    pkgDir = what('bauerParams');
    extCoeffDir = string(pkgDir.path);
    extCoeffFile = fullfile(extCoeffDir,"prahl_extinct_coef.txt");
end

[lambda1, extCoeff] = getExtCoeff(extCoeffFile); % Get hemoglobin extinction coefficients
% extCoeff is 1/(cm*M)

[sourceSpectra, lambda2] = getSpectra(lightSourceFiles);

op.HbT=76*10^-6; % M concentration
op.sO2=0.71; % Oxygen saturation (%/100)
op.BV=0.1; % blood volume (%/100)

op.nin=1.4; % Internal Index of Refraction
op.nout=1; % External Index of Refraction
op.c=3*10^10/op.nin; % Speed of Light in the Medium (cm/s)

% a = 40; b = 1.16; % musp parameters
% op.musp=10; % Reduced Scattering Coefficient (cm-1)

E = nan(numel(lightSourceFiles),size(extCoeff,2)); % total extinction

for sourceInd = 1:numel(lightSourceFiles)
    
    % Interpollate from Spectrometer Wavelengths to Reference Wavelengths
    sourceSpectra{sourceInd} = interp1(lambda2{sourceInd},...
        sourceSpectra{sourceInd},lambda1,'pchip');
    
    % Subtract Spectrum baseline
    base = mean(sourceSpectra{sourceInd}(1:50));
    sourceSpectra{sourceInd} = sourceSpectra{sourceInd} - base;
    
    % Normalize
    sourceSpectra{sourceInd} = sourceSpectra{sourceInd}./sum(sourceSpectra{sourceInd});
    
    % Zero Out Noise
    sourceSpectra{sourceInd}(sourceSpectra{sourceInd}<0.05*max(sourceSpectra{sourceInd}))=0;
    
    % Spectroscopy Matrix
    E(sourceInd,:)=extCoeff'*sourceSpectra{sourceInd};
    
    conc = op.HbT*[op.sO2 1-op.sO2]; % concentration of species
    
%     muspSpectra = a*(lambda1./500).^(-b);
%     musp = muspSpectra'*sourceSpectra{sourceInd};
    
    op.musp(sourceInd) = muspFcn(lambda1,sourceSpectra{sourceInd});
    
    [op.mua(sourceInd),op.dpf(sourceInd)] = diffPath_newOp(op.c,op.musp(sourceInd),E(sourceInd,:),conc);
end

end