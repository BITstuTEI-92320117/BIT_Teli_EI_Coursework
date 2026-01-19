G3_3 = [13.0577, 12.5731, 11.9682, 11.5041, 11.3590, 12.3297, 13.4701, 12.8777, 11.0183];
A3_3 = [0, 10, 20, 30, 40, 50, 60, 65, 70];
G3_8 = [13.1953, 13.1168, 13.1145, 12.7134, 12.1762, 12.3439, 13.7039, 13.1488, 11.0521, 8.6363];
A3_8 = [0, 10, 20, 30, 40, 50, 60, 65, 70, 74];
G4_3 = [12.5556, 12.7634, 13.2013, 13.6885, 13.4056, 12.4357, 13.3965, 13.7477, 13.0441, 11.3784];
A4_3 = [0, 10, 20, 30, 40, 50, 60, 65, 70, 74];

%% 绘制曲线
figure('Color','white');    % 创建图形
hold on, box on
y_low = 8.5;
y_high = 15.5;
plot(A3_3, G3_3', 'k-s', 'LineWidth', 1.2, 'MarkerSize', 4, 'MarkerFaceColor','k');  
plot(A3_8, G3_8', 'r-o', 'LineWidth', 1.2, 'MarkerSize', 4, 'MarkerFaceColor','r');  
plot(A4_3, G4_3', 'b-^', 'LineWidth', 1.2, 'MarkerSize', 4, 'MarkerFaceColor','b');  

%% X轴刻度
xticks(0:10:80);        % 主刻度：2.5-5.0 GHz，间隔0.5 GHz
xticklabels(0:10:80);   % 刻度标签
setMinorTick(gca, 1, 0)     % 开启次刻度

%% Y轴刻度
% yticks(y_low:5:0);          % 主刻度：-25-0 dB，间隔5 dB
% yticklabels(y_low:5:0);     % 刻度标签
set(gca, 'FontSize', 10, 'FontWeight','bold');  % 刻度字体：10号，加粗

%% 坐标轴与标签
xlim([0, 80]); ylim([y_low, y_high]);  % 轴范围
xlabel('Angle/deg', 'FontSize', 11, 'FontName', 'Times New Roman', 'FontWeight','bold');  % X轴标签
ylabel('Realized Gain/dBi', 'FontSize', 11, 'FontName', 'Times New Roman', 'Rotation', 90, 'FontWeight','bold');  % Y轴标签

%% 图例
legend('at 3.3GHz', 'at 3.8GHz', 'at 4.3GHz', 'Location', 'southwest', 'FontSize', 10, 'Box', 'off', 'FontName', 'Times New Roman', 'FontWeight','bold');  % 图例设置

%% 保存
set(gca, 'GridAlpha', 0.3, 'MinorGridAlpha', 0.1);
hold off;
print('E_Scan_Angle', '-dpng', '-r300');  % 保存为300dpi PNG