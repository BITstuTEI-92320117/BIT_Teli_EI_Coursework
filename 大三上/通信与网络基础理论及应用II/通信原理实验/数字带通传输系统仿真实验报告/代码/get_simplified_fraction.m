function [p, q] = get_simplified_fraction(x)
% 浮点数转最简分数函数
% 输入：x-浮点数
% 输出：p-分子, q-分母（最简正整数分数）

% 处理浮点数精度误差（四舍五入到6位小数）
x = round(x * 1e6) / 1e6;
% 调用rat函数将浮点数转为分数（误差<1e-6）
[n, d] = rat(x, 1e-6);
% 取绝对值，确保分子分母为正整数
p = abs(n);
q = abs(d);
% 避免分子分母为0
if p == 0
    p = 1;
end
if q == 0
    q = 1;
end
end