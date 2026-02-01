clear,clc;
%% 矩量法计算
% 定义参数
l = 0.25;
a = 0.001;
Z0 = 120 * pi;
f = 3.0e8;
c = 3.0e8;
k = 2 * pi * f / c;
r = 100;
M = 360;

% 线域网格离散
N = 21; % 匹配点个数
dl = 2 * l/(N - 1);
zb = -l:dl:l;

% 打印参数信息
fprintf('天线长度的一半l = %gm\n',l)
fprintf('匹配点个数N = %d\n',N)
fprintf('远场半径r = %dm\n',r)

% 计算矩阵元素
flag1 = 1;
[Z, b] = MoM_Zb(a, k, Z0, N ,dl, zb);

% 利用矩量法计算电流
figure(1);
I_MOM = MoM_I(Z, b, zb, l, N, flag1);

% 计算输入阻抗
Zin = MoM_Zin(I_MOM, N, l, flag1); % 计算结果仅供参考
if imag(Zin) > 0
    fprintf('输入阻抗Zin = %g + %gj\n', real(Zin), imag(Zin));
elseif imag(Zin) < 0
    fprintf('输入阻抗Zin = %g - %gj\n', real(Zin), -imag(Zin));
else
    fprintf('输入阻抗Zin = %g\n', real(Zin));
end

% 计算电场幅值并绘制其分布(φ=0平面)
figure(2);
[E_MOM, E_MOM_phi0]= funcE(r, zb, I_MOM, a, dl, k, Z0, N, l, M, flag1);

% 计算方向性系数
[D_MOM, D_max_MOM] = funcD(E_MOM, Z0, flag1, l, N);
fprintf('方向性系数(矩量法):%g\n',D_max_MOM);

% 绘制线天线辐射场的三维方向图
figure(3);
Direction_map_3D(D_MOM, l, N, flag1);

% 绘制线天线辐射场的二维E面方向图并计算半功率波瓣宽度
figure(4);
HPBW = Direction_map_2D_HPBW(D_MOM, l, N, flag1);
fprintf('半功率波瓣宽度(矩量法): %.2f度\n', HPBW);

% 分析匹配点个数对计算精度的影响
Computational_accuracy(l, a, Z0, k, r, M)
%% 传输线模型
% 计算电场幅值并绘制其分布(r=100,φ=0平面)
% 通过设置参数flag确定是否计算
flag2 = 1;
if flag2 == 1
    r = 100;
    M = 360;
    % 求解电流分布
    figure(5);
    I_TLM = TLM_I(l, k);

    % 将求解结果与矩量法计算结果作比较
    figure(6);
    I_compare(zb, l, I_MOM, I_TLM, N)

    % 计算电场幅值并绘制其分布(r=100,φ=0平面)
    figure(7);
    E_TLM = funcE_T(r, k, l, Z0, M);

    % 计算方向性系数
    flag3 = 2;
    [D_TLM, D_max_TLM] = funcD(E_TLM, Z0, flag3);
    fprintf('方向性系数(传输线模型):%g\n',D_max_TLM);

    % 绘制线天线辐射场的三维方向图
    figure(8);
    Direction_map_3D(D_TLM, l, N, flag3);

    % 绘制线天线辐射场的二维E面方向图并计算半功率波瓣宽度
    figure(9);
    HPBW = Direction_map_2D_HPBW(D_TLM, l, N, flag3);
    fprintf('半功率波瓣宽度(传输线模型): %.2f度\n', HPBW);
end