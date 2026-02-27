function [D, D_max] = funcD(E, Z0)
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
end