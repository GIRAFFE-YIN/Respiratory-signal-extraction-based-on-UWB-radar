clc
clear
close all


load('Grow.mat')
Mt = pleace_holder(:,:,300:600);

[x_number,y_number,z_number] = size(Mt);

for itime = 1:z_number
    St(:,:) = Mt(:,:,itime);
    threshold = (100/(x_number*y_number))*sum(St(:));
    St(St<threshold) = 0;
    Mt(:,:,itime) = St;
end
icenter = 1;
% location
% non_zero = find(Mt > 0);
% [x,y,z] = ind2sub([x_number,y_number,z_number],non_zero);
% scatter3(x,y,z,'filled');


pleace_holder = Mt;
nshift = 2;
nwidth = 10;
max_number = floor((size(Mt,3)-nwidth)/nshift);

temp = [1 1 1];

tic
for inum = 1:max_number-1
    
    pleace_holder = circshift(pleace_holder,nshift,3);
    Mt = pleace_holder(:,:,end-nwidth:end-1);
    % non_zero = find(Mt >= 500);
    % Mt(Mt <= 200) = 0;
    %%
    [x_number,y_number,z_number] = size(Mt);
    % % non_zero = find(Mt >= 200);
    % %
    % % % location
    % % [x,y,z] = ind2sub([x_number,y_number,z_number],non_zero);
    % % scatter3(x,y,z,'filled');
    % for i = 1:z_number
    %     [cent, varargout]=FastPeakFind(Mt(:,:,i), 200, 2 ,2, 1);
    %     for j = 1:length(cent)/2
    %         scatter3(cent(j*2-1),cent(j*2),i,'filled');
    %         hold on
    %     end
    % end
    %%
    
    % x = 1:x_number;
    % y = 1:y_number;
    % z = 1:z_number;
    
    % [x,y,z] = meshgrid(1:y_number,1:x_number,1:z_number);
    % c = x.^2+y.^2+z.^2;
    % xs = 1:x_number;
    % ys = 1:y_number;
    % zs = 1:z_number;
    %
    %
    % h = slice(x,y,z,Mt,xs,ys,zs);
    % set(h,'FaceColor','interp','EdgeColor','none')
    % camproj perspective
    % box on
    % view(-70,70)
    % colormap hsv
    % colorbar
    
    % for i = 1:z_number
    %     non_zero()
    
    
    dxy = 2;
    dt = 3;
    
    [Seed] = generate_seeds(x_number,y_number,z_number,dxy,dt);
    
    % iseed = 1;
    % for i = 1:z_number
    %     input = Mt(:,:,i);
    %     [cent, varargout]=FastPeakFind(input, max(input(:))/10, 2 ,2, 1);
    %     for j = 1:length(cent)/2
    %         Seed(iseed,:) = [cent(j*2-1),cent(j*2),i];
    %         iseed = iseed +1;
    %     end
    % end
    position_range =[];
    
    States = ones(size(Seed,1));
    
    for i = 1:size(Seed,1)
        if ( Mt(Seed(i,1),Seed(i,2),Seed(i,3))~=0 ) && ( States(i)~=0 )
            
            [J] = Region_grow(Mt,Seed(i,:),10,Inf);
            
            index = find(J==1);
            
            if (length(index)>50) %&& (sum(Mt(index))>length(index)*200)
                [i1,i2,i3] = ind2sub([x_number,y_number,z_number],index);
                temp = union(temp,[i1,i2,i3+inum*2],'row');
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
        center(icenter,:) = [cent 5+inum*2];
        icenter = icenter+1;
    end
    
end
toc
%%
figure
scatter3(temp(:,1),temp(:,2),temp(:,3),'filled');
hold on
% plot3(center(:,1),center(:,2),center(:,3),'-r','linewidth',2);
xlabel('Distance index in x axis');
ylabel('Distance index in y axis');
zlabel('Frame index');
