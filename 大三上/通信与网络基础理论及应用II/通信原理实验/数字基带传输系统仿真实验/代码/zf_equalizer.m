function [equalized_seq, C] = zf_equalizer(received_seq, rect_filter, osr, eq_tap_num, EbN0)
% 迫零均衡器：消除码间串扰
% 1. 计算系统总冲激响应
total_impulse_response = conv(rect_filter, rect_filter, 'full');
% 2. 下采样得到符号间隔响应
symbol_response = downsample(total_impulse_response, osr);
% 3. 找到主抽头位置
[~, main_tap] = max(abs(symbol_response));
% 4. 均衡器参数
N = floor(eq_tap_num/2);  % 均衡器半长
seq_len = length(received_seq);
% 5. 提取设计用响应片段
start_idx = max(1, main_tap - N);
end_idx = min(length(symbol_response), main_tap + N);
h_design = symbol_response(start_idx:end_idx);
% 补零保证长度为eq_tap_num
if length(h_design) < eq_tap_num
    pad_before = max(0, N - (main_tap - 1));
    pad_after = max(0, N - (length(symbol_response) - main_tap));
    h_design = [zeros(1, pad_before), h_design, zeros(1, pad_after)];
end
h_design = h_design(1:eq_tap_num);
% 6. 构建均衡器矩阵方程
H = zeros(eq_tap_num, eq_tap_num);
for row = 1:eq_tap_num
    k = row - N - 1;  
    for col = 1:eq_tap_num
        i = col - N - 1;  
        h_idx = k - i + N + 1;  
        if h_idx >= 1 && h_idx <= eq_tap_num
            H(row, col) = h_design(h_idx);
        end
    end
end
b = zeros(eq_tap_num, 1);
b(N+1) = 1;  % 迫零条件：y_0=1
% 7. 求解均衡器系数
C = H \ b;
% 8. 应用均衡器到接收序列
equalized_seq = zeros(seq_len, 1);
for k = 1:seq_len
    y_k = 0;
    for i = -N:N
        idx = k - i;
        if idx >= 1 && idx <= seq_len
            y_k = y_k + C(i+N+1) * received_seq(idx);
        end
    end
    equalized_seq(k) = y_k;
end
% 低信噪比时下采样
if EbN0 <= -4 
    equalized_seq = downsample(equalized_seq, osr);
end
end