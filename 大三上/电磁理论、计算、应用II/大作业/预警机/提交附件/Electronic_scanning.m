clear, clc
% 雷达电子扫描
% 雷达接收信息
beta_scam = 10;     % 天线扫描方位角 / 度
beta = 240;            % 天线阵面法线方向 / 度
E = 0.417;           % 接收信号强度 / 单位
alpha_scam = 2.2;   % 天线扫描俯仰角 / 度
gamma = 6;           % 主瓣宽度 / 度
t0 = 0;
t1 = 2.5e-6;         % t1 / s
t2 = 368e-6;         % t2 / s
t3 = 370.55e-6;      % t3 / s
PA = 10;             % 功放


% 定标数据
dt0 = 33e-6;         % 定标时延  / s
D0 = 1.5e3;          % 标准体视距 / m
E0 = 1.5;            % 定标强度 / 单位
PA0 = 10;            % 功放 / dB
s0 = 0.088;          % 雷达散射截面 / m²
c = 3e8;             % 光速


% 载机信息
h = 9000;                % 预警机升空高度
phi = 120;               % 预警机偏航角
alpha = 5;               % 预警机俯仰角


% 雷达电子扫描结果计算
if (beta + beta_scam) < 180
    beta1 = beta + beta_scam;
else
    beta1 = 360 - (beta + beta_scam);
end

Fazim = phi + beta + beta_scam;                                  % 方位角
if Fazim > 360
    Fazim = Fazim - 360;
end

Felev = alpha * (1 - beta1 / 90) + alpha_scam;                   % 俯仰角
Felev_range = gamma / 2;                                         % 俯仰角误差范围

dt1 = t2 - t0;
dt2 = t3 - t1;
D = (dt1 - dt0) * c / 2 + D0;                                    % 距离
d = (dt2 - dt1) * c / 2;                                         % 径向尺寸
s = s0 * (E / E0) * (E / E0) * (10^((PA0 - PA) / 10)) * (D / D0) * (D / D0);        % 雷达散射截面


% 输出结果
fprintf('雷达电子扫描结果为：\n');
fprintf('   方位角：%14.0f°\n', Fazim);
fprintf('   俯仰角：%15.1f°\n', Felev);
fprintf('   距离：%19.2fkm\n', D / 1000);
fprintf('   雷达散射截面%13.3fm²\n', s);
fprintf('   径向尺寸：%13.1fm\n', d);