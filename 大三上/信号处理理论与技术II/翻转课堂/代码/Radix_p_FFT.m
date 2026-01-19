function fft_x = Radix_p_FFT(x, p)
% 基p的fft
% 需要保证 x的长度为p^n
N = length(x);
if N == 1
    fft_x = x;
    return;
end
X_p_array = zeros(p, N/p);  % 每一行就是一段
for i = 1:1:p
    X_p_array(i, :) = Radix_p_FFT(x(i:p:N), p);  % 索引为0, p, 2p, ... // 1, p+1, 2p+1, ...
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