import librosa
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
import matplotlib.pyplot as plt
y, sr = librosa.load('浊音b.m4a',sr=None)
mfcc = librosa.feature.mfcc(y, sr, n_mfcc=13)
mfcc = mfcc.T # turn into (n_samples, n_features)
scaler = StandardScaler()
mfcc = scaler.fit_transform(mfcc)
pca = PCA(n_components=2)
two_d_feature = pca.fit_transform(mfcc)
print(pca.explained_variance_ratio_)


plt.scatter(two_d_feature[:,0],two_d_feature[:,1])
plt.title('voiced b')
plt.show()
