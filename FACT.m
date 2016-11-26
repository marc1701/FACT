function [ simulation,detection,filterdata ] = FACT( simulation,detection )
%   The Feedback Analysis and Cancellation Toolkit (FACT)
%   
%   by Marc Ciufo Green
%
%   Creates a virtual acoustic feedback loop as if between a single speaker and a single
%   microphone. Allows testing of the effectiveness of various methods of feedback howl
%   detection and various methods of feedback howl cancellation. The code is split into three
%   main sections: 
%
%   **********************************SIMULATION*********************************** 
%   The main overlap/add convolution process that is designed to cause realistic buildup of
%   virtual acoustic feedback howls.
%
%   ***INPUT***: Structure containing the following fields:
%
%   simulation.IR : string specifying RIR audio file to use as the acoustic return path in the
%   simulation. The sampling frequency of this file specifies the fs of the entire simulation.
%   Specified RIR must be monaural.
%   
%   simulation.stimulus: string specifying audio file to use as 'desired' mic input signal. Fs
%   of stimulus must match fs of RIR, and must also be monaural.
%   
%   simulation.gain: value for desired loop gain of simulation, in dB. It can be useful to use
%   loopResponseAnalysis prior to setting up FACT to determine the Maximum Stable Gain of the
%   RIR intended for use. loopResponseAnalysis is also run as part of FACT, and its predictions
%   for likely howl frequencies are dependent on the gain level set here.
%
%   simulation.latency: value, in samples, for the latency inherent in digital sound
%   reinforcement systems. Must be a power of 2 (default 64).
%
%   simulation.length: length, in seconds, for the total simulated time (this will be the
%   length of the output file). If simulation.stimulus is shorter than simulation.length, or
%   simulation.length is unspecified, the simulation will run for the full length of the
%   stimulus.
%
%   simulation.plotCharts: string indicating the x-axis format for the live-updating chart of
%   the simulation. 'lin' plots frequency on a linear scale, and 'log' plots frequency
%   logarithmically. 'none' prevents plotting. (Default 'lin').
%
%   ***OUTPUT***
%
%   simulation.output: Audio file of the 'microphone signal' being passed to the 'loudspaeaker'
%   for the entirety of the loop. 
%
%   Output structure will also contain all input parameters for reference.
%   
%   **********************************DETECTION*********************************** 
%
%   ***INPUT***: Structure including the following fields:
%   
%   detection.primary: Substructure specifying primary method of howl identification:
%   detection.primary.type: string - 'MSD', 'PMP', 'PAPR', 'PNPR', 'PHPR', 'PTPR' or 'none'.
%   
%   'PMP' requires: 
%   detection.primary.nframes: Number of frames in which probable howl ID must have persisted.
%   Must not exceed detection.bufferlength
%   
%   'PAPR', 'PNPR', 'PHPR' or 'PTPR' require:
%   detection.primary.threshold: Threshold ratio that triggers positive ID of howl.
%   
%   detection.secondary: Substructure specifying secondary method of howl identification. Set
%   up as above, however 'PMP' cannot be used as secondary howl ID method. The output
%   candidates from secondary howl analysis are passed to primary analysis. Leave unspecified
%   for no secondary analysis.
%   
%   detection.findpeaksActive: 'y' or 'n'. Enables or disables standard MATLAB peak-picking
%   algorithm findpeaks as a first stage in howl identification (default 'n').
%
%   detection.maxHowls: Maximum number of howls that can be identified simultaneously. 
%   (default 8).
%
%   detection.bufferlength: Number of frequency magnitude frames to be kept in magnitude
%   history buffer.analysis (default 16).
%
%   detection.analysis: Substructure specifying FFT analysis parameters:
%
%   detection.analysis.framelength: Number of samples used for analysis frame (default 256)
%
%   detection.analysis.overlap: Frame overlap percentage (default 75%)
%
%   detection.analysis.fs: FFT resampling frequency. Set to double analysis frequency range
%   (default 4410);
%   
%   ***OUTPUT***: detection structure including all input parameters for reference.
%   
%   **********************************DESTRUCTION*********************************** 
%
%   ***INPUT*** String:
%   'notchFilters': Use bank of 8 notch filters for howl cancellation.
%   'bandpassFilters': Use bank of octave-band bandpass filters for howl cancellation (note
%   that this option is unfinished). Defaults to 'notchFilters'.
%
%   ***OUTPUT*** filterdata Structure
%   Includes data on the how the filters changed over time, along with a timestamp that
%   specifies when (simulated time in seconds) these changes occurred. Also includes final
%   aggregated magnitude response curve of the filters.
%
%   ********************************************************************************
%
%   Example #1: Findpeaks active, secondary analysis PAPR (20dB threshold) and primary analysis
%   PMP (8 frame persistence). -15dB loop gain. Linear chart plot:
%   
%   detection.findpeaksActive = 'y'; 
%   detection.secondary.type = 'PAPR';
%   detection.secondary.threshold = 20;
%   detection.primary.type = 'PMP';
%   detection.primary.nframes = 8;
%
%   simulation.stimulus = 'exampleStimulus.wav';
%   simulation.IR = 'exampleIR.wav';
%   simulation.gain = -15;
%
%   [sim,det,filtData] = FACT(simulation,detection);
%
%   Example #2: Primary analysis MSD, bufferlength 16 (default).
%
%   detection.primary.type = 'MSD';
%   simulation.stimulus = 'exampleStimulus.wav';
%   simulation.IR = 'exampleIR.wav';
%   simulation.gain = -15;
%
%   [sim,det,filtData] = FACT(simulation,detection);
%   
%   by Marc Ciufo Green
%   Audiolab
%   Department of Electronics
%   University of York
%
%   Thanks to my supervisors Dr. John Szymanski and Dr. Matthew Speed
%   
%   Thanks to Robert Bemis for round2 
%   http://uk.mathworks.com/matlabcentral/fileexchange/4261-round2/content/round2.m 
%
%   Thanks to sparafucile17 for save_fig
%   http://www.dsprelated.com/showcode/223.php

