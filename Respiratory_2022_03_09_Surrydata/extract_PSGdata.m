clc
clear
close all

% PSG data
data = edfread('25\SDRI-001_SDRI_V4_N1_025_PSG_(1)_(1).edf');

fidin=fopen('25\Markers.txt');
while ~feof(fidin)  % Determine if it is the end of the file
    tline=fgetl(fidin);
    if isempty(tline)
        continue
    elseif tline(1:5) == 'Start'
        start_date = regexp(tline,'\d\d/\d\d/\d\d\d\d','match');
    elseif double(tline(1))>=48 && double(tline(1))<=57    % Determine if the first character is a numeric value
        splited_date = regexp(tline,';','split');
        switch splited_date{2}
            case ' Start'
                start_time = datetime( splited_date{1},...
                    'Format' , 'dd.MM.yyyy HH:mm:ss,SSS' );
            case ' LIGHTS OFF'
                light_off_time = datetime( splited_date{1},...
                    'Format' , 'dd.MM.yyyy HH:mm:ss,SSS' );
            case ' LIGHTS ON'
                light_on_time = datetime( splited_date{1},...
                    'Format' , 'dd.MM.yyyy HH:mm:ss,SSS' );
            case ' End'
                end_time = datetime( splited_date{1},...
                    'Format' , 'dd.MM.yyyy HH:mm:ss,SSS' );
        end
        continue
    end
end
fclose('all');


% Sample rate is 128
[thorax_data, RIP_fs] = cell2vector(data.RIPThora);
Abdom_data = cell2vector(data.RIPAbdom);
PLMl_data = cell2vector(data.PLMl);
PLMr_data = cell2vector(data.PLMr);
FlowTh_data = cell2vector(data.FlowTh_);

time_axis = linspace(start_time,end_time,length(thorax_data))';

PSG_128 = timetable(time_axis,thorax_data,Abdom_data,PLMl_data,PLMr_data,FlowTh_data);

% Samples within the light off and light on time
rangeOfTimes = timerange(light_off_time,light_on_time);
[~,whichRows] = withinrange(PSG_128,rangeOfTimes);
PSG_128 = PSG_128(whichRows,:);


% Sample rate is 256
[EMG1_data, EMG_fs]= cell2vector(data.EMG1);
EMG2_data = cell2vector(data.EMG2);
EMG3_data = cell2vector(data.EMG3);
EMG4_data = cell2vector(data.EMG4);
EMG5_data = cell2vector(data.EMG5);
EMG6_data = cell2vector(data.EMG6);
EMG2_EMG3 = cell2vector(data.EMG2_EMG3);
ECGII = cell2vector(data.ECGII);
EMG1_EMG3 = cell2vector(data.EMG1_EMG3);
[PressureFlow, PressureFlow_fs]= cell2vector(data.PressureFlow);

time_axis = linspace(start_time,end_time,length(EMG1_data))';

PSG_256 = timetable(time_axis,ECGII,EMG1_data,EMG2_data,EMG3_data,EMG4_data,...
                    EMG5_data,EMG6_data,EMG2_EMG3,EMG1_EMG3,PressureFlow);
                
% Samples within the light off and light on time
[~,whichRows] = withinrange(PSG_256,rangeOfTimes);
PSG_256 = PSG_256(whichRows,:);               


save('Respiratory_2022_03_09_Surrydata\25\participants_25_PSG_night.mat',...
'PSG_128','PSG_256','RIP_fs','EMG_fs','light_on_time','light_off_time')

% figure();plot(time,thorax_data_plot)

% function [data,axis] = generate_time_axis(data,start_time,end_time,light_off_time,light_on_time)
% 
% time_axis = linspace(start_time,end_time,length(data));
% index = isbetween(time_axis,light_off_time,light_on_time);
% axis = time_axis(index);
% data = data(index);
% 
% end

%%

%
%
% fidin=fopen('19\PSG\Markers_PSG.txt');
% while ~feof(fidin)  % Determine if it is the end of the file
%     tline=fgetl(fidin);
%     if isempty(tline)
%         continue
%     elseif tline(1:5) == 'Start'
%         start_date = regexp(tline,'\d\d/\d\d/\d\d\d\d','match');
%     elseif double(tline(1))>=48 && double(tline(1))<=57    % Determine if the first character is a numeric value
%         splited_date = regexp(tline,';','split');
%         switch splited_date{2}
%             case ' Start'
%                 start_time = datetime( [start_date{1} ' ' splited_date{1}],...
%                  'Format' , 'dd/MM/yyyy HH:mm:ss,SSS' );
%             case ' LIGHTS OFF'
%                 light_off_time = datetime( [start_date{1} ' ' splited_date{1}],...
%                 'Format' , 'dd/MM/yyyy HH:mm:ss,SSS' );
%             case ' LIGHTS ON'
%                 light_on_time = datetime( [start_date{1} ' ' splited_date{1}],...
%                  'Format' , 'dd/MM/yyyy HH:mm:ss,SSS' ) + days(1);
%             case ' End'
%                 end_time = datetime( [start_date{1} ' ' splited_date{1}],...
%                  'Format' , 'dd/MM/yyyy HH:mm:ss,SSS' ) + days(1);
%         end
%         continue
%     end
% end
