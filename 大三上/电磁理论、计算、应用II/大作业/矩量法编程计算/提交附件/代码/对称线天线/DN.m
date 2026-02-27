function A = DN(A)
%% 对数据做归一化
[m, n] = size(A);
max_A = max(max(A));
min_A = min(min(A));
for i = 1:m
    for j = 1:n
        % 最大值最小值归一
        A(i, j) = (A(i, j) - min_A) / (max_A - min_A);
    end
end
end