function setMinorTick(ax, N, XYAxis)
% 设置次刻度线数量
% ax 需要设置的绘图对象, 通常为ax = gca
% N 次刻度线的数量  默认:4
% XYAxis 设置的坐标轴(XY轴:0  X轴:1  Y轴:2)  默认:X轴和Y轴

if nargin < 2, N = 4; end   
if nargin < 3, XYAxis = 0; end  

% 设置X轴的次刻度线
if XYAxis == 0 || XYAxis == 1
    set(ax,'XMinorTick',true)   % 开启X轴的次刻度线

    % 当前次刻度线的最小和最大值
    XAxis_min = min(get(ax.XAxis,'TickValues'));
    XAxis_max = max(get(ax.XAxis,'TickValues'));

    % 当前主刻度线的数量
    XAxis_N = length(get(ax.XAxis,'TickValues'));

    % 计算新刻度线的间隔
    XAxis_space = (XAxis_max-XAxis_min)/((XAxis_N-1)*(N+1));

    % 设置新刻度线
    ax.XAxis.MinorTickValues = XAxis_min:XAxis_space:XAxis_max;
end

% 设置Y轴的次刻度线 
if XYAxis == 0 || XYAxis == 2
    set(ax,'YMinorTick',true)
    YAxis_min = min(get(ax.YAxis,'TickValues'));
    YAxis_max = max(get(ax.YAxis,'TickValues'));
    YAxis_N = length(get(ax.YAxis,'TickValues'));
    YAxis_space = (YAxis_max-YAxis_min)/((YAxis_N-1)*(N+1));
    ax.YAxis.MinorTickValues = YAxis_min:YAxis_space:YAxis_max;
end