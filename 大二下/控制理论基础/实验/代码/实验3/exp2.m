% 定义三种不同的零点位置  
z1 = -8;    
z2 = -18;   
z3 = -3;    
  
% 定义共同的极点配置（包含实数极点和共轭复数极点）  
p = [0 -2 -4+4i -4-4i];  % 极点在 s = 0, -2, -4±4i  
  
% 创建三种零极点形式的传递函数（增益均为1）  
G1 = zpk(z1, p, 1);   
G2 = zpk(z2, p, 1);    
G3 = zpk(z3, p, 1);    
 
% 绘制第一种系统的根轨迹图  
figure(1)  
rlocus(G1)  % 绘制G1的根轨迹  
title('根轨迹图（零点：-8，极点：0,-2,-4±4i）')    
xlabel('实轴（Re）')    
ylabel('虚轴（Im）')    
grid on    
  
% 绘制第二种系统的根轨迹图  
figure(2)  
rlocus(G2)    
title('根轨迹图（零点：-18，极点：0,-2,-4±4i）')   
xlabel('实轴（Re）')    
ylabel('虚轴（Im）')    
grid on    
	  
% 绘制第三种系统的根轨迹图  
figure(3)  
rlocus(G3)   
title('根轨迹图（零点：-3，极点：0,-2,-4±4i）')   
xlabel('实轴（Re）')   
ylabel('虚轴（Im）')    
grid on   
