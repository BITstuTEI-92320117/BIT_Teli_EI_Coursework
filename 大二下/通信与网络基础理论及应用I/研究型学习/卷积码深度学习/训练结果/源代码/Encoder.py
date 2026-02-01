import numpy as np
import torch
generator_polynomials = {
    0: [0b1101011, 0b1111001],  # 标签0的生成多项式（约束长度7）
    1: [0b1100101, 0b1111101],  # 标签1的生成多项式
    2: [0b1001111, 0b1101101],  # 标签2的生成多项式
    3: [0b1010111, 0b1110101]   # 标签3的生成多项式
}

def encode(bits, generators, constraint_length=7):
    """
    卷积码编码函数
    :param bits: 输入比特序列（一维数组，0/1值）
    :param generators: 生成器多项式列表（十进制表示）
    :param constraint_length: 约束长度（决定移位寄存器长度，默认7）
    :return: 编码后的比特流（numpy数组，长度为len(bits)*len(generators)）
    """
    encoded = []  # 存储编码后的比特
    shift_register = [0] * constraint_length  # 初始化移位寄存器（全0）
    for bit in bits:
        # 更新移位寄存器：新比特插入首位，其余右移（模拟移位操作）
        shift_register = [bit] + shift_register[:-1]
        outputs = []  # 存储当前比特的两个输出
        for g in generators:  # 遍历每个生成器多项式
            xor_sum = 0
            for i in range(constraint_length):  # 逐位检查生成器掩码
                # 将生成器多项式转换为二进制掩码，确定哪些位参与异或
                mask = (g >> (6 - i)) & 1  # 例如，g=0b1101011对应i从0到6的掩码位
                xor_sum0 = shift_register[i] & mask  # 当前寄存器位与掩码位按位与
                xor_sum = xor_sum ^ xor_sum0  # 异或累加
            outputs.append(xor_sum % 2)  # 取模2得到输出比特
        encoded.extend(outputs)  # 将两个输出比特添加到编码流
    return np.array(encoded)  # 转换为numpy数组

def generate_dataset(ber = -1, num_samples=1000, seq_length=900):
    """
    生成训练/测试数据集，包含带噪声的编码序列和对应标签
    :param ber:
    :param num_samples: 样本数量
    :param seq_length: 输入比特序列长度（编码后长度为seq_length*2）
    :return: 特征张量X和标签张量y
    """
    X = []
    y = []
    for _ in range(num_samples):
        # 随机选择标签（0-3）
        label = np.random.randint(0, 4)
        generators = generator_polynomials[label]  # 获取对应生成器
        # 生成随机输入比特序列（0/1）
        bits = np.random.randint(0, 2, seq_length)
        encoded = encode(bits, generators)  # 编码得到200长度序列（2倍）
        # 模拟信道误码：按ber概率翻转比特
        if ber == -1:
            ber = np.random.uniform(0, 0.1)
        # 生成误码掩码（1表示该位出错）
        mask = np.random.choice(
            [0, 1],
            size=encoded.shape,
            p=[1 - ber, ber]  # 误码概率为ber
        )
        # 添加误码：异或操作（0+0=0, 0+1=1, 1+1=0）
        corrupted = (encoded + mask) % 2
        X.append(corrupted.astype(np.float32))  # 转换为float32类型
        y.append(label)
    # 转换为PyTorch张量
    return torch.tensor(np.array(X)), torch.tensor(np.array(y))
