function [Error_Point, Error_Rate,Sequence_Length, Error_Code_Rate]...
    =VSB_ModDmod(N, fs, fc, Ac, fm, Ka, SNR, Filter, pic, n)
% N  采样点数 N  = 40000
% fs 采样率 fs = 20000
% fc 载波频率 (Hz) fc = 2000
% Ac 载波幅度 Ac = 1
% fm 基带信号频率（码元速率） (Hz) fm = 50
% Ka 调制系数 Ka = 1
% SNR 信噪比dB  SNR = 20


%% 确定采样率
%clear all;		%清除所有
% SSB调制解调过程
%% 基本参数
dt=1/fs;                    % 时间采样间隔，采样频率的倒数
t=(0:N-1) * dt;               % 采样点的时间序列，作为横坐标
t_max = t(end);	%最大时间

% 图形显示参数设置
t_window = t_max/10;  % 时域图形显示的时间范围（最大时间的1/10）
t_door   = 3;         % 时域图形显示的幅度范围（-3到3）
f_window = fs/4;      % 频域图形显示的频率范围（-fs/4到fs/4）
f_door   = 0.5;       % 频域图形显示的幅度范围（0到0.5）

%% 载波生成
c_t = Ac*cos(2*pi*fc*t);  % 载波时域信号（余弦波）

% 绘制载波时域和频域图形
[f,C_f] = T2F(t, c_t);  % T2F是自定义函数，将时域信号转换为频域
if pic == 1
    figure(1);
    subplot(2,1,1);
    plot(t,c_t);
    axis([0, t_window, -t_door, t_door]);
    title('载波信号');

    % 计算载波的频域表示
    subplot(2,1,2);
    plot(f,abs(C_f));
    axis([-f_window, f_window, 0, 1]);
    title('载波频域');
    saveas(gcf,'载波信号.png');
end

%% 基带信号生成
Tm = 1/fm;        % 码元周期 (秒)
% 生成二元随机基带信号（使用自定义函数myBinary）
[m_t, ~, Sequence_Length] = myBinary(t, Tm);

% 绘制基带信号时域和频域图形
[f,M_f] = T2F(t, m_t);
if pic == 1
    figure(2);
    subplot(2,1,1);
    plot(t,m_t);
    axis([t_max/2 - t_window, t_max/2 + t_window, -t_door, t_door]);
    title('基带信号');

    % 计算基带信号的频域表示
    subplot(2,1,2);
    plot(f,abs(M_f));
    axis([-f_window, f_window, 0, f_door]);
    title('基带频域');
    saveas(gcf,'基带信号.png');
end

%% DSB调制
s_t = Ka * m_t .* c_t;  % DSB调制（双边带调制）
% 绘制调制后的时域和频域图形
[f,S_f] = T2F(t, s_t);
if pic == 1
    figure(3);
    subplot(2,1,1);
    plot(t,s_t);
    axis([t_max/2 - t_window, t_max/2 + t_window, -t_door, t_door]);
    title('DSB调制信号');
    %频域
    subplot(2,1,2);
    plot(f,abs(S_f));
    axis([-f_window, f_window, 0, f_door]);
    title('DSB调制信号频域');
    saveas(gcf,'DSB调制信号频域.png');
end

%% ******************VSB波信号时域波形******************
[samsf1]=lpf_VSB(f,S_f,fc);      % VSB滤波
[t,v_t]=F2T(f,samsf1);            %逆傅里叶变换

% 绘制滤波后的时域和频域图形
[f,Sb_f] = T2F(t, v_t);
if pic == 1
    figure(4);
    subplot(2,1,1);
    plot(t,v_t);
    axis([t_max/2 - t_window, t_max/2 + t_window, -t_door, t_door]);
    title('VSB信道信号');
    %频域

    subplot(2,1,2);
    plot(f,abs(Sb_f));
    axis([-f_window, f_window, 0, f_door]);
    title('VSB信道频域');
    saveas(gcf,'VSB信道信号.png');
end

%% 传输（加噪）
if SNR == '0'
    vn_t = v_t;
else
    vn_t=awgn(v_t,SNR,'measured');  % 加入高斯白噪声
end

% 绘制加噪后的时域和频域图形
[f,Sn_f] = T2F(t, vn_t);
if pic == 1
    figure(5);
    subplot(2,1,1);
    plot(t,vn_t);
    axis([t_max/2 - t_window, t_max/2 + t_window, -t_door, t_door]);
    title('VSB调制信号加噪');
    %频域
    subplot(2,1,2);
    plot(f,abs(Sn_f));
    axis([-f_window, f_window, 0, f_door]);
    title('VSB调制信号加噪频域');
    saveas(gcf,'VSB信道信号加噪.png');
end

% 调用利用率分析函数（增加）
if n == 1
    bit_rate = fm;  % 码元速率即比特率(假设二进制)
    [bandwidth, spec_eff, ~, ~] = Spectrum_Analysis(vn_t, fs, bit_rate, str2double(SNR), t);
    % 显示分析结果
    fprintf('90%%能量带宽: %.2f Hz\n', bandwidth);
    fprintf('频谱利用率: %.4f bps/Hz\n', spec_eff);
