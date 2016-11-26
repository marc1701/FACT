function [ X, XdB ] = freqAnalysis( frame )
%freqAnalysis Automatically applies hann window to input time-domain frame, and returns fft
%magnitude power spectrum, also converted to decibel scale.

w = window(@hann, length(frame)); % define hann window

windowed = frame .* w;

X = real(abs(fft(windowed))); % get magnitude spectrum of frame
X = X(1 : (length(X)/2)); % remove mirrored upper half of fft output
XdB = 20*log10(X); % convert to dB scale

end

