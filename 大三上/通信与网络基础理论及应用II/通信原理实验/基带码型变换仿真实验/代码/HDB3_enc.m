function [HDB3_code, HDB3_level] = HDB3_enc(seq, fs)
% HDB3编码：限制连0≤3，插入V/B破坏节，输出编码序列及归零波形
ls = length(seq);          % 序列长度
HDB3_code = zeros(1, ls);  % HDB3电平序列

% 初始化：前非零极性、连0计数、前V码极性
last_one = 1;  % 前一个非零码极性
count = 0;     % 连续0计数
last_V = 1;    % 前一个V码极性

% HDB3编码核心逻辑
for i = 1:ls
    if seq(i) == 1  % 遇1极性反转
        HDB3_code(i) = -last_one;
        last_one = HDB3_code(i);
        count = 0;  % 重置连0计数
    else
        count = count + 1;  % 连0计数+1
        if count == 4  % 连续4个0：插入破坏节
            count = 0;  % 重置计数
            HDB3_code(i) = -last_V;  % V码极性与前V交替
            last_V = HDB3_code(i);
            
            % V码与前非零同极性，否则前3位置B码
            if HDB3_code(i) * last_one == -1
                HDB3_code(i - 3) = HDB3_code(i);
            end
            
            last_one = HDB3_code(i);  % 更新前非零极性
        end
    end
end

% 生成归零编码波形
HDB3_level = RZ(HDB3_code, ls, fs);
end