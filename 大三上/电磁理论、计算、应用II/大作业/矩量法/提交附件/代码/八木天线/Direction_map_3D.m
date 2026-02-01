function Direction_map_3D(D, lr, ls, ld, ld_num, dr, ds, flag)
%% 根据电场分布绘制三维方向图
if flag == 1
    figure(3);
    M = size(D, 1) - 1;
    D = DN(D) ;
    [theta, phi] = meshgrid(0: pi/M: pi, 0: pi/M: 2*pi);
    [x,y,z] = sph2cart(phi,pi/2 - theta, D');
    mesh(x,y,z);
    title('八木天线辐射场的三维方向图','FontSize', 12);
    xlabel('x');
    ylabel('y');
    zlabel('F(θ,φ)');
    set(gcf, 'Color', 'white');
    set(gca, 'Color', [0.98, 0.98, 0.98]);
    % 合适的观察角度
    view(60,60);
    pname = sprintf('八木天线辐射场的三维方向图(lr=%gm,ls=%gm,ld=%gm,ld_num=%dm,dr=%gm,ds=%gm).png' ...
        ,lr, ls, ld, ld_num, dr, ds);
    saveas(gcf,pname)
end
end