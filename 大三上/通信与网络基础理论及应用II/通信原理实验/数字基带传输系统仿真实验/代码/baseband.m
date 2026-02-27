function [BER_theory, BER_RRCF, BER_rect_noeq, BER_rect_eq, Eta] = baseband(Rb, fs, T, alpha, span, EbN0, N_draw, eq_tap_num, flag1, flag2)
% 基带传输系统仿真：计算误码率与频谱利用率
osr = fs/Rb;             % 过采样率
sym_num = Rb * T;        % 符号个数
sym_seq = randi([0,1], sym_num, 1);
sym_seq = 2*sym_seq - 1; % 生成双极性符号序列
Eta = 0;
if (ischar(EbN0) || length(EbN0) == 1) && flag1 == 1
    % 无噪声时计算误码率
    BER_theory = 0;
    [BER_RRCF, ~] = RRCF('None', sym_seq, alpha, sym_num, span, osr, N_draw, fs, flag1);
    fprintf('误码率(无码间串扰)BER=%.2f%%\n',BER_RRCF*100)
    [BER_rect_noeq, BER_rect_eq] = rect_pulse_filter('None', osr, sym_seq, sym_num, eq_tap_num, N_draw, flag1);
elseif (ischar(EbN0) || length(EbN0) == 1) && flag1 == 2
    % 计算频谱利用率
    BER_theory = 0;
    BER_rect_noeq = 0;
    BER_rect_eq = 0;
    [BER_RRCF, BW] = RRCF('None', sym_seq, alpha, sym_num, span, osr, N_draw, fs, flag1);
    Eta = Rb/BW; % 频谱利用率=符号速率/带宽
else
    % 不同信噪比下计算误码率
    l = length(EbN0);
    BER_theory = berawgn(EbN0, 'psk', 2, 'nondiff');  % 2PSK理论误码率
    BER_RRCF = zeros(1,l);
    BER_rect_noeq = zeros(1,l);
    BER_rect_eq = zeros(1,l);
    for i = 1:l
        [BER_RRCF(i), ~] = RRCF(EbN0(i), sym_seq, alpha, sym_num, span, osr, N_draw, fs, flag1);
        if flag2 == 1
            [BER_rect_noeq(i), BER_rect_eq(i)] = rect_pulse_filter(EbN0(i), osr, sym_seq, sym_num, eq_tap_num, N_draw, flag1);          
        end
    end
end
end