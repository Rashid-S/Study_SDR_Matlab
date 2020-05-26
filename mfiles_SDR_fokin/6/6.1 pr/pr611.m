clear all; clc;
% Инициализация параметров
stability=5000;             % стабильность частоты в ppm
ppm=1e-6;                   % ppm
fc=1e8;                     % эталонная частота 
df=stability*ppm*fc;        % уход частоты
ftx = fc-df;                % частота гетеродина передатчика
frx = fc+df;                % частота гетеродина приемниках 
fs = 100*fc;                % частота дискретизации
T_max = 1e-7;               % время моделирования
t = (0:1/fs:(T_max-1/fs))'; % временная шкала
stx = sin(2*pi*ftx*t);    
srx = sin(2*pi*frx*t); 
% построение госциллограмм 
figure(1); 
plot(t,stx,'b-','LineWidth',1); hold on;
plot(t,srx,'r-','LineWidth',1); grid on; 
title('осциллограммы опорных сигналов гетеродинов');
xlabel('время (с)'); ylabel('амплитуда');
legend('передатчик', 'приемник');