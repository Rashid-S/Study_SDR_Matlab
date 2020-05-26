clear all;
tT=[-4:0.01:4]; % нормированное время t/T
beta=[0.1 0.5 1.0];
figure(1); subplot(2,1,1);
for i=1:length(beta)
    for j=1:length(tT)
        ht(j)=trrt(tT(j), beta(i));
    end
    plot(tT,ht,'linewidth',1); hold on;
end
legend('beta=0.1', 'beta=0.5', 'beta=1.0'); grid on;
title('Импульсная характеристика'); xlabel('t/T'); axis('tight');
fT=[-2:0.01:2];
subplot(2,1,2);
for i=1:length(beta)
    for j=1:length(fT)
        hf(j)=frrt(fT(j), beta(i));
    end
    plot(fT,hf,'linewidth',1); hold on;
end
legend('beta=0.1', 'beta=0.5', 'beta=1.0'); grid on;
title('Частотная характеристика'); xlabel('fT'); axis('tight');
% Функция для оценки импульсной характеристики
function ht=trrt(tT, beta)
wt=cos(pi*beta*tT)./(1-(2*beta*tT).^2);
ht=sinc(tT).*wt;
end
% Функция для оценки частотной характеристики
function hf=frrt(fT, beta)
if abs(fT)<(1-beta)/2
    hf=1;
elseif abs(fT)>(1+beta)/2
    hf=0;
else
    hf=0.5*(1+cos(pi/beta.*(abs(fT)-(1-beta)/2)));
end
end