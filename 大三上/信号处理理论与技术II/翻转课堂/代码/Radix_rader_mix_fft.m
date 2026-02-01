function fft_x = Radix_rader_mix_fft(x)
% 加入了雷德算法的混合基fft, 可以处理质数情况
% 获取数据长度, 之后对它进行质因数分解
N = length(x);
factor_list = factor(N);  % 质因数分解
if factor_list(1) == 1  % 递归到底了
    fft_x = x;
    return;
end

% 对于小质数长度的序列, 直接用定义比用雷德算法快
if isscalar(factor_list) && factor_list(1) > 32  % 如果序列长度是质数, 则调用雷德算法返回fft结果
    fft_x =  RaderFFT(x);
    return;
end

p = factor_list(1);  % 取最小的那个
X_p_array = zeros(p, N/p);  % 每一行就是一段

for i = 1:1:p
    X_p_array(i, :) = Radix_rader_mix_fft(x(i:p:N));  % 索引为0, p, 2p, ... // 1, p+1, 2p+1, ...
end
WN = exp(-2*pi*1i / N);  % 基于N的旋转因子
Wp = exp(-2*pi*1i / p);  % 基于p的旋转因子

fft_x = zeros(1, N);  % 初始化输出
for k = 0:1:N/p-1
    for i=1:1:p  % 列循环
        for j=1:1:p  % 行循环
            fft_x(k+1+(i-1)*N/p) = fft_x(k+1+(i-1)*N/p) + X_p_array(j, k+1) * WN^((j-1)*k) * Wp^((i-1)*(j-1));
        end
    end
end
end