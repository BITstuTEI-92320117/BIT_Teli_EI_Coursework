function [x1,x2]=dec22bin(h,l,k)
% 二进制转换函数
% h，l分别为编码函数求得的上下限
% x1为得到的二进制编码
% x2为编码后转换的二进制数，可以方便后续译码
x1=[];
a=k*2*log2(k);
% 二进制转换
h2=dec2bin(h);
l2=dec2bin(l);
% 将编码函数求得的二进制上下限前面补零，使总位数为49位
% 得到的结果为：第一个数字是原小数上下限的整数部分，后面的数字为小数部分
for i=1:(a+1)-length(h2)
    h2=['0',h2];
end
for i=1:(a+1)-length(l2)
    l2=['0',l2];
end
% 对全0和全255两种极端情况特殊处理
if h==2^a
    x1=[x1,1];
elseif l==0
    x1=[x1,0];
% 一般情况，二进制编码取原小数上下限二进制形式前面相同的数字后再补1
else
    i=1;
    while l2(i)==h2(i)
        x1=[x1,str2double(h2(i))];
        i=i+1;
    end
    x1=[x1,1];
end
% 求得到的算术编码对应的二进制整数，用于后续译码
x2=0;
l0=length(x1);
for i=1:l0
    x2=x2+(2^(a+1-i))*x1(i);
end
x2=dec2bin(x2);
end