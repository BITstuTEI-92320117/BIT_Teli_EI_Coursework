clear,clc,close all
%% 通用参数初始化
Fs = 20e3;          % 采样频率(Hz)
Nyquist = Fs/2;     % 奈奎斯特频率(Hz)
nfft = 1024;        % 频率响应计算点数

%% 1. 巴特沃斯高通滤波器设计
% 设计指标
Rp_high = 3;        % 通带波纹(dB)
As_high = 30;       % 阻带衰减(dB)
fp_high = 5e3;      % 通带截止频率(Hz)
fs_high = 3e3;      % 阻带截止频率(Hz)

% 频率归一化（至奈奎斯特频率）
Wp_high = fp_high / Nyquist;  
Wst_high = fs_high / Nyquist;

% 计算滤波器最小阶数和截止频率
[N_high, Wn_high] = buttord(Wp_high, Wst_high, Rp_high, As_high);
fprintf('=== 巴特沃斯高通滤波器 ===\n');

% 设计高通滤波器并计算频率响应
[b_high, a_high] = butter(N_high, Wn_high, 'high');
[H_high, w_high] = freqz(b_high, a_high, nfft);
mag_dB_high = 20 * log10(abs(H_high)); % 分贝幅频响应

% 指标验证计算
fp_high_norm = pi*fp_high/(Fs/2);  % 通带起始归一化角频率
fs_high_norm = pi*fs_high/(Fs/2);  % 阻带终止归一化角频率

% 通带波纹（通带内dB值最大差值）
passband_idx_high = find(w_high >= fp_high_norm);
rp_actual_high = max(mag_dB_high(passband_idx_high)) - min(mag_dB_high(passband_idx_high));

% 阻带衰减（阻带内最小衰减值）
stopband_idx_high = find(w_high <= fs_high_norm);
as_actual_high = abs(max(mag_dB_high(stopband_idx_high)));

% 输出验证结果
fprintf('巴特沃斯高通滤波器：\n');
fprintf('  通带波纹：%.2f dB ≤ %d dB\n', rp_actual_high, Rp_high);
fprintf('  阻带衰减：%.2f dB ≥ %d dB\n\n', as_actual_high, As_high);

% 绘制频率响应图
figure('Name', '巴特沃斯高通滤波器频率响应', 'Color', 'w');
subplot(2, 2, 1);
plot(w_high/pi, abs(H_high), 'LineWidth', 1.2, 'Color', 'b');
grid on;
title('巴特沃斯高通滤波器 - 线性幅频响应');
xlabel('\omega/(\pi)');
ylabel('|H(e^{j\omega})|');
xlim([0, 1]); ylim([0, 1]);

subplot(2, 2, 2);
plot(w_high/pi, mag_dB_high, 'LineWidth', 1.2, 'Color', 'b');
grid on;
title('巴特沃斯高通滤波器 - 幅频响应(dB)');
xlabel('\omega/(\pi)');
ylabel('|H(e^{j\omega})| (dB)');
xlim([0, 1]); ylim([-300, 0]);

subplot(2, 2, 3);
plot(w_high/pi, angle(H_high), 'LineWidth', 1.2, 'Color', 'b');
grid on;
title('巴特沃斯高通滤波器 - 相频响应');
xlabel('\omega/(\pi)');
ylabel('Phase of H(e^{j\omega}) (rad)');
xlim([0, 1]);

subplot(2, 2, 4);
[gd_high, w_gd_high] = grpdelay(b_high, a_high, nfft);
plot(w_gd_high/pi, gd_high, 'LineWidth', 1.2, 'Color', 'b');
grid on;
title('巴特沃斯高通滤波器 - 群延迟');
xlabel('\omega/(\pi)');
ylabel('Group delay');
xlim([0, 1]);
saveas(gcf, '巴特沃斯高通滤波器-频率响应.png');

%% 2. 切比雪夫I型带通滤波器设计
% 设计指标
Rp_bp = 3;          % 通带波纹(dB)
As_bp = 30;         % 阻带衰减(dB)
fp_bp = [2e3, 3e3]; % 通带频率范围(Hz)
fs_bp = [1e3, 4e3]; % 阻带频率范围(Hz)

