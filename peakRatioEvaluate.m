function [ candidates, ratios ] = peakRatioEvaluate( detection, instance )
%peakRatioEvaluate Incorporates PHPR, PNPR, PTPR and PAPR analysis into one 
%function.
%
%   For use with the FACT acoustic feedback simulation function. Takes input structure
%   'detection', which must include the following fields:
%
%   detection.XdB: Magnitude data from the current FFT analysis frame.
%
%   detection.maxHowls: A scalar indicating the maximum number of howls that this function will
%   identify (usually set to the same number as the number of available notch filters).
%
%   detection.binsToCheck: A vector indicating which frequency bins to check for howl. This is
%   set in FACT by a standard peak-picking algorithm or a secondary detection stage, depending
%   on how the simulation has been set up. If neither of these are in use, binsToCheck includes
%   the entire frequency spectrum.
%
%   detection.primary.type/detection.secondary.type: string indicating which ratio to use for
%   analysis:
%
%   'PHPR': Peak-to-Harmonic Power Ratio - Note this will only analyse lower half of input
%   magnitude spectrum. Above this, data on harmonic frequencies is not available.
%   
%   'PNPR': Peak-to-Neighbouring Power Ratio - Calculates average PNPR using bins above and
%   below the bin in question. The analysis for the lowest and highest frequency bins uses only
%   the bin above or below, respectively.
%
%   'PAPR': Peak-to-Average Power Ratio - Must de-log input dB-scale data in order to find
%   average power.
%
%   'PTPR': Peak-to-Threshold Power Ratio.
%
%   detection.primary.threshold/detection.secondary.threshold: dB value for ratio threshold
%   which, if exceeded, will trigger a positive howl ID.
%
%   instance: String 'primary' or 'secondary' indicating whether peak ratio analysis is being
%   used as primary or secondary analysis in the present FACT simulation. Whether
%   peakRatioEvaluate reads detection.primary or detection.secondary data depends on this
%   input.

fftFrame = detection.XdB;
nCandidates = detection.maxHowls;
nBin = detection.binsToCheck;

switch instance
    case 'primary' % read correct function parameters
        ratioType = detection.primary.type;
        threshold = detection.primary.threshold;
    case 'secondary'
        ratioType = detection.secondary.type;
        threshold = detection.secondary.threshold;
end

ratios = zeros(length(nBin), 1); % prepare output vector

for i = 1:length(nBin)
    switch ratioType
        case 'PHPR'
            if nBin(i) < (length(fftFrame)/2) % calculate ratio for each specified bin
                ratio = fftFrame(nBin(i)) - fftFrame(2*nBin(i));
            else
                ratio = [];
            end
            
        case 'PNPR'
            if nBin(i) < 2 % for the lowest bin
                % use only bin above to calculate ratio
                ratio = fftFrame(nBin(i)) - fftFrame(nBin(i)+1);
            elseif nBin(i) > length(fftFrame)-2 % for the highest bin
                % use only bin below to calculate ratio
                ratio = fftFrame(nBin(i)) - fftFrame(nBin(i)-1);
            else % all other bins calculated by averaging above/below
                PNPRu = fftFrame(nBin(i)) - fftFrame(nBin(i)+1);
                PNPRl = fftFrame(nBin(i)) - fftFrame(nBin(i)-1);
                ratio = (PNPRu + PNPRl)/2;
            end
                    
        case 'PAPR'
            X = 10.^(fftFrame/20); % de-log frame to find average
            ratio = 10 * log10( (X(nBin(i))^2) / (mean(X)^2) );
            
        case 'PTPR'
            ratio = fftFrame(nBin(i));
    end
    
    if ratio > threshold
        ratios(i) = ratio; % save ratio
    end 
end

if any(ratios)
    [ratios,idx] = sort(ratios,'descend');
    ratios(ratios==0)=[]; % remove excess zeros
    idx = idx(1:length(ratios));
    candidates = nBin(idx);

    if length(ratios) > nCandidates % if too many candidates have been identified
        ratios = ratios(1:nCandidates); % highest ratios become candidates
        candidates = candidates(1:nCandidates);
    end
else
    ratios = [];
    candidates = [];
end

end

