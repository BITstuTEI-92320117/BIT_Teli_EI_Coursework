clear,clc,close all
warning off
%% 实验参数定义
Fs = 10e3;          % 采样频率(Hz)
fp = 1e3;           % 通带截止频率(Hz)
fs = 1.5e3;         % 阻带截止频率(Hz)
Rp = 1;             % 通带波纹(dB)
As = 15;            % 阻带衰减(dB)

%% 第一问：计算巴特沃斯模拟原型的最小阶数
freq_ratio = fp / fs;                   % 通带/阻带截止频率比
numerator = log10((10^(Rp/10) - 1) / (10^(As/10) - 1));  % 阶数计算分子项
denominator = 2 * log10(freq_ratio);   % 阶数计算分母项
N = ceil(numerator / denominator);     % 最小阶数(向上取整)
fprintf('巴特沃斯滤波器的最小阶数 N = %d\n', N);

omega_p = 2 * pi * fp;   % 通带模拟角频率(rad/s)
omega_s = 2 * pi * fs;   % 阻带模拟角频率(rad/s)
omega_c1 = omega_p / ((10^(Rp/10) - 1)^(1/(2*N))); % 通带对应3dB截止频率
omega_c2 = omega_s / ((10^(As/10) - 1)^(1/(2*N))); % 阻带对应3dB截止频率
omega_c = (omega_c1 + omega_c2)/2; % 平均3dB截止频率
fprintf('模拟原型滤波器的3dB截止频率 ωc = %.4f rad/s\n', omega_c);
[b, a] = butter(N, omega_c, 's'); % 设计巴特沃斯模拟滤波器

%% 第二问：设计数字滤波器（冲激响应不变法+双线性变换法）
% 冲激响应不变法 
[b_imp, a_imp] = impinvar(b, a, Fs);  % 模拟→数字(冲激响应不变法)

% 计算冲激响应不变法频率响应
[H_imp, w_imp] = freqz(b_imp, a_imp, 1024);  % 频率响应(1024点)
mag_imp = abs(H_imp);               % 线性幅频响应
mag_dB_imp = 20 * log10(mag_imp);   % 分贝幅频响应
phase_imp = angle(H_imp);           % 相频响应(rad)
[gd_imp, w_gd_imp] = grpdelay(b_imp, a_imp, 1024);  % 群延迟

% 双线性变换法(含频率预畸)
omega_p_bilin = 2 * Fs * tan(pi * fp / Fs);  % 通带预畸模拟频率
omega_s_bilin = 2 * Fs * tan(pi * fs / Fs);  % 阻带预畸模拟频率
omega_c1_bilin = omega_p_bilin / ((10^(Rp/10) - 1)^(1/(2*N))); % 预畸通带3dB截止频率
omega_c2_bilin = omega_s_bilin / ((10^(As/10) - 1)^(1/(2*N))); % 预畸阻带3dB截止频率
omega_c_bilin = (omega_c1_bilin + omega_c2_bilin)/2; % 预畸平均3dB截止频率
[b_bilin_ana, a_bilin_ana] = butter(N, omega_c_bilin, 's'); % 预畸模拟滤波器
[b_bilin, a_bilin] = bilinear(b_bilin_ana, a_bilin_ana, Fs); % 模拟→数字(双线性变换)

% 计算双线性变换法频率响应
[H_bilin, w_bilin] = freqz(b_bilin, a_bilin, 1024); % 频率响应(1024点)
mag_bilin = abs(H_bilin); % 线性幅频响应
mag_dB_bilin = 20 * log10(mag_bilin); % 分贝幅频响应
phase_bilin = angle(H_bilin); % 相频响应(rad)
[gd_bilin, w_gd_bilin] = grpdelay(b_bilin, a_bilin, 1024); % 群延迟

%% 绘图：频率响应可视化
% 冲激响应不变法频率响应
figure('Name', '冲激响应不变法-频率响应', 'Color', 'w');

subplot(2, 2, 1);
plot(w_imp/pi, mag_imp, 'LineWidth', 1.2, 'Color', 'b');
grid on;
title('冲激响应不变法 - 线性幅频响应|H(e^{j\omega})|');
xlabel('\omega/(\pi)');
ylabel('|H(e^{j\omega})|');
xlim([0, 1]); 
ylim([0, 1]);