end

%% ******************相干解调******************
%% ******************已调信号与载波信号相乘******************
v0_t = vn_t.*c_t;                     % 已调信号与载波信号相乘

% 绘制相干解调后的时域和频域图形
[f,V0_f] = T2F(t, v0_t);
if pic == 1
    figure(6);
    subplot(2,1,1);
    plot(t,v0_t);
    axis([t_max/2 - t_window, t_max/2 + t_window, -t_door, t_door]);
    title('相干解调的信号');
    %频域

    subplot(2,1,2);
    plot(f,abs(V0_f));
    axis([-f_window, f_window, 0, f_door]);
    title('相干解调的信号频域');
    saveas(gcf,'VSB相干解调信号.png');
end

%% SSB解调步骤2（低通滤波：滤除高频分量）
BT = 5*fm;
if Filter == 3
    [t,v1_t] = myEllipticLPF(t, v0_t, BT);
else
    [t,v1_t] = myLPF(t, v0_t, BT);
end

% 绘制低通滤波后的时域和频域图形
[f,V1_f] = T2F(t, v1_t);
if pic == 1
    figure(7);
    subplot(2,1,1);
    plot(t,v1_t);
    axis([t_max/2 - t_window, t_max/2 + t_window, -t_door, t_door]);
    title('低通滤波的信号');
    %频域
    subplot(2,1,2);
    plot(f,abs(V1_f));
    axis([-f_window, f_window, 0, f_door]);
    title('低通滤波信号频域');
    if Filter == 3
        saveas(gcf,'VSB相干解调椭圆低通滤波的信号.png');
    else
        saveas(gcf,'VSB相干解调理想低通滤波的信号.png');
    end
end

%% SSB解调步骤3（归位：幅度调整）
% 调整幅度，补偿解调过程中的衰减（理论推导的增益因子为4/(Ka*Ac^2)）
v2_t = v1_t*4/(Ka*Ac^2);

% 计算调整后的频域
[f,V2_f] = T2F(t, v2_t);

if pic == 1
    % 绘制原始基带信号和解调信号的对比
    figure(8);
    subplot(2,1,1);
    plot(t, m_t);
    axis([t_max/2 - t_window, t_max/2 + t_window, -t_door, t_door]);
    title('解调信号');
    hold on;
    plot(t,v2_t);
    legend('原始信号','解调信号');
    hold off;
    subplot(2,1,2);
    plot(f,abs(M_f));
    axis([-f_window, f_window, 0,f_door]);
    title('解调信号频域');
    hold on;
    plot(f,abs(V2_f));
    legend('原始信号','解调信号');
    hold off;
    if Filter == 3
        saveas(gcf,'VSB原始解调信号椭圆滤波.png');
    else
        saveas(gcf,'VSB原始解调信号理想滤波.png');
    end
end

%% 施密特整型（将模拟信号转换为数字信号）
% 使用施密特触发器，阈值设为-0.5和0.5
% 输出为0和1，然后调整为-1和1（与原始基带信号一致）
y_t = 2*SMTTrigger(v2_t, -1/2, 1/2) - 1;

% 绘制整型信号与原始基带信号的对比
if pic == 1
    figure(9);
    subplot(2,1,1);
    plot(t, y_t);axis([0, t_max, -t_door, t_door]);title('整型信号');hold on;
    plot(t, m_t);axis([0, t_max, -t_door, t_door]);title('原始信号');legend('整型信号','原始信号');hold off;
end

% 计算误差率
e_t = abs(y_t - m_t);
Error_Point = sum(e_t)/2;
Error_Rate = Error_Point / N;
fprintf('误差点数：%d, 误差率：%.2f%%\n', Error_Point, Error_Rate*100);
if pic == 1
    subplot(2,1,2);
    plot(t, e_t);
    axis([0, t_max, -t_door/3, t_door]);
    title('误差波形');
    if Filter == 3
        saveas(gcf,'VSB误差信号椭圆滤波.png');
    else
        saveas(gcf,'VSB误差信号理想滤波.png');
    end
end

%% 计算误码率（新增）与SSB基本相同
% 首先确定译码序列，确定最佳采样位置，这里采用码元周期的中间位置，此时受其他码元干扰较小（写完去除）
M_Code = GetSequence(t, m_t, Tm);
Y_Code = GetSequence(t, y_t, Tm);
[Y_Code, ~] = shift_compare(Y_Code, M_Code);
E_Code = abs(M_Code - Y_Code);
Error_Code_Num = sum(E_Code);
Error_Code_Rate = Error_Code_Num / Sequence_Length;

if pic == 1
    figure(10);
    subplot(3,1,1);stem(M_Code);axis([0,Sequence_Length,-0.8,1.8]);title('原序列');
    subplot(3,1,2);stem(Y_Code);axis([0,Sequence_Length,-0.8,1.8]);title('输出序列');
    subplot(3,1,3);stem(E_Code);axis([0,Sequence_Length,-0.8,1.8]);title('误码序列');
end
fprintf('码元总数：%d, 误码点数：%d\n',Sequence_Length, Error_Code_Num);
fprintf('误码率：%.2f%%\n', Error_Code_Rate*100);
end