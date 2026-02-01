function BER = error_rate(sym_num, receive_wave_down, sym_seq, N_draw, flag)
% 计算误码率并绘制恢复序列
sym_seq_rec = zeros(1,sym_num);
for i = 1:sym_num
    % 判决规则：<0→-1，否则→1
    if receive_wave_down(i) < 0
        sym_seq_rec(i) = -1;
    else
        sym_seq_rec(i) = 1;
    end
end
if flag == 1
    % 绘制原始/下采样/恢复序列
    figure('Name', '码元序列的恢复', 'Color','white');
    subplot(3,1,1);
    stem(1:N_draw, sym_seq(1:N_draw), 'filled', 'MarkerFaceColor','b', 'LineWidth', 1.5, 'Color', 'b');
    title('原始双极性符号序列');
    xticks(1:N_draw);
    xlim([1, N_draw]);
    xlabel('符号位置');
    ylabel('幅度');
    grid on;

    subplot(3,1,2);
    stem(1:N_draw, receive_wave_down(1:N_draw), 'filled', 'MarkerFaceColor','b', 'LineWidth', 1.5, 'Color', 'b');
    title('下采样后序列');
    xticks(1:N_draw);
    xlim([1, N_draw]);
    xlabel('符号位置');
    ylabel('幅度');
    grid on;

    subplot(3,1,3);
    stem(1:N_draw, sym_seq_rec(1:N_draw), 'filled', 'MarkerFaceColor','b', 'LineWidth', 1.5, 'Color', 'b');
    title('抽样判决恢复序列');
    xticks(1:N_draw)
    xlim([1, N_draw])
    xlabel('符号位置');
    ylabel('符号幅度');
    grid on; 
     saveas(gcf, '码元序列的恢复.png');
end
% 统计误码数
err_num = 0;
for j = 1:sym_num
    if sym_seq_rec(j) ~= sym_seq(j)
        err_num = err_num + 1;
    end
end
BER = err_num/length(sym_seq); % 误码率=误码数/总符号数
end