% 问题一代码
clear; clc; close all;

%% 第一小问：Fs=100Hz、T0=5s，对称显示DFT/DTFT/理论谱对比
% 参数设置
Fs = 100;          % 采样率(Hz)
T0 = 5;            % 信号时长(s)
T = 1/Fs;          % 采样间隔(s)
N = Fs * T0;       % 序列长度（500点）
nfft = N;          % DFT点数=序列长度
L = 2048;          % DTFT计算点数（保证频谱平滑）

% 生成离散序列（实序列，频谱天然偶对称）
n = 0:N-1;
t = n * T;
x = exp(-5 * t);   % 离散序列x[n] = x(nT)

% 计算DFT（幅度谱对称化+缩放，逼近连续谱）
h_dft = fft(x, nfft);
dft_amp = fftshift(abs(h_dft)) * T;  % fftshift转换为[-Fs/2, Fs/2)频率轴
f_dft = linspace(-Fs/2, Fs/2 - Fs/N, N);  % DFT对称频率轴

% 计算DTFT（0~2π数字角频率转为-π~π，实现对称显示）
[h_dtft, omega_digital] = freqz(x, 1, L, 'whole');  % 全频段DTFT（0~2π）
h_dtft = [h_dtft(L/2+1:end);h_dtft(1:L/2)];         % 重组为-π~π区间
omega_digital = [omega_digital(L/2+1:end)-2*pi;omega_digital(1:L/2)];
dtft_amp = abs(h_dtft) * T;                         % DTFT幅度谱缩放
f_dtft = omega_digital * Fs/(2*pi);                 % 数字角频率转物理频率(Hz)

% 计算理论谱（连续信号傅里叶变换幅度谱）
f_theo = linspace(-Fs/2, Fs/2 - Fs/N, N);
theo_amp = 1 ./ sqrt(25 + (2*pi*f_theo).^2);  % |X(jω)| = 1/√(25+ω²)

% 绘图：叠加DTFT曲线、DFT采样点、理论谱
figure('Name','第一小问频谱对比图(Fs=100Hz, T0=5s)','Color','w');
plot(f_dtft, dtft_amp, 'b-', 'LineWidth',1.5, 'DisplayName','DTFT');
hold on;
stem(f_dft, dft_amp, 'filled', 'MarkerSize',2, 'LineWidth',1.0, 'Color','b', 'DisplayName','DFT');
plot(f_theo, theo_amp, '--r', 'LineWidth',1.5, 'DisplayName','理论谱');
grid on;
legend('Location','best');
title('第一小问频谱对比图(Fs=100Hz, T0=5s)');
xlabel('频率f/Hz');
ylabel('幅度|X(j\omega)|');
xlim([-20, 20]);  % 限定频率范围，强制对称显示
ylim([0, max(theo_amp)+0.05]);
saveas(gcf, '第一小问频谱对比图.png');

%% 第二小问：分析采样率/信号时长/DFT点数对频谱的影响（对称显示）
% 改变采样率
figure('Name','不同采样率的频谱图','Color','w');
Fs_list = [25,50,100,200];
for i=1:length(Fs_list)
    subplot(2,2,i)
    Fs=Fs_list(i);
    T = 1/Fs;          
    T0=5;
    N=Fs*T0;
    n=0:N-1;
    x=exp(-5*n/Fs);
    % 计算DFT
    h_dft=fft(x,N);
    dft_amp=fftshift(abs(h_dft))/Fs;
    f_dft=linspace(-Fs/2,Fs/2-Fs/N,N);
    % 计算DTFT（对称化处理）
    [h_dtft,omega_d]=freqz(x,1,L,'whole');
    h_dtft = [h_dtft(L/2+1:end);h_dtft(1:L/2)];
    omega_d = [omega_d(L/2+1:end)-2*pi;omega_d(1:L/2)];
    dtft_amp = abs(h_dtft) * T;
    f_dtft = omega_d * Fs/(2*pi);
    % 绘图
    plot(f_dtft,dtft_amp,'b', 'LineWidth',1.5, 'DisplayName',sprintf('Fs=%dHz(DTFT)',Fs));
    hold on;
    stem(f_dft,dft_amp,'b', 'filled','MarkerSize',2, 'DisplayName',sprintf('Fs=%dHz(DFT)',Fs));
    plot(f_theo,theo_amp,'--r','LineWidth',1.5, 'DisplayName','理论谱');
    grid on; legend('Location','northeast','FontSize',8);
    xlim([-10,10])
    title(sprintf('采样率Fs=%dHz', Fs))
    xlabel('频率f/Hz');
    ylabel('幅度|X(j\omega)|');
