clear all; clc;
% ������������� ����������
stability=5000;             % ������������ ������� � ppm
ppm=1e-6;                   % ppm
fc=1e8;                     % ��������� ������� 
df=stability*ppm*fc;        % ���� �������
ftx = fc-df;                % ������� ���������� �����������
frx = fc+df;                % ������� ���������� ���������� 
fs = 100*fc;                % ������� �������������
T_max = 1e-7;               % ����� �������������
t = (0:1/fs:(T_max-1/fs))'; % ��������� �����
stx = sin(2*pi*ftx*t);    
srx = sin(2*pi*frx*t); 
% ���������� ������������� 
figure(1); 
plot(t,stx,'b-','LineWidth',1); hold on;
plot(t,srx,'r-','LineWidth',1); grid on; 
title('������������� ������� �������� �����������');
xlabel('����� (�)'); ylabel('���������');
legend('����������', '��������');