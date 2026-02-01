function [D, D_max] = funcD(E, Z0, flag, l ,N)
%% 计算方向性系数
% 离散化处理
[m,n] = size(E);
theta = linspace(0, pi, m);
dtheta = pi / m;        
dphi = 2 * pi / n;    

% 数值积分计算平均功率
H = E / Z0;  
Sav = E .* conj(H) *0.5;  
Pr = sum(sum(Sav .* sin(theta')*dtheta) * dphi) / (4*pi) ;    

% 计算方向性
D = abs(Sav / Pr);
D_max = max(max(D));
if flag == 1
    fname1 = sprintf('方向性(l=%gm,N=%d).xlsx', l, N);
    writematrix(D,fname1);
    fname2 = sprintf('方向性系数(l=%gm,N=%d).xlsx', l, N);
    writematrix(D_max,fname2);
end
end