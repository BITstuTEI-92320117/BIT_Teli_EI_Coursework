% 频率采样法设计线性相位FIR低通滤波器
% 设计指标：ω_p=0.3π, R_p=1dB, ω_s=0.4π, A_s=50dB
% 场景：①N=20无过渡样本 ②N=40单过渡样本(T=0.4) ③N=60双过渡样本(T1=0.6,T2=0.1)
clear; clc; close all;
freq_points = 1024;  % 频率响应采样点数（提升曲线平滑度）

% 三种场景参数配置：{场景名, N值, 过渡样本参数, 保存前缀}
cases = {
    'N=20无过渡样本',  20,  [],                  'N20无过渡样本';
    'N=40单过渡样本',  40,  [7,0.4],             'N40单过渡样本';  % k=7（幅值0.4）
    'N=60双过渡样本',  60,  [10,0.6,11,0.1],     'N60双过渡样本';  % k=10(0.6)、k=11(0.1)
};
wp = 0.3 * pi;  % 通带截止角频率
ws = 0.4 * pi;  % 阻带截止角频率
Rp = 1;         % 通带最大波纹(dB)
As = 50;        % 阻带最小衰减(dB)

% 循环处理每种设计场景
for case_idx = 1:length(cases)- 1
    % 提取当前场景参数
    case_name = cases{case_idx, 1};
    N = cases{case_idx, 2};
    trans_param = cases{case_idx, 3};
    save_prefix = cases{case_idx, 4};
    alpha = (N - 1) / 2;  % 线性相位延迟因子
    k = 0:N-1;            % 采样点索引
    wk = (2 * pi / N) * k;% 采样点对应频率ω_k=2πk/N
    
    % 初始化幅频采样值（满足偶对称|H[k]|=|H[N−k]|）
    Hrs = zeros(1, N);
    % 配置通带采样点（ω_k ≤ 0.3π → k ≤ 0.15N）
    pass_k_max = floor(0.15 * N);
    Hrs(1:pass_k_max+1) = 1;  % 通带幅值为1
    % 配置阻带采样点（ω_k ≥ 0.4π → k ≥ 0.2N）
    stop_k_min = ceil(0.2 * N);
    % 配置过渡样本（单/双过渡样本场景）
    if ~isempty(trans_param)
        if length(trans_param)==2  % 单过渡样本
            trans_k = trans_param(1);
            trans_amp = trans_param(2);
            Hrs(trans_k+1) = trans_amp;  % MATLAB索引从1开始
        elseif length(trans_param)==4  % 双过渡样本
            trans_k1 = trans_param(1);
            trans_amp1 = trans_param(2);
            trans_k2 = trans_param(3);
            trans_amp2 = trans_param(4);
            Hrs(trans_k1+1) = trans_amp1;
            Hrs(trans_k2+1) = trans_amp2;
        end
    end
    % 偶对称补全幅频采样值
    for k_idx = 1:N
        sym_k = N - k_idx + 2;
        if sym_k <= N && sym_k >= 1
            Hrs(sym_k) = Hrs(k_idx);
        end
    end
    
    % 配置相频采样值（满足线性相位特性）
    k1 = 0:floor((N-1)/2);
    k2 = floor((N-1)/2)+1:N-1;
    angH = [-alpha*(2*pi)/N*k1,alpha*(2*pi)/N*(N-k2)]; 
    
    % 构造复频率采样值，IDFT求冲激响应h(n)
    Hk = Hrs .* exp(1j * angH);
    h = ifft(Hk, N);              
   
    % 计算滤波器频率响应特性
    [H_freq, w_freq] = freqz(h, 1, freq_points);
    mag_dB = 20 * log10(abs(H_freq) / max(abs(H_freq)));  % 幅频响应(dB)
    phase_rad = angle(H_freq);                             % 相频响应(rad)
    angH = mod(angH,2*pi) - pi;
    [Hr, w_hr] = zerophase(h);                             % 线性相位幅度函数
    
    % 绘制采样值对称性验证图
    figure('Name',[case_name,'-采样值对称性验证']);
    % 子图1：幅频采样值（验证偶对称）
    subplot(2,1,1);
    stem(k, Hrs, 'filled', 'MarkerSize', 3, 'Color', 'b', 'LineWidth',1.5);
    xlabel('采样点k'); ylabel('幅频采样值|H[k]|');
    title([case_name,'-幅频采样值']);
    grid on; axis tight;
    % 子图2：相频采样值（验证线性相位）
    subplot(2,1,2);
    plot(k, angH, 'LineWidth', 1.2, 'Color', 'b', 'LineWidth',1.5);
    xlabel('采样点k'); ylabel('相频采样值∠H[k] (rad)');
    title([case_name,'-相频采样值']);
    grid on; axis tight;
    % 保存采样值验证图
    save_path1 = [save_prefix,'-采样值对称性验证.png'];
    print(gcf, save_path1, '-dpng', '-r300');
    
    % 绘制滤波器特性图（冲激响应+频域特性）
    figure('Name',[case_name,'-滤波器特性'],'Color','w');
    % 子图1：冲激响应h(n)
    subplot(2,2,1);
    stem(0:N-1, abs(h), 'filled', 'MarkerSize', 3, 'Color', 'b', 'LineWidth',1.5);
    xlabel('时间序列n'); ylabel('冲激响应h(n)');
    title([case_name,'-冲激响应']);
    grid on; axis tight;
    % 子图2：幅频响应（dB）
    subplot(2,2,2);
    plot(w_freq/pi, mag_dB, 'LineWidth',1.5, 'Color', 'b', 'LineWidth',1.5);
    xlabel('归一化频率\omega/\pi'); ylabel('幅频响应 (dB)');
    title([case_name,'-幅频响应']);
    grid on; axis([0,1,-80,5]);  % 聚焦0~π，查看阻带衰减
    % 子图3：相频响应
    subplot(2,2,3);
    plot(w_freq/pi, phase_rad, 'LineWidth',1.5, 'Color', 'b', 'LineWidth',1.5);
    xlabel('归一化频率\omega/\pi'); ylabel('相频响应 (rad)');
    title([case_name,'-相频响应']);
    grid on; axis tight;
    % 子图4：线性相位幅度函数
    subplot(2,2,4);
    plot(w_hr/pi, abs(Hr), 'LineWidth',1.5, 'Color', 'b');
    xlabel('归一化频率\omega/\pi'); ylabel('幅度函数H(\omega)');
    title([case_name,'-线性相位幅度函数']);
    grid on; axis tight;
    % 保存滤波器特性图
    save_path2 = [save_prefix,'-滤波器特性.png'];
    print(gcf, save_path2, '-dpng', '-r300');
    
    % 指标验证（通带波纹/阻带衰减）
    pass_idx = w_freq <= wp;
    pass_mag = mag_dB(pass_idx);
    actual_Rp = max(pass_mag) - min(pass_mag);  % 实际通带波纹
    stop_idx = w_freq >= ws;
    actual_As = max(mag_dB(stop_idx));          % 实际阻带衰减（dB，负数）
    
    % 判断是否满足指标（阻带衰减≤-As dB即满足）
    if (actual_Rp <= Rp) && (actual_As <= -As)
        str_qualified = '是';
    else
        str_qualified = '否';
    end
    
    % 输出验证结果
    fprintf('%s：通带波纹=%.2f dB（要求≤%d dB），阻带衰减=%.2f dB（要求≥%d dB），是否满足指标：%s\n', ...
        case_name, actual_Rp, Rp, abs(actual_As), As, str_qualified);
end