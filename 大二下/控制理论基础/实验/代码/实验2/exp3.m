%% 初始系统  
num = 1;     
den = [5, 1, 0];   
G = tf(num, den);   
  
%% 比例控制  
figure(2);   
G2 = 5 * G;   
G2 = feedback(G2, 1, -1);  
  
% 绘制阶跃响应曲线(0-50秒，步长0.01秒)  
step(G2, 0:0.01:50);  
xlabel('时间');  
ylabel('幅值');  
grid on;  
	  
%% 比例-微分控制   
figure(3);   
T = tf([4, 5], 1);   
G3 = T * G;   
G3 = feedback(G3, 1, -1);  
  
% 绘制阶跃响应曲线(0-50秒，步长0.02秒)  
step(G3, 0:0.02:50);  
xlabel('时间');  
ylabel('幅值');  
grid on;  
 
%% 速度负反馈控制  
figure(4);  
T1 = tf(5, [5, 1]);  
T1 = feedback(T1, 0.8, -1);  
T2 = tf(1, [1, 0]);   
G4 = T1 * T2;  
G4 = feedback(G4, 1, -1);   
  
% 绘制阶跃响应曲线(0-50秒，步长0.02秒)  
step(G4, 0:0.02:50);  
xlabel('时间(秒)');  
ylabel('幅值');  
grid on;  
