import librosa
import matplotlib.pyplot as plt
import numpy as np
import librosa.display
import matplotlib

matplotlib.rcParams['font.sans-serif']=['SimHei']   # 用黑体显示中文
matplotlib.rcParams['axes.unicode_minus']=False     # 正常显示负号


unvoiced, sr = librosa.load('清音f.m4a', sr=None)
voiced, sr = librosa.load('浊音b.m4a', sr=None)

frame_width = int(25e-3 * sr)

st1 = np.argmax(unvoiced)
st2 = np.argmax(voiced)

oneframe_unvoiced = unvoiced[st1:st1+frame_width]
oneframe_voiced = voiced[st2:st2+frame_width]

def get_spectrum(y):
    from numpy.fft import fft,fftfreq
    import numpy as np
    import matplotlib.pyplot as plt
    N = len(y)
    yf = fft(y)
    xf = fftfreq(N,1/sr)[:N//2]
    return xf, 2.0/N * np.abs(yf[0:N//2])
fig, axes = plt.subplots(nrows=2, ncols=2)
time_x = np.linspace(0,0.025,frame_width)
x1,y1 = get_spectrum(oneframe_unvoiced)
x2,y2 = get_spectrum(oneframe_voiced)
axes[0,0].plot(time_x, oneframe_unvoiced)
axes[0,0].set_title('浊音时域')
axes[0,1].plot(time_x, oneframe_voiced)
axes[0,1].set_title('清音时域')
axes[1,0].plot(x1,y1)
axes[1,0].set_title('浊音频域')
axes[1,1].plot(x2,y2)
axes[1,1].set_title('清音频域')

axes[1,1].sharey(axes[1,0])
axes[0,1].sharey(axes[0,0])

plt.subplots_adjust(
                    left=0.1,
                    bottom=0.1,
                    right=0.9,
                    top=0.9,
                    wspace=0.4,
                    hspace=0.4)
plt.show()

