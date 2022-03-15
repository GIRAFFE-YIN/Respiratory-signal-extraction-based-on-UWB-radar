function [position,position_axis] = Position_estimation(Data)

position_axis = std(Data,0,2);

% range bin that we are looking for 
[~,position] = max(position_axis);

end

