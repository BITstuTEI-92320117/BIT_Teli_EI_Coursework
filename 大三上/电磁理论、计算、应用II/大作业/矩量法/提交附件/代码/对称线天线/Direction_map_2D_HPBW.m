function HPBW = Direction_map_2D_HPBW(D, l, N, flag)
%% 根据电场分布绘制二维(E面)方向图并计算半功率波瓣宽度
[m, n] = size(D);
D = DN(D);
D_E0 = D(:,(n-1)/4 +1);
D_E1 = flip(D(:, 3*(n-1)/4 +1));
D_E1(1) = [];
D_E = [D_E0;D_E1];
theta = linspace(0, 2*pi, 2*m-1);

% 计算半功率波瓣宽度
% 找到最大值和对应的角度
[max_D_E, max_idx] = max(D_E);
half_D_E = max_D_E / 2;
theta_deg = rad2deg(theta);

% 在主瓣左侧寻找半功率点
left_idx = max_idx;
while true
    left_idx = left_idx - 1;
    if D_E(left_idx) <= half_D_E
        break;
    end
end

% 在主瓣右侧寻找半功率点
right_idx = max_idx;
while true
    right_idx = right_idx + 1;
    if D_E(right_idx) <= half_D_E
        break;
    end
end

% 使用线性插值提高精度
% 左侧插值
x1 = D_E(left_idx-1);
x2 = D_E(left_idx);
y1 = theta_deg(left_idx-1);
y2 = theta_deg(left_idx);
if x1 ~= x2
    theta_left = y1 + (half_D_E - x1) * (y2 - y1) / (x2 - x1);
else
    theta_left = (y1 + y2) / 2;
end

% 右侧插值
x1 = D_E(right_idx);
x2 = D_E(right_idx+1);
y1 = theta_deg(right_idx);
y2 = theta_deg(right_idx+1);
if x1 ~= x2
    theta_right = y1 + (half_D_E - x1) * (y2 - y1) / (x2 - x1);
else
    theta_right = (y1 + y2) / 2;
end

% 计算半功率波瓣宽度
HPBW = abs(theta_right - theta_left);
if HPBW > 180
    HPBW = 360 - HPBW;
end
if flag == 1
    fname = sprintf('半功率波瓣宽度(l=%gm,N=%d).xlsx', l, N);
    writematrix(HPBW,fname);
end

if flag == 1
    polarplot(pi/2 - theta, D_E);
    grid on;
    title('线天线辐射场的二维(E面)方向图','FontSize', 12);
    set(gcf, 'Color', 'white');
    set(gca, 'Color', [0.98, 0.98, 0.98]);
    fname = sprintf('线天线辐射场的二维方向图(矩量法l=%gm,N=%d).png' ,l, N);
    saveas(gcf,fname)
elseif flag == 2
    polarplot(pi/2 - theta, D_E);
    grid on;
    title('线天线辐射场的二维(E面)方向图','FontSize', 12);
    set(gcf, 'Color', 'white');
    set(gca, 'Color', [0.98, 0.98, 0.98]);
    fname = sprintf('线天线辐射场的二维方向图(传输线模型l=%gm).png' ,l);
    saveas(gcf,fname)
end
end