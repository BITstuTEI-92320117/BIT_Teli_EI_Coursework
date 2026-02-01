% 绘制TE模式的传输图像
function []= Draw_TEmode(t,p,Ez,mode)
    
    % 绘制Ez
    trisurf(t(1:3,:)',p(1,:),p(2,:),0*ones(size(p(2,:))),...
            abs(Ez(:,mode)),'facecolor','interp','edgecolor','none');
    axis equal
    colormap jet
    colorbar
    title('TE mode')
    hold on
   
    % 平面问题，更改视角，方便观察
    view(0,90);
return