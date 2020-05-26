% передаточная характеристика аналоговой ФАПЧ 2-го порядка
clear all;
w=[0:0.01:3];
wn=1;
d=0.5;
num=wn^4+4*d^2*wn^2*w.^2;
den=(wn^2-w.^2).^2+4*d^2*wn^2*w.^2;
H1=sqrt(num./den);
H2=num./den;
plot(w,H1,'r-','linewidth',2); hold on;
plot(w,H2,'r--','linewidth',2); grid on;
xlabel('\omega'); ylabel('|H(j\omega)|');
legend('|H(j\omega)|', '|H(j\omega)|^{2}');
    