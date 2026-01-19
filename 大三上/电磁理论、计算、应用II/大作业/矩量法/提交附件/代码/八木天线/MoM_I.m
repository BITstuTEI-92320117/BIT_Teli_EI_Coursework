function Im = MoM_I(Z, b, z, N, num, flag, l)
%% 计算并绘制矩量法电流求解结果
Im = Z \ b;
Im = reshape(Im, [N, num])';  % 第i行代表天线i的电流
Im(:, 1) = 0;                 % 天线上端电流为0
Im(:, N) = 0;                 % 天线下端电流为0
m = floor(num^0.5);           % 合理根据天线数排列绘图分布
n = ceil(num/m);
if flag == 1
    figure(1);
    for i = 1: num
        % 绘制每根天线电流分布图
        subplot(m, n, i);
        plot(z(i,:), abs(Im(i,:)), 'LineWidth', 1.5, 'Marker', 'o', ...
            'MarkerSize', 4, 'MarkerEdgeColor', 'none');
        grid on;
        title(sprintf('第%d根线天线电流分布图', i),'FontSize', 12);
        xlabel('位置z/m', 'FontSize', 11);
        ylabel('电流Im/A', 'FontSize', 11, 'Rotation', 90);
        xlim([-l(i), l(i)])
        legend('电流分布', 'Location', 'northeast', 'FontSize', 10);
        set(gcf, 'Color', 'white');
        set(gca, 'Color', [0.98, 0.98, 0.98]);
    end
    % 保存结果
    pname = sprintf('八木天线电流分布图.fig');
    saveas(gcf,pname)
    % 绘制电流分布汇总图
    figure(2);
    I_draw  = [Im(2,:),Im(3,:), Im(1,:),Im(5,:),Im(4,:)];
    plot(abs(I_draw), 'LineWidth', 1.5);
    grid on;
    xlim([0,length(I_draw)])
    ylabel('电流Im/A', 'FontSize', 11, 'Rotation', 90);
    title('八木天线电流分布汇总图')
    set(gcf, 'Color', 'white');
    set(gca, 'Color', [0.98, 0.98, 0.98]);
    legend('电流分布', 'Location', 'north', 'FontSize', 10);
    % 保存结果
    pname = sprintf('八木天线电流分布汇总图.png');
    saveas(gcf,pname)
end
end