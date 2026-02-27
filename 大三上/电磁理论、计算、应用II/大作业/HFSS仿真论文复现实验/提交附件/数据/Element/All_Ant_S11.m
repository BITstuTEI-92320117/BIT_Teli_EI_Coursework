%% 从文本文件中导入数据
% 用于从以下文本文件中导入数据的脚本:
%
%    filename: D:\lessons_and_papers\专业课\电磁理论、计算、应用\电磁理论、计算、应用II\论文复现\数据\Ant1\S Parameter Plot 1.csv
%
% 由 MATLAB 于 2025-11-08 16:05:08 自动生成

%% 设置导入选项并导入数据
opts = delimitedTextImportOptions("NumVariables", 2);

% 指定范围和分隔符
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% 指定列名称和类型
opts.VariableNames = ["FreqGHz", "dBS11"];
opts.VariableTypes = ["double", "double"];

% 指定文件级属性
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% 导入数据
SParameterPlot1 = readtable("D:\lessons_and_papers\专业课\电磁理论、计算、应用\电磁理论、计算、应用II\论文复现\数据\Ant1\S Parameter Plot 1.csv", opts);

% 转换为输出类型
data_S11 = table2array(SParameterPlot1);

freq = data_S11(:,1);         % 频率数据(2.5-5.0 GHz)
S11_ant1 = data_S11(:,2);     % Ant.1的S11参数

%% 设置导入选项并导入数据
opts = delimitedTextImportOptions("NumVariables", 2);

% 指定范围和分隔符
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% 指定列名称和类型
opts.VariableNames = ["FreqGHz", "dBS11"];
opts.VariableTypes = ["double", "double"];

% 指定文件级属性
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% 导入数据
SParameterPlot2 = readtable("D:\lessons_and_papers\专业课\电磁理论、计算、应用\电磁理论、计算、应用II\论文复现\数据\Ant1\S Parameter Plot 2.csv", opts);

% 转换为输出类型
data_S11 = table2array(SParameterPlot2);
S11_ant2 = data_S11(:,2);     % Ant.2的S11参数

%% 设置导入选项并导入数据
opts = delimitedTextImportOptions("NumVariables", 2);

% 指定范围和分隔符
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% 指定列名称和类型
opts.VariableNames = ["FreqGHz", "dBS11"];
opts.VariableTypes = ["double", "double"];

% 指定文件级属性
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% 导入数据
SParameterPlot3 = readtable("D:\lessons_and_papers\专业课\电磁理论、计算、应用\电磁理论、计算、应用II\论文复现\数据\Ant1\S Parameter Plot 3.csv", opts);

%% 转换为输出类型
data_S11 = table2array(SParameterPlot3);
S11_pro_ant = data_S11(:,2);     % S11参数

%% 初始化绘图
y_low = -30;                % Y轴下限
figure('Color','white');    % 创建图形
hold on; box on             % 保持图形，显示边框

%% 绘制曲线
plot(freq, S11_ant1, 'k-.', 'LineWidth', 1.2);  
plot(freq, S11_ant2, 'r--', 'LineWidth', 1.2);  
plot(freq, S11_pro_ant, 'b-', 'LineWidth', 1.2);  

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
ylabel('S_{11}/dB', 'FontSize', 11, 'FontName', 'Times New Roman', 'Rotation', 90, 'FontWeight','bold');  % Y轴标签

%% 图例
legend('Ant. 1', 'Ant. 2', 'Proposed', 'Location', 'southeast', 'FontSize', 10, 'Box', 'off', 'FontName', 'Times New Roman', 'FontWeight','bold');  % 图例设置

%% 保存
set(gca, 'GridAlpha', 0.3, 'MinorGridAlpha', 0.1);
hold off;
print('All_Ant_S11', '-dpng', '-r300');  % 保存为300dpi PNG