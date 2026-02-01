%% 导入电子表格中的数据
% 用于从以下电子表格导入数据的脚本:
%
%    工作簿: D:\lessons_and_papers\专业课\电磁理论、计算、应用\电磁理论、计算、应用II\论文复现\数据\E_Array\scan_3.8\E_All.xlsx
%    工作表: Sheet1
%
% 由 MATLAB 于 2025-11-13 00:17:25 自动生成

clear
%% 设置导入选项并导入数据
opts = spreadsheetImportOptions("NumVariables", 10);

% 指定工作表和范围
opts.Sheet = "Sheet1";
opts.DataRange = "A1:J361";

% 指定列名称和类型
opts.VariableNames = ["VarName1", "VarName2", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% 导入数据
HAll = readtable("D:\lessons_and_papers\专业课\电磁理论、计算、应用\电磁理论、计算、应用II\论文复现\数据\E_Array\scan_3.8\E_All.xlsx", opts, "UseExcel", false);

%% 转换为输出类型
HAll = table2array(HAll);

% 提取角度和增益
theta = HAll(:,1);    % 读取原始角度数据（范围：-180°~180°）
theta = (theta + 180)*2*pi/360;  % 将角度转换为弧度，并映射到0~2π范围

H_66 = HAll(:,2);
gc = H_66(1:180);
H_66(1:181) = H_66(181:361);  % 数据复制处理，确保极坐标曲线绘制连续
H_66(182:361) = gc;

H_60 = HAll(:,3);
gc = H_60(1:180);
H_60(1:181) = H_60(181:361);  % 数据复制处理，确保极坐标曲线绘制连续
H_60(182:361) = gc;

H_40 = HAll(:,4);
gc = H_40(1:180);
H_40(1:181) = H_40(181:361);  % 数据复制处理，确保极坐标曲线绘制连续
H_40(182:361) = gc;

H_20 = HAll(:,5);
gc = H_20(1:180);
H_20(1:181) = H_20(181:361);  % 数据复制处理，确保极坐标曲线绘制连续
H_20(182:361) = gc;

H0 = HAll(:,6);
gc = H0(1:180);
H0(1:181) = H0(181:361);  % 数据复制处理，确保极坐标曲线绘制连续
H0(182:361) = gc;

H20 = HAll(:,7);
gc = H20(1:180);
H20(1:181) = H20(181:361);  % 数据复制处理，确保极坐标曲线绘制连续
H20(182:361) = gc;

H40 = HAll(:,8);
gc = H40(1:180);
H40(1:181) = H40(181:361);  % 数据复制处理，确保极坐标曲线绘制连续
H40(182:361) = gc;

H60 = HAll(:,9);
gc = H60(1:180);
H60(1:181) = H60(181:361);  % 数据复制处理，确保极坐标曲线绘制连续
H60(182:361) = gc;

H66 = HAll(:,10);
gc = H66(1:180);
H66(1:181) = H66(181:361);  % 数据复制处理，确保极坐标曲线绘制连续
H66(182:361) = gc;
% 调整曲线样式（单曲线，加粗实线）
figure('Color','white');    % 创建白色背景的图形窗口
polaraxes('Color','white')
hold on

polarplot(pi/2 - theta, H_66, 'k-', 'LineWidth', 1.2);  % 绘制极坐标曲线，红色加粗实线，图例显示"Meas."
polarplot(pi/2 - theta, H_60, 'r--', 'LineWidth', 1.2);
polarplot(pi/2 - theta, H_40, 'c:', 'LineWidth', 1.2);  % 绘制极坐标曲线，红色加粗实线，图例显示"Meas."
polarplot(pi/2 - theta, H_20, 'm-.', 'LineWidth', 1.2);
polarplot(pi/2 - theta, H0, 'g-.', 'LineWidth', 1.2);  % 绘制极坐标曲线，红色加粗实线，图例显示"Meas."
polarplot(pi/2 - theta, H20, 'b--', 'LineWidth', 1.2');
polarplot(pi/2 - theta, H40, 'm:', 'LineWidth', 1.2);  % 绘制极坐标曲线，红色加粗实线，图例显示"Meas."
polarplot(pi/2 - theta, H60, 'r-.', 'LineWidth', 1.2);
polarplot(pi/2 - theta, H66, 'm-', 'LineWidth', 1.2);  % 绘制极坐标曲线，红色加粗实线，图例显示"Meas."
rlim([-25,15])  % 设置径向（增益）显示范围

ax = gca;  % 获取当前极坐标轴对象
ax.ThetaTickLabels = {'90', '60', '30', '0', '-30', '-60', '-90', '-120', '-150', '180', '150', '120'};  % 自定义角度刻度标签

% 调整网格线样式（虚线、浅灰色、适当透明度）
ax.GridColor = [0.6, 0.6, 0.6];  % 设置网格线颜色为浅灰色
ax.GridAlpha = 0.7;  % 设置网格线透明度
ax.RMinorGrid = 'on';  % 开启径向次要网格
ax.ThetaMinorGrid = 'on';  % 开启角度次要网格

% 添加图例（单曲线，无边框）
legend('-70\circ','-60\circ','-40\circ','-20\circ','0\circ','20\circ','40\circ','60\circ','70\circ','Location', 'northeastoutside', 'Box', 'off', 'FontSize', 10, 'FontWeight', 'bold');  % 图例位于东北方向，无边框，字体加粗

% 调整径向刻度标签样式（匹配增益范围）
ax.RTick = -25:2.5:15;  % 设置径向刻度位置
ax.RTickLabels = {'-25dBi','','','','','','','','','','','', '5dBi','', '','','15dBi'};  % 自定义径向刻度标签（带单位）
ax.FontName = 'Times New Roman';  % 统一设置字体为Times New Roman
ax.FontWeight = 'bold';  % 字体加粗
hold off
print('E_All', '-dpng', '-r300');  % 保存图形为300dpi的PNG格式，文件名为“Ant1_H”