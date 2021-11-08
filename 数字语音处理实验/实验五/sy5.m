clear all;
 
[x,fs]=audioread('D:\manwoman.m4a');  %声音的获取
x=filter([1-0.9375],[1],x);    			%预处理高频预加重，抵消频谱倾斜 
wlen=882;                  			 		%设置窗长
win=hamming(wlen);                                           
inc=320;                                                  %设置帧移
xf=enframe(x,wlen,inc)';                                  %分帧、加汉明窗
  n1=length(xf);
  n2=fix(wlen/2)+1;
p=24;
bank=v_melbankm(p,wlen,fs,0,0.5,'m');    %Mel滤波器
bank=full(bank);
bank=bank/max(bank(:));             %归一化Mel滤波器组系数
for k=1:13                                  %DCT系数
  n=0:p-1;
  detcoef(k,:)=cos((2*n+1)*k*pi/(2*p));  	%p为滤波器个数
end
 
for i=1:size(xf,2)          %计算mfcc参数
  y1=xf(i,:);
  s1=y1';   
  t1=abs(fft(s1));
  t1=t1.^2;
  c1=detcoef*log(bank*t1(1:n2));
m1(i,:)=c1';
end

data=m1(:,1:2)
 

N=2;
figure
[id,center]=k_means(data,N);
plot(data(id==1,1),data(id==1,2),'r.');
hold on;
plot(data(id==2,1),data(id==2,2),'b.');
hold on;
plot(center(:,1),center(:,2),'Kx');
grid on;
 
function [id,center]=k_means(data,K)
%K-means聚类
%id是表示数据点属于哪一类的标记，center是每个类的聚类中心
%data为输入数据,K为需要分的聚类
% data=datafile();
% K=3;
[m,n]=size(data); %求输入数据点的个数m
id=zeros(m,1);
 
%随机初始化聚类中心
C=zeros(K,n);
for i=1:K
    C(i,:)=data(randi(m,1),:);     %随机初始化聚类中心%randi(n,1)产生一个1到n的伪随机整数
end
%C(i)表示第i类的聚类中心
 
while 1
    %分配簇
    for x=1:m
        for y=1:K
            d(y)=norm(data(x,:)-C(y,:)); %计算数据点到每个聚类中心的距离
        end
        [~,idx]=min(d);
        id(x)=idx;
    end
    %更新聚类中心 
    new_C=zeros(K,n);
    num=zeros(K);
    q=0;
    for y=1:K
        for x=1:m
            if id(x,1)==y
            new_C(y,:)=new_C(y,:)+data(x,:);
            num(y)=num(y)+1;
            end
        end
        new_C(y,:)=new_C(y,:)/num(y);
        if norm(new_C(y,:)-C(y,:))<0.001  %判断是否收敛
            q=q+1;
        end
    end
    if q==K
        break;
    else
        C=new_C;
    end
end
center=C;
end
 
