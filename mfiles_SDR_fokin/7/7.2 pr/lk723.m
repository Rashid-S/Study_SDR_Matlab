clear all; clc;
L=40;    % ����� �������
R=1e6;   % ���������� �������� 1 ����/�
Fs=8*R;  % ������� ������������� (����������������� � 8 ���)
T=1/R;   % ������������ �������
Ts=1/Fs; % ������ �������������
beta =0.5; % ����������� �����������
% ������ ������� ���� "������������ ��������"
if mod(L,2)==0
    M=L/2 ;    % ��� ������ L
else
    M=(L-1)/2; % ��� �������� L
end
g=zeros(1,L);
for n=-M:M
    num=sin(pi*n*Ts/T)*cos(beta*pi*n*Ts/T);
    den=(pi*n*Ts/T)*(1-(2*beta*n*Ts/T)^2);
    g(n+M+1)=num/den;
    if (1-(2*beta*n*Ts/T)^2)==0
        g(n+M+1)=pi/4*sin(pi*n*Ts/T)/(pi*n*Ts/T);
    end
    if n==0
        g(n+M+1)=cos(beta*pi*n*Ts/T)/(1-(2*beta*n*Ts/T)^2);
    end
end
figure(1); 
% impz(g,1); % ����������� �� ��������� �������
stem(g); grid on; axis('tight'); 
title(['��. ����� ������� ',num2str(L),' ��������']);
% ������������ ���������� ��������
data=2*(rand(1,1000)>=0.5)-1; 
% ����������������� ��������
output=upsample(data,Fs/R); 
% ������� �������� � �� �������
y=conv(g,output);
% y=filter(g,1,output); % ���������� �������� � �� �������
figure(2);
subplot(3,1,1);
stem(data); axis([0,20,-1.5,1.5]); grid on;
title('������� �� ����� �������');
xlabel('�������'); ylabel('���������');
subplot(3,1,2);
plot(y); axis([L/3,160+L/3,-1.5,1.5]); grid on;
title('������� �� ������ ������� (����������������� � 8 ���)');
xlabel('�������'); ylabel('���������');
L=length(y); NFFT=2^nextpow2(L);
FFTY=fft(y,NFFT); FFTY=fftshift(FFTY); FFTY=abs(FFTY)/L;
f=(-NFFT/2:NFFT/2-1)/NFFT*Fs;
subplot(3,1,3);
plot(f,20*log10(abs(FFTY))); grid on;
xlabel('�������, ��');ylabel('���������, ��');
title('������ ������� �� ������ �������')