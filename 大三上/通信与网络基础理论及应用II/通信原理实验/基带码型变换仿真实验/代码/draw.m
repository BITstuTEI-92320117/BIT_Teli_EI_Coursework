function draw(seq, code, level, code_type, N_draw, fs)
% 绘制前N_draw位：信源序列、编码序列、归零波形
str1 = ['前20位信源序列与',code_type,'波形'];
figure('Name',str1,'Color','white');
subplot(3,1,1);
seq = seq(1:N_draw);
stem(1:N_draw, seq, 'filled', 'MarkerFaceColor','b', 'LineWidth', 1.5, 'Color', 'b');
xlim([1,N_draw])
title('前20位信源序列');
xlabel('符号位置'); ylabel('值(0/1)');
xticks(1:N_draw)
grid on;

% 编码序列绘图
code = code(1:N_draw);
subplot(3,1,2);
stem(1:N_draw, code, 'filled', 'MarkerFaceColor','b', 'LineWidth', 1.5, 'Color', 'b');
xlim([1,N_draw])
str2 = ['前20位信源序列',code_type,'码'];
title(str2);
xlabel('符号位置'); ylabel('值(0/1/-1)');
xticks(1:N_draw)
grid on;

% 归零波形绘图
level = level(1:N_draw*fs);
subplot(3,1,3);
plot(0:length(level)-1, level, 'LineWidth',1.5, 'Color', 'b');
str3 = ['前20位信源序列的归零',code_type,'波形'];
title(str3);
xlabel('采样点'); ylabel('电平');
grid on;
name = ['前20位信源序列与',code_type,'波形', '.png'];
saveas(gcf, name)
end