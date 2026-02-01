function plot_Eta(list, Eta, cato)
% 绘制频谱利用率曲线
name = ['频谱利用率随', cato, '变化图'];
figure('Name',name,'Color','w')
plot(list,Eta,'bo-','MarkerSize', 4, 'MarkerFaceColor', 'b', 'LineWidth',1.2)
% 设置标签与标题
xlabel(cato, 'FontSize', 10)
ylabel('频谱利用率', 'FontSize', 10)
xlim([list(1),list(end)])
ylim([1,1.8])
title(name, 'FontSize', 11)
grid on;
box on;
hold off;
saveas(gcf, [name,'.png']); % 保存图片
end