%% 从文本文件中导入数据
% 用于从以下文本文件中导入数据的脚本:
%
%    filename: D:\lessons_and_papers\专业课\电磁理论、计算、应用\电磁理论、计算、应用II\论文复现\数据\H_Array\H_Plane_S4_H60.csv
%
% 由 MATLAB 于 2025-11-13 11:13:39 自动生成

%% 设置导入选项并导入数据
opts = delimitedTextImportOptions("NumVariables", 3);

% 指定范围和分隔符
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% 指定列名称和类型
opts.VariableNames = ["Hamm", "FreqGHz", "dBActiveS41"];
opts.VariableTypes = ["double", "double", "double"];

% 指定文件级属性
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% 导入数据
HPlaneS4H = readtable("D:\lessons_and_papers\专业课\电磁理论、计算、应用\电磁理论、计算、应用II\论文复现\数据\H_Array\H_Plane_S4_H60.csv", opts);

%% 转换为输出类型
HPlaneS4H = table2array(HPlaneS4H);

H0 = HPlaneS4H(1:251,3);
H2 = HPlaneS4H(252:502,3);
H4 = HPlaneS4H(503:753,3);
H6 = HPlaneS4H(754:1004,3);
H8 = HPlaneS4H(1005:1255,3);
freq = HPlaneS4H(1:251,2);
%% 初始化绘图
y_low = -35;                % Y轴下限
figure('Color','white');    % 创建图形
hold on; box on             % 保持图形，显示边框

%% 绘制曲线
maker_idx = 10:10:250;
plot(freq, H0, 'g-d', 'LineWidth', 1.2,'MarkerIndices',maker_idx, 'MarkerSize', 4, 'MarkerFaceColor','g');  
plot(freq, H2, 'm-v', 'LineWidth', 1.2,'MarkerIndices',maker_idx, 'MarkerSize', 4, 'MarkerFaceColor','m');  
plot(freq, H4, 'b-^', 'LineWidth', 1.2,'MarkerIndices',maker_idx, 'MarkerSize', 4, 'MarkerFaceColor','b');  
plot(freq, H6, 'r-o', 'LineWidth', 1.2,'MarkerIndices',maker_idx, 'MarkerSize', 4, 'MarkerFaceColor','r');  
plot(freq, H8, 'k-s', 'LineWidth', 1.2,'MarkerIndices',maker_idx, 'MarkerSize', 4, 'MarkerFaceColor','k');  

%% X轴刻度
xticks(2.5:0.5:5.0);        % 主刻度：2.5-5.0 GHz，间隔0.5 GHz
xticklabels(2.5:0.5:5.0);   % 刻度标签
setMinorTick(gca, 1, 0)     % 开启次刻度

%% Y轴刻度
yticks(y_low:5:0);          % 主刻度：-25-0 dB，间隔5 dB
yticklabels(y_low:5:0);     % 刻度标签
set(gca, 'FontSize', 10, 'FontWeight','bold');  % 刻度字体：10号，加粗

%% 坐标轴与标签
xlim([2.5, 5.0]); ylim([y_low, 0]);  % 轴范围
xlabel('Frequency/GHz', 'FontSize', 11, 'FontName', 'Times New Roman', 'FontWeight','bold');  % X轴标签
ylabel('Active |S_{11}|/dB', 'FontSize', 11, 'FontName', 'Times New Roman', 'Rotation', 90, 'FontWeight','bold');  % Y轴标签

%% 图例
legend('Ha=0mm', 'Ha=2mm', 'Ha=4mm','Ha=6mm', 'Ha=8mm', 'Location', 'southwest', 'FontSize', 10, 'Box', 'off', 'FontName', 'Times New Roman', 'FontWeight','bold');  % 图例设置

%% 保存
set(gca, 'GridAlpha', 0.3, 'MinorGridAlpha', 0.1);
hold off;
print('H_Plane_S4_H60', '-dpng', '-r300');  % 保存为300dpi PNG