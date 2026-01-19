% 读取图片数据
I=imread('图片1.bmp');
figure,imshow(I);
% 将图片变为一通道
J=rgb2gray(I);
figure,imshow(J);
imwrite(J,'1组-灰度图.bmp');
% 定义相关常数
k=8;
m=256/k;
A2=zeros(256,256);
B={};
C={};
Zip=cell(m,m,k);
cnt=0;
% 灰度图矩阵只有0和255两种编码
b=unique(J);
% 将矩阵进行k*k分块编码，对分的每一块按行进行算术编码
for i=1:m
    for j=1:m
        A(i,j,:,:)=J(1+k*(i-1):k*i,1+k*(j-1):k*j);
        A0=J(1+k*(i-1):k*i,1+k*(j-1):k*j);
        % 调试语句
        % kk=(i-1)*m+j;
        % if kk==35
        %     debug=0;
        % end
        [B0,C0,cnt0]=encode(A0,k);
        B=[B;B0];
        C=[C;C0];
        cnt=cnt+cnt0;
    end
end
% 计算压缩比
y=(256*256*8)/cnt;
fprintf('压缩比为: %.2f%/n', y);
disp(' ');
% 将得到的二进制算术编码写入文件
% 其中Zip(i,j,:)为原图像矩阵中第i行第j列的分块矩阵的按行二进制算术编码
for i=1:m
    for j=1:m
        D=C(k*((i-1)*m+j-1)+1:k*((i-1)*m+j-1)+k);
        Zip(i,j,:)=D;
    end
end
save('二进制算术编码.mat', 'Zip');
disp('二进制算术编码已写入文件"二进制算术编码.mat”');
% 分块译码
% 对算术编码进行译码，A2为译码后的图像矩阵
for i=1:m
    for j=1:m
        % 调试语句
        % kk=(i-1)*m+j;
        % if kk==35
        %     debug=0;
        % end
        A0=J(1+k*(i-1):k*i,1+k*(j-1):k*j);
        x=B(k*((i-1)*m+j-1)+1:k*((i-1)*m+j-1)+k);
        A1=decode(A0,k,x);
        A2(1+k*(i-1):k*i,1+k*(j-1):k*j)=A1;
    end
end
% 计算失真率
A2=uint8(A2);
yl=length(find(A2-J))/256*256;
fprintf('失真率为: %.2f%%\n', yl * 100);
% 输出解压缩图片
figure,imshow(A2);
imwrite(A2,'译码-灰度图.bmp');
disp('解压缩图片已写入文件“译码-灰度图.bmp”');