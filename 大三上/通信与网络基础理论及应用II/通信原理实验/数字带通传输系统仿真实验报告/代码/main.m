% 主程序：选择实验编号，执行对应仿真
clc; clear; close all;
exp = 1; % 实验编号

% 实验1：无噪BPSK带通传输仿真
if exp == 1
    rng(1120232075);  % 固定随机种子
    clc; clear; close all;
    fs = 5e5; % 采样频率500kHz
    osample = 16; % 过采样率16
    fc = 5e4; % 载波频率50kHz
    flag1 = 1; % 启用绘图
    flag2 = 1; % 启用序列截断
    is_int_os = 1; % 整数倍过采样
    conv_mode = 'same'; % 卷积模式same
    T = 1; % 采样时间1s
    EbN0 = 'None'; % 无噪
    [ber_theorical, error_rating_hrc, error_rating_rectang] = psk(fs, osample, fc, conv_mode, flag1, flag2, EbN0, T, is_int_os);
    fprintf('误码率(无噪)BER=%.2f%%\n',error_rating_hrc*100)

% 实验2：不同成型滤波器误码率对比
elseif exp == 2
    rng(1120232075);  % 固定随机种子
    fs = 5e5;
    osample = 16;
    fc = 5e4;
    flag1 = 1;
    flag2 = 1;
    is_int_os = 1;
    conv_mode = 'same';
    T = 1;
    EbN0 = -10:1:10; % 信噪比范围-10~10dB
    [ber_theorical, error_rating_hrc, error_rating_rectang] = psk(fs, osample, fc, conv_mode, flag1, flag2, EbN0, T, is_int_os);
    BER = [ber_theorical; error_rating_hrc; error_rating_rectang];
    name = '不同成型滤波器误码率与EbN0关系对比图';
    plot_BER(EbN0,BER,name,'滤波器',EbN0(1:3),1)

% 实验4：采样频率/符号速率/载波频率对误码率影响
elseif exp ==4
    flag1 = 0; % 禁用绘图（提升仿真速度）
    flag2 = 0; % 禁用截断
    EbN0 = -10:1:10;
    T = 1;
    conv_mode = 'same';
    is_int_os = 1;

    %% 4.1 固定fs/fc，改变符号速率Rs（通过osample调整）
    fs_fixed = 5e5;
    fc_fixed = 5e4;
    osample_list = [2,4,8,16,32]; % 过采样率列表
    ber_hrc_41 = zeros(length(osample_list), length(EbN0)); % 存储误码率
    % 遍历过采样率，计算误码率
    for idx = 1:length(osample_list)
        rng(1120232075);
        os = osample_list(idx);
        [ber_theorical, ber_hrc, ber_rect] = psk(fs_fixed, os, fc_fixed, conv_mode, flag1, flag2, EbN0, T, is_int_os);
        ber_hrc_41(idx,:) = ber_hrc;
    end
    Rs_list = fs_fixed ./ osample_list; % 计算对应的符号速率
    name = '不同符号速率的误码率随EbN0变化图';
    plot_BER(EbN0,ber_hrc_41,name,'Rs',Rs_list,0)

    %% 4.2 固定Rs/fc，改变采样频率fs
    Rs_fixed = 31250; % 固定符号速率31250Baud
    fc_fixed = 5e4;
    fs_list = [93750,1.25e5,2.5e5,5e5,1e6]; % 采样频率列表
    osample_list_42 = fs_list / Rs_fixed; % 计算对应过采样率
    ber_hrc_42 = zeros(length(fs_list), length(EbN0));
    % 遍历采样频率，计算误码率
    for idx = 1:length(fs_list)
        rng(1120232075);
        fs = fs_list(idx);
        os = osample_list_42(idx);
        [ber_theorical, ber_hrc, ber_rect] = psk(fs, os, fc_fixed, conv_mode, flag1, flag2, EbN0, T, is_int_os);
        ber_hrc_42(idx,:) = ber_hrc;
    end
    name = '不同采样频率的误码率随EbN0变化图';
    plot_BER(EbN0,ber_hrc_42,name,'fs',fs_list,0)

    %% 4.3 固定fs/osample，改变载波频率fc
    fs_fixed = 5e5;
    os_fixed = 16;
    fc_list = [5e4,1e5,2e5,5e5,10e5]; % 载波频率列表
    ber_hrc_43 = zeros(length(fc_list), length(EbN0));
    % 遍历载波频率，计算误码率
    for idx = 1:length(fc_list)
        rng(1120232075);
        fc = fc_list(idx);
        [ber_theorical, ber_hrc, ber_rect] = psk(fs_fixed, os_fixed, fc, conv_mode, flag1, flag2, EbN0, T, is_int_os);
        ber_hrc_43(idx,:) = ber_hrc;
    end
    name = '不同载波频率的误码率随EbN0变化图';
    plot_BER(EbN0,ber_hrc_43,name,'fc',fc_list,0)

% 实验5：滤波器same/full模式对误码率影响
elseif exp == 5
    clc; clear; close all;
    rng(1120232075);
    is_int_os = 1;
    fs_fixed = 5e5;
    os_fixed = 16;
    fc_fixed = 5e4;
    EbN0 = -10:1:10;
    T =1;
    conv_modes = {'same','full'}; % 两种卷积模式

    % 分别仿真same模式、full模式（截断/不截断）
    [~, ber_hrc_same, ber_rect_same] = psk(fs_fixed, os_fixed, fc_fixed, conv_modes{1}, 0, 1, EbN0, T, is_int_os);
    [~, ber_hrc_full1, ber_rect_full] = psk(fs_fixed, os_fixed, fc_fixed, conv_modes{2}, 0, 1, EbN0, T, is_int_os);
    [~, ber_hrc_full2, ~] = psk(fs_fixed, os_fixed, fc_fixed, conv_modes{2}, 0, 0, EbN0, T, is_int_os);

    BER = [ber_hrc_same; ber_hrc_full1; ber_hrc_full2];
    name = '滤波器same和full模式误码率对比';
    plot_BER(EbN0,BER,name,'samefull',EbN0(1:3),1)

% 实验6：整数/非整数倍过采样对误码率影响
elseif exp == 6
    clc; clear; close all;
    rng(1120232075)
    flag1 = 0;
    flag2 = 0;
    conv_mode = 'same';
    fs_fixed = 5e5;
    fc_fixed = 5e4;
    T = 1;
    EbN0 = -10:1:10;
    osample_list = [15.5, 16, 16.5, 20]; % 整数/非整数过采样率
    is_int_os_list = [0, 1, 0, 1]; % 标记是否整数倍

    % 预分配存储
    ber_hrc_6 = zeros(length(osample_list), length(EbN0));
    ber_rect_6 = zeros(length(osample_list), length(EbN0));

    % 遍历过采样率，计算误码率
    for idx = 1:length(osample_list)
        os = osample_list(idx);
        is_int = is_int_os_list(idx);
        [ber_theorical, ber_hrc, ber_rect] = psk(fs_fixed, os, fc_fixed, conv_mode, flag1, flag2, EbN0, T, is_int);
        ber_hrc_6(idx,:) = ber_hrc;
        ber_rect_6(idx,:) = ber_rect;
    end
    name = '整数和非整数倍过采样对根升余弦成形误码率的影响';
    plot_BER(EbN0,ber_hrc_6,name,'osr',osample_list,0)

% 无效实验编号提示
else
   error('该实验不存在！有效实验编号为1,2,4,5,6')
end