function [ iter,decoderData ] = ldpcdecoderminsum(H,HRowNum,HColNum,receiveSignal,MAX_ITER_NUM,NORM_FACTOR)
%LDPCC解码器，基于最小和(Min-Sum)算法
% 输入参数：
%   H: LDPC校验矩阵 (M行N列)
%   HRowNum: 行索引集合 (元胞数组，每个元素为对应行的非零元素列坐标)
%   HColNum: 列权重向量 (1xN向量，每列非零元素个数)
%   receiveSignal: 接收信道软信息 (1xN向量)
%   MAX_ITER_NUM: 最大迭代次数
%   NORM_FACTOR: 归一化因子 (用于校验节点更新，减小最小和算法误差)
% 输出参数：
%   iter: 实际迭代次数
%   decderData: 解码结果 (1xN二进制向量)

[~,N] = size(H);      % 获取码字长度N   

vl = receiveSignal;   % 初始化变量节点信息为接收的软信息
decoderData = zeros(1,N); % 初始化解码结果

% 初始化消息矩阵：vml(变量->校验), uml(校验->变量)
uml = zeros(1,sum(HColNum)); % 总消息数=校验矩阵非零元素总数
vml = uml;                   % 初始化vml为与uml同尺寸的零向量

% 变量节点初始化：将接收信号值填充到对应的消息位置
ColStart = 1;% 列起始指针初始化
for L=1:length(HColNum)
    % 将当前变量节点对应的所有校验边初始化为接收信号值
    vml(ColStart:ColStart+HColNum(L)-1) = vl(L);
    ColStart = ColStart+HColNum(L); % 更新列起始指针
end

% 主迭代循环
for iter=1:MAX_ITER_NUM
    %% 校验节点处理阶段 (水平步骤)
    for L=1:length(HRowNum)   % 遍历所有校验节点(行处理)
        L_col = HRowNum{L};   % 获取当前校验行连接的所有变量节点索引
        vmltemp = vml(L_col); % 提取当前校验行对应的变量节点消息
        
        % 符号处理：计算所有输入消息符号的乘积        
        vmlMark = ones(size(vmltemp));
        vmlMark(vmltemp<0) = -1;      % 将负值标记为-1
        vmlMark = prod(vmlMark);      % 计算符号乘积

        % 幅度处理：找出最小和次小绝对值
        minvml = sort(abs(vmltemp)); % 对绝对值升序排序

        % 校验节点消息更新 (最小和算法核心)
        % 遍历当前校验节点连接的所有变量节点消息（每个变量节点对应一个列索引）
        for L_col_i = 1:length(L_col)
            % 判断当前消息是否为绝对值最小的消息
            if minvml(1)==abs(vmltemp(L_col_i))
                % 当当前消息是最小值时：
                if vmltemp(L_col_i)<0
                    % 情况：原消息为负，使用次小值并恢复符号
                    % 符号逻辑：总符号vmlMark * (-1)（原消息符号） → -vmlMark
                    % 幅度取次小值minvml(2)
                    vmltemp(L_col_i) = -vmlMark*minvml(2);
                else
                    % 情况：原消息为正，使用次小值并恢复符号
                    % 符号保持总符号vmlMark
                    % 幅度取次小值minvml(2)
                    vmltemp(L_col_i) = vmlMark*minvml(2);
                end
            else
                % 当当前消息不是最小值时：
                if vmltemp(L_col_i)<0
                    % 情况：原消息为负，使用最小值并恢复符号
                    % 符号逻辑：总符号vmlMark * (-1) → -vmlMark
                    % 幅度取最小值minvml(1)
                    vmltemp(L_col_i) = -vmlMark*minvml(1);
                else
                    % 情况：原消息为正，使用最小值并恢复符号
                    % 符号保持总符号vmlMark
                    % 幅度取最小值minvml(1)
                    vmltemp(L_col_i) = vmlMark*minvml(1);
                end
            end
        end

        % 应用归一化因子并存储校验节点消息
        uml(L_col) = NORM_FACTOR*vmltemp;
    end

    %% 变量节点处理阶段 (垂直步骤)
    ColStart = 1;      % 列起始指针重置
    qn0_1 = ones(1,N); % 初始化后验概率比(用于最终判决)

    for L=1:length(HColNum) % 遍历所有变量节点
        % 提取当前变量节点对应的所有校验节点消息
        umltemp = uml(ColStart:ColStart+HColNum(L)-1);
        
        % 计算总外部信息(所有校验消息之和)
        temp = sum(umltemp);

        % 更新后验概率：总外部信息 + 初始接收信息
        qn0_1(L) = temp + vl(L);

        % 变量节点消息更新：总外部信息 - 当前校验消息 + 接收信息
        umltemp = temp - umltemp;    % 排除自环信息
        vml(ColStart:ColStart+HColNum(L)-1) = umltemp + vl(L);
        
        ColStart = ColStart+HColNum(L); % 更新列起始指针
    end

    %% 硬判决与校验
    decoderData(qn0_1>=0) = 0;% LLR非负判为0
    decoderData(qn0_1<0) = 1; % LLR负判为1

    % 校验是否满足所有校验方程 (H*x'=0 mod 2)
    if(mod(H*decoderData',2)==0)
        break; % 校验成功则提前退出迭代
    end
end


