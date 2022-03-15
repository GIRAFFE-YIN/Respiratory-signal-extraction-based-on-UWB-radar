function [bins] = get_range_bins(area_size,block_size,Rx,range_vector)
%GET_RANGE_BINS Summary of this function goes here
%   Detailed explanation goes here
x_number = floor(area_size(1)/block_size(1));
y_number = floor(area_size(2)/block_size(1));
% Loop for each block
bins = [];
for ix = 1:x_number
    for iy = 1:y_number
        
        block_location = [block_size(1)/2 + block_size(1) * (ix-1),... 
                          block_size(1)/2 + block_size(1) * (iy-1), area_size(3)];
        
        % Loop for each radar
        for iradar = 1:size(Rx,1)
            
            % Find the max range and min range of the radar to bolck
            [bins_range] = within_indicator(Rx(iradar,:),block_location,block_size(1),block_size(2));
            % Which range bins cross that block
            bins_number = find(range_vector>bins_range(2)&range_vector<bins_range(1));
            % If there is no range bin cross that block
           
            if isempty(bins_number)
                bins(ix,iy,iradar,:) = [0 0]; % Set the vote value to 0
            else
                bins(ix,iy,iradar,:) = [max(bins_number),min(bins_number)];
            end
            
        end
        
        % Multiply all votes together, which penalises the clutter in a
        % single radar LoS
%         St(ix,iy) = prod(Max_vote);
        
    end
end

% bins = reshape(bins,[x_number*y_number size(Rx,1) 2]);

end

