function seq = gen_seq(N, p)
% 生成长度N、0概率p的二进制随机序列
r = rand(1, N);        % 生成[0,1)随机数
seq = (r > p);         % 随机数>p为1，否则为0
end