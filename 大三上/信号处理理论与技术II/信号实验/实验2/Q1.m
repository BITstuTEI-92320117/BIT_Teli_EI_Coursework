% 清空环境，避免干扰
clear; clc; close all;

%% ==================== 系统①：H(z)=(1-z^(-1))/[(1-0.7z^(-1))(1+0.7z^(-1))] ====================
% 系数向量（z^(-1)升幂）：分子b1，分母a1
b1 = [1, -1];
a1 = [1, 0, -0.49];

% 绘制零极点分布图并保存
figure('Name','系统① 零极点分布图','Color','w');
zplane(b1, a1);
title('系统① 零极点分布图');
grid on;
saveas(gcf, '系统① 零极点分布图.png')

% 绘制冲激响应并保存
figure('Name','系统① 冲激响应','Color','w');
impz(b1, a1);
title('系统① 冲激响应');
grid on;
saveas(gcf, '系统① 冲激响应.png')

% 计算并绘制频率响应（幅频+相频），保存图像
figure('Name','系统① 频率响应','Color','w');
[H1, w1] = freqz(b1, a1);
subplot(2, 1, 1);
plot(w1/pi, abs(H1), 'b-', 'LineWidth',1.5);
xlabel('频率\Omega (\times\pi)');
ylabel('幅值 |H1(e^{j\Omega})|');
title('系统① 幅频响应');
grid on;
subplot(2, 1, 2);
plot(w1/pi, angle(H1), 'b-', 'LineWidth',1.5);
xlabel('频率\Omega (\times\pi)');
ylabel('相位 ∠H1(e^{j\Omega}) (rad)');
title('系统① 相频响应');
grid on;
saveas(gcf, '系统① 频率响应.png')

%% ==================== 系统②：H(z)=(z-1)/[(z-0.7)(z+0.7)] ====================
% 转换为z^(-1)升幂形式，系数向量：分子b2，分母a2（与系统①一致）
b2 = [0, 1, -1];
a2 = [1, 0, -0.49];

% 绘制零极点分布图并保存
figure('Name','系统② 零极点分布图','Color','w');
zplane(b2, a2);
title('系统② 零极点分布图');
grid on;
saveas(gcf, '系统② 零极点分布图.png')

% 绘制冲激响应并保存
figure('Name','系统② 冲激响应','Color','w');
impz(b2, a2);
title('系统② 冲激响应');
grid on;
saveas(gcf, '系统② 冲激响应.png')

% 计算并绘制频率响应（幅频+相频），保存图像
figure('Name','系统② 频率响应','Color','w');
[H2, w2] = freqz(b2, a2);
subplot(2, 1, 1);
plot(w2/pi, abs(H2), 'b-', 'LineWidth',1.5);
xlabel('频率\Omega (\times\pi)');
ylabel('幅值 |H2(e^{j\Omega})|');
title('系统② 幅频响应');
grid on;
subplot(2, 1, 2);
plot(w2/pi, angle(H2), 'b-', 'LineWidth',1.5);
xlabel('频率\Omega (\times\pi)');
ylabel('相位 ∠H2(e^{j\Omega}) (rad)');
title('系统② 相频响应');
grid on;
saveas(gcf, '系统② 频率响应.png')

%% ==================== 稳定性判断（因果系统：极点全在单位圆内则稳定） ====================
fprintf('==================== 稳定性分析 ====================\n');
% 系统①极点计算与判断
p1 = roots(a1);
fprintf('系统①的极点：\n');
disp(p1);
fprintf('系统①极点的模：\n');
disp(abs(p1));
stable1 = all(abs(p1) < 1);
if stable1
    stable1_str = '是';
else
    stable1_str = '否';
end
fprintf('系统①是否稳定：%s\n\n', stable1_str);

% 系统②极点计算与判断（分母同系统①，极点一致）
p2 = roots(a2);
fprintf('系统②的极点：\n');
disp(p2);
fprintf('系统②极点的模：\n');
disp(abs(p2));
stable2 = all(abs(p2) < 1);
if stable2
    stable2_str = '是';
else
    stable2_str = '否';
end
fprintf('系统②是否稳定：%s\n\n', stable2_str);

%% ==================== 系统①、②的异同分析 ====================
fprintf('==================== 系统①与②的异同分析 ====================\n');
fprintf('1. 系统是否相同？\n');
fprintf('   结论：不相同\n\n');
fprintf('2. 核心区别：\n');
fprintf('   (1) 系统函数：H2(z) = z^(-1)*H1(z)（系统②多单位延迟项）\n\n');
fprintf('   (2) 冲激响应：h2(n) = h1(n-1)（系统②延迟1个离散时间单位）\n\n');
fprintf('   (3) 频率响应：幅频一致，相频②多线性延迟相位-Ω\n\n');
fprintf('   (4) 物理意义：①无延迟响应，②存在1步单位延迟\n');