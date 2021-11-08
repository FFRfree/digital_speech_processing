 %所用到的函数
% function frameTime=frame2time(frameNum,framelen,inc,fs)
% 分帧后计算每帧对应的时间
% frameTime=(((1:frameNum)-1)*inc+framelen/2)/fs;
% end
%--------------------------------------------------------------------
%画出清音和浊音的短时能量图，进行比较
clear all;
[x,fs]=audioread('D:\MYData\voice\sy3\清音f.m4a');         %读取音频
x=x(:,1);                                                  %提取一个通道
wlen=960;                                                  %设置窗长
win=hanning(wlen);                                         %设置海宁窗  
inc=400;                                                   %设置帧移
lx=length(x);
xf=enframe(x,win,inc)';                                    %分帧、加海宁窗    
fnx=size(xf,2);                                            %帧数
tx=(0:lx-1)/fs;                
frametimex=frame2time(fnx,wlen,inc,fs);
for i=1:fnx
    xf1=xf(:,i);
    xe=xf1.*xf1;
    Enx(i)=sum(xe);
end
figure('Name','短时能量','NumberTitle','off');                                          
subplot(2,2,1);                                            %绘制清音信号时域图
plot(tx,x,'k');
axis([0 5 -0.6 0.6]);
xlabel('时间/s');
ylabel('幅值');
title('清音信号时域图');
grid;
 
subplot(2,2,3);
plot(frametimex,Enx,'k');                             %绘制清音信号短时能量图
axis([0 5 0 15]);
title('清音短时能量');
xlabel('时间/s');
ylabel('幅值');
grid;
 
[y,fs]=audioread('D:\MYData\voice\sy3\浊音b.m4a');       
y=y(:,1);
ly=length(y);
yf=enframe(y,win,inc)';
fny=size(yf,2);
ty=(0:ly-1)/fs;
frametimey=frame2time(fny,wlen,inc,fs);
for i=1:fny
    yf1=yf(:,i);
    ye=yf1.*yf1;
    Eny(i)=sum(ye);
end                                         
subplot(2,2,2);                                      
plot(ty,y,'k');
xlabel('时间/s');
ylabel('幅值');
title('浊音信号时域图');
grid;
 
subplot(2,2,4);
plot(frametimey,Eny,'k');   
axis([0 5 -0.6 0.6]);
axis([0 5 0 15]);         
title('浊音短时能量');
xlabel('时间/s');
ylabel('幅值');
grid;
%--------------------------------------------------------
%画出清音和浊音的平均过零率，进行比较
% 所用到的函数
% function frameTime=frame2time(frameNum,framelen,inc,fs)
% % 分帧后计算每帧对应的时间
% frameTime=(((1:frameNum)-1)*inc+framelen/2)/fs;
% end
 
clear all;
[x,fs]=audioread('D:\MYData\voice\sy3\清音f.m4a');     
x=x(:,1);
wlen=960;
win=hanning(wlen);                                           
inc=400;               
xx=x-mean(x);
lxx=length(xx);
txx=(0:lxx-1)/fs;
xxf=enframe(xx,win,inc)';                                      
fnxx=size(xxf,2);
zcrx=zeros(1,fnxx);
for i=1:fnxx
    xxf1=xxf(:,i);
    for j=1:(wlen-1)
        if xxf1(j)*xxf1(j+1)<0
            zcrx(i)=zcrx(i)+1;
        end
    end
end
txx1=(0:lxx-1)/fs;
frametimexx=frame2time(fnxx,wlen,inc,fs);
figure('Name','短时平均过零率','NumberTitle','off');   
subplot(2,2,1);                                      
plot(txx,xx,'k');
axis([0 5 -0.6 0.6]);  
xlabel('时间/s');
ylabel('幅值');
title('清音信号时域图');
grid;
 
