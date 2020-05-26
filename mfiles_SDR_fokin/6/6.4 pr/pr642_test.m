load('test642');
subplot(2,3,1); plot(in1,'k','linewidth',2); grid on; axis('tight');
title('����������� ��������� ���� (������� �����)');
subplot(2,3,2); plot(in2,'k','linewidth',2); grid on; axis('tight');
title('�������� ��������� ���� (��������� �����)');
subplot(2,3,3); plot(in3,'k','linewidth',2); grid on; axis('tight');
title('������������ ��������� ���� (��������� ���������� ������)');

subplot(2,3,4); 
plot(out11,'r-','linewidth',2); hold on;
plot(out12,'b-.','linewidth',2); hold on;
plot(out13,'g--','linewidth',2); grid on; axis('tight');
legend('��� 1','��� 2','��� 3');
title('������ �� ����������� ��������� ����');

subplot(2,3,5); 
plot(out21,'r-','linewidth',2); hold on;
plot(out22,'b-.','linewidth',2); hold on;
plot(out23,'g--','linewidth',2); grid on; axis('tight');
legend('��� 1','��� 2','��� 3');
title('������ �� �������� ��������� ����');

subplot(2,3,6); 
plot(out31,'r-','linewidth',2); hold on;
plot(out32,'b-.','linewidth',2); hold on;
plot(out33,'g--','linewidth',2); grid on; axis('tight');
legend('��� 1','��� 2','��� 3');
title('������ �� ������������ ��������� ����');
