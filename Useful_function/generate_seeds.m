function [Seed] = generate_seeds(x_number,y_number,z_number,dxy,dt)


% Seed = zeros((floor(x_number/dxy)-1)*(floor(y_number/dxy)-1)...
%         *(floor(z_number/dt)-2),1);
Seed = zeros((floor(x_number/dxy))*(floor(y_number/dxy))...
         *(floor(z_number/dt)),3);

i = 1;
for ix = 1 : floor(x_number/dxy)
    for iy = 1:floor(y_number/dxy)
        for it = 1:floor(z_number/dt)
%             Seed(i) = sub2ind([x_number,y_number,z_number],ix*dxy,iy*dxy,it*dt);
            Seed(i,:) = [ix*dxy,iy*dxy,it*dt];
            i = i+1;
        end
    end
end



end

