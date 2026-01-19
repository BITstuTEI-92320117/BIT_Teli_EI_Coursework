clear,clc;
%% 矩量法分析八木天线
% 定义参数
lr = 0.3;           % 反射器长度(对照组lr=0.3,最优lr=0.239)
ls = 0.25;          % 有源振子长度(对照组ls=0.25,最优ls=0.190)
ld = 0.225;         % 引向器长度(对照组ld=0.225,最优ld=0.226)
ld_num = 3;         % 引向器个数(对照组ld_num=3,最优ld_num=4)
dr = 0.25;          % 反射器与有源阵子间距(对照组dr=0.25,最优dr=0.324)
ds = 0.25;          % 引向器间距(对照组ds=0.25,最优ds=0.324) 最大方向性系数18.9354
r = 100;            % 场点半径 
a = 0.001;         
f = 3.0e8;   
c = 3.0e8;      
k = 2 * pi * f / c; 
Z0 = 120 * pi;  
l = [lr, ls, ld*ones(1,ld_num)];           % 天线一半的长度
l_num = length(l);       
M = 360;            % 电场离散程度 360
d = [dr, repmat(ds, 1, l_num-1).*(1:l_num-1)+dr]; % 所有天线相对于第一根天线的距离
flag1 = 1;

% 线域网格离散
N = 101;             % 匹配点个数 101
dl = 2 * l/(N - 1); 
% 确定每根天线的匹配点
zb = zeros(l_num, N);
for i = 1: l_num
    zb(i,:) = -l(i): dl(i): l(i);
end

% 打印参数信息
fprintf('反射器半长lr = %gm\n',lr)
fprintf('有源振子半长ls = %gm\n',ls)
fprintf('引向器半长lr = %gm\n',ld)
fprintf('引向器个数ld_num = %d\n',ld_num)
fprintf('反射器与有源阵子间距dr = %gm\n',dr)
fprintf('引向器间距ds = %gm\n',ds)
fprintf('远场半径r = %dm\n',r)

% 计算矩阵元素
[Z, b] = MoM_Zb(a, k, Z0, N ,dl, zb, l_num, d);

% 利用矩量法计算线天线电流，并绘制电流分布
flag2 = 1;
I_MOM = MoM_I(Z, b, zb, N, l_num, flag2, l);

% 计算输入阻抗
Zin = MoM_Zin(I_MOM(2,:), N);
if imag(Zin) > 0
    fprintf('输入阻抗Zin = %g + %gj\n', real(Zin), imag(Zin));
elseif imag(Zin) < 0
    fprintf('输入阻抗Zin = %g - %gj\n', real(Zin), -imag(Zin));
else
    fprintf('输入阻抗Zin = %g\n', real(Zin));
end

% 计算电场分布(φ=90平面)
E_MOM = funcE(r, zb, I_MOM, a, dl, k, Z0, N, l_num, M, d);

% 计算方向性系数
[D_MOM, D_max_MOM] = funcD(E_MOM, Z0);
fprintf('方向性系数:%g\n',D_max_MOM);

% 绘制线天线辐射场的三维方向图
Direction_map_3D(D_MOM, lr, ls, ld, ld_num, dr, ds, flag1);

% 绘制线天线辐射场的二维E面方向图并计算半功率波瓣宽度
[HPBW_E, HPBW_H] = Direction_map_2D_HPBW(D_MOM, lr, ls, ld, ld_num, dr, ds, flag1);
fprintf('E面半功率波瓣宽度: %.2f度\n', HPBW_E);
fprintf('H面半功率波瓣宽度: %.2f度\n', HPBW_H);