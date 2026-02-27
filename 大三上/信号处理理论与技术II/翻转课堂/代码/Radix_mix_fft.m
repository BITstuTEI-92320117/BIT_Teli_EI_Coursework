function fft_x = Radix_mix_fft(x)
% 混合基 fft
% 基-p 混合基fft, 可以处理任意长度

% 获取数据长度, 之后对它进行质因数分解
N = length(x);
factor_list = factor(N);  % 质因数分解

if factor_list(1) == 1  % 递归到底了
    fft_x = x;
    return;
end

p = factor_list(1);  % 取最小的那个
% 将数据划分为p段, 每一段长度为N/p
X_p_array = zeros(p, N/p);  % 每一行就是一段

for i = 1:1:p
    % 调用自己
    X_p_array(i, :) = Radix_mix_fft(x(i:p:N)); 
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