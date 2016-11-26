function [ divisionFactor ] = divisionFactorCalc( IR, latency, gainTarget )
%divisionFactorCalc Returns division factor to give input RIR desired loop gain value.
%   
%   by Marc Ciufo Green
%   
%   Input arguments:
%   
%   IR: either a vector containing a monaural room impulse response, or a string pointing to a
%   WAV file containing monaural IR information.
%
%   latency: Numeric value indicating latency, in samples, of a digital sound reinforcement
%   system. If unspecifed, latency will be set to 0.
%
%   gainTarget: desired loop gain (dB) for analysis/simulation using input RIR.
%
%   Example usage: divisionFactor = divisionFactorCalc('sampleIR.wav',64,-15); 
%   Reads sampleIR.wav file and applies 64 zeros to account for digital latency. Calculates
%   value with which to divide IR data in order to achieve desired loop signal gain in analysis
%   or simulation.

if ischar(IR) % if input IR value is a string, open from file
    IR = audioread(IR);
end

IR = vertcat(zeros(latency,1),IR); % account for latency if required

analysis = fft(IR); % calculate frequency magnitude response of IR 
analysis = analysis(1:length(analysis)/2);
X = real(abs(analysis));

MLG = mean(abs(X).^2); % find Mean Loop Gain and convert to dB scale
meanIRGain = 10*log10(MLG);

reqdBLoss = gainTarget - meanIRGain; % calculate IR division factor to achieve desired gain 
divisionFactor = 0.5^(reqdBLoss/6);
% multFactor = 2^(reqdBLoss/6);

end

