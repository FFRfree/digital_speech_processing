import librosa
import os
from sklearn.cluster import KMeans
import numpy as np
noise_dir = r'D:\Downloads\Compressed\musan\noise\free-sound'
speech_dir = r'D:\Downloads\Compressed\musan\speech\librivox'

noise_filename = list(filter(lambda x:x.endswith('.wav'), os.listdir(noise_dir)))
speech_filename = list(filter(lambda x:x.endswith('.wav'), os.listdir(speech_dir)))

data_x = []
data_y = [] # 0-noise 1-speech
extra_info = []

DURATION = 5
N_MFCC = 39

quantity = 0
for filename in noise_filename:
    if quantity >=10:
        break
    y, sr = librosa.load(os.path.join(noise_dir, filename), sr=None, offset=3, duration=DURATION)
    if len(y)/sr <DURATION:
        # 跳过这段
        continue
    mfccs = librosa.feature.mfcc(y=y, sr=sr, n_mfcc=N_MFCC)
    data_x.append(mfccs.flatten().tolist())
    data_y.append(0)
    extra_info.append(filename)
    quantity+=1


quantity = 0
for filename in speech_filename:
    if quantity>=10:
        break
    y, sr = librosa.load(os.path.join(speech_dir, filename), sr=None, offset=3 ,duration=DURATION)
    if len(y)/sr <DURATION:
        # 跳过这段
        continue
    mfccs = librosa.feature.mfcc(y=y, sr=sr, n_mfcc=N_MFCC)
    data_x.append(mfccs.flatten().tolist())
    data_y.append(1)
    extra_info.append(filename)
    quantity+=1

data_x = np.array(data_x)
data_y = np.array(data_y)

kmeans = KMeans(n_clusters=2,random_state=42).fit(data_x)
print(kmeans.labels_)



