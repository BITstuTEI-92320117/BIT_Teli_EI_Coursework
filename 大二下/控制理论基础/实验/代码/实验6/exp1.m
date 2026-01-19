%% 计算系统特征值
A = [-2,-1,1;1,0,1;-1,0,1];
B = [1;1;1];
eig_orig = eig(A);
fprintf('系统特征值: %.2f, %.2f, %.2f\n', eig_orig);
% 稳定性判断
if all(real(eig_orig) < 0)
    disp('系统稳定（所有特征值实部为负）');
else
    disp('系统不稳定（存在特征值实部非负）');
end

%% 极点配置设计（期望极点：-1, -2, -3）
desired_poles = [-1, -2, -3];
% 计算状态反馈矩阵K
K = place(A, B, desired_poles);
fprintf('状态反馈矩阵 K = [%.4f, %.4f, %.4f]\n', K);
