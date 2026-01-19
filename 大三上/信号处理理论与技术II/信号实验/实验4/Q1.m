% 窗函数法设计1型线性相位FIR低通滤波器（单窗单图+自动保存）
% 设计指标：ω_p=0.3π, R_p=1dB, ω_s=0.4π, A_s=50dB
clear; clc; close all;

% 滤波器通用参数
wp = 0.3 * pi;          % 通带截止角频率
ws = 0.4 * pi;          % 阻带截止角频率
Rp = 1;                 % 通带最大波纹(dB)
As = 50;                % 阻带最小衰减(dB)
Delta_w = ws - wp;      % 过渡带宽
wc = (wp + ws) / 2;     % 理想低通截止频率（通阻带中点）
freq_points = 1024;     % 频率响应采样点数（提升曲线平滑度）

% 窗函数阶数计算（1型线性相位要求N为奇数）
% 按各窗过渡带宽公式计算最小阶数，并调整为奇数
N_boxcar = round(1.8*pi/(Delta_w) + abs(mod(1.8*pi/(Delta_w),2)-1));
N_hanning = round(6.2*pi/(Delta_w) + abs(mod(6.2*pi/(Delta_w),2)-1));
N_hamming = round(6.6*pi/(Delta_w) + abs(mod(6.6*pi/(Delta_w),2)-1));
N_blackman = round(11*pi/(Delta_w) + abs(mod(11*pi/(Delta_w),2)-1));
beta = 0.1102 * (As - 8.7);  % 凯瑟窗β参数（As≥50dB时的计算公式）
N_kaiser = ceil((As - 7.95)/(2.285 * Delta_w) + 1);
N_kaiser = round(N_kaiser + abs(mod(N_kaiser,2)-1));  % 调整为奇数

% 输出各窗函数最小阶数计算结果
fprintf('==================== 各窗函数最小阶数计算结果 ====================\n');
fprintf('矩形窗最小阶数：%d\n', N_boxcar);
fprintf('汉宁窗最小阶数：%d\n', N_hanning);
fprintf('海明窗最小阶数：%d\n', N_hamming);
fprintf('布莱克曼窗最小阶数：%d\n', N_blackman);
fprintf('凯瑟窗最小阶数：%d（β=%.2f）\n', N_kaiser, beta);
fprintf('\n');

% 手动调整矩形窗和汉宁窗阶数（用于增阶验证）
% N_boxcar = 101;
% N_hanning = 101;

% 窗函数配置：{窗名称, 窗函数句柄, 滤波器长度N, 保存前缀}
windows = {
    '矩形窗',   @boxcar,     N_boxcar,  '矩形窗';
    '汉宁窗',   @hanning,    N_hanning,  '汉宁窗';
    '海明窗',   @hamming,    N_hamming,  '海明窗';
    '布莱克曼窗', @blackman, N_blackman, '布莱克曼窗';
    '凯瑟窗',   @(N) kaiser(N, beta), N_kaiser, '凯瑟窗';
};

