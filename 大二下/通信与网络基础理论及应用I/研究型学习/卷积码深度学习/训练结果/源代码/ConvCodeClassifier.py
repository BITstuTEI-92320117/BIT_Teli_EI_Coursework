import torch.nn as nn
class ConvCodeClassifier(nn.Module):
    """卷积神经网络分类器，用于识别不同卷积码生成的序列"""
    def __init__(self, input_length=1800):
        super().__init__()
        self.features = nn.Sequential(
            # 第一层卷积：输入通道1，输出64，卷积核15，填充7保持长度
            nn.Conv1d(in_channels=1, out_channels=64, kernel_size=15, padding=7),
            nn.BatchNorm1d(64),  # 批归一化
            nn.ReLU(),  # 激活函数
            nn.MaxPool1d(2),  # 最大池化，长度减半

            # 第二层卷积：输入64，输出128，核9，填充4
            nn.Conv1d(64, 128, kernel_size=9, padding=4),
            nn.BatchNorm1d(128),
            nn.ReLU(),
            nn.MaxPool1d(2),  # 长度再减半 → 200/2/2=50

            # 第三层卷积：输入128，输出256，核5，填充2
            nn.Conv1d(128, 256, kernel_size=5, padding=2),
            nn.BatchNorm1d(256),
            nn.ReLU(),
            nn.AdaptiveAvgPool1d(1)  # 自适应平均池化到长度1 → 256维特征向量
        )
        self.classifier = nn.Sequential(
            nn.Linear(256, 128),  # 全连接层
            nn.Dropout(0.5),  # Dropout防止过拟合
            nn.ReLU(),
            nn.Linear(128, 4)  # 输出4类（对应4种生成器）
        )

    def forward(self, x):
        # 输入形状：(batch_size, input_length) → 添加通道维度 → (batch_size, 1, input_length)
        x = x.unsqueeze(1)
        x = self.features(x)  # 经过卷积层 → (batch_size, 256, 1)
        x = x.view(x.size(0), -1)  # 展平 → (batch_size, 256)
        return self.classifier(x)  # 分类 → (batch_size, 4)