% Reset any persistent variables and plots from last run
clear notchFilters; clear plotData; clear gainset; clear pmpEvaluate; close all;

if ~isfield(simulation,'plotCharts'); simulation.plotCharts = 'lin'; end

% *********************** CONVOLUTION VARIABLES ***********************      
if ~isfield(simulation,'latency'); simulation.latency = 64; end

[simulation.IR, simulation.fs] = audioread(simulation.IR); % load IR and get fs
simulation.divisionfactor = ... % determine division factor required for specified gain
    divisionFactorCalc(simulation.IR,simulation.latency,simulation.gain);
simulation.IR = simulation.IR/simulation.divisionfactor; % division acts as gain control
simulation.stimulus = audioread(simulation.stimulus); % load stimulus sound (i.e. mic input)

if ~isfield(simulation,'length'); % set to full length of stimulus if unspecified
    simulation.length = length(simulation.stimulus)/simulation.fs;
end

if (simulation.length * simulation.fs) > length(simulation.stimulus)
    warning(['Specified simulation length is longer than length of stimulus audio. '...
        'Simulation will run to length of stimulus sound only.']);
else % trim to specified simulation length
    simulation.stimulus = simulation.stimulus(1:(simulation.length * simulation.fs));
end

inputlength = length(simulation.stimulus); % get number of samples in source signal
framesize = simulation.latency*2; % find number of samples per convolution frame
% find number of samples in simulation.output convolution
convlength = (framesize + length(simulation.IR) - 1); 
stepsize = framesize/2; % step size for overlap/add
nframes = floor(inputlength / stepsize) - 1; % total number of simulation frames
outputlength = inputlength + convlength - stepsize; % total number of samples in output
% pad stimulus to account for convolution
simulation.stimulus = vertcat(simulation.stimulus,zeros(outputlength - inputlength, 1));
simulation.output = zeros(outputlength, 1); % initialise output vector
w = hann(framesize, 'periodic'); % generate the hann function to window a frame

