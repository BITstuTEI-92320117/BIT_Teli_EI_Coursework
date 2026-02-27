function [BER, BW]  = RRCF(EbN0, sym_seq, alpha, sym_num, span, osr, N_draw, fs, flag)
% 根升余弦滤波处理
sym_seq_up = upsample(sym_seq, osr); % 符号上采样
hrc = rcosdesign(alpha, span, osr, "sqrt"); % 设计根升余弦滤波器
base_wave = conv(sym_seq_up, hrc, 'same'); % 成形滤波
BW = 0;
% 计算-20dB带宽（flag=2时）
if flag == 2
    [Pxx, f] = pwelch(base_wave);  % 功率谱密度
    P_peak = max(Pxx);  % 功率峰值
    dB = -20;
    k = 10^(dB/10);
    P_threshold = P_peak * k;  % -20dB功率阈值
    valid_freq_indices = find(Pxx >= P_threshold);  % 有效频率索引
    if ~isempty(valid_freq_indices)
        f_min = min(f(valid_freq_indices));  
        f_max = max(f(valid_freq_indices));  
        BW = f_max - f_min;  % 计算带宽
        BW = BW*fs/(2*pi);
    else
        BW = 0;
    end
end
% 信道传输：加噪声
receive_wave = base_wave;
if EbN0 ~= 'None'
    SNR = EbN0 - 10*log10(osr) + 10*log10(2);
    receive_wave = awgn(receive_wave, SNR,'measured','dB');
end
% 接收端匹配滤波
receive_wave = conv(receive_wave, hrc, 'same');
% 下采样恢复符号速率
receive_wave_down = downsample(receive_wave, osr);
% 绘图（flag=1时）
if flag == 1
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
    stem(1:N_draw*osr, sym_seq_up(1:N_draw*osr), 'filled', 'MarkerFaceColor','b', 'LineWidth', 1.5, 'Color', 'b');
    xlim([1, N_draw*osr])
    title('上采样后的符号序列');
    grid on;
    xlabel('符号位置');
    ylabel('幅度');
    saveas(gcf, '原始序列与上采样后序列.png');
    % 绘制成形滤波波形
    figure('Name', '根升余弦滤波器波束成形(前128采样点)', 'Color','white');
    plot(base_wave, 'LineWidth',1.5,'Color','b');
    xlim([0, 128])
    title('根升余弦滤波器波束成形(前128采样点)');
    grid on;
    xlabel('采样点位置');
    ylabel('幅度');
    saveas(gcf, '根升余弦滤波器波束成形(前128采样点).png');
    % 绘制功率谱
    figure('Name', '根升余弦滤波器波束成形(功率谱密度)', 'Color','white');
    pwelch(base_wave)
    title('根升余弦滤波器波束成形(功率谱密度)');
    h_pwelch = findobj(gca, 'Type', 'line');
    set(h_pwelch, 'Color', 'b');
    saveas(gcf, '根升余弦滤波器波束成形(功率谱密度).png');
    % 绘制匹配接收波形
    figure('Name', '根升余弦滤波器匹配接收的输出波形', 'Color','white');
    plot(receive_wave, 'LineWidth',1.5,'Color','b');
    xlim([0, 128])
    title('根升余弦滤波器匹配接收的输出波形');
    grid on
        xlabel('采样点位置');
    ylabel('幅度');
    saveas(gcf, '根升余弦滤波器匹配接收的输出波形.png');
end
% 计算误码率
BER = error_rate(sym_num, receive_wave_down, sym_seq, N_draw, flag);
end