% 频率归一化（至奈奎斯特频率）
Wp_bp = fp_bp / Nyquist;
Wst_bp = fs_bp / Nyquist;

% 计算滤波器最小阶数和截止频率
[N_bp, Wn_bp] = cheb1ord(Wp_bp, Wst_bp, Rp_bp, As_bp);
fprintf('=== 切比雪夫I型带通滤波器 ===\n');

% 设计带通滤波器并计算频率响应
[b_bp, a_bp] = cheby1(N_bp, Rp_bp, Wn_bp, 'bandpass');
[H_bp, w_bp] = freqz(b_bp, a_bp, nfft);
mag_dB_bp = 20 * log10(abs(H_bp)); % 分贝幅频响应

% 指标验证计算
fp1_bp_norm = pi*fp_bp(1)/(Fs/2);  % 通带下限归一化角频率
fp2_bp_norm = pi*fp_bp(2)/(Fs/2);  % 通带上限归一化角频率
fs1_bp_norm = pi*fs_bp(1)/(Fs/2);  % 下阻带上限归一化角频率
fs2_bp_norm = pi*fs_bp(2)/(Fs/2);  % 上阻带下限归一化角频率

% 通带波纹（通带内dB值最大差值）
passband_idx_bp = find(w_bp >= fp1_bp_norm & w_bp <= fp2_bp_norm);
rp_actual_bp = max(mag_dB_bp(passband_idx_bp)) - min(mag_dB_bp(passband_idx_bp));

% 阻带衰减（两个阻带最小衰减值）
stopband1_idx_bp = find(w_bp <= fs1_bp_norm);
stopband2_idx_bp = find(w_bp >= fs2_bp_norm);
as_actual1_bp = abs(max(mag_dB_bp(stopband1_idx_bp)));
as_actual2_bp = abs(max(mag_dB_bp(stopband2_idx_bp)));
as_actual_bp = min(as_actual1_bp, as_actual2_bp);

% 输出验证结果
fprintf('切比雪夫I型带通滤波器：\n');
fprintf('  通带波纹：%.2f dB ≤ %d dB\n', rp_actual_bp, Rp_bp);
fprintf('  阻带衰减：%.2f dB ≥ %d dB\n\n', as_actual_bp, As_bp);

% 绘制频率响应图
figure('Name', '切比雪夫I型带通滤波器频率响应', 'Color', 'w');
subplot(2, 2, 1);
plot(w_bp/pi, abs(H_bp), 'LineWidth', 1.2, 'Color', 'b');
grid on;
title('切比雪夫I型带通滤波器 - 线性幅频响应');
xlabel('\omega/(\pi)');
ylabel('|H(e^{j\omega})|');
xlim([0, 1]); ylim([0, 1]);

subplot(2, 2, 2);
plot(w_bp/pi, mag_dB_bp, 'LineWidth', 1.2, 'Color', 'b');
grid on;
title('切比雪夫I型带通滤波器 - 幅频响应(dB)');
xlabel('\omega/(\pi)');
ylabel('|H(e^{j\omega})| (dB)');
xlim([0, 1]); ylim([-300, 0]);

subplot(2, 2, 3);
plot(w_bp/pi, angle(H_bp), 'LineWidth', 1.2, 'Color', 'b');
grid on;
title('切比雪夫I型带通滤波器 - 相频响应');
xlabel('\omega/(\pi)');
ylabel('Phase of H(e^{j\omega}) (rad)');
xlim([0, 1]);

subplot(2, 2, 4);
[gd_bp, w_gd_bp] = grpdelay(b_bp, a_bp, nfft);
plot(w_gd_bp/pi, gd_bp, 'LineWidth', 1.2, 'Color', 'b');
grid on;
title('切比雪夫I型带通滤波器 - 群延迟');
xlabel('\omega/(\pi)');
ylabel('Group delay');
xlim([0, 1]);
saveas(gcf, '切比雪夫I型带通滤波器-频率响应.png');

