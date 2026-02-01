function Computational_accuracy(l, a, Z0, k, r, M)
%% 分析匹配点个数对计算精度的影响
% 线域网格离散
N_start = 11;
N_end = 1001;
N_num = (N_end - N_start) / 10 + 1;
N = N_start:10:N_end; % 匹配点个数
flag = 2;
Z_real = zeros(1,N_num);
Z_imag = zeros(1,N_num);
D_max = zeros(1,N_num);
HPBW = zeros(1,N_num);
for i = 1:N_num
    N0 = N(i);
    dl = 2 * l/(N0 - 1);
    zb = -l:dl:l;

    % 利用矩量法计算电流
    [Z, b] = MoM_Zb(a, k, Z0, N0 ,dl, zb);
    I_MOM = MoM_I(Z, b, zb, l, N0, flag);

    % 计算输入电阻和电抗
    Zin = MoM_Zin(I_MOM, N0, l, flag);
    Z_real(i) = real(Zin);
    Z_imag(i) = imag(Zin);

    % 计算方向性系数
    [E_MOM, ~]= funcE(r, zb, I_MOM, a, dl, k, Z0, N0, l, M, flag);
    [D_MOM, D_max(i)] = funcD(E_MOM, Z0, flag, l, N0);

    % 计算半功率波瓣宽度
    HPBW(i) = Direction_map_2D_HPBW(D_MOM, l, N0, flag);
end
% 作图分析
figure(10)
plot(N, Z_real, 'LineWidth', 1.5, 'Marker', 'o', ...
    'MarkerSize', 4, 'MarkerEdgeColor', 'none');
grid on;
title('线天线输入电阻随匹配点个数变化图','FontSize', 12);
xlabel('匹配点个数N', 'FontSize', 11);
ylabel('输入电阻R/Ω', 'FontSize', 11, 'Rotation', 90);
legend('线天线输入电阻', 'FontSize', 10);
xlim([N_start,N_end])
ylim([0,140])
set(gcf, 'Color', 'white');
set(gca, 'Color', [0.98, 0.98, 0.98]);
saveas(gcf,'线天线输入电阻随匹配点个数变化图.png')

figure(11)
plot(N, Z_imag, 'LineWidth', 1.5, 'Marker', 'o', ...
    'MarkerSize', 4, 'MarkerEdgeColor', 'none');
grid on;
title('线天线输入电抗随匹配点个数变化图','FontSize', 12);
xlabel('匹配点个数N', 'FontSize', 11);
ylabel('输入电抗X/Ω', 'FontSize', 11, 'Rotation', 90);
legend('线天线输入电抗', 'FontSize', 10);
xlim([N_start,N_end])
ylim([-60,80])
set(gcf, 'Color', 'white');
set(gca, 'Color', [0.98, 0.98, 0.98]);
saveas(gcf,'线天线输入电抗随匹配点个数变化图.png')

figure(12)
plot(N, D_max, 'LineWidth', 1.5, 'Marker', 'o', ...
    'MarkerSize', 4, 'MarkerEdgeColor', 'none');
grid on;
title('线天线方向性系数随匹配点个数变化图','FontSize', 12);
xlabel('匹配点个数N', 'FontSize', 11);
ylabel('方向性系数D_max', 'FontSize', 11, 'Rotation', 90);
legend('方向性系数', 'Location', 'southeast', 'FontSize', 10);
xlim([N_start,N_end])
ylim([0,1.8])
set(gcf, 'Color', 'white');
set(gca, 'Color', [0.98, 0.98, 0.98]);
saveas(gcf,'线天线方向性系数随匹配点个数变化图.png')

figure(13)
plot(N, HPBW, 'LineWidth', 1.5, 'Marker', 'o', ...
    'MarkerSize', 4, 'MarkerEdgeColor', 'none');
grid on;
title('线天线半功率波瓣宽度随匹配点个数变化图','FontSize', 12);
xlabel('匹配点个数N', 'FontSize', 11);
ylabel('半功率波瓣宽度HPBW', 'FontSize', 11, 'Rotation', 90);
legend('半功率波瓣宽度', 'FontSize', 10);
xlim([N_start,N_end])
ylim([0,100])
set(gcf, 'Color', 'white');
set(gca, 'Color', [0.98, 0.98, 0.98]);
saveas(gcf,'线天线半功率波瓣宽度随匹配点个数变化图.png')
end