subplot(2, 2, 2);
plot(w_imp/pi, mag_dB_imp, 'LineWidth', 1.2, 'Color', 'b');
grid on;
title('冲激响应不变法 - 幅频响应(dB)');
xlabel('\omega/(\pi)');
ylabel('|H(e^{j\omega})|(dB)');
xlim([0, 1]); 
ylim([-120, 0]);

subplot(2, 2, 3);
plot(w_imp/pi, phase_imp, 'LineWidth', 1.2, 'Color', 'b');
grid on;
title('冲激响应不变法 - 相频响应');
xlabel('\omega/(\pi)');
ylabel('Phase of H(e^{j\omega}) (rad)');
xlim([0, 1]);

subplot(2, 2, 4);
plot(w_gd_imp/pi, gd_imp, 'LineWidth', 1.2, 'Color', 'b');
grid on;
title('冲激响应不变法 - 群延迟');
xlabel('\omega/(\pi)');
ylabel('Group delay');
xlim([0, 1]); 
saveas(gcf, '冲激响应不变法-频率响应.png') % 保存图片

% 双线性变换法频率响应
figure('Name', '双线性变换法-频率响应', 'Color', 'w');

subplot(2, 2, 1);
plot(w_bilin/pi, mag_bilin, 'LineWidth', 1.2, 'Color', 'b');
grid on;
title('双线性变换法 - 线性幅频响应|H(e^{j\omega})|');
xlabel('\omega/(\pi)');
ylabel('|H(e^{j\omega})|');
xlim([0, 1]); 
ylim([0, 1])

subplot(2, 2, 2);
plot(w_bilin/pi, mag_dB_bilin, 'LineWidth', 1.2, 'Color', 'b');
grid on;
title('双线性变换法 - 幅频响应');
xlabel('\omega/(\pi)');
ylabel('|H(e^{j\omega})| (dB)');
xlim([0, 1]); 
ylim([-300, 0]);

subplot(2, 2, 3);
plot(w_bilin/pi, phase_bilin, 'LineWidth', 1.2, 'Color', 'b');
grid on;
title('双线性变换法 - 相频响应（rad）');
xlabel('\omega/(\pi)');
ylabel('Phase of H(e^{j\omega}) (rad)');
xlim([0, 1]); 

subplot(2, 2, 4);
plot(w_gd_bilin/pi, gd_bilin, 'LineWidth', 1.2, 'Color', 'b');
grid on;
title('双线性变换法 - 群延迟');
xlabel('\omega/(\pi)');
ylabel('Group delay');
xlim([0, 1]);
saveas(gcf, '双线性变换法-频率响应.png') % 保存图片

%% 指标验证
% 冲激响应不变法验证
op = 2*pi*fp/Fs; % 通带数字角频率
os = 2*pi*fs/Fs; % 阻带数字角频率
fp_idx_imp = find(w_imp >= op, 1, 'first');  % 通带频率点索引
rp_imp = mag_dB_imp(fp_idx_imp - 1);        % 通带波纹(dB)
fs_idx_imp = find(w_imp >= os, 1, 'first');  % 阻带频率点索引
as_imp = mag_dB_imp(fs_idx_imp);            % 阻带衰减(dB)

% 双线性变换法验证
fp_idx_bilin = find(w_bilin >= op, 1, 'first'); % 通带频率点索引
rp_bilin = mag_dB_bilin(fp_idx_bilin - 1);     % 通带波纹(dB)
fs_idx_bilin = find(w_bilin >= os, 1, 'first'); % 阻带频率点索引
as_bilin = mag_dB_bilin(fs_idx_bilin);         % 阻带衰减(dB)

% 输出验证结果
fprintf('\n==================== 指标验证结果 ====================\n');
fprintf('冲激响应不变法：\n');
fprintf('  通带波纹：%.2f dB ≤ %d dB\n', abs(rp_imp), Rp);
fprintf('  阻带衰减：%.2f dB ≥ %d dB\n', abs(as_imp), As);
fprintf('双线性变换法：\n');
fprintf('  通带波纹：%.2f dB ≤ %d dB\n', abs(rp_bilin), Rp);
fprintf('  阻带衰减：%.2f dB ≥ %d dB\n', abs(as_bilin), As);