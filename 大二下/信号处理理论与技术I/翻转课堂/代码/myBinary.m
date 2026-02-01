function [x_t, Nm, Sequence_Length] = myBinary(t,Tm)		%二元随机信号
% 函数功能：生成二元随机信号（取值为-1或1）
% 输入参数：
%   t: 时间向量，定义了信号的时间范围
%   Tm: 码元周期（每个码元持续的时间长度）
% 输出参数：
%   x_t: 生成的二元随机信号（时域波形）
%   Nm: 每个码元周期内的采样点数
%   Sequence_Length: 生成的码元序列的长度（即码元个数）

% 获取时间向量t的长度，即总采样点数
N = length(t);
  
% 计算时间向量的总时长（从第一个时间点到最后一个时间点）
Len = t(end)-t(1);
    
% 计算码元翻转的次数（即码元的个数，使用floor确保整数）
% 注意：最后一个码元可能不完整
Turning_Times = fix(Len/Tm);  %翻转次数

% 计算每个码元周期内包含的采样点数（取整）
Nm = floor(N/Turning_Times);    %码元点数

% 初始化输出信号向量，长度为N，全零
x_t = zeros(1,N);

% 生成随机相位偏移（0到Nm-1之间的整数）
% 使码元边界不一定从采样点开始，模拟实际信号
N_Phase = randi([0,Nm-1]);
 
% 循环生成每个码元区间的信号（除了第一个和最后一个码元）
for k = 0:Turning_Times-2
    % 计算当前码元的起始位置：k*Nm+1+N_Phase
    % 结束位置：(k+1)*Nm+N_Phase
    % 在每一个码元区间内，生成一个随机的二元值（-1或1）
    x_t(k*Nm+1+N_Phase:(k+1)*Nm+N_Phase) = 2*randi([0, 1]) - 1;
end
% 处理信号起始部分（第一个码元之前的部分）
% 使用随机二元值填充（长度为N_Phase）
x_t(1:N_Phase) = 2*randi([0, 1]) - 1;
    
% 处理信号结束部分（最后一个码元）
% 使用随机二元值填充剩余部分
x_t((Turning_Times-1)*Nm+1:end) = 2*randi([0, 1]) - 1;
    
% 设置输出的码元序列长度（实际生成的码元个数）

Sequence_Length = Turning_Times;
end