%% 从文本文件中导入数据
% 用于从以下文本文件中导入数据的脚本:
%
%    filename: D:\lessons_and_papers\专业课\电磁理论、计算、应用\电磁理论、计算、应用II\论文复现\数据\Ant1\HGain Plot_Pro.csv
%
% 由 MATLAB 于 2025-11-08 20:48:04 自动生成

%% 设置导入选项并导入数据
opts = delimitedTextImportOptions("NumVariables", 4);

% 指定范围和分隔符
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% 指定列名称和类型
opts.VariableNames = ["Var1", "Var2", "Thetadeg", "dBGainTotal"];
opts.SelectedVariableNames = ["Thetadeg", "dBGainTotal"];
opts.VariableTypes = ["string", "string", "double", "double"];

% 指定文件级属性
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% 指定变量属性
opts = setvaropts(opts, ["Var1", "Var2"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2"], "EmptyFieldRule", "auto");

% 导入数据
HGainPlotPro = readtable("D:\lessons_and_papers\专业课\电磁理论、计算、应用\电磁理论、计算、应用II\论文复现\数据\Ant1\HGain Plot_Pro.csv", opts);

%% 转换为输出类型
HGainPlotPro = table2array(HGainPlotPro);

% 提取角度和增益
theta = HGainPlotPro(:,1);    % 读取原始角度数据（范围：-180°~180°）
theta = (theta + 180)*2*pi/360;  % 将角度转换为弧度，并映射到0~2π范围
gain = HGainPlotPro(:,2);     % 读取增益数据（单位：dBi）
gc = gain(1:180);
gain(1:181) = gain(181:361);  % 数据复制处理，确保极坐标曲线绘制连续
gain(182:361) = gc;

% 调整曲线样式（单曲线，加粗实线）
figure('Color','white');    % 创建白色背景的图形窗口
polarplot(pi/2 - theta, gain, 'r-', 'LineWidth', 1.2, 'DisplayName', 'Proposed');  % 绘制极坐标曲线，红色加粗实线，图例显示“Meas.”
rlim([-10,7.5])  % 设置径向（增益）显示范围

ax = gca;  % 获取当前极坐标轴对象
ax.ThetaTickLabels = {'90', '60', '30', '0', '-30', '-60', '-90', '-120', '-150', '180', '150', '120'};  % 自定义角度刻度标签

% 调整网格线样式（虚线、浅灰色、适当透明度）
ax.GridColor = [0.6, 0.6, 0.6];  % 设置网格线颜色为浅灰色
ax.GridAlpha = 0.7;  % 设置网格线透明度
ax.RMinorGrid = 'on';  % 开启径向次要网格
ax.ThetaMinorGrid = 'on';  % 开启角度次要网格

% 添加图例（单曲线，无边框）
legend('Location', 'northeastoutside', 'Box', 'off', 'FontSize', 10, 'FontWeight', 'bold');  % 图例位于东北方向，无边框，字体加粗

% 调整径向刻度标签样式（匹配增益范围）
ax.RTick = [-6.5 -3 0.5 4];  % 设置径向刻度位置
ax.RTickLabels = {'-6.5dBi', '-3dBi', '0.5dBi', '4dBi'};  % 自定义径向刻度标签（带单位）
ax.FontName = 'Times New Roman';  % 统一设置字体为Times New Roman
ax.FontWeight = 'bold';  % 字体加粗

print('Pro_Ant_H', '-dpng', '-r300');  % 保存图形为300dpi的PNG格式，文件名为“Ant1_H”