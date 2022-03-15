function [clowpassed] = downconversion(rf_cube,fc,fs)

% Down conversion. RF signal to Baseband Signal.
% rf_cube --- The input data matrix (M * N) has M range bin and N frame
% fc --- center frequency
% fs --- samplying frequency
%
% by Maowen 
% 05/10/2020

csice_cube = zeros(size(rf_cube));

csine = exp(-1j*(fc/fs)*2*pi*(0:size(rf_cube,1)-1));

for icol = 1:size(rf_cube,2)
    csice_cube(:,icol) = csine;
end

c_cube = csice_cube .* rf_cube;

clowpassed = lowpass(c_cube,fc,fs);

end

