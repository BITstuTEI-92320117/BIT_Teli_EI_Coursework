function [AMI_code, AMI_level] = AMI_enc(seq, fs)
% AMI编码：1交替为+1/-1，0为0，输出编码序列及归零波形
ls = length(seq); % 序列长度
AMI_code = zeros(1, ls); % AMI电平序列
code = 1; % 初始极性

% 电平分配：1交替翻转，0保持0
for i = 1:ls
    if seq(i) == 1
        AMI_code(i) = code;
        code = -code;  % 极性交替
    else
        AMI_code(i) = 0;
    end
end

% 生成归零编码波形
AMI_level = RZ(AMI_code, ls, fs);
end