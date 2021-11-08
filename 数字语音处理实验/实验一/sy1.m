%声音的获取与收听
[pyr,fs]=audioread('D:\Test.wav');       %声音的获取audioread
 sound(pyr,fs);					     %收听音频
%---------------------------------------------------------------------
%load命令的使用
save T1 pyr;							%将获取的声音保存成mat文件
load('T1.mat');						%将mat文件加载到工作区	
%---------------------------------------------------------------------
%write命令的使用
filename = 'Test_1.wav';		    	%把声音文件加载到工作区
audiowrite(filename,pyr,fs);
%---------------------------------------------------------------------
%5.4	使用plot指令绘制声音信号的时域波形与频谱图
n1=length(pyr);
t=(0:n1-1)/fs;
pyr1=fft(pyr,n1);						%快速傅里叶变换

figure(1);					         	%绘制时域波形
subplot(2,1,1);
plot(t,pyr);
xlabel('时间s');
ylabel('幅度');
title('声音信号时域图');
grid;

pyrFFTdb=20*log10(abs(pyr1+eps));  
subplot(2,1,2);						%绘制频谱图
plot(fs*(0:n1/2-1)/n1,pyrFFTdb(1:n1/2));
title('声音信号频谱图');
xlabel('频率hz');
ylabel('幅度db');
grid;
%---------------------------------------------------------------------
%使用strip plot指令画出0.125秒的条状信号图
strips(pyr,0.125,fs);
%---------------------------------------------------------------------
%使用sample conversion指令对声音信号进行样本转换
%采样率转换
y2=resample(pyr,11025,fs);          %取样频率48000Hz转变为11025Hz
%---------------------------------------------------------------------
%将信号经滤波器处理并绘制出相应波形
f = 0.8;
n2 = 6;
a = fir1(n2,f,'high');      %fir 高通滤波器                
p = filter(a,1,pyr);        %将音频传送到高通滤波器 

figure(2);		               %对比经过高通滤波器处理前后声音信号时域图
subplot(2,1,1);
plot(t,pyr);                 %原声音信号时域图
xlabel('时间s');
ylabel('幅度');
title('原始声音信号时域图');
subplot(2,1,2);
plot(t,p);   
xlabel('时间s');
ylabel('幅度');
title('高通滤波输出后声音信号时域图');


figure(3);	               %对比经过高通滤波器处理前后声音信号频域图
pyrFFTdb=20*log10(abs(pyr1+eps));  
subplot(2,1,1);			  %绘制频谱图
plot(fs*(0:n1/2-1)/n1,pyrFFTdb(1:n1/2));
title('声音信号频谱图');
xlabel('频率hz');
ylabel('幅度db');
grid;
n3=length(p);
pyr2=fft(p,n3);
subplot(2,1,2)
pyr2FFTdb=20*log10(abs(pyr2+eps));  
plot(fs*(0:n3/2-1)/n3,pyr2FFTdb(1:n3/2));
subplot(2,1,2)
title('声音信号频谱图');
xlabel('频率hz');
ylabel('幅度db');


