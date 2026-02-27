%% 导入电子表格中的数据
% 用于从以下电子表格导入数据的脚本:
%
%    工作簿: D:\lessons_and_papers\专业课\电磁理论、计算、应用\电磁理论、计算、应用II\论文复现\数据\E_Array\scan_3.8\All_S1.xlsx
%    工作表: Sheet1
%
% 由 MATLAB 于 2025-11-13 08:38:19 自动生成

%% 设置导入选项并导入数据
opts = spreadsheetImportOptions("NumVariables", 6);

% 指定工作表和范围
opts.Sheet = "Sheet1";
opts.DataRange = "A1:F251";

% 指定列名称和类型
opts.VariableNames = ["VarName1", "VarName2", "VarName3", "VarName4", "VarName5", "VarName6"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double"];

% 导入数据
AllS1 = readtable("D:\lessons_and_papers\专业课\电磁理论、计算、应用\电磁理论、计算、应用II\论文复现\数据\E_Array\scan_3.8\All_S1.xlsx", opts, "UseExcel", false);

%% 转换为输出类型
AllS1 = table2array(AllS1);


freq = AllS1(:,1);         % 频率数据(2.5-5.0 GHz)
S1_0 = AllS1(:,2);     % Ant.1的S11参数
S1_20 = AllS1(:,3);
S1_40 = AllS1(:,4);
S1_60 = AllS1(:,5);
S1_70 = AllS1(:,6);

%% 初始化绘图
y_low = -35;                % Y轴下限
figure('Color','white');    % 创建图形
hold on; box on             % 保持图形，显示边框

%% 绘制曲线
maker_idx = 10:10:250;
plot(freq, S1_0, 'k-s', 'LineWidth', 1.2,'MarkerIndices',maker_idx, 'MarkerSize', 4, 'MarkerFaceColor','k');  
plot(freq, S1_20, 'r-o', 'LineWidth', 1.2,'MarkerIndices',maker_idx, 'MarkerSize', 4, 'MarkerFaceColor','r');  
plot(freq, S1_40, 'b-^', 'LineWidth', 1.2,'MarkerIndices',maker_idx, 'MarkerSize', 4, 'MarkerFaceColor','b');  
plot(freq, S1_60, 'm-v', 'LineWidth', 1.2,'MarkerIndices',maker_idx, 'MarkerSize', 4, 'MarkerFaceColor','m');  
plot(freq, S1_70, 'g-d', 'LineWidth', 1.2,'MarkerIndices',maker_idx, 'MarkerSize', 4, 'MarkerFaceColor','g');  

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
legend('0\circ', '20\circ', '40\circ','60\circ', '70\circ', 'Location', 'southwest', 'FontSize', 10, 'Box', 'off', 'FontName', 'Times New Roman', 'FontWeight','bold');  % 图例设置

%% 保存
set(gca, 'GridAlpha', 0.3, 'MinorGridAlpha', 0.1);
hold off;
print('E_ALL_S1', '-dpng', '-r300');  % 保存为300dpi PNG