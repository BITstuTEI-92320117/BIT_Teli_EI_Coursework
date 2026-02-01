wn1 = 6;  % 设定自然频率为6 rad/s
ks1 = [0.1, 0.2, 0.707, 1.0, 2.0]; % 不同阻尼系数数组
warning off
figure(1)
hold on

% 循环生成不同阻尼系数的二阶系统
for i = 1:5
    num1 = wn1^2;
    den1 = [1, 2*wn1*ks1(i), wn1^2];
    G(i) = tf(num1, den1);
    step(G(i))
    title('固定ωn=6，变化ζ时的阶跃响应')
    xlabel('时间')
    ylabel('幅值')
    legend('ζ=0.1','ζ=0.2','ζ=0.707','ζ=1.0','ζ=2.0','Location','best')
    grid on
end
hold off


%% 第二部分：固定阻尼系数，变化自然频率
ks2 = 0.5;  % 设定阻尼系数为0.5
wn2 = [1, 3, 5]; % 不同自然频率数组

figure(2)
hold on

% 循环生成不同自然频率的二阶系统
for j = 1:3
    num2 = wn2(j)^2;
    den2 = [1, 2*wn2(j)*ks2, wn2(j)^2];
    T(j) = tf(num2, den2);
    step(T(j))
    title('固定ζ=0.5，变化ωn时的阶跃响应')
    xlabel('时间')
    ylabel('幅值')
    legend('ωn=1','ωn=3','ωn=5','Location','best')
    grid on
end
hold off


%% 第三部分：不同增益的三阶系统分析
k = [1.2, 2.25, 4];  % 不同增益值数组
den1 = [1, 0];
den2 = [0.5, 1];
den3 = [4, 1];

% 创建各子系统传递函数
N1 = tf(1, den1);
N2 = tf(1, den2);
N3 = tf(1, den3);

% 分析不同增益下的闭环系统
hold on
for n = 1:3
    figure(n+2)
    N = k(n) * N1 * N2 * N3;
    N = feedback(N, 1, -1);

    % 根据增益值调整仿真时间
    if n == 2
        step(N, 0:0.1:50)  % 中等增益使用更长时间仿真
    else
        step(N)  % 默认仿真时间
    end

    ylim([-3e27,3e27])
    title(['增益K=',num2str(k(n)),'时的闭环系统响应'])
    xlabel('时间')
    ylabel('幅值')
    grid on
end
hold off
