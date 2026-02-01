function [Error_Point, Error_Rate, Sequence_Length, Error_Code_Rate]...
    =SSB_ModDmod(N, fs, fc, Ac, fm, Ka, SNR, Filter, pic, m, n)
% N  采样点数 N  = 40000
% fs 采样率 fs = 20000
% fc 载波频率 (Hz) fc = 2000
% Ac 载波幅度 Ac = 1
% fm 基带信号频率（码元速率） (Hz) fm = 50
% Ka 调制系数 Ka = 1
% SNR 信噪比dB  SNR = 20


%% 确定采样率
dt = 1/fs;		%采样间隔0.00005
t  = (0:N-1)*dt;	%从零开始的时域（0-2s）
t_max = t(end);	%最大时间

% 图形显示参数设置
t_window = t_max/10;  % 时域图形显示的时间范围（最大时间的1/10）
t_door   = 3;         % 时域图形显示的幅度范围（-3到3）
f_window = fs/4;      % 频域图形显示的频率范围（-fs/4到fs/4）
f_door   = 0.5;       % 频域图形显示的幅度范围（0到0.5）

%% 载波生成
c_t = Ac*cos(2*pi*fc*t);  % 载波时域信号（余弦波）

% 绘制载波时域和频域图形
if pic == 1
    figure(1);
    subplot(2,1,1);
    plot(t,c_t);
    axis([0, t_window, -t_door, t_door]);
    title('载波信号');

    % 计算载波的频域表示
    [f,C_f] = T2F(t, c_t);  % T2F是自定义函数，将时域信号转换为频域
    subplot(2,1,2);
    plot(f,abs(C_f));
    axis([-f_window, f_window, 0, 1]);
    title('载波频域');
    saveas(gcf,'载波信号.png');
end

%% 基带信号生成
Tm = 1/fm;        % 码元周期 (秒)
% 生成二元随机基带信号（使用自定义函数myBinary）
% 生成99个码元，每个码元的周期为0.02s，每个码元的采样点数为404（增加）
% 这样做是因为码元边界不一定从采样点开始，模拟实际信号，要生成随机相位偏移（增加）
[m_t, ~, Sequence_Length] = myBinary(t, Tm);

if pic == 1
    % 绘制基带信号时域和频域图形
    figure(2);
    subplot(2,1,1);
    plot(t,m_t);
    axis([t_max/2 - t_window, t_max/2 + t_window, -t_door, t_door]);
    title('基带信号');

    % 计算基带信号的频域表示
    [f,M_f] = T2F(t, m_t);
    subplot(2,1,2);
    plot(f,abs(M_f));
    axis([-f_window, f_window, 0, f_door]);
    title('基带频域');
    saveas(gcf,'基带信号.png');
end

%% SSB调制
s_t = Ka * m_t .* c_t;  % DSB调制（双边带调制）
% 绘制调制后的时域和频域图形
if pic == 1
    figure(3);
    subplot(2,1,1);
    plot(t,s_t);
    axis([t_max/2 - t_window, t_max/2 + t_window, -t_door, t_door]);
    title('DSB调制信号');
    saveas(gcf,'DSB调制信号.png');
    %频域
    [f,S_f] = T2F(t, s_t);
    subplot(2,1,2);
    plot(f,abs(S_f));
    axis([-f_window, f_window, 0, f_door]);
    title('DSB调制信号频域');
    saveas(gcf,'DSB调制信号.png');
end

% 调用频谱利用率分析函数（DSB调制）（增加）
if n == 1
    bit_rate = fm;  % 码元速率即比特率(假设二进制)
    [bandwidth, spec_eff, ~, ~] = Spectrum_Analysis(s_t, fs, bit_rate, str2double(SNR), t);
    % 显示分析结果
    fprintf('90%%能量带宽: %.2f Hz\n', bandwidth);
    fprintf('DSB调制频谱利用率: %.4f bps/Hz\n', spec_eff);
end

BT = 5*fm;%理论上：fc > BT/2（基带带宽）就不会混叠
if m == 0
    %% 信道处理（带通滤波）
    % 使用带通滤波器，只保留上边带（频率范围：fc 到 fc+BT）
    if Filter ==2
        [t, sb_t] = myLPF(t, s_t, fc);
    elseif Filter == 3
        [t, sb_t] = myEllipticLPF(t, s_t, fc);
    end
else
    s_t = Ac*sin(2*pi*fc*t);  % 载波时域信号（正弦波）
    m_h_t = imag(hilbert(m_t));  % 希尔伯特变换得到正交分量
    sb_t = m_t.*c_t + m_h_t.*s_t; % 相移法实现
end

