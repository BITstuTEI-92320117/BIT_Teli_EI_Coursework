% 仿真参数设置  
t = 0:0.01:10;  
u = ones(size(t));   
x0 = [0; 1];       
x0_hat = [0; 0]; % 观测器初始状态（可任意选）

A = [0 1; -3 -4];
B = [0; 1];
C = [2 0];
D = 0; % 原系统直接传递项

% 构建原系统状态空间模型
sys_plant = ss(A, B, C, D);

% 仿真原系统响应，得到输出y和状态x
[y_plant, t, x_plant] = lsim(sys_plant, u, t, x0);  

% 期望观测器极点：-12 ± j
des_poles_obs = [-12 + 1j, -12 - 1j];

% 利用对偶原理计算观测器增益（系统能观测，可任意配置极点）
L = place(A', C', des_poles_obs)'; % 计算得L = [10; 31]（原代码中L(2)=21错误）

% 观测器状态方程
A_obs = A - L * C;
B_obs = [B L]; % 输入为[u; y]，故输入矩阵包含B（对应u）和L（对应y）

% 构建观测器状态空间模型（输出为观测器状态$\hat{x}$）
sys_obs = ss(A_obs, B_obs, eye(2), zeros(2, 2));

% 步骤1：将u转为列向量（与y_plant维度统一为N×1）
u_col = u'; % 1×1001 转 1001×1

% 步骤2：按列拼接构建观测器输入（lsim要求：每列一个输入通道，每行一个时间点）
% 最终u_obs为1001×2矩阵，第1列=u，第2列=y_plant，匹配观测器2个输入通道
u_obs = [u_col, y_plant];

% 仿真观测器响应（输入u_obs为N×2矩阵，匹配sys_obs的2个输入通道）
[x_hat, t, ~] = lsim(sys_obs, u_obs, t, x0_hat);  

% 第一幅图：单独显示原系统状态  
figure;  
% 子图1：x1状态  
subplot(2,1,1);  
plot(t, x_plant(:,1), 'b-', 'LineWidth', 2);    
title('原系统状态x1');  
xlabel('时间t/s');  
ylabel('状态值');  
legend('x1');    
grid on;  
 
% 子图2：x2状态  
subplot(2,1,2);  
plot(t, x_plant(:,2), 'b-', 'LineWidth', 2);    
title('原系统状态x2');  
xlabel('时间t/s');  
ylabel('状态值');  
legend('x2');   
grid on;  
  
% 第二幅图：对比原系统状态与观测器估计  
figure;  
% 子图1：x1与x1估计对比  
subplot(2,1,1);  
plot(t, x_plant(:,1), 'b-', 'LineWidth', 2);    
hold on;  
plot(t, x_hat(:,1), 'r--', 'LineWidth', 2);   
title('状态x1与观测器估计x1对比');   
xlabel('时间t/s');  
ylabel('状态值');  
legend('x1', 'x1估计');    
grid on;  
  
% 子图2：x2与x2估计对比  
subplot(2,1,2);  
plot(t, x_plant(:,2), 'b-', 'LineWidth', 2);    
hold on;  
plot(t, x_hat(:,2), 'r--', 'LineWidth', 2);   
title('状态x2与观测器估计x2对比');    
xlabel('时间t/s');  
ylabel('状态值');  
legend('x2', 'x2估计');   
grid on;  