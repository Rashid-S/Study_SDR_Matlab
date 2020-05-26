load('test643');
subplot(2,3,1); plot(in1,'k','linewidth',2); grid on; axis('tight');
title('ступенчатое изменение фазы (фазовый сдвиг)');
subplot(2,3,2); plot(in2,'k','linewidth',2); grid on; axis('tight');
title('линейное изменение фазы (частотный сдвиг)');
subplot(2,3,3); plot(in3,'k','linewidth',2); grid on; axis('tight');
title('квадратичное изменение фазы (изменение частотного сдвига)');

subplot(2,3,4); 
plot(out11,'r-','linewidth',2); hold on;
plot(out12,'b-','linewidth',2); hold on;
plot(out13,'g-','linewidth',2); hold on;
plot(out14,'c-','linewidth',2); hold on;
plot(out15,'m-','linewidth',2); hold on;
plot(out16,'k-','linewidth',2); grid on; axis('tight');
legend('\zeta=0.3','\zeta=0.5','\zeta=0.707',...
    '\zeta=1.0','\zeta=2.0','\zeta=3.0');
title('отклик на ступенчатое изменение фазы');


subplot(2,3,5); 
plot(out21,'r-','linewidth',2); hold on;
plot(out22,'b-','linewidth',2); hold on;
plot(out23,'g-','linewidth',2); hold on;
plot(out24,'c-','linewidth',2); hold on;
plot(out25,'m-','linewidth',2); hold on;
plot(out26,'k-','linewidth',2); grid on; axis('tight');
legend('\zeta=0.3','\zeta=0.5','\zeta=0.707',...
    '\zeta=1.0','\zeta=2.0','\zeta=3.0');
title('отклик на линейное изменение фазы');

subplot(2,3,6); 
plot(out31,'r-','linewidth',2); hold on;
plot(out32,'b-','linewidth',2); hold on;
plot(out33,'g-','linewidth',2); hold on;
plot(out34,'c-','linewidth',2); hold on;
plot(out35,'m-','linewidth',2); hold on;
plot(out36,'k-','linewidth',2); grid on; axis('tight');
legend('\zeta=0.3','\zeta=0.5','\zeta=0.707',...
    '\zeta=1.0','\zeta=2.0','\zeta=3.0');
title('отклик на квадратичное изменение фазы');