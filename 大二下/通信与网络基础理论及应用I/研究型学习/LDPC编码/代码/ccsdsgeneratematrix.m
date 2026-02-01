function [ Gqc ] = ccsdsgeneratematrix( H, M, RATE )
% 根据 CCSDS 标准（2006版）从校验矩阵 H 生成准循环结构的生成矩阵 Gqc
% 输入参数：
%   H     : 校验矩阵（需符合 CCSDS 结构）
%   M     : 标准中定义的矩阵参数，决定分块大小
%   RATE  : 编码速率（支持 1/2, 2/3, 4/5）
% 输出：
%   Gqc   : 准循环生成矩阵（稀疏形式）

%% 根据码率确定参数 K（控制生成矩阵结构）
switch(RATE)
    case 1/2
        K = 2;   % 码率1/2时，信息块分2个主块
    case 2/3
        K = 4;   % 码率2/3时，信息块分4个主块
    case 4/5
        K = 8;   % 码率4/5时，信息块分8个主块
end

%% 提取校验矩阵 H 的关键子矩阵
% P矩阵：H的最后3M-1列（对应校验位部分），且取前3M-1行
P = H(1:3*M-1, end-3*M+2:end); 

% Q矩阵：H的前M*K列（对应信息位部分），且取前3M-1行
Q = H(1:3*M-1, 1:M*K);         

%% 计算生成矩阵的核心部分 W
% 关键公式：W = (P^{-1} * Q)^T mod 2
% 注：此处 inv(P) 需在GF(2)下计算，且P必须是可逆的
W = mod((mod(inv(P),2) * Q),2)';  % 转置后得到 W

%% 构造基础生成矩阵 G（系统码形式）
IMK = eye(M*K);        % M*K阶单位矩阵（信息位部分）
OMK = zeros(M*K, 1);   % 全零列向量（占位）
G = [IMK OMK W];       % 标准系统码结构：[I | 0 | W]

%% 构建准循环结构的生成矩阵 Gqc
rowNum = 1:M/4:1+M*K-M/4;  % 初始化基准行索引（每隔 M/4 行）
Gqc = zeros(size(G));      % 初始化准循环矩阵
Gqc(rowNum, :) = G(rowNum, :);  % 将基准行复制到 Gqc

% 对每个子块进行循环右移操作
for m = 1:(4*K + 12)       % 总块数 = 信息块(K) + 校验块(12/4=3)
    for n = 1:M/4 - 1      % 每个子块内的行循环偏移
        % 计算当前子块列范围
        colRange = M/4*(m-1)+1 : M/4*m;
        
        % 对基准行的子块进行循环右移n位，赋值给后续行
        Gqc(rowNum + n, colRange) = circshift( G(rowNum, colRange), n, 2 );
    end
end

%% 可视化生成矩阵结构
figure;
spy(Gqc);  % 绘制非零元素分布
hold on;

% 添加红色分块线（标识准循环子块）
gridG = zeros(size(G));
gridG(M:M:(K-1)*M, :) = 1;    % 水平分块线（每 M 行）
gridG(:, M:M:(K+2)*M) = 1;    % 垂直分块线（每 M 列）
spy(gridG, 'r', 4);           % 红色显示分块线（线宽4）
title('Quasi-Cyclic Generate Matrix Structure');
hold off;
end