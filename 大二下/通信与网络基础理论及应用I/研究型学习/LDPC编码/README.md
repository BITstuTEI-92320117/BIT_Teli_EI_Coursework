# LDPC编码图像传输仿真系统
## 一、项目概述
本项目基于MATLAB实现LDPC信道编码与Min-Sum译码的图像传输仿真，遵循CCSDS 2006/2007版标准，可完成图像预处理、编码加噪、迭代译码、恢复与性能评估，验证LDPC码的纠错性能，适用于通信、存储等场景的误码抑制测试。

## 二、文件/函数核心用途
| 文件名/函数名               | 核心用途                                                                 |
|-----------------------------|--------------------------------------------------------------------------|
| `Pic.m`                     | 系统主函数，整合图像预处理、编码、加噪、译码、恢复全流程，支持单组/批量性能测试与可视化 |
| `ldpcdecoderminsum.m`       | 实现Min-Sum译码算法，通过迭代修正接收信号错误，输出译码结果               |
| `inv_bin.m`                 | 计算二进制域（GF(2)）方阵的逆矩阵，用于生成矩阵的校验子矩阵逆运算         |
| `add_noise.m`               | 模拟信道噪声，按指定误码率随机翻转编码比特，生成含噪接收信号             |
| `ccsdscheckmatrix.m`        | 生成CCSDS 2006版LDPC校验矩阵（支持1/2、2/3、4/5码率）                   |
| `ccsdscheckmatrix2.m`       | 生成CCSDS 2007版LDPC校验矩阵（依赖预定义常数文件）                       |
| `ccsdsgeneratematrix.m`     | 从2006版校验矩阵生成准循环LDPC生成矩阵，满足G×H'≡0(mod 2)               |
| `ccsdsgeneratematrix2.m`    | 从2007版校验矩阵生成准循环LDPC生成矩阵                                   |
| `checkmatrixconstant.mat`   | 存储2007版校验矩阵生成所需的预定义参数（theta数组、fai矩阵）              |

## 三、使用步骤
1. 环境准备：MATLAB R2018b及以上，所有文件放在同一目录，待测试图像命名为“1组-灰度图.bmp”（或修改`Pic.m`中`imagePath`）；
2. 单组测试：命令行输入`Pic(Pe, No_matrix)`（如`Pic(0.1, 0)`，Pe=原误码率，No_matrix=0=2006版/1=2007版）；
3. 批量对比：直接运行`Pic.m`，自动遍历Pe=0~0.2，生成两版标准的BER性能对比图。

## 四、注意事项
1. 码率仅支持1/2、2/3、4/5，需保持主函数与矩阵生成函数参数一致；
2. 原误码率建议≤13%，超过14%会降低纠错效果；
3. 批量测试需确保`checkmatrixconstant.mat`与`ccsdscheckmatrix2.m`同目录。

## 五、参考文献
[1] Gallager R G. Low-Density Parity-Check Codes[J]. IRE Transactions on Information Theory, 1962, 8(1): 21-28.<br>
[2] Ryan W E, Lin S. Channel Codes: Classical and Modern[M]. Cambridge University Press, 2009.<br>
[3] 王筝, 等. 面向6G 的速率兼容空间耦合LDPC 码设计[J]. 移动通信, 2025.<br>
[4] 曹伟, 王新梅. LDPC 码的构造方法综述[J]. 电子学报, 2005.

