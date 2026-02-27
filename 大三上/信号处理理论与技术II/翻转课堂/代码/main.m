clc,clear,close all;
%% 生成有限长单边指数序列
a = 0.8*exp(j*pi/5);
L = 3001; % 3^7,5^5,3000,3001
fprintf('序列的长度N=%d\n',L)
% 生成序列
[n, seq] = gen_seq(a, L);
% 仿真参数
p = 3;
Radix_p_flag = 0;
Radix_mix_flag = 1;
Radix_rader_mix_flag = 1;
t_cnt = 4;
cnt = 1;

% 绘制DTFT频谱图
plot_dtft(a)

% MATLAB内置fft函数
fprintf('MATLAB内置fft函数')
tic
fft_base = fft(seq);
toc
figure('Color','w','Name','FFT频谱图')
plot_fft(t_cnt, cnt, L, fft_base,'MATLAB内置算法')
cnt = cnt + 1;

% dft直接计算
fprintf('DFT直接计算')
tic
dft_test = dft(seq);
toc
plot_fft(t_cnt, cnt, L, dft_test,'DFT直接计算')
cnt = cnt + 1;

% 基p-fft算法
if Radix_p_flag == 1
    fprintf('基p-FFT算法')
    tic;
    fft_Radix_p_test = Radix_p_FFT(seq, p);
    toc;
    plot_fft(t_cnt, cnt, L, fft_Radix_p_test,'基p-FFT算法')
    diff = fft_base - fft_Radix_p_test;
    cnt = cnt + 1;
end

% 混合基fft算法
if Radix_mix_flag == 1
    fprintf('混合基FFT算法')
    tic;
    fft_Radix_mix_test = Radix_mix_fft(seq);
    toc;
    plot_fft(t_cnt, cnt, L, fft_Radix_mix_test,'混合基FFT算法')
    diff = fft_base - fft_Radix_mix_test;
    cnt = cnt + 1;
end

% 雷德-混合基fft算法
if Radix_rader_mix_flag == 1
    fprintf('雷德-混合基FFT算法')
    tic;
    fft_Radix_rader_mix_test = Radix_rader_mix_fft(seq);
    toc;
    plot_fft(t_cnt, cnt, L, fft_Radix_rader_mix_test,'雷德-混合基FFT算法')
    diff = fft_base - fft_Radix_rader_mix_test;
    cnt = cnt + 1;
end
saveas(gca,'FFT频谱图.png')
disp(size(diff))  % 误差的形状
disp(diff(1:5))  % 显示5个误差
err = diff.*conj(diff);
mse = mean(err, "all");  % 均方误差
disp(mse)

diff2 = fft_base - dft_test;
disp(size(diff2))
disp(diff2(1:5))
err = diff2.*conj(diff2);
mse = mean(err, "all");  % 均方误差
disp(mse)
