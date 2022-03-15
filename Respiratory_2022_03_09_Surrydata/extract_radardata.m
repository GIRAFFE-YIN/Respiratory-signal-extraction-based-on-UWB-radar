clc
clear 
close all

load('SDRI001_RDREV04_025V4N1.mat') 
load('participants_25_PSG_night.mat') 

time_axis = linspace(date_start,date_end,length(time));
index_time = isbetween(time_axis,light_off_time,light_on_time);
time_axis_radar = time_axis(index_time);

bin_length = 1.5e8/23.328e9;
frame_start = 0.18;
range_axis = frame_start:bin_length:frame_start+bin_length*size(data,2)-bin_length;
index_range = find(range_axis>0.5);
range_axis = range_axis(index_range);

radar_data = data(index_time,index_range);

save('Respiratory_2022_03_09_Surrydata\25\participants_25_radar_night.mat','radar_data','time_axis_radar','range_axis')
