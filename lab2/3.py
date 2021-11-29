import matplotlib.pyplot as plt   #画图用
import librosa.core as lc   #计算stft使用
import numpy as np   #使用了其中的一些工具函数
import librosa.display   #画声谱图用

path = "manwoman.m4a"
y, sr = librosa.load(path, sr=None)

#获取宽带声谱图
mag = np.abs(lc.stft(y, hop_length=10, win_length=40, window='hamming'))        #进行短时傅里叶变换，并获取幅度
D = librosa.amplitude_to_db(mag, ref=np.max)    #幅度转换为db单位
librosa.display.specshow(D, sr=sr, hop_length=10, x_axis='s', y_axis='linear')             #画声谱图
plt.colorbar(format='%+2.0f dB')
plt.title('broadband spectrogram')
plt.savefig('broader.png')
plt.show()

#获取窄带声谱图
mag1 = np.abs(lc.stft(y, hop_length=100, win_length=400, window='hamming'))
D1 = librosa.amplitude_to_db(mag1, ref=np.max)
librosa.display.specshow(D1, sr=sr, hop_length=100, x_axis='s', y_axis='log')
plt.colorbar(format='%+2.0f dB')
plt.title('narrowband spectrogram')
plt.savefig('narrowband.png')
plt.show()

