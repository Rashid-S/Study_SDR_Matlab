% передаточная характеристика аналоговой ФАПЧ 2-го порядка
clear all;
w=[0:0.01:3];
wn=1;
d=[0.25 0.5 0.75 1];
for i=1:length(d)
    num=wn^4+4*d(i)^2*wn^2*w.^2;
    den=(wn^2-w.^2).^2+4*d(i)^2*wn^2*w.^2;
    H=sqrt(num./den);
    plot(w,H,'linewidth',2); hold on;
end
grid on; xlabel('\omega'); ylabel('|H(j\omega)|');
legend('\zeta=0.25', '\zeta=0.5', '\zeta=0.75', '\zeta=1.0');
    