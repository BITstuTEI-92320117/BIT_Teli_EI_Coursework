function I_compare(zb, l, I1, I2, N)
%% 画图比较矩量法和传输线模型电流分布的计算结果
plot(zb, DN(abs(I1)), 'LineWidth', 1.5, 'Marker', 'o', ...
    'MarkerSize', 4, 'MarkerEdgeColor', 'none');
hold on;
N1 = 101; % 匹配点个数
dl = 2 * l/(N1 - 1);
z = -l:dl:l;
plot(z, abs(I2), 'LineWidth', 1.5, 'Marker', 'o', ...
    'MarkerSize', 4, 'MarkerEdgeColor', 'none');
title('线天线电流传输线模型与矩量法求解结果对比图','FontSize', 12);
xlabel('位置z/m', 'FontSize', 11);
ylabel('电流Im/A', 'FontSize', 11, 'Rotation', 90);
legend('矩量法电流分布','传输线模型电流分布', 'Location', 'southeast', 'FontSize', 10);
xticks(-l:l/5:l)
xlim([-l,l])
grid on;
set(gcf, 'Color', 'white');
set(gca, 'Color', [0.98, 0.98, 0.98]);
hold off 
pname = sprintf('线天线电流传输线模型与矩量法求解结果对比图(l=%gm,N=%d).png' ,l, N);
saveas(gcf,pname)
end