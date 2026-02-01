clear, clc, close all
rng(1120232075)  % 固定随机种子，结果可复现
exp = 1; % 实验编号
if exp == 1
    % 实验1：固定0概率p=0.7
    N = 1000;       % 序列长度
    p = 0.7;        % 0出现概率
    fs = 8;         % 采样率（符号率8倍）
    N_draw = 20;    % 绘图符号数
    seq = gen_seq(N, p); % 生成二进制序列
    nfft = 1024;    % FFT长度
    win = hanning(nfft); % 汉宁窗：降低频谱泄漏

    % 绘制前20位信源序列及非归零波形
    figure('Name','前20位信源序列及其非归零波形','Color','white');
    subplot(2,1,1);
    seq_plot = seq(1:N_draw);
    stem(1:N_draw, seq_plot, 'filled', 'MarkerFaceColor','b', 'LineWidth', 1.5, 'Color', 'b');
    xlim([1,N_draw])
    title('前20位信源序列');
    xlabel('符号位置'); ylabel('值(0/1)');
    xticks(1:N_draw)
    grid on;
    seq_level = NRZ(seq, length(seq), fs);
    level_plot = seq_level(1:N_draw*fs);
    subplot(2,1,2);
    plot(0:length(level_plot)-1, level_plot, 'LineWidth',1.5, 'Color', 'b');
    title('前20位信源序列非归零波形');
    xlabel('采样点'); ylabel('电平');
    grid on;
    saveas(gcf, '前20位信源序列及其非归零波形.png')

    % AMI编码与绘图
    [AMI_code, AMI_level] = AMI_enc(seq, fs);
    draw(seq, AMI_code, AMI_level, 'AMI', N_draw, fs);
    % AMI功率谱估计（重叠512，中心频率）
    [P_AMI, f_AMI] = pwelch(AMI_level, win, nfft/2, nfft, fs, 'centered');

    % HDB3编码与绘图
    [HDB3_code, HDB3_level] = HDB3_enc(seq, fs);
    draw(seq, HDB3_code, HDB3_level, 'HDB3', N_draw, fs);
    % HDB3功率谱估计
    [P_HDB3, f_HDB3] = pwelch(HDB3_level, win, nfft/2, nfft, fs, 'centered');

    % 功率谱对比图
    [P_seq, f_seq] = pwelch(seq_level, win, nfft/2, nfft, fs, 'centered');
    figure('Name', '原序列、AMI码和HDB3码的功率谱密度对比图','Color','white');
    hold on;
    plot(f_seq, 10*log10(P_seq), 'b-', 'LineWidth', 1.2);
    plot(f_AMI, 10*log10(P_AMI), 'r-', 'LineWidth', 1.2);
    plot(f_HDB3, 10*log10(P_HDB3), 'g-', 'LineWidth', 1.2);
    xlabel('频率 (Hz)','FontSize', 11);
    ylabel('归一化功率谱 (dB)', 'FontSize', 11);
    title('原序列、AMI码和HDB3码的功率谱密度对比图', 'FontSize', 12)
    legend('原序列', 'AMI', 'HDB3', 'FontSize', 10);
    grid on;
    hold off
    box on
    saveas(gcf, '原序列、AMI码和HDB3码的功率谱密度对比图.png')
