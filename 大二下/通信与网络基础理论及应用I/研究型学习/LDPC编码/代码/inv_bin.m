function [ out ] = inv_bin( in )
% INV_BIN 计算二进制域 GF(2) 上的矩阵逆（高斯-约旦消元法）
% 输入:
%   in  - 二进制方阵（元素取0或1）
% 输出:
%   out - 输入矩阵的逆矩阵（在GF(2)下），若不可逆则结果无效
% 注意:
%   1. 当矩阵不可逆时，输出矩阵无意义
%   2. 通过行交换处理主元为零的情况，可能引入随机性

[m, n] = size(in);
if m ~= n
    fprintf('m~=n\n');
    return;
end

E = eye(m); % 初始化单位矩阵，最终将转换为逆矩阵

%% 高斯-约旦消元（二进制域）
for i = 1:m  % 主循环：逐列进行高斯消元（共m列）
    % ========== 步骤1：选主元 ==========
    % 寻找第i列中非零元素的行索引（仅考虑当前行及下方行）
    noneZerosIndex = find(in(:,i));               % 获取第i列所有非零行索引
    noneZerosIndex = noneZerosIndex(find(noneZerosIndex>=i)); % 筛选>=i的行（避免处理已消元的行）
    
    % 处理全零列特殊情况
    if(length(noneZerosIndex)==0)                 % 若当前列下方全为0
        randIndex = randi([i+1,m],1);             % 随机选择i+1到m之间的行索引
        % 列交换：将随机列换到当前列位置（避免消元失败）
        temp = in(:,i);
        in(:,i) = in(:,randIndex);                % 交换in矩阵的列
        in(:,randIndex) = temp;       
        temp = E(:,i);
        E(:,i) = E(:,randIndex);                 % 同步交换E矩阵的列
        E(:,randIndex) = temp;
    end
    
    % ========== 步骤2：行交换 ==========
    id1 = noneZerosIndex(1);                      % 取第一个非零元素的行作为主元
    % 行交换：将主元行换到当前处理行i的位置
    temp = in(i,:);
    in(i,:) = in(id1,:);                          % 交换in矩阵的行
    in(id1,:) = temp;
    temp = E(i,:);
    E(i,:) = E(id1,:);                            % 同步交换E矩阵的行
    E(id1,:) = temp;
    
    % ========== 步骤3：消元操作 ==========
    noneZerosIndex = find(in(:,i));                % 重新获取第i列非零行索引
    for cc = 1:length(noneZerosIndex)              % 遍历所有非零行
        if(noneZerosIndex(cc)~=i)                 % 排除主元行自身
            % 行相加模2运算：将其他行的第i列元素清零
            temp = mod(in(noneZerosIndex(cc),:) + in(i,:) , 2);  % 消去in矩阵
            in(noneZerosIndex(cc),:) = temp;
            temp = mod(E(noneZerosIndex(cc),:) + E(i,:) , 2);    % 同步操作E矩阵
            E(noneZerosIndex(cc),:) = temp;
        end
    end
end

out = E;  % 返回记录所有行变换操作的矩阵
end