% 清空环境：工作区、命令行、图形窗口，避免干扰
clear; clc; close all;

%% ==================== 系统①：单零点z=-0.8，单极点p=0.8 ====================
% 系统函数：H(z)=(1+0.8z^(-1))/(1-0.8z^(-1))
% 系数（z^(-1)升幂）：分子b1，分母a1
b1 = [1, 0.8];
a1 = [1, -0.8];

% 1. 绘制零极点分布图并保存
figure('Name','系统① 零极点分布图','Color','w');
zplane(b1, a1, 'b-');
title('系统① 零极点分布图（z=-0.8, p=0.8）');
grid on;
saveas(gcf, '系统① 零极点分布图.png');

% 2. 绘制前30点冲激响应并保存
figure('Name','系统① 冲激响应','Color','w');
impz(b1, a1, 30);
title('系统① 冲激响应');
grid on;
saveas(gcf, '系统① 冲激响应.png');

% 3. 计算并绘制频率响应（幅频+相频），保存图像
figure('Name','系统① 频率响应','Color','w');
[H1, w1] = freqz(b1, a1);
subplot(2, 1, 1);
plot(w1/pi, abs(H1), 'b-', 'LineWidth',1.5);
xlabel('频率\Omega (\times\pi)');
ylabel('幅值 |H(e^{j\Omega})|');
title('系统① 幅频响应');
grid on;
subplot(2, 1, 2);
plot(w1/pi, angle(H1), 'b-', 'LineWidth',1.5);
xlabel('频率\Omega (\times\pi)');
ylabel('相位 ∠H(e^{j\Omega}) (rad)');
title('系统① 相频响应');
grid on;
saveas(gcf, '系统① 频率响应.png');

%% ==================== 系统②：单零点z=0.5，单极点p=-1.25 ====================
% 系统函数：H(z)=(1-0.5z^(-1))/(1+1.25z^(-1))
% 系数（z^(-1)升幂）：分子b2，分母a2
b2 = [1, -0.5];
a2 = [1, 1.25];

% 1. 零极点分布图
figure('Name','系统② 零极点分布图','Color','w');
zplane(b2, a2);
title('系统② 零极点分布图（z=0.5, p=-1.25）');
grid on;
saveas(gcf, '系统② 零极点分布图.png');

% 2. 冲激响应（前30点）
figure('Name','系统② 冲激响应','Color','w');
impz(b2, a2, 30);
title('系统② 冲激响应');
grid on;
saveas(gcf, '系统② 冲激响应.png');

% 3. 频率响应（幅频+相频）
figure('Name','系统② 频率响应','Color','w');
[H2, w2] = freqz(b2, a2);
subplot(2, 1, 1);
plot(w2/pi, abs(H2), 'b-', 'LineWidth',1.5);
xlabel('频率\Omega (\times\pi)');
ylabel('幅值 |H(e^{j\Omega})|');
title('系统② 幅频响应');
grid on;
subplot(2, 1, 2);
plot(w2/pi, angle(H2), 'b-', 'LineWidth',1.5);
xlabel('频率\Omega (\times\pi)');
ylabel('相位 ∠H(e^{j\Omega}) (rad)');
title('系统② 相频响应');
grid on;
saveas(gcf, '系统② 频率响应.png');

%% ==================== 系统③：零点z=0，共轭极点p=0.8e^(±jπ/3) ====================
% 系统函数：H(z)=1/[1-0.8z^(-1)+0.64z^(-2)]
% 系数（z^(-1)升幂）：分子b3（零点z=0），分母a3（共轭极点展开）
b3 = 1;
a3 = [1, -0.8, 0.64];

% 1. 零极点分布图
figure('Name','系统③ 零极点分布图','Color','w');
zplane(b3, a3);
title('系统③ 零极点分布图（z=0, p=0.8e^{±jπ/3}）');
grid on;
saveas(gcf, '系统③ 零极点分布图.png');

% 2. 冲激响应（前30点）
figure('Name','系统③ 冲激响应','Color','w');
impz(b3, a3, 30);
title('系统③ 冲激响应');
grid on;
saveas(gcf, '系统③ 冲激响应.png');

% 3. 频率响应（幅频+相频）
figure('Name','系统③ 频率响应','Color','w');
[H3, w3] = freqz(b3, a3);
subplot(2, 1, 1);
plot(w3/pi, abs(H3), 'b-', 'LineWidth',1.5);
xlabel('频率\Omega (\times\pi)');
ylabel('幅值 |H(e^{j\Omega})|');
title('系统③ 幅频响应');
grid on;
subplot(2, 1, 2);
plot(w3/pi, angle(H3), 'b-', 'LineWidth',1.5);
xlabel('频率\Omega (\times\pi)');
ylabel('相位 ∠H(e^{j\Omega}) (rad)');
title('系统③ 相频响应');
grid on;
saveas(gcf, '系统③ 频率响应.png');

