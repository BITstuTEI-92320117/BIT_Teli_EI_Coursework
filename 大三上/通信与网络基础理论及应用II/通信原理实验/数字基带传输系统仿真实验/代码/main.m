clear, clc, close all;
rng(1120232075) % 设置随机种子
exp = 1; % 实验编号
% 实验参数
Rb = 31.25e6;            % 符号速率
fs = 500e6;              % 采样频率
osr = fs/Rb;             % 过采样率
Ts = 1/Rb;               % 符号周期
T_fs = 1/fs;             % 采样周期
T = 1;                   % 采样时间，若运行时间过长，可改用0.1s等较小值，不影响实验结论
sym_num = Rb * T;        % 符号个数
sam_num = sym_num * osr; % 采样点个数
alpha = 0.3;             % 滚降系数
EbN0 = -10:1:10;          % 信噪比范围（dB）
span = 6;                % 滤波器跨度（符号数）
N_draw = 20;             % 绘制码元个数
eq_tap_num = 201;          % 均衡器抽头数
if exp == 1
    % 实验1：无噪声下误码率
    [BER_theory, BER_RRCF, BER_rect_noeq, ~, ~] = baseband(Rb, fs, T, alpha, span, 'None', N_draw, 0, 1, 1);
elseif exp == 2
    % 实验2：不同滤波器误码率对比
    name_BER = '不同成形滤波器误码率与EbN0关系对比图';
    [BER_theory, BER_RRCF, BER_rect_noeq, ~, ~] = baseband(Rb, fs, T, alpha, span, EbN0, N_draw, 0, 0, 1);
    BER = [BER_theory; BER_RRCF; BER_rect_noeq];
    plot_BER(EbN0,BER,name_BER,'滤波器',EbN0(1:3),1)
elseif exp == 3
    % 实验3：升余弦滤波器参数对性能的影响
    alpha_list = [0.1, 0.3, 0.5, 0.7, 1.0];  % 滚降系数列表
    span_list = [4, 6, 8, 10];               % 滤波器跨度列表
    osr_list = [8, 16, 32];                  % 过采样率列表
    % 1. 滚降系数alpha的影响
    name_BER = '不同滚降系数误码率随EbN0变化图';
    cato_Eta = '滚降系数';
    BER_alpha = zeros(length(alpha_list), length(EbN0));
    Eta_alpha = zeros(1, length(alpha_list));
    for i = 1:length(alpha_list)
        alpha_i = alpha_list(i);
        [~, BER_alpha(i,:), ~, ~, ~] = baseband(Rb, fs, T, alpha_i, span, EbN0, N_draw, 0, 0, 0);
        [~, ~, ~, ~, Eta_alpha(i)] = baseband(Rb, fs, T, alpha_i, span, 'None', N_draw, 0, 2, 0);
    end
    plot_BER(EbN0,BER_alpha,name_BER,'alpha', alpha_list, 0)
    plot_Eta(alpha_list, Eta_alpha, cato_Eta)
    % 2. 滤波器跨度span的影响
    name_BER = '不同滤波器跨度误码率随EbN0变化图';
    cato_Eta = '滤波器跨度';
    BER_span = zeros(length(span_list), length(EbN0));
    Eta_span = zeros(1, length(span_list));
    alpha_fixed = 0.3;  
    for i = 1:length(span_list)
        span_i = span_list(i);
        [~, BER_span(i,:), ~, ~, ~] = baseband(Rb, fs, T, alpha_fixed, span_i, EbN0, N_draw, 0, 0, 0);
        [~, ~, ~, ~, Eta_span(i)] = baseband(Rb, fs, T, alpha_fixed, span_i, 'None', N_draw, 0, 2, 0);
    end
    plot_BER(EbN0,BER_span,name_BER,'span', span_list, 0)
    plot_Eta(span_list, Eta_span, cato_Eta)
    % 3. 过采样率osr的影响
    name_BER = '不同过采样率误码率随EbN0变化图';
    cato_Eta = '过采样率';
    BER_osr = zeros(length(osr_list), length(EbN0));
    Eta_osr = zeros(1, length(osr_list));
    span_fixed = 6;     
    for i = 1:length(osr_list)
        osr_i = osr_list(i);
        fs_i = osr_i * Rb;  % 同步调整采样频率
        [~, BER_osr(i,:), ~, ~, ~] = baseband(Rb, fs_i, T, alpha_fixed, span_fixed, EbN0, N_draw, 0, 0, 0);
        [~, ~, ~, ~, Eta_osr(i)] = baseband(Rb, fs_i, T, alpha_fixed, span_fixed, 'None', N_draw, 0, 2, 0);
    end
    plot_BER(EbN0,BER_osr,name_BER,'osr', osr_list, 0)
    plot_Eta(osr_list, Eta_osr, cato_Eta)
elseif exp == 4
    % 实验4：时域均衡
    name_BER = '时域均衡误码率与EbN0关系对比图';
    [BER_theory, BER_RRCF, BER_rect_noeq, BER_rect_eq, ~] = baseband(Rb, fs, T, alpha, span, EbN0, N_draw, eq_tap_num, 0, 1);
    BER = [BER_theory; BER_RRCF; BER_rect_noeq;BER_rect_eq];
    plot_BER(EbN0,BER,name_BER,'滤波器',EbN0(1:4),1)
else
    % 实验编号错误提示
    error('该实验不存在！有效实验编号为1,2,3,4')
end
