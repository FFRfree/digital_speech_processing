# 画出清音和浊音的短时能量图，进行比较
import numpy as np
import wave
import matplotlib.pyplot as plt
import matplotlib
import librosa
wlen=960
inc=400

matplotlib.rcParams['font.sans-serif']=['SimHei']   # 用黑体显示中文
matplotlib.rcParams['axes.unicode_minus']=False     # 正常显示负号


def short_time_energy(wave_data, framerate):
    signal_length = len(wave_data)  # 信号总长度
    if signal_length <= wlen:  # 若信号长度小于一个帧的长度，则帧数定义为1
        nf = 1
    else:  # 否则，计算帧的总长度
        nf = int(np.ceil((1.0 * signal_length - wlen + inc) / inc))
    print(nf)
    pad_length = int((nf - 1) * inc + wlen)  # 所有帧加起来总的铺平后的长度
    zeros = np.zeros((pad_length - signal_length,))  # 不够的长度使用0填补，类似于FFT中的扩充数组操作
    pad_signal = np.concatenate((wave_data, zeros))  # 填补后的信号记为pad_signal
    indices = np.tile(np.arange(0, wlen), (nf, 1)) + np.tile(np.arange(0, nf * inc, inc),
                                                             (wlen, 1)).T  # 相当于对所有帧的时间点进行抽取，得到nf*nw长度的矩阵
    print(indices[:2])
    indices = np.array(indices, dtype=np.int32)  # 将indices转化为矩阵
    frames = pad_signal[indices]  # 得到帧信号
    windown = np.hanning(wlen)
    d = np.zeros(nf)
    x = np.zeros(nf)
    time = np.arange(0, nf) * (inc * 1.0 / framerate)
    for i in range(0, nf):
        a = frames[i:i + 1]
        b = a[0] * windown
        c = np.square(b)
        d[i] = np.sum(c)
    d = d * 1.0 / (max(abs(d)))

    return time, d



wave_data_voiced, framerate_1= librosa.load('浊音b.m4a', sr=None)
wave_data_unvoiced, framerate_2 = librosa.load('清音f.m4a', sr=None)
time1, d1 = short_time_energy(wave_data_voiced, framerate_1)
time2, d2 = short_time_energy(wave_data_unvoiced, framerate_2)


ax1 = plt.subplot(2,2,1)
ax1.plot(time1, d1)
ax1.grid()
ax1.set_title('浊音b短时能量图')

ax2 = plt.subplot(2,2,2, sharex=ax1, sharey=ax1)
ax2.plot(time2, d2)
ax2.grid()
ax2.set_title('清音f短时能量图')

ax3 = plt.subplot(2,2,3)
time_voiced = np.linspace(0, len(wave_data_voiced)/framerate_1, len(wave_data_voiced))
ax3.plot(time_voiced,wave_data_voiced)
ax3.grid()
ax3.set_title('浊音b波形图')

ax4 = plt.subplot(2,2,4, sharex=ax3, sharey=ax3)
time_unvoiced = np.linspace(0, len(wave_data_unvoiced)/framerate_2, len(wave_data_unvoiced))
ax4.plot(time_unvoiced,wave_data_unvoiced)
ax4.grid()
ax4.set_title('清音f波形图')

plt.subplots_adjust(
                    left=0.1,
                    bottom=0.1,
                    right=0.9,
                    top=0.9,
                    wspace=0.4,
                    hspace=0.4)

plt.show()