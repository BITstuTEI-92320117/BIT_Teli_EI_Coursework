function [E, E_phi0] = funcE(r0, z, I, a, dl, k, Z0, N, l, M, flag)
%% 计算矩量法电场幅值分布
% 参数设置
theta = 0: pi/M: pi;
phi = 0: pi/M: 2*pi;
r = r0 * ones(length(theta),length(phi)); % 参数定义

% 计算电场分布
L = length(theta);
S = zeros(1, L);
for m = 1:N
    rs = sqrt(z(m)^2 + a^2)* sign(z(m));
    S = S + I(m)*exp( 1j*k*rs*cos(theta) ) * dl;
end
E = 1j*k*Z0*exp(-1j*k*r).*sin(theta)'.* S' ./ (4*pi*r);
E_phi0 = E(:,1);

if flag == 1
    % 绘制φ=0,θ=0~180°范围内电场幅值分布图
    theta0 = theta/pi * 180;    % 绘制为角度坐标
    plot(theta0, abs(E_phi0), 'LineWidth', 1.5, 'Marker', 'o', ...
        'MarkerSize', 4, 'MarkerEdgeColor', 'none');
    grid on;
    title('线天线辐射电场幅值分布图');
    xlabel('θ', 'FontSize', 11);
    xticks(0:180/10:180)
    xlim([0,180])
    ylabel('E', 'FontSize', 11, 'Rotation', 90);
    legend('线天线辐射电场分布', 'Location', 'northeast', 'FontSize', 10);
    set(gcf, 'Color', 'white');
    set(gca, 'Color', [0.98, 0.98, 0.98]);
    pname = sprintf('线天线辐射电场幅值分布图(矩量法计算结果l=%gm,N=%d,r=%d).png' ,l, N, r0);
    saveas(gcf,pname)
    fname = sprintf('线天线辐射电场幅值(矩量法计算结果r=%d,l=%gm,N=%d).xlsx', r0, l, N);
    writematrix(E_phi0,fname);
end
end