function [ candidates,magnitudeHistoryOut ] = msdEvaluate( detection,instance )
%msdEvaluate Calculates the Magnitude Slope Deviation of all data points
%in magnitude data buffer. Uses double-differentiation to
%identify straight-line magnitude growth (dB scale) of component
%frequencies.
%   Detailed explanation goes here

magnitudeHistory = detection.magnitudeHistory;
nCandidates = detection.maxHowls;
nBin = detection.binsToCheck;
bufferlength = detection.bufferlength;

switch instance
    case 'primary'
        evaluationType = detection.primary.evaluation;
        if strcmp(evaluationType,'full')
            gradientTolerance = detection.primary.tolerance;
            devcountPercentage = detection.primary.devcountPercentage;
        end
    case 'secondary'
        evaluationType = detection.secondary.evaluation;
        if strcmp(evaluationType,'full')
            gradientTolerance = detection.secondary.tolerance;
            devcountPercentage = detection.secondary.devcountPercentage;
        end
end

gradChange = diff(magnitudeHistory,2,2);

if sum(abs(magnitudeHistory(:,bufferlength))) > 0 % once history buffer is full
    switch evaluationType
        case 'full'
            candidates = zeros(nCandidates, 1); % initialise output vector
            for q = 1:length(nBin) % loop through frequency bins
                devcount = 0; % initialise/reset devcount
                for p = 1:length(gradChange(1,:)) % loop through gradient values
                        % if gradient change is +-tolerance (reasonably near 0)
                        if abs(gradChange(nBin(q),p)) <= gradientTolerance 
                            devcount = devcount + 1; % add 1 to counter
                        else
                            devcount = devcount - 1; % take 1 from counter
                        end 
                end

                if devcount >= (devcountPercentage / 100) * ...
                        length(gradChange(1,:)) % if more than *percentage* gradient points are near 0
                    n = find(candidates==0, 1, 'first');
                    candidates(n) = nBin(q); % flag frequency as howl
                end
            end
            candidates(candidates==0)=[]; % remove excess zeros

        case 'summing'
            gradChange = gradChange(nBin,:);
            sumSquared = sum(abs(gradChange).^2,2);
            candidates = nBin(sumSquared < (bufferlength/16));
    end
else
    candidates = [];
end

if length(candidates) > nCandidates % if there are too many candidates
    meanGrads = mean(diff(magnitudeHistory,1,2),2); % prioritise those with steepest gradient 
    [~,grdIdx] = sort(meanGrads(candidates),'descend');               % (fastest growing howl)
    candidates = grdIdx(1:nCandidates);
end

magnitudeHistoryOut = magnitudeHistory;

end


