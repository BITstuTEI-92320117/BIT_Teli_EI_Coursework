%% 从文本文件中导入数据
% 用于从以下文本文件中导入数据的脚本:
%
%    filename: D:\lessons_and_papers\专业课\电磁理论、计算、应用\电磁理论、计算、应用II\论文复现\数据\Ant1\VGain Plot_1.csv
%
% 由 MATLAB 于 2025-11-08 21:03:44 自动生成

%% 设置导入选项并导入数据
opts = delimitedTextImportOptions("NumVariables", 3);

% 指定范围和分隔符
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% 指定列名称和类型
opts.VariableNames = ["Phideg", "Thetadeg", "dBGainTotal"];
opts.VariableTypes = ["double", "double", "double"];

% 指定文件级属性
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% 导入数据
VGainPlot1 = readtable("D:\lessons_and_papers\专业课\电磁理论、计算、应用\电磁理论、计算、应用II\论文复现\数据\Ant1\VGain Plot_1.csv", opts);

%% 转换为输出类型
VGainPlot1 = table2array(VGainPlot1);
%% 三维方向图绘制（天线辐射特性可视化）
% 1. 提取数据并转换单位（角度→弧度，适配MATLAB三维绘图）
phi_deg = VGainPlot1(:,1);    % 方位角（Phi，单位：度）
theta_deg = VGainPlot1(:,2);  % 仰角（Theta，单位：度）
gain_dbi = VGainPlot1(:,3);   % 总增益（单位：dBi）

% 角度转弧度（MATLAB三角函数默认弧度制）
phi_rad = deg2rad(phi_deg);
theta_rad = deg2rad(theta_deg);

% 2. 极坐标→直角坐标转换（三维球面坐标映射）
% 注：天线三维方向图常用球面坐标，r取增益（归一化处理避免数值偏差）
r = gain_dbi - min(gain_dbi);  % 增益归一化（最小值归零，突出差异）
x = r .* sin(theta_rad) .* cos(phi_rad);  % X轴坐标
y = r .* sin(theta_rad) .* sin(phi_rad);  % Y轴坐标
z = r .* cos(theta_rad);                  % Z轴坐标

% 3. 创建三维图形窗口
figure('Color','white', 'Position', [300, 200, 800, 600]);
hold on; grid on; axis equal;  % 保持图形、显示网格、等比例坐标轴

% 4. 绘制三维方向图（散点+面渲染，清晰显示增益分布）
% 散点图：标记每个数据点，红色实心点，大小适配
scatter3(x, y, z, 30, gain_dbi, 'filled', 'MarkerEdgeColor', 'k', 'LineWidth', 0.3);
% 面渲染：连接相邻点生成曲面，半透明效果避免遮挡
tri = delaunay(x, y, z);       % 生成三角剖分网格
trisurf(tri, x, y, z, gain_dbi, 'FaceAlpha', 0.6, 'EdgeAlpha', 0.2);

% 5. 颜色条与标签（标注增益数值，提升可读性）
colorbar;
c = colorbar;
c.Label.String = 'Gain (dBi)';              % 颜色条标签（增益单位）
c.Label.FontName = 'Times New Roman';       % 字体统一为学术常用字体
c.Label.FontSize = 10;
c.Label.FontWeight = 'bold';

% 6. 坐标轴与标题设置（匹配学术图表规范）
xlabel('X (normalized)', 'FontName', 'Times New Roman', 'FontSize', 11, 'FontWeight', 'bold');
ylabel('Y (normalized)', 'FontName', 'Times New Roman', 'FontSize', 11, 'FontWeight', 'bold');
zlabel('Z (normalized)', 'FontName', 'Times New Roman', 'FontSize', 11, 'FontWeight', 'bold');
title('3D Radiation Pattern of Ant1 (VGain Data)', 'FontName', 'Times New Roman', 'FontSize', 12, 'FontWeight', 'bold');

% 7. 视角调整（默认从斜上方观察，清晰显示三维结构）
view(45, 30);

hold off;
% 8. 高分辨率保存（适配论文插入，300dpi PNG格式）
print('Ant1_VGain_3D_Pattern', '-dpng', '-r300');