function [Z, b] = MoM_Zb(a,k,Z0,N,dl,z)
%% 计算线天线Z矩阵元素及b向量的值
% 初始化
Z = zeros(N, N);
b = zeros(N, 1);

% 奇异点处理
r_nn = sqrt(dl*dl + 4*a*a);
Z_nn1 = 1/(4 * pi) * log((r_nn+dl)/(r_nn-dl));
Z_nn2 = 1/(4 * pi) * 1j * k * dl;
Z_nn3 = 1/(8 * pi) * (r_nn*dl/2 + a*a*log( (r_nn+dl) / (r_nn-dl) ) ) * k*k/2;

% 循环计算Z和b
for m = 1: N
    b(m, 1) = -1j * sin(k * abs(z(m)))/(2 * Z0); % 计算b向量
    Z(m, 1) = -cos(k*z(m)); % 计算Z矩阵第一列
    for n = 2:N % 计算Z矩阵其余列
        % 源点场点相距较近
        if m == n
            Z(m, n) = Z_nn1 - Z_nn2 - Z_nn3;
            % 源点场点相距较远
        else
            r = sqrt((z(n) - z(m))^2 + a*a);
            Z(m, n) = exp(-1j * k * r) * dl/(4 * pi * r);
        end
    end
end
end