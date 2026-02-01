function [ Gqc ] = ccsdsgeneratematrix2( H,M,RATE )
% 生成CCSDS标准（2007版）LDPC码的生成矩阵
% 输入参数：
%   H  : 校验矩阵（需预先通过ccdscheckmatrix2生成）
%   M  : CCSDS 131.1-O-2文档定义的结构参数
%   RATE : 码率（支持1/2, 2/3, 4/5三种模式）
% 输出参数：
%   Gqc : 生成的准循环生成矩阵（QC-LDPC格式）
%% 码率参数映射
switch(RATE)
    case 1/2
        K=2;% 码率1/2时扩展因子为2
    case 2/3
        K=4;% 码率2/3时扩展因子为4
    case 4/5
        K=8;% 码率4/5时扩展因子为8
end
%% 提取H矩阵关键子块
% H矩阵结构解析（基于CCSDS标准分块方式）：
% 前3M行对应系统信息位，后3M行对应校验位
P = H(1:3*M,end-3*M+1:end); % 提取右下角3M×3M的校验子块
Q = H(1:3*M,1:M*K);% 提取左上角3M×(M*K)的系统信息子块
%% 计算生成矩阵核心部分
% 通过矩阵运算生成基础生成矩阵：
% 1. inv_bin(P) 计算P的二进制域逆矩阵（需确保inv_bin函数支持GF(2)运算）
% 2. W = mod(inv_bin(P)*Q, 2)' 生成信息位与校验位的关联矩阵
% 3. IMK为单位矩阵，构成生成矩阵的系统信息部分
W = mod(inv_bin(P)*Q,2)';
IMK = eye(M*K);
G = [IMK W];% 初始生成矩阵结构
%% 构建准循环结构
% 确定非零元素起始行（每隔M/4行填充）
rowNum = 1:M/4:1+M*K-M/4;% 间隔为M/4的行索引序列
% 初始化QC格式生成矩阵
Gqc = zeros(size(G));
% 复制基础结构到目标矩阵
Gqc(rowNum,:) = G(rowNum,:);
%% 填充循环移位模式
% 按照CCSDS标准准循环结构进行元素移位：
% 外层循环：覆盖所有扩展块（共4K+12个移位单元）
% 内层循环：每个块内进行M/4-1次循环右移
for m = 1:4*K+12
    for n = 1:M/4-1
        % 对指定列区间进行循环右移n位
        % 移位操作保持QC结构特性，仅改变列位置不改变非零元素密度
        Gqc(rowNum+n,M/4*(m-1)+1:M/4*m) = circshift(G(rowNum,M/4*(m-1)+1:M/4*m),n,2);
    end
end
%% 可视化验证
figure
spy(Gqc);% 绘制非零元素分布图


hold on;
% 绘制QC结构网格：
% - 垂直网格：每M列一个块（共K+2个信息块）
% - 水平网格：每M行一个信息块（共K个信息块）
gridG = zeros(size(G));
gridG(M:M:(K-1)*M,:) = 1;
gridG(:,M:M:(K+2)*M) = 1;
spy(gridG,'r',4);
hold off;

end

