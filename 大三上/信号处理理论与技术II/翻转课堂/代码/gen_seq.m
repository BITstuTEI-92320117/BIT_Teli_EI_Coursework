function [n, seq] = gen_seq(a, L)
% 生成有限长单边指数序列       
n = 0:L-1;         
seq = a.^n;         
end