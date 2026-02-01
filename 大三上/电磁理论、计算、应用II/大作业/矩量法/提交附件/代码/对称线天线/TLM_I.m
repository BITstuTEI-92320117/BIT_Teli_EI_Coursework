function It = TLM_I(l, k)
%% 计算并绘制传输线模型电流求解结果
% 归一化处理，取I0=1
N = 101; % 匹配点个数
dl = 2 * l/(N - 1);
z = -l:dl:l;
It = sin(k*(l - abs(z)));

% 绘制电流分布
plot(z, abs(It), 'LineWidth', 1.5, 'Marker', 'o', ...
    'MarkerSize', 4, 'MarkerEdgeColor', 'none');
grid on;
title('线天线电流分布图(传输线模型求解结果)','FontSize', 12);
xlabel('位置z/m', 'FontSize', 11);
ylabel('电流It/A', 'FontSize', 11, 'Rotation', 90);
xticks(-l:l/5:l)
xlim([-l,l])
legend('传输线模型电流分布', 'Location', 'southeast', 'FontSize', 10);
set(gcf, 'Color', 'white');
set(gca, 'Color', [0.98, 0.98, 0.98]);
fname = sprintf('线天线电流分布图(传输线模型求解结果,l=%gm).png' ,l);
saveas(gcf,fname)
end