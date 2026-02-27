function plot_fft(t_cnt, cnt, L, fft_base,name)
% 绘制FFT频谱图
k = 0:L-1;
subplot(t_cnt, 1, cnt)
plot(2*pi*k/L, abs(fft_base), 'b', 'LineWidth',1.5);
xlabel('频率'); ylabel('幅度');
grid on; 
set(gca, 'FontSize',10);
xlim([0,2*pi])
title(name)
end