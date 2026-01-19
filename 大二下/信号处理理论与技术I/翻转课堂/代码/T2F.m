function [f,sf]= T2F(t,st)      % FFT
% dt = t(2)-t(1);
T=t(end) - t(1);                % 输入信号的时间最大值为T【被梁璨改进后成为了双边傅里叶变换】
df = 1/T;                       % dt=1/fs; 时间采样间隔，采样频率的倒数;
                                % N=T/dt;  采样点个数，总时长除以采样间隔
                                % 两式联合推导 df = 1/T 
N = length(st);                 % 输入信号时间的长度为采样点数
f = -N/2*df : df : N/2 * df-df; % 频率分布
sf = fft(st);                   % 做FFT
sf = T/N * fftshift(sf);        % 最后输出，将0-fs频谱搬移到-fs/2-fs/2频谱   
