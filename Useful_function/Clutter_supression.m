function [clutter_data,denoised_data] = Clutter_supression(raw_data,denoised_data,clutter_data,amax,amin)

   envelope_received = envelope(raw_data);
   envelope_denoised = envelope(denoised_data);

   a = zeros(length(envelope_received),1);

   for ifast = 1:length(envelope_denoised)
       d = min(envelope_received(ifast),envelope_denoised(ifast))/envelope_received(ifast);
       a(ifast) = amin + (amax-amin)*d;
   end

   clutter_data = a.*clutter_data + (1-a).*raw_data;
   denoised_data = raw_data - clutter_data;

end