audiomax = 1; % set audio range for simulation.output
audiomin = -1; % worth noting that this doesn't have to be 1 
                                                                            
loopResponseAnalysis(simulation.IR,simulation.latency,simulation.fs); % IR analysis plot
% display('Click on chart or press return to continue.'); waitforbuttonpress;
if isfield(simulation,'plotCharts'); figure(2); set(gcf,'Position',[1 1 1280 701]); end % prepare figure 2 for live plot

% ************************ ANALYSIS VARIABLES *************************
if ~isfield(detection,'analysis'); % set unspecified fields to default values
    detection.analysis.framelength = 256;
    detection.analysis.overlap = 75;
    detection.analysis.fs = 4410;
end

if ~isfield(detection,'bufferlength'); detection.bufferlength = 16; end

if ~isfield(detection,'maxHowls'); detection.maxHowls = 8; end

% fraction calculation for analysis fs reduction
[l,m] = rat(detection.analysis.fs/simulation.fs);
% number of overlapping samples in each successive analysis frame
detection.analysis.stepsize = detection.analysis.framelength * ...
    (1-(detection.analysis.overlap/100)); 
% minimum convolution frames before enough samples accumulated for analysis
detection.analysis.minframes = detection.analysis.framelength / (stepsize*(l/m));
% convolution frames needed for enough samples for next analysis frame
detection.analysis.stepframes = detection.analysis.stepsize / (stepsize*(l/m));
% bandwidth of frequency bins
detection.analysis.binbandwidth = detection.analysis.fs/detection.analysis.framelength;

detection.n = 0; % freqAnalysis output counter
% set up xAxis values - used for lookup of frequencies as well as graph
detection.xAxisLength = detection.analysis.framelength/2;
detection.xAxis = linspace(0,((detection.xAxisLength-1) * ...
    detection.analysis.binbandwidth),detection.xAxisLength)';
detection.magnitudeHistory = zeros(detection.xAxisLength,detection.bufferlength);

% *********************************************************************
% ********************** CONVOLUTION SECTION **************************
% *********************************************************************

framestart = 1;
for n = 1:nframes
    % get current frame of audio from stimulus vector
    thisFrame = simulation.stimulus(framestart:framestart + framesize -1);  
    
    nextframe = framestart + stepsize; % establish next frame
    
    % if notch filter frequencies have been specified
    if exist('filterdata','var') && ~nnz(filterdata.frequencies) == 0
        for k = 1:nnz(filterdata.frequencies(:,1)) % apply notch filter(s)
            thisFrame = filter(filterdata.b(k,:),filterdata.a(k,:),thisFrame);
        end   
    end
    
    windowed = w .* thisFrame; % apply hann window
    
    % add filtered sound to output vector (not convolved with room IR)
    simulation.output(framestart : framestart + framesize - 1) = ... 
    simulation.output(framestart : framestart + framesize - 1) + windowed;

    simulation.signal = conv(windowed,simulation.IR); % convolve IR with this frame
    
    % add to next frame of source
    simulation.stimulus(nextframe : nextframe + convlength - 1) = ... 
        simulation.stimulus(nextframe : nextframe + convlength - 1) + simulation.signal;
        
    % clip to specified audio range
    simulation.stimulus(simulation.stimulus > audiomax) = audiomax;
    simulation.stimulus(simulation.stimulus < audiomin) = audiomin;
    
    simulation.output(simulation.output > audiomax) = audiomax;
    simulation.output(simulation.output < audiomin) = audiomin;
    
    framestart = nextframe; % advance to next frame
    
    
% *********************************************************************
% ************************ DETECTION SECTION **************************
% *********************************************************************
    
    % if enough frames have passed to give FFT enough samples and current frame is a multiple
    % of frames required for analysis step
    if n >= detection.analysis.minframes && mod(n,detection.analysis.stepframes) == 0;
  