end
saveas(gcf, '不同采样率的频谱图.png');

% 改变信号时长
figure('Name','不同信号时长的频谱图','Color','w');
T0_list=[0.2,0.5,2,5];
for i=1:length(T0_list)
    subplot(2,2,i)
    T0=T0_list(i);
    Fs=100;
    N=Fs*T0;
    T = 1/Fs;
    n=0:N-1;
    x=exp(-5*n/Fs);
    delta_f = 1/T0;  % 频率分辨率（代码中"分别率"为笔误，保留不修改）
    % 计算DFT
    h_dft=fft(x,N);
    dft_amp=fftshift(abs(h_dft))/Fs;
    f_dft=linspace(-Fs/2,Fs/2-Fs/N,N);
    % 计算DTFT（对称化处理）
    [h_dtft,omega_d]=freqz(x,1,L,'whole');
    h_dtft = [h_dtft(L/2+1:end);h_dtft(1:L/2)];
    omega_d = [omega_d(L/2+1:end)-2*pi;omega_d(1:L/2)];
    dtft_amp = abs(h_dtft) * T;
    f_dtft = omega_d * Fs/(2*pi);
    % 绘图
    plot(f_dtft,dtft_amp,'b', 'LineWidth',1.5, 'DisplayName',sprintf('T0=%.1fs(DTFT)',T0));
    hold on;
    stem(f_dft,dft_amp,'b', 'filled','MarkerSize',2, 'DisplayName',sprintf('T0=%.1fs(DFT)',T0));
    plot(f_theo,theo_amp,'--r','LineWidth',1.5, 'DisplayName','理论谱');
    xlim([-10,10])
    grid on; legend('Location','northeast','FontSize',8);
    xlim([-20,20]); ylim([0,0.25]);
    title(sprintf('信号时长T0=%.1fs，频率分别率=%.1fHz', T0, delta_f))
    xlabel('频率f/Hz');
    ylabel('幅度|X(j\omega)|');
end
saveas(gcf, '不同信号时长的频谱图.png');

% 改变DFT点数
figure('Name','不同DFT点数的频谱图','Color','w');
Fs=100; T0=5; N=500; x=exp(-5*n/Fs); nfft_list=[128,256,512,1024]; colors=['b','g','r'];
for i=1:length(nfft_list)
    subplot(2,2,i)
    nfft=nfft_list(i);
    % 计算DFT
    h_dft=fft(x,nfft);
    dft_amp=fftshift(abs(h_dft))/Fs;
    f_dft=linspace(-Fs/2,Fs/2-Fs/nfft,nfft);
    % 计算DTFT（对称化处理）
    [h_dtft,omega_d]=freqz(x,1,L,'whole');
    h_dtft = [h_dtft(L/2+1:end);h_dtft(1:L/2)];
    omega_d = [omega_d(L/2+1:end)-2*pi;omega_d(1:L/2)];
    dtft_amp = abs(h_dtft) * T;
    f_dtft = omega_d * Fs/(2*pi);
    % 绘图
    plot(f_dtft,dtft_amp,'b', 'LineWidth',1.5, 'DisplayName',sprintf('DFT点数为%d(DTFT)',nfft));
    hold on;
    stem(f_dft,dft_amp,'b', 'filled','MarkerSize',2, 'DisplayName',sprintf('DFT点数为%d(DFT)',nfft));
    plot(f_theo,theo_amp,'--r','LineWidth',1.5, 'DisplayName','理论谱');
    xlim([-10,10])
    grid on; legend('Location','northeast','FontSize',8);
    xlim([-20,20]); ylim([0,0.25]);
    xlabel('频率f/Hz');
    ylabel('幅度|X(j\omega)|');
    title(sprintf('DFT点数=%d', nfft))
end
saveas(gcf, '不同DFT点数的频谱图.png');