elseif exp == 2
    % 实验2：不同0概率下功率谱分析
    N = 1000;               % 序列长度
    fs = 8;                 % 采样率
    nfft = 1024;            % FFT长度
    win = hanning(nfft);    % 汉宁窗
    p_list = [0.1, 0.3, 0.5, 0.7, 0.9];  % 测试0概率集合
    color_list = ['b', 'r', 'g', 'm', 'y'];  % 曲线颜色
    label_list = {sprintf('p=%.1f', p_list(1)), sprintf('p=%.1f', p_list(2)), ...
        sprintf('p=%.1f', p_list(3)), sprintf('p=%.1f', p_list(4)), ...
        sprintf('p=%.1f', p_list(5))};  % 图例标签

    % 初始化功率谱存储单元
    P_seq_list = cell(1, length(p_list));  % 原码功率谱
    P_AMI_list = cell(1, length(p_list));  % AMI功率谱
    P_HDB3_list = cell(1, length(p_list)); % HDB3功率谱
    f_common = [];  % 共用频率轴

    % 循环计算各概率下功率谱
    for i = 1:length(p_list)
        p = p_list(i);  % 当前0概率

        % 生成序列+非归零波形
        seq = gen_seq(N, p);
        seq_level = NRZ(seq, length(seq), fs);
        % 原码功率谱（转dB）
        [P_seq, f_temp] = pwelch(seq_level, win, nfft/2, nfft, fs, 'centered');
        P_seq_list{i} = 10*log10(P_seq);

        % AMI功率谱
        [~, AMI_level] = AMI_enc(seq, fs);
        [P_AMI, ~] = pwelch(AMI_level, win, nfft/2, nfft, fs, 'centered');
        P_AMI_list{i} = 10*log10(P_AMI);

        % HDB3功率谱
        [~, HDB3_level] = HDB3_enc(seq, fs);
        [P_HDB3, ~] = pwelch(HDB3_level, win, nfft/2, nfft, fs, 'centered');
        P_HDB3_list{i} = 10*log10(P_HDB3);

        % 存储频率轴（仅首次）
        if i == 1
            f_common = f_temp;
        end
    end

    % 绘制原码不同概率功率谱对比
    figure('Name', '原始单极性非归零波形不同"0"概率的功率谱密度对比图','Color','white');
    hold on; grid on;
    for i = 1:length(p_list)
        plot(f_common, P_seq_list{i}, color_list(i), 'LineWidth', 1.2, 'DisplayName', label_list{i});
    end
    xlabel('频率 (Hz)', 'FontSize', 11);
    ylabel('归一化功率谱 (dB)', 'FontSize', 11);
    title('原始单极性非归零波形不同"0"概率的功率谱密度对比图', 'FontSize', 12);
    legend('FontSize', 10);
    ylim([-100, 20]);  % 固定y轴范围
    box on
    saveas(gcf, '原始单极性非归零波形不同0概率的功率谱密度对比图.png')

    % 绘制AMI不同概率功率谱对比
    figure('Name', '归零AMI码不同"0"概率的功率谱密度对比图','Color','white');
    hold on; grid on;
    for i = 1:length(p_list)
        plot(f_common, P_AMI_list{i}, color_list(i), 'LineWidth', 1.2, 'DisplayName', label_list{i});
    end
    xlabel('频率 (Hz)', 'FontSize', 11);
    ylabel('归一化功率谱 (dB)', 'FontSize', 11);
    title('归零AMI码不同"0"概率的功率谱密度对比图', 'FontSize', 12);
    legend('FontSize', 10);
    ylim([-100, 20]);
    box on
    saveas(gcf, '归零AMI码不同0概率的功率谱密度对比图.png')

    % 绘制HDB3不同概率功率谱对比
    figure('Name', '归零HDB3码不同"0"概率的功率谱密度对比图','Color','white');
    hold on; grid on;
    for i = 1:length(p_list)
        plot(f_common, P_HDB3_list{i}, color_list(i), 'LineWidth', 1.2, 'DisplayName', label_list{i});
    end
    xlabel('频率 (Hz)', 'FontSize', 11);
    ylabel('归一化功率谱 (dB)', 'FontSize', 11);
    title('归零HDB3码不同"0"概率的功率谱密度对比图', 'FontSize', 12);
    legend('FontSize', 10);
    ylim([-100, 20]);
    box on
    saveas(gcf, '归零HDB3码不同0概率的功率谱密度对比图.png')
else
    % 实验编号错误提示
    error('该实验不存在！有效实验编号为1,2')
end

