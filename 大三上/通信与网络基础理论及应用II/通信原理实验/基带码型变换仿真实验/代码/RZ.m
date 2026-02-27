function level = RZ(code, ls, fs)
% 归零编码：每个码元前fs/2采样点为电平，后fs/2为0（占空比50%）
lc = ls * fs;
level = zeros(1, lc);
for i = 1:ls
    le = code(i);
    pulse = [le*ones(1, fs/2), zeros(1, fs/2)];
    level(fs*(i-1)+1:fs*i) = pulse;
end
end