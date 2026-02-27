function plot_BER(EbN0,BER,name,cato,xcato,flag)
% 误码率曲线绘制函数
% 输入：EbN0-信噪比数组, BER-误码率矩阵, name-图名, cato-参数类型, xcato-参数值数组, flag-图例模式标志

figure('Name', name, 'Color','white');
markers = {'o','s','^','d','v'}; % 标记样式
colors = {'r','g','b','m','k'}; % 颜色数组

% 模式1：固定图例（滤波器类型/模式对比）
if flag == 1
    for i = 1:length(xcato)
        semilogy(EbN0, BER(i,:), 'Color', colors{i}, 'Marker', markers{i}, ...
            'MarkerSize', 4, 'MarkerFaceColor', colors{i}, 'LineWidth',1.2);
        hold on
    end
    % 滤波器模式对比图例
    if length(cato) == 8
        legend('same模式','full模式截断' , 'full模式不截断','Location','northeast', 'FontSize', 9);
    % 成型滤波器类型对比图例
    else
        legend('理论值','根升余弦波束成形','方波波束成形', ...
            'Location','northeast', 'FontSize', 9);
    end
% 模式2：动态图例（参数值对比）
else
    for i = 1:length(xcato)
        if xcato(i) > 1000
            % 参数值>1000时，以kHz为单位显示
            if cato == 'Rs'
                semilogy(EbN0, BER(i,:), 'Color', colors{i}, 'Marker', markers{i}, ...
                    'MarkerSize', 4, 'MarkerFaceColor', colors{i}, 'LineWidth',1.2, ...
                    'DisplayName', [cato, sprintf('=%.3fk', xcato(i)/1000)]);
            elseif cato == 'fs'
                 semilogy(EbN0, BER(i,:), 'Color', colors{i}, 'Marker', markers{i}, ...
                    'MarkerSize', 4, 'MarkerFaceColor', colors{i}, 'LineWidth',1.2, ...
                    'DisplayName', [cato, sprintf('=%.2fk', xcato(i)/1000)]);
            else
                semilogy(EbN0, BER(i,:), 'Color', colors{i}, 'Marker', markers{i}, ...
                    'MarkerSize', 4, 'MarkerFaceColor', colors{i}, 'LineWidth',1.2, ...
                    'DisplayName', [cato, sprintf('=%dk', xcato(i)/1000)]);
            end
        else
            % 参数值≤1000时，直接显示
            semilogy(EbN0, BER(i,:), 'Color', colors{i}, 'Marker', markers{i}, ...
                'MarkerSize', 4, 'MarkerFaceColor', colors{i}, 'LineWidth',1.2, ...
                'DisplayName', [cato, sprintf('=%.1f', xcato(i))]);
        end
        hold on
    end
    legend('Location','northeast', 'FontSize',9);
end

% 设置y轴为对数刻度，固定范围
set(gca, 'YScale', 'log');
ylim([1e-6, 1]);

% 设置坐标轴标签、标题、网格
xlabel('Eb/N0 (dB)', 'FontSize', 10);
ylabel('误码率 (BER)', 'FontSize', 10);
xlim([EbN0(1), EbN0(end)]);
title(name, 'FontSize', 11);
grid on;
box on;
hold off;

% 保存图片
name = [name, '.png'];
saveas(gcf, name);
end