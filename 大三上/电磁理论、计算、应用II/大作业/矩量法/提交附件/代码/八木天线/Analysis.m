clear,clc;
%% 矩量法分析八木天线
% 定义参数
flag = 7;           % 用于选择模式的标志变量
lr = 0.3;           % 反射器长度(对照组lr=0.3)
lr0 = 0.01:0.01:1;
ls = 0.25;          % 有源振子长度(对照组ls=0.25)
ls0 = 0.01:0.01:1;
ld = 0.225;         % 引向器长度(对照组ld=0.225)
ld0 = 0.005:0.005:1;
ld_num = 3;         % 引向器个数(对照组ld_num=3)
ld_num0 = 1:10;
dr = 0.25;          % 反射器与有源阵子间距(对照组dr=0.25)
dr0 = 0.01:0.01:1;
ds = 0.25;          % 引向器间距(对照组ds=0.25)
ds0 = 0.01:0.01:1;
N = 101;             % 匹配点个数 101
N0 = 11:10:1001;
M = 360;            % 电场离散程度 360
r = 100;            % 场点半径
a = 0.001;
f = 3.0e8;
c = 3.0e8;
k = 2 * pi * f / c;
Z0 = 120 * pi;
flag2 = 0;
if flag == 3
    num = 200;
elseif flag == 4
    num = 10;
else
    num = 100;
end
D_max_MOM = zeros(1,num);
Z_real = zeros(1,num);
Z_imag = zeros(1,num);

% 循环分析
for i = 1:num
    if flag == 1 % 为每次循环相应参数赋值
        lr = lr0(i);
    elseif flag == 2
        ls = ls0(i);
    elseif flag == 3
        ld = ld0(i);
    elseif flag == 4
        ld_num = ld_num0(i);
    elseif flag == 5
        dr = dr0(i);
    elseif flag == 6
        ds = ds0(i);
    elseif flag == 7
        ds = ds0(i);
        dr = dr0(i);
    else
        N = N0(i);
    end
    l = [lr, ls, ld*ones(1,ld_num)];           % 天线一半的长度
    l_num = length(l);
    M = 360;
    d = [dr, repmat(ds, 1, l_num-1).*(1:l_num-1)+dr]; % 所有天线相对于第一根天线的距离
    flag1 = 0;

    % 线域网格离散

    dl = 2 * l/(N - 1);
    % 确定每根天线的匹配点
    zb = zeros(l_num, N);
    for j = 1: l_num
        zb(j,:) = -l(j):dl(j):l(j);
    end

    % 计算矩阵元素
    [Z, b] = MoM_Zb(a, k, Z0, N ,dl, zb, l_num, d);

    % 利用矩量法计算线天线电流，并绘制电流分布
    flag2 = 0;
    I_MOM = MoM_I(Z, b, zb, N, l_num, flag2, l);

    % 计算输入阻抗
    Zin = MoM_Zin(I_MOM(2,:), N);
    Z_real(i) = real(Zin);
    Z_imag(i) = imag(Zin);

    % 计算电场分布(φ=90平面)
    E_MOM = funcE(r, zb, I_MOM, a, dl, k, Z0, N, l_num, M, d);

    % 计算方向性系数
    [D_MOM, D_max_MOM(i)] = funcD(E_MOM, Z0);
