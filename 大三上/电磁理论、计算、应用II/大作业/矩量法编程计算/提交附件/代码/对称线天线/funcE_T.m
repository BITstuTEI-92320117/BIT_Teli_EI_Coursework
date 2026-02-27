function E = funcE_T(r0, k, l, Z0, M)
%% 传输线模型电场幅值分布
% 参数设置
theta = 0: pi/M: pi;
phi = 0: pi/M: 2*pi; 
r = r0 * ones(length(theta),length(phi)); % 参数定义

% 计算电场分布
E = 1j*Z0*exp(-1j*k*r).*(cos(k*l*cos(theta'))-cos(k*l))./(2*pi*r.*sin(theta'));
E(1,:) = 0;

% 绘制φ=0,θ=0~180°范围内电场幅值分布图
E_phi0 = E(:,1);
E_phi0 = abs(E_phi0);
theta0 = theta/pi * 180;    % 绘制为角度坐标
plot(theta0, abs(E_phi0), 'LineWidth', 1.5, 'Marker', 'o', ...
     'MarkerSize', 4, 'MarkerEdgeColor', 'none');
grid on;
title('线天线辐射电场幅值分布图');
xlabel('θ', 'FontSize', 11);
ylabel('E', 'FontSize', 11, 'Rotation', 90);
xticks(0:180/10:180)
xlim([0,180])
legend('线天线辐射电场分布', 'Location', 'northeast', 'FontSize', 10);
set(gcf, 'Color', 'white');
set(gca, 'Color', [0.98, 0.98, 0.98]);
pname = sprintf('线天线辐射电场幅值分布图(传输线模型计算结果l=%gm,r=%d).png' ,l ,r0);
saveas(gcf,pname)
end