%% ==================== 系统④：共轭零点z=e^(±jπ/3)，共轭极点p=-0.8e^(±jπ/4) ====================
% 系统函数：H(z)=(1-z^(-1)+z^(-2))/[1+1.1314z^(-1)+0.64z^(-2)]
% 系数（z^(-1)升幂）：分子b4（共轭零点展开），分母a4（共轭极点展开）
b4 = [1, -2*cos(pi/3), 1];
a4 = [1, 2*0.8*cos(pi/4), 0.64];

% 1. 零极点分布图
figure('Name','系统④ 零极点分布图','Color','w');
zplane(b4, a4);
title('系统④ 零极点分布图（z=e^{±jπ/3}, p=-0.8e^{±jπ/4}）');
grid on;
saveas(gcf, '系统④ 零极点分布图.png');

% 2. 冲激响应（前30点）
figure('Name','系统④ 冲激响应','Color','w');
impz(b4, a4, 30);
title('系统④ 冲激响应');
grid on;
saveas(gcf, '系统④ 冲激响应.png');

% 3. 频率响应（幅频+相频）
figure('Name','系统④ 频率响应','Color','w');
[H4, w4] = freqz(b4, a4);
subplot(2, 1, 1);
plot(w4/pi, abs(H4), 'b-', 'LineWidth',1.5);
xlabel('频率\Omega (\times\pi)');
ylabel('幅值 |H(e^{j\Omega})|');
title('系统④ 幅频响应');
grid on;
subplot(2, 1, 2);
plot(w4/pi, angle(H4), 'b-', 'LineWidth',1.5);
xlabel('频率\Omega (\times\pi)');
ylabel('相位 ∠H(e^{j\Omega}) (rad)');
title('系统④ 相频响应');
grid on;
saveas(gcf, '系统④ 频率响应.png');

%% ==================== 新系统1：验证极点幅度对幅频峰值的影响（对照系统③） ====================
% 控制变量：极点相位π/3、零点z=0不变，仅改极点幅度（0.9/0.5）
b1a = 1;  % 零点z=0，分子系数
a1a = [1, -0.9, 0.81];  % 极点幅度0.9，共轭展开系数
b1b = [1];
a1b = [1, -0.5, 0.25];  % 极点幅度0.5，共轭展开系数

% 幅频响应对比绘制
figure('Name','极点幅度对幅频响应峰值尖锐度的影响','Color','w');
[H1a, w1a] = freqz(b1a, a1a);
subplot(2,1,1);
plot(w1a/pi, abs(H1a), 'b-', 'LineWidth',1.5);
xlabel('频率\Omega (\times\pi)');
ylabel('幅值 |H(e^{j\Omega})|');
title('极点幅度0.9，相位π/3');
grid on;

[H1b, w1b] = freqz(b1b, a1b);
subplot(2,1,2);
plot(w1b/pi, abs(H1b), 'b-', 'LineWidth',1.5);
xlabel('频率\Omega (\times\pi)');
ylabel('幅值 |H(e^{j\Omega})|');
title('极点幅度0.5，相位π/3');
grid on;
saveas(gcf, '极点幅度对幅频响应峰值尖锐度的影响.png');

%% ==================== 新系统2：验证零点幅度对幅频谷值的影响（对照系统④） ====================
% 控制变量：零点相位π/3、极点参数不变，仅改零点幅度（0.95/0.4）
a2a = [1, -0.8];
a2b = a2a;  % 极点系数保持一致
b2a = [1, -2*0.9*cos(pi/4), 0.81];  % 零点幅度0.9，共轭展开系数
b2b = [1, -2*0.5*cos(pi/4), 0.25];  % 零点幅度0.5，共轭展开系数

% 幅频响应对比绘制
figure('Name','零点幅度对幅频响应谷值的影响','Color','w');
[H2a, w2a] = freqz(b2a, a2a);
subplot(2,1,1);
plot(w2a/pi, abs(H2a), 'b-', 'LineWidth',1.5);
xlabel('频率\Omega (\times\pi)');
ylabel('幅值 |H(e^{j\Omega})|');
title('零点幅度0.9，相位π/4');
grid on;

[H2b, w2b] = freqz(b2b, a2b);
subplot(2,1,2);
plot(w2b/pi, abs(H2b), 'b-', 'LineWidth',1.5);
xlabel('频率\Omega (\times\pi)');
ylabel('幅值 |H(e^{j\Omega})|');
title('零点幅度0.5，相位π/4');
grid on;
saveas(gcf, '零点幅度对幅频响应谷值的影响.png');

