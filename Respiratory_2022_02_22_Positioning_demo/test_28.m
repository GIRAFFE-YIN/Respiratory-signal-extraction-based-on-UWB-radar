
% Generate animation and movie file
if genanimation_STFT == 'y'
if genmovie_STFT == 'y'
v = VideoWriter('STFT_RangeFrequencyTime_Animation_Simulations_TwoRadars.mp4','MPEG-4');
v.FrameRate = 1/frame_interval; %Frames per second in the video
open(v)
end
figure('Name','Range-Doppler-Time Representation - STFT','Position',scrsz)
for i=1:t_step:length(t_axis_STFT)
clf % Clears entire figure
subplot(1,2,1)
hold on
h = pcolor(range_axis_data,f_axis_STFT,20*log10(abs(spec_data_tensor_1(:,:,i)'+eps)));
for k=ind
plot(Body_displ_doppler_mtx_STFT_1((2*k)-1,i),Body_displ_doppler_mtx_STFT_1((2*k),i),'.','MarkerSize',20)
end
colormap(gray)
clim = get(gca,'CLim'); %CLim ="color limits".
set(gca,'CLim',clim(2) + [-50 -5]);
xlim([range_axis_data(1) range_axis_data(end)])
set(h, 'EdgeColor', 'none')
xlabel('Range (m)','FontSize',11); ylabel('Doppler Frequency (Hz)','FontSize',11);
set(gca,'FontSize',11)
h_2 = colorbar;
set(get(h_2,'label'),'string','Power/frequency (dB/Hz)','FontSize',11);
title(['Radar 1: STFT - Time: ', num2str(t_axis_STFT(i)),' s']);
legend('STFT Spectrum',BodyParts_1(ind).name,'Location','South');
subplot(1,2,2)
hold on
h = pcolor(range_axis_data,f_axis_STFT,20*log10(abs(spec_data_tensor_2(:,:,i)'+eps)));
for k=ind
plot(Body_displ_doppler_mtx_STFT_2((2*k)-1,i),Body_displ_doppler_mtx_STFT_2((2*k),i),'.','MarkerSize',20)
end
colormap(gray)
clim = get(gca,'CLim'); %CLim ="color limits".
set(gca,'CLim',clim(2) + [-50 -5]);
xlim([range_axis_data(1) range_axis_data(end)])
set(h, 'EdgeColor', 'none')
xlabel('Range (m)','FontSize',11); ylabel('Doppler Frequency (Hz)','FontSize',11);
set(gca,'FontSize',11)
h_2 = colorbar;
set(get(h_2,'label'),'string','Power/frequency (dB/Hz)','FontSize',11);
title(['Radar 2: STFT - Time: ', num2str(t_axis_STFT(i)),' s']);
legend('STFT Spectrum',BodyParts_2(ind).name,'Location','South');
drawnow
if genmovie_STFT == 'y'
frame = getframe(gcf);
writeVideo(v,frame);
end
end
if genmovie_STFT == 'y'
close(v)
end
end

