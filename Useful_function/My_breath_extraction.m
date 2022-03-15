function [RR,Signal_required,Radar_Data] = My_breath_extraction(new_position,bin_length,Radar_Data)

subject_range = (new_position-round(0.1/bin_length)):(new_position+round(0.1/bin_length));

% number of realizations
NR = 100;
MaxIter = 500;
% assume noise level is low
Nstd = 0.1;

% recording time 
fs = 10;

Radar_Data = abs(Radar_Data(subject_range,:));
Radar_Data = sum(Radar_Data);
% Radar_Data = bandpass(Radar_Data,[0.1 2],10);

modes = eemd(Radar_Data,Nstd,NR,MaxIter);
Signal_required = modes(3,:);
% plot(Signal_required)
FFT_signal = fft(Signal_required);

windowLength = size(Radar_Data,2);
fftFreqs = (0:(windowLength-1))*fs/windowLength;
fftFreqs(fftFreqs >= fs/2) = fftFreqs(fftFreqs >= fs/2) -fs;
    
FFT_signal(fftFreqs<0.1 | fftFreqs >1) = 0;
absa = abs(FFT_signal)';
[~,freqMax] = max(absa);
RR = fftFreqs(freqMax)*60;

end
