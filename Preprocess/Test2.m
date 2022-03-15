clear
clc

% Root folder for segmented data
root = 'Radar_SDRI001_CroppedVersion';
% Number of the subject
PersonID = 019;
%Excel files with timestamps
exceldir = ['Time_stamp\Participant_' num2str(PersonID) '.xlsx'];
radardir = ['SDRI001_RDR005_MEAS4_0' num2str(PersonID) 'V4D1.txt'];
Person_dir = [root '\' 'SDRI001_' num2str(PersonID) 'V4D1'];

splitting_radar_signals(root,radardir,PersonID,exceldir);