% 绘制滤波后的时域和频域图形
if pic == 1
    figure(4);
    subplot(2,1,1);
    plot(t,sb_t);
    axis([t_max/2 - t_window, t_max/2 + t_window, -t_door, t_door]);
    title('SSB信道信号');

    %频域
    [f,Sb_f] = T2F(t, sb_t);
    subplot(2,1,2);
    plot(f,abs(Sb_f));
    axis([-f_window, f_window, 0, f_door]);
    title('SSB信道频域');
    if Filter ==2
        saveas(gcf,'SSB信道信号下边带理想滤波.png');
    elseif Filter == 3
        saveas(gcf,'SSB信道信号下边带椭圆滤波.png');
    end
end

% 调用利用率分析函数（SSB调制）（增加）
if n == 1
    bit_rate = fm;  % 码元速率即比特率(假设二进制)
    [bandwidth, spec_eff, ~, ~] = Spectrum_Analysis(sb_t, fs, bit_rate, str2double(SNR), t);
    % 显示分析结果
    fprintf('90%%能量带宽: %.2f Hz\n', bandwidth);
    fprintf('SSB调制频谱利用率: %.4f bps/Hz\n', spec_eff);
end

%% 传输（加噪）
if SNR == '0'
    sn_t = sb_t;
else
    sn_t=awgn(sb_t,SNR,'measured');  % 加入高斯白噪声
end

% 绘制加噪后的时域和频域图形
if pic == 1
    figure(5);
    subplot(2,1,1);
    plot(t,sn_t);
    axis([t_max/2 - t_window, t_max/2 + t_window, -t_door, t_door]);
    title('SSB调制信号加噪');


    %频域
    [f,Sn_f] = T2F(t, sn_t);
    subplot(2,1,2);
    plot(f,abs(Sn_f));
    axis([-f_window, f_window, 0, f_door]);
    title('SSB调制信号加噪频域');
    if Filter ==2
        saveas(gcf,'SSB信道信号下边带理想滤波加噪.png');
    elseif Filter == 3
        saveas(gcf,'SSB信道信号下边带椭圆滤波加噪.png');
    end
end

snb_t = sn_t;

% %% 信道处理2（接收端带通滤波：再次滤波去除带外噪声）
if Filter == 2
    [t, snb_t] = myLPF(t, sn_t, fc);
end

%% SSB解调步骤1（相干解调：与本地载波相乘）
v0_t = snb_t.*c_t;

% 绘制相干解调后的时域和频域图形
if pic == 1
    figure(6);
    subplot(2,1,1);
    plot(t,v0_t);
    axis([t_max/2 - t_window, t_max/2 + t_window, -t_door, t_door]);
    title('相干解调的信号');


    %频域
    [f,V0_f] = T2F(t, v0_t);
    subplot(2,1,2);
    plot(f,abs(V0_f));
    axis([-f_window, f_window, 0, f_door]);
    title('相干解调的信号频域');
    if Filter ==2
        saveas(gcf,'SSB相干解调的信号下边带理想滤波加噪.png');
    elseif Filter == 3
        saveas(gcf,'SSB相干解调的信号下边带椭圆滤波加噪.png');
    end
end

%% SSB解调步骤2（低通滤波：滤除高频分量）
if Filter == 3
    [t,v1_t] = myEllipticLPF(t, v0_t, BT);
else
    [t,v1_t] = myLPF(t, v0_t, BT);
end

if pic == 1
    figure(7);
    subplot(2,1,1);
    plot(t,v1_t);
    axis([t_max/2 - t_window, t_max/2 + t_window, -t_door, t_door]);
    title('低通滤波的信号');

    %频域
    [f,V1_f] = T2F(t, v1_t);
    subplot(2,1,2);
    plot(f,abs(V1_f));
    axis([-f_window, f_window, 0, f_door]);
    title('低通滤波信号频域');
    if Filter ==2
        saveas(gcf,'SSB低通滤波的信号下边带理想滤波加噪.png');
    elseif Filter == 3
        saveas(gcf,'SSB低通滤波的信号下边带椭圆滤波加噪.png');
    end
end

%% SSB解调步骤3（归位：幅度调整）
% 调整幅度，补偿解调过程中的衰减（理论推导的增益因子为4/(Ka*Ac^2)）
if m == 0
    v2_t = v1_t*4/(Ka*Ac^2);
else
    v2_t = v1_t*2/(Ka*Ac^2);
end

% 计算调整后的频域
[f,V2_f] = T2F(t, v2_t);

% 绘制原始基带信号和解调信号的对比
if pic == 1
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
    if Filter ==2
        saveas(gcf,'SSB原始解调信号下边带理想滤波.png');
    elseif Filter == 3
        saveas(gcf,'SSB原始解调信号下边带椭圆滤波.png');
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
    if Filter ==2
        saveas(gcf,'SSB误差信号下边带理想滤波.png');
    elseif Filter == 3
        saveas(gcf,'SSB误差信号下边带椭圆滤波.png');
    end
end

%% 计算误码率（新增）
% 首先确定译码序列，确定最佳采样位置，这里采用码元周期的中间位置，此时受其他码元干扰较小
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
end

