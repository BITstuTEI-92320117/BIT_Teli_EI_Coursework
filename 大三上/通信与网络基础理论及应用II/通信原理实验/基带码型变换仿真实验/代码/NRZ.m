function level = NRZ(code, ls, fs)
% 非归零编码：每个码元占fs个采样点，电平保持不变
lc = ls * fs;
level = zeros(1, lc);
for i = 1:ls
    le = code(i);
    pulse = le*ones(1, fs);
    level(fs*(i-1)+1:fs*i) = pulse;
end
end