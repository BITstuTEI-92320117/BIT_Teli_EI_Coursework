BH = [68, 66, 65, 63, 61, 59, 58, 59, 60, 63, 63, 64, 62, 61];
freq = 3.2:0.1:4.5;

%% 初始化绘图
y_low = -25;                % Y轴下限
figure('Color','white');    % 创建图形
hold on; box on             % 保持图形，显示边框

%% 绘制曲线
plot(freq, BH, 'b-^', 'LineWidth', 1.2, 'MarkerSize',4, 'MarkerFaceColor','b');  % Ant.1曲线：黑色点划线

%% X轴刻度
xticks(3.0:0.5:5.0);        % 主刻度：2.5-5.0 GHz，间隔0.5 GHz
xticklabels(3.0:0.5:5.0);   % 刻度标签
setMinorTick(gca, 1, 0)     % 开启次刻度

%% Y轴刻度
yticks(45:5:80);          % 主刻度：-25-0 dB，间隔5 dB
yticklabels(45:5:80);     % 刻度标签
set(gca, 'FontSize', 10, 'FontWeight','bold');  % 刻度字体：10号，加粗

%% 坐标轴与标签
xlim([3, 5.0]); ylim([45, 80]);  % 轴范围
xlabel('Frequency/GHz', 'FontSize', 11, 'FontName', 'Times New Roman', 'FontWeight','bold');  % X轴标签
ylabel('Angle/deg', 'FontSize', 11, 'FontName', 'Times New Roman', 'Rotation', 90, 'FontWeight','bold');  % Y轴标签

%% 图例
legend('Proposed', 'Location', 'southeast', 'FontSize', 10, 'Box', 'off', 'FontName', 'Times New Roman', 'FontWeight','bold');  % 图例设置

%% 保存
set(gca, 'GridAlpha', 0.3, 'MinorGridAlpha', 0.1);
hold off;
print('Draw_H_Scan_Freq', '-dpng', '-r300');  % 保存为300dpi PNG