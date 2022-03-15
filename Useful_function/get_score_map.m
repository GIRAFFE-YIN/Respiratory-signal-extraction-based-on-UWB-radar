function [St] = get_score_map(bins,amp_radar)
%GET_SCORE_MAP Summary of this function goes here
%   Detailed explanation goes here
[xmax,ymax,radarsize,~] = size(bins);
Max_vote = zeros(radarsize,1,'single');
St = zeros(xmax,ymax,'single');


for ix = 1:xmax
    for iy = 1:ymax

        for iradar = 1:radarsize
            
%             Max_vote(ixy,iradar) = mean(amp_radar(bins(ixy,iradar,2):bins(ixy,iradar,1),iradar));
%             
            % If there is no range bin cross that block
            if sum(bins(ix,iy,iradar,:))==0
                Max_vote(iradar) = 1; % Set the vote value to 1
            else
                Max_vote(iradar) = mean(amp_radar(bins(ix,iy,iradar,2):bins(ix,iy,iradar,1),iradar));
            end
        end
        
        % Multiply all votes together, which penalises the clutter in a
        % single radar LoS
        St(ix,iy) = prod(Max_vote);
    end    
end

% [xymax,radarsize,~] = size(bins);
% Max_vote = zeros(radarsize,1,'single');
% St = zeros(xymax,1,'single');
% % Loop for each block
% 
% for ixy = 1:xymax
% 
%         for iradar = 1:radarsize
%             
% %             Max_vote(ixy,iradar) = mean(amp_radar(bins(ixy,iradar,2):bins(ixy,iradar,1),iradar));
% %             
%             % If there is no range bin cross that block
%             if sum(bins(ixy,iradar,:))==0
%                 Max_vote(iradar) = 1; % Set the vote value to 1
%             else
%                 Max_vote(iradar) = mean(amp_radar(bins(ixy,iradar,2):bins(ixy,iradar,1),iradar));
%             end
%         end
%         
%         % Multiply all votes together, which penalises the clutter in a
%         % single radar LoS
%         St(ixy) = prod(Max_vote);
%          
% end

% St = Max_vote(:,1).*Max_vote(:,2);

end

