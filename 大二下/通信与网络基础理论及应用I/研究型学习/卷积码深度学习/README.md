# 卷积码识别神经网络环境配置说明

## 项目简介
本项目实现了基于卷积神经网络的卷积码识别系统，包含数据集生成、模型训练、测试及预测等功能，可用于识别不同生成多项式对应的卷积码序列。

## 环境依赖
以下是运行本项目所需的依赖库及推荐版本：
- Python 3.8+
- PyTorch 1.10.0+（需支持CUDA）
- numpy 1.21.0+
- matplotlib 3.5.0+
- torchsummary 1.5.1
- torchview 0.2.6

## 环境搭建步骤

### 1. 安装Python
推荐使用Python 3.8或更高版本，可从[Python官网](https://www.python.org/downloads/)下载安装。

### 2. 创建虚拟环境（可选但推荐）
```bash
# 使用conda创建虚拟环境
conda create -n convcode python=3.8
conda activate convcode

# 或使用venv
python -m venv convcode-env
# Windows激活
convcode-env\Scripts\activate
# Linux/Mac激活
source convcode-env/bin/activate
```

### 3. 安装PyTorch
根据操作系统和CUDA版本选择合适的安装命令，推荐使用带CUDA支持的版本以加速训练。  
参考[PyTorch官网](https://pytorch.org/)获取最新安装命令，示例如下（CUDA 11.3）：
```bash
pip3 install torch==1.12.1+cu113 torchvision==0.13.1+cu113 torchaudio==0.12.1 --extra-index-url https://download.pytorch.org/whl/cu113
```

### 4. 安装其他依赖库
```bash
pip install numpy==1.21.5
pip install matplotlib==3.5.2
pip install torchsummary==1.5.1
pip install torchview==0.2.6
```

## 项目文件结构说明
- `train_and_test.py`：模型训练和测试主程序，包含数据集加载、模型训练、性能评估及曲线绘制
- `predict.py`：基于训练好的模型进行预测，分析不同误码率下的识别性能
- `dataset.py`：数据集生成和加载工具，支持生成新数据集或从CSV文件加载
- `test_data_prediction.py`：针对测试数据的预测脚本
- `ConvCodeClassifier.py`：卷积码分类器模型定义（CNN网络结构）
- `Encoder.py`：卷积码编码工具，包含生成多项式定义和编码函数

## 注意事项
1. **CUDA配置**：确保系统已安装匹配的NVIDIA显卡驱动和CUDA工具包，以支持GPU加速
2. **数据集大小**：默认训练集包含100万样本，测试集20万样本，生成时可能需要较大磁盘空间和较长时间，可根据实际情况调整样本数量，可以先一次生成训练集和测试集，后续读取文件即可
3. **依赖兼容性**：若出现版本兼容问题，可尝试调整相关库的版本，核心确保PyTorch能正常运行
4. **可视化工具**：torchview绘图可能需要Graphviz支持，如无法正常生成模型图，需额外安装Graphviz：
   ```bash
   # Ubuntu
   sudo apt-get install graphviz
   # macOS
   brew install graphviz
   # Windows
   choco install graphviz
   # 同时安装Python绑定
   pip install graphviz
   ```

## 运行说明
1. 首先运行`train_and_test.py`进行模型训练，生成训练好的模型文件`best_model.pth`
2. 训练完成后，可运行`predict.py`分析模型在不同误码率下的性能
3. 使用`test_data_prediction.py`可对自定义测试数据进行预测
