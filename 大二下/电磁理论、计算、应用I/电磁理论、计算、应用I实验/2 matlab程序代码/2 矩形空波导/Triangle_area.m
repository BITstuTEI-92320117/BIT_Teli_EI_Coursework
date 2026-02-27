function s = Triangle_area(x,y)

    % 计算三角形面积
    s = 0.5 * abs((x(1)-x(3))*(y(2)-y(3)) - (x(2)-x(3))*(y(1)-y(3)));
    
return