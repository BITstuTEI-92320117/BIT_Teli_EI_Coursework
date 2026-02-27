function output = SMTTrigger(input, thresholdLow, thresholdHigh)
% 输入参数：
% input: 输入信号向量
% thresholdLow: 触发器的低阈值
% thresholdHigh: 触发器的高阈值
% 输出参数：
% output: 输出信号向量

output = zeros(size(input)); % 初始化输出向量

% 遍历输入信号向量
for i = 1:length(input)
    if input(i) > thresholdHigh
        output(i) = 1; % 高电平
    elseif input(i) < thresholdLow
        output(i) = 0; % 低电平
    else
        % 保持之前的输出状态
        if i > 1
            output(i) = output(i-1);
        end
    end
end
end