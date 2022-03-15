


clc
clear
close all


data = edfread('25\SDRI-001_SDRI_V4_N1_025_PSG_(1)_(1).edf');

thorax_data = data.RIPThora;
Abdom_data = data.RIPAbdom;
EMG1_data = data.EMG1;
EMG2_data = data.EMG2;
EMG3_data = data.EMG3;
EMG4_data = data.EMG4;
EMG5_data = data.EMG5;
EMG6_data = data.EMG6;

PSG_fs = length(thorax_data{1});
EMG_fs = length(EMG1_data{1});

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

thorax_data_plot = zeros(length(thorax_data)*PSG_fs,1);
Abdom_data_plot = zeros(length(Abdom_data)*EMG_fs,1);
EMG1_data_plot = zeros(length(EMG1_data)*EMG_fs,1);
EMG2_data_plot = zeros(length(EMG1_data)*EMG_fs,1);
EMG3_data_plot = zeros(length(EMG1_data)*EMG_fs,1);
EMG4_data_plot = zeros(length(EMG1_data)*EMG_fs,1);
EMG5_data_plot = zeros(length(EMG1_data)*EMG_fs,1);
EMG6_data_plot = zeros(length(EMG1_data)*EMG_fs,1);

for i=1:length(thorax_data)
    
    thorax_data_plot((i-1)*length(thorax_data{1})+1:i*length(thorax_data{1})) = thorax_data{i};
    Abdom_data_plot((i-1)*length(Abdom_data{1})+1:i*length(Abdom_data{1})) = Abdom_data{i};
    EMG1_data_plot((i-1)*length(EMG1_data{1})+1:i*length(EMG1_data{1})) = EMG1_data{i};
    EMG2_data_plot((i-1)*length(EMG1_data{1})+1:i*length(EMG1_data{1})) = EMG2_data{i};
    EMG3_data_plot((i-1)*length(EMG1_data{1})+1:i*length(EMG1_data{1})) = EMG3_data{i};
    EMG4_data_plot((i-1)*length(EMG1_data{1})+1:i*length(EMG1_data{1})) = EMG4_data{i};
    EMG5_data_plot((i-1)*length(EMG1_data{1})+1:i*length(EMG1_data{1})) = EMG5_data{i};
    EMG6_data_plot((i-1)*length(EMG1_data{1})+1:i*length(EMG1_data{1})) = EMG6_data{i};
    
end

time_axis = linspace(start_time,end_time,length(thorax_data_plot));
% (1/PSG_fs:1/PSG_fs:(length(thorax_data_plot)/PSG_fs));
% index = find(time_axis>light_off_time&time_axis<light_on_time);
index = isbetween(time_axis,light_off_time,light_on_time);
time_axis_PSG = time_axis(index);
thorax_data = thorax_data_plot(index);
Abdom_data = Abdom_data_plot(index);

time_axis = linspace(start_time,end_time,length(EMG1_data_plot));
index = isbetween(time_axis,light_off_time,light_on_time);
time_axis_EMG = time_axis(index);
EMG1_data = EMG1_data_plot(index);
EMG2_data = EMG2_data_plot(index);
EMG3_data = EMG3_data_plot(index);
EMG4_data = EMG4_data_plot(index);
EMG5_data = EMG5_data_plot(index);
EMG6_data = EMG6_data_plot(index);

save('Respiratory_2022_03_09_Surrydata\25\participants_25_PSG_night.mat','thorax_data',...
'Abdom_data','EMG1_data','EMG2_data','EMG3_data','EMG4_data','EMG5_data','EMG6_data',...
'PSG_fs','time_axis_EMG','time_axis_PSG','light_on_time','light_off_time')

% figure();plot(time,thorax_data_plot)

fclose('all')

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
