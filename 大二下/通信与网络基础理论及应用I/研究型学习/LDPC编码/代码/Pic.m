function ber = Pic(Pe,No_matrix)
%% LDPC图像传输仿真（修正矩阵乘法错误）
%% 参数设置
tic
M = 512;                % CCSDS标准定义的码字长度参数
RATE = 1/2;             % LDPC码率（编码效率）
fprintf('原误码率(Pe): %.4f\n', Pe);        % 二元对称信道(BSC)的误码概率
MAX_ITER_NUM = 50;      % LDPC译码最大迭代次数
NORM_FACTOR = 0.8;      % Min-Sum算法的归一化因子
imagePath = '1组-灰度图.bmp'; % 输入图像路径

%% 图像预处理（核心步骤1：数据准备）
% 读取图像并转换为灰度格式
img = imread(imagePath);
if size(img, 3) == 3    % 如果是RGB图像
    img = rgb2gray(img);% 转换为灰度图
end

% 图片加噪并可视化
noise_img = add_noise(img,Pe);
figure;
subplot(1,2,1); 
imshow(im2uint8(img), [0 255]); 
title('原始图像');
subplot(1,2,2); 
imshow(im2uint8(noise_img), [0 255]); 
title(sprintf('噪声图像 (Pe=%.4f)', Pe));

img = im2uint8(img);    % 确保数据类型为uint8
[imgHeight, imgWidth] = size(img); % 获取图像尺寸
imgData = img(:);       % 将图像展开为列向量

% 将像素值转换为二进制流（每个像素8bit，MSB优先）
infoBits = de2bi(imgData, 8, 'left-msb')'; % 转置为8列矩阵
infoBits = infoBits(:)'; % 展开为1维二进制序列

%% LDPC矩阵生成（核心步骤2：编码准备）
% 生成CCSDS标准校验矩阵H和生成矩阵G
if (No_matrix == 0)
    disp("根据 CCSDS 标准（2006版）生成 LDPC 码的校验矩阵 H 和生成矩阵 G")
    H = ccsdscheckmatrix(M, RATE);  % 生成校验矩阵
    G = ccsdsgeneratematrix(H, M, RATE); % 生成生成矩阵
else
    disp("根据 CCSDS 标准（2007版）生成 LDPC 码的校验矩阵 H 和生成矩阵 G")
    H = ccsdscheckmatrix2(M, RATE);
    G = ccsdsgeneratematrix2( H,M,RATE );
end
G = double(G);          % 关键修正：将逻辑矩阵转为数值型以支持矩阵运算
[K, N] = size(G);       % 获取生成矩阵维度（K信息位，N码长）
assert(N == size(H,2), '校验矩阵H与生成矩阵G维度不匹配!'); % 维度校验

%% 校验矩阵预处理（加速译码）
% 建立校验节点的行列索引关系
[r_mark, c_mark] = find(H); % 找到H矩阵中所有1的位置坐标
HColNum = sum(H, 1);    % 每列的校验节点数（变量节点度数）
HRowNum = cell(1, size(H, 1)); % 初始化行索引存储单元
for rowH = 1:size(H, 1)
    HRowNum{rowH} = find(r_mark == rowH); % 记录每行对应的列索引
end

%% 分块编码（核心步骤3：LDPC编码）
numBlocks = ceil(length(infoBits) / K); % 计算需要的分块数量
padBits = numBlocks*K - length(infoBits); % 计算需要填充的比特数
infoBitsPadded = [infoBits, zeros(1, padBits)]; % 填充0保证完整分块

encodedBits = zeros(1, numBlocks*N); % 预分配编码结果空间
for i = 1:numBlocks
    % 获取当前数据块并转换为double类型（矩阵运算需要）
    block = double(infoBitsPadded((i-1)*K+1 : i*K)); 
    % 执行模2矩阵乘法（核心编码操作）
    encodedBlock = mod(block * G, 2); 
    % 存储编码结果
    encodedBits((i-1)*N+1 : i*N) = encodedBlock;
end

%% 信道模拟（核心步骤4：噪声添加）
receivedBits = add_noise(encodedBits,Pe);

%% LDPC译码（核心步骤5：迭代译码）
decodedBits = zeros(1, numBlocks*K); % 预分配译码结果空间
for i = 1:numBlocks
    % 提取当前接收码块
    rxSignal = receivedBits((i-1)*N+1 : i*N);
    % 计算对数似然比（BSC信道下LLR计算）
    llr = (-1).^rxSignal; % 0->1, 1->-1
    % 执行Min-Sum译码算法
    [~, decodedBlock] = ldpcdecoderminsum(...
        H, HRowNum, HColNum, llr, MAX_ITER_NUM, NORM_FACTOR); 
    % 存储译码结果中的信息位
    decodedBits((i-1)*K+1 : i*K) = decodedBlock(1:K);
end
decodedBits = decodedBits(1:end-padBits); % 去除填充的冗余比特

%% 图像恢复与性能评估（核心步骤6：结果处理）
% 尝试重构图像二进制矩阵
try
    imgDecoded = reshape(decodedBits, 8, [])'; % 8bit/像素
catch % 处理长度不匹配情况
    padImg = 8 - mod(length(decodedBits), 8);
    decodedBits = [decodedBits, zeros(1, padImg)]; % 尾部填充
    imgDecoded = reshape(decodedBits, 8, [])';
end
% 二进制转十进制像素值
imgRecovered = bi2de(imgDecoded, 'left-msb');
% 重构图像矩阵
imgRecovered = reshape(imgRecovered, imgHeight, imgWidth);

% 计算比特误码率（BER）
ber = sum(decodedBits(1:length(infoBits)) ~= infoBits) / length(infoBits);

%% 结果可视化
figure;
subplot(1,2,1); 
imshow(img, [0 255]); 
title('原始图像');
subplot(1,2,2); 
imshow(uint8(imgRecovered), [0 255]); 
title(sprintf('恢复图像 (BER=%.4f)', ber));
fprintf('信道编译码后的误码率(BER): %.4f\n', ber);
toc
fprintf('\n')
end