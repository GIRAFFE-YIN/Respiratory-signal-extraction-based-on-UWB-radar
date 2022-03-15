function [bins_range] = within_indicator(radar_location,block_location,r,h)
% in meter

% position of the cell
X = [block_location(1)-r/2,block_location(2)-r/2,block_location(3)+h/2;
     block_location(1)+r/2,block_location(2)-r/2,block_location(3)+h/2;
     block_location(1)-r/2,block_location(2)+r/2,block_location(3)+h/2;
     block_location(1)+r/2,block_location(2)+r/2,block_location(3)+h/2;
     block_location(1)-r/2,block_location(2)-r/2,block_location(3)-h/2;
     block_location(1)+r/2,block_location(2)-r/2,block_location(3)-h/2;
     block_location(1)-r/2,block_location(2)+r/2,block_location(3)-h/2;
     block_location(1)+r/2,block_location(2)+r/2,block_location(3)-h/2;];

num = size(X,1);
distance = zeros(1,num);

for idistance = 1:num
    distance(idistance) = norm(radar_location-X(idistance,:));
end

% 
% distance_matrix = radar_location - X;
% 
% distance = vecnorm(distance_matrix,2,2);


bins_range = [max(distance) min(distance)];

end