%% 3. 切比雪夫II型带阻滤波器设计
% 设计指标
Rp_bs = 3;          % 通带波纹(dB)
As_bs = 30;         % 阻带衰减(dB)
fp_bs = [3e3, 6e3]; % 通带频率范围(Hz)
fs_bs = [4e3, 5e3]; % 阻带频率范围(Hz)

% 频率归一化（至奈奎斯特频率）
Wp_bs = fp_bs / Nyquist;
Wst_bs = fs_bs / Nyquist;

% 计算滤波器最小阶数和截止频率
[N_bs, Wn_bs] = cheb2ord(Wp_bs, Wst_bs, Rp_bs, As_bs);
fprintf('=== 切比雪夫II型带阻滤波器 ===\n');

% 设计带阻滤波器并计算频率响应
[b_bs, a_bs] = cheby2(N_bs, As_bs, Wn_bs, 'stop');
[H_bs, w_bs] = freqz(b_bs, a_bs, nfft);
mag_dB_bs = 20 * log10(abs(H_bs)); % 分贝幅频响应

% 指标验证计算
fp1_bs_norm = pi*fp_bs(1)/(Fs/2);  % 下通带上限归一化角频率
fp2_bs_norm = pi*fp_bs(2)/(Fs/2);  % 上通带下限归一化角频率
fs1_bs_norm = pi*fs_bs(1)/(Fs/2);  % 阻带下限归一化角频率
fs2_bs_norm = pi*fs_bs(2)/(Fs/2);  % 阻带上限归一化角频率

% 通带波纹（两个通带合并后dB值最大差值）
passband1_idx_bs = find(w_bs <= fp1_bs_norm);
passband2_idx_bs = find(w_bs >= fp2_bs_norm);
mag_dB_pass_all_bs = [mag_dB_bs(passband1_idx_bs); mag_dB_bs(passband2_idx_bs)];
rp_actual_bs = max(mag_dB_pass_all_bs) - min(mag_dB_pass_all_bs);

% 阻带衰减（阻带内最小衰减值）
stopband_idx_bs = find(w_bs >= fs1_bs_norm & w_bs <= fs2_bs_norm);
as_actual_bs = abs(max(mag_dB_bs(stopband_idx_bs)));

% 输出验证结果
fprintf('切比雪夫II型带阻滤波器：\n');
fprintf('  通带波纹：%.2f dB ≤ %d dB\n', rp_actual_bs, Rp_bs);
fprintf('  阻带衰减：%.2f dB ≥ %d dB\n\n', as_actual_bs, As_bs);

% 绘制频率响应图
figure('Name', '切比雪夫II型带阻滤波器频率响应', 'Color', 'w');
subplot(2, 2, 1);
plot(w_bs/pi, abs(H_bs), 'LineWidth', 1.2, 'Color', 'b');
grid on;
title('切比雪夫II型带阻滤波器 - 线性幅频响应');
xlabel('\omega/(\pi)');
ylabel('|H(e^{j\omega})|');
xlim([0, 1]); ylim([0, 1]);

subplot(2, 2, 2);
plot(w_bs/pi, mag_dB_bs, 'LineWidth', 1.2, 'Color', 'b');
grid on;
title('切比雪夫II型带阻滤波器 - 幅频响应(dB)');
xlabel('\omega/(\pi)');
ylabel('|H(e^{j\omega})| (dB)');
xlim([0, 1]);

subplot(2, 2, 3);
plot(w_bs/pi, angle(H_bs), 'LineWidth', 1.2, 'Color', 'b');
grid on;
title('切比雪夫II型带阻滤波器 - 相频响应');
xlabel('\omega/(\pi)');
ylabel('Phase of H(e^{j\omega}) (rad)');
xlim([0, 1]);

subplot(2, 2, 4);
[gd_bs, w_gd_bs] = grpdelay(b_bs, a_bs, nfft);
plot(w_gd_bs/pi, gd_bs, 'LineWidth', 1.2, 'Color', 'b');
grid on;
title('切比雪夫II型带阻滤波器 - 群延迟');
xlabel('\omega/(\pi)');
ylabel('Group delay');
xlim([0, 1]);
saveas(gcf, '切比雪夫II型带阻滤波器-频率响应.png');