%% 矢量计算方法
% 参数设置
T0 = 2;            
tau = 0.5;          
Fs = 1000;      
T = 1/Fs;           
t_total = 10*T0;   
t = -t_total/2 : T : t_total/2 - T;
N = length(t);     

% 生成周期矩形脉冲信号
x = zeros(size(t));
for n = -round(t_total/(2*T0)) : round(t_total/(2*T0))
    x = x + (abs(t - n*T0) < tau/2); 
end

% 确定主值区间
t1 = min(t);        
t2 = max(t);        
T_data = t2 - t1;

% 频率参数设置
f_center = 0;      
f_span = Fs;       
K = N;             
df = f_span/N;    

% 构建对称频率轴
f = f_center - f_span/2 : df : f_center + f_span/2 - df;

% 矢量计算方法 - 傅里叶变换
tic
X_vec = zeros(1, K); 

% 预计算时间序列
time_series = t1 + (0:N-1)*T;  % t1, t1+Δt, ..., t1+(N-1)Δt

% 计算DTFT
for k = 1:K
    current_freq = f(k); 
    
    exponent = -1i * 2*pi * current_freq * time_series;
    exp_term = exp(exponent);
    
    X_vec(k) = sum(x .* exp_term) * T; 
end
toc

% 矢量计算方法 - 逆傅里叶变换
tic
x_vec_ifft = zeros(1, N); 

% 预计算频率序列
freq_series = f;  

% 计算IDTFT
for n = 1:N
    current_time = t1 + (n-1)*T;  % 当前时间点
    exponent = 1i * 2*pi * freq_series * current_time;
    exp_term = exp(exponent);
    x_vec_ifft(n) = sum(X_vec .* exp_term) * df;  % 乘以频率间隔df
end
x_vec_ifft = real(x_vec_ifft); 
toc

% 绘图显示
figure;
subplot(3,1,1);
plot(t, x);
title('原始周期矩形脉冲');
xlabel('时间 (s)');
ylabel('幅度');
grid on;

subplot(3,1,2);
plot(f, abs(X_vec));
title('矢量计算 - 傅里叶变换幅度谱');
xlabel('频率 (Hz)');
ylabel('|X(f)|');
grid on;

subplot(3,1,3);
plot(t, x_vec_ifft);
title('矢量计算 - 逆傅里叶变换恢复信号');
xlabel('时间 (s)');
ylabel('幅度');
grid on;

%% 矩阵计算方法
% 矩阵计算方法 - 傅里叶变换
tic
% 构建时间矩阵（N行K列）
t_matrix = ones(K, 1) * time_series;

% 构建频率矩阵（N行K列）
f_matrix = freq_series' * ones(1, N); 

% 构建指数矩阵 U
exponent_matrix = -1i * 2*pi * f_matrix .* t_matrix;
U = exp(exponent_matrix);

% 计算傅里叶变换
X_mat = x * U * T;  
toc

% 矩阵计算方法 - 逆傅里叶变换
tic
% 构建逆变换指数矩阵
U_inv = exp(1i * 2*pi * f_matrix .* t_matrix);

% 计算逆傅里叶变换
x_mat_ifft = X_mat * U_inv * df;  
x_mat_ifft = real(x_mat_ifft);
toc

% 绘图显示
figure;
subplot(3, 1, 1);
plot(t, x);
title('周期矩形脉冲信号');
xlabel('时间 (s)');
ylabel('幅度');
grid on;

subplot(3, 1, 2);
plot(f, abs(X_mat));
title('矩阵计算 - 傅里叶变换幅度谱');
xlabel('频率 (Hz)');
ylabel('|X(f)|');
grid on;

subplot(3, 1, 3);
plot(t, x_mat_ifft);
title('矩阵计算 - 逆傅里叶变换恢复信号');
xlabel('时间 (s)');
ylabel('幅度');
grid on;
