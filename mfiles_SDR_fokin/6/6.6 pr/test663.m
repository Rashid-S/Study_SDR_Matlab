figure(1);
subplot(2,1,1); 
plot((1:1:n)*T, Freq10); hold on;
plot((1:1:n)*T, (fq+ferr)*ones(1,length(Freq10)),'linewidth', 2); grid on;
xlabel('�����, �'); ylabel('�������, ��');
legend('���������� ������� �� ������ ���',...
    '������� ������������ ������������',...
    'location', 'southeast');
title('������� ������ 10 ���');

subplot(2,1,2); 
plot((1:1:n)*T, Freq20); hold on;
plot((1:1:n)*T, (fq+ferr)*ones(1,length(Freq20)),'linewidth', 2); grid on;
xlabel('�����, �'); ylabel('�������, ��');
legend('���������� ������� �� ������ ���',...
    '������� ������������ ������������',...
    'location', 'southeast');
title('������� ������ 20 ���');