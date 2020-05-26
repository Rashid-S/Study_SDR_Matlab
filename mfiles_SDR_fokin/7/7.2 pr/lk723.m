clear all; clc;
L=40;    % длина фильтра
R=1e6;   % символьная скорость 1 Мсим/с
Fs=8*R;  % частота дискретизации (передискретизация в 8 раз)
T=1/R;   % длительность символа
Ts=1/Fs; % период дискретизации
beta =0.5; % коэффициент сглаживания
% Синтез фильтра типа "приподнятого косинуса"
if mod(L,2)==0
    M=L/2 ;    % для четных L
else
    M=(L-1)/2; % для нечетных L
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
% impz(g,1); % отображение ИХ цифрового фильтра
stem(g); grid on; axis('tight'); 
title(['ИХ. Длина фильтра ',num2str(L),' символов']);
% формррование биполярных символов
data=2*(rand(1,1000)>=0.5)-1; 
% передискретизация символов
output=upsample(data,Fs/R); 
% свертка символов с ИХ фильтра
y=conv(g,output);
% y=filter(g,1,output); % фильтрация символов с ИХ фильтра
figure(2);
subplot(3,1,1);
stem(data); axis([0,20,-1.5,1.5]); grid on;
title('Символы на входе фильтра');
xlabel('выборки'); ylabel('Амплитуда');
subplot(3,1,2);
plot(y); axis([L/3,160+L/3,-1.5,1.5]); grid on;
title('Символы на выходе фильтра (передискретизация в 8 раз)');
xlabel('выборки'); ylabel('Амплитуда');
L=length(y); NFFT=2^nextpow2(L);
FFTY=fft(y,NFFT); FFTY=fftshift(FFTY); FFTY=abs(FFTY)/L;
f=(-NFFT/2:NFFT/2-1)/NFFT*Fs;
subplot(3,1,3);
plot(f,20*log10(abs(FFTY))); grid on;
xlabel('Частота, Гц');ylabel('Амплитуда, дБ');
title('Спектр сигнала на выходе фильтра')