clear all;
 
[x,fs]=audioread('D:\manwoman.m4a');  %�����Ļ�ȡ
x=filter([1-0.9375],[1],x);    			%Ԥ�����ƵԤ���أ�����Ƶ����б 
wlen=882;                  			 		%���ô���
win=hamming(wlen);                                           
inc=320;                                                  %����֡��
xf=enframe(x,wlen,inc)';                                  %��֡���Ӻ�����
  n1=length(xf);
  n2=fix(wlen/2)+1;
p=24;
bank=v_melbankm(p,wlen,fs,0,0.5,'m');    %Mel�˲���
bank=full(bank);
bank=bank/max(bank(:));             %��һ��Mel�˲�����ϵ��
for k=1:13                                  %DCTϵ��
  n=0:p-1;
  detcoef(k,:)=cos((2*n+1)*k*pi/(2*p));  	%pΪ�˲�������
end
 
for i=1:size(xf,2)          %����mfcc����
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
%K-means����
%id�Ǳ�ʾ���ݵ�������һ��ı�ǣ�center��ÿ����ľ�������
%dataΪ��������,KΪ��Ҫ�ֵľ���
% data=datafile();
% K=3;
[m,n]=size(data); %���������ݵ�ĸ���m
id=zeros(m,1);
 
%�����ʼ����������
C=zeros(K,n);
for i=1:K
    C(i,:)=data(randi(m,1),:);     %�����ʼ����������%randi(n,1)����һ��1��n��α�������
end
%C(i)��ʾ��i��ľ�������
 
while 1
    %�����
    for x=1:m
        for y=1:K
            d(y)=norm(data(x,:)-C(y,:)); %�������ݵ㵽ÿ���������ĵľ���
        end
        [~,idx]=min(d);
        id(x)=idx;
    end
    %���¾������� 
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
        if norm(new_C(y,:)-C(y,:))<0.001  %�ж��Ƿ�����
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
 
