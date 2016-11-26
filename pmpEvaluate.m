function [ continualCands ] = pmpEvaluate( detection )
%pmpEvaluate Outputs a vector containing candidates that have persisted over nFrames.
%   
%   For use with FACT acoustic feedback simulation function. Requires input structure
%   'detection', which must include the following fields:
%   
%   detection.bufferlength: A scalar indicating the length of the magnitudeHistory buffer
%   (number of data frames that are saved).
%
%   detection.primary.nframes: Number of past frames in which a particular bin must have
%   appeared as a howl candidate before this function flags it as howl.
%
%   detection.binsToCheck: A vector indicating which frequency bins to check for howl. This is
%   set in FACT by a standard peak-picking algorithm or a secondary detection stage, depending
%   on how the simulation has been set up. If neither of these are in use, binsToCheck includes
%   the entire frequency spectrum.
%
%   detection.maxHowls: A scalar indicating the maximum number of howls that this function will
%   identify (usually set to the same number as the number of available notch filters).

bufferLength = detection.bufferlength;
nFrames = detection.primary.nframes;
candidates = detection.binsToCheck;
maxCandidates = detection.maxHowls;

persistent candidateHistory;

if isempty(candidateHistory) % initialisation of buffer
    candidateHistory = zeros(maxCandidates, bufferLength);
end

candidateHistory = circshift(candidateHistory,[0 1]); % shift old data
candidates = vertcat(candidates, zeros(maxCandidates - length(candidates), 1));
candidateHistory(:,1) = candidates; % add new data
continualCands = zeros(length(candidateHistory(:,1)),1); % initialise output

for i = 1:length(candidateHistory(:,1))
    if candidateHistory(i) ~= 0
        if sum(sum(candidateHistory == candidateHistory(i))) >= nFrames
            continualCands(i) = candidateHistory(i);
        end
    end
end

continualCands(continualCands==0)=[]; % remove excess zeros
    
end

