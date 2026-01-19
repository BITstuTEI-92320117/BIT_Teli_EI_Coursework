% 求TE特征值
function [Ez,kc]= TE_mode(A,B,num)

    % 转为稀疏矩阵提高运算速度
    A = sparse(A);
    B = sparse(B);
    
    [Ez,D]= eigs(A,B,num+1,'smallestabs');
    kc = abs(diag(D).^0.5);                 % 提取出特征值
    
    % 第一个为0，删去
    kc(1) = [];
    Ez(:,1) = [];
    
return