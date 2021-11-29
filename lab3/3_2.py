# 画出清音和浊音的平均过零率，进行比较
import numpy as np
import wave
import matplotlib.pyplot as plt
import matplotlib
import librosa
wlen=960
inc=400

matplotlib.rcParams['font.sans-serif']=['SimHei']   # 用黑体显示中文
matplotlib.rcParams['axes.unicode_minus']=False     # 正常显示负号
# def read_audio(filename):
#     f = wave.open(filename, "rb")
#     params = f.getparams()
#     nchannels, sampwidth, framerate, nframes = params[:4]
#     str_data = f.readframes(nframes)
#     wave_data = np.frombuffer(str_data, dtype=np.short)
#     wave_data = wave_data * 1.0 / (max(abs(wave_data)))

def zero_crossing_rate(wave_data, framerate):
    signal_length = len(wave_data)  # 信号总长度
    if signal_length <= wlen:  # 若信号长度小于一个帧的长度，则帧数定义为1
        nf = 1
    else:  # 否则，计算帧的总长度
        nf = int(np.ceil((1.0 * signal_length - wlen + inc) / inc))
    pad_length = int((nf - 1) * inc + wlen)  # 所有帧加起来总的铺平后的长度
    zeros = np.zeros((pad_length - signal_length,))  # 不够的长度使用0填补，类似于FFT中的扩充数组操作
    pad_signal = np.concatenate((wave_data, zeros))  # 填补后的信号记为pad_signal
    indices = np.tile(np.arange(0, wlen), (nf, 1)) + np.tile(np.arange(0, nf * inc, inc),
                                                             (wlen, 1)).T  # 相当于对所有帧的时间点进行抽取，得到nf*nw长度的矩阵
    print(indices[:2])
    indices = np.array(indices, dtype=np.int32)  # 将indices转化为矩阵
    frames = pad_signal[indices]
    windown = np.hanning(wlen)
    c = np.zeros(nf)
    for i in range(nf):
        a = frames[i:i + 1]
        b = windown * a[0]
        for j in range(wlen - 1):
            if b[j] * b[j + 1] < 0:
                c[i] = c[i] + 1
    time = np.arange(0, nf) * (inc * 1.0 / framerate)

    return time, c



wave_data_voiced, framerate_1= librosa.load('浊音b.m4a', sr=None)
wave_data_unvoiced, framerate_2 = librosa.load('清音f.m4a', sr=None)
time1, c1 = zero_crossing_rate(wave_data_voiced, framerate_1)
time2, c2 = zero_crossing_rate(wave_data_unvoiced, framerate_2)


ax1 = plt.subplot(2,2,1)
ax1.plot(time1,c1)
ax1.grid()
ax1.set_title('浊音b平均过零率')

ax2 = plt.subplot(2,2,2, sharex=ax1, sharey=ax1)
ax2.plot(time2,c2)
ax2.grid()
ax2.set_title('清音f平均过零率')

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