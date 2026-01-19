function receivedBits = add_noise(encodedBits,Pe)
%% 信道模拟（核心步骤4：噪声添加）
receivedBits = encodedBits; % 初始化接收信号
% 生成随机错误位置（Pe概率的误码）
errorPositions = rand(size(encodedBits)) < Pe;
% 翻转错误位置的比特值
receivedBits(errorPositions) = 1 - receivedBits(errorPositions);
end