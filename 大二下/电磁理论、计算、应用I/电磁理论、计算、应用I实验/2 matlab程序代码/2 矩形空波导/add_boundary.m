% 添加边界条件，删去矩阵中处于边界处的行和列
function [A,B] = add_boundary(A,B,e)
    
    Nnode = size(A);
    
    inner_node_num = 1:Nnode;
    inner_node_num(e(1,:)) = [];
    
    A = A(inner_node_num,inner_node_num);
    B = B(inner_node_num,inner_node_num);
    
return