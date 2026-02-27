clc; clear; close all;
% 设置相关参数
Pic(0.1,0)
Pe = 0:0.01:0.2;
l = length(Pe);
Ber = zeros(2,l);
% 同一误码率下，不同编码方法的的性能分析
for i = 0:1
    % 同一编码方法下，不同误码率的性能分析
    for j = 1:l  
        Ber(i + 1,j) = Pic(Pe(j),i);
    end
end
% 数据可视化
figure
plot(Pe,Ber(1,:),'b-o','LineWidth',1,'MarkerSize',2.5)
hold on
plot(Pe,Ber(2,:),'r-*','LineWidth',1,'MarkerSize',2.5)
xlabel('Pe');
ylabel('Ber');
legend('CCSDS标准（2006版）','CCSDS标准（2007版）','location','northwest')
grid on;
title('不同编码方式性能对比图');


