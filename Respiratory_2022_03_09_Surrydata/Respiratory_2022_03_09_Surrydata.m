clc
clear
close all


load('Respiratory_2022_03_09_Surrydata\25\participants_25_PSG_night.mat')
load('Respiratory_2022_03_09_Surrydata\25\participants_25_radar_night.mat')

%% Processing data (5 min slot)

radar_fs = 10;
duration = 30;
RIP_sampled_fps = 10;
% Time when participant fall asleep
time_start = datetime('21.07.2021 02:21:30,000','Format','dd.MM.yyyy HH:mm:ss,SSS');
time_end = time_start + seconds(30);

% index = isbetween(time_axis_PSG,time_start,time_end);
index = find(time_axis_PSG>time_start&time_axis_PSG<time_end);
thorax_data_test = thorax_data(index);

index = isbetween(time_axis_radar,time_start,time_end);
radar_data_test = radar_data(index,:);

%% Preprocessing

Data_Matrix = (radar_data_test');
clutter_map = mean(Data_Matrix,2);
Average_Subtraction = (Data_Matrix - clutter_map);
[denoised_data] = (Adaptive_clutter_suppression(Average_Subtraction,0.9,0.7));
% denoised_data(denoised_data<0) = 0;
% Average_Subtraction(Average_Subtraction<0) = 0;

figure
surf((1:size(radar_data_test,1))/10,range_axis,((Data_Matrix)));
shading interp
axis tight
c = colorbar('TickLabelInterpreter',"latex");
c.Label.String = 'Power(dB)';
title('Range Profile: Raw Data');
xlabel('Time (s)');
ylabel('Range (m)');
colormap(jet)

% find the range 
var_radar = mean(abs(Data_Matrix),2);
[max_var, location] = max(var_radar); 
% breathing_range = [0.95 1];
% breathing_bins = find(range_axis>breathing_range(1)...
%                    &range_axis<breathing_range(2));
raw_data = mean(denoised_data([location-5 location+5],:));

% radar_fs = 2;
% idxq = linspace(1, length(raw_data), duration*radar_fs);    % Interpolation Vector
% raw_data = interp1(1:length(raw_data), raw_data, idxq, 'cubic');

% Respiratory frequency range
breathing_frange = [0.1 1.5];
 % Pre-filter the data
breathing_data = bandpass(raw_data,breathing_frange,radar_fs);

%% Respiratory signal extraction

% From radar
% number of realizations
NR = 20;
MaxIter = 100;
% assume noise level is low
Nstd = 0.4;
modes = eemd((breathing_data),Nstd,NR,MaxIter);

energy = sum(modes.^2,2);
[~,loc] = max(energy);
Signal_required = modes(4,:);

fftmax = fftmax_with_boundarise(Signal_required,radar_fs,breathing_frange);
RR_radar = fftmax*60;

figure
subplot(2,1,1)
plot((1:length(Signal_required))/radar_fs,raw_data,'linewidth',1.5)
hold on
plot((1:length(Signal_required))/radar_fs,breathing_data,'linewidth',1.5);
plot((1:length(Signal_required))/radar_fs,Signal_required,'linewidth',1.5)

legend('raw data','filtered data','extracted signal')
xlim([0 30])

Nstd = 0.1;
% From RIP
idxq = linspace(1, length(thorax_data_test), duration*RIP_sampled_fps);    % Interpolation Vector
RIP_resample = interp1(1:length(thorax_data_test), thorax_data_test, idxq, 'linear');
% breathing_data = bandpass(RIP_resample,breathing_frange,RIP_sampled_fps);
modes = eemd((RIP_resample),Nstd,NR,MaxIter);

energy = sum(modes.^2,2);
[~,loc] = max(energy);
Signal_required = modes(4,:);
fftmax = fftmax_with_boundarise(Signal_required,RIP_sampled_fps,breathing_frange);
RR_RIP = fftmax*60;

subplot(2,1,2)
plot((1:length(Signal_required))/RIP_sampled_fps,RIP_resample,'linewidth',1.5);
hold on
plot((1:length(Signal_required))/RIP_sampled_fps,Signal_required,'linewidth',1.5)
legend('raw RIP signal','filtered RIP signal')
xlim([0 30])
