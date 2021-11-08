clear all;
 
[x,fs]=audioread('D:\����b.m4a');  %�����Ļ�ȡ
x=x(:,1);
x=filter([1-0.9375],[1],x);    %Ԥ����   %��ƵԤ���أ�����Ƶ����б

wlen=960;   %���ô���
win=hamming(wlen);                                           
inc=400;                                                  %����֡��
xf=enframe(x,wlen,inc)';                                  %��֡���Ӻ�����
  n3=length(xf);
  n4=fix(wlen/2)+1;
p=24;
bank=v_melbankm(p,wlen,fs,0,0.5,'m');    %Mel�˲���
bank=full(bank);
bank=bank/max(bank(:));  %��һ��Mel�˲�����ϵ��
for k=1:13     %DCTϵ��
  n=0:p-1;
  detcoef(k,:)=cos((2*n+1)*k*pi/(2*p));  %pΪ�˲�������
end

for i=1:size(xf,2)    %����ÿ֡mfcc����
  v1=xf(i,:);
  s=v1';   
  t=abs(fft(s));
  t=t.^2;
  c1=detcoef*log(bank*t(1:n4));
  m1(i,:)=c1';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[y,fs]=audioread('D:\����f.m4a');    %�����Ļ�ȡ
y=y(:,1);
y=filter([1-0.9375],[1],y);    %Ԥ����   %��ƵԤ���أ�����Ƶ����б 
wlen=960;   %���ô���
win=hamming(wlen);                                           
inc=400;                                                  %����֡��
yf=enframe(y,wlen,inc)';                                  %��֡���Ӻ�����
  n3=length(yf);
  n4=fix(wlen/2)+1;
p=24;
bank=v_melbankm(p,wlen,fs,0,0.5,'m');    %Mel�˲���
bank=full(bank);   
bank=bank/max(bank(:));  %��һ��Mel�˲�����ϵ��
for k=1:13     %DCTϵ��
  n=0:p-1;
  detcoef(k,:)=cos((2*n+1)*k*pi/(2*p));  %pΪ�˲�������
end
w = size(yf,2)
for i=1:size(yf,2)    %����ÿ֡mfcc����
   v2=yf(i,:);
   s=v2';   
   t=abs(fft(s));
   t=t.^2;
   c1=detcoef*log(bank*t(1:n4));
   m2(i,:)=c1';
end
%------------------------------------------------------------------------
%����ȡ��MFCC������PCA�������:
[pcaData1,COEFF3] = fastPCA(m1, 2 );
subplot(2,1,1);
plot(pcaData1(:,1),pcaData1(:,2),'b.');
title('��Ϊ2ά��������mfcc')
 

[pcaData2,COEFF3] = fastPCA(m2, 2 );
subplot(2,1,2);
plot(pcaData2(:,1),pcaData2(:,2),'b.');
title('��Ϊ2ά��������mfcc')



function [pcaA,V] = fastPCA( A, k )
% ����PCA
% ���룺A --- ��������ÿ��Ϊһ������
%      k --- ��ά�� k ά
% �����pcaA --- ��ά��� k ά��������������ɵľ���ÿ��һ������������ k Ϊ��ά�����������ά��
%      V --- ���ɷ�����
[r,c] = size(A);
% ������ֵ
meanVec = mean(A);
% ����Э��������ת�� covMatT
Z = (A-repmat(meanVec, r, 1));
covMatT = Z * Z';
% ���� covMatT ��ǰ k ������ֵ�ͱ�������
[V,D] = eigs(covMatT, k);
% �õ�Э������� (covMatT)' �ı�������
V = Z' * V;
% ����������һ��Ϊ��λ��������
for i=1:k
    V(:,i)=V(:,i)/norm(V(:,i));
end
% ���Ա任��ͶӰ����ά�� k ά
pcaA = Z * V;
% ����任���� V �ͱ任ԭ�� meanVec
end