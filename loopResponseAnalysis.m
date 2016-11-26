function [ MSG, howlFreqs ] = loopResponseAnalysis( IR, latency, fs )
%loopResponseAnalysis Plots acoustic feedback parameters of input RIR.
%
%   by Marc Ciufo Green
%   
%   Required input arguments:
%   
%   IR: either a vector containing a monaural room impulse response, or a string pointing to a
%   WAV file containing monaural IR information.
%   
%   Optional input arguments:
%   
%   latency: Numeric value indicating latency, in samples, of a digital sound reinforcement
%   system. If unspecifed, latency will be set to 0.
%   
%   fs: Sampling frequency. Required if IR is passed a vector rather than a string.
%   
%   Example usage:
%
%   loopResponseAnalysis('sampleIR.wav'); 
%   Opens sampleIR.wav and plots magnitude response of chart (dB scale) overlaid with dotted
%   lines representing MSG (red), safe gain (green), and current gain (cyan). Stability margin
%   is shaded in yellow. Red triangles indicate frequencies with potential to howl.
%   
%   loopResponseAnalysis(sampleIR,64,44100,20); 
%   Reads from vector sampleIR, zero pads vector with 64 samples to represent digital
%   latency, Plots chart as above, incorporating specified parameters into analysis.
%
%   [MSG,howlfreqs] = loopResponseAnalysis(sampleIR,64,44100); 
%   As above, but returns scalar indicating MSG, and vector containing values of frequencies
%   which are likely to howl.

if ischar(IR) % if input IR value is a string, open from file
    [IR, fs] = audioread(IR);
end

if exist('latency', 'var'); % account for latency if required
    IR = vertcat(zeros(latency,1),IR);
end

% zero-pad IR to give 1Hz frequency bin resolution
IR = vertcat(IR, zeros((floor(fs) - length(IR)), 1)); 

analysis = fft(IR); % FFT frequency analysis
analysis = analysis(1:floor(length(analysis)/2));
X = real(abs(analysis));
Xphase = angle(analysis);
XdB = 20*log10(X);

MLG = mean(abs(X).^2); % calculate Mean Loop Gain
meanIRGain = 10*log10(MLG); % find current gain of IR

xFreqs = linspace(0,(fs/2)-1,length(IR)/2)'; % x-axis frequency values

% find locations of frequencies with phase close to 0
zeroPhaseLocs = find(Xphase > -0.1 & Xphase < 0.1);
                                                                            
XdBinPhase = XdB(zeroPhaseLocs); % loop phase close to 0
yMarkers = XdBinPhase(XdBinPhase >= 0); % loop gain exceeding unity
n = ismember(XdB,yMarkers); % find indeces of probable howl frquencies
howlFreqs = xFreqs(n); % get howl frequencies

XinPhase = X(zeroPhaseLocs); % magnitude data only from frequencies fulfilling phase condition

peakGain = max(abs(XinPhase).^2); % find MSG value
MSG = -10*log10(peakGain / MLG);
stabilityMargin = MSG - 6;

semilogx(xFreqs, XdB, howlFreqs, yMarkers, 'rv'); % plot chart of analysis data
title('Loop Response Analysis');
hold on

% fill 'danger area' in yellow
xFill = vertcat(xFreqs(21:length(xFreqs)),flipud(xFreqs(21:length(xFreqs))));
yFill = ...
    vertcat((repmat(MSG,(length(xFill)/2),1)),(repmat(stabilityMargin,(length(xFill)/2),1)));
    
h = fill(xFill,yFill,'y');
set(h,'facealpha',0.1);
set(h,'EdgeColor','None'); 

% plot dotted lines denoting MSG, safe gain (6dB stability margin)
semilogx([xFreqs(20),xFreqs(length(xFreqs))],[MSG,MSG],'--r',...    
    [xFreqs(20),xFreqs(length(xFreqs))],[meanIRGain,meanIRGain],'--c');
%     [xFreqs(20),xFreqs(length(xFreqs))],[stabilityMargin,stabilityMargin],'--g',...
    

% create text objects on chart displaying MSG and current gain values
text(30,MSG-40,['MSG = ',num2str(MSG,4),'dB'],'FontSize',11);
text(30,MSG-45,['Current Gain = ',num2str(meanIRGain,4),'dB'],'FontSize',11);
ylabel('Magnitude [dB]');
xlabel('Frequency [Hz]');
xlim([20, fs/2]);
ax = gca; % set frequency axis tick markers
set(ax, 'XTick', [20 40 80 160 320 640 1280 2560 5120 10240 20000]);

end

