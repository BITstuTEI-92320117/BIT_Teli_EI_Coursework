% 定义系统零点位置  
z = [-5];  % 系统零点在s = -5处  
	  
% 定义三种不同的极点配置  
p1 = [-1 -3 -12];    
p2 = [-1 -3 -35];    
p3 = [-1 -3 -7];     
  
% 创建三种零极点形式的传递函数  
G1 = zpk(z, p1, 1);    
G2 = zpk(z, p2, 1);    
G3 = zpk(z, p3, 1);    
  
% 绘制第一种系统的根轨迹图  
figure(1)  
rlocus(G1)    
title('根轨迹图（极点：-1, -3, -12）')    
xlabel('实轴')   
ylabel('虚轴')    
grid on   
  
% 绘制第二种系统的根轨迹图  
figure(2)  
rlocus(G2)    
title('根轨迹图（极点：-1, -3, -35）')  
xlabel('实轴')    
ylabel('虚轴')    
grid on    
  
% 绘制第三种系统的根轨迹图  
figure(3)  
rlocus(G3)  
title('根轨迹图（极点：-1, -3, -7）')   
xlabel('实轴')   
ylabel('虚轴')    
grid on   