% 验证线性相位条件（1型要求冲激响应偶对称）
fprintf('==================== 线性相位条件的验证 ====================\n')
for i = 1:length(windows)
    % 提取当前窗函数参数
    win_name = windows{i, 1};       % 窗函数名称
    win_fun = windows{i, 2};        % 窗函数句柄
    N = windows{i, 3};              % 滤波器长度（奇数）
    save_prefix = windows{i, 4};    % 保存文件名前缀
    n = 0:N-1;                      % 时间序列
    alpha = (N - 1) / 2;            % 1型线性相位延迟因子

    % 计算理想低通滤波器冲激响应
    hd = (wc / pi) * sinc((wc / pi) * (n - alpha));

    % 生成窗函数并加窗得到实际冲激响应
    w = win_fun(N)';                % 转置匹配hd维度
    h = hd .* w;                    % 加窗（保证偶对称）

    % 验证冲激响应偶对称性（线性相位核心条件）
    symmetry_error = max(abs(h - fliplr(h)));  % 对称误差（趋近0为满足）
    if symmetry_error == 0
        fprintf([win_name, '滤波器满足线性相位条件\n']);
    end

    % 计算滤波器频率响应特性
    [H, w_freq] = freqz(h, 1, freq_points);    % 频率响应
    mag_abs = abs(H);                          % 幅度响应（线性刻度）
    mag_dB = 20 * log10(mag_abs / max(mag_abs));% 幅度响应（归一化dB刻度）
    phase_rad = angle(H);                      % 相频响应（弧度）
    [Hr, w_hr] = zerophase(h);                 % 线性相位幅度函数

    % 创建独立图形（2x2子图展示时域/频域特性）
    figure;
    set(gcf,'Name',[win_name,'-FIR滤波器特性'], 'color', 'w');

    % 子图1：冲激响应
    subplot(2, 2, 1);
    stem(n, h, 'filled', 'MarkerSize', 3, 'Color', 'b');
    xlabel('时间序列 n');
    ylabel('冲激响应 h(n)');
    title([win_name, '滤波器-冲激响应(N=', num2str(N), ')']);
    grid on; axis tight;

    % 子图2：幅频响应（dB）
    subplot(2, 2, 2);
    plot(w_freq/pi, mag_dB, 'LineWidth', 1.2, 'Color', 'b');
    xlabel('归一化频率 \omega/\pi');
    ylabel('幅频响应 (dB)');
    title([win_name, '滤波器-幅频响应']);
    grid on; axis([0, 1, -80, 5]);  % 聚焦0~π，查看阻带衰减

    % 子图3：相频响应
    subplot(2, 2, 3);
    plot(w_freq/pi, phase_rad, 'LineWidth', 1.2, 'Color', 'b');
    xlabel('归一化频率 \omega/\pi');
    ylabel('相频响应 (rad)');
    title([win_name, '滤波器-相频响应']);
    grid on; axis tight;

    % 子图4：线性相位幅度函数
    subplot(2, 2, 4);
    plot(w_hr/pi, Hr, 'LineWidth', 1.2, 'Color', 'b');
    xlabel('归一化频率 \omega/\pi');
    ylabel('幅度函数 H(\omega)');
    title([win_name, '滤波器-线性相位幅度函数']);
    grid on; axis tight;

    % 保存图形至当前目录（300dpi高清PNG）
    save_path = [save_prefix, '-FIR滤波器特性.png'];
    print(gcf, save_path, '-dpng', '-r300');
end

% 指标验证结果汇总输出
fprintf('\n==================== 各窗函数指标验证结果 ====================\n');
for i = 1:length(windows)
    win_name = windows{i, 1};
    win_fun = windows{i, 2};
    N = windows{i, 3};
    n = 0:N-1;
    alpha = (N - 1) / 2;
    
    % 重新计算冲激响应和频率响应
    hd = (wc / pi) * sinc((wc / pi) * (n - alpha));
    w = win_fun(N)';
    h = hd .* w;
    [H, w_freq] = freqz(h, 1, freq_points);
    mag_dB = 20 * log10(abs(H) / max(abs(H)));

    % 计算实际通带波纹和阻带衰减
    pass_idx = w_freq <= wp;          % 通带频率索引（ω≤0.3π）
    stop_idx = w_freq >= ws;          % 阻带频率索引（ω≥0.4π）
    actual_Rp = max(mag_dB(pass_idx)) - min(mag_dB(pass_idx));  % 通带波纹
    actual_As = max(mag_dB(stop_idx));                          % 阻带衰减（dB，负数）

    % 判断是否满足指标（阻带衰减≤-As dB即满足）
    if (actual_Rp <= Rp) && (actual_As <= -As)
        is_qualified = '是';
    else
        is_qualified = '否';
    end

    % 输出验证结果
    fprintf('%s：通带波纹=%.2f dB（要求≤%d dB），阻带衰减=%.2f dB（要求≥%d dB），是否满足指标：%s\n', ...
        win_name, actual_Rp, Rp, abs(actual_As), As, is_qualified);
end