% %% 周期矩形脉冲参数
% T0 = 2;       % 周期
% tau = 0.5;    % 脉宽
% A = 1;        % 幅度
% N = 50;       % 叠加到前N次谐波（n=-N到N）
% 
% % 时间轴（三个周期内细化）
% t = linspace(-3*T0/2, 3*T0/2, 10000);  
% Omega0 = 2*pi/T0;  
% 
% % 初始化信号
% xN = zeros(size(t));  
% 
% for n = -N:N
%     % 计算傅里叶系数 Xn
%     Xn = (A*tau/T0) * sinc(n*tau/T0);  
%     % 叠加谐波分量
%     xN = xN + Xn * exp(1j*n*Omega0*t);  
% end
% 
% % 绘图
% figure(1);
% plot(t, real(xN), 'LineWidth', 1.2);  
% xlabel('Time/s'); ylabel('Amplitude');  
% title(['前50次谐波叠加']);  
% grid on;

%% 定义信号参数
T0 = 2;          
tau = 0.5;       
A = 1;         
N0 = 10;    

% 生成时域信号
dt = 0.002;                
t = -N0*T0/2:dt:N0*T0/2-dt; 
x = zeros(size(t));         

% 生成周期矩形脉冲信号
for k = -N0/2:N0/2
    start0 = k*T0 - tau/2;
    end0 = k*T0 + tau/2;
    x = x + A * (t >= start0 & t <= end0);
end

% 绘制时域波形
figure('Position', [100, 100, 1200, 800])
plot(t, x, 'LineWidth', 1.2);
xlabel('时间 t (s)');
ylabel('幅度');
title(['周期矩形脉冲信号（T_0 = 2' 's, τ = ' '0.5s）']);
grid on;

% 频域计算参数
w = -60*pi:120*pi/10240:60*pi-120*pi/10240;
X = x*exp(-1j*t'*w)*dt; 
 
% 绘制频谱
figure('Position', [100, 100, 1200, 800])
plot(w, abs(X), 'LineWidth', 1.5)
title('周期矩形脉冲信号的频谱幅度 |X(\omega)|')
xlabel('\omega/ (rad/s)')
ylabel('幅度')
grid on

% 分析T0和τ对频谱的影响
figure('Position', [100, 100, 1200, 800])

% 改变T0，保持τ不变
tau_fixed = 0.5;
T0_values = [1, 2, 4];
N0_values = [20, 10 ,5];
for i = 1:length(T0_values)
    T0 = T0_values(i);
    N0 = N0_values(i);

    % 生成时域信号
    t = -N0*T0/2:dt:N0*T0/2-dt;
    x = zeros(size(t));
    for k = -N0/2:N0/2
        start0 = k*T0 - tau_fixed/2;
        end0 = k*T0 + tau_fixed/2;
        x = x + A * (t >= start0 & t <= end0);
    end

    % 计算频谱
    X = x * exp(-1j*t'*w) * dt;

    % 绘制频谱
    subplot(2, length(T0_values), i)
    plot(w, abs(X), 'LineWidth', 1.5)
    title(['T_0 = ', num2str(T0), 's, \tau = ', num2str(tau_fixed), 's'])
    xlabel('\omega/ (rad/s)')
    ylabel('幅度')
    grid on
end

% 改变τ，保持T0不变
T0_fixed = 2;
tau_values = [0.25, 0.5, 1];
N0 = 10;
for i = 1:length(tau_values)
    tau = tau_values(i);

    % 生成时域信号
    t = -N0*T0_fixed/2:dt:N0*T0_fixed/2-dt;
    x = zeros(size(t));
    for k = -N0/2:N0/2
        start0 = k*T0_fixed - tau/2;
        end0 = k*T0_fixed + tau/2;
        x = x + A * (t >= start0 & t <= end0);
    end

    % 计算频谱
    X = x * exp(-1j*t'*w) * dt;

    % 绘制频谱
    subplot(2, length(tau_values), length(T0_values) + i)
    plot(w, abs(X), 'LineWidth', 1.5)
    title(['T_0 = ', num2str(T0_fixed), 's, \tau = ', num2str(tau), 's'])
    xlabel('\omega/ (rad/s)')
    ylabel('幅度')
    grid on
end
