function [t1,x1_t] = myLPF(t,x_t,Band)
[f,X_f] = T2F(t,x_t);
X1_f = X_f.*(-Band < f & f < Band);
[t1,x1_t] = F2T(f,X1_f);
% % ================== 添加幅频响应曲线绘制 ==================
% % 计算采样频率和Nyquist频率
% dt = t(2) - t(1);
% Fs = 1 / dt;
% Nyquist = Fs / 2;
% 
% % 创建频率向量（0到Nyquist）
% f_plot = linspace(0, Nyquist, 1000);
% 
% % 创建理想低通滤波器的幅度响应
% mag_linear = double(abs(f_plot) < Band);
% 
% % 创建图形窗口
% figure('Name', '理想低通滤波器幅频响应', 'NumberTitle', 'off', 'Position', [100, 100, 800, 400]);
% 
% % 绘制幅频响应（线性幅度）
% plot(f_plot, mag_linear, 'b', 'LineWidth', 1.5);
% hold on;
% 
% 
% 
% % 添加标题和标签
% title(sprintf('理想低通滤波器幅频响应 (截止频率 = %.1f Hz)', Band));
% xlabel('频率 (Hz)');
% ylabel('幅度 (倍数)');
% grid on;
% 
% % 设置坐标轴范围
% axis([0 5000 0 1.1]);
% 
% % 添加图例
% legend('幅频响应', 'Location', 'northeast');
% 
% % 添加参数说明
% annotation('textbox', [0.15 0.01 0.7 0.05], 'String', ...
%     sprintf('截止频率: %.1f Hz | Nyquist频率: %.1f Hz', Band, Nyquist), ...
%     'FitBoxToText', 'on', 'BackgroundColor', [0.95 0.95 0.95], 'EdgeColor', 'none');
% 
% 
% % 添加截止频率标注
% saveas(gcf,'理想低通滤波器幅频响应.fig');
end