clc
clear
close all

%% Load data
load('Radar_Data_03032022_173645_RF_breathingbelt test2.mat',...
     'Data_Matrix','actual_fps','frame_axis','range_vector')
 
% Force data from respiration belt
% load force data from the second row 
temp = csvread('csv-export.csv',1,0);

belt_time_axis = temp(:,1);
belt_force = temp(:,2);
belt_RR_1 = temp(:,3);
clear temp

%% Preprocessing data

Data_Matrix = (Data_Matrix');
clutter_map = mean(Data_Matrix,2);
Average_Subtraction = Data_Matrix - clutter_map;
Average_Subtraction(Average_Subtraction<0) = 0;
[denoised_data] = Adaptive_clutter_suppression(Data_Matrix,0.9,0.7);
denoised_data(denoised_data<0)=0;
%% Remove first 20s
removed_time = 20;
belt_dt = 0.05;
belt_fs = 20;
total_time = 120;
frames = find(belt_time_axis>=removed_time);
belt_time_axis = belt_time_axis(frames-min(frames)+1);
belt_force = belt_force(frames);

% find the range 
% breathing_range = [1.8 1.85];
% breathing_bins = find(range_vector>breathing_range(1)...
%                    &range_vector<breathing_range(2));
frames = find(frame_axis>=removed_time);
frame_axis = frame_axis(frames-min(frames)+1);
raw_data = (denoised_data(220,frames));
% Respiratory frequency range
breathing_frange = [0.1 1];
 % Pre-filter the data
breathing_data = bandpass(raw_data,breathing_frange,10);

%% Visualise the data

% figure
% surf(frame_axis,range_vector(breathing_bins),(abs(denoised_data(breathing_bins,frames))));
% shading interp
% axis tight
% c = colorbar('TickLabelInterpreter',"latex");
% c.Label.String = 'Power(dB)';
% title('Range Profile: Raw Data');
% xlabel('Time (s)');
% ylabel('Range (m)');
% colormap(jet)


figure 
% subplot(2,1,1)
% plot(belt_time_axis,normalize(belt_force,'range'),'linewidth',2)
% hold on 
plot(frame_axis,normalize(raw_data,'range'),'linewidth',2)
hold on
plot(belt_time_axis,normalize(belt_force,'range'),'linewidth',2)

%%
% find the range 

raw_data = (denoised_data(223,frames));
% Respiratory frequency range
breathing_frange = [0.1 1];
 % Pre-filter the data
breathing_data = bandpass(raw_data,breathing_frange,10);
plot(frame_axis,normalize(raw_data,'range'),'linewidth',2)

% find the range 
raw_data = (denoised_data(232,frames));
% Respiratory frequency range
breathing_frange = [0.1 1];
 % Pre-filter the data
breathing_data = bandpass(raw_data,breathing_frange,10);
plot(frame_axis,normalize(raw_data,'range'),'linewidth',2,'color','k')





