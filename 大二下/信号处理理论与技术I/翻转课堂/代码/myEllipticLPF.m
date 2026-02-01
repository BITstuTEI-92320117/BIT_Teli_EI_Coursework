function [t1, x1_t] = myEllipticLPF(t, x_t, Band)
    % 计算采样频率
    dt = t(2) - t(1);
    Fs = 1 / dt;
    Nyquist = Fs / 2;
    
    % 设计椭圆滤波器参数（使用默认值）
    Rp = 0.1;   % 通带波纹 (dB)
    Rs = 40;    % 阻带衰减 (dB)
    
    % 处理Band=0的情况（只保留直流分量）
    if Band == 0
        [f, X_f] = T2F(t, x_t);
        X1_f = zeros(size(X_f));
        idx = find(f == 0);
        if ~isempty(idx)
            X1_f(idx) = X_f(idx);
        end
        [t1, x1_t] = F2T(f, X1_f);
        return;
    end
    
    % 调整Band不超过Nyquist频率
    if Band >= Nyquist
        Band = Nyquist * 0.999;
    end
    
    % 设计椭圆滤波器
    Wp = Band / Nyquist;       % 归一化通带截止频率
    Ws = min(1.1 * Wp, 0.99);  % 阻带起始频率（过渡带10%）
    
    % 计算滤波器阶数
    [N, Wn] = ellipord(Wp, Ws, Rp, Rs);
    
    % 设计椭圆滤波器
    [b, a] = ellip(N, Rp, Rs, Wn, 'low');
    
    % 获取信号频谱
    [f, X_f] = T2F(t, x_t);
    
    % 计算滤波器在整个频率范围内的响应
    H = freqz(b, a, f, Fs);
    
    % 应用滤波器
    X1_f = X_f .* H;
    
    % 转换回时域
    [t1, x1_t] = F2T(f, X1_f);
 % % ================== 添加幅频响应曲线绘制（线性幅度） ==================
 %    % 创建更精细的频率向量用于绘制滤波器特性
 %    N_points = 1024;
 %    f_plot = linspace(0, Nyquist, N_points);
 %    H_plot = freqz(b, a, f_plot, Fs);
 % 
 %    % 计算线性幅度响应
 %    mag_linear = abs(H_plot);
 % 
 %    % 计算通带波纹和阻带衰减的线性表示
 %    Rp_linear_max = 1;  % 最大增益（通带中心）
 %    Rp_linear_min = 10^(-Rp/20);  % 通带最小增益
 %    Rs_linear = 10^(-Rs/20);     % 阻带最大增益
 % 
 %    % 创建图形窗口
 %    figure('Name', '椭圆低通滤波器幅频响应（线性）', 'NumberTitle', 'off', 'Position', [100, 100, 800, 600]);
 % 
 %    % 绘制幅频响应（线性幅度）
 %    plot(f_plot, mag_linear, 'b', 'LineWidth', 1.5);
 %    hold on;
 % 
 %    % 标记通带波纹区域
 %    line([0, Nyquist], [Rp_linear_min, Rp_linear_min], 'Color', 'm', 'LineStyle', '--', 'LineWidth', 1.2);
 % 
 %    % 标记阻带衰减线
 %    line([0, Nyquist], [Rs_linear, Rs_linear], 'Color', 'r', 'LineStyle', '--', 'LineWidth', 1.2);
 % 
 %    % 标记截止频率
 %    line([Band, Band], [0, 1.1], 'Color', 'g', 'LineStyle', '--', 'LineWidth', 1.2);
 % 
 %    % 添加标题和标签
 %    title(sprintf('椭圆低通滤波器幅频响应 (阶数 N=%d, Rp=%.1fdB, Rs=%.1fdB)', N, Rp, Rs));
 %    xlabel('频率 (Hz)');
 %    ylabel('幅度 (倍数)');
 %    grid on;
 % 
 %    % 设置坐标轴范围
 %    axis([0 5000 0 1.05]);
 % 
 %    % 添加图例
 %    legend('幅频响应', '通带波纹要求', '阻带衰减要求', '截止频率', 'Location', 'best');
 % 
 %    % 添加参数说明
 %    annotation('textbox', [0.15 0.01 0.7 0.05], 'String', ...
 %        sprintf('截止频率: %.1f Hz | 通带波纹: %.1f dB (%.4f-%.4f) | 阻带衰减: %.1f dB (≤%.4f) | Nyquist频率: %.1f Hz | 滤波器阶数: %d', ...
 %        Band, Rp, Rp_linear_min, Rp_linear_max, Rs, Rs_linear, Nyquist, N), ...
 %        'FitBoxToText', 'on', 'BackgroundColor', [0.95 0.95 0.95], 'EdgeColor', 'none');
 % 
 % 
 %        saveas(gcf,'椭圆低通滤波器幅频响应.fig');
end