% ************************ FREQUENCY ANALYSIS *************************         
        windowStart = (n*stepsize) - ((detection.analysis.framelength/(l/m)) - 1);
        windowEnd = n*stepsize;
        dataToAnalyse = simulation.output(windowStart:windowEnd);
        
        % if analysis cutoff has been set to below nyquist
        if detection.analysis.fs <= simulation.fs 
            if mod(simulation.fs,detection.analysis.fs) ~= 0
                error('Analysis fs must be factor of simulation fs');
            end
            dataToAnalyse = resample(dataToAnalyse,l,m);
        else
            error('Error: Analysis fs cannot be higher than simulation fs');
        end
        
        % freqAnalysis has hann windowing built in
        [~, detection.XdB] = freqAnalysis(dataToAnalyse); 
        detection.n = detection.n + 1; % increment analysis output counter    
        
        detection.magnitudeHistory = circshift(detection.magnitudeHistory,[0 1]);
        detection.magnitudeHistory(:,1) = detection.XdB; % add new data
        
% ************************** HOWL DETECTION ***************************
        if isfield(detection,'findpeaksActive') && detection.findpeaksActive == 'y'; 
            [~, detection.binsToCheck] = ... % optional standard peak-picking algorithm
                findpeaks(detection.XdB,'sortstr','descend','NPeaks',detection.maxHowls);
            
        else % if peak-picking not active, algorithms search all bins
            detection.binsToCheck = linspace(1,detection.xAxisLength,detection.xAxisLength)';
        end

        if isfield(detection,'secondary'); % if secondary analysis type is specified
            switch detection.secondary.type
                case {'PAPR','PHPR','PNPR','PTPR'}
                    detection.secondary.candidates = peakRatioEvaluate(detection,'secondary');
                case 'MSD'
                    detection.secondary.candidates = msdEvaluate(detection);
                otherwise
                    error('Error: Secondary analysis selection invalid');
            end
            % set nBin to secondary howl IDs 
            % (this is how secondary analyses are combined with primary)
            detection.binsToCheck = detection.secondary.candidates;
        end
        
        switch detection.primary.type
            case 'PMP'
                % if nBin is longer than detection.maxHowls, this indicates that primary 
                % analysis will still be looking at whole spectrum. PMP analysis is not 
                % appropriate in this case.
                if length(detection.binsToCheck) > detection.maxHowls       
                    error(['Error: PMP can only be used as primary analysis if peak-picking'...
                        'algorithm or secondary analysis are in use.']);
                else
                    detection.primary.candidates = pmpEvaluate(detection);
                end
            case 'MSD'
                detection.primary.candidates = msdEvaluate(detection,'primary');%remember to GET RID
            case {'PAPR','PHPR','PNPR','PTPR'}
                detection.primary.candidates = peakRatioEvaluate(detection,'primary');
            case 'none'
                detection.primary.candidates = [];
        end

% *********************************************************************
% ************************* FILTER SECTION ****************************
% *********************************************************************
        
        % get filter data from notchFilters function
        filterdata  = notchFilters(detection,simulation,n);
        
        if ~strcmp(simulation.plotCharts,'none'); % if plotting type is specified, plot chart
                plotData(simulation,detection,filterdata);
        end 
    end     
end
                              
% strip zeros from filterdata outputs
filterdata.magnitudes = filterdata.magnitudes(:,any(filterdata.magnitudes));
filterdata.frequencies = filterdata.frequencies(:,any(filterdata.frequencies));
filterdata.depths = filterdata.depths(:,any(filterdata.depths));
filterdata.timestamp(filterdata.timestamp == 0) = [];
filterdata.magnitudes(~any(filterdata.magnitudes,2),:) = [];
filterdata.frequencies(~any(filterdata.frequencies,2),:) = [];
filterdata.depths(~any(filterdata.depths,2),:) = [];

csvSave;

end
    