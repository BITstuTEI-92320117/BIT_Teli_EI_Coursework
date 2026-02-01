function Im = MoM_I(Z, b, z, l, N, flag)
%% 计算并绘制矩量法电流求解结果
Im = Z \ b;
Im(1, 1) = 0;

% 绘制电流分布
if flag == 1
    plot(z, abs(Im), 'LineWidth', 1.5, 'Marker', 'o', ...
        'MarkerSize', 4, 'MarkerEdgeColor', 'none');
    grid on;
    title('线天线电流分布图(矩量法求解结果)','FontSize', 12);
    xlabel('位置z/m', 'FontSize', 11);
    ylabel('电流Im/A', 'FontSize', 11, 'Rotation', 90);
    legend('矩量法电流分布', 'Location', 'southeast', 'FontSize', 10);
    xticks(-l:l/5:l)
    xlim([-l,l])
    set(gcf, 'Color', 'white');
    set(gca, 'Color', [0.98, 0.98, 0.98]);
    pname = sprintf('线天线电流分布图(矩量法求解结果,l=%gm,N=%d).png' ,l, N);
    saveas(gcf,pname)
    fname = sprintf('线天线电流分布(矩量法求解结果,l=%gm,N=%d).mat' ,l, N);
    save(fname,'Im')
end
end