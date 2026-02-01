function [Z, b]=MoM_Zb(a, k, Z0, N, dl_all, z, num, d)
%% 计算八木天线Z矩阵元素及b向量的值
% 为矩阵分配空间
Z = zeros(num*N, num*N);
b = zeros(num*N, 1);

% 循环计算Z和b
for m = N+1: 2*N
    zm = z(2, m-N);
    b(m, 1) = -1j * sin(k*abs(zm))/(2*Z0) ; % 只有馈电线对应的部分不为0
end

% 计算Z矩阵
for i = 1:num
    for j = 1:num
        if i == j  % 同一根天线
            for m = (i-1)*N+1: i*N
                zm = z(i,m-(i-1)*N);
                Z(m, (i-1)*N+1) = cos(k * zm); % 第一列
                dl = dl_all(i);
                r = sqrt(dl*dl + 4*a*a);
                Z_nn1 = 1/(4 * pi) * log((r+dl)/(r-dl));
                Z_nn2 = 1/(4 * pi) * 1j * k * dl;
                Z_nn3 = 1/(8 * pi) * (r*dl/2 + a*a*log((r+dl)/(r-dl))) * k*k/2;
                for n = (i-1)*N+2:i*N
                    if m == n               % 奇异点处理                     
                        Z(m, n) = Z_nn1 - Z_nn2 - Z_nn3;
                    else
                        r = sqrt((z(i,m-(i-1)*N) - z(i,n-(i-1)*N))^2 + a*a);
                        Z(m, n) = exp(-1j * k * r) * dl/(4 * pi * r);     % 计算矩阵元素
                    end
                end
            end
        else        % 两根天线之间耦合的部分
            dl = dl_all(j);
            for m = (i-1)*N+1: i*N
                Z(m, (j-1)*N+1) = 0;
                for n = (j-1)*N+2: j*N
                    r = sqrt((z(i,m-(i-1)*N) - z(j,n-(j-1)*N))^2 + (abs(d(i)-d(j)))^2);
                    Z(m, n) = exp(-1j * k * r) * dl/(4 * pi * r);
                end
            end
        end
    end
end
end