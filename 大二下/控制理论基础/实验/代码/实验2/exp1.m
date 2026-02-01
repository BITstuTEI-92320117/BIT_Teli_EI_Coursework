% 1. 定义开环传递函数  
num = [8];            
den = [1, 2, 0];      
G = tf(num, den);      
  
% 2. 构建单位反馈闭环系统  
T = feedback(G, 1, -1);   
	  
% 3. 绘制阶跃响应曲线  
step(T);            
title('闭环系统阶跃响应');  
xlabel('时间(秒)');  
ylabel('幅值');  
grid on;  
