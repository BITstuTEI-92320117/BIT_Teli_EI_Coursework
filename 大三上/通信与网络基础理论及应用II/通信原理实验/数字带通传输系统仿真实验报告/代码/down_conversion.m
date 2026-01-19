function [receive_hrc_matched, receive_rectang_matched] = down_conversion(EbN0, send_hrc_wave, ...
    send_rectan_wave, carrier_hrc, carrier_rectan, hrc, h, osample, conv_mode, sym_num, flag1, flag2)
% 下变频与匹配滤波函数
% 输入：EbN0-信噪比, send_hrc_wave-根升余弦上变频信号, send_rectan_wave-方波上变频信号, carrier_hrc-根升余弦载波, carrier_rectan-方波载波, hrc-根升余弦滤波器, h-方波滤波器, osample-过采样率, conv_mode-卷积模式, sym_num-符号数, flag1-绘图标志, flag2-截断标志
% 输出：receive_hrc_matched-根升余弦匹配滤波输出, receive_rectang_matched-方波匹配滤波输出

% 无噪情况：直接接收发送信号
if EbN0 == 'None'
    receive_hrc_wave = send_hrc_wave;
    receive_rectang_wave = send_rectan_wave;
% 有噪情况：添加指定信噪比的高斯白噪声
else
    SNR = EbN0 + 3 - 10*log10(osample); % 转换EbN0为SNR
    receive_hrc_wave = awgn(send_hrc_wave, SNR, 'measured', 'dB');
    receive_rectang_wave = awgn(send_rectan_wave, SNR, 'measured', 'dB');
end

% 下变频：接收信号与载波相乘（频谱搬回基带）
receive_hrc_wave_demodule = receive_hrc_wave .* carrier_hrc;
receive_rectang_wave_demodule = receive_rectang_wave .* carrier_rectan;

% 绘图标志：绘制下变频波形及功率谱
if flag1 == 1
    if EbN0 == 'None'
        % 无噪下变频波形及功率谱
        figure('Name','根升余弦波束成形下变频无噪波形', 'Color','w')
        plot(receive_hrc_wave_demodule, 'LineWidth', 1.5, 'Color', 'b')
        xlim([0,128])
        title('根升余弦波束成形下变频无噪波形')
        grid on
        saveas(gcf, '根升余弦波束成形下变频无噪波形.png')
        
        figure('Name','根升余弦波束成形下变频无噪波形功率谱密度','Color','w')
        pwelch(receive_hrc_wave_demodule)
        h_pwelch = findobj(gca, 'Type', 'line');
        set(h_pwelch, 'Color', 'b');
        title('根升余弦波束成形下变频无噪波形功率谱密度')
        grid on
        saveas(gcf, '根升余弦波束成形下变频无噪波形功率谱密度.png');

    elseif EbN0 == 3
        %  EbN0=3时的有噪波形及功率谱
        figure('Name','根升余弦波束成形有噪波形', 'Color','w')
        plot(receive_hrc_wave, 'LineWidth', 1.5, 'Color', 'b')
        xlim([0,128])
        title('根升余弦波束成形有噪波形')
        grid on
        saveas(gcf, '根升余弦波束成形有噪波形.png')
        
        figure('Name','根升余弦波束成形有噪波形功率谱密度','Color','w')
        pwelch(receive_hrc_wave)
        h_pwelch = findobj(gca, 'Type', 'line');
        set(h_pwelch, 'Color', 'b');
        title('根升余弦波束成形有噪波形功率谱密度')
        grid on
        saveas(gcf, '根升余弦波束成形有噪波形功率谱密度.png');
        
        figure('Name','根升余弦波束成形下变频有噪波形', 'Color','w')
        plot(receive_hrc_wave_demodule, 'LineWidth', 1.5, 'Color', 'b')
        xlim([0,128])
        title('根升余弦波束成形下变频有噪波形')
        grid on
        saveas(gcf, '根升余弦波束成形下变频有噪波形.png')
        
        figure('Name','根升余弦波束成形下变频有噪波形功率谱密度','Color','w')
        pwelch(receive_hrc_wave_demodule)
        h_pwelch = findobj(gca, 'Type', 'line');
        set(h_pwelch, 'Color', 'b');
        title('根升余弦波束成形下变频有噪波形功率谱密度')
        grid on
        saveas(gcf, '根升余弦波束成形下变频有噪波形功率谱密度.png');
    end
end

% 匹配滤波：与发送端滤波器同模式卷积
receive_hrc_matched = conv(receive_hrc_wave_demodule, hrc, conv_mode);
receive_rectang_matched = conv(receive_rectang_wave_demodule, h, conv_mode);

% 绘图标志：绘制匹配滤波输出波形及功率谱
if flag1 == 1
    if EbN0 == 'None'
        figure('Name','根升余弦波束成形匹配滤波输出无噪波形','Color','w')
        plot(receive_hrc_matched, 'LineWidth', 1.5, 'Color', 'b');
        title('根升余弦波束成形匹配滤波输出无噪波形')
        xlim([0,128])
        grid on
        saveas(gcf, '根升余弦波束成形匹配滤波输出无噪波形.png')
        
        figure('Name','根升余弦波束成形匹配滤波输出无噪波形功率谱密度','Color','w')
        pwelch(receive_hrc_matched)
        h_pwelch = findobj(gca, 'Type', 'line');
        set(h_pwelch, 'Color', 'b');
        title('根升余弦波束成形匹配滤波输出无噪波形功率谱密度')
        grid on
        saveas(gcf, '根升余弦波束成形匹配滤波输出无噪波形功率谱密度.png');
        
    elseif EbN0 == 3
        figure('Name','根升余弦波束成形匹配滤波输出有噪波形','Color','w')
        plot(receive_hrc_matched, 'LineWidth', 1.5, 'Color', 'b');
        title('根升余弦波束成形匹配滤波输出有噪波形')
        xlim([0,128])
        grid on
        saveas(gcf, '根升余弦波束成形匹配滤波输出有噪波形.png')
        
        figure('Name','根升余弦波束成形匹配滤波输出有噪波形功率谱密度','Color','w')
        pwelch(receive_hrc_matched)
        h_pwelch = findobj(gca, 'Type', 'line');
        set(h_pwelch, 'Color', 'b');
        title('根升余弦波束成形匹配滤波输出有噪波形功率谱密度')
        grid on
        saveas(gcf, '根升余弦波束成形匹配滤波输出有噪波形功率谱密度.png');
    end
end

% 截断标志：将匹配滤波输出截断为原始上采样序列长度
trunc_len = sym_num * osample;
if length(receive_hrc_matched) > trunc_len && flag2 == 1
    start_idx = floor((length(receive_hrc_matched) - trunc_len)/2) + 1;
    receive_hrc_matched = receive_hrc_matched(start_idx:start_idx+trunc_len-1);
    start_idx = floor((length(receive_rectang_matched) - trunc_len)/2) + 1;
    receive_rectang_matched = receive_rectang_matched(start_idx:start_idx+trunc_len-1);
end
end