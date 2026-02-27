function pr=probibility(A)
% 求矩阵A像素值的分布概率
p=length(find(A))/numel(A);
p0=1-p;
pr=[p,p0];
end