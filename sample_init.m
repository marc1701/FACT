simulation.IR = 'heslingtonIR.wav';
simulation.stimulus = 'jupiterSample.wav';
simulation.foldername = 'holstChurch2';

MSG = loopResponseAnalysis('heslingtonIR.wav',64);
simulation.gain = MSG+2;

simulation.n=1;
detection.primary.type = 'none';
FACT(simulation,detection);

simulation.n=3;
detection.primary.type = 'MSD';
detection.bufferlength = 16;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=4;
detection.primary.type = 'MSD';
detection.bufferlength = 16;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=5;
detection.primary.type = 'MSD';
detection.bufferlength = 8;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=6;
detection.primary.type = 'MSD';
detection.bufferlength = 8;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=7;
detection.primary.type = 'MSD';
detection.bufferlength = 4;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=8;
detection.primary.type = 'MSD';
detection.bufferlength = 12;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=9;
detection.primary.type = 'PAPR';
detection.primary.threshold = 20;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=10;
detection.primary.type = 'PAPR';
detection.primary.threshold = 20;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=11;
detection.primary.type = 'PHPR';
detection.primary.threshold = 35;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=12;
detection.primary.type = 'PHPR';
detection.primary.threshold = 35;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=13;
detection.primary.type = 'PNPR';
detection.primary.threshold = 15;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=14;
detection.primary.type = 'PNPR';
detection.primary.threshold = 15;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

% *********************************

simulation.IR = 'heslingtonIR.wav';
simulation.stimulus = 'holstSample.wav';
simulation.foldername = 'holstChurch4';

MSG = loopResponseAnalysis('heslingtonIR.wav',64);
simulation.gain = MSG+4;

simulation.n=1;
detection.primary.type = 'none';
FACT(simulation,detection);

simulation.n=3;
detection.primary.type = 'MSD';
detection.bufferlength = 16;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=4;
detection.primary.type = 'MSD';
detection.bufferlength = 16;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=5;
detection.primary.type = 'MSD';
detection.bufferlength = 8;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=6;
detection.primary.type = 'MSD';
detection.bufferlength = 8;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=7;
detection.primary.type = 'MSD';
detection.bufferlength = 4;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=8;
detection.primary.type = 'MSD';
detection.bufferlength = 12;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=9;
detection.primary.type = 'PAPR';
detection.primary.threshold = 20;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=10;
detection.primary.type = 'PAPR';
detection.primary.threshold = 20;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=11;
detection.primary.type = 'PHPR';
detection.primary.threshold = 35;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=12;
detection.primary.type = 'PHPR';
detection.primary.threshold = 35;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=13;
detection.primary.type = 'PNPR';
detection.primary.threshold = 15;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=14;
detection.primary.type = 'PNPR';
detection.primary.threshold = 15;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

% *********************************

simulation.IR = 'heslingtonIR.wav';
simulation.stimulus = 'marsSample.wav';
simulation.foldername = 'marsChurch2';

MSG = loopResponseAnalysis('heslingtonIR.wav',64);
simulation.gain = MSG+2;

simulation.n=1;
detection.primary.type = 'none';
FACT(simulation,detection);

simulation.n=3;
detection.primary.type = 'MSD';
detection.bufferlength = 16;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=4;
detection.primary.type = 'MSD';
detection.bufferlength = 16;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=5;
detection.primary.type = 'MSD';
detection.bufferlength = 8;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=6;
detection.primary.type = 'MSD';
detection.bufferlength = 8;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=7;
detection.primary.type = 'MSD';
detection.bufferlength = 4;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=8;
detection.primary.type = 'MSD';
detection.bufferlength = 12;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=9;
detection.primary.type = 'PAPR';
detection.primary.threshold = 20;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=10;
detection.primary.type = 'PAPR';
detection.primary.threshold = 20;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=11;
detection.primary.type = 'PHPR';
detection.primary.threshold = 35;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=12;
detection.primary.type = 'PHPR';
detection.primary.threshold = 35;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=13;
detection.primary.type = 'PNPR';
detection.primary.threshold = 15;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=14;
detection.primary.type = 'PNPR';
detection.primary.threshold = 15;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=15;
detection.primary.type = 'PHPR';
detection.primary.threshold = 35;
detection.secondary.type = 'MSD';
detection.findpeaksActive = 'y';
FACT(simulation,detection);

% *********************************

simulation.IR = 'heslingtonIR.wav';
simulation.stimulus = 'marsSample.wav';
simulation.foldername = 'marsChurch4';

MSG = loopResponseAnalysis('heslingtonIR.wav',64);
simulation.gain = MSG+4;

simulation.n=1;
detection.primary.type = 'none';
FACT(simulation,detection);

simulation.n=3;
detection.primary.type = 'MSD';
detection.bufferlength = 16;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=4;
detection.primary.type = 'MSD';
detection.bufferlength = 16;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=5;
detection.primary.type = 'MSD';
detection.bufferlength = 8;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=6;
detection.primary.type = 'MSD';
detection.bufferlength = 8;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=7;
detection.primary.type = 'MSD';
detection.bufferlength = 4;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=8;
detection.primary.type = 'MSD';
detection.bufferlength = 12;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=9;
detection.primary.type = 'PAPR';
detection.primary.threshold = 20;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=10;
detection.primary.type = 'PAPR';
detection.primary.threshold = 20;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=11;
detection.primary.type = 'PHPR';
detection.primary.threshold = 35;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=12;
detection.primary.type = 'PHPR';
detection.primary.threshold = 35;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=13;
detection.primary.type = 'PNPR';
detection.primary.threshold = 15;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=14;
detection.primary.type = 'PNPR';
detection.primary.threshold = 15;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=15;
detection.primary.type = 'PHPR';
detection.primary.threshold = 35;
detection.secondary.type = 'MSD';
detection.findpeaksActive = 'y';
FACT(simulation,detection);

% *********************************

simulation.IR = 'heslingtonIR.wav';
simulation.stimulus = 'speechSample.wav';
simulation.foldername = 'speechChurch2';

MSG = loopResponseAnalysis('heslingtonIR.wav',64);
simulation.gain = MSG+2;

simulation.n=1;
detection.primary.type = 'none';
FACT(simulation,detection);

simulation.n=3;
detection.primary.type = 'MSD';
detection.bufferlength = 16;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=4;
detection.primary.type = 'MSD';
detection.bufferlength = 16;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=5;
detection.primary.type = 'MSD';
detection.bufferlength = 8;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=6;
detection.primary.type = 'MSD';
detection.bufferlength = 8;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=7;
detection.primary.type = 'MSD';
detection.bufferlength = 4;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=8;
detection.primary.type = 'MSD';
detection.bufferlength = 12;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=9;
detection.primary.type = 'PAPR';
detection.primary.threshold = 20;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=10;
detection.primary.type = 'PAPR';
detection.primary.threshold = 20;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=11;
detection.primary.type = 'PHPR';
detection.primary.threshold = 35;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=12;
detection.primary.type = 'PHPR';
detection.primary.threshold = 35;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=13;
detection.primary.type = 'PNPR';
detection.primary.threshold = 15;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=14;
detection.primary.type = 'PNPR';
detection.primary.threshold = 15;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=15;
detection.primary.type = 'PHPR';
detection.primary.threshold = 35;
detection.secondary.type = 'MSD';
detection.findpeaksActive = 'y';
FACT(simulation,detection);

% *********************************

simulation.IR = 'heslingtonIR.wav';
simulation.stimulus = 'speechSample.wav';
simulation.foldername = 'speechChurch4';

MSG = loopResponseAnalysis('heslingtonIR.wav',64);
simulation.gain = MSG+4;

simulation.n=1;
detection.primary.type = 'none';
FACT(simulation,detection);

simulation.n=3;
detection.primary.type = 'MSD';
detection.bufferlength = 16;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=4;
detection.primary.type = 'MSD';
detection.bufferlength = 16;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=5;
detection.primary.type = 'MSD';
detection.bufferlength = 8;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=6;
detection.primary.type = 'MSD';
detection.bufferlength = 8;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=7;
detection.primary.type = 'MSD';
detection.bufferlength = 4;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=8;
detection.primary.type = 'MSD';
detection.bufferlength = 12;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=9;
detection.primary.type = 'PAPR';
detection.primary.threshold = 20;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=10;
detection.primary.type = 'PAPR';
detection.primary.threshold = 20;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=11;
detection.primary.type = 'PHPR';
detection.primary.threshold = 35;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=12;
detection.primary.type = 'PHPR';
detection.primary.threshold = 35;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=13;
detection.primary.type = 'PNPR';
detection.primary.threshold = 15;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=14;
detection.primary.type = 'PNPR';
detection.primary.threshold = 15;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=15;
detection.primary.type = 'PHPR';
detection.primary.threshold = 35;
detection.secondary.type = 'MSD';
detection.findpeaksActive = 'y';
FACT(simulation,detection);

% *********************************

simulation.IR = 'heslingtonIR.wav';
simulation.stimulus = 'ravenSample.wav';
simulation.foldername = 'rockChurch2';

MSG = loopResponseAnalysis('heslingtonIR.wav',64);
simulation.gain = MSG+2;

simulation.n=1;
detection.primary.type = 'none';
FACT(simulation,detection);

simulation.n=3;
detection.primary.type = 'MSD';
detection.bufferlength = 16;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=4;
detection.primary.type = 'MSD';
detection.bufferlength = 16;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=5;
detection.primary.type = 'MSD';
detection.bufferlength = 8;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=6;
detection.primary.type = 'MSD';
detection.bufferlength = 8;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=7;
detection.primary.type = 'MSD';
detection.bufferlength = 4;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=8;
detection.primary.type = 'MSD';
detection.bufferlength = 12;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=9;
detection.primary.type = 'PAPR';
detection.primary.threshold = 20;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=10;
detection.primary.type = 'PAPR';
detection.primary.threshold = 20;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=11;
detection.primary.type = 'PHPR';
detection.primary.threshold = 35;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=12;
detection.primary.type = 'PHPR';
detection.primary.threshold = 35;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=13;
detection.primary.type = 'PNPR';
detection.primary.threshold = 15;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=14;
detection.primary.type = 'PNPR';
detection.primary.threshold = 15;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=15;
detection.primary.type = 'PHPR';
detection.primary.threshold = 35;
detection.secondary.type = 'MSD';
detection.findpeaksActive = 'y';
FACT(simulation,detection);
%*********************************

simulation.IR = 'heslingtonIR.wav';
simulation.stimulus = 'ravenSample.wav';
simulation.foldername = 'rockChurch4';

MSG = loopResponseAnalysis('heslingtonIR.wav',64);
simulation.gain = MSG+4;

simulation.n=1;
detection.primary.type = 'none';
FACT(simulation,detection);

simulation.n=3;
detection.primary.type = 'MSD';
detection.bufferlength = 16;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=4;
detection.primary.type = 'MSD';
detection.bufferlength = 16;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=5;
detection.primary.type = 'MSD';
detection.bufferlength = 8;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=6;
detection.primary.type = 'MSD';
detection.bufferlength = 8;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=7;
detection.primary.type = 'MSD';
detection.bufferlength = 4;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=8;
detection.primary.type = 'MSD';
detection.bufferlength = 12;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=9;
detection.primary.type = 'PAPR';
detection.primary.threshold = 20;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=10;
detection.primary.type = 'PAPR';
detection.primary.threshold = 20;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=11;
detection.primary.type = 'PHPR';
detection.primary.threshold = 35;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=12;
detection.primary.type = 'PHPR';
detection.primary.threshold = 35;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=13;
detection.primary.type = 'PNPR';
detection.primary.threshold = 15;
detection.findpeaksActive = 'n';
FACT(simulation,detection);

simulation.n=14;
detection.primary.type = 'PNPR';
detection.primary.threshold = 15;
detection.findpeaksActive = 'y';
FACT(simulation,detection);

simulation.n=15;
detection.primary.type = 'PHPR';
detection.primary.threshold = 35;
detection.secondary.type = 'MSD';
detection.findpeaksActive = 'y';
FACT(simulation,detection);

shutdown;