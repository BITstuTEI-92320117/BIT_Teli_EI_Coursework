import matplotlib.pyplot as plt
import torch
from torch.utils.data import DataLoader, TensorDataset
import numpy as np
from ConvCodeClassifier import ConvCodeClassifier
from dataset import dataset
import train_and_test
# 加载已训练的模型
torch.serialization.add_safe_globals([ConvCodeClassifier])
best_model = torch.load('best_model.pth', weights_only=False)
best_model.cuda()  # 移至GPU
criterion = torch.nn.CrossEntropyLoss(label_smoothing=0.1)  # 标签平滑防止过拟合
# 对0-0.2的误码率进行测试
Pe = np.linspace(0, 0.2, num=21)
accuracies = []
# 保存预测结果到文件
with open("predictions.txt", "w", encoding="utf-8") as f1:
    # 初始化数据
    for i in Pe:
        f1.write(f"The bit error rate is: {100 * i:.0f}%\n")
        # 生成预测数据集（1000样本）
        X_prediction, y_prediction = dataset(mode = "generate", length = 1000, save = "N", ber = i)
        test_dataset1 = TensorDataset(X_prediction, y_prediction)
        test_loader1 = DataLoader(
            dataset=test_dataset1,
            batch_size=64,
            shuffle=False,
            pin_memory=True
        )
        loss_test = 0
        accuracy = 0
        predictions = torch.zeros(1000)  # 存储最终预测集的预测结果
        # 预测阶段
        for j, (images, labels) in enumerate(test_loader1):
            images = images.cuda()
            labels = labels.cuda()
            with torch.no_grad():  # 不计算梯度
                outputs = best_model(images)
                _, preds = outputs.max(1)
            labels = labels.to(torch.long)
            # 计算测试损失
            loss_test += criterion(outputs, labels)
            total = y_prediction.size(0)
            # 计算准确率
            accuracy += (preds == labels).sum().item()
            # 保存预测结果
            if j < 1000 // 64:
                predictions[64 * j:64 * (j + 1)] = preds
            else:
                predictions[64 * j:] = preds
        # 计算平均预测损失和准确率
        accuracy = accuracy / len(X_prediction)
        accuracies.append(accuracy)
        loss_test = loss_test / (len(X_prediction)//64)
        print(f"Pe: {100 * i:.0f}% | Prediction Loss: {loss_test.item():.4f} | Accuracy: {100 * accuracy:.1f}%")
        for idx, pred in enumerate(predictions):
            f1.write(f"{idx}:样本{idx + 1}的预测标签（{int(pred.item())}）\n")
        f1.write(f"Prediction Loss: {loss_test.item():.4f} | Accuracy: {100 * accuracy:.1f}%\n\n")

# 作出预测正确率随误码率变化曲线
plt.figure()
plt.plot(Pe, accuracies, 'b', marker='o',label='Accuracy-Pe Curve', linestyle='-', linewidth=2, markersize=5)
plt.xlabel('Pe', fontsize=12)
plt.ylabel('Accuracies', fontsize=12)
plt.xlim(0 ,0.2)
plt.ylim(0 ,1)
PE = np.linspace(0, 0.2, num=11)
plt.xticks(PE)
plt.title('Accuracy-Pe Curve', fontsize=14, pad=20)
plt.grid(True, linestyle='--', alpha=0.7)
plt.legend()
plt.savefig('Accuracy_Pe_Curve', dpi=300, bbox_inches='tight')
plt.show()
# 统计模型参数并保存信息
best_model = torch.load('best_model.pth', weights_only=False)
total_params = sum(p.numel() for p in best_model.parameters())  # 总参数量
trainable_params = sum(p.numel() for p in best_model.parameters() if p.requires_grad)
with open("params0.txt", "w", encoding="utf-8") as f:
    f.write("\n====== 模型结构 ======\n")
    f.write(str(best_model) + "\n\n")

    f.write("\n====== 参数统计 ======\n")
    f.write(f"总参数量：{total_params}\n")
    f.write(f"可训练参数量：{trainable_params}\n")

    f.write("\n====== 训练配置 ======\n")
    f.write(f"训练轮次：{train_and_test.epochs}\n")

    f.write(f"训练时间：{train_and_test.train_time:.4f}s\n")
    f.write("\n====== 预测结果 ======\n")
    for i in range(len(accuracies)):
        f.write(f"误码率为：{Pe[i] * 100:.0f}%，预测集正确率：{100 * accuracies[i]:.1f}%\n")
