import matplotlib.pyplot as plt
import torch
from torch.utils.data import DataLoader, TensorDataset
import numpy as np
from ConvCodeClassifier import ConvCodeClassifier
torch.serialization.add_safe_globals([ConvCodeClassifier])
best_model = torch.load('best_model.pth', weights_only=False)
best_model.cuda()  # 移至GPU
criterion = torch.nn.CrossEntropyLoss(label_smoothing=0.1)  # 标签平滑防止过拟合
# 对0-0.2的误码率进行测试
Pe = np.linspace(0, 0.2, num=21)
accuracies = []
X_prediction = np.loadtxt("test_data.csv", delimiter=",")
y_prediction = np.zeros(1000)
# X_prediction, y_prediction = dataset(mode="generate", ber=0,length=1000,save="NO")
X_prediction = torch.tensor(X_prediction, dtype=torch.float32)
y_prediction = torch.tensor(y_prediction, dtype=torch.float32)
test_dataset1 = TensorDataset(X_prediction, y_prediction)
test_loader1 = DataLoader(
    dataset=test_dataset1,
    batch_size=64,
    shuffle=False,
    pin_memory=True
)
# 保存预测结果到文件
with open("test_data_predictions.txt", "w", encoding="utf-8") as f1:

    predictions = torch.zeros(1000)  # 存储最终预测集的预测结果
    predictions0 = torch.zeros(1000)
    # 预测阶段
    for epoch in range(10):
        for j, (images, labels) in enumerate(test_loader1):
            images = images.cuda()
            labels = labels.cuda()
            with torch.no_grad():  # 不计算梯度
                outputs = best_model(images)
                _, preds = outputs.max(1)

            if j < 1000 // 64:
                predictions[64 * j:64 * (j + 1)] = preds
            else:
                predictions[64 * j:] = preds
        mask = torch.eq(predictions, predictions0)
        mask_count = mask.sum().item()
        if torch.all(mask) or epoch == 0:
            print("OK")
        else:
            print(mask_count)
        for k in range(1000):
            predictions0[k] = predictions[k]

    for idx, pred in enumerate(predictions):
        f1.write(f"{idx}:样本{idx + 1}的预测标签（{int(pred.item())}）\n")
    print("预测结果已保存至test_data_predictions.txt")



