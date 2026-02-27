%% （1）绘制系统的根轨迹图
% 定义开环传递函数 G(s) = K/[s(s^2 + 4s + 5)]
num = 1;
den = conv([1 0], [1 4 5]);

G = tf(num, den);

% 绘制根轨迹图
figure(1)
rlocus(G)
title('系统根轨迹图 G(s)=K/[s(s^2+4s+5)]')
grid on

%% 验证不同K值的阶跃响应
K_values = [10 20 30];  % 分别选择稳定、临界稳定和不稳定的K值

for i = 1:length(K_values)
    K = K_values(i);
    G_closed = feedback(K*G, 1);

    figure(i+1)
    step(G_closed, 10)  % 仿真10秒
    title(sprintf('阶跃响应 (K=%d)', K))
    grid on

end
%% 专门验证无超调情况
for K_no_overshoot = 5:6
    figure(K_no_overshoot)
    G_closed_no_overshoot = feedback(K_no_overshoot*G, 1);

    step(G_closed_no_overshoot, 10)
    title(sprintf('无超调验证 (K=%.1f)', K_no_overshoot))
    grid on
end
