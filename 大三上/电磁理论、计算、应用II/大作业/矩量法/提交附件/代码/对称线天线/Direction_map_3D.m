function Direction_map_3D(D, l, N, flag)
%% 根据电场分布绘制三维方向图
M = size(D, 1) - 1;
D = DN(D) ;
[theta, phi] = meshgrid(0: pi/M: pi, 0: pi/M: 2*pi);
[x,y,z] = sph2cart(phi,pi/2 - theta, D');
mesh(x,y,z);
title('线天线辐射场的三维方向图','FontSize', 12);
xlabel('x');
ylabel('y');
zlabel('F(θ,φ)');
set(gcf, 'Color', 'white');
set(gca, 'Color', [0.98, 0.98, 0.98]);
if flag == 1
    fname = sprintf('线天线辐射场的三维方向图(矩量法l=%gm,N=%d).png' ,l, N);
else
    fname = sprintf('线天线辐射场的三维方向图(传输线模型l=%gm).png' ,l);
end
saveas(gcf,fname)
end