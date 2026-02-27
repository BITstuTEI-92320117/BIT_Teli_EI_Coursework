function plot_BER(EbN0,BER,name,cato,xcato,flag)
% 绘制误码率曲线
figure('Name', name, 'Color','white');
markers = {'o','s','^','d','v'};
colors = {'r','g','b','m','k'};
if flag == 1
    % 绘制理论/不同滤波器误码率
    for i = 1:length(xcato)
        semilogy(EbN0, BER(i,:), 'Color', colors{i}, 'Marker', markers{i}, ...
            'MarkerSize', 4, 'MarkerFaceColor', colors{i}, 'LineWidth',1.2);
        hold on
    end
    % 设置图例
    if length(xcato) == 4
        legend('理论值','根升余弦波束成形(无码间串扰)','方波波束成形(含码间串扰)', ...
            '方波波束成形(时域均衡)' ,'Location','northeast', 'FontSize', 9);
    else
        legend('理论值','根升余弦波束成形(无码间串扰)','方波波束成形(含码间串扰)', ...
            'Location','northeast', 'FontSize', 9);
    end
else
    % 绘制不同参数下的误码率
    for i = 1:length(xcato)
        semilogy(EbN0, BER(i,:), 'Color', colors{i}, 'Marker', markers{i}, ...
            'MarkerSize', 4, 'MarkerFaceColor', colors{i}, 'LineWidth',1.2, ...
            'DisplayName', [cato, sprintf('=%.4f', xcato(i))]);
        hold on
    end
    legend('Location','northeast', 'FontSize',9);
end
% 设置对数坐标
set(gca, 'YScale', 'log');
ylim([1e-6, 1]);            
% 设置标签与标题
xlabel('Eb/N0 (dB)', 'FontSize', 10);
ylabel('误码率 (BER)', 'FontSize', 10);
xlim([EbN0(1), EbN0(end)]);
title(name, 'FontSize', 11);
grid on;
box on;
hold off;
saveas(gcf, [name,'.png']); % 保存图片
end