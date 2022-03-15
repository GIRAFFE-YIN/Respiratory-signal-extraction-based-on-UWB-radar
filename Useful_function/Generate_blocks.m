function [S,x_number,y_number] = Generate_blocks(x_length,y_length,r)

x_number = floor(x_length/r);
y_number = floor(y_length/r);

S = zeros(x_number,y_number,2);
for ix = 1:x_number
    for iy = 1:y_number
        S(ix,iy,:) = [r/2 + (r-1) * ix, r/2 + (r-1) * iy];
    end
end


end

