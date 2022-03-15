function [output] = Adaptive_clutter_suppression(received_data,amax,amin)

[row,col] = size(received_data);

a = zeros(row,1);

% use first 10 frame to construct the clutter map
frame_addition = 50;
denoised_data = zeros(row,col+frame_addition);
clutter_data = zeros(row,col+frame_addition);

received_data = [fliplr(received_data(:,1:frame_addition)) received_data];
denoised_data(:,1) = received_data(:,1);
% clutter_data(:,1) = received_data(:,1);

for islow = 2:col+frame_addition
    envelope_received = normalize(envelope(received_data(:,islow-1)),'range',[1 2]);
    envelope_denoised = normalize(envelope(denoised_data(:,islow-1)),'range',[1 2]);
    for ifast = 1:row
        d = min(envelope_received(ifast),envelope_denoised(ifast))/envelope_received(ifast);
        a(ifast) = amin + (amax-amin)*d;
    end
    clutter_data(:,islow) = a.*clutter_data(:,islow-1) + (1-a).*received_data(:,islow-1);
    denoised_data(:,islow) = received_data(:,islow) - clutter_data(:,islow);
end

output = denoised_data(:,frame_addition+1:end);
end

% a = zeros(row,1);
% 
% % use first 10 frame to construct the clutter map
% denoised_data = zeros(row,col+10);
% clutter_data = zeros(row,col+10);
% 
% denoised_data(:,1:10) = received_data(:,1:10);
% clutter_data(:,1:10) = received_data(:,1:10);
% 
% received_data = [received_data(:,1:10) received_data];
% 
% for islow = 2:col
%     envelope_received = abs(hilbert(abs(received_data(:,islow-1))));
%     envelope_denoised = abs(hilbert(abs(denoised_data(:,islow-1))));
%     for ifast = 1:row
%         d = min(envelope_received(ifast),envelope_denoised(ifast))/envelope_received(ifast);
%         a(ifast) = amin + (amax-amin)*d;
%     end
%     clutter_data(:,islow) = a.*clutter_data(:,islow-1) + (1-a).*received_data(:,islow);
%     denoised_data(:,islow) = received_data(:,islow) - clutter_data(:,islow);
% end
% 
% output = denoised_data(:,11:end);
% end
% function [denoised_data] = Adaptive_clutter_suppression(received_data,amax,amin)
% 
% [row,col] = size(received_data);
% 
% a = zeros(row,1);
% denoised_data = zeros(row,col);
% clutter_data = zeros(row,col);
% 
% denoised_data(:,1) = received_data(:,1);
% clutter_data(:,1) = received_data(:,1);
% 
% for islow = 2:col
%     envelope_received = abs(hilbert(abs(received_data(:,islow-1))));
%     envelope_denoised = abs(hilbert(abs(denoised_data(:,islow-1))));
%     for ifast = 1:row
%         d = min(envelope_received(ifast),envelope_denoised(ifast))/envelope_received(ifast);
%         a(ifast) = amin + (amax-amin)*d;
%     end
%     clutter_data(:,islow) = a.*clutter_data(:,islow-1) + (1-a).*received_data(:,islow);
%     denoised_data(:,islow) = received_data(:,islow) - clutter_data(:,islow);
% end
% 
% end

