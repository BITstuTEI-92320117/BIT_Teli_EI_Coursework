function A1=decode(A0,k,x)
% 解码函数
% x为A0的每一行算术编码的二进制小数通过累乘k*k得到的整数
a=k*2*log2(k);
p=probibility(A0);
high_r=2^a;
low_r=0;
rec=zeros(1,k);
A1=zeros(k,k);

for i=1:k
    r=x{i};
    r=bin2dec(r);
    high_r=2^a;
    low_r=0;
    for j=1:k
        if r==2^a
            rec=255*ones(1,k);
        elseif r==0
            rec=zeros(1,k);
        else
            m=low_r+(high_r-low_r)*p(1);
            if m<r
                rec(j)=255;
                low_r=low_r+(high_r-low_r)*p(1);
            else
                rec(j)=0;
                high_r=high_r-(high_r-low_r)*p(2);
            end
        end
        A1(i,:)=rec;
    end
end
end