end
figure(6)
if flag == 1 % 为每次循环相应参数赋值
    plot(lr0, D_max_MOM, 'LineWidth', 1.5, 'Marker', 'o', ...
        'MarkerSize', 4, 'MarkerEdgeColor', 'none');
    title('八木天线方向性系数随反射器长度变化图','FontSize', 12);
    xlabel('反射器长度lr/m', 'FontSize', 11);
    ylabel('方向性系数', 'FontSize', 11, 'Rotation', 90);
    grid on;
    xlim([0.01, 1])
    set(gcf, 'Color', 'white');
    set(gca, 'Color', [0.98, 0.98, 0.98]);
    saveas(gcf,'八木天线方向性系数随反射器长度变化图.png')
    writematrix(D_max_MOM','八木天线方向性系数随反射器长度变化值.xlsx','Range','A1:A100');
elseif flag == 2
    plot(ls0, D_max_MOM, 'LineWidth', 1.5, 'Marker', 'o', ...
        'MarkerSize', 4, 'MarkerEdgeColor', 'none');
    title('八木天线方向性系数随有源振子长度变化图','FontSize', 12);
    xlabel('有源振子长度ls/m', 'FontSize', 11);
    ylabel('方向性系数', 'FontSize', 11, 'Rotation', 90);
    legend('方向性系数', 'FontSize', 10);
    grid on;
    xlim([0.01, 1])
    set(gcf, 'Color', 'white');
    set(gca, 'Color', [0.98, 0.98, 0.98]);
    saveas(gcf,'八木天线方向性系数随有源振子长度变化图.png')
    writematrix(D_max_MOM','八木天线方向性系数随有源振子长度变化值.xlsx','Range','A1:A100');
elseif flag == 3
    plot(ld0, D_max_MOM, 'LineWidth', 1.5, 'Marker', 'o', ...
        'MarkerSize', 4, 'MarkerEdgeColor', 'none');
    title('八木天线方向性系数随引向器长度变化图','FontSize', 12);
    xlabel('引向器长度ld/m', 'FontSize', 11);
    ylabel('方向性系数', 'FontSize', 11, 'Rotation', 90);
    legend('方向性系数', 'FontSize', 10);
    grid on;
    xlim([0.005, 1])
    set(gcf, 'Color', 'white');
    set(gca, 'Color', [0.98, 0.98, 0.98]);
    saveas(gcf,'八木天线方向性系数随引向器长度变化图.png')
    writematrix(D_max_MOM','八木天线方向性系数随引向器长度变化值.xlsx','Range','A1:A200');
elseif flag == 4
    plot(ld_num0, D_max_MOM, 'LineWidth', 1.5, 'Marker', 'o', ...
        'MarkerSize', 4, 'MarkerEdgeColor', 'none');
    title('八木天线方向性系数随引向器个数变化图','FontSize', 12);
    xlabel('引向器个数ld_num', 'FontSize', 11);
    ylabel('方向性系数', 'FontSize', 11, 'Rotation', 90);
    legend('方向性系数', 'FontSize', 10);
    grid on;
    xlim([1, 10])
    set(gcf, 'Color', 'white');
    set(gca, 'Color', [0.98, 0.98, 0.98]);
    saveas(gcf,'八木天线方向性系数随引向器个数变化图.png')
    writematrix(D_max_MOM','八木天线方向性系数随引向器个数变化值.xlsx','Range','A1:A10');
elseif flag == 5
    plot(dr0, D_max_MOM, 'LineWidth', 1.5, 'Marker', 'o', ...
        'MarkerSize', 4, 'MarkerEdgeColor', 'none');
    title('八木天线方向性系数随反射器与有源阵子间距变化图','FontSize', 12);
    xlabel('反射器与有源阵子间距dr/m', 'FontSize', 11);
    ylabel('方向性系数', 'FontSize', 11, 'Rotation', 90);
    legend('方向性系数', 'FontSize', 10);
    grid on;
    xlim([0.01, 1])
    set(gcf, 'Color', 'white');
    set(gca, 'Color', [0.98, 0.98, 0.98]);
    saveas(gcf,'八木天线方向性系数随反射器与有源阵子间距变化图.png')
    writematrix(D_max_MOM','八木天线方向性系数随有源阵子间距变化值.xlsx','Range','A1:A100');
elseif flag == 6
    plot(ds0, D_max_MOM, 'LineWidth', 1.5, 'Marker', 'o', ...
        'MarkerSize', 4, 'MarkerEdgeColor', 'none');
    title('八木天线方向性系数随引向器间距变化图','FontSize', 12);
    xlabel('引向器间距ds/m', 'FontSize', 11);
    ylabel('方向性系数', 'FontSize', 11, 'Rotation', 90);
    legend('方向性系数', 'FontSize', 10);
    grid on;
    xlim([0.01, 1])
    set(gcf, 'Color', 'white');
    set(gca, 'Color', [0.98, 0.98, 0.98]);
    saveas(gcf,'八木天线方向性系数随引向器间距变化图.png')
    writematrix(D_max_MOM','八木天线方向性系数随引向器间距变化值.xlsx','Range','A1:A100');
elseif flag == 7
    plot(ds0, D_max_MOM, 'LineWidth', 1.5, 'Marker', 'o', ...
        'MarkerSize', 4, 'MarkerEdgeColor', 'none');
    title('八木天线方向性系数随天线间距变化图','FontSize', 12);
    xlabel('天线间距ds/m', 'FontSize', 11);
    ylabel('方向性系数', 'FontSize', 11, 'Rotation', 90);
    legend('方向性系数', 'FontSize', 10);
    grid on;
    xlim([0.01, 1])
    set(gcf, 'Color', 'white');
    set(gca, 'Color', [0.98, 0.98, 0.98]);
    saveas(gcf,'八木天线方向性系数随天线间距变化图.png')
    writematrix(D_max_MOM','八木天线方向性系数随天线间距变化值.xlsx','Range','A1:A100');
else
    plot(N0, D_max_MOM, 'LineWidth', 1.5, 'Marker', 'o', ...
        'MarkerSize', 4, 'MarkerEdgeColor', 'none');
    grid on;
    title('八木天线方向性系数随匹配点个数变化图','FontSize', 12);
    xlabel('匹配点个数N', 'FontSize', 11);
    ylabel('方向性系数D_max', 'FontSize', 11, 'Rotation', 90);
    legend('方向性系数', 'Location', 'southeast', 'FontSize', 10);
    xlim([11,1001])
    ylim([0, 10])
    set(gcf, 'Color', 'white');
    set(gca, 'Color', [0.98, 0.98, 0.98]);
    saveas(gcf,'八木天线方向性系数随匹配点个数变化图.png')

    figure(7)
    plot(N0, Z_real, 'LineWidth', 1.5, 'Marker', 'o', ...
        'MarkerSize', 4, 'MarkerEdgeColor', 'none');
    grid on;
    title('八木天线输入电阻随匹配点个数变化图','FontSize', 12);
    xlabel('匹配点个数N', 'FontSize', 11);
    ylabel('输入电阻R/Ω', 'FontSize', 11, 'Rotation', 90);
    legend('八木天线输入电阻', 'FontSize', 10, 'Location', 'northwest');
    xlim([11,1001])
    ylim([0, 160])
    set(gcf, 'Color', 'white');
    set(gca, 'Color', [0.98, 0.98, 0.98]);
    saveas(gcf,'八木天线输入电阻随匹配点个数变化图.png')

    figure(8)
    plot(N0, Z_imag, 'LineWidth', 1.5, 'Marker', 'o', ...
        'MarkerSize', 4, 'MarkerEdgeColor', 'none');
    grid on;
    title('八木天线输入电抗随匹配点个数变化图','FontSize', 12);
    xlabel('匹配点个数N', 'FontSize', 11);
    ylabel('输入电抗X/Ω', 'FontSize', 11, 'Rotation', 90);
    legend('八木天线输入电抗', 'FontSize', 10, 'Location', 'northwest');
    xlim([11,1001])
    ylim([-80, 80])
    set(gcf, 'Color', 'white');
    set(gca, 'Color', [0.98, 0.98, 0.98]);
    saveas(gcf,'八木天线输入电抗随匹配点个数变化图.png')
end
