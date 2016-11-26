function [ b, a ] = iirnotchHz( centre_freq, bandwidth, depth, fs )
%iirnotchHz Takes filter centre frequency and sample rate, returns difference equation
%coefficients for notch filter.

w0 = (2*centre_freq)/fs;
bw = (2*bandwidth)/fs;

[b,a] = iirnotch(w0,bw,depth);

end

