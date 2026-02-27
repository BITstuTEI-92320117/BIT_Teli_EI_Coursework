function [HPBW_E, HPBW_H] = Direction_map_2D_HPBW(D, lr, ls, ld, ld_num, dr, ds, flag)
%% 根据电场分布绘制二维(E面和H面)方向图并计算半功率波瓣宽度
[m, n] = size(D);
D = DN(D);
D_E0 = D(:,(n-1)/4 +1);
D_E1 = flip( D(:, 3*(n-1)/4 +1) );
D_E1(1) = [];
D_E = [D_E0;D_E1];
D_H = D((m+1)/2,:);
theta = linspace(0, 2*pi, 2*m-1);
phi = linspace(0, 2*pi, n);
HPBW_E = HPBW(D_E, theta);
HPBW_H = HPBW(D_H, theta);

if flag == 1
    % 绘制E面方向图
    figure(4);
    polarplot(pi/2 - theta, D_E);
    grid on;
    title('八木天线辐射场E面方向图');
    set(gcf, 'Color', 'white');
    set(gca, 'Color', [0.98, 0.98, 0.98]);
    pname = sprintf('八木天线辐射场E面方向图(lr=%gm,ls=%gm,ld=%gm,ld_num=%dm,dr=%gm,ds=%gm).png' ...
        ,lr, ls, ld, ld_num, dr, ds);
    saveas(gcf,pname)
    % 绘制H面方向图
    figure(5);
    polarplot(pi/2 - phi, D_H);
    title('八木天线H面方向图');
    grid on;
    title('八木天线辐射场H面方向图');
    set(gcf, 'Color', 'white');
    set(gca, 'Color', [0.98, 0.98, 0.98]);
    pname = sprintf('八木天线辐射场H面方向图(lr=%gm,ls=%gm,ld=%gm,ld_num=%dm,dr=%gm,ds=%gm).png' ...
        ,lr, ls, ld, ld_num, dr, ds);
    saveas(gcf,pname)
end
end