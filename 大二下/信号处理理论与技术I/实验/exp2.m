% % 定义不同的 RC 值
% RC_values = [0.001, 0.01, 0.1]; 
% 
% % 定义频率范围
% omega = logspace(0, 5, 1000); 
% 
% figure;
% for i = 1:length(RC_values)
%     RC = RC_values(i);
%     H = 1 ./ (1 + 1j * omega * RC); % 计算系统函数
%     mag_H = abs(H); % 计算幅频响应的幅度
%     loglog(omega, mag_H); % 用对数坐标绘制幅频响应
%     hold on;
% end
% 
% % 画RC电路幅频响应
% xlabel('\omega (rad/s)');
% ylabel('|H(j\omega)|');
% title('RC电路幅频响应');
% legend(cellstr(num2str(RC_values', 'RC = %g')));
% grid on;

% 采样参数设置
Fs = 10000;          
T = 1/Fs;             
t = 0:T:0.2-T;        
N = length(t);        

% 生成输入信号
f1 = 100;            
f2 = 3000;           
x = cos(2*pi*f1*t) + cos(2*pi*f2*t);

% 设计RC低通滤波器
RC = 1/(1000*pi);     % RC时间常数，对应截止频率fc=500Hz
fc = 1/(2*pi*RC);     

% 正确计算系统频率响应(双边)
f = (-N/2:N/2-1)*(Fs/N);  
H = 1./(1 + 1j*2*pi*abs(f)*RC); 

% 频域滤波实现(修正版)
X = fftshift(fft(x));  
Y = X .* H;           
y = ifft(ifftshift(Y));  

% 计算频谱用于可视化
X_mag = abs(X)/N;      % 原始信号幅度谱
Y_mag = abs(Y)/N;      % 滤波后信号幅度谱

% 绘制时域波形
figure('Position', [100, 100, 800, 600]);

subplot(2,1,1);
plot(t, x);
title('原始输入信号 x(t) = cos(2π·100t) + cos(2π·3000t)');
xlabel('时间 (s)');
ylabel('幅度');
grid on;

subplot(2,1,2);
plot(t, real(y));     
title(['滤波后信号 (RC = ', num2str(RC), ' s, fc = ', num2str(fc), ' Hz)']);
xlabel('时间 (s)');
ylabel('幅度');
grid on;

% 绘制系统频率响应曲线
figure('Position', [100, 200, 800, 600]);
w = logspace(0, 5, 1000);

% 幅频响应子图
subplot(2,1,1);
H_mag = abs(1 ./ (1 + 1j*w*RC));  % 计算幅频响应
loglog(w, H_mag, 'LineWidth', 1.5, 'Color', '#0072BD');  % 蓝色曲线，匹配常见图表风格
hold on;
title('RC电路幅频响应');
xlabel('\omega (rad/s)');
ylabel('|H(j\omega)|');
grid on;
set(gca, 'XScale', 'log', 'YScale', 'log');

% 相频响应子图
subplot(2,1,2);
H_phase = angle(1 ./ (1 + 1j*w*RC)) * 180/pi;  % 相位转角度
semilogx(w, H_phase, 'LineWidth', 1.5, 'Color', '#0072BD');  % 蓝色曲线
hold on;
title('RC电路相频响应');
xlabel('\omega (rad/s)');
ylabel('相位 (°)');
grid on;
set(gca, 'XScale', 'log');  



