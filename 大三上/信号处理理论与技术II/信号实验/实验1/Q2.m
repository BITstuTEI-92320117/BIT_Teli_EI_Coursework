% 问题二代码
clear; clc; close all;

%% 公共参数定义
f1 = 48;          % 余弦信号频率1(Hz)
f2 = 52;          % 余弦信号频率2(Hz)
Fs = 200;         % 采样率(Hz)，满足奈奎斯特（Fs≥2*52=104）
T = 1/Fs;         % 采样间隔(s)
L = 4096;         % DTFT计算点数，保证包络平滑

%% 第一小问：T0=1s，DFT点数=序列长度
% 参数计算
T0_1 = 1;                % 信号时长(s)
N_1 = Fs * T0_1;         % 序列长度
nfft_1 = N_1;            % DFT点数=序列长度

% 生成时域双余弦序列
n_1 = 0:N_1-1;           % 时域索引
t_1 = n_1 * T;           % 采样时间轴
x_1 = cos(2*pi*f1*t_1) + cos(2*pi*f2*t_1);

% 计算DFT并处理幅度谱（对称化+归一化）
X_1 = fft(x_1, nfft_1);  % 200点DFT
amp_1 = fftshift(abs(X_1)) * T;       % 幅度谱对称化+归一化
f_1 = linspace(-Fs/2, Fs/2 - Fs/N_1, N_1);  % DFT频率轴（对称）

% 计算DTFT（生成连续包络）
[h_dtft_1, omega_d_1] = freqz(x_1, 1, L, 'whole');  % 0~2π数字角频率DTFT
dtft_amp_1 = fftshift(abs(h_dtft_1)) * T;     % DTFT幅度谱对称化+归一化
f_dtft_1 = linspace(-Fs/2, Fs/2, L);                % DTFT频率轴（对称）

% 绘制频谱：DTFT包络 + DFT采样点
figure('Name','第一小问频谱图','Color','w');
plot(f_dtft_1, dtft_amp_1, '--r', 'LineWidth',1.5, 'DisplayName','DTFT幅度谱');
hold on;
stem(f_1, amp_1, 'filled', 'MarkerSize',2, 'LineWidth',1.5, 'Color','b', 'DisplayName','DFT幅度谱');
grid on;
legend('Location','northeast');
title('第一小问频谱图');
xlabel('频率f/Hz');
ylabel('幅度|X(j\omega)|');
xlim([40, 60]);  % 聚焦40~60Hz关键频段
xticks(40:60);
xticklabels(40:60);
saveas(gcf, '第一小问频谱图.png');

%% 第二小问：T0=1s，DFT点数=256（补零）
% 参数计算：仅修改DFT点数，其余同(1)
T0_2 = 1;                % 信号时长不变
N_2 = Fs * T0_2;         % 原始序列长度(200点)
nfft_2 = 256;            % DFT点数(补56个零)

% 生成时域信号（与(1)一致）
n_2 = 0:N_2-1;
t_2 = n_2 * T;
x_2 = cos(2*pi*f1*t_2) + cos(2*pi*f2*t_2);

% 计算补零后DFT及幅度谱
X_2 = fft(x_2, nfft_2);  % 256点DFT（自动补零）
amp_2 = fftshift(abs(X_2)) * T;  % 幅度谱处理
f_2 = linspace(-Fs/2, Fs/2 - Fs/nfft_2, nfft_2);  % 补零后DFT频率轴

% 计算DTFT（序列不变，包络与(1)一致）
[h_dtft_2, omega_d_2] = freqz(x_2, 1, L, 'whole');
dtft_amp_2 = fftshift(abs(h_dtft_2)) * T;
f_dtft_2 = linspace(-Fs/2, Fs/2, L);

% 绘制频谱：对比200点/256点DFT
figure('Name','第二小问频谱图','Color','w');
plot(f_dtft_2, dtft_amp_2, '--r', 'LineWidth',1.5, 'DisplayName','DTFT幅度谱');
hold on;
stem(f_2, amp_2, 'filled', 'MarkerSize',2, 'LineWidth',1.5, 'Color','g', 'DisplayName','DFT幅度谱（256点）');
% 截取(1)中40~60Hz的DFT数据用于对比
f_1_crop = f_1(find(f_1>=40 & f_1<=60));
amp_1_crop = amp_1(find(f_1>=40 & f_1<=60));
stem(f_1_crop, amp_1_crop, 'filled','LineWidth',1.5,  'MarkerSize',2, 'Color','b', 'DisplayName','DFT幅度谱（200点）');
grid on;
legend('Location','northeast');
title('第二小问频谱图');
xlabel('频率f/Hz');
ylabel('幅度|X(j\omega)|');
xlim([40, 60]);
xticks(40:60);
xticklabels(40:60);
saveas(gcf, '第二小问频谱图.png');

%% 第三小问：不同信号时长（0.2/0.3/0.5/1.0s）频谱对比
T0_list = [0.2, 0.3, 0.5, 1.0];  % 测试信号时长
figure('Name','第三小问不同信号观测时长的频谱图对比','Color','w');

for idx = 1:length(T0_list)
    T0_3 = T0_list(idx);
    N_3 = Fs * T0_3;         % 序列长度（随时长变化）
    nfft_3 = N_3;            % DFT点数=序列长度
    delta_f = 1/T0_3;        % 频率分辨率(Hz)

    % 生成对应时长的时域序列
    n_3 = 0:N_3-1;
    t_3 = n_3 * T;
    x_3 = cos(2*pi*f1*t_3) + cos(2*pi*f2*t_3);

    % 计算DFT及幅度谱
    X_3 = fft(x_3, nfft_3);
    amp_3 = fftshift(abs(X_3)) * T;
    f_3 = linspace(-Fs/2, Fs/2 - Fs/N_3, N_3);

    % 计算DTFT（对应当前序列的包络）
    [h_dtft_3, omega_d_3] = freqz(x_3, 1, L, 'whole');
    dtft_amp_3 = fftshift(abs(h_dtft_3)) * T;
    f_dtft_3 = linspace(-Fs/2, Fs/2, L);

    % 子图绘制：DTFT包络 + DFT采样点
    subplot(2,2,idx);
    plot(f_dtft_3, dtft_amp_3, '--r', 'LineWidth',1.5, 'DisplayName','DTFT幅度谱');
    hold on;
    stem(f_3, amp_3, 'filled', 'MarkerSize',2, 'LineWidth',1.5, 'Color','b', 'DisplayName','DFT幅度谱');
    grid on;
    legend('Location','northeast','FontSize',8);
    title(sprintf('T0=%.1fs，DFT点数=%d，频率分辨率=%.1fHz', T0_3, nfft_3, delta_f));
    xlabel('频率f/Hz');
    ylabel('幅度|X(j\omega)|');
    xticks(40:60);
    xticklabels(40:60);
    xlim([40, 60]);  % 聚焦关键频段
end
saveas(gcf, '第三小问不同信号观测时长的频谱图对比.png');
