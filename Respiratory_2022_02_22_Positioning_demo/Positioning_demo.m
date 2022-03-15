clc
clear
close all

%% Positioning demo for TWO radar

load('frame_gen.mat')
load('Radar_Data_RF_20220222_143239_localisation_v3_empty_ExperimentA_Set2_Height1')

% Because all my code use col vector to store the data
% I transposed the matrix, please don't get confused

% Besides, because the RF signal is jumpy, I took the envelope after
% taking the absolute value for the signal. This was helpful for localization
% and extraction of the respiratory signal, but I'm not sure it helped in
% generating the spectrograms.
Data_Matrix_1 = envelope(Data_Matrix_1');
Data_Matrix_2 = envelope(Data_Matrix_2');

% generate the clutetr map
clutter_map_1 = mean(Data_Matrix_1,2);
clutter_map_2 = mean(Data_Matrix_2,2);

% Raw data for the experiment
load('Radar_Data_RF_20220222_143021_localisation_v3_ExperimentA_Set2_Height1')

amax = 0.8;
amin = 0.5;
% Remove clutter for each radar
Data_Matrix_1 = abs(envelope(Data_Matrix_1') - clutter_map_1);
Data_Matrix_2 = abs(envelope(Data_Matrix_2') - clutter_map_2);
% Data_Matrix_1(Data_Matrix_1<0) = 0;
% Data_Matrix_2(Data_Matrix_2<0) = 0;
% Adaptive filter
[Data_Matrix_1] = Adaptive_clutter_suppression(Data_Matrix_1,amax,amin);
[Data_Matrix_2] = Adaptive_clutter_suppression(Data_Matrix_2,amax,amin);
Data_Matrix_1 = abs(Data_Matrix_1);
Data_Matrix_2 = abs(Data_Matrix_2);
% Data_Matrix_1(Data_Matrix_1<0) = 0;
% Data_Matrix_2(Data_Matrix_2<0) = 0;
% Just choose the valide period
Data_Matrix_1 = Data_Matrix_1(:,600:end);
Data_Matrix_2 = Data_Matrix_2(:,600:end);
frame_axis = frame_axis(600:end);

%% Some Basic variables ignore it
bins = length(range_axis);
% Location of the radar: [x y z] in row
Rx = [0.5 -1 1;3.5 -1 1];
% Size of each block: [length in x/y dim, length in z dim]

block_size = [0.09 1];
% Weights parameter. Enlarge a when better SNR
a = 2;
% Location and Size of the area: [xlength, ylength, zlength]
area_size = [4 6 1];
% Number of blocks in x and y axis
x_number = floor(area_size(1)/block_size(1));
y_number = floor(area_size(2)/block_size(1));
% Average the value every 5 frames
frame = 5;
% Parameter init
St = zeros(x_number,y_number);
Mt = zeros(x_number,y_number,frame);

pleace_holder = zeros(x_number,y_number,1000);
% Ploting axis init
px = 0:block_size(1):(x_number)*block_size(1)-block_size(1);
py = 0:block_size(1):(y_number)*block_size(1)-block_size(1);
pz = St';
% init the graph
h.fig  = figure ;
h.ax   = handle(axes) ;                 % create an empty axes that fills the figure
h.surf = handle( surf( NaN(2) ) ) ;     % create an empty "surface" object
set( h.surf , 'XData',px, 'YData',py, 'ZData',pz);
hold on
h.scatter = handle( scatter3(NaN,NaN,NaN,'filled') );
set(h.scatter, 'XData' ,1,'YData',1,'ZData',5000);
h.position = handle( scatter3(NaN,NaN,NaN,'filled','MarkerFaceColor','r') );
set(h.position, 'XData' ,1,'YData',1,'ZData',5000);
shading interp
% axis tight
title('RF signal');
grid on;
xlabel('Distance x axis [m]');
ylabel('Distance y axis [m]');
view([0,0,90]);
% hold off

iframe = 1;
dxy = 5;
% dt = 2;
bins_for_each_radar = get_range_bins(area_size,block_size,Rx,range_axis);
for itime = 1:1000%length(frame_axis)
    
    tic
    
    % preprocessing the data
    raw_data = [Data_Matrix_1(:,itime) Data_Matrix_2(:,itime)];
    
    % Here I have updated the weights of each radar signal.
    % You can see that I first squared the signal and then divided it by
    % the average value. This way values that would have been higher than
    % the ambient noise are amplified.
    amp_radar = (raw_data.^a)./(sum(raw_data.^a)/bins);
    amp_radar = single(amp_radar); 
    % Here I calculate the value for each blocks
%     [St] = position_map(area_size,block_size,amp_radar,Rx,range_axis);
    
    St = get_score_map_mex(bins_for_each_radar,amp_radar);
%     St = reshape(St,[x_number y_number]);
    pleace_holder(:,:,itime) = St;
    h.surf.ZData = St';
    % Additionally, I calculated a rough threshold to remove all data
    % below the threshold. 
    threshold = (25/(x_number*y_number))*sum(St(:));
    %     temp(temp>threshold*35) = threshold*35;
    St(St<threshold) = 0;
     
    % I store the value and calculate the mean every 5 frame
    % Once again we have suppressed ambient noise 
    Mt = circshift(Mt,-1,3);
    Mt(:,:,frame) = St;
    %     temp = mean(Mt,3);
    
    if iframe>=frame
        
        iframe = 4;
        
         [x_number,y_number,z_number] = size(Mt);
        position_range =[];
        
        [Seed] = generate_seeds(x_number,y_number,z_number,5,2);
%         iseed = 1;
%         for i = 1:frame
%             input = Mt(:,:,i);
%             [cent, varargout]=FastPeakFind(input, 2 , 2,1);
%             for j = 1:length(cent)/2
%                 Seed(iseed,:) = [cent(j*2-1),cent(j*2),i];
%                 iseed = iseed +1;
%             end
%         end
        
        for i = 1:size(Seed,1)
            if ( Mt(Seed(i,1),Seed(i,2),Seed(i,3))~=0 )
                
                [J] = Region_grow(Mt,Seed(i,:),10,Inf);
                index = find(J==1);
                
                if (length(index)>20) %&& (sum(Mt(index))>length(index))
                    position_range = union(position_range,index);
                end
            end
        end
        
        if any(position_range(:))
            mean_temp = zeros(size(Mt));
            mean_temp(position_range) = Mt(position_range);
            meam_data = mean(mean_temp,3);
            [cent]=FastPeakFind(meam_data, 2 , 2,2);
            cent = round(cent);
            set(h.position, 'XData' ,px(cent(1)),'YData',py(cent(2)),'ZData',6000);
            [i1,i2,i3] = ind2sub([x_number,y_number,frame],position_range);
             set(h.scatter, 'XData' ,px(i1),'YData',py(i2),'ZData',ones(length(i1),1)*5000);
        end

    end
    
    iframe = iframe+1;
    
    drawnow
    
    tic_toc_time = toc
    if dt-tic_toc_time>0
        pause(dt-tic_toc_time);
    end
end

save('Grow.mat','pleace_holder')