# 导入必要的库
import time
import matplotlib.pyplot as plt
import torch
import torch.nn as nn
from torch.utils.data import DataLoader, TensorDataset
from torchsummary import summary
from torchview import draw_graph
from ConvCodeClassifier import ConvCodeClassifier
from dataset import dataset

# 可视化神经网络结构
model0 = ConvCodeClassifier(input_length=1800)
dummy_input = torch.randn(1, 1800)  # 生成随机输入样本
output = model0(dummy_input)  # 前向传播测试
# 绘制模型结构图并保存为PNG
graph = draw_graph(
    model0,
    input_data=dummy_input,
    graph_name="Neural_Network_Model",
    expand_nested=True  # 展开嵌套结构
)
graph.visual_graph.render(format='png', view=True)

start0 = time.time()
# 生成训练数据集（10000000样本）并保存到CSV，如果已生成数据集可以注释掉这行语句
X_train, y_train = dataset("generate", "train_signals.csv", 10000000)
# 加载训练集数据，如事先已生成则可取消注释这行语句，直接读取CSV文件，否则需要生成
# X_train, y_train = dataset("exist", "train_signals.csv")
train_dataset = TensorDataset(X_train, y_train)
train_loader = DataLoader(
    dataset=train_dataset,
    batch_size=64,
    shuffle=True,  # 打乱数据
    pin_memory=True  # 加速GPU传输
)

# 生成测试数据集（2000000样本）并保存到CSV，如果已生成数据集可以注释掉这行语句
X_test, y_test = dataset("generate", "train_signals.csv", 2000000)
# 加载测试集数据，如事先已生成则可取消注释这行语句，直接读取CSV文件，否则需要生成
# X_test, y_test = dataset("exist", "test_signals.csv")
test_dataset = TensorDataset(X_test, y_test)
test_loader = DataLoader(
    dataset=test_dataset,
    batch_size=64,
    shuffle=True,  # 打乱数据
    pin_memory=True  # 加速GPU传输
)
end0 = time.time()
print(f"加载数据集用时：{end0 - start0:.4f}s")

model = ConvCodeClassifier()
model.cuda()  # 移至GPU
optimizer = torch.optim.Adam(
    model.parameters(),
    lr=0.001,  # 学习率
    weight_decay=1e-4  # L2正则化
)
criterion = nn.CrossEntropyLoss(label_smoothing=0.1)  # 标签平滑防止过拟合
epochs = 20  # 训练轮次
# 初始化记录变量
epoch_losses_training = []  # 记录每个epoch的训练损失
epoch_losses_testing = []   # 记录每个epoch的测试损失
epoch_accuracies = []       # 记录测试准确率
best_accuracy = 0 # 最大正确率
best_epoch = 0 # 最好轮次
start = time.time()  # 开始计时
with open("log.txt", "w", encoding="utf-8") as f0:  # 训练过程日志文件
    for epoch in range(epochs):
        model.train()  # 训练模式
        # 遍历训练数据批次
        for batch_idx, (inputs, labels) in enumerate(train_loader):
            inputs = inputs.cuda()  # 数据移至GPU
            labels = labels.cuda()
            labels = labels.to(torch.long)  # 转换为长整型
            outputs = model(inputs)  # 前向传播
            loss = criterion(outputs, labels)  # 计算损失
            optimizer.zero_grad()  # 清空梯度
            loss.backward()        # 反向传播
            optimizer.step()       # 更新参数
        # 记录训练损失
        loss_value = loss.detach().cpu().item()
        epoch_losses_training.append(loss_value)

        # 测试阶段
        loss_test=0
        accuracy=0
        # model.eval()  # 测试模式
        for i,(images,labels) in enumerate(test_loader):
            images = images.cuda()
            labels = labels.cuda()
            with torch.no_grad():  # 不计算梯度
                outputs = model(images)
                _, preds=outputs.max(1)
            labels = labels.to(torch.long)
            # 计算测试损失
            loss_test += criterion(outputs, labels)
            total = y_test.size(0)
            # 计算准确率
            accuracy += (preds == labels).sum().item()
        # 计算平均测试损失和准确率
        accuracy = accuracy / len(X_test)
        accuracy_value = accuracy
        epoch_accuracies.append(accuracy_value)
        loss_test = loss_test / (len(X_test)//64)
        loss_value = loss_test.detach().cpu().item()
        epoch_losses_testing.append(loss_value)
        # 输出日志
        print("Epoch is {}, Train loss is {:.4f}, Test loss is {:.4f},".format(epoch + 1, loss.item(), loss_test.item()), f"Accuracy is {accuracy * 100:.1f}%")
        f0.write(f"Epoch [{epoch + 1}/{epochs}] | Train Loss: {loss.item():.4f} | Test Loss: {loss_test.item():.4f} | Accuracy: {100 * accuracy:.1f}%\n")
        #保存最好模型
        if accuracy > best_accuracy:
            best_accuracy = accuracy
            best_epoch = epoch
            torch.save(model, 'best_model.pth')
            print(f"Epoch is {epoch + 1}, Accuracy is {accuracy * 100:.1f}%, The best model is saved")
        # 最后一轮输出最终评估结果
        if epoch == epochs - 1:
            print(f"[评估结果] 训练轮次：{epochs} | 最好轮次：{best_epoch + 1} | 正确率：{best_accuracy * 100:.1f}%")
    f0.write(f"The best epoch is {best_epoch + 1}, Accuracy is {accuracy * 100:.1f}%")
end = time.time()
train_time = end-start  # 总训练时间

# 绘制训练和测试损失曲线
Epochs = range(1, epochs + 1)
EPochs = range(0, epochs + 2 ,epochs // 10)  # 横坐标刻度

plt.figure()
plt.plot(Epochs, epoch_losses_training, 'b', marker='o',label='Training loss', linestyle='-', linewidth=2, markersize=5)
plt.plot(Epochs, epoch_losses_testing, 'r',marker='s' ,label='Testing loss', linestyle='-', linewidth=2, markersize=5)
plt.xlabel('Epochs', fontsize=12)
plt.ylabel('Loss', fontsize=12)
plt.xlim(0 ,epochs)
plt.ylim(0 ,0.7)
plt.title('Training and Testing Loss Curve', fontsize=14, pad=20)
plt.xticks(EPochs)
plt.grid(True, linestyle='--', alpha=0.7)
plt.legend()
plt.savefig('Training_and_Testing_Loss_Curve.png', dpi=300, bbox_inches='tight')
plt.show()

# 绘制测试准确率曲线
plt.figure()
epoch_accuracies = [0] + epoch_accuracies
Epochs = range(0, epochs + 1)
plt.plot(Epochs, epoch_accuracies, 'b', label='Testing Accuracy',marker='o' ,linestyle='-', linewidth=2, markersize=5)
plt.xlabel('Epochs', fontsize=12)
plt.ylabel('Accuracy', fontsize=12)
plt.xlim(0 ,epochs)
plt.ylim(0 ,1)
plt.title('Testing Accuracy Curve', fontsize=14, pad=20)
plt.xticks(EPochs)
plt.grid(True, linestyle='--', alpha=0.7)
plt.legend()
plt.savefig('Testing_Accuracy_Curve.png', dpi=300, bbox_inches='tight')
plt.show()

