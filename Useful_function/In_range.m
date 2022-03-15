function [A] = In_range(position,distance_range)
if(position(end-3) < position(end-2) + distance_range) && (position(end-3) >  position(end-2) - distance_range)
    if (position(end-2) < position(end-1) + distance_range) && (position(end-2) >  position(end-1) - distance_range)
        if (position(end-1) < position(end) + distance_range) && (position(end-1) >  position(end) - distance_range)
            A = 1;
            return
        end
    end
end
A=0;
end

