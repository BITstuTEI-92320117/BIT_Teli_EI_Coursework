% 绘制TM模式的传输图像
function []= Draw_TMmode(t,p,e,Ez,mode)
    
    % 补全Ez
    inner_node = 1:size(p,2);
    inner_node(e(1,:)) = [];
    Ez0(inner_node) = Ez(:,mode);
    Ez0(e(1,:)) = 0;

    % 绘制Ez
    trisurf(t(1:3,:)',p(1,:),p(2,:),0*ones(size(p(2,:))),...
            abs(Ez0),'facecolor','interp','edgecolor','none');
    axis equal
    colormap jet
    colorbar
    title('TM mode')
    hold on
   
    % 平面问题，更改视角，方便观察
    view(0,90);
return