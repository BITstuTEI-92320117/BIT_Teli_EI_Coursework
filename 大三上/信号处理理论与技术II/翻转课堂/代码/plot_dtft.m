function plot_dtft(a)
% 绘制DTFT频谱图
figure('Color','w','Name','DTFT频谱图')
omega = 0:pi/1500:2*pi;
X = 1./(1 - a*exp(-1j*omega));
plot(omega, abs(X), 'b','LineWidth',1.5);
xlabel('频率'); ylabel('幅度');
grid on; 
set(gca, 'FontSize',10);
xlim([0,2*pi])
title('DTFT频谱图')
saveas(gca,'dtft.png')
saveas(gcf, 'DTFT频谱图.png')
end