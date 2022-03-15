function [J] = Region_grow(image, initPos, thresVal, maxDist)

[nRow, nCol, nSli] = size(image);

% initial pixel value
% If we want to have both upper and lower limits use this
regVal = double(image(initPos(1), initPos(2), initPos(3)));

% preallocate array
J = false(nRow, nCol, nSli);

% add the initial pixel to the queue
queue = [initPos(1), initPos(2), initPos(3)];

while size(queue, 1)
  % the first queue position determines the new values
  xv = queue(1,1);
  yv = queue(1,2);
  zv = queue(1,3);
 
  % delete the first queue position
  queue(1,:) = [];
    
  % check the neighbors for the current position
  for i = -1:1
    for j = -1:1
      for k = -1:1
            
        if xv+i > 0  &&  xv+i <= nRow-1 &&...          % within the x-bounds
           yv+j > 0  &&  yv+j <= nCol-1 &&...          % within the y-bounds          
           zv+k > 0  &&  zv+k <= nSli-1 &&...          % within the z-bounds
           any([i, j, k])       &&...      % i/j/k of (0/0/0) is redundant
           ~J(xv+i, yv+j, zv+k) &&...          % pixelposition already set
           sqrt( (xv+i-initPos(1))^2 +...
                 (yv+j-initPos(2))^2 +...
                 (zv+k-initPos(3))^2 ) < maxDist &&...   % within distance?
           image(xv+i, yv+j, zv+k) >= thresVal % within range
            % If we want to have both upper and lower limits use this
%            cIM(xv+i, yv+j, zv+k) >= (regVal - thresVal) % 

           % current pixel is true, if all properties are fullfilled
           J(xv+i, yv+j, zv+k) = true; 

           % add the current pixel to the computation queue
           queue(end+1,:) = [xv+i, yv+j, zv+k];
% 
        
        end        
      end
    end  
  end
end