function HPBW = HPBW(D, theta)
%% 计算半功率波瓣宽度
% 找到最大值和对应的角度
l = length(D);
Dc = D(3*(l-1)/4+2:l);
D((l-1)/4+1:l) = D(1:3*(l-1)/4+1);
D(1:(l-1)/4) = Dc;
[max_D_E, max_idx] = max(D);
half_D = max_D_E / 2;
theta_deg = rad2deg(theta);
lt = length(theta_deg);

% 在主瓣左侧寻找半功率点
left_idx = max_idx;
while true
    if D(left_idx) <= half_D || left_idx == 1
        break;
    end
    left_idx = left_idx - 1;
end

% 在主瓣右侧寻找半功率点
right_idx = max_idx;
while true
    if D(right_idx) <= half_D || right_idx == lt
        break;
    end
    right_idx = right_idx + 1;
end

% 使用线性插值提高精度
% 左侧插值
if left_idx == 1
    x1 = D(1);
    x2 = D(1);
    y1 = theta_deg(1);
    y2 = theta_deg(1);
else
    x1 = D(left_idx-1);
    x2 = D(left_idx);
    y1 = theta_deg(left_idx-1);
    y2 = theta_deg(left_idx);
end
if x1 ~= x2
    theta_left = y1 + (half_D - x1) * (y2 - y1) / (x2 - x1);
else
    theta_left = (y1 + y2) / 2;
end

% 右侧插值
if right_idx == lt
    x1 = D(lt);
    x2 = D(lt);
    y1 = theta_deg(lt);
    y2 = theta_deg(lt);
else
    x1 = D(right_idx);
    x2 = D(right_idx+1);
    y1 = theta_deg(right_idx);
    y2 = theta_deg(right_idx+1);
end
if x1 ~= x2
    theta_right = y1 + (half_D - x1) * (y2 - y1) / (x2 - x1);
else
    theta_right = (y1 + y2) / 2;
end

% 计算半功率波瓣宽度
HPBW = abs(theta_right - theta_left);
end