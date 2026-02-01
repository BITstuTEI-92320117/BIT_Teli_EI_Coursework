function X = RaderFFT(x)
% RaderFFT 实现雷德算法
% 验证输入序列长度是否为质数

N = length(x);
if ~isprime(N)
    error('Input length must be a prime number.');
    % 只处理质数, 其它的情况不应该调用该函数
end

% 常量定义
X0 = sum(x); % 原点项
g = findPrimitiveRoot(N); % 找到模 N 的原根
DOUBLE_PI = 2 * pi;

% 初始化 a_q 和 b_q
aq = zeros(1, N-1);
bq = zeros(1, N-1);
aqIndex = zeros(1, N-1);
bqIndex = zeros(1, N-1);

aqIndex(1) = 1; % 起始索引
bqIndex(1) = 1; % 起始索引
aq(1) = x(2); % 起始值
bq(1) = exp(-1i * DOUBLE_PI / N); % 权重初始化

% 计算索引和权重
currentExp = modExp(g, 1, N); % g^1 mod N
currentExpInverse = modExpInverse(g, 1, N); % g^(-1) mod N
expInverseBase = currentExpInverse;

for index = 2:N-1
    aqIndex(index) = currentExp; % 更新 aq 索引
    bqIndex(index) = currentExpInverse; % 更新 bq 索引

    aq(index) = x(currentExp+1); % 填充 aq 值
    bq(index) = exp(-1i * (currentExpInverse * DOUBLE_PI / N)); % 填充 bq 权重

    % 更新 currentExp 和 currentExpInverse
    currentExp = mod(currentExp * g, N);
    currentExpInverse = mod(currentExpInverse * expInverseBase, N);
end

% 补零到 2 的幂次长度
M = 2^nextpow2(2*N-3);
if M ~= N-1
    aq = [aq(1), zeros(1, M-N+1), aq(2:end)];  % 在第一二元素之间插入连续的零
    len = length(bq);  % 记录旧的bq的长度, 方便之后循环填充
    bq = [bq, zeros(1, M-N+1)];  % 循环填充自己到和aq一样的长度, 务必使用for循环, 以为可能会循环多次, 没法直接索引填充
    for i=1:1:M-N+1
        bq(len+i) = bq(i);
    end
end

% 使用 MATLAB 内置 FFT 计算
% 这部分可以使用matlab自带的fft, 如果已经实现了混合基fft, 也可以用混合基fft, 此时序列长度是2^n, 可以高效计算
% faq = fft(aq);
% fbq = fft(bq);
faq = Radix_2_FFT(aq);
fbq = Radix_2_FFT(bq);
product = faq .* fbq;

% 逆 FFT 计算
% 这个ifft, 序列长度也是2^n, 所以不用担心质数
% inverseDFT = ifft(product);
inverseDFT = Radix_2_IFFT(product);

% 合并结果，注意不做额外的除法
X = zeros(1, N);
X(1) = X0; % DC 分量
for index = 1:N-1
    X(bqIndex(index)+1) = inverseDFT(index) + x(1); % 修复除法问题
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% 辅助函数1:
% 快速模幂计算 (a^k) % n
function result = modExp(a, k, n)
result = 1;
base = mod(a, n);
while k > 0
    if mod(k, 2) == 1
        result = mod(result * base, n);
    end
    base = mod(base^2, n);
    k = floor(k / 2);
end
end

% 辅助函数2:
% 模逆运算 (a^(-k)) % n
function result = modExpInverse(a, k, n)
result = modExp(a, n-1-k, n); % 使用费马小定理
end

% 辅助函数3:
% 找到质数 N 的一个原根
function g = findPrimitiveRoot(N)
for g = 2:N-1
    if isPrimitiveRoot(g, N)
        return;
    end
end
error('No primitive root found.');
end

% 辅助函数4:
% 判断一个数是否是模 N 的原根
function isRoot = isPrimitiveRoot(g, N)
tot = N - 1; % 欧拉函数值 (N 为质数时等于 N-1)
factors = factor(tot); % 对 tot 进行因式分解
isRoot = true;

% 检查 g^((tot)/pi) (mod N) 是否为 1
for pi = factors
    if modExp(g, tot / pi, N) == 1
        isRoot = false;
        return;
    end
end
end

% 辅助函数5:
% 基-2 的fft
function fft_x = Radix_2_FFT(x)
N = length(x);
if N == 1
    fft_x = x;
    return;
end
% 奇数项和偶数项
X_even = Radix_2_FFT(x(1:2:N));  % 偶数项
X_odd = Radix_2_FFT(x(2:2:N));  % 奇数项

% 旋转因子
W = exp(-2*pi*1i/N * (0:N/2-1));
fft_x = [X_even + W .* X_odd, X_even - W .* X_odd];  % 合并结果
end


% 辅助函数6-part1：
% 基-2的ifft, 结果除以N，是通过调用结果不除以N的ifft实现的
function fft_x = Radix_2_IFFT(x)
% 对ifft的结果除以N
N_const = length(x);
fft_x = radix_2_ifft(x);
fft_x = fft_x./N_const;
end

% 辅助函数6-part2
% 基-2 的ifft, 不除以N, 要算完单独除以N
function fft_x = radix_2_ifft(x)
N = length(x);
if N == 1
    fft_x = x;
    return;
end
% 奇数项和偶数项
X_even = radix_2_ifft(x(1:2:N));  % 偶数项
X_odd = radix_2_ifft(x(2:2:N));  % 奇数项

% 旋转因子
W = exp(2*pi*1i/N * (0:N/2-1));
fft_x = [X_even + W .* X_odd, X_even - W .* X_odd];  % 合并结果
end