function [bandwidth, spec_eff, energy_spectrum, f] = Spectrum_Analysis(signal, fs, bit_rate, snr_db, t)
% 调制频谱利用率分析
% 输入参数:
%   signal - 输入信号
%   fs - 采样率
%   bit_rate - 比特率(码元速率)
%   snr_db - 信噪比(dB)
% 输出参数:
%   bandwidth - 90%能量带宽
%   spec_eff - 频谱利用率(bps/Hz)
%   energy_spectrum - 能量频谱
%   f - 频率轴

% 计算信号长度
N = length(signal);

% 计算信号的频域表示
[f,F] = T2F(t, signal);
% F = fft(signal);
% f = (-N/2:N/2-1)*(fs/N);  % 生成对称频率轴

% 计算能量频谱(使用帕塞瓦尔定理)
energy_spectrum = abs(F).^2 ;

% 只考虑正频率部分(带通信号分析)
positive_idx = f > 0;
f_pos = f(positive_idx);
energy_pos = energy_spectrum(positive_idx);

% 计算总能量
total_energy = sum(energy_pos);

% 按频率顺序累加能量
cum_energy = cumsum(energy_pos);
cum_energy_percent = cum_energy / total_energy * 100;

% 找到包含7.5%到97.5%能量的频率点
lower_idx = find(cum_energy_percent >= 7.5, 1, 'first');
upper_idx = find(cum_energy_percent >= 97.5, 1, 'first');

% 确定90%能量带宽
if exist('lower_idx', 'var') && exist('upper_idx', 'var')
    lower_freq = f_pos(lower_idx);
    upper_freq = f_pos(upper_idx);
    bandwidth = upper_freq - lower_freq;
else
    % 如果无法找到合适的能量区间，使用默认带宽
    bandwidth = 2 * bit_rate;  % SSB理论带宽约为码元速率
end
% 计算频谱利用率(信息速率/带宽)
spec_eff = bit_rate / bandwidth;

% 绘制能量频谱图
figure;
plot(f, energy_spectrum);
hold on;
xlim([-5000,5000])
title('VSB信号能量频谱');
legend('能量频谱');
xlabel('频率(Hz)');
ylabel('能量');
grid on;
hold off;

% 保存图形
saveas(gcf, 'VSB能量频谱.png');
end