 %���õ��ĺ���
% function frameTime=frame2time(frameNum,framelen,inc,fs)
% ��֡�����ÿ֡��Ӧ��ʱ��
% frameTime=(((1:frameNum)-1)*inc+framelen/2)/fs;
% end
%--------------------------------------------------------------------
%���������������Ķ�ʱ����ͼ�����бȽ�
clear all;
[x,fs]=audioread('D:\MYData\voice\sy3\����f.m4a');         %��ȡ��Ƶ
x=x(:,1);                                                  %��ȡһ��ͨ��
wlen=960;                                                  %���ô���
win=hanning(wlen);                                         %���ú�����  
inc=400;                                                   %����֡��
lx=length(x);
xf=enframe(x,win,inc)';                                    %��֡���Ӻ�����    
fnx=size(xf,2);                                            %֡��
tx=(0:lx-1)/fs;                
frametimex=frame2time(fnx,wlen,inc,fs);
for i=1:fnx
    xf1=xf(:,i);
    xe=xf1.*xf1;
    Enx(i)=sum(xe);
end
figure('Name','��ʱ����','NumberTitle','off');                                          
subplot(2,2,1);                                            %���������ź�ʱ��ͼ
plot(tx,x,'k');
axis([0 5 -0.6 0.6]);
xlabel('ʱ��/s');
ylabel('��ֵ');
title('�����ź�ʱ��ͼ');
grid;
 
subplot(2,2,3);
plot(frametimex,Enx,'k');                             %���������źŶ�ʱ����ͼ
axis([0 5 0 15]);
title('������ʱ����');
xlabel('ʱ��/s');
ylabel('��ֵ');
grid;
 
[y,fs]=audioread('D:\MYData\voice\sy3\����b.m4a');       
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
xlabel('ʱ��/s');
ylabel('��ֵ');
title('�����ź�ʱ��ͼ');
grid;
 
subplot(2,2,4);
plot(frametimey,Eny,'k');   
axis([0 5 -0.6 0.6]);
axis([0 5 0 15]);         
title('������ʱ����');
xlabel('ʱ��/s');
ylabel('��ֵ');
grid;
%--------------------------------------------------------
%����������������ƽ�������ʣ����бȽ�
% ���õ��ĺ���
% function frameTime=frame2time(frameNum,framelen,inc,fs)
% % ��֡�����ÿ֡��Ӧ��ʱ��
% frameTime=(((1:frameNum)-1)*inc+framelen/2)/fs;
% end
 
clear all;
[x,fs]=audioread('D:\MYData\voice\sy3\����f.m4a');     
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
figure('Name','��ʱƽ��������','NumberTitle','off');   
subplot(2,2,1);                                      
plot(txx,xx,'k');
axis([0 5 -0.6 0.6]);  
xlabel('ʱ��/s');
ylabel('��ֵ');
title('�����ź�ʱ��ͼ');
grid;
 
subplot(2,2,3);
plot(frametimexx,zcrx,'k');   
axis([0 7 0 350]);        
title('�����źŶ�ʱƽ��������');
xlabel('ʱ��/s');
ylabel('��ֵ');
grid;
 
 
%����
[y,fs]=audioread('D:\MYData\voice\sy3\����b.m4a');       
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
xlabel('ʱ��/s');
ylabel('��ֵ');
title('�����ź�ʱ��ͼ');
grid;
 
subplot(2,2,4);
plot(frametimeyy,zcry,'k');    
axis([0 7 0 350]);         
title('�����źŶ�ʱƽ��������');
xlabel('ʱ��/s');
ylabel('��ֵ');
grid;
%---------------------------------------------------------------
%��һ������Ϊѵ���������ö�ʱ�����Ͷ�ʱ���������ַ����趨��ֵ��
%����һ������Ϊ���Լ����ó������������������ж�ͼ����λΪ֡����
%��ʱ����

[pyr,fs]=audioread('D:\MYData\voice\sy3\Test.wav');      % ���������ļ�  ��ϰ��
[pxr,fs]=audioread('D:\MYData\voice\sy3\seaboat.wav');      % ���������ļ�  ���Լ�
 
pxr=pxr(:,1);
wlen=960; inc=400;          % ����֡����֡��
win=hanning(wlen);         % ����������
pxr_l=length(pxr);               % �źų���
pxrf=enframe(pxr,win,inc)';     % ��֡
pxr_fn=size(pxrf,2);              % ���֡��
 
amp_pxr=sum(pxrf.^2);
 
L=length(amp_pxr);
 
 
 
pyr=pyr(:,1);
wlen=960; inc=400;          % ����֡����֡��
win=hanning(wlen);         % ����������
pyr_l=length(pyr);               % �źų���
pyrf=enframe(pyr,win,inc)';     % ��֡
pyr_fn=size(pyrf,2);              % ���֡��
pyr_t=(0:pyr_l-1)/fs;         % ������źŵ�ʱ��̶�
for i=1:pyr_fn
    pyrf1=pyrf(:,i);    % ȡ��һ֡
    pyrf1_e=pyrf1.*pyrf1; % �������
    En(i)=sum(pyrf1_e);% ��һ֡�ۼ����
  
end
 
 
 
pxr=pxr(:,1);
wlen=960; inc=400;          % ����֡����֡��
win=hanning(wlen);         % ����������
pxr_l=length(pxr);               % �źų���
pxrf=enframe(pxr,win,inc)';     % ��֡
pxr_fn=size(pxrf,2);              % ���֡��
pxr_t=(0:pxr_l-1)/fs;         % ������źŵ�ʱ��̶�
for i=1:pxr_fn
    pxrf1=pxrf(:,i);    % ȡ��һ֡
    pxrf1_e=pxrf1.*pxrf1; % �������
    Em(i)=sum(pxrf1_e);% ��һ֡�ۼ����
  
end
 
frameTime=frame2time(pxr_fn,wlen,inc,fs);   % ���ÿ֡��Ӧ��ʱ��
subplot 211; plot(frameTime,Em,'k')     % ������ʱ����ͼ
title('��ʱ����');
 ylabel('��ֵ'); xlabel(['ʱ��/s' ]);
 
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
%��ʱ�����ʷ���
clear all; clc;
[x,fs]=audioread('D:\MYData\voice\sy3\Test.wav');   %��ϰ��
[y,fs]=audioread('D:\MYData\voice\sy3\seaboat.wav');   %���Լ�
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
title('�źŶ�ʱƽ��������');
xlabel('ʱ��/s');
ylabel('��ֵ');
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
%��ʱ�����ʷ���
clear all; clc;
[x,fs]=audioread('D:\MYData\voice\sy3\Test.wav');   %��ϰ��
[y,fs]=audioread('D:\MYData\voice\sy3\seaboat.wav');   %���Լ�
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
title('�źŶ�ʱƽ��������');
xlabel('ʱ��/s');
ylabel('��ֵ');
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
  

