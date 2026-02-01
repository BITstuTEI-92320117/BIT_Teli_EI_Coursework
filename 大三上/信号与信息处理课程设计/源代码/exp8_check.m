data = load('ECG.mat');
fs = 1000;
time_start = 162000;
time_end = 167000;
t = 162:167;
plot(data.a_2n2(time_start:time_end), 'b')
xlim([0, 5000])
xticks(0:1000:5000)
xticklabels(t)
[~, peakLocs] = findpeaks(data.a_2n2(time_start:time_end), 'MinPeakHeight', 0.5*max(data.a_2n2(time_start:time_end)), ...
                    'MinPeakDistance', 0.3*fs);
xlabel('时间/s')
ylabel('心率')
title('162~167s时间窗心电信号')
rrIntervals = mean(diff(peakLocs)/fs)
hrTimeDomain = 60/rrIntervals