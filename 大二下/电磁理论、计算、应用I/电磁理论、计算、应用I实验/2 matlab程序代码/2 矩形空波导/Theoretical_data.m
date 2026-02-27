% 计算空波本征值理论值
a = 0.4572;
b = 0.2286;
m = 0:8;
n = 0:5;
kc = zeros(9,6);
for i = 1:9
    for j = 1:6
        kc(i,j) = pi*((m(i)/a)^2+(n(j)/b)^2)^0.5;
    end
end
disp(kc);