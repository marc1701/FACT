% saves FACT simulation data, audio and final filter curve to desktop (mac)

csvwrite(['~/Desktop/',num2str(simulation.n),'/magnitudes.csv'],filterdata.magnitudes);

csvwrite(['~/Desktop/',num2str(simulation.n),'/frequencies.csv'],filterdata.frequencies);

csvwrite(['~/Desktop/',num2str(simulation.n),'/depths.csv'],filterdata.depths);

csvwrite(['~/Desktop/',num2str(simulation.n),'/timestamp.csv'],filterdata.timestamp);

audiowrite(['~/Desktop/',num2str(simulation.n),'/sim.wav'],simulation.output,simulation.fs);

fig2 = figure(2);
save_fig(fig2,['~/Desktop/',num2str(simulation.n),'/MATLAB'],'pdf');