function[yf]=lpf_VSB(f,sf,B)
% VSB残留边带调制专用低通滤波器
% 输入参数：
%   f: 频率向量
%   sf: 输入信号的频域表示
%   B: 滤波器带宽
% 输出参数：
%   yf: 滤波后的频域信号

% 计算频率分辨率
df=f(2)-f(1);

% 获取频率向量长度
fN=length(f);

% 初始化滤波器响应向量（全零
ym=zeros(1,fN);

% 计算带宽对应的频率点数（取整）
xm=floor(B/df);
center_index = floor(fN/2);
ym(-xm+floor(fN/2):xm-1+floor(fN/2)) = 1;
% 设置滤波器基本响应 ======================================
% 在中心频率两侧对称位置设置0.5增益点
ym(-xm+floor(fN/2))=0.5;  % 左侧过渡点
ym(xm-1+floor(fN/2))=0.5; % 右侧过渡点

% 构建过渡带特性 =========================================
% 在基本点周围创建平滑过渡
% for i=1:floor(xm/4)
for i=1:floor(xm/2)
    ym(-xm+floor(fN/2)-i)=0.2;
    ym(-xm+floor(fN/2)+i)=0.8;
    ym(xm-1+floor(fN/2)-i)=0.8;
    ym(xm-1+floor(fN/2)+i)=0.2;
end
yf=ym.*sf;

% % ================== 添加幅频响应曲线绘制 ==================
%     % 创建图形窗口
%     figure('Name', 'VSB残留边带调制专用滤波器', 'NumberTitle', 'off', 'Position', [100, 100, 800, 600]);
% 
%     % 绘制幅频响应（线性幅度）
%     plot(f, ym, 'b', 'LineWidth', 1.5);
%     hold on;
% 
%     % 标记关键点
%     plot(f(center_index - xm), ym(center_index - xm), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
%     plot(f(center_index + xm - 1), ym(center_index + xm - 1), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
% 
%     % 添加参考线
%     line([min(f) max(f)], [0.5 0.5], 'Color', 'k', 'LineStyle', '--', 'LineWidth', 0.5);
%     line([0 0], [0 1.1], 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1.0);
% 
%     % % 标记关键区域
%     % fill([f(center_index - xm - floor(xm/2)), f(center_index - xm - floor(xm/2)), ...
%     %       f(center_index - xm), f(center_index - xm)], ...
%     %      [0, 1, 1, 0], [1 0.95 0.95], 'EdgeColor', 'none'); % 左侧过渡区
%     % 
%     % fill([f(center_index + xm - 1), f(center_index + xm - 1), ...
%     %       f(center_index + xm - 1 + floor(xm/2)), f(center_index + xm - 1 + floor(xm/2))], ...
%     %      [0, 1, 1, 0], [1 0.95 0.95], 'EdgeColor', 'none'); % 右侧过渡区
% 
%     % 添加标题和标签
%     title(sprintf('VSB残留边带调制专用滤波器 (带宽 = %.1f Hz)', B));
%     xlabel('频率 (Hz)');
%     ylabel('幅度 (倍数)');
%     grid on;
% 
%     % 设置坐标轴范围
%     axis([min(f) max(f) 0 1.1]);
% 
%     % 添加图例
%     legend('幅频响应', '过渡点 (0.5增益)', 'Location', 'best');
% 
%     % 添加参数说明
%     annotation('textbox', [0.15 0.01 0.7 0.05], 'String', ...
%         sprintf('滤波器带宽: %.1f Hz | 频率分辨率: %.4f Hz | 过渡点偏移: %d个频率点', B, df, xm + 1), ...
%         'FitBoxToText', 'on', 'BackgroundColor', [0.95 0.95 0.95], 'EdgeColor', 'none');
% 
%     % 添加关键点标注
%     text(f(center_index - xm), 0.55, sprintf('2000Hz, 0.5'), ...
%         'HorizontalAlignment', 'center', 'FontSize', 10);
%     text(f(center_index + xm - 1), 0.55, sprintf('2000Hz, 0.5'), ...
%         'HorizontalAlignment', 'center', 'FontSize', 10);
% 
%     % 添加滤波器特性说明
%     % text(mean(f), 0.3, ...
%     %     {'VSB滤波器特性：', ...
%     %      '1. 中心频率处增益为1.0', ...
%     %      '2. 过渡点处增益为0.5', ...
%     %      '3. 不对称过渡带设计', ...
%     %      '4. 保留部分边带信息'}, ...
%     %     'HorizontalAlignment', 'center', 'BackgroundColor', [1 1 0.8], 'EdgeColor', 'k');
% 
%     % 绘制理想滤波器对比
%     % hold on;
%     % ideal_response = abs(f) < B;
%     % plot(f, ideal_response, 'g--', 'LineWidth', 1.0);
%     % legend('VSB滤波器', '过渡点 (0.5增益)', '中心频率 (0 Hz)', '理想低通滤波器', 'Location', 'best');
%     saveas(gcf,'VSB滤波器幅频响应.fig');
end
