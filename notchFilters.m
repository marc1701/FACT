function [ filterdata ] = notchFilters( detection,simulation,n )
%notchFilters Returns data for notch filters to negate feedback howl.
%
%   For use with the FACT acoustic feedback simulation function. Takes two input structs,
%   'detection' and 'simulation', which must include the following fields:
%
%   *** DETECTION *** detection.analysis.binbandwidth: scalar indicating bandwidth of fft
%   frequency bins.
%
%   detection.bufferlength: A scalar indicating the length of the magnitudeHistory buffer
%   (number of data frames that are saved).
%
%   detection.primary.candidates: A vector containing frequency bins in which potential
%   feedback howl has been identified.
%
%   detection.magnitudeHistory: A matrix including current and past values for frequency
%   magnitudes from fft frequency analysis. This is generated as part of FACT.
%
%   detection.xAxis: Vector containing the centre frequencies of each fft frequency bin
%   (doubles as x-axis for plots).
%
%   ***SIMULATION*** simulation.fs: Sampling frequency for feedback simulation.
%
%   simulation.latency: Simulated digital latency (in samples).
%
%   n: Counter indicating how long FACT has been running.
%
%   ****************
%
%   Returns 'filterdata' structure, which includes the following fields:
%   
%   filterdata.a/filterdata.b: Difference equation coefficients for set of up to 8 notch
%   filters (8x3 matrices).
%
%   filterdata.magnitudes: Magnitudes of howl peaks upon introduction of filters.
%
%   filterdata.frequencies: Centre frequencies of each filter.
%
%   filterdata.depths: Depths of each filter.
%
%   filterdata.timestamp: Vector of values indicating time (in seconds) when changes to filters
%   took place (e.g. introduction of filter, change of depth, change of frequecy will all write
%   a new timestamp value). Note this is simulated time (which corresponds to time in FACT's
%   audio output file) rather than real time.

persistent b
persistent a
persistent peakFreqs
persistent peakMags
persistent peakBins
persistent depth
persistent timeStamp
persistent attentionBins

if isempty(b) % first-run setup of variables
    b = zeros(8,3);
    a = zeros(8,3);
    peakFreqs = zeros(8,1000);
    peakBins = zeros(8,1000);
    peakMags = zeros(8,1000);
    depth = zeros(8,1000);
    timeStamp = zeros(1,1000);
    attentionBins = zeros(8,1);
end

if detection.bufferlength < 3
    error('Buffer length must be 3 or greater for MSD notch depth setting');
end

width = detection.analysis.binbandwidth;

% find new incoming howl candidates
newCands = setdiff(detection.primary.candidates,attentionBins); 
if ~isempty(newCands)
    attentionBins = vertcat(attentionBins, newCands); % add to vector of current candidates
end
attentionBins(attentionBins == 0) = [];

for f = 1:length(attentionBins)
    % find any filter already at candidate bin
    existingFilter = find(peakBins(:,1) == attentionBins(f)); 
    
    if isempty(existingFilter) % if no filter already at candidate bin
        filterToUse = find(peakMags(:,1) == 0,1); % use first free filter
        if isempty(filterToUse) 
            % if no free filter, use filter suppressing lowest magnitude howl
            filterToUse = find(peakMags(:,1) == min(peakMags(:,1)),1);      
        end
    else % use the filter already there
        filterToUse = existingFilter; 
    end

    grad = diff([detection.magnitudeHistory(attentionBins(f),2), ...
        detection.magnitudeHistory(attentionBins(f),1)]);
    lastGrad = diff([detection.magnitudeHistory(attentionBins(f),3), ...
        detection.magnitudeHistory(attentionBins(f),2)]);
    
    % gradient must be consistently positive (or close), max depth -25dB
    if grad > -0.5 && lastGrad > -0.5 && depth(filterToUse) > -25           
        depth(filterToUse) = depth(filterToUse)-1; % incrementally increase depth by 1dB
    end
    if diff([depth(filterToUse,2) depth(filterToUse,1)]) == 0 
        % if depth has not changed over 2 iterations
        attentionBins(f) = 0; % remove frequency from attention
        filterToUse = [];
    end
    
    if ~isempty(filterToUse) % if there's a filterToUse variable
        peakFreqs = circshift(peakFreqs,[0 1]); % shift and store historical data in buffer
        peakMags = circshift(peakMags,[0 1]);
        peakBins = circshift(peakBins,[0 1]);
        depth = circshift(depth,[0 1]);
        timeStamp = circshift(timeStamp,[0 1]);
        peakBins(:,1) = peakBins(:,2);
        peakFreqs(:,1) = peakFreqs(:,2);                                
        peakMags(:,1) = peakMags(:,2);
        depth(:,1) = depth(:,2);
        
        peakBins(filterToUse) = attentionBins(f);
        peakFreqs(filterToUse) = round2(detection.xAxis(attentionBins(f)),1);
        peakMags(filterToUse,1:detection.bufferlength) = ...
            detection.magnitudeHistory(attentionBins(f),:);
        
        % assign b and a coefficients to filter
        [b(filterToUse,:), a(filterToUse,:)] = ...
            iirnotchHz(peakFreqs(filterToUse),width,depth(filterToUse),simulation.fs);
            
        timeStamp(1) = (n*simulation.latency)/simulation.fs; % store timestamp in seconds
    end
end

filterdata.a = a; % place data into struct ready for output
filterdata.b = b;
filterdata.magnitudes = peakMags;
filterdata.frequencies = peakFreqs;
filterdata.depths = depth;
filterdata.timestamp = timeStamp;

end
