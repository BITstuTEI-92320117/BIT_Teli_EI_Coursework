clear;

% 加载网格
% load('waveguide_1_mesh1');
 load('waveguide_1_mesh2');
% load('waveguide_1_mesh3');
% load('waveguide_2_mesh');

% 填充矩阵
[A,B]= fill_matrix(p,t);

% 求TE特征值
num_TE = 10;
[Ez_TE,kc_TE]= TE_mode(A,B,num_TE);
disp(kc_TE)

% 求TM特征值
num_TM = 10;
[Ez_TM,kc_TM]= TM_mode(A,B,e,num_TM);
disp(kc_TM)

% 绘制场模式图
mode_TE = 1;
mode_TM = 5;
Draw_TEmode(t,p,Ez_TE,mode_TE);         % 绘制TE模式场分布图
figure();
Draw_TMmode(t,p,e,Ez_TM,mode_TM);       % 绘制TM模式场分布图