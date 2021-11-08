clear all;
 
[x,fs]=audioread('D:\浊音b.m4a');  %浊音的获取
x=x(:,1);
x=filter([1-0.9375],[1],x);    %预处理   %高频预加重，抵消频谱倾斜

wlen=960;   %设置窗长
win=hamming(wlen);                                           
inc=400;                                                  %设置帧移
xf=enframe(x,wlen,inc)';                                  %分帧、加汉明窗
  n3=length(xf);
  n4=fix(wlen/2)+1;
p=24;
bank=v_melbankm(p,wlen,fs,0,0.5,'m');    %Mel滤波器
bank=full(bank);
bank=bank/max(bank(:));  %归一化Mel滤波器组系数
for k=1:13     %DCT系数
  n=0:p-1;
  detcoef(k,:)=cos((2*n+1)*k*pi/(2*p));  %p为滤波器个数
end

for i=1:size(xf,2)    %计算每帧mfcc参数
  v1=xf(i,:);
  s=v1';   
  t=abs(fft(s));
  t=t.^2;
  c1=detcoef*log(bank*t(1:n4));
  m1(i,:)=c1';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[y,fs]=audioread('D:\清音f.m4a');    %浊音的获取
y=y(:,1);
y=filter([1-0.9375],[1],y);    %预处理   %高频预加重，抵消频谱倾斜 
wlen=960;   %设置窗长
win=hamming(wlen);                                           
inc=400;                                                  %设置帧移
yf=enframe(y,wlen,inc)';                                  %分帧、加汉明窗
  n3=length(yf);
  n4=fix(wlen/2)+1;
p=24;
bank=v_melbankm(p,wlen,fs,0,0.5,'m');    %Mel滤波器
bank=full(bank);   
bank=bank/max(bank(:));  %归一化Mel滤波器组系数
for k=1:13     %DCT系数
  n=0:p-1;
  detcoef(k,:)=cos((2*n+1)*k*pi/(2*p));  %p为滤波器个数
end
w = size(yf,2)
for i=1:size(yf,2)    %计算每帧mfcc参数
   v2=yf(i,:);
   s=v2';   
   t=abs(fft(s));
   t=t.^2;
   c1=detcoef*log(bank*t(1:n4));
   m2(i,:)=c1';
end
%------------------------------------------------------------------------
%对提取的MFCC特征做PCA聚类分析:
[pcaData1,COEFF3] = fastPCA(m1, 2 );
subplot(2,1,1);
plot(pcaData1(:,1),pcaData1(:,2),'b.');
title('降为2维后浊音的mfcc')
 

[pcaData2,COEFF3] = fastPCA(m2, 2 );
subplot(2,1,2);
plot(pcaData2(:,1),pcaData2(:,2),'b.');
title('降为2维后清音的mfcc')



function [pcaA,V] = fastPCA( A, k )
% 快速PCA
% 输入：A --- 样本矩阵，每行为一个样本
%      k --- 降维至 k 维
% 输出：pcaA --- 降维后的 k 维样本特征向量组成的矩阵，每行一个样本，列数 k 为降维后的样本特征维数
%      V --- 主成分向量
[r,c] = size(A);
% 样本均值
meanVec = mean(A);
% 计算协方差矩阵的转置 covMatT
Z = (A-repmat(meanVec, r, 1));
covMatT = Z * Z';
% 计算 covMatT 的前 k 个本征值和本征向量
[V,D] = eigs(covMatT, k);
% 得到协方差矩阵 (covMatT)' 的本征向量
V = Z' * V;
% 本征向量归一化为单位本征向量
for i=1:k
    V(:,i)=V(:,i)/norm(V(:,i));
end
% 线性变换（投影）降维至 k 维
pcaA = Z * V;
% 保存变换矩阵 V 和变换原点 meanVec
end