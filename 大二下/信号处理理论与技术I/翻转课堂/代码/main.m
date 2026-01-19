Error_Rate0 = zeros(4,27);
Error_Code_Rate0 = zeros(4,27);
test_SNR = [-40, -35, -30:1:-10, -5, 0, 5, 10];
flag = 2;
if flag == 1
    for i = [2, 3]
        for j = 1:27
            [~, Error_Rate0(i - 1, j),~,~]...
                =SSB_ModDmod(40000, 20000, 2000, 1, 50, 1, test_SNR(j), i, 0, 0, 0);
        end
    end
    for j = 1:27
        [~, Error_Rate0(3, j),~,~]...
            =SSB_ModDmod(40000, 20000, 2000, 1, 50, 1, test_SNR(j), 3, 0, 1, 0);
    end
    for k = 1:27
        [~, Error_Rate0(4, k),~,~]...
            =VSB_ModDmod(40000, 20000, 2000, 1, 50, 1, test_SNR(k), 3, 0, 0);
    end
    figure(1)
    plot(test_SNR,Error_Rate0(1,:),'b-','LineWidth',1.5)
    hold on
    plot(test_SNR,Error_Rate0(2,:),'r-','LineWidth',1.5)
    xlabel('SNR');
    ylabel('Error Rate');
    legend('理想滤波器','椭圆滤波器','location','northeast')
    grid on;
    title('SSB调制不同滤波器性能对比图');
    saveas(gcf,'SSB调制不同滤波器性能对比图.png');
    figure(2)
    plot(test_SNR,Error_Rate0(2,:),'b-','LineWidth',1.5)
    hold on
    plot(test_SNR,Error_Rate0(3,:),'r-','LineWidth',1.5)
    xlabel('SNR');
    ylabel('Error Rate');
    legend('滤波法','相移法','location','northeast')
    grid on;
    title('SSB调制滤波法和相移法性能对比图');
    saveas(gcf,'SSB调制滤波法和相移法性能对比图.png');
    figure(3)
    plot(test_SNR,Error_Rate0(2,:),'b-','LineWidth',1.5)
    hold on
    plot(test_SNR,Error_Rate0(4,:),'r-','LineWidth',1.5)
    xlabel('SNR');
    ylabel('Error Rate');
    legend('SSB调制','VSB调制','location','northeast')
    grid on;
    title('不同调制方式椭圆滤波器性能对比图');
    saveas(gcf,'不同调制方式椭圆滤波器性能对比图.png');
    save('Error_Rate0.mat','Error_Rate0')

elseif flag == 2
    % 探究在无噪理想低通滤波器条件下，三种调制方式频谱利用率（增加）
    % 频谱利用率定义为系统所传输的信息速率R与系统带宽W的比
    % 帕塞瓦尔定理，时域信号的能量等于频域中的能量
    % 这里采取能量占总能量的90%频带的宽度作为带宽
    % 信息速率等于码元速率，即基带信号频率
    % 在上述带宽定义下DSB:0.3472 bps/Hz,SSB:0.7092 bps/Hz,VSB:0.5405 bps/Hz
    % 观察可知，SSB调制的频谱利用率最大，VSB次之，最后为DSB。
    [Error_Point, Error_Rate,Sequence_Length, Error_Code_Rate]...
        =VSB_ModDmod(40000, 20000, 2000, 1, 50, 1, '0', 1, 0, 1);

    %% 探究SSB调制和VSB调制下，不同滤波器对误码率大小的影响（新增）
    % 绘制SSB调制和VSB调制下，分别使用理想滤波器和椭圆滤波器，误码率随信噪比变化曲线
elseif flag == 3
    for k = [2, 3]
        for l = 1:27
            [Error_Point, Error_Rate,Sequence_Length, Error_Code_Rate0(k - 1, l)]...
                =SSB_ModDmod(40000, 20000, 2000, 1, 50, 1, test_SNR(l), k, 0, 0, 0);
        end
    end
    figure(4)
    plot(test_SNR,Error_Code_Rate0(1, :),'b-','LineWidth',1.5)
    hold on
    plot(test_SNR,Error_Code_Rate0(2, :),'r-','LineWidth',1.5)
    xlabel('SNR');
    ylabel('Error Code Rate');
    legend('理想滤波','椭圆滤波','location','northeast')
    grid on;
    title('SSB调制不同滤波法误码率对比图');
    saveas(gcf,'SSB调制不同滤波法误码率对比图.png');
    for k = [2, 3]
        for l = 1:27
            [Error_Point, Error_Rate,Sequence_Length, Error_Code_Rate0(k + 1, l)]...
                =VSB_ModDmod(40000, 20000, 2000, 1, 50, 1, test_SNR(l), k, 0, 0);
        end
    end
    figure(5)
    plot(test_SNR,Error_Code_Rate0(3, :),'b-','LineWidth',1.5)
    hold on
    plot(test_SNR,Error_Code_Rate0(4, :),'r-','LineWidth',1.5)
    xlabel('SNR');
    ylabel('Error Code Rate');
    legend('理想滤波','椭圆滤波','location','northeast')
    grid on;
    title('VSB调制不同滤波法误码率对比图');
    saveas(gcf,'VSB调制不同滤波法误码率对比图.png');
    save('Error_Code_Rate0.mat','Error_Code_Rate0')
    % 由上述仿真图像可知，SSB调制和VSB调制在低噪声（SNR>-10dB）条件下误码率较低（增加）
    % 在强噪声（SNR>-10dB）条件下误码率较高，因为此时信道容量过低，几乎失去传送信息的功能
    % 尽管椭圆滤波器恢复的波形在所有采样点上误差率较大，波形失真较严重
    % 但由于在低噪声条件下二者效果差别不大，因此实际通信系统中可以使用椭圆滤波器
    % 代替理想滤波器进行滤波，仍能起到很好的传输效果（写完去除）
    % 功率利用率用在给定误比特率条件下能量信噪比
    % 由上图认为SSB调制和VSB调制在低噪声下功率利用率相等，实际上DSB也相等（查资料或AI）
else
    [Error_Point, Error_Rate,Sequence_Length, Error_Code_Rate]...
        =SSB_ModDmod(40000, 20000, 2000, 1, 50, 1, '0', 2, 0, 0, 1);
end




