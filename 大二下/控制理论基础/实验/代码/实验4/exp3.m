% 定义两个不同的分子系数（系统增益）  
num1 = 5;     
num2 = 20;   
 
% 定义共同的分母多项式（通过conv函数计算多项式乘积）  
den = conv([1 1 0 0], [0.1 1]);  

% 创建两个传递函数对象（不同增益，相同极点配置）  
G1 = tf(num1, den);   
G2 = tf(num2, den);   
  
% 绘制第一个系统的Bode图（含幅值/相位裕度）  
figure(1);  
margin(G1);   
grid on;      
 
% 绘制第二个系统的Bode图（含幅值/相位裕度）  
figure(2);  
margin(G2);    
grid on;   
