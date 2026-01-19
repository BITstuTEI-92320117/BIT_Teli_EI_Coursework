%% 从文本文件中导入数据
% 用于从以下文本文件中导入数据的脚本:
%
%    filename: D:\lessons_and_papers\专业课\电磁理论、计算、应用\电磁理论、计算、应用II\论文复现\数据\E_Array\E_Plane_S4_E00.csv
%
% 由 MATLAB 于 2025-11-25 10:32:47 自动生成

%% 设置导入选项并导入数据
opts = delimitedTextImportOptions("NumVariables", 4);

% 指定范围和分隔符
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% 指定列名称和类型
opts.VariableNames = ["Var1", "Var2", "Var3", "Var4"];
opts.SelectedVariableNames = ["Var3", "Var4"];
opts.VariableTypes = ["string", "string", "double", "double"];

% 指定文件级属性
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% 指定变量属性
opts = setvaropts(opts, ["Var1", "Var2"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2"], "EmptyFieldRule", "auto");

% 导入数据
E_Plane_S4_E00 = readtable("D:\lessons_and_papers\专业课\电磁理论、计算、应用\电磁理论、计算、应用II\论文复现\数据\E_Array\E_Plane_S4_E00.csv", opts);

%% 转换为输出类型
E_Plane_S4_E00 = table2array(E_Plane_S4_E00);

H0 = E_Plane_S4_E00(1:251,2);
H2 = E_Plane_S4_E00(252:502,2);
H4 = E_Plane_S4_E00(503:753,2);
H6 = E_Plane_S4_E00(754:1004,2);
H8 = E_Plane_S4_E00(1005:1255,2);
H10 = E_Plane_S4_E00(1256:1506,2);
freq = E_Plane_S4_E00(1:251,1);
%% 初始化绘图
y_low = -15;                % Y轴下限
figure('Color','white');    % 创建图形
hold on; box on             % 保持图形，显示边框

%% 绘制曲线
maker_idx = 10:10:250;
plot(freq, H0, 'g-d', 'LineWidth', 1.2,'MarkerIndices',maker_idx, 'MarkerSize', 4, 'MarkerFaceColor','g');  
plot(freq, H2, 'm-v', 'LineWidth', 1.2,'MarkerIndices',maker_idx, 'MarkerSize', 4, 'MarkerFaceColor','m');  
plot(freq, H4, 'b-^', 'LineWidth', 1.2,'MarkerIndices',maker_idx, 'MarkerSize', 4, 'MarkerFaceColor','b');  
plot(freq, H6, 'y-p', 'LineWidth', 1.2,'MarkerIndices',maker_idx, 'MarkerSize', 4, 'MarkerFaceColor','y');  
plot(freq, H8, 'k-s', 'LineWidth', 1.2,'MarkerIndices',maker_idx, 'MarkerSize', 4, 'MarkerFaceColor','k');  
plot(freq, H10, 'r-o', 'LineWidth', 1.2,'MarkerIndices',maker_idx, 'MarkerSize', 4, 'MarkerFaceColor','r');  
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
legend('La=15mm', 'La=18mm', 'La=21mm','La=24mm', 'La=27mm', 'La=30mm','Location', 'southwest', 'FontSize', 10, 'Box', 'off', 'FontName', 'Times New Roman', 'FontWeight','bold');  % 图例设置

%% 保存
set(gca, 'GridAlpha', 0.3, 'MinorGridAlpha', 0.1);
hold off;
print('E_Plane_S4_E00', '-dpng', '-r300');  % 保存为300dpi PNG