import pandas as pd
import numpy as np

# 从 CSV 文件中读取数据
data = pd.read_csv('H_Plane_E4.csv')

# 提取角度和增益数据
theta = data['Theta [deg]']
gain = data['dB(GainTotal) []']

# 找到增益最大值及其对应的角度
max_gain = np.max(gain)
max_gain_angle = theta[np.argmax(gain)]

# 计算半功率（3dB 下降）电平
half_power = max_gain - 3

# 找到增益首次下降到半功率电平以下的左边界索引
left_index = np.where(gain[:np.argmax(gain)] < half_power)[0]
left_index = left_index[-1] if len(left_index) > 0 else 0

# 找到增益首次下降到半功率电平以下的右边界索引
right_index = np.where(gain[np.argmax(gain):] < half_power)[0]
right_index = right_index[0] + np.argmax(gain) if len(right_index) > 0 else len(gain) - 1

# 计算 3dB 波束宽度
beamwidth = theta[right_index] - theta[left_index]

print(f"天线方向图最大值: {max_gain} dBi")
print(f"指向角度: {max_gain_angle} 度")
print(f"3dB 波束宽度: {beamwidth} 度")