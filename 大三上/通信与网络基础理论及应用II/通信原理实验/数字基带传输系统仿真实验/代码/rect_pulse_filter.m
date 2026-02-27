function [BER, BER_eq] = rect_pulse_filter(EbN0, osr, sym_seq, sym_num, eq_tap_num, N_draw, flag)
% 矩形脉冲滤波处理
rect_filter = ones(1, osr); % 矩形滤波器
sym_seq_up = upsample(sym_seq, osr);  % 符号上采样
base_wave = conv(sym_seq_up, rect_filter, 'same');  % 成形滤波
% 信道传输：加噪声
receive_wave = base_wave;
if EbN0 ~= 'None'
    SNR = EbN0 - 10*log10(osr) + 10*log10(2);
    receive_wave = awgn(receive_wave, SNR,'measured','dB');
end
% 接收端匹配滤波
receive_wave = conv(receive_wave, rect_filter, 'same');
% 下采样恢复符号速率
receive_wave_down = downsample(receive_wave, osr);
% 绘图（flag=1时）
if flag == 1
    figure('Name', '方波波束成形(前128采样点)', 'Color','white');
    plot(1:128, base_wave(1:128), 'LineWidth',1.5, 'Color','b');
    xlim([1, 128]);
    title('方波波束成形(前128采样点)');
    xlabel('采样点位置');
    ylabel('幅度');
    grid on; 
    saveas(gcf, '方波波束成形(前128采样点).png');
    % 绘制功率谱
    figure('Name', '方波波束成形(功率谱密度)', 'Color','white');
    pwelch(base_wave)
    title('方波波束成形(功率谱密度)');
    h_pwelch = findobj(gca, 'Type', 'line');
    set(h_pwelch, 'Color', 'b');
    saveas(gcf, '方波波束成形(功率谱密度).png');
end
% 计算误码率
BER = error_rate(sym_num, receive_wave_down, sym_seq, N_draw, 0);
BER_eq = 0;
% 迫零均衡（抽头数>0时）
if eq_tap_num > 0
     if EbN0 <= -4
         [equalized_seq, ~] = zf_equalizer(receive_wave, rect_filter, osr, eq_tap_num, EbN0);
     else
         [equalized_seq, ~] = zf_equalizer(receive_wave_down, rect_filter, osr, eq_tap_num, EbN0);
     end
    BER_eq = error_rate(sym_num, equalized_seq, sym_seq, N_draw, 0);
end
end