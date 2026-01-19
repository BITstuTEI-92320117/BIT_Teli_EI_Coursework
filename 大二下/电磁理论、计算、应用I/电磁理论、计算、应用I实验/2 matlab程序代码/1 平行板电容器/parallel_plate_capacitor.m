clear;
% 求解区间[a,b]
a = 0;
b = 1;

% 将求解区间均匀地分成n个小段
n = 6;
h = (b - a) / n;

Q = a:h:b;% 存全局坐标
K = zeros(n+1,n+1);% 最后整个的大K矩阵
B = zeros(n+1,1);% 最后整个的B矩阵

% 算矩阵
syms x
for m = 1:n
    J = [Q(m),Q(m+1)];% 局部坐标
    N = {@(x) (J(2)-x)/(J(2)-J(1)),@(x) (x-J(1))/(J(2)-J(1))};% N1和N2
    for i = 1:2
        for j = 1:2
            k(i,j) = int(diff(N{i},x)*...
                         diff(N{j},x),x,J(1),J(2));%计算小矩阵kij
            K(m+i-1,m+j-1) = K(m+i-1,m+j-1)+k(i,j);% 直接把小矩阵往大矩阵上加   
        end
        b1(i,1) = int((x+1)*N{i},x,J(1),J(2));% 计算b
        B(m+i-1,1) = B(m+i-1,1)-b1(i);% 直接把小矩阵往大矩阵上加   
    end
end

% 边界条件
B(1) = 0;
B(n+1) = 1;
K(1,:) = 0;
K(1,1) = 1;
K(n+1,:) = 0;
K(n+1,n+1) = 1;

S = linsolve(K,B);  % 求解

% 绘制图像
plot(Q,S,'linewidth',2);    % 绘制数值解
y = 1/6*x^3+0.5*x^2+1/3*x;  % 精确解方程
hold on;
fplot(x,y,[0,1],'--','linewidth',2);    % 绘精确值解
xlabel('x(m)');      % x轴标签
ylabel('φ(V)');     % y轴标签
ylim([0,1]);         % y轴范围
title('一维平行板电容器电势求解');
legend('数值解','精确解');