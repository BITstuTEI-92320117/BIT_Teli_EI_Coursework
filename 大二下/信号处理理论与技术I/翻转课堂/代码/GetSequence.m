function Sequence = GetSequence(t, x_t, Tm)
% GetSequence - 从连续信号中提取二进制序列
% 输入参数:
%   t       - 时间向量
%   x_t     - 连续信号
%   Tm      - 码元周期
% 输出参数:
%   Sequence - 提取出的二进制序列

% 计算信号的总长度和采样点数
Len = t(end)-t(1);
N = length(t);

% 计算预期的码元翻转次数和每个码元的采样点数
Turning_Times = floor(Len/Tm);  % 整个信号持续时间内的码元翻转次数
Nm = floor(N/Turning_Times);    % 每个码元包含的采样点数

% 寻找信号的第一个跳变沿，以此确定最佳采样位置
for i = (1:N)
    if i == 1
        temp = x_t(1);% 初始化参考值为信号的第一个采样点
    else
        % 若发现当前采样点的值与参考值不同，说明找到了跳变沿
        if x_t(i) ~= temp
            rand_Phase = mod(i, Nm) - 1;  % 计算跳变沿在码元周期内的相对位置
            break;
        end
    end
end

% 确定最佳采样位置（通常是码元周期的中间位置）
N_sample = rand_Phase + floor(Nm / 2);   % 从跳变沿位置偏移半个码元宽度，找到码元中间点

% 初始化输出序列
Sequence = zeros(1,Turning_Times-1);

% 对每个码元周期进行采样，生成二进制序列
for i = (1:Turning_Times-1)
    % 依据采样点的值与0的大小关系判断码元是1还是0
    if x_t(N_sample) > 0
        Sequence(i) = 1;
    else
        Sequence(i) = 0;
    end
    % 移动到下一个码元周期的采样点
    N_sample = N_sample + Nm;
end
end
