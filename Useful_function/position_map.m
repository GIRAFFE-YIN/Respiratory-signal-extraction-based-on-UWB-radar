function [St] = position_map(area_size,block_size,amp_radar,Rx,range_vector)
%POSITION_MAP Summary of this function goes here
%   Detailed explanation goes here

x_number = floor(area_size(1)/block_size(1));
y_number = floor(area_size(2)/block_size(1));
Max_vote = zeros(size(amp_radar,2),1);
St = zeros(x_number,y_number);
% Loop for each block

for ix = 1:x_number
    for iy = 1:y_number
        
        block_location = [block_size(1)/2 + block_size(1) * (ix-1),... 
                          block_size(1)/2 + block_size(1) * (iy-1), area_size(3)];
        
        % Loop for each radar
        for iradar = 1:size(amp_radar,2)
            
            % Find the max range and min range of the radar to bolck
            [bins_range] = within_indicator(Rx(iradar,:),block_location,block_size(1),block_size(2));
            % Which range bins cross that block
            bins_number = find(range_vector>bins_range(2)&range_vector<bins_range(1));
            % If there is no range bin cross that block
            if isempty(bins_number)
                Max_vote(iradar) = 1; % Set the vote value to 1
            else
                Max_vote(iradar) = mean(amp_radar(bins_number,iradar));
            end
        end
        
        % Multiply all votes together, which penalises the clutter in a
        % single radar LoS
        St(ix,iy) = prod(Max_vote);
        
    end
end


end

