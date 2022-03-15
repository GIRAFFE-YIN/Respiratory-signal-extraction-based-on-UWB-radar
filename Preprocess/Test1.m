% data = edfread('PSGresp_Rdar_PSGresp_Rdar.edf');
% 
% dataThorax = data.RIPTho;
% 
% fs = length(dataThorax{1});
% 
% dataThoraxPlot = zeros(length(dataThorax)*length(dataThorax{1}),1);
% 
% for i=1:length(dataThorax)
% 
%     dataThoraxPlot((i-1)*length(dataThorax{1})+1:i*length(dataThorax{1})) = dataThorax{i};
% 
% end
% 
% time = 1/fs:1/fs:(length(dataThoraxPlot)/fs);
% 
% figure();plot(time,dataThoraxPlot)


clear 
clc

data = edfread('PSGresp_Rdar_PSGresp_Rdar.edf');

dataThorax = data.RIPTho;

fs = length(dataThorax{1});

fidin=fopen('Markers.txt'); 

i = 1;
j = 1;
splited_date = cell(30,2);
splited_ID = cell(2,2);

while ~feof(fidin)  % Determine if it is the end of the file                                             
    tline=fgetl(fidin); 
    if isempty(tline)
        continue      
    elseif double(tline(1))>=48 && double(tline(1))<=57    % Determine if the first character is a numeric value      
       splited_date(i,:) = regexp(tline,';','split');  
       splited_date{i,1} = datetime( splited_date{i,1} , 'TimeZone' , 'local' , 'Format' , 'dd.MM.yyyy HH:mm:ss,SSS' );
       i = i + 1;
       continue
    else    
        splited_ID(j,:) = regexp(tline,': ','split');  
        j = j + 1;
    end
end



for idate = size(splited_date,1)

end




% unixDateTime = datetime(1626276943132,'ConvertFrom','epochtime','TicksPerSecond',1e3,'Format','dd-MMM-yyyy HH:mm:ss.SSS Z','TimeZone','UTC');
% 
% startTime = unixDateTime(1);
% 
% startTime.TimeZone = 'local'; %Convert from UTC to local british time before the following operations.

% startHour = 22; %This is in hours local time 24-hour clock format, be careful to use correct timezone within Matlab so corrections for daylight saving time are applied.
% 
% startTime = startTime - hours(hour(startTime))+ hours(startHour);
% 
% endTime = startTime + days(1);
% 
% endHour = 8;
% 
% endTime = endTime - hours(hour(endTime)) + hours(endHour);
% 
%  
% 
% startIdx = find(unixDateTime>startTime,1,'first');
% 
% endIdx = find(unixDateTime>endTime,1,'first');