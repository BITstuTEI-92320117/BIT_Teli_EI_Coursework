G3_3 = [14.2182, 14.0155, 14.0449, 14.0476, 13.6719, 13.3732, 12.6140, 11.2864, 10.0440];
A3_3 = [0, 10, 20, 30, 40, 50, 60, 66, 70];
G3_8 = [14.7010, 14.7888, 15.0144, 15.0914, 14.7997, 13.7348, 10.8754, 8.6688];
A3_8 = [0, 10, 20, 30, 40, 50, 60, 65];
G4_3 = [14.1259, 14.2771, 14.9022, 15.1384, 14.4961, 12.7488, 11.7480, 11.4309];
A4_3 = [0, 10, 20, 30, 40, 50, 60, 65];

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
print('H_Scan_Angle', '-dpng', '-r300');  % 保存为300dpi PNG