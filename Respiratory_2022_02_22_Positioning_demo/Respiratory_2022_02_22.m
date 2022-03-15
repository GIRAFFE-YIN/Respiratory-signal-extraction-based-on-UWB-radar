clc
clear

%% This code is for offline processing for positioning algorithm

load('Radar_Data_RF_20220222_143239_localisation_v3_empty_ExperimentA_Set2_Height1')

Data_Matrix_1 = envelope(Data_Matrix_1');
Data_Matrix_2 = envelope(Data_Matrix_2');

clutter_map_1 = mean(Data_Matrix_1,2);
clutter_map_2 = mean(Data_Matrix_2,2);

% column vector to represent data
clutter_map = [clutter_map_1 clutter_map_2];
% frame_rate = 25;

load('Radar_Data_RF_20220222_143021_localisation_v3_ExperimentA_Set2_Height1')

Data_Matrix_1 = envelope(Data_Matrix_1');
Data_Matrix_2 = envelope(Data_Matrix_2');

Data_Matrix_1 = Data_Matrix_1(:,600:end);
Data_Matrix_2 = Data_Matrix_2(:,600:end);
frame_axis = frame_axis(600:end);

bins = length(range_axis);
Rx = [0.5 -1;3.5 -1];
r = 0.05;
a = 2;
x_length = 4;
y_length = 6;
x_number = floor(x_length/r);
y_number = floor(y_length/r);
St = zeros(x_number,y_number);
frame = 10;
Mt = zeros(x_number,y_number,frame);

px = 0:r:(x_number)*r-r;
py = 0:r:(y_number)*r-r;
pz = St';

h.fig  = figure ;
h.ax   = handle(axes) ;                 % create an empty axes that fills the figure
h.surf = handle( surf( NaN(2) ) ) ;     % create an empty "surface" object
set( h.surf , 'XData',px, 'YData',py, 'ZData',pz);
shading interp
% axis tight
title('RF signal');
grid on;
xlabel('Distance x axis [m]');
ylabel('Distance y axis [m]');
view([0,0,90]);

for itime = 1:length(frame_axis)
    tic
    
    raw_data = [Data_Matrix_1(:,itime) Data_Matrix_2(:,itime)];
    
     raw_data = abs(raw_data - clutter_map);      % Remove clutter for each radar
%        raw_data(raw_data<0) = 0;               % Remove value < 0
%      raw_data = abs(raw_data);
    
    amp_radar = (raw_data.^a)./(sum(raw_data.^a)/bins); 
    
    [St] = position_map(x_number,y_number,r,amp_radar,Rx,range_axis);
    Mt = circshift(Mt,1,3);
    Mt(:,:,1) = St;   
    
    temp = mean(Mt,3);
    
    threshold = (1/(x_number*y_number))*sum(temp(:));
%     temp(temp>threshold*35) = threshold*35;
    temp(temp<threshold) = 0;

    h.surf.ZData = temp';
    drawnow
    
    tic_toc_time = toc;
    if dt-tic_toc_time>0
        pause(dt-tic_toc_time);
    end
end