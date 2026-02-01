% 算矩阵
function [A,B]= fill_matrix(p,t)
    
    n = size(p,2);
    A = zeros(n,n);
    B = zeros(n,n);
    
    for m = 1:size(t,2)
        x = p(1,t(1:3,m));  % 计算小三角形顶点的全局坐标
        y = p(2,t(1:3,m));

        L = [2,3;3,1;1,2];
        
        % 计算小三角形面积
        s = Triangle_area(x,y);
        
        % 矩阵组装
        for i = 1:3
            bi = y(L(i,1))-y(L(i,2));
            ci = x(L(i,2))-x(L(i,1));
            for j = 1:3
                bj = y(L(j,1))-y(L(j,2));
                cj = x(L(j,2))-x(L(j,1));

                % 填充A矩阵
                A(t(i,m),t(j,m)) = A(t(i,m),t(j,m)) + (bi*bj+ci*cj)/(4*s);

                % 填充B矩阵
                B(t(i,m),t(j,m)) = B(t(i,m),t(j,m)) + (1+derta(i,j))*s/12;
            end
        end
    end
    
return