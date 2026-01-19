function [error_rating_theorical, error_rating_hrc, error_rating_rectang] = psk(fs, osample, fc, conv_mode, flag1, flag2, EbN0, T, is_int_os)
% BPSK系统仿真主函数：调用上下变频，计算误码率
% 输入：fs-采样频率, osample-过采样率, fc-载波频率, conv_mode-卷积模式, flag1-波形绘图标志, flag2-序列截断标志, EbN0-信噪比, T-采样时间, is_int_os-是否整数倍过采样
% 输出：error_rating_theorical-理论误码率, error_rating_hrc-根升余弦成形误码率, error_rating_rectang-方波成形误码率

% 处理单个EbN0值（无噪或特定信噪比）
if ischar(EbN0) || length(EbN0) == 1
    [send_hrc_wave, send_rectan_wave, carrier_hrc, carrier_rectan, ...
        hrc, h, sym_num, sym_seq] = up_conversion(T, ...
        fs, osample, fc, conv_mode, flag1, is_int_os);
    [receive_hrc_matched, receive_rectang_matched] = down_conversion(EbN0, ...
        send_hrc_wave, send_rectan_wave, carrier_hrc, ...
        carrier_rectan, hrc, h, osample, conv_mode, sym_num, flag1, flag2);
    [error_rating_hrc, error_rating_rectang] = judge(receive_hrc_matched, ...
        receive_rectang_matched, osample, sym_num, sym_seq, is_int_os);
    error_rating_theorical = 0;
% 处理EbN0数组（多信噪比仿真）
else
    [send_hrc_wave, send_rectan_wave, carrier_hrc, carrier_rectan, ...
        hrc, h, sym_num, sym_seq] = up_conversion(T, ...
        fs, osample, fc, conv_mode, flag1, is_int_os);
    leng = length(EbN0);
    error_rating_hrc = zeros(1,leng);
    error_rating_rectang = zeros(1,leng);
    error_rating_theorical = berawgn(EbN0, 'psk', 2, 'nondiff'); % 计算BPSK理论误码率
    % 遍历每个信噪比，计算误码率
    for i = 1:leng
        [receive_hrc_matched, receive_rectang_matched] = down_conversion(EbN0(i), ...
            send_hrc_wave, send_rectan_wave, carrier_hrc, ...
            carrier_rectan, hrc, h, osample, conv_mode, sym_num, flag1, flag2);
        [error_rating_hrc(i), error_rating_rectang(i)] = judge(receive_hrc_matched, ...
            receive_rectang_matched, osample, sym_num, sym_seq, is_int_os);
        % 打印EbN0=3时的误码率
        if (EbN0(i) == 3) && (flag1 == 1) && (flag2 == 1)
            fprintf('误码率(EbN0=%d)BER=%.2f%%\n',EbN0(i),error_rating_hrc(i)*100)
        end
    end
end
end