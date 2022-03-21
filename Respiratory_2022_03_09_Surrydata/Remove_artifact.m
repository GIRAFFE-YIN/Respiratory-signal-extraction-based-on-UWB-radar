% clc
% clear
% close all
% 
% RIP_sampled_fps = 10;
% duration = 2280;
% load('Respiratory_2022_03_09_Surrydata\25\participants_25_PSG_night.mat')
% load('Respiratory_2022_03_09_Surrydata\25\participants_25_radar_night.mat')

% Time when participant fall asleep
time_start = datetime('03.08.2021 23:37:30,000','Format','dd.MM.yyyy HH:mm:ss,SSS');
time_end = datetime('03.08.2021 23:40:00,000','Format','dd.MM.yyyy HH:mm:ss,SSS');

index = isbetween(PSG_128.time_axis,time_start,time_end);
thorax_data_test = PSG_128.thorax_data(index);
PLMl_data_test = PSG_128.FlowTh_data(index);
timeaxis_RIP_test = PSG_128.time_axis(index);

index = isbetween(PSG_256.time_axis,time_start,time_end);
pressure_test = PSG_256.PressureFlow(index);
timeaxis_EMG_test = PSG_256.time_axis(index);
ECGII_test = PSG_256.ECGII(index);

index = isbetween(time_axis_radar,time_start,time_end);
radar_data_test = radar_data(index,:);
timeaxis_radar_test = time_axis_radar(index);


%% Artifacts plot

data_enve = envelope(radar_data_test(:,1:150)');

figure
surf(timeaxis_radar_test,range_axis(1:150),radar_data_test(:,1:150)');
shading interp
axis tight
c = colorbar('TickLabelInterpreter',"latex");
c.Label.String = 'Power(dB)';
title('Range Profile: Raw Data');
xlabel('Time (s)');
ylabel('Range (m)');
colormap(jet)

data_enve_mean = (data_enve(68,:));

figure
subplot(3,1,1)
plot(timeaxis_radar_test,normalize(data_enve_mean,'range'),'linewidth',1.5)
subplot(3,1,2)
plot(timeaxis_RIP_test,normalize(PLMl_data_test,'range'),'linewidth',1.5)
subplot(3,1,3)
plot(timeaxis_EMG_test,normalize(ECGII_test,'range'),'linewidth',1.5)


% %% Preprocessing
% 
% data_enve = envelope(radar_data_test(:,1:150)');
% 
% breathing_data_radar = mean(data_enve(52:78,:));
% 
% breathing_data_radar = bandpass(detrend(breathing_data_radar),[0.1 2],10);
% 
% figure
% plot(timeaxis_radar_test,normalize(breathing_data_radar,'range'),'linewidth',1.5);
% hold on
% 
