function [ H ] = ccsdscheckmatrix2( M ,RATE )
% 创建CCSDS文档（2007年版本V2）中定义的LDPC码校验矩阵
% 输入参数:
%   M    : CCSDS 131.1-O-2文档中定义的参数
%   RATE : 信息速率（例如1/2, 2/3, 4/5）
% 输出参数:
%   H    : 生成的LDPC校验矩阵

% 加载预计算的常数数据（包含theta数组和fai cell数组）
load('checkmatrixconstant.mat');

% 初始化基础矩阵模块
A = zeros(M);    % 全零矩阵，用于构建基本结构
B = eye(M);      % 单位矩阵，用于构建基本结构

% 生成辅助索引序列
L = 0:M-1;       % 行索引偏移量，范围0到M-1

% 构建26个C矩阵（对应CCSDS规范中的26个非零子矩阵模式）
for matrixNum = 1:26
    % 获取当前模式的theta参数（来自预加载数据）
    t_k = theta(matrixNum);
    % 计算4倍行索引的整除结果（用于模式选择）
    f_4i_M = floor(4*L/M);
    % 从预计算的fai表中获取模式参数（行：f_4i_M+1，列：log2(M)-6）
    f_k = fai{matrixNum}(f_4i_M+1,log2(M)-6)';
    % 计算列位置的核心参数（核心算法公式）
    col_1 = M/4*(mod((t_k+f_4i_M),4)) + ...% 四分之一周期偏移项
        mod((f_k+L),M/4);% 行相关偏移项
    % 将一维列索引转换为二维矩阵坐标（行优先）
    row_col = col_1+1 + L*M;
    % 构建当前模式的C矩阵模板
    C_temp = zeros(M);% 初始化模板矩阵
    C_temp(ind2sub([M,M],row_col)) = 1;% 设置非零元素位置
    C{matrixNum} = C_temp';% 转置后存入cell数组
end
% 构建基础校验矩阵框架
H = [A A B A B+C{1};B B A B C{4}+C{3}+C{2};B C{5}+C{6} A C{7}+C{8} B];
% 根据不同码率扩展校验矩阵
switch(RATE)
    case 1/2% 码率1/2：保持基础结构不变
        H=H;
        gridCol = 1:4;% 定义4列的分块网格
    case 2/3% 码率2/3：添加中间扩展分块
        H_23 = [A A;C{11}+C{10}+C{9} B; B C{14}+C{13}+C{12}];
        H=[H_23 H]; % 水平拼接
        gridCol = 1:6;% 更新为6列分块
    case 4/5 % 码率4/5：多层扩展结构
        H_23 = [A A;C{11}+C{10}+C{9} B; B C{14}+C{13}+C{12}];
        H_45 = [A A A A;C{23}+C{22}+C{21} B C{17}+C{16}+C{15} B;...
            B C{26}+C{25}+C{24} B C{20}+C{19}+C{18}];
        % 垂直堆叠扩展结构
        H = [H_45 H_23 H]; % 组合所有扩展块
        gridCol = 1:10; % 更新为10列分块
end
% 可视化校验矩阵结构
figure;
spy(H);% 绘制非零元素分布
hold on;
% 创建网格标记矩阵
gridH = zeros(size(H));
gridH([M,2*M],:) = 1;% 标记垂直网格线（每M列为一个块）
gridH(:,M*gridCol) = 1;% 标记水平网格线（按当前码率分块）
% 叠加绘制红色网格（线宽4）
spy(gridH,'r',4);
hold off;

end

