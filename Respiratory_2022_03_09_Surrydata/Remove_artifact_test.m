clc
clear
close all

RIP_sampled_fps = 10;
duration = 2280;
load('Respiratory_2022_03_09_Surrydata\25\participants_25_PSG_night.mat')
load('Respiratory_2022_03_09_Surrydata\25\participants_25_radar_night.mat')

% Time when participant fall asleep
time_start = datetime('03.08.2021 23:10:00,000','Format','dd.MM.yyyy HH:mm:ss,SSS');
time_end = datetime('03.08.2021 23:20:00,000','Format','dd.MM.yyyy HH:mm:ss,SSS');

index = isbetween(PSG_128.time_axis,time_start,time_end);
thorax_data_test = PSG_128.thorax_data(index);
FlowTh_data_test = PSG_128.FlowTh_data(index);
timeaxis_PSG_test = PSG_128.time_axis(index);

index = isbetween(time_axis_radar,time_start,time_end);
radar_data_test = radar_data(index,:);
timeaxis_radar_test = time_axis_radar(index);

%% Preprocessing

Data_Matrix = radar_data_test(:,1:150)';

data_enve = envelope(Data_Matrix);

before_env_as = Data_Matrix - mean(Data_Matrix,2);
before_env_den = Adaptive_clutter_suppression(Data_Matrix,0.9,0.7);
data_env_later = envelope(before_env_den);

clutter_map = mean(data_enve,2);
Average_Subtraction_env = (data_enve - clutter_map);
[denoised_data_env] = (Adaptive_clutter_suppression(data_enve,0.9,0.7));

% figure
% surf((1:round(size(radar_data_test,1)))/10,range_axis(1:150),((Data_Matrix)));
% shading interp
% axis tight
% c = colorbar('TickLabelInterpreter',"latex");
% c.Label.String = 'Power(dB)';
% title('Range Profile: Raw Data');
% xlabel('Time (s)');
% ylabel('Range (m)');
% colormap(jet)
% 
% 
% figure
% surf((1:round(size(radar_data_test,1)))/10,range_axis(1:150),((data_enve)));
% shading interp
% axis tight
% c = colorbar('TickLabelInterpreter',"latex");
% c.Label.String = 'Power(dB)';
% title('Range Profile: Raw Data');
% xlabel('Time (s)');
% ylabel('Range (m)');
% colormap(jet)

%% plot the result
breathing_data_raw_en = mean(data_enve(52:78,:));
breathing_data_env_later = mean(data_env_later(52:78,:));
breathing_data_en_den = mean(Average_Subtraction_env(52:78,:));
idxq = linspace(1, length(thorax_data_test), duration*RIP_sampled_fps);    % Interpolation Vector
RIP_resample = interp1(1:length(thorax_data_test), thorax_data_test, idxq, 'linear');

breathing_data_raw_en = bandpass(detrend(breathing_data_raw_en),[0.1 2],10);
breathing_data_env_later = bandpass(detrend(breathing_data_env_later),[0.1 2],10);
breathing_data_en_den = bandpass(detrend(breathing_data_en_den),[0.1 2],10);
temp = bandpass(detrend(Data_Matrix(68,:)),[0.1 2],10);

figure
% plot(timeaxis_radar_test,normalize(temp,'range'),'linewidth',1.5);
hold on 
plot(timeaxis_radar_test,normalize(breathing_data_raw_en,'range'),'linewidth',1.5);
% plot(timeaxis_radar_test,normalize(breathing_data_env_later,'range'),'linewidth',1.5);
plot(timeaxis_PSG_test,normalize(thorax_data_test,'range'),'linewidth',1.5);

plot(timeaxis_PSG_test,normalize(FlowTh_data_test,'range'),'k','linewidth',1.5);

legend('raw enve','enve+denoise','ground truth')