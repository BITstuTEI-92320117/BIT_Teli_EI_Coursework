% 求TM特征值
function [Ez,kc]= TM_mode(A,B,e,num)

    [A,B] = add_boundary(A,B,e);

    % 转为稀疏矩阵提高运算速度
    A = sparse(A);
    B = sparse(B);
    
    [Ez,D]= eigs(A,B,num,'smallestabs');
    kc = abs(diag(D).^0.5);                 % 提取出特征值
  
return