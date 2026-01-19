function [error_rating_hrc, error_rating_rectang] = judge(receive_hrc_matched, receive_rectang_matched, osample, sym_num, sym_seq, is_int_os)
% 判决与误码率统计函数
% 输入：receive_hrc_matched-根升余弦匹配滤波输出, receive_rectang_matched-方波匹配滤波输出, osample-过采样率, sym_num-符号数, sym_seq-原始符号序列, is_int_os-是否整数倍过采样
% 输出：error_rating_hrc-根升余弦成形误码率, error_rating_rectang-方波成形误码率

% 整数/非整数倍下采样区分
if is_int_os == 1
    hrc_down = downsample(receive_hrc_matched, osample); % 整数倍下采样
    rect_down = downsample(receive_rectang_matched, osample);
else
    [p, q] = get_simplified_fraction(osample); % 非整数倍：转为最简分数p/q
    hrc_down = resample(receive_hrc_matched, q, p); % 分数倍下采样（1/osample=q/p）
    rect_down = resample(receive_rectang_matched, q, p);
end

% 截取与原始符号数一致的序列
hrc_down = hrc_down(1:sym_num);
rect_down = rect_down(1:sym_num);

% 硬判决：大于0判1（映射为-1），小于等于0判0（映射为-1）
hrc_decision = (hrc_down > 0) .* 2 - 1;
rect_decision = (rect_down > 0) .* 2 - 1;

% 计算误码率（错误符号数/总符号数）
error_rating_hrc = sum(hrc_decision ~= sym_seq) / sym_num;
error_rating_rectang = sum(rect_decision ~= sym_seq) / sym_num;
end