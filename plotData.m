function [ filterx,filtery ] = plotData( simulation,detection,filterdata )
%plotData Creates live-updating plots based in incoming data from FACT.
%
%   For use with the FACT acoustic feedback simulation function.
%   
%   Required inputs: plotFormat: 'lin' or 'log' - specifies whether frequency axis is linear or
%   logarithmic.
%
%   **********
%
%   detection: Structure that must include:
%
%   detection.xAxis: Vector containing the centre frequencies of each fft frequency bin.
%
%   detection.XdB: Magnitude data from the current FFT analysis frame.
%
%   detection.primary.candidates: A vector containing frequency bins in which potential
%   feedback howl has been identified.
%
%   and can optionally include detection.secondary.candidates: A vector containing frequency
%   bins that secondary howl analysis has flagged as potential howl frequencies.
%
%   **********
%
%   filterdata: Structure that must include:
%
%   filterdata.b/filterdata.a: Difference equation coefficients for set of up to 8 notch
%   filters (8x3 matrices).
%
%   filterdata.frequencies: Centre frequencies of each filter.
%
%   **********
%
%   Sets up a plot that shows current frame of frequency magnitude data (blue line) overlaid
%   with current aggregated filter magnitude response curve (green line). Red triangles
%   indicate howl frequncies that have been identified by primary analysis (this is the data
%   that is sent to the notch filter function), and magenta triangles indicate potential howl
%   frequencies that have been identified by secondary analysis (if in use).
%
%   Returns: filterx,filtery: Filter frequency magnitude response based on input filterdata.
%   This is useful to get information on the final state of notch filter bank upon conclusion
%   of a FACT simulation.

persistent spectrum
persistent filterPlot
persistent candPlot
persistent sPlot

if isempty(spectrum)
    switch simulation.plotCharts
        case 'lin'
            spectrum = plot(detection.xAxis,detection.XdB); % initialise graphs for data
            hold on
            filterPlot = plot(detection.xAxis,nan,'green');
            candPlot = plot(detection.xAxis,nan,'rv');
            sPlot = plot(detection.xAxis,nan,'mv');
            ax = gca; % set frequency axis tick markers
            xTicks = round2((linspace(20,detection.xAxis(length(detection.xAxis)),10)),10); 
            xTicks(length(xTicks)) = round2(detection.xAxis(length(detection.xAxis)),10);
            set(ax,'XTick',xTicks);
        case 'log'
            spectrum = semilogx(detection.xAxis,detection.XdB);
            hold on
            filterPlot = semilogx(detection.xAxis,nan,'green');
            candPlot = semilogx(detection.xAxis,nan,'rv');
            sPlot = semilogx(detection.xAxis,nan,'mv');
            ax = gca; % set frequency axis tick markers
            xTicks = round2((logspace(log10(20),...
                log10(detection.xAxis(length(detection.xAxis))),10)),5);
            xTicks(length(xTicks)) = round2(detection.xAxis(length(detection.xAxis)),10);
            set(ax,'XTick',xTicks);
        otherwise
            error('plotCharts must be either ''log'' or ''lin''');
    end
    title('Frequency Magnitude Spectrum (dB)');
    xlabel('Frequency [Hz]');
    ylabel('Magnitude [dB]');
    ylim manual;
    ylim([-100, 50]);
    xlim([20,round2(detection.xAxis(length(detection.xAxis)),10)]);
else
    set(spectrum,'YData',detection.XdB);
    
    filtery = zeros(4096,length(filterdata.b(:,1)));
    
    if ~nnz(filterdata.b) == 0 % get magnitude response curve for each filter
        for i = 1:nnz(filterdata.frequencies(:,1))
            [y,x] = freqz(filterdata.b(i,:),filterdata.a(i,:),4096); 
            filtery(:,i) = 20*log10(y);
        end
        filterx = ((x/pi)*simulation.fs)/2;
        filtery = sum(real(filtery),2); % combine magnitude responses
    else
        filterx = linspace(0,2.204461669921875e+04,4096); % lin spacing between 0 and nyquist. 
        filtery = filtery(:,1); % Based upon scaling normalised frequency axis x in the manner: 
    end                         % filterx = ((x/pi)*fs)/2;
    
    set(filterPlot,'XData',filterx,'YData',filtery);

    if any(detection.primary.candidates) % get primary frequency and magnitude data
        primFreqs = detection.xAxis(detection.primary.candidates); 
        primMags = detection.XdB(detection.primary.candidates);
        set(candPlot,'XData',primFreqs,'YData',primMags); % send data to chart
    else
        set(candPlot,'XData',nan,'YData',nan);
    end
    
    if isfield(detection,'secondary') && any(detection.secondary.candidates)
        % get secondary frequency and magnitude data
        secFreqs = detection.xAxis(detection.secondary.candidates); 
        secMags = detection.XdB(detection.secondary.candidates);
        set(sPlot,'XData',secFreqs,'YData',secMags);
    else
        set(sPlot,'XData',nan,'YData',nan);
    end 
end

drawnow;

end

