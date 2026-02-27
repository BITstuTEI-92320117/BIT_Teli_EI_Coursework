function [send_hrc_wave, send_rectan_wave, carrier_hrc, carrier_rectan, ...
    hrc, h, sym_num, sym_seq] = up_conversion(T, fs, osample, fc, conv_mode, flag, is_int_os)
% 上变频与波形成形函数：生成符号序列、上采样、成形滤波、上变频
% 输入：T-采样时间, fs-采样频率, osample-过采样率, fc-载波频率, conv_mode-卷积模式, flag-绘图标志, is_int_os-是否整数倍过采样
% 输出：send_hrc_wave-根升余弦成形上变频信号, send_rectan_wave-方波成形上变频信号, carrier_hrc-根升余弦对应载波, carrier_rectan-方波对应载波, hrc-根升余弦滤波器, h-方波滤波器, sym_num-符号数, sym_seq-符号序列

% 计算符号速率
Rs = fs / osample;
% 计算符号数并取整
sym_num = round(Rs * T);
% 生成0/1随机序列并映射为-1/1双极性序列
sym_seq = randi([0,1],1,sym_num);
sym_seq(sym_seq == 0) = -1;

% 整数/非整数倍上采样区分
if is_int_os == 1
    sym_seq_upsample = upsample(sym_seq, osample); % 整数倍：插入osample-1个零
else
    [p, q] = get_simplified_fraction(osample); % 非整数倍：转为最简分数p/q
    sym_seq_upsample = resample(sym_seq, p, q); % 分数倍上采样
end

% 根升余弦滤波器参数设置（滚降系数0.3，滤波器跨度6）
beta = 0.3; spsn = 6;
sps_int = round(osample); % 过采样率取整用于滤波器设计
hrc = rcosdesign(beta, spsn, sps_int, 'sqrt'); % 设计根升余弦滤波器
base_hrc_wave = conv(sym_seq_upsample, hrc, conv_mode); % 根升余弦成形（指定卷积模式）

% 绘图标志：绘制序列及成形波形、功率谱
if flag == 1
    N_draw = 20;
    figure('Name', '原始序列与上采样后序列', 'Color','white');
    subplot(2,1,1)
    stem(1:N_draw, sym_seq(1:N_draw), 'filled', 'MarkerFaceColor','b', 'LineWidth', 1.5, 'Color', 'b');
    title('发送符号序列');
    xlabel('符号位置');
    ylabel('幅度');
    xticks(1:N_draw)
    xlim([1, N_draw])
    grid on;
    subplot(2,1,2)
    stem(1:N_draw*osample, sym_seq_upsample(1:N_draw*osample), 'filled', 'MarkerFaceColor','b', 'LineWidth', 1.5, 'Color', 'b');
    xlim([1, N_draw*osample])
    title('上采样后的符号序列');
    grid on;
    xlabel('符号位置');
    ylabel('幅度');
    saveas(gcf, '原始序列与上采样后序列.png');
    
    figure('Name','根升余弦滤波器波束成形(前128采样点)', 'Color','white')
    plot(base_hrc_wave, 'LineWidth', 1.5, 'Color', 'b')
    xlim([0,128])
    title('根升余弦滤波器波束成形(前128采样点)')
    grid on
    saveas(gcf, '根升余弦滤波器波束成形(前128采样点).png');
    
    figure('Name', '根升余弦滤波器波束成形(功率谱密度)', 'Color','white')
    pwelch(base_hrc_wave)
    title('根升余弦滤波器波束成形(功率谱密度)')
    h_pwelch = findobj(gca, 'Type', 'line');
    set(h_pwelch, 'Color', 'b');
    grid on
    saveas(gcf, '根升余弦滤波器波束成形(功率谱密度).png');
end

% 设计方波滤波器并成形
h = ones(1,sps_int);
base_rectan_wave = conv(sym_seq_upsample, h, conv_mode);

% 生成与成形信号长度匹配的载波
sig_len_hrc = length(base_hrc_wave);
sig_len_rectan = length(base_rectan_wave);
carrier_hrc = cos(2*pi*fc*(0:sig_len_hrc-1)/fs);
carrier_rectan = cos(2*pi*fc*(0:sig_len_rectan-1)/fs);

% 上变频：基带信号与载波相乘
send_hrc_wave = base_hrc_wave .* carrier_hrc;
send_rectan_wave = base_rectan_wave .* carrier_rectan;

% 绘制上变频波形及功率谱
if flag == 1
    figure('Name','根升余弦波束成形上变频波形','Color','w')
    plot(send_hrc_wave, 'LineWidth', 1.5, 'Color', 'b')
    xlim([0,128])
    grid on
    title('根升余弦波束成形上变频波形')
    saveas(gcf, '根升余弦波束成形上变频波形.png')

    figure('Name','根升余弦波束成形上变频功率谱密度','Color','w')
    pwelch(send_hrc_wave)
    h_pwelch = findobj(gca, 'Type', 'line');
    set(h_pwelch, 'Color', 'b');
    title('根升余弦波束成形上变频功率谱密度')
    grid on
    saveas(gcf, '根升余弦波束成形上变频功率谱密度.png');
end
end