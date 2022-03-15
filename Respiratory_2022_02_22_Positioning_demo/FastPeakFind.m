function  [cent, varargout]=FastPeakFind(d, filt ,edg,res)
%% defaults

% if ndims(d)>2 %I added this in case one uses imread (JPG\PNG\...).
%     d=uint16(d);
% end
% if isfloat(d) 
%     if max(d(:))<=1
%         d =  uint16( d.*2^16./(max(d(:))));
%     else
%         d = uint16(d);
%     end
% end

%% Analyze image


% add threshold if needed 
%     d = medfilt2(d,[3,3]);

%     % apply threshold
%     if isa(d,'uint8')
%         d=d.*uint8(d>thres);
%     else
%         d=d.*uint16(d>thres);
%     end

if any(d(:))    %for the case of the image is still non zero
    
    % smooth image
    d=conv2((d),filt,'same') ;
    
    % Apply again threshold
    %         d=d.*(d>0.9*thres);
    
    switch res % switch between local maxima and sub-pixel methods
        
        case 1 
            % no need to remove the noise
             sd=size(d);
             [x,y]=find(d(edg:sd(1)-edg,edg:sd(2)-edg));
%             [x,y]=find(d);
            %                 x = union(x,x+1);
            %                 x = union(x,x-1);
            %                 y = union(y,y+1);
            %                 y = union(y,y-1);
            % initialize outputs
            cent=[];%
            cent_map=zeros(sd);
%             
             x=x+edg-1;
            y=y+edg-1;
            for j=1:length(y)
                if (d(x(j),y(j))>d(x(j)-1,y(j)-1 )) &&...
                        (d(x(j),y(j))>d(x(j)-1,y(j))) &&...
                        (d(x(j),y(j))>d(x(j)-1,y(j)+1)) &&...
                        (d(x(j),y(j))>d(x(j),y(j)-1)) && ...
                        (d(x(j),y(j))>d(x(j),y(j)+1)) && ...
                        (d(x(j),y(j))>d(x(j)+1,y(j)-1)) && ...
                        (d(x(j),y(j))>d(x(j)+1,y(j))) && ...
                        (d(x(j),y(j))>d(x(j)+1,y(j)+1))
                     
                    cent = [cent ;  x(j) ; y(j)];
                    cent_map(x(j),y(j))=cent_map(x(j),y(j))+1; % if a binary matrix output is desired
                    
                end
            end
            
        case 2 % find weighted centroids of processed image,  sub-pixel resolution.

            % get peaks areas and centroids
            stats = regionprops(logical(d),d,'Area','WeightedCentroid');
           
            rel_peaks_vec=[stats.Area]<=mean([stats.Area])+2*std([stats.Area]);
            cent=[stats(rel_peaks_vec).WeightedCentroid]';
            cent_map=[];
            
    end 
    
else % in case image after threshold is all zeros
    cent=[];
    cent_map=zeros(size(d));
    if nargout>1   
        varargout{1}=cent_map; 
    end
    return
end

% return binary mask of centroid positions if asked for
if nargout>1 ;  varargout{1}=cent_map; end
