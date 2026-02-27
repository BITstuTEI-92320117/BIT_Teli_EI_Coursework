% % 定义传递函数 H(s)
% num = [1 0 3];          
% den = conv([1 2 5], [1 2]); 
% 
% % 部分分式展开求拉氏逆变换
% [r, p, k] = residue(num, den)

% 定义四个传递函数的零极点数据
data = struct('title', {'(e)', '(f)', '(g)', '(h)'}, ...
              'zeros', {[0], [-2i; 2i], [0; 0], [-2i; 2i]}, ...
              'poles', {[-1-1i; -1+1i], [-2-1.5i; -2+1.5i], [-1-1i; -1+1i], [-1.5i; -1.5i]});

% 定义频率抽样点
omega = 0:0.01:100; 
figure('Position', [100, 100, 800, 800]);

% 遍历四个传递函数
for id = 1:4
    [b,a] = zp2tf(data(id).zeros,data(id).poles,1); % 由零极点得到传递函数系数
    H = freqs(b,a,omega); % 计算响应
    
    % 创建子图并绘制曲线
    subplot(4,1,id);
    semilogx(omega, abs(H), 'LineWidth', 2, 'Color', [0 0.4470 0.7410]);
    set(gca, 'YScale', 'log');
    grid on;
    title(data(id).title, 'FontWeight', 'bold');
    xlabel('\omega','FontWeight', 'bold');
    ylabel('|H(\omega)|','FontWeight', 'bold');
    xlim([min(omega), max(omega)]);
end
sgtitle('传递函数幅频响应特性');
