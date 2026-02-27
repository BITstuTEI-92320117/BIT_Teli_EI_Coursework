% dft, 用定义平凡实现
function dft_x = dft(x)
N = length(x);
dft_x = zeros(1, N);
WN = exp(-2*pi*1i / N);  % 基于N的旋转因子
for i=1:1:N
    for j=1:1:N
        dft_x(i) = dft_x(i) + x(j)*WN^((j-1)*(i-1));
    end
end
end