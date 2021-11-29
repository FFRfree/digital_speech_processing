import numpy as np
import matplotlib.pyplot as plt
import librosa

wave_data, framerate = librosa.load('清音f.m4a', sr=None)

ms = 25
wlen = int(ms * 0.001 * framerate)
inc = int(wlen / 4)

time = np.arange(0, wlen) * (1.0 / framerate)
signal_length=len(wave_data) #信号总长度
if signal_length<=wlen: #若信号长度小于一个帧的长度，则帧数定义为1
        nf=1
else: #否则，计算帧的总长度
        nf=int(np.ceil((1.0*signal_length-wlen+inc)/inc))
pad_length=int((nf-1)*inc+wlen) #所有帧加起来总的铺平后的长度
zeros=np.zeros((pad_length-signal_length,)) #不够的长度使用0填补，类似于FFT中的扩充数组操作
pad_signal=np.concatenate((wave_data,zeros)) #填补后的信号记为pad_signal
indices=np.tile(np.arange(0,wlen),(nf,1))+np.tile(np.arange(0,nf*inc,inc),(wlen,1)).T  #相当于对所有帧的时间点进行抽取，得到nf*nw长度的矩阵
print(indices[:2])
indices=np.array(indices,dtype=np.int32) #将indices转化为矩阵
frames=pad_signal[indices] #得到帧信号
a=frames[203:204]
print(a[0])
plt.figure(figsize=(10,4))
plt.plot(time,a[0],c="g")
plt.grid()
plt.show()
