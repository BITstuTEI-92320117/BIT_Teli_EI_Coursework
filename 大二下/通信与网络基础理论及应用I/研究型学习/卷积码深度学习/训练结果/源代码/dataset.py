import numpy as np
import torch
from Encoder import generate_dataset

def dataset(mode, file = "signals.csv", length = 10000000, save = "Y", ber = -1):
    if mode == "generate":
        # 生成数据集（默认10000000样本）并保存到CSV
        X, y = generate_dataset(ber, num_samples = length, seq_length = 900)
        Xn = X.numpy()
        yn = y.numpy()
        yn = yn[:,np.newaxis]  # 添加新维度以拼接
        signals = np.concatenate((Xn,yn),axis=1)
        if save == "Y":
            np.savetxt(
                file,
                signals,
                delimiter=",",
                fmt="%d"  # 整数格式保存
            )

    elif mode == "exist":
    # 从CSV加载数据集
        data = np.loadtxt(file, delimiter=",")
        X = data[..., :-1]  # 最后一列之前是特征
        y = data[..., -1]  # 最后一列是标签
        X = torch.tensor(X, dtype=torch.float32)
        y = torch.tensor(y, dtype=torch.float32)
    return X, y