%% ==================== 新系统3：验证零极点相角相对位置的影响（对照系统④） ====================
% 控制变量：零极点幅度不变，仅改相角相对位置（接近/远离）
b3a = [1, -2*cos(pi/3), 1];  % 零点系数（相位π/3）
b3b = b3a;
a3a = [1, -2*0.8*cos(pi/4), 0.64];  % 极点相位π/4（相角接近）
a3b = [1, -2*0.8*cos(3*pi/4), 0.64];  % 极点相位3π/4（相角远离）

% 幅频响应对比绘制
figure('Name','零极点相角相对位置对幅频响应的影响','Color','w');
[H3a, w3a] = freqz(b3a, a3a);
subplot(2,1,1);
plot(w3a/pi, abs(H3a), 'b-', 'LineWidth',1.5);
xlabel('频率\Omega (\times\pi)');
ylabel('幅值 |H(e^{j\Omega})|');
title('相角接近(π/3 vs π/4)');
grid on;

[H3b, w3b] = freqz(b3b, a3b);
subplot(2,1,2);
plot(w3b/pi, abs(H3b), 'b-', 'LineWidth',1.5);
xlabel('频率\Omega (\times\pi)');
ylabel('幅值 |H(e^{j\Omega})|');
title('相角远离(π/3 vs 3π/4)');
grid on;
saveas(gcf, '零极点相角相对位置对幅频响应的影响.png');

%% ==================== 稳定性判断（因果系统：极点全在单位圆内则稳定） ====================
fprintf('==================== 4个系统的稳定性分析 ====================\n');

% 系统①稳定性
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

% 系统②稳定性
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

% 系统③稳定性
p3 = roots(a3);
fprintf('系统③的极点：\n');
disp(p3);
fprintf('系统③极点的模：\n');
disp(abs(p3));
stable3 = all(abs(p3) < 1);
if stable3
    stable3_str = '是';
else
    stable3_str = '否';
end
fprintf('系统③是否稳定：%s\n\n', stable3_str);

% 系统④稳定性
p4 = roots(a4);
fprintf('系统④的极点：\n');
disp(p4);
fprintf('系统④极点的模：\n');
disp(abs(p4));
stable4 = all(abs(p4) < 1);
if stable4
    stable4_str = '是';
else
    stable4_str = '否';
end
fprintf('系统④是否稳定：%s\n\n', stable4_str);

%% ==================== 零极点位置对系统频率特性的影响分析 ====================
fprintf('==================== 零极点位置对频率特性的影响分析 ====================\n');
fprintf('1. 极点位置的影响：\n');
fprintf('   (1) 极点幅度r（模）：\n');
fprintf('       - r越接近1（靠近单位圆）：幅频响应在对应频率处的峰值越尖锐（选频特性越强）；\n');
fprintf('       - r越小（远离单位圆）：峰值越平缓（系统响应越慢）；\n');
fprintf('       - r>1（单位圆外）：系统不稳定，频率响应无实际物理意义（如系统②，p=-1.25，r=1.25>1）。\n');
fprintf('   (2) 极点相角θ：\n');
fprintf('       - 极点相角θ决定幅频峰值的"目标频率"：Ω=θ时，极点对频率响应的贡献最大，峰值最显著；\n');
fprintf('       - 共轭极点（θ和-θ）：幅频特性对称，无额外相位失真（如系统③、④的共轭极点）。\n');
fprintf('\n');
fprintf('2. 零点位置的影响：\n');
fprintf('   (1) 零点幅度r（模）：\n');
fprintf('       - r越接近1（靠近单位圆）：幅频响应在对应频率处的谷值越深（抑制该频率信号）；\n');
fprintf('       - r越小（远离单位圆）：谷值越平缓（对频率抑制作用减弱）；\n');
fprintf('       - r=0（原点零点）：对幅频响应无影响（|1-0·e^{-jΩ}|=1），仅影响相频（如系统③）。\n');
fprintf('   (2) 零点相角θ：\n');
fprintf('       - 零点相角θ决定幅频谷值的"目标频率"：Ω=θ时，零点对频率响应的抑制作用最强；\n');
fprintf('       - 共轭零点（θ和-θ）：幅频特性对称，相频响应线性度更好（如系统④的共轭零点）。\n');
fprintf('\n');
fprintf('3. 零极点的联合影响：\n');
fprintf('   - 若零点与极点的相角接近：零点会削弱极点对应的峰值（抵消部分选频作用）；\n');
fprintf('   - 若零点与极点的相角远离：两者作用独立，分别形成谷值和峰值；\n');
fprintf('   - 共轭零/极点组合：可构建对称的幅频特性，避免单边频率失真，常用于滤波器设计。\n');