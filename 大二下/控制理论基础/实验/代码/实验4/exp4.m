% 系统参数
K = 1; % 初始增益
num = K;
den = [1, 2, 4]; % s^2 + 2s + 4

% 1. 满足稳态误差要求
K_req = 36;
sys_uncorrected = tf(K_req, den);

% 2. 检查未校正系统的相位裕度
[Gm_uncorr, Pm_uncorr] = margin(sys_uncorrected);
fprintf('未校正系统相位裕度: %.2f°\n', Pm_uncorr);

% 3. 设计超前校正器（满足相位裕度45°）
% 目标相位裕度
Pm_desired = 45;

% 计算需要增加的相位超前量
phi_m = (Pm_desired - Pm_uncorr) + 10; % 增加10°补偿量
phi_m_rad = deg2rad(phi_m);

% 计算超前校正器的参数
alpha = (1 + sin(phi_m_rad))/(1 - sin(phi_m_rad));

% 找到未校正系统增益为-10log10(alpha)的频率
[mag, phase, w] = bode(sys_uncorrected);
mag_db = 20*log10(squeeze(mag));
gain_target = -10*log10(alpha);
w_c = interp1(mag_db, w, gain_target, 'spline');

% 计算时间常数
T = 1/(w_c*sqrt(alpha));

% 创建超前校正器
num_lead = [alpha*T, 1];
den_lead = [T, 1];
lead_compensator = tf(num_lead, den_lead);

% 4. 校正后系统
sys_corrected = series(lead_compensator, sys_uncorrected);

% 5. 验证校正后系统性能
[Gm_corr, Pm_corr] = margin(sys_corrected);
fprintf('校正后系统相位裕度: %.2f°\n', Pm_corr);

% 6. 绘制Bode图
figure('Position', [100, 100, 1000, 800]);

% 未校正系统Bode图
subplot(2,1,1);
hold on
margin(sys_uncorrected);
grid on;

% 校正后系统Bode图
margin(sys_corrected);
grid on;
title('Bode图');
legend('未校正系统', '校正后系统');
hold off

% 7. 绘制单位阶跃响应
subplot(2,1,2);
hold on;

% 未校正系统闭环阶跃响应
sys_cl_uncorr = feedback(sys_uncorrected, 1);
step(sys_cl_uncorr);

% 校正后系统闭环阶跃响应
sys_cl_corr = feedback(sys_corrected, 1);
step(sys_cl_corr);

grid on;
title('单位阶跃响应');
legend('未校正系统', '校正后系统');
xlim([0, 5]);

% 8. 显示控制器参数
fprintf('\n超前校正器设计:\n');
fprintf('传递函数: Gc(s) = %.4f * (%.4fs + 1)/(%.4fs + 1)\n', ...
    alpha, alpha*T, T);
fprintf('参数: alpha = %.4f, T = %.4f\n', alpha, T);

% 9. 分析校正效果
fprintf('相位裕度从 %.2f° 提高到 %.2f°\n', Pm_uncorr, Pm_corr);
