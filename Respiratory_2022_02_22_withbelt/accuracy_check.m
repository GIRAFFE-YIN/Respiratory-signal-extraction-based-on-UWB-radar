clear
clc
close all

%% Load data
load('Radar_Data_03032022_222513_RF_breathingbelt_test2.mat',...
    'Data_Matrix','actual_fps','frame_axis','range_vector')

% Force data from respiration belt
% load force data from the second row
temp = csvread('test2.csv',1,0);

belt_time_axis = temp(:,1);
belt_force = temp(:,2);
belt_RR_1 = temp(:,3);
clear temp

%% Preprocessing data

Data_Matrix = (Data_Matrix');
clutter_map = mean(Data_Matrix,2);
Average_Subtraction = (Data_Matrix - clutter_map);
[denoised_data] = Adaptive_clutter_suppression(Data_Matrix,0.9,0.7);

%% Remove first 20s

belt_fs = 16;
belt_dt = 1/belt_fs;
breathing_range = [2 2.2];
total_time = 300;
removed_time = 20;

% for belt
frames = find(belt_time_axis>=removed_time);
belt_time_axis = belt_time_axis(frames-min(frames)+1);
belt_force = belt_force(frames);
% for radar
breathing_bins = find(range_vector>breathing_range(1)...
    &range_vector<breathing_range(2));
frames = find(frame_axis>=removed_time);
frame_axis = frame_axis(frames-min(frames)+1);
radar_data = mean(Average_Subtraction(breathing_bins,frames));
% Respiratory frequency range
breathing_frange = [0.1 1.5];
% Pre-filter the data
radar_data = bandpass(radar_data,breathing_frange,actual_fps);

%% Accuracy check
processing_window = 30;
sliding_length = 2;
sample_num = floor((total_time-processing_window)/sliding_length);
% number of realizations
NR = 50;
MaxIter = 100;
% % assume noise level is low
% Nstd = 0;

RR_belt = zeros(sample_num,1);
RR_radar = zeros(sample_num,1);

for isample = 1:sample_num
    
    iradar_data = radar_data(1:round(processing_window*actual_fps));
    radar_data = circshift(radar_data,-2*round(sliding_length*actual_fps));
    
    ibelt_data = belt_force(1:processing_window*belt_fs);
    belt_force = circshift(belt_force,-2*sliding_length*belt_fs);
    
    % Respiratory from Belt
    fftmax = fftmax_with_boundarise(ibelt_data,belt_fs,breathing_frange);
    RR_belt(isample) = fftmax*60;
    
    % Respiratory from Radar
    Nstd = 0.3;
    modes = eemd(iradar_data,Nstd,NR,MaxIter);
    energy = sum(modes.^2,2);
    [~,loc(isample)] = max(energy);
    Signal_required = modes(loc(isample),:);
    fftmax = fftmax_with_boundarise(Signal_required,actual_fps,breathing_frange);
    RR_radar(isample) = fftmax*60;
    
end

%% plot the results
figure
subplot(2,1,1);
plot(belt_time_axis,normalize(belt_force,'range'),'linewidth',2)
hold on
plot(frame_axis,normalize(radar_data,'range'),'linewidth',2)

legend('ground truth','raw radar data','filtered data')

subplot(2,1,2);
xaxis = linspace(0,300,length(RR_belt));
plot(xaxis,RR_belt,'linewidth',2)
hold on
plot(xaxis,RR_radar,'linewidth',2)

error_rate = (abs(RR_radar-RR_belt)./RR_radar);
mean(error_rate)*100

