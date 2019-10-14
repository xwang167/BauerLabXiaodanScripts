classdef OpticalProperty
    %OpticalProperty Defines optical properties of the tissue
    %   This object contains basic absorption and refraction properties of
    %   the tissue. It also contains functions that can calculate
    %   derivative properties, including pathlength, reduced scattering
    %   coefficient, and extinction coefficient.
    
    properties
        ExtinctCoeffFile % char array for file containing species' extinction coefficients
        LightSourceFiles % cell char array of light source files (full directory). If one input, one char array can be given as well
        Concentration = 76E-6*[0.71 0.29]
        InternalIndexOfRefraction = 1.4
        LightSpeed = 3E10 % cm/s
        Musp = @(x,y) (40*(x/500).^-1.16)'*y; % equation for calculating musp. Expected input : (wavelength, normalized spectra)
    end
    
    methods
        function obj = OpticalProperty(varargin)
            %OpticalProperty Construct an instance of this class
            %   light source files. Cell array of char vectors (optional)
            %   ext coefficient file (optional)
            
            if numel(varargin) > 0
                lightSourceFiles = varargin{1};
                if ~iscell(lightSourceFiles)
                    lightSourceFiles = cellstr(lightSourceFiles);
                end
                obj.LightSourceFiles = lightSourceFiles;
            else
                paramPath = what('bauerParams');
                hbLoc = fullfile(paramPath.path,'ledSpectra');
                ledFiles = {'150917_Mtex_530nm_Pol.txt',...
                    '150917_TL_590nm_Pol.txt'...
                    '150917_TL_628nm_Pol.txt'};
                for i = 1:3
                    ledFiles{i} = fullfile(hbLoc,ledFiles{i});
                end
                obj.LightSourceFiles = ledFiles;
            end

            if numel(varargin) > 1
                extCoeffFiles = varargin{2};
                obj.ExtinctCoeffFile = extCoeffFiles;
            else
                paramPath = what('bauerParams');
                extCoeffFile = fullfile(paramPath.path,'prahl_extinct_coef.txt');
                obj.ExtinctCoeffFile = extCoeffFile;
            end
        end

        function musp = getMusp(obj)
            %getMusp Obtain reduced scattering coefficient for each light
            %source. No inputs to be given.
            [sourceSpectra,~,lambda] = obj.getSpectra();
            musp = nan(1,numel(sourceSpectra));
            for sourceInd = 1:numel(sourceSpectra)
                musp(sourceInd) = obj.Musp(lambda,sourceSpectra{sourceInd});
            end
        end
        
        function [sourceSpectra,extCoeff,lambda] = getSpectra(obj,varargin)
            %getSpectra Obtain extinction coefficients and normalized
            %spectra.
            %   Input:
            %       normalize (optional) = boolean determining whether normalization
            %       should be done. Default = true
            %   Output:
            %       sourceSpectra
            %       extCoeff
            %       lambda
            
            if numel(varargin) > 0
                normalize = varargin{1};
            else
                normalize = true;
            end
            
            [lambda, extCoeff] = bauerParams.getExtCoeff(obj.ExtinctCoeffFile);
            
            [sourceSpectra, lambda2] = bauerParams.getSpectra(obj.LightSourceFiles);
            
            for sourceInd = 1:numel(sourceSpectra)
                
                % Interpollate from Spectrometer Wavelengths to Reference Wavelengths
                sourceSpectra{sourceInd} = interp1(lambda2{sourceInd},...
                    sourceSpectra{sourceInd},lambda,'pchip');
                
                if normalize
                    % Subtract Spectrum baseline
                    base = mean(sourceSpectra{sourceInd}(1:50));
                    sourceSpectra{sourceInd} = sourceSpectra{sourceInd} - base;
                    
                    % Normalize
                    sourceSpectra{sourceInd} = sourceSpectra{sourceInd}./sum(sourceSpectra{sourceInd});
                    
                    % Zero Out Noise
                    sourceSpectra{sourceInd}(sourceSpectra{sourceInd}<0.05*max(sourceSpectra{sourceInd}))=0;
                end
            end

             
            
            
            
            
            
            
            
        end
        
        function E = getSpectraExtCoeff(obj)
            %getSpectraExtCoeff Obtain extinction coefficient normalized
            %for each light source spectra
            %   make sure light source and extinction spectra files are
            %   determined
            
            [sourceSpectra,extCoeff,~] = obj.getSpectra();
            
            for sourceInd = 1:numel(sourceSpectra)
                % Spectroscopy Matrix
                E(sourceInd,:)=extCoeff'*sourceSpectra{sourceInd};
            end
        end
        
        function dp = getDiffPath(obj)
            %getDiffPath Obtain diff path length assuming semi-infinite
            %medium
            %   make sure light source and extinction spectra files are
            %   determined
            
            [sourceSpectra,extCoeff,lambda] = obj.getSpectra();
                                    %%
     fid=fopen('C:\Users\xiaodanwang\Downloads\pathlengths.txt');
        
    temp=textscan(fid,'%f %f','headerlines',0);
    fclose(fid);
   lambda3= temp{1};
    dp_hillman= temp{2};
dp_hillman = interp1(lambda3,dp_hillman,lambda,'pchip');
            
            %%

            
            
            
            c = obj.LightSpeed/obj.InternalIndexOfRefraction;
            
            for sourceInd = 1:numel(sourceSpectra)
                %%
                    
                            % interpollate from Hillman wavelength to reference wavelengths
       
                dp(sourceInd) = dp_hillman'*sourceSpectra{sourceInd}/10;
                
                %%
%                 % Spectroscopy Matrix
%                 E(sourceInd,:)=extCoeff'*sourceSpectra{sourceInd};
%                 
%                 musp = obj.Musp(lambda,sourceSpectra{sourceInd});
%                 
%                 dp(sourceInd) = mouse.physics.diffPath(c,musp,E(sourceInd,:),obj.Concentration);
            end

            
            
            
            
        end
    end
end

