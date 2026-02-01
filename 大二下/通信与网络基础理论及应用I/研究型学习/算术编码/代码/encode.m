function [B,C,cnt]=encode(A,k)
% 编码函数
% k是分块尺寸
% 对矩阵A进行按行算术编码
% C为A的每一行得到的算术编码
% B为A的每一行算术编码的二进制小数通过累乘k*k得到的整数，可方便后续译码
% B,C均为k*1向量
[r,c]=size(A);
B={};
% 求得概率的分母一定是2的幂次
pr=probibility(A);
low=0;%区间下界
high=1;%区间上界
cnt=0;
C={};
% 对矩阵A进行逐行算术编码
% 为避免浮点精度的影响，在每次编码后都乘k*k。
% 这相当于二进制数小数点的移动，将得到的小数上下限转化为整数
for i=1:r
    x=A(i,:);
    low=0;
    high=1;
    for j=1:c
        if x(j)==0
            high=high-(high-low)*pr(2);
            high=high*k*k;
            low=low*k*k;
        else
            low=low+(high-low)*pr(1);
            high=high*k*k;
            low=low*k*k;
        end
    end
    [x1,x2]=dec22bin(high,low,k);
    cnt=cnt+length(x1);
    B=[B;x2];
    C=[C;x1];
end
end