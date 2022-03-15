function splitting_radar_signals(root,radardir,Person_dir,exceldir)


% Root folder for segmented data
make_folder(root);

% Read excel files with timestamps
time_stamp = readtable(exceldir);
time_stamp = fillmissing(time_stamp,'previous');
time_stamp = table2cell(time_stamp);


% txt to mat
[radar_data,time,date_start] = ...
radardataconvert_to_mat(radardir,'tiresias','text');

% Calculate absolute time
UTCDateTime = date_start + seconds(time);

for irow = 1:size(time_stamp,1)
    % Create a folder for storing data
    dir = [Person_dir '\' time_stamp{irow,1} '\' time_stamp{irow,2}];
    dir = strrep(dir, ':' , '_' );
    make_folder(dir);
    
   measurement_start_time = time_stamp{irow,4};
   measurement_end_time = time_stamp{irow,5};
   [row,~] = find( (measurement_start_time<UTCDateTime) & (UTCDateTime<measurement_end_time) );
   radar_data_segmented = radar_data(row,:);
   t = time(row);
   dir2 = [dir,'\',time_stamp{irow,3},'.mat'];
   save(dir2,'radar_data_segmented','measurement_start_time','t')
end

end

