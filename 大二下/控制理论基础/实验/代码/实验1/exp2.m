% 定义状态空间模型的矩阵
A = [0, 1, 0, 0;
    0, 0, 1, 0;
    0, 0, 0, 1;
    -1, -2, -3, -4];

B = [0; 0; 0; 1];
C = [10, 2, 0, 0];
D = 0;

% 创建状态空间对象
Gss = ss(A, B, C, D)

% 转换为零极点增益形式
Gzpk = zpk(Gss)

% 绘制零极点图
figure;
pzmap(Gzpk);
title('系统零极点分布图');
xlabel('实轴');
ylabel('虚轴');
grid on;

% 转换为传递函数形式
Gtf = tf(Gzpk)
