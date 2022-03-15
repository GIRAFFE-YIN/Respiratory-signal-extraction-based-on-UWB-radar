clc
clear
close all

load('Respiratory_2022_03_09_Surrydata\25\participants_25_PSG_night.mat')
load('Respiratory_2022_03_09_Surrydata\25\participants_25_radar_night.mat')

path = '25\Position.txt';
fidin=fopen(path);

[linecount] = linecount(path);

radar_fs = 10;
duration = 30;
RIP_sampled_fps = 10;

breathing_frange = [0.1 1.5];

% number of realizations
NR = 20;
MaxIter = 100;
% assume noise level is low
Nstd = 0.4;
% Time when participant fall asleep

% In order to make the program run faster, numbers are used here to
% represent the different states. 0 = Artefact

line = 1;
position = {};
while ~feof(fidin)  % Determine if it is the end of the file
    tline=fgetl(fidin);
    if isempty(tline)
        continue
        %     elseif tline(1:5) == 'Start'
        %         start_date = regexp(tline,'\d\d/\d\d/\d\d\d\d','match');
        
    elseif double(tline(1))>=48 && double(tline(1))<=57    % Determine if the first character is a numeric value
        splited_date = regexp(tline,';','split');
        
        time_end = datetime(splited_date{1},'Format','dd.MM.yyyy HH:mm:ss,SSS');
        time_start = time_end - seconds(30);
        
        index = isbetween(time_axis_PSG,time_start,time_end);
        thorax_data_test = thorax_data(index);
        
        index = isbetween(time_axis_radar,time_start,time_end);
        radar_data_test = radar_data(index,:);
        
        if isempty(thorax_data_test) || isempty(radar_data_test)
            continue
        end
        
        Data_Matrix = (radar_data_test');
        clutter_map = mean(Data_Matrix,2);
        Average_Subtraction = (Data_Matrix - clutter_map);
        
        % find the range
        var_radar = mean(abs(Data_Matrix(10:end,:)),2);
        [max_var, location] = max(var_radar); 
        raw_data = mean(Average_Subtraction([location+5 location+15],:));
        breathing_data = bandpass(raw_data,breathing_frange,radar_fs);
        
        Nstd = 0.4;
        modes = eemd(breathing_data,Nstd,NR,MaxIter);
        
        energy = sum(modes.^2,2);
        [~,loc] = max(energy);
        Signal_required = modes(4,:);
        
        fftmax = fftmax_with_boundarise(Signal_required,radar_fs,breathing_frange);
        RR_radar = fftmax*60;
        
        % From RIP
        Nstd = 0.06;
        idxq = linspace(1, length(thorax_data_test), duration*RIP_sampled_fps);    % Interpolation Vector
        RIP_resample = interp1(1:length(thorax_data_test), thorax_data_test, idxq, 'linear');
%         breathing_data = bandpass(RIP_resample,breathing_frange,RIP_sampled_fps);
        modes = eemd(RIP_resample,Nstd,NR,MaxIter);
        
        energy = sum(modes.^2,2);
        [~,loc] = max(energy);
        Signal_required = modes(loc,:);
        fftmax = fftmax_with_boundarise(Signal_required,RIP_sampled_fps,breathing_frange);
        RR_RIP = fftmax*60;

        position{line,1} =  RR_radar;
        position{line,2} =  RR_RIP;
        position{line,3} =  splited_date{2};
        position{line,4} =  splited_date{3};
        
        
        line = line+1;
    end
end

save('22_result.mat','position');
%% plot the results

sleep_state = position(:,4);
[loc] = find(~strcmp(sleep_state, ' Wake'));
RR_radar = cell2mat(position(loc,1));
RR_RIP = cell2mat(position(loc,2));

figure
subplot(2,1,1);
% plot(belt_time_axis,normalize(belt_force,'range'),'linewidth',2)
% hold on
% plot(frame_axis,normalize(radar_data,'range'),'linewidth',2)
% 
% legend('ground truth','raw radar data','filtered data')

subplot(2,1,2);
% xaxis = linspace(0,30,length(RR_RIP));
plot(RR_RIP,'linewidth',2)
hold on
plot(RR_radar,'linewidth',2)

error_rate = (abs(RR_radar-RR_RIP)./RR_radar);
legend('ground truth','radar data')
mean(error_rate)*100
