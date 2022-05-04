function params = parameters(data)
        
      params = containers.Map;
      params('f_start') = 77e9;
      params('f_end') = 81e9;
      params('fc') = (params('f_start') + params('f_end')) / 2;
      params('SweepTime') = 40e-3;
      params('NTS') = 256;
      params('numTX') = 2;
      params('numRX') = 4;
      params('NoC') = 128;
      params('slope') = 80e12;
      params('sampleFreq') = 10e6;
      params('idletime') = 100e-6;
      params('adcStartTime') = 5e-6;
      params('rampEndTime') = 50e-6;
      params('isBPM') = 1;
      params('isTDM') = 0;
      params('max_range_plot') = 4;  % params('sampleFreq') * 299792458 / (2 * params('slope'))  % max range to be plotted
      params('save_ra_map_az') = 1;
      params('save_ra_map_el') = 1;
      params('save_rd_map') = 1;
      params('save_spectrogram') = 1;
      
      % Calculated params
      params('c') = 299792458;
      params('Bw') = params('f_end') - params('f_start');
      params('NPpF') = params('numTX') * params('NoC');
      params('numChirps') = np.ceil(len(data) / 2 / params('NTS') / params('numRX'));
      params('dT') = params('SweepTime') / params('NPpF');
      params('prf') = 1 / params('dT');
      params('duration') = params('numChirps') * params('dT');
      params('Rmax') = params('sampleFreq') * params('c') / (2 * params('slope'));
      params('rResol') = params('c') / (2 * params('Bw'));
      params('RANGE_FFT_SIZE') = params('NTS');
      params('RNGD2_GRID') = np.linspace(0, params('Rmax'), params('RANGE_FFT_SIZE'));
      params('fps') = 1 / params('SweepTime');
      params('n_frames') = params('duration') * params('fps');
      params('Tc') = params('idletime') + params('rampEndTime');
      params('lambda') = params('c') / params('fc');
      params('velmax') = params('lambda') / (params('Tc') * 4);  % Unambiguous max velocity
      params('DFmax') = params('velmax') / (params('c') / params('fc') / 2);
      params('vResol') = params('lambda') / (2 * params('SweepTime'));
        
        
end