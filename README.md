The Feedback Analysis and Cancellation Toolkit (FACT)
========================

by Marc Ciufo Green
-------------------

Creates a virtual acoustic feedback loop as if between a single speaker and a single
microphone. Allows testing of the effectiveness of various methods of feedback howl
detection and various methods of feedback howl cancellation. The code is split into three
main sections:

###Simulation###

The main overlap/add convolution process that is designed to cause realistic buildup of
virtual acoustic feedback howls.

__Input:__

Structure containing the following fields:

`simulation.IR` : string specifying RIR audio file to use as the acoustic return path in the
simulation. The sampling frequency of this file specifies the fs of the entire simulation.
Specified RIR must be monaural.

`simulation.stimulus`: string specifying audio file to use as 'desired' mic input signal. Fs
of stimulus must match fs of RIR, and must also be monaural.

`simulation.gain`: value for desired loop gain of simulation, in dB. It can be useful to use
loopResponseAnalysis prior to setting up FACT to determine the Maximum Stable Gain of the
RIR intended for use. loopResponseAnalysis is also run as part of FACT, and its predictions
for likely howl frequencies are dependent on the gain level set here.

`simulation.latency`: value, in samples, for the latency inherent in digital sound
reinforcement systems. Must be a power of 2 (default 64).

`simulation.length`: length, in seconds, for the total simulated time (this will be the
length of the output file). If simulation.stimulus is shorter than simulation.length, or
simulation.length is unspecified, the simulation will run for the full length of the
stimulus.

`simulation.plotCharts`: string indicating the x-axis format for the live-updating chart of
he simulation. 'lin' plots frequency on a linear scale, and 'log' plots frequency
logarithmically. 'none' prevents plotting. (Default 'lin').

__Output:__

`simulation.output`: Audio file of the 'microphone signal' being passed to the 'loudspaeaker'
for the entirety of the loop.

Output structure will also contain all input parameters for reference.

###Detection###

__Input:__ 
Structure including the following fields:

`detection.primary`: Substructure specifying primary method of howl identification:
`detection.primary.type`: string - ``'MSD', 'PMP', 'PAPR', 'PNPR', 'PHPR', 'PTPR'`` or `'none'`.

`'PMP'` requires:
`detection.primary.nframes`: Number of frames in which probable howl ID must have persisted.
Must not exceed detection.bufferlength

`'PAPR', 'PNPR', 'PHPR'` or `'PTPR'` require:
`detection.primary.threshold`: Threshold ratio that triggers positive ID of howl.

`detection.secondary`: Substructure specifying secondary method of howl identification. Set
up as above, however 'PMP' cannot be used as secondary howl ID method. The output
candidates from secondary howl analysis are passed to primary analysis. Leave unspecified
for no secondary analysis.

`detection.findpeaksActive`: `'y'` or `'n'`. Enables or disables standard MATLAB peak-picking
algorithm findpeaks as a first stage in howl identification (default `'n'`).

`detection.maxHowls`: Maximum number of howls that can be identified simultaneously.
(default 8).

`detection.bufferlength`: Number of frequency magnitude frames to be kept in magnitude
history buffer.analysis (default 16).

`detection.analysis`: Substructure specifying FFT analysis parameters:

`detection.analysis.framelength`: Number of samples used for analysis frame (default 256)

`detection.analysis.overlap`: Frame overlap percentage (default 75%)

`detection.analysis.fs`: FFT resampling frequency. Set to double analysis frequency range
(default 4410);

__Output:__ detection structure including all input parameters for reference.

###Destruction###

__Input__ String:
`'notchFilters'`: Use bank of 8 notch filters for howl cancellation.
'bandpassFilters': Use bank of octave-band bandpass filters for howl cancellation (note
that this option is unfinished). Defaults to 'notchFilters'.

__Output__ filterdata Structure
Includes data on the how the filters changed over time, along with a timestamp that
specifies when (simulated time in seconds) these changes occurred. Also includes final
aggregated magnitude response curve of the filters.

---

Example #1: Findpeaks active, secondary analysis PAPR (20dB threshold) and primary analysis
PMP (8 frame persistence). -15dB loop gain. Linear chart plot:

```MATLAB
detection.findpeaksActive = 'y';
detection.secondary.type = 'PAPR';
detection.secondary.threshold = 20;
detection.primary.type = 'PMP';
detection.primary.nframes = 8;

simulation.stimulus = 'exampleStimulus.wav';
simulation.IR = 'exampleIR.wav';
simulation.gain = -15;

[sim,det,filtData] = FACT(simulation,detection);
```

Example #2: Primary analysis MSD, bufferlength 16 (default).

```MATLAB
detection.primary.type = 'MSD';
simulation.stimulus = 'exampleStimulus.wav';
simulation.IR = 'exampleIR.wav';
simulation.gain = -15;

[sim,det,filtData] = FACT(simulation,detection);
```

---

by Marc Ciufo Green  
Audio Lab  
Department of Electronics  
University of York  

Thanks to my supervisors Dr. John Szymanski and Dr. Matthew Speed

Thanks to Robert Bemis for round2  
http://uk.mathworks.com/matlabcentral/fileexchange/4261-round2/content/round2.m

Thanks to sparafucile17 for save_fig  
http://www.dsprelated.com/showcode/223.php