subplot(2,2,3);
plot(frametimexx,zcrx,'k');   
axis([0 7 0 350]);        
title('清音信号短时平均过零率');
xlabel('时间/s');
ylabel('幅值');
grid;
 
 
%浊音
[y,fs]=audioread('D:\MYData\voice\sy3\浊音b.m4a');       
y=y(:,1);
yy=y-mean(y);
lyy=length(yy);
tyy=(0:lyy-1)/fs;
yyf=enframe(yy,win,inc)';                                    
fnyy=size(yyf,2);
zcry=zeros(1,fnyy);
for i=1:fnyy
    yyf1=yyf(:,i);
    for j=1:(wlen-1)
        if yyf1(j)*yyf1(j+1)<0
            zcry(i)=zcry(i)+1;
        end
    end
end
tyy1=(0:lyy-1)/fs;
frametimeyy=frame2time(fnyy,wlen,inc,fs);   
subplot(2,2,2);                                      
plot(tyy,yy,'k');
axis([0 5 -0.6 0.6]);  
xlabel('时间/s');
ylabel('幅值');
title('浊音信号时域图');
grid;
 
subplot(2,2,4);
plot(frametimeyy,zcry,'k');    
axis([0 7 0 350]);         
title('浊音信号短时平均过零率');
xlabel('时间/s');
ylabel('幅值');
grid;
%---------------------------------------------------------------
%以一段语音为训练集，利用短时能量和短时过零率两种方法设定阈值，
%以另一段语音为测试集，得出测试语音的清浊音判断图（单位为帧）。
%短时能量

[pyr,fs]=audioread('D:\MYData\voice\sy3\Test.wav');      % 读入数据文件  练习集
[pxr,fs]=audioread('D:\MYData\voice\sy3\seaboat.wav');      % 读入数据文件  测试集
 
pxr=pxr(:,1);
wlen=960; inc=400;          % 给出帧长和帧移
win=hanning(wlen);         % 给出海宁窗
pxr_l=length(pxr);               % 信号长度
pxrf=enframe(pxr,win,inc)';     % 分帧
pxr_fn=size(pxrf,2);              % 求出帧数
 
amp_pxr=sum(pxrf.^2);
 
L=length(amp_pxr);
 
 
 
pyr=pyr(:,1);
wlen=960; inc=400;          % 给出帧长和帧移
win=hanning(wlen);         % 给出海宁窗
pyr_l=length(pyr);               % 信号长度
pyrf=enframe(pyr,win,inc)';     % 分帧
pyr_fn=size(pyrf,2);              % 求出帧数
pyr_t=(0:pyr_l-1)/fs;         % 计算出信号的时间刻度
for i=1:pyr_fn
    pyrf1=pyrf(:,i);    % 取出一帧
    pyrf1_e=pyrf1.*pyrf1; % 求出能量
    En(i)=sum(pyrf1_e);% 对一帧累加求和
  
end
 
 
 
pxr=pxr(:,1);
wlen=960; inc=400;          % 给出帧长和帧移
win=hanning(wlen);         % 给出海宁窗
pxr_l=length(pxr);               % 信号长度
pxrf=enframe(pxr,win,inc)';     % 分帧
pxr_fn=size(pxrf,2);              % 求出帧数
pxr_t=(0:pxr_l-1)/fs;         % 计算出信号的时间刻度
for i=1:pxr_fn
    pxrf1=pxrf(:,i);    % 取出一帧
    pxrf1_e=pxrf1.*pxrf1; % 求出能量
    Em(i)=sum(pxrf1_e);% 对一帧累加求和
  
end
 
frameTime=frame2time(pxr_fn,wlen,inc,fs);   % 求出每帧对应的时间
subplot 211; plot(frameTime,Em,'k')     % 画出短时能量图
title('短时能量');
 ylabel('幅值'); xlabel(['时间/s' ]);
 
for i1 =1:L
    if  Em(i1)<=((max(En)-min(En))*0.25);
        c(i1)=0;
    elseif  Em(i1)<=((max(En)-min(En))*0.5);
        c(i1)=1;
    else 
        c(i1)=2;

    end
end
subplot 212;plot(frameTime,c,'k.');

%-------------------------------------------------------------
%短时过零率法：
clear all; clc;
[x,fs]=audioread('D:\MYData\voice\sy3\Test.wav');   %练习集
[y,fs]=audioread('D:\MYData\voice\sy3\seaboat.wav');   %测试集
x=x(:,1);
wlen=960;
win=hanning(wlen);                                           
inc=400;               
xx=x-mean(x);
lxx=length(xx);
txx=(0:lxx-1)/fs;
xxf=enframe(xx,win,inc)';                                      
fnxx=size(xxf,2);
zcrx=zeros(1,fnxx);
for i=1:fnxx
    xxf1=xxf(:,i);
    for j=1:(wlen-1)
        if xxf1(j)*xxf1(j+1)<0
            zcrx(i)=zcrx(i)+1;
        end
    end
end
 
y=y(:,1);
yy=y-mean(y);
lyy=length(yy);
tyy=(0:lyy-1)/fs;
yyf=enframe(yy,win,inc)';                                    
fnyy=size(yyf,2);
zcry=zeros(1,fnyy);
for i=1:fnyy
    yyf1=yyf(:,i);
    for j=1:(wlen-1)
        if yyf1(j)*yyf1(j+1)<0
            zcry(i)=zcry(i)+1;
        end
    end
end
 
frameTime=frame2time(fnyy,wlen,inc,fs);
txx1=(0:lxx-1)/fs;
frametimexx=frame2time(fnxx,wlen,inc,fs);
 
subplot(2,1,1);
plot(frametimexx,zcrx,'k');
axis(0 6 0 2)          
title('信号短时平均过零率');
xlabel('时间/s');
ylabel('幅值');
grid;
 
for i1 =1:fnyy
    if  zcry(i1)<=((max(zcrx)-min(zcrx))*0.25);
        c(i1)=0;
    elseif zcry(i1)<=((max(zcrx)-min(zcrx))*0.5);
        c(i1)=1;
    else 
        c(i1)=2;
    end
end
subplot 212;plot(frameTime,c,'k.');
%------------------------------------------------------------------------
%短时过零率法：
clear all; clc;
[x,fs]=audioread('D:\MYData\voice\sy3\Test.wav');   %练习集
[y,fs]=audioread('D:\MYData\voice\sy3\seaboat.wav');   %测试集
x=x(:,1);
wlen=960;
win=hanning(wlen);                                           
inc=400;               
xx=x-mean(x);
lxx=length(xx);
txx=(0:lxx-1)/fs;
xxf=enframe(xx,win,inc)';                                      
fnxx=size(xxf,2);
zcrx=zeros(1,fnxx);
for i=1:fnxx
    xxf1=xxf(:,i);
    for j=1:(wlen-1)
        if xxf1(j)*xxf1(j+1)<0
            zcrx(i)=zcrx(i)+1;
        end
    end
end
 
y=y(:,1);
yy=y-mean(y);
lyy=length(yy);
tyy=(0:lyy-1)/fs;
yyf=enframe(yy,win,inc)';                                    
fnyy=size(yyf,2);
zcry=zeros(1,fnyy);
for i=1:fnyy
    yyf1=yyf(:,i);
    for j=1:(wlen-1)
        if yyf1(j)*yyf1(j+1)<0
            zcry(i)=zcry(i)+1;
        end
    end
end
 
frameTime=frame2time(fnyy,wlen,inc,fs);
txx1=(0:lxx-1)/fs;
frametimexx=frame2time(fnxx,wlen,inc,fs);
 
subplot(2,1,1);
plot(frametimexx,zcrx,'k');         
title('信号短时平均过零率');
xlabel('时间/s');
ylabel('幅值');
grid;
 
for i1 =1:fnyy
    if  zcry(i1)<=((max(zcrx)-min(zcrx))*0.25);
        c(i1)=0;
    elseif zcry(i1)<=((max(zcrx)-min(zcrx))*0.5);
        c(i1)=1;
    else 
        c(i1)=2;
    end
end
subplot 212;plot(frameTime,c,'k.');
  

