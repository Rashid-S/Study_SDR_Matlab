% Феномен Гиббса
clc; clear all; 
sps=10; % число выборок на символ
N=4; % число символов
tT=[-10:1/sps:10]; % нормированное время t/T
for i=1:length(tT)
    if abs(tT(i))<N
        ht(i)=sin(pi*tT(i))./(pi*tT(i));
    else
        ht(i)=0;
    end
end
ht(isnan(ht))=1;
subplot(2,1,1); 
plot(tT,ht,'linewidth',1); grid on; axis('tight');
title(['ИХ с учечением до N=',num2str(N),' символов']);
L=length(ht); NFFT=2^nextpow2(L);
hf = fft(ht,NFFT)/L; hf = fftshift(hf);
fT=(-NFFT/2:NFFT/2-1)/NFFT*sps;
subplot(2,1,2); 
plot(fT,10*log10(abs(hf))); grid on; xlim([-2 2]);
title(['ЧХ с учечением до N=',num2str(N